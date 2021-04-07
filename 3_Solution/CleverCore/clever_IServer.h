#pragma once

#include "clever_inclusions.h"
#include "clever_TSQueue.h"
#include "clever_Message.h"
#include "clever_Connection.h"
#include "clever_DBConnection.h"
#include "clever_Exceptions.h"

namespace clever
{
	template<typename T>
	class server_interface
	{
	public:
		// Create a server, ready to listen on specified port
		server_interface(uint16_t port)
			: m_asioAcceptor(m_asioContext, asio::ip::tcp::endpoint(asio::ip::address::from_string("0.0.0.0"), port))
		{

		}

		virtual ~server_interface()
		{
			// May as well try and tidy up
			Stop();
		}

		// Starts the server!
		bool Start()
		{
			try
			{
				// Issue a task to the asio context - This is important
				// as it will prime the context with "work", and stop it
				// from exiting immediately. Since this is a server, we 
				// want it primed ready to handle clients trying to
				// connect.
				WaitForClientConnection();

				// Launch the asio context in its own thread
				m_threadContext = std::thread([this]() { m_asioContext.run(); });
			}
			catch (std::exception& e)
			{
				// Something prohibited the server from listening
				std::cerr << "[SERVER] Exception: " << e.what() << "\n";
				return false;
			}

			std::cout << "[SERVER] Started!\n";
			return true;
		}

		// Stops the server!
		void Stop()
		{
			// Request the context to close
			m_asioContext.stop();

			// Tidy up the context thread
			if (m_threadContext.joinable()) m_threadContext.join();

			// Inform someone, anybody, if they care...
			std::cout << "[SERVER] Stopped!\n";
		}

		void ConnectToDatabase()
		{
			if (m_dbconnector.OnAttemptToConnect())
			{
				std::cout << "[SERVER] Server is connected successfully to the SQL Server Database!\n";
			}
			else
			{
				throw DatabaseConnectionError("[SERVER] Couldn't connect to SQL Server Database\n");
			}
		}

		std::string GetQueryExecResult(const std::string& query)
		{
			ConnectToDatabase();
			return m_dbconnector.GetResultFromExecuteQuery(query);
		}

		void ExecQuery(const std::string& query)
		{
			/*if (!m_dbconnector.isConnected())
			{*/
			ConnectToDatabase();
			std::cout << "\n[SERVER] Query Result:\n\n\n";
			m_dbconnector.ExecuteQuery(query); // throws Query exception!
			std::cout << "\n";
			//}


			//else
			//{
			//	std::cout << "\n[SERVER] Query Result:\n\n\n";
			//	m_dbconnector.ExecuteQuery(query); // throws int exception!
			//	std::cout << "\n";
			//}

			//if (m_dbconnector.OnAttemptToConnect())
			//{
			//	//SQLCHAR query_res = m_dbconnector.ExecuteQuery(query);
			//	std::cout << "\n[SERVER] Query Result:\n\n\n";
			//	m_dbconnector.ExecuteQuery(query); // throws int exception!
			//	std::cout << "\n";
			//}
			//else
			//{
			//	std::cout << "\n[SERVER] Couldn't connect to database anymore! :\n\n\n";
			//	throw - 1;
			//}
		}


		// ASYNC - Instruct asio to wait for connection
		void WaitForClientConnection()
		{
			// Prime context with an instruction to wait until a socket connects. This
			// is the purpose of an "acceptor" object. It will provide a unique socket
			// for each incoming connection attempt
			m_asioAcceptor.async_accept(
				[this](std::error_code ec, asio::ip::tcp::socket socket)
				{
					// Triggered by incoming connection request
					if (!ec)
					{
						// Display some useful(?) information
						std::cout << "[SERVER] New Connection: " << socket.remote_endpoint() << "\n";

						// Create a new connection to handle this client 
						std::shared_ptr<connection<T>> newconn =
							std::make_shared<connection<T>>(connection<T>::owner::server,
								m_asioContext, std::move(socket), m_qMessagesIn);



						// Give the user server a chance to deny connection
						if (OnClientConnect(newconn))
						{
							// Connection allowed, so add to container of new connections
							m_deqConnections.push_back(std::move(newconn));

							// And very important! Issue a task to the connection's
							// asio context to sit and wait for bytes to arrive!
							m_deqConnections.back()->ConnectToClient(this, nIDCounter++);

							std::cout << "[" << m_deqConnections.back()->GetID() << "] Connection Approved\n";
						}
						else
						{
							std::cout << "[-----] Connection Denied\n";

							// Connection will go out of scope with no pending tasks, so will
							// get destroyed automagically due to the wonder of smart pointers
						}
					}
					else
					{
						// Error has occurred during acceptance
						std::cout << "[SERVER] New Connection Error: " << ec.message() << "\n";
					}

					// Prime the asio context with more work - again simply wait for
					// another connection...
					WaitForClientConnection();
				});
		}

		// Send a message to a specific client
		void MessageClient(std::shared_ptr<connection<T>> client, const message<T>& msg)
		{
			// Check client is legitimate...
			if (client && client->IsConnected())
			{
				// ...and post the message via the connection
				client->Send(msg);
			}
			else
			{
				// If we cant communicate with client then we may as 
				// well remove the client - let the server know, it may
				// be tracking it somehow
				OnClientDisconnect(client);

				// Off you go now, bye bye!
				client.reset();

				// Then physically remove it from the container
				m_deqConnections.erase(
					std::remove(m_deqConnections.begin(), m_deqConnections.end(), client), m_deqConnections.end());
			}
		}

		// Send message to all clients
		void MessageAllClients(const message<T>& msg, std::shared_ptr<connection<T>> pIgnoreClient = nullptr)
		{
			bool bInvalidClientExists = false;

			// Iterate through all clients in container
			for (auto& client : m_deqConnections)
			{
				// Check client is connected...
				if (client && client->IsConnected())
				{
					// ..it is!
					if (client != pIgnoreClient)
						client->Send(msg);
				}
				else
				{
					// The client couldnt be contacted, so assume it has
					// disconnected.
					OnClientDisconnect(client);
					client.reset();

					// Set this flag to then remove dead clients from container
					bInvalidClientExists = true;
				}
			}

			// Remove dead clients, all in one go - this way, we dont invalidate the
			// container as we iterated through it.
			if (bInvalidClientExists)
				m_deqConnections.erase(
					std::remove(m_deqConnections.begin(), m_deqConnections.end(), nullptr), m_deqConnections.end());
		}

		// Force server to respond to incoming messages
		void Update(size_t nMaxMessages = -1, bool bWait = false)
		{
			if (bWait) m_qMessagesIn.wait();

			// Process as many messages as you can up to the value
			// specified
			size_t nMessageCount = 0;
			while (nMessageCount < nMaxMessages && !m_qMessagesIn.empty())
			{
				// Grab the front message
				auto msg = m_qMessagesIn.pop_front();

				// Pass to message handler
				OnMessage(msg.remote, msg.msg);

				nMessageCount++;
			}
		}

	public:
		// called when a client is validated

		virtual void OnClientValidated(std::shared_ptr<connection<T>> client)
		{

		}

	protected:
		// This server class should override thse functions to implement
		// customised functionality

		// Called when a client connects, you can veto the connection by returning false
		virtual bool OnClientConnect(std::shared_ptr<connection<T>> client)
		{
			return false;
		}

		// Called when a client appears to have disconnected
		virtual void OnClientDisconnect(std::shared_ptr<connection<T>> client)
		{

		}

		// Called when a message arrives
		virtual void OnMessage(std::shared_ptr<connection<T>> client, message<T>& msg)
		{

		}
		void OnLoginUserPAT(char PAT[])
		{
			// TO DO.
			throw InvalidPATLoginError("PAT is invalid, we couldn't get any user with this PAT. Try to login again!");
		}
		void OnRememberUserLoggedIn(char username[], char PAT[])
		{
			// first get the ID of user that is registered with this username
			std::string l_username = convertToSqlVarcharFormat(username);
			std::string query = "SELECT UserID FROM CleverPocket.dbo.Users WHERE Username = " + l_username;
			std::string resultID = GetQueryExecResult(query);
			if (resultID == "")
			{
				throw UsernameInvalidLoginError("Username is not valid! No user registered with this credential!");
			}
			else
			{
				// then go insert into Sessions userID and PAT.
				char resultIDChar[1024]; strcpy(resultIDChar, resultID.c_str());
				resultID = convertToSqlVarcharFormat(resultIDChar);
				std::string l_PAT = convertToSqlVarcharFormat(PAT);

				query = "INSERT INTO [CleverPocket].[dbo].[Sessions] (UserID, PAT) VALUES ( " + resultID + ", " + l_PAT+")";
				ExecQuery(query);
			}
		}
		void OnLoginUserToServer(char username[], char password[])
		{
			std::string l_username = convertToSqlVarcharFormat(username);
			std::string query = "IF EXISTS(SELECT 1 FROM CleverPocket.dbo.Users WHERE Username = " + l_username + ") " + "SELECT 1 ELSE SELECT 0";
			std::string result = GetQueryExecResult(query);
			if (result == "0")
			{
				throw UsernameInvalidLoginError("Username is not valid! No user registered with this credential!");
			}

			std::string l_password = convertToSqlVarcharFormat(password);
			query = "IF EXISTS(SELECT 1 FROM CleverPocket.dbo.Users WHERE Password = " + l_password + ") " + "SELECT 1 ELSE SELECT 0";
			result = GetQueryExecResult(query);
			if (result == "0")
			{
				throw PasswordInvalidLoginError("Password is incorrect for this user!");
			}
		}

		void RegisterUserToDatabase(char username[], char password[], char email[])
		{
			// build query with those credentials.
			if (!checkEmailFormat(email))
			{
				throw EmailValidationError("Email Validation Failed. Format is not good!");
			}

			if (checkUserAlreadyRegistered(username, email))
			{
				throw UserAlreadyRegisteredError("A user with this username is already registered to the database!");
			}
			std::string l_username = convertToSqlVarcharFormat(username);
			std::string l_password = convertToSqlVarcharFormat(password);
			std::string l_email = convertToSqlVarcharFormat(email);
			std::string query = "INSERT INTO [CleverPocket].[dbo].[Users] (Username, Password, Email) VALUES ( " + l_username + ", " + l_password + ", " + l_email + ")";
			//std::string query = "SELECT * FROM [CleverPocket].[dbo].[Users]";
			// exec query
			ExecQuery(query);
		}

	private:
		std::string convertToSqlVarcharFormat(char field[])
		{
			std::string str;
			str = "'";
			str += field;
			str += "'";
			return str;
		}
		bool checkUserAlreadyRegistered(char username[], char email[])
		{
			// first check if the username is already there.
			std::string l_username = convertToSqlVarcharFormat(username);
			std::string query = "IF EXISTS(SELECT 1 FROM CleverPocket.dbo.Users WHERE Username = " + l_username + ") " + "SELECT 1 ELSE SELECT 0";
			std::string result = GetQueryExecResult(query);
			if (result == "1")
			{
				return true;
			}

			// then check if email is already there.
			std::string l_email = convertToSqlVarcharFormat(email);
			query = "IF EXISTS(SELECT 1 FROM CleverPocket.dbo.Users WHERE Email = " + l_email + ") " + "SELECT 1 ELSE SELECT 0";
			result = GetQueryExecResult(query);
			if (result == "1")
			{
				return true;
			}

			return false;
		}
		bool checkEmailFormat(char email[])
		{
			std::string str_email = email;
			// handle REGEX.
			const std::regex pattern("(\\w+)(\\.|_)?(\\w*)@(\\w+)(\\.(\\w+))+");
			return std::regex_match(str_email, pattern);
		}
	protected:
		// Thread Safe Queue for incoming message packets
		tsqueue<owned_message<T>> m_qMessagesIn;

		// Container of active validated connections
		std::deque<std::shared_ptr<connection<T>>> m_deqConnections;

		// Order of declaration is important - it is also the order of initialisation
		asio::io_context m_asioContext;
		std::thread m_threadContext;

		// These things need an asio context
		asio::ip::tcp::acceptor m_asioAcceptor; // Handles new incoming connection attempts...

		// Clients will be identified in the "wider system" via an ID
		uint32_t nIDCounter = 10000;

		// dbconnection class.
		dbconnection<T> m_dbconnector;
	};
}