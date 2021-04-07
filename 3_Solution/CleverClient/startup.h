#pragma once
//#include "client_backend.h"
#include <QtWidgets/QMainWindow>
#include "ui_startup.h"
#include <qstackedwidget.h>
#include <QtGui>
#include "dashboard.h"


class Startup : public QWidget
{
	Q_OBJECT

public:
	Startup(QWidget *parent = Q_NULLPTR);
	~Startup();
private:
	Ui::Startup ui;
	void resizeToLoginPage();
	void resizeToRegisterPage();
	void resizeToForgotPasswordPage();
	void resizeToTermsAndConditionsPage();
	void clearGaps();
	Dashboard* m_dshptr;

private slots:
	void on_registerLinkButton_clicked();
	void on_alreadyRegisteredLinkButton_clicked();
	void on_registerPushButton_clicked();
	void on_loginPushButton_clicked();
	void on_forgotPasswordLinkButton_clicked();
	void on_termsAndConditionsLinkButton_clicked();
	void on_backToRegisterLinkButton_clicked();
	void on_backToLoginLinkButton_clicked();
	void on_registerNowLinkButton_clicked();
};
