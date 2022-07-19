#!/bin/bash

#The frontend is the service in RobotShop to serve the web content over Nginx.

set -e
COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"

#user validation 
source components/common.sh

echo -n "Installing Nginx : "
yum install nginx -y  &>>  $LOGFILE
stat $?

echo -n "Enabling Nginx : "
systemctl enable nginx  &>>$LOGFILE
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

echo -n "Updating the DNS Name in the Nginx Reverse Proxy File:  "
sed -i -e "/catalogue/s/localhost/catalogue.rhobode.iternal/" -e "/user/s/localhost/user.rhobode.iternal/" -e "/cart/s/localhost/cart.rhobode.iternal/" -e "/shipping/s/localhost/shipping.rhobode.iternal/" -e "/payment/s/localhost/payment.rhobode.iternal/" /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Strating Nginx : "
systemctl restart nginx &>>  $LOGFILE
systemctl status nginx &>>  $LOGFILE
stat $?

echo -e "\e[32m ------------$COMPONENT Configuration is completed------------------  \e[0m"