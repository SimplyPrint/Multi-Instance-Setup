#!bin/bash

if [ -e docker-compose.yaml ]; then
	rm docker-compose.yaml
fi
cat > docker-compose.yaml <<-EOL
version: '2.4'

services:
EOL
index=-1
for device in $@; do
	((index+=1))
	cat >> docker-compose.yaml <<-EOL
  sp${index}:
    image: octoprint/octoprint
    restart: unless-stopped

    ports:
      - 8${index}:80

    devices:
      - $device:$device

    volumes:
      - ./sp${index}:/octoprint

	EOL
done