#!/bin/bash

. functions.sh
. sp.config

get_ports

# Loop each device
change_something=0

declare -A newDevices

for ii in "${!spDevices[@]}"; do
  echo "Checking sp$ii: spDevices[$ii]"
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
    echo "Port not found"
    # This device is no longer plugged in, consider it a change
    lastPort=""
    change_something=1
  fi

  newDevices[$ii]=$lastPort
  echo ""
done

# Proceed
if [ "$change_something" == "1" ]; then
  # A device has changed port!
  printf "\nGenerating docker-compose.yaml file\n\n"
  for index in ${!newDevices[@]}; do
    val=${spDevices[$ii]}
    arrIN=(${val//,/ })
    spDevice="${spDevices[$index]}"
    sed -i "s-spDevices\[$index\]=${arrIN[0]},${arrIN[1]}-spDevices\[$index\]=${arrIN[0]},${newDevices[$index]}-gI" sp.config
  done
  bash generate_yaml.sh
fi
