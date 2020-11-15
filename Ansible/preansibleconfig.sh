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
ipn=$(hostname -I | awk '{print $1}') 
hostn=$(hostname)
echo Please use the following command to register this VM into Ansible 
echo $hostn ansible_user=ubuntu ansible_port=22 ansible_host=$ipn
echo Pre Flight Provisions have been deployed! Happy VMing.






