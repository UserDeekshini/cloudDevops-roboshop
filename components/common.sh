#!/bin/bash

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31m you need to be a root user to install software!!! \e[0m"
    exit 1
fi


stat()
{
if [ $1 -eq 0 ] ;  then
    echo -e "\e[32m SUCCESS \e[0m"
else
    echo -e "\e[32m FAILURE \e[0m"  
fi
}

START(){
systemctl daemon-reload 
systemctl restart $COMPONENT 
systemctl enable $COMPONENT 
systemctl status $COMPONENT -l 
stat $?
}