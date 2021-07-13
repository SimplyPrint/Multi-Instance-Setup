#!/bin/sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose

#Get 4 printer configuration
curl https://raw.githubusercontent.com/math045b/simplyprint_multi_instance/main/docker-compose.yaml?token=AO6ZQMSJ42NDDQRIQEPJSOTA5VNFA -o docker-compose.yaml
docker-compose up
