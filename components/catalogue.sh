#!/bin/bash

set -e
COMPONENT=catalogue
LOG_FILE="/tmp/$COMPONENT.log"
NODE_SOURCE="https://rpm.nodesource.com/setup_lts.x"
APPUSER="roboshop"

#user validation 
source components/common.sh

echo -n "Installing nodeJS"
curl -sL $NODE_SOURCE | bash &>>$LOG_FILE
yum install nodejs -y  &>>$LOG_FILE
stat $?


echo -n "Creating the roboshop user : "
id roboshop &>>$LOG_FILE || adduser roboshop &>>$LOG_FILE
stat $?


echo -n "Downloading the $COMPONENT repo : "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Performing cleanup : "
cd /home/roboshop && rm -rf ${COMPONENT} &>>$LOG_FILE
stat $?

echo -n "Extracting the ${COMPONENT} : "
unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
mv ${COMPONENT}-main ${COMPONENT} &&    chown -R $APPUSER:$APPUSER $COMPONENT
cd /home/roboshop/$COMPONENT 
stat $?

echo -n "Installing  the $COMPONENT"
npm install &>> $LOG_FILE
stat $?


echo -n "Updating SystemD file with service name : "
sed -i -e 's/MONGO_DNSNAME/mongodb.rhobode.iternal/' /home/roboshop/catalogue/systemd.service
cat /home/$APPUSER/$COMPONENT/systemd.service &>>$LOG_FILE
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "Starting the $COMPONENT : "
systemctl daemon-reload &>> $LOG_FILE
systemctl restart $COMPONENT &>> $LOG_FILE
systemctl enable $COMPONENT &>> $LOG_FILE
systemctl status $COMPONENT -l &>> $LOG_FILE

#Now, you would still see **`CATEGORIES`** on the frontend page as empty. 
#That’s because your `frontend` doesn't know who the `CATALOGUE` is when someone clicks the `CATEGORIES` option. So, we need to update the Nginx Reverse Proxy on the frontend. If not, you’d still see the frontend without categories.
#In order to make it work, update the proxy file in Nginx with the `CATALOGUE` server IP Address in the **`FRONTEND`** Server  
#**`Note:`** Do not do a copy and paster of IP in the proxy file, there are high chances to enter the empty space characters, which are not visible on the vim editor. Manual Typing of IP Address/ DNS Name is preferred. 
# vim /etc/nginx/default.d/roboshop.conf
#1. Reload and restart the Nginx service.
# systemctl restart nginx
