#!/bin/bash

cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4}')
ram=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')

cpu_int=${cpu%.*}
ram_int=${ram%.*}

if (( cpu_int > 80 )); then
  echo "$(date) - ALERT: CPU $cpu%" >> alerty.log
fi

if (( ram_int > 90 )); then
  echo "$(date) - ALERT: RAM $ram%" >> alerty.log
fi

