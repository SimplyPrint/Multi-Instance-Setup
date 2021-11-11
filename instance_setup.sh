#!/bin/bash

if [[ ! -e add_instance.sh ]]; then
  curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/add_instance.sh -o add_instance.sh
fi

echo "total=0" >sp.config
echo "declare -A spDevices" >>sp.config

sep="# ---------------------------------- #"
printf "\n\n"
echo $sep

# Check if it's Pi, and if so; which model?
pi_file="/proc/device-tree/model"
pi_model=""
warn=false

# Get model name from file
if test -f "$pi_file"; then
  pi_model=$(tr -d '\0' <$pi_file) # "<" same as "cat"
fi

if [ "$pi_model" == "" ]; then
  # Could not find device model
  rec_max="20"
  echo "We don't know what kind of device you're on, but we _think_ it isn't a Raspberry Pi."
  echo "So, we assume you're on a \"real\" Linux-based computer!"
  printf "\nThe max suggested amount of instances to set up is; $rec_max in your case\n\n"
else
  # Found device model
  rec_max="5"
  unknown=false

  case $pi_model in
  *"Pi 4"*)
    # Pi 4 or 400
    rec_max="8"
    ;;
  *"Pi 3 Model A+"*)
    # Small version of Pi 3B with less ram
    rec_max="2"
    ;;
  *"Pi 3 Model B"*)
    # Pi 3B
    rec_max="4"
    ;;
  *"Pi A+"*)
    # Single core, bad like Zero and no WiFi
    rec_max="2"
    warn=true
    ;;
  *"Pi 3"* | *"Pi 2"* | *"Pi 1"*)
    # Old; Pi 3 (not B), 2 or 1 - not very good
    rec_max="2"
    ;;
  *"Zero"*)
    # Zero, single core and just bad...
    rec_max="2"
    warn=true
    ;;
  *)
    # Unknown model
    unknown=true
    ;;
  esac

  # Done looping models; tell user
  if [ "$unknown" = true ]; then
    echo "Don't know nothing"
  else
    if [ "$warn" = true ]; then
      # Bad; Zero or something
      echo " !!!! WARNING !!!! "
      echo "We can see you're using a \"$pi_model\" which is NOT recommended and will most likely _NOT_ work for setting up multiple instances."
      printf "\nWe won't stop you in proceeding, but strongly advise against it as there's very little chance it will work or function well, and could potentially damage your Rasbperry Pi..."
      echo " !!!!         !!!! "
      printf "\n\n"
    else
      echo "\"$pi_model\" detected"
      printf "We recommend setting up max; $rec_max instances\n\n"

      if [ $rec_max -gt "4" ]; then
        # More than 4 could be an issue, as the Pi's only have 4 USBs
        printf "Setting up more than 4 will require a good USB hub, as the Pi only has 4 USB inputs\n\n"
      fi
    fi
  fi

fi

read -n 1 -s -r -p "Press any key when all USB cables are removed ..."

. add_instance.sh

#Read current crontab
crontab -l > mycron
#Check if the cronjob already exist
if [[ $mycron != *"* * * * * bash $(pwd)/check_devices.sh"* ]]; then
  #echo new cronjob into crontab file
  echo "@reboot bash $(pwd)/check_devices.sh" >> mycron
  echo "* * * * * bash $(pwd)/check_devices.sh && sleep 10 && bash $(pwd)/check_devices.sh && sleep 10 && bash $(pwd)/check_devices.sh && sleep 10 && bash $(pwd)/check_devices.sh && sleep 10 && bash $(pwd)/check_devices.sh" >> mycron
  #install new cron file
  crontab mycron
fi
#Remove 
rm mycron

#. generate_yaml.sh

#printf "\n\nAwesome! Setting up $amount instances.\n\n"
printf "\n\nSetting up Docker, this can take a while (up to 15 minutes), please wait (there will be no confirmation when it's done)\n"
printf "\nRun 'docker-compose ps' to check if it's running. You can run if they are down 'docker-compose up' if it's not\n"
#printf "If you get this error: 'x matches found based on name: network pi_default is ambiguous' then run 'docker system prune -af && docker volume prune --force'\n\n"

exit
