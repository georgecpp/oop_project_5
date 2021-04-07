#pragma once
#include <clever_core.h>

class Client : public clever::client_interface<clever::MessageType>
{
private:
	static Client* instance;
	std::string ip_address_to;
	int port_to;
	Client() {};
	Client(const Client& src) = delete;
	~Client() {};

	void setIpPortTo();

public:
	static Client& getInstance();
	static void destroyInstance();
	static std::string generatePAT();

	void PingServer();
	void MessageAll();
	void Register(const std::string& username, const std::string& password, const std::string& email);
	void LoginUser(const std::string& username, const std::string& password);
	void LoginUserRemembered(const std::string& PAT);
	void RememberMe(const std::string& PAT, const std::string& username);

public:
	std::string getIpAddressTo();
	int getPortTo();
};