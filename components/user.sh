#!/bin/bash

set -e
COMPONENT=user
LOG_FILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

#user verification 
source components/common.sh

#calling function from common.sh to perfrom complete nodejs installation
NODEJS

echo -e "\e[32m ------------$COMPONENT Configuration is completed  \e[0m"


# Update the USER Component IP Address in the Frontend Server( Nginx Reverse Proxy ) 
# # vim /etc/nginx/default.d/roboshop.conf
# Once the USER IP Address is added, restart the service
# # systemctl daemon-reload
# # systemctl restart nginx