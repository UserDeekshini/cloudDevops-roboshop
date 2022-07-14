#!/bin/bash

set -e
COMPONENT=catalogue
LOG_FILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

#user validation 
source components/common.sh

#calling function from common.sh 
NODEJS

echo -e "\e[32m ------------$COMPONENT Configuration is completed-----------  \e[0m"

#In order to make it work, update the proxy file in Nginx with the `CATALOGUE` server IP Address in the **`FRONTEND`** Server  
#**`Note:`** Do not do a copy and paster of IP in the proxy file, there are high chances to enter the empty space characters, which are not visible on the vim editor. Manual Typing of IP Address/ DNS Name is preferred. 
# vim /etc/nginx/default.d/roboshop.conf
#1. Reload and restart the Nginx service.
# systemctl restart nginx
