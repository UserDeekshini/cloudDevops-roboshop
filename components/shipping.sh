#!/bin/bash

set -e
COMPONENT=catalogue
LOG_FILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

#user validation 
source components/common.sh


#calling the function from common.sh
INSTALL_MAVEN

