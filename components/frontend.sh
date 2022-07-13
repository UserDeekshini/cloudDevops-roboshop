#!/bin/bash

#The frontend is the service in RobotShop to serve the web content over Nginx.

set -e

source components/common.sh

COMPONENT=frontend
LOG_FILE="/temp/$COMPONENT.log"
#user validation 
USER_VALIDATION

echo "Installing Nginx : "
yum install nginx -y  &>> $LOG_FILE

if [$? -eq 0] ; then
    echo -e "\e[32m SUCCESS \e[0m"
else
    echo -e "\e[32m FAILURE \e[0m"
    
#systemctl enable nginx
#systemctl start nginx
#curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
#Deploy in Nginx Default Location.
# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
