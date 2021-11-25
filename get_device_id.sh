#!/bin/bash

usbInfo=$(udevadm info "$1")

id="id"

# For Prusa
if [[ $usbInfo == *"ID_SERIAL_SHORT"* ]]; then
  cut=${usbInfo#*ID_SERIAL_SHORT=}
  cut1=${cut%%E*}
  id+=":${cut1::(-1)}"
fi

# Other
if [[ $usbInfo == *"ID_VENDOR_ID"* ]]; then
  cut=${usbInfo#*ID_VENDOR_ID=}
  cut1=${cut%%E*}
  id+=":${cut1::(-1)}"
fi

if [[ $usbInfo == *"ID_MODEL_ID"* ]]; then
  cut=${usbInfo#*ID_MODEL_ID=}
  cut1=${cut%%E*}
  id+=":${cut1::(-1)}"
fi

if [[ $usbInfo == *"ID_REVISION"* ]]; then
  cut=${usbInfo#*ID_REVISION=}
  cut1=${cut%%E*}
  id+=":${cut1::(-1)}"
fi

echo "$id"
