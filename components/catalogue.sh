#!/bin/bash

set -e
COMPONENT=catalogue
LOG_FILE="/tmp/$COMPONENT.log"
NODE_SOURCE="https://rpm.nodesource.com/setup_lts.x"

#User Validation
source /components/common.sh

echo -n "Installing nodeJS"
curl -sL $NODE_SOURCE | bash
yum install nodejs -y  &>>$LOG_FILE
stat $?


echo -n "Creating the roboshop user : "
id roboshop &>>$LOG_FILE || adduser roboshop &>>$LOG_FILE
stat $?


echo -n "Downloading the $COMPONENT repo : "
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
cd /home/roboshop
stat $?

echo -n "Unzip $COMPONENT : "
unzip -o /tmp/$COMPONENT.zip


mv $COMPONENT-main $COMPONENT
cd /home/roboshop/$COMPONENT
npm install & >>$LOG_FILE
stat $?

echo -n "Updating SystemD file with correct IP addresses : "
sed -i -e 's/MONGO_DNSNAME/catalogue.rhobode.iternal' /home/roboshop/catalogue/systemd.service
cat /home/roboshop/catalogue/systemd.service &>>$LOG_FILE
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
stat $?

echo -n "Starting the $COMPONENT : "
systemctl daemon-reload
systemctl start $COMPONENT
systemctl enable $COMPONENT
systemctl status $COMPONENT -l


Ref Log:
{"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}

#Now, you would still see **`CATEGORIES`** on the frontend page as empty. 
#That’s because your `frontend` doesn't know who the `CATALOGUE` is when someone clicks the `CATEGORIES` option. So, we need to update the Nginx Reverse Proxy on the frontend. If not, you’d still see the frontend without categories.

#In order to make it work, update the proxy file in Nginx with the `CATALOGUE` server IP Address in the **`FRONTEND`** Server  

**`Note:`** Do not do a copy and paster of IP in the proxy file, there are high chances to enter the empty space characters, which are not visible on the vim editor. Manual Typing of IP Address/ DNS Name is preferred. 
# vim /etc/nginx/default.d/roboshop.conf

#1. Reload and restart the Nginx service.

# systemctl restart nginx
