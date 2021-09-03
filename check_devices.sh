#!/bin/bash

. functions.sh
. sp.config

get_ports

# Loop each device
change_something=0

declare -A newDevices

for ii in "${!spDevices[@]}"; do
  val=${spDevices[$ii]}
  arrIN=(${val//,/ })

  id=${arrIN[0]}
  lastPort=${arrIN[1]}
  found="0"

  # Check current devices
  for x in $return_ports; do
    dev_id=$(bash get_device_id.sh $x)

    if [ "$dev_id" == "$id" ]; then
      # Found it!
      found="1"
      if [ "$x" != "$lastPort" ]; then
        # Is a new port!
        lastPort=$x
        change_something=1
      fi
    fi
  done # end loop current ports

  # Check if it was found
  if [ "$found" == "0" ]; then
    # This device is no longer plugged in, consider it a change
    lastPort=""
    change_something=1
  fi

  newDevices[$ii]=$lastPort
done

# Proceed
if [ "$change_something" == "1" ]; then
  # A device has changed port!
  printf "\nGenerating docker-compose.yaml file\n\n"
  for index in ${!newDevices[@]}; do
    #arrIN=(${spDevices[$index]//,/})
    spDevice="${spDevices[$index]}"
    device="${spDevice%*,}"
    sed -i "s-spDevices\[$index\]=$spDevice-spDevices\[$index\]=${device}${newDevice[$index]}-gI" sp.config
  done
  bash generate_yaml.sh
fi
