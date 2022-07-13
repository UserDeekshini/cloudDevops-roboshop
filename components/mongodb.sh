#!/bin/bash

set -e
COMPONENT=mongodb
LOG_FILE="/tmp/$COMPONENT.log"
MONGODB_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"

#user validation 
source components/common.sh

echo -n "Downoading the $COMPONENT repos : "
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGODB_REPO_URL 
stat $?

echo -n "Installing $COMPONENT repos : "
yum install -y mongodb-org &>> $LOG_FILE
stat $?

echo -n "Enabling  the $COMPONENT : "
systemctl enable mongod &>> $LOG_FILE
stat $?

echo -n "Starting  the $COMPONENT : "
systemctl start mongod &>> $LOG_FILE
stat $?

#Update Listen IP address from 127.0.0.1 to 0.0.0.0 in the config file, so that MongoDB can be accessed by other services.
echo -n "Updating $COMPONENT Listening address : "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
cat /etc/mongod.conf &>> $LOG_FILE
stat $?


echo -n "Restarting  the $COMPONENT : "
systemctl restart mongod
systemctl status mongod  &>> $LOG_FILE

echo -n "Downloading the $COMPONENT Schema :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting the $COMPONENT Schema : 
cd /tmp
unzip $COMPONENT.zip &>> $LOG_FILE

echo -n "Injecting/Loading the $COMPONENT Schema : "
cd $COMPONENT-main
mongo < catalogue.js &>> $LOG_FILE
mongo < users.js  &>> $LOG_FILE
stat $?