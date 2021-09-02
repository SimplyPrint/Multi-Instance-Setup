#!/bin/bash

. sp.config

sep="# ---------------------------------- #"
printf "\n\nHow many SimplyPrint instances do you wish to set up? (write a number and press Enter)\n"

read addTotal
newTotal=$(($total + $addTotal))

printf "\n\nSetting up $addTotal instances"

. functions.sh

# Get ports now that all are removed;
get_ports
last_total_ports=$total_ports

for ((i = $total ; i < $newTotal ; i++)); do
  printf "\n\n\n\n"
  echo $sep
  echo "- Printer $((i + 1)) setup"

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
    printf "\n\nDevice $this_port detected!\n"
    dev_id=$(bash get_device_id.sh $this_port)
    echo "spDevices[$i]=$dev_id,$this_port" >>sp.config
  fi

done

bash generate_yaml.sh

printf "\nHere are the links for octoprint, they will be offline until Docker is ready\n"
ip=$(ifconfig wlan0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
echo "ip: $ip"
for ((i = $total ; i < $newTotal ; i++)); do
  echo "http://$ip:8$i/"
done

sed -i "s/total=[0-99]/total=${newTotal}/gI" sp.config
