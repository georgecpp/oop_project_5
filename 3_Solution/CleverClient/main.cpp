#include "Client.h"
#include "stdafx.h"
#include <QtWidgets/QApplication>
#include "startup.h"

int main(int argc, char* argv[])
{
    QApplication a(argc, argv);
    Client& c = Client::getInstance(); // va conecta clientul la server.    
    Startup st;
    st.show();
    return a.exec();
}