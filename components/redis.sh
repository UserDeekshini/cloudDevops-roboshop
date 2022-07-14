#!/bin/bash

set -e
COMPONENT=redis
LOG_FILE="/tmp/$COMPONENT/log"

# user validation
source components/common.sh

echo -e "Installing Redis : "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
yum install redis-6.2.7 -y  &>> $LOG_FILE
stat $?

echo -n "Updating $COMPONENT Listening address : "
sed -i -e "s/127.0.0.1/0.0.0.0/"  /etc/redis.conf
sed -i -e "s/127.0.0.1/0.0.0.0/"  /etc/redis/redis.conf
cat /etc/redis/redis.conf &>> $LOG_FILE
stat $?
