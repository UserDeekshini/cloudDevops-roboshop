#!/bin/bash

set -e
COMPONENT=user
LOG_FILE="/tmp/$COMPONENT.log"

#user verification 
source components/common.sh

#calling function from common.sh to perfrom complete nodejs installation
NODEJS

echo -e "\e[32m ------------$COMPONENT Configuration is completed  \e[0m"