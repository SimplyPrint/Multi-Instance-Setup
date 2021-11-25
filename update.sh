#!/bin/bash

echo "$(date -u) - update.sh" >>"$(pwd)"/logs/scripts.log

curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/check_devices.sh -o check_devices.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/functions.sh -o functions.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/generate_yaml.sh -o generate_yaml.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/get_device_id.sh -o get_device_id.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/instance_setup.sh -o instance_setup.sh
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/add_instance.sh -o add_instance.sh
