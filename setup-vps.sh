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

# Create a SSH key
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

# Confirm you have no swap
sudo swapon -s
 
# Allocate 4GB (or more if you wish) in /swapfile
sudo fallocate -l 4G /swapfile
 
# Make it secure
sudo chmod 600 /swapfile
ls -lh /swapfile
 
# Activate it
sudo mkswap /swapfile
sudo swapon /swapfile
 
# Confirm again there's indeed more memory now
free -m
sudo swapon -s
 
# Configure fstab to use swap when instance restart
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

# Change swappiness to 10, so that swap is used only when 10% RAM is unused
# The default is too high at 60
echo 10 | sudo tee /proc/sys/vm/swappiness
echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
