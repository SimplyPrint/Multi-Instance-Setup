#!/bin/bash
yes | apt-get update
sudo -u pi curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker pi
apt-get install libffi-dev libssl-dev
yes | apt install python3-dev
apt-get install -y python3 python3-pip
pip3 install docker-compose

sudo -u pi curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/check_devices.sh -o check_devices.sh
sudo -u pi curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/functions.sh -o functions.sh
sudo -u pi curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/generate_yaml.sh -o generate_yaml.sh
sudo -u pi curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/get_device_id.sh -o get_device_id.sh
sudo -u pi curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/instance_setup.sh -o instance_setup.sh

chmod -R 775 .* 2>/dev/null
chmod -R 775 . 2>/dev/null

sudo -u pi echo "@reboot bash $(pwd)/instance_setup.sh" >> newcron
#Read current crontab
crontab -u pi -l > oldcron
if [[ -n "$oldcron" ]]; then
  $oldcron >> newcron
fi
crontab -u pi newcron
rm oldcron
rm newcron
reboot
