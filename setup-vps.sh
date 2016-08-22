#!/bin/bash

USER="web"
SSH_PORT="22123"

# Create user
sudo adduser $USER --gecos "$USER,0,0,0" --disabled-password

# Add to root
gpasswd -a $USER sudo

# Copy ssh folder
cp -r /root/.ssh/ /home/$USER/.ssh

# Change permissions on .ssh folder
chown -R $USER:$USER /home/$USER/.ssh

# Do root command without password
echo "$USER     ALL=(ALL) NOPASSWD:ALL" | sudo tee --append /etc/sudoers

# ssh config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/Port 22/Port '$SSH_PORT'/g' /etc/ssh/sshd_config

# Restart ssh
service ssh restart
