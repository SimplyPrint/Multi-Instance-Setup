#!/bin/bash

echo "$(date -u) - update.sh" >>"$(pwd)"/logs/scripts.log

baseUrl="https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/"

curl ${baseUrl}check_devices.sh -o check_devices.sh
curl ${baseUrl}functions.sh -o functions.sh
curl ${baseUrl}generate_yaml.sh -o generate_yaml.sh
curl ${baseUrl}get_device_id.sh -o get_device_id.sh
curl ${baseUrl}instance_setup.sh -o instance_setup.sh
curl ${baseUrl}add_instance.sh -o add_instance.sh
curl ${baseUrl}cron_check.sh -o cron_check.sh
curl ${baseUrl}log_controller.sh -o log_controller.sh
curl ${baseUrl}update.sh -o update.sh
