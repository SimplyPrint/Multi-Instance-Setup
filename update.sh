#!/bin/bash

echo "$(date -u) - update.sh" >>"$(pwd)"/logs/scripts.log

baseUrl="https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/"

curl ${baseUrl}main/check_devices.sh -o check_devices.sh
curl ${baseUrl}main/functions.sh -o functions.sh
curl ${baseUrl}main/generate_yaml.sh -o generate_yaml.sh
curl ${baseUrl}main/get_device_id.sh -o get_device_id.sh
curl ${baseUrl}main/instance_setup.sh -o instance_setup.sh
curl ${baseUrl}main/add_instance.sh -o add_instance.sh
curl ${baseUrl}main/cron_check.sh -o cron_check.sh
curl ${baseUrl}main/update.sh -o update.sh
