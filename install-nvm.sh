#!/bin/bash

NODE_VERSION=9.11.2
NVM_VERSION=0.33.11

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update -y
sudo apt-get install -y build-essential libssl-dev yarn

curl -sL https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh -o install_nvm.sh

bash install_nvm.sh

echo 'export NVM_DIR="$HOME/.nvm"' >> .bashrc.tmp
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> .bashrc.tmp
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> .bashrc.tmp
cat .bachrc >> .bachrc.tmp
mv .bashrc .bashrc.old 
mv .bashrc.tmp .bashrc

source ~/.bashrc

nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default
