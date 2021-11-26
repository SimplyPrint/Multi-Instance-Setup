#!/bin/bash

sudo -u pi mkdir "simplyprint"
# shellcheck disable=SC2164
cd SimplyPrint

sudo -u pi mkdir "logs"
sudo -u pi touch logs/log.txt
sudo -u pi touch logs/device.log
sudo -u pi touch logs/scripts.log
sudo -u pi touch logs/docker.log

sudo -u pi echo "Log created $(date -u)" >>"$(pwd)"/logs/log.txt
sudo -u pi echo "Log created $(date -u)" >>"$(pwd)"/logs/device.log
sudo -u pi echo "Log created $(date -u)" >>"$(pwd)"/logs/scripts.log
sudo -u pi echo "Log created $(date -u)" >>"$(pwd)"/logs/docker.log
sudo -u pi echo "$(date -u) - docker_setup.sh" >>"$(pwd)"/logs/scripts.log

yes | apt-get update
sudo -u pi curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker pi
apt-get install libffi-dev libssl-dev
yes | apt install python3-dev
apt-get install -y python3 python3-pip
pip3 install docker-compose

sudo -u pi curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/update.sh -o update.sh
sudo -u pi bash update.sh

#Read current crontab
myCron=$(crontab -l)
#Check if the cronjob already exist
if [[ $myCron != *"@reboot cd $(pwd) && bash cron_check.sh"* ]]; then
  #echo new cronjob into crontab file
  {
    echo "@reboot cd $(pwd) && bash cron_check.sh"
    echo "* * * * * cd $(pwd) && bash cron_check.sh"
    echo "0 0 * * * cd $(pwd) && curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/update.sh -o update.sh"
    echo "0 0 * * 0 cd $(pwd) && bash log_controller.sh"
  } >>myCron
  #install new cron file
  sudo -u pi crontab myCron
fi
#Remove
rm myCron

chmod -R 775 .* 2>/dev/null
chmod -R 775 . 2>/dev/null

printf "\n\n--- Ready! ---\n\n\nThe raspberry pi will now reboot, press Enter to continue"
read -r
