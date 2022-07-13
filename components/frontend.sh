#!/bin/bash

#The frontend is the service in RobotShop to serve the web content over Nginx.

set -e 

#user validation 
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31m you need to be a root user to run it!!! \e[0m"
    exit 1
fi


#Installing Nginx.

#yum install nginx -y
#systemctl enable nginx
#systemctl start nginx
# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
#Deploy in Nginx Default Location.
# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
