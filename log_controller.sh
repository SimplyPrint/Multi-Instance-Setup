#! /bin/bash

# Log controller
logs/device.log >logs/device_old.log
logs/scripts.log >logs/scripts_old.log
logs/log.txt >logs/log_old.txt

echo "Cleared $(date)" >logs/device.log
echo "Cleared $(date)" >logs/scripts.log
echo "Cleared $(date)" >logs/log.txt
