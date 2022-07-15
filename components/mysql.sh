#!/bin/bash

COMPONENT=mysql
LOG_FILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

#user validation 
source components/common.sh

echo -n "Configuring $COMPONENT Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing $COMPONENT"
yum install mysql-community-server -y &>>$LOG_FILE
stat $?

echo -n "Starting the $COMPONENT"
systemctl enable mysqld &>>$LOG_FILE && systemctl start mysqld &>>$LOG_FILE
systemctl status mysqld &>>$LOG_FILE
stat $?

# Mysql root user password has to be changed only once during the login in, if it is run twice error msg will be thrown
# so using if condition to validate
echo "show databases" | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ 0 -ne $? ]; then
    echo -n "Changing the Default $COMPONENT username and password : "
    echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');"  > /tmp/rootpassword_change.sql
    DEFAULT_MYSQLROOT_PASSWORD=$(sudo grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
    mysql --connect-expired-password -uroot -p"$DEFAULT_MYSQLROOT_PASSWORD"  < /tmp/rootpassword_change.sql
    stat $?
fi

# uninstall plugin validate_password only once 
echo "show plugins" | mysql -uroot -pRoboShop@1 | grep "validate_password"  &>>$LOG_FILE 
if [ 0 -eq $? ]; then
    echo -n "Uninstalling $COMPONENT validate_password pluggin : "
    echo "uninstall plugin validate_password;" > /tmp/password_validate.sql
    mysql --connect-expired-password -uroot -pRoboShop@1  < /tmp/password_validate.sql 
    stat $?
fi

echo -n "Downloading the $COMPONENT schema :"
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
stat $?

echo -n "Extracting the schema : "
cd /tmp
unzip -o $COMPONENT.zip &>>$LOG_FILE
stat $?

echo -n "Injecting the schema : "
cd $COMPONENT-main
mysql -u root -pRoboShop@1 <shipping.sql &>>$LOG_FILE
stat $?


