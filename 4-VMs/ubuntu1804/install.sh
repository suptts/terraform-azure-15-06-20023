#!/bin/bash

sudo apt-get update

sudo apt install chrony curl docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker 
sudo systemctl status docker
sudo apt install docker-compose -y

sudo usermod -aG docker ${USER}

echo "Chrony installation DONE"
echo "===================================="
echo "server gitlabtpitits.southeastasia.cloudapp.azure.com prefer" >> /etc/chrony/chrony.conf
sudo systemctl restart chrony.service
sudo timedatectl set-timezone "Asia/Bangkok"
sudo apt install -y doc
echo | date
