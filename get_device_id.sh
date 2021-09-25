#!/bin/bash

ai=$(udevadm info $1)
cut0="${ai#*MAJOR=}"
cut1="${ai#*ID_VENDOR_ID=}"
cut2="${ai#*ID_MODEL_ID=}"
cut3="${ai#*ID_REVISION=}"
cut4="${ai#*ID_USB_DRIVER=}"
# For Prusa
cut5="${ai#*ID_SERIAL_SHORT=}"
id="${cut0::3}:${cut1::4}:${cut2::4}:${cut3::4}:${cut4::7}:${cut4::18}"

echo $id
