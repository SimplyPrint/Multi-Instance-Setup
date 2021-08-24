#!bin/bash

# Import config
. sp.config

# Delete old yaml file
if [ -e docker-compose.yaml ]; then
	rm docker-compose.yaml
fi

# Add Header to the yaml file
cat > docker-compose.yaml <<-EOL
version: '2.4'

services:
EOL
index=-1

# Add instances
for ((i = 0 ; i < $total ; i++)); do
	cat >> docker-compose.yaml <<-EOL
  sp${i}:
    image: simplyprint/simplypi-docker
    restart: unless-stopped

    ports:
      - 8${i}:80

    volumes:
      - ./sp${i}:/octoprint

    environment:
      - ENABLE_MJPG_STREAMER=true

	EOL
	temp="${spDevices[$i]}"
        device="${temp#*,}"

	if [[ $@ =~ $device ]]; then
		cat >> docker-compose.yaml <<-EOL
    devices:
      - $device:$device

EOL
	fi
done
docker-compose up
