#!/bin/bash

set -e
COMPONENT=cart
LOG_FILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

#user validation
source components/common.sh

#calling function from the common.sh file for installing and configuring nodejs
NODEJS

# Update the CART IP Address / CART DNS Name in the Nginx Reverse Proxy File ( on Frontend )
# On Frontend Server,

# # vim /etc/nginx/default.d/roboshop.conf
# # systemctl restart nginx 


echo -e "\e[32m ------------$COMPONENT Configuration is completed-----------  \e[0m"