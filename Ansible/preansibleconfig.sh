#!/bin/bash 
 # In order to deploy this, use the command below!
 # Command: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/WarpWing/Trident/main/Ansible/preansibleconfig.sh)"
clear 
echo Deploying Pre Flight Provisions!
sleep 2s
cd .ssh
echo Beginning SSH Key Deployment
sudo rm authorized_keys 
wget -q https://raw.githubusercontent.com/WarpWing/Trident/main/Ansible/authorized_keys
cd ..
echo Pre Flight Provisions have been deployed! Happy VMing.






