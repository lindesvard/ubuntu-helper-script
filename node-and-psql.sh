#!/bin/bash

NODE_VERSION=8.10

echo "Installning nvm & node $NODE_VERSION"
sudo apt-get update
sudo apt-get -y install build-essential libssl-dev

curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh -o install_nvm.sh
bash install_nvm.sh
source ~/.profile
nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default $NODE_VERSION

echo "Installning DB"

sudo apt-get -y install postgresql postgresql-contrib

echo "sudo -i -u postgres psql"

echo ""

echo "CREATE DATABASE __DB__;"
echo "CREATE USER __USER__ WITH ENCRYPTED PASSWORD '__PASSWORD__';"
echo "GRANT CONNECT ON DATABASE __DB__ to __USER__;"
echo "GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO __USER__;"
echo "GRANT SELECT ON ALL TABLES IN SCHEMA public TO __USER__;"

echo ""

echo "Change postgres settings here"
echo "vim /etc/postgresql/9.5/main/postgresql.conf"
