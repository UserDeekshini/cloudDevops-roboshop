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

NODEJS(){
    echo -n "Configuring nodeJS Repos : "
    curl -sL "https://rpm.nodesource.com/setup_lts.x" | bash &>>$LOG_FILE
    stat $?

    echo -n "Installing nodeJS : "
    yum install nodejs -y  &>>$LOG_FILE
    stat $?

    #calling user creation function 
    CREATE_USER()

    #calling function to download and extract the component files
    DOWNLOAD_AND_EXTRACT()

    #echo -n "Installing  the $COMPONENT : "
    npm install &>> $LOG_FILE
    stat $?
    
    #calling function to configure the component services
    CONFIG_SERVICE()

    #calling function start service
    START_SERVICE()

}

CREATE_USER(){
    echo -n "Creating the roboshop user : "
    id roboshop &>>$LOG_FILE || adduser roboshop &>>$LOG_FILE
    stat $?
}

DOWNLOAD_AND_EXTRACT(){
    echo -n "Downloading the $COMPONENT repo : "
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
    stat $?

    echo -n "Performing cleanup : "
    cd /home/roboshop && rm -rf ${COMPONENT} &>>$LOG_FILE
    stat $?

    echo -n "Extracting the ${COMPONENT} : "
    unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
    mv ${COMPONENT}-main ${COMPONENT} &&    chown -R $APPUSER:$APPUSER $COMPONENT
    cd /home/roboshop/$COMPONENT 
    stat $?
}

CONFIG_SERVICE(){
    echo -n "Updating SystemD file with service name : "
    sed -i -e 's/MONGO_DNSNAME/mongodb.rhobode.iternal/' /home/roboshop/catalogue/systemd.service
    cat /home/$APPUSER/$COMPONENT/systemd.service &>>$LOG_FILE
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?
}

START_SERVICE(){
    echo -n "Starting the $COMPONENT service : "
    systemctl daemon-reload 
    systemctl restart $COMPONENT 
    systemctl enable $COMPONENT &>> $LOG_FILE
    systemctl status $COMPONENT -l &>> $LOG_FILE
    stat $?
}