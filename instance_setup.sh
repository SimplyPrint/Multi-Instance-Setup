#!/bin/bash

# Setup wizard
echo "$(date -u) - instance_setup.sh" >>"$(pwd)"/logs/scripts.log

if [[ ! -e add_instance.sh ]]; then
  curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/add_instance.sh -o add_instance.sh
fi

echo "total=0" >sp.config
echo "declare -A spDevices" >>sp.config

sep="# ---------------------------------- #"
printf "\n\n"
echo "$sep"

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
  echo ""
  echo "The max suggested amount of instances to set up is; $rec_max in your case"
  echo ""
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
    echo "Be aware that the $pi_model has not been tested"
  else
    if [ "$warn" = true ]; then
      # Bad; Zero or something
      echo " !!!! WARNING !!!! "
      echo "We can see you're using a \"$pi_model\" which is NOT recommended and will most likely _NOT_ work for setting up multiple instances."
      printf "\nWe won't stop you in proceeding, but strongly advise against it as there's very little chance it will work or function well, and could potentially damage your Raspberry Pi..."
      echo " !!!!         !!!! "
      printf "\n\n"
    else
      echo "\"$pi_model\" detected"
      echo "We recommend setting up max; $rec_max instances"
      echo ""

      if [ $rec_max -gt "4" ]; then
        # More than 4 could be an issue, as the Pi's only have 4 USBs
        printf "Setting up more than 4 will require a good USB hub, as the Pi only has 4 USB inputs\n\n"
      fi
    fi
  fi

fi

read -n 1 -s -r -p "Press any key when all USB cables are removed ..."

bash add_instance.sh

exit
