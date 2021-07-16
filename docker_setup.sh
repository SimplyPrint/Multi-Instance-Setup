#!/bin/bash
yes | apt-get update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
usermod -aG docker pi
apt-get install libffi-dev libssl-dev
apt install python3-dev
apt-get install -y python3 python3-pip
pip3 install docker-compose

curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/check_devices.sh -o check_devices.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/functions.sh -o functions.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/generate_yaml.sh -o generate_yaml.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/get_device_id.sh -o get_device_id.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/instance_setup.sh -o instance_setup.sh

sudo -u pi bash instance_setup.sh
