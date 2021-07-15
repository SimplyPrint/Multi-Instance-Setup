#!/bin/bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker pi
apt-get install libffi-dev libssl-dev
apt install python3-dev
apt-get install -y python3 python3-pip
pip3 install docker-compose

curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/b1cf1385da6e26231a11be2238c6a004fb1046ee/check_devices.sh -o check_devices.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/b1cf1385da6e26231a11be2238c6a004fb1046ee/functions.sh -o functions.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/b1cf1385da6e26231a11be2238c6a004fb1046ee/generate_yaml.sh -o generate_yaml.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/b1cf1385da6e26231a11be2238c6a004fb1046ee/get_device_id.sh -o get_device_id.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/b1cf1385da6e26231a11be2238c6a004fb1046ee/instance_setup.sh -o instance_setup.sh

bash instance_setup.sh