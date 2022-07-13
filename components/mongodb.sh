#!/bin/bash

set -e
COMPONENT=cart
LOG_FILE="/tmp/$COMPONENT.log"
MONGODB_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"

#user validation 
source components/common.sh

echo -n "Downoading the MongoDB repos : "
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGODB_REPO_URL 
stat $?

echo -n "Installing MongoDB repos : "
yum install -y mongodb-org &>> $LOG_FILE
stat $?

echo -n "Enabling  the MongoDB : "
systemctl enable mongod &>> $LOG_FILE
stat $?

echo -n "Starting  the MongoDB : "
systemctl start mongod &>> $LOG_FILE
stat $?

#Update Listen IP address from 127.0.0.1 to 0.0.0.0 in the config file, so that MongoDB can be accessed by other services.
echo -n "Starting  the MongoDB : "
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf
cat /etc/mongod.conf &>> $LOG_FILE
stat $?


echo -n "Restarting  the MongoDB : "
systemctl restart mongod
systemctl status mongod  &>> $LOG_FILE

echo -n "Downloading the MongoDB Schema :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Injecting the Schema : "
cd /tmp
unzip $COMPONENT.zip &>> $LOG_FILE
cd $COMPONENT-main
mongo < catalogue.js &>> $LOG_FILE
mongo < users.js  &>> $LOG_FILE
stat $?