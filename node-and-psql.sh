#!/bin/bash

NODE_VERSION=8.10
DB_NAME="db_name"
DB_USER="db_user"
DB_PASSWORD="db_password"

echo "Installning nvm & node $NODE_VERSION"
sudo apt-get update
sudo apt-get -y install build-essential libssl-dev

curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh -o install_nvm.sh
bash install_nvm.sh
source ~/.profile
source ~/.bashrc

nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default

echo "Installning DB"

sudo apt-get -y install postgresql postgresql-contrib

echo "sudo -i -u postgres psql"

echo ""

echo "CREATE DATABASE $DB_NAME;"
echo "CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASSWORD';"
echo "GRANT CONNECT ON DATABASE $DB_NAME to $DB_USER;"
echo "GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;"
echo "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $DB_USER;"

echo ""

echo "Change postgres settings here"
echo "vim /etc/postgresql/9.5/main/postgresql.conf"

echo ""

echo "Dont forget to move NVM to the top in /home/web/.bashrc"
