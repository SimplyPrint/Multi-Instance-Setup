#!/bin/sh
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker pi
apt-get install libffi-dev libssl-dev
apt install python3-dev
apt-get install -y python3 python3-pip
pip3 install docker-compose

curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/docker-compose.yaml -o docker-compose.yaml
docker-compose up