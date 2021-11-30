#!/bin/bash

# Generate the Docker YAML file
echo "$(date -u) - generate_yaml.sh" >>"$(pwd)"/logs/scripts.log

# Import config
. sp.config

# Delete old yaml file
if [ -e docker-compose.yaml ]; then
  rm docker-compose.yaml
fi

# Add Header to the yaml file
cat >docker-compose.yaml <<-EOL
version: '2.4'

services:
EOL

ports=$(ls /dev/ttyUSB* /dev/ttyACM*)

# Add instances
# shellcheck disable=SC2154
for ((i = 0; i < total; i++)); do
  cat >>docker-compose.yaml <<-EOL
  sp${i}:
    image: simplyprint/simplypi-docker
    restart: unless-stopped

    ports:
      - 80${i}:80

    volumes:
      - ./sp${i}:/octoprint

    environment:
      - ENABLE_MJPG_STREAMER=true

	EOL
  temp="${spDevices[$i]}"
  device="${temp#*,}"

  if [[ $ports =~ $device ]] && [[ -n $device ]]; then
    cat >>docker-compose.yaml <<-EOL
    devices:
      - $device:$device

EOL
  fi
done
sleep 1
date >>"$(pwd)"/logs/docker.log
if ( (/usr/local/bin/docker-compose up -d)); then
  echo "/usr/local/bin/docker-compose up -d - Successful - $(pwd)" >>"$(pwd)"/logs/log.txt
else
  echo "!!! /usr/local/bin/docker-compose up -d - Failed - $(pwd) !!!" >>"$(pwd)"/logs/log.txt
fi
docker-compose logs | grep error >>"$(pwd)"/logs/docker.log
