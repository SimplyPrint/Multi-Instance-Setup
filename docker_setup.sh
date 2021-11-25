#!/bin/bash

mkdir "SimplyPrint"
# shellcheck disable=SC2164
cd SimplyPrint

mkdir "logs"
echo "Log created $(date -u)" >>"$(pwd)"/logs/log.txt
echo "Log created $(date -u)" >>"$(pwd)"/logs/device.log
echo "Log created $(date -u)" >>"$(pwd)"/logs/scripts.log
echo "$(date -u) - docker_setup.sh" >>"$(pwd)"/logs/scripts.log

yes | apt-get update
sudo -u pi curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker pi
apt-get install libffi-dev libssl-dev
yes | apt install python3-dev
apt-get install -y python3 python3-pip
pip3 install docker-compose

curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/update.sh -o update.sh
bash update.sh

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
  crontab myCron
fi
#Remove
rm myCron

chmod -R 775 .* 2>/dev/null
chmod -R 775 . 2>/dev/null

printf "\n\n--- Ready! ---\n\n\nThe raspberry pi will now reboot, press Enter to continue"
read -r
