#!/bin/bash

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

# Pi-validation done
# How many instances to set up?
printf "How many SimplyPrint instances do you wish to set up?\nEnter a number between 2 and $rec_max; "

read amount

if [ "$amount" -le "1" ]; then
  echo "Must set up at least 2 - otherwise there's no point"
  exit
fi

printf "\n\n\n\n"
echo $sep
printf "\nGreat! Let's set up $amount printers!\n\n### Please remove all USB cables from your Raspberry Pi (except USB-hubs if you plan on using one)!\n\n"

last_total_ports=0

read -n 1 -s -r -p "Press any key when all USB cables are removed ..."

. functions.sh

# Get ports now that all are removed;
get_ports
last_total_ports=$total_ports

# Loop printers and set each one up
i="0"

echo "declare -A spDevices" >sp.config

declare -A newDevices

while [ "$i" -lt "$amount" ]; do
  i=$(($i + 1))
  printf "\n\n\n\n"
  echo $sep
  echo "- Printer $i setup"

  if [ $i -gt "1" ]; then
    echo " !! Do NOT remove any USB cables !! "
  fi

  echo "Insert the USB cable into the pi (cable must be connected to the printer, and printer must be turned on)"
  printf "\n"

  read -n 1 -s -r -p "Press any key when cable is inserted... "
  last_ports=$return_ports # save last ports
  get_ports                # get ports now

  if [ "$total_ports" -lt "$last_total_ports" ] || [ "$total_ports" -eq "$last_total_ports" ]; then
    printf "\n\n\n # !!! Failed; has same amount of ports as before. Either previous USB was plugged out, or new one wasn't inserted / registered\n\n"
    exit
  fi

  last_total_ports=$total_ports # set new 'last'
  this_port=""

  for x in $return_ports; do
    if [[ ! " $last_ports " =~ " $x " ]]; then
      # This (new) value doesn't exist in old array; is the new device
      this_port=$x
    fi
  done

  if [ "$this_port" == "" ]; then
    # Could not find a new port...
    printf "\n\n\n # !!! Failed; New device not detected, try again - maybe with a different cable? Make sure the printer's power supply is turned on.\n\n"
    echo "" >sp.config
    exit
  else
    # Found port! Let's continue
    num=$(($i - 1))
    printf "\n\nDevice $this_port detected!\n"
    dev_id=$(bash get_device_id.sh $this_port)
    echo "spDevices[$num]=$dev_id,$this_port" >>sp.config
    newDevices[$num]=$this_port
  fi

done

echo "total=$amount" >>sp.config
myarray=()
for index in ${!newDevices[@]}; do
  myarray[$index]=${newDevices[$index]}
done
echo ${myarray[@]}
bash generate_yaml.sh "${myarray[@]}"

#Read current crontab
crontab -l > mycron
#Check if the cronjob already exist
if [[ $mycron != *"* * * * * bash $(pwd)/check_devices.sh"* ]]; then
  #echo new cronjob into crontab file
  echo "* * * * * bash $(pwd)/check_devices.sh" >> mycron
  #install new cron file
  crontab mycron
fi
#Remove 
rm mycron

printf "\n\nAwesome! Setting up $amount instances.\n\n"
printf "Setting up Docker, this can take a while (up to 15 minutes), please wait\n(there will be no confirmation when it's done)\n"
docker-compose up &>/dev/null &

exit
