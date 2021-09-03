#!/bin/bash

ai=$(udevadm info $1)
#cut0="${ai#*N: }"
#echo "Getting ID from ${cut0::7}"
cut1="${ai#*ID_VENDOR_ID=}"
cut2="${ai#*ID_MODEL_ID=}"
cut3="${ai#*ID_REVISION=}"
id="${cut1::4}:${cut2::4}:${cut3::4}"

echo $id
