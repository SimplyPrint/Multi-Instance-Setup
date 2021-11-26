#!/bin/bash

total_ports=0
return_ports=()

function get_ports() {
  total_ports=0
  now_ports=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null)
  return_ports=()

  for word in $now_ports; do
    return_ports+=("$word")
    total_ports=$(($total_ports + 1))
  done

  # shellcheck disable=SC2124
  # shellcheck disable=SC2178
  return_ports=${return_ports[@]}
}
