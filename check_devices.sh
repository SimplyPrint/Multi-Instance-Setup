#!/bin/bash


echo "-- $(date -u) - Running check_devices.sh" >>"$(pwd)"/logs/log.txt
echo "$(date -u) - Running check_devices.sh" >>"$(pwd)"/logs/scripts.log

. functions.sh
. sp.config

get_ports

# Loop each device
change_something=0

# shellcheck disable=SC2154
echo "Return Ports: $return_ports" >>"$(pwd)"/logs/log.txt

declare -A newDevices

# shellcheck disable=SC2154
for ii in "${!spDevices[@]}"; do
  val=${spDevices[$ii]}
  # shellcheck disable=SC2206
  arrIN=(${val//,/ })

  id=${arrIN[0]}
  lastPort=${arrIN[1]}
  found="0"

  # Check current devices
  for x in $return_ports; do
    dev_id=$(bash get_device_id.sh "$x")

    if [ "$dev_id" == "$id" ]; then
      # Found it!
      found="1"
      if [ "$x" != "$lastPort" ]; then
        echo "spDevices[$ii] - New port: $x - ${spDevices[$ii]}" >>"$(pwd)"/logs/log.txt
        # Is a new port!
        lastPort=$x
        change_something=1
        break
      else
        echo "spDevices[$ii] - Same port: $x - ${spDevices[$ii]}" >>"$(pwd)"/logs/log.txt
        break
      fi
    fi
  done # end loop current ports

  # Check if it was found
  if [ "$found" == "0" ]; then
    echo "spDevices[$ii] - Port not found - ${spDevices[$ii]}" >>"$(pwd)"/logs/log.txt
    # This device is no longer plugged in, consider it a change
    if [[ -n $lastPort ]]; then
      lastPort=""
      change_something=1
    fi
  fi

  newDevices[$ii]=$lastPort
done

# Proceed
if [ "$change_something" == "1" ]; then
  # A device has changed port!
  echo "Generating docker-compose.yaml file - $(date -u)" >>"$(pwd)"/logs/device.log
  for index in "${!newDevices[@]}"; do
    val=${spDevices[$index]}
    # shellcheck disable=SC2206
    arrIN=(${val//,/ })
    {
      echo "Changing from - to;"
      echo "spDevices\[$index\]=${val}"
      echo "spDevices\[$index\]=${arrIN[0]},${newDevices[$index]}"
    } >>"$(pwd)"/logs/device.log
    sed -i "s-spDevices\[$index\]=${val}-spDevices\[$index\]=${arrIN[0]},${newDevices[$index]}-gI" sp.config
  done
  bash generate_yaml.sh
fi
