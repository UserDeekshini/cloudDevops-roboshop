#!/bin/bash

set -e
COMPONENT=payment
LOG_FILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

#user validation 
source components/common.sh

echo -e "\e[32m ------------$COMPONENT Configuration is completed-----------  \e[0m"