#!/bin/bash

set -e
COMPONENT=mysql
LOG_FILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

#user validation 
source components/common.sh

echo -n "Configuring $COMPONENT Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing $COMPONENT"
yum install mysql-community-server -y &>>$LOG_FILE
stat $?

echo -n "Starting the $component"
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
stat $?


echo -n "Changing the Default $COMPONENT username and password : "
echo "show databases" | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ 0 -ne $? ]; then
    echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');"  > /tmp/rootpassword_change.sql
    DEFAULT_MYSQLROOT_PASSWORD=$(sudo grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
    mysql --connect-expired-password -uroot -p"$DEFAULT_MYSQLROOT_PASSWORD"  < /tmp/rootpassword_change.sql
fi

stat $?
# 1. Next, We need to change the default root password in order to start using the database service. Use password as `RoboShop@1` . Rest of the options you can choose `No`


# # mysql_secure_installation


# 1. You can check whether the new password is working or not using the following command in MySQL

# First let's connect to MySQL

# ```bash
# # mysql -uroot -pRoboShop@1
# ```

# Once after login to MySQL prompt then run this SQL Command. This will uninstall the password validation feature like number of characters, password length, complexty and all. As I don’t want that I’d be uninstalling the `validate_password` plugin

# ```sql
# > uninstall plugin validate_password;
# ```

# ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/584e54a9-29fa-4246-9655-e5666a18119b/Untitled.png)

# ## **Setup Needed for Application.**

# As per the architecture diagram, MySQL is needed by

# - Shipping Service

# So we need to load that schema into the database, So those applications will detect them and run accordingly.

# To download schema, Use the following command

# ```bash
# # curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
# ```

# Load the schema for mysql. This file contains the list of COUNTRIES, CITIES and their PINCODES. This will be helpful in doing the shipping charges calculation which is based on the distance the product is shippied

# ```bash
# # cd /tmp
# # unzip mysql.zip
# # cd mysql-main
# # mysql -u root -pRoboShop@1 <shipping.sql
# ```

# ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/92634964-7621-49c9-ace2-fc8e47073237/Untitled.png)