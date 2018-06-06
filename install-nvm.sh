#!/bin/bash

NODE_VERSION=8.10
NVM_VERSION=0.33.11

sudo apt-get update -y
sudo apt-get install -y build-essential libssl-dev

curl -sL https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh -o install_nvm.sh

bash install_nvm.sh

echo "export NVM_DIR=\"\$HOME/.nvm\"\n[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm\n[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion\nexport NODE_ENV=production\n\n" | cat - .bashrc > .temp.bachrc && mv .temp.bachrc .bashrc

source ~/.bashrc

nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default
