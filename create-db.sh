#!/bin/bash

MYSQL_USER="root"
MYSQL_PASSWORD="root"

DATABASE=$1
USER=$2
PASSWORD=$3

if [ "$DATABASE" = "" ]; then
	echo "Missing database name as first argument"
	exit
fi

echo "Creating Database"

mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE $DATABASE;"

if [ "$USER" != "" ]; then
	echo "Creating user for $DATABASE and flush privileges"

	mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "\
	CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASSWORD'; \
	GRANT ALL PRIVILEGES ON $DATABASE . * TO '$USER'@'localhost'; \
	FLUSH PRIVILEGES; \
	"
fi
