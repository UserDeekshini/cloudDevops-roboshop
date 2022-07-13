#!/bin/bash

#The frontend is the service in RobotShop to serve the web content over Nginx.

set -e
COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"
source components/common.sh

stat()
{
if [ $1 -eq 0 ] ;  then
    echo -e "\e[32m SUCCESS \e[0m"
else
    echo -e "\e[32m FAILURE \e[0m"  
fi
}
#user validation 
USER_VALIDATION

echo -n "Installing Nginx : "
yum install nginx -y  &>>  $LOGFILE
stat $?

echo -n "Enabling Nginx : "
systemctl enable nginx  &>>$LOGFILE
stat $?

echo -n "Strating Nginx : "
systemctl restart nginx &>>  $LOGFILE
systemctl status nginx &>>  $LOGFILE
stat $?



echo -n "Downloading $COMPONENT : "
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" 
stat $?


echo -n "Clearing contents from Nginx default location : "
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n "Extracting the $COMPONENT contents: "
unzip /tmp/$COMPONENT.zip &>>$LOGFILE
stat $?

echo -n "Updating the proxy file : "
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?