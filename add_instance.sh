#!/bin/bash

. sp.config

sep="# ---------------------------------- #"
printf "\nHow many instances would you like to add?"

read addAmount
newAmount=$(($amount + $addAmount))

for ((i = $amount ; i <  newAmount; i++)); do
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

$amount=newAmount
