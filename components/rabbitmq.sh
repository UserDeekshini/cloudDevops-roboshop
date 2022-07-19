#!/bin/bash

set -e
COMPONENT=rabbitmq
LOG_FILE="/tmp/$COMPONENT.log"

#user validation 
source components/common.sh

echo -n "Installing dependency for $COMPONENT : "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  
stat $?

echo -n "Setingup YUM repositories for $COMPONENT : "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash 
stat $?

echo -n "Installing $COMPONENT : "
yum install rabbitmq-server -y &>> $LOG_FILE
stat $?

echo -n "Starting $COMPONENT:  "
systemctl enable rabbitmq-server 
systemctl restart rabbitmq-server &>> $LOG_FILE
systemctl status rabbitmq-server -l &>> $LOG_FILE

stat $?

echo -n "Creating application user for $COMPONENT : "
rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
rabbitmqctl set_user_tags roboshop administrator &>> $LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
stat $?

echo -e "\e[32m ------------$COMPONENT Configuration is completed-----------  \e[0m"