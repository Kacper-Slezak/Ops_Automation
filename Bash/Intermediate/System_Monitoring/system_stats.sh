#!/bin/bash

echo "---- Server Performance Stats ---"
echo ""

# Current date and time 
echo "Stats from: $(date)"
echo "Uptime: $(uptime -p)"

# CPU usage
echo "--- CPU Stats ---"
echo "Total CPU usage: $(top -bn1 | grep "Cpu(s)")"
echo ""

# Memory usage

echo "--- Memory Stats ---"
echo "Total Memory: $(free -h | awk 'NR==2 {print $2}')"
echo "Used Memory: $(free -h | awk 'NR==2 {print $3}')"
echo "Free Memory: $(free -h | awk 'NR==2 {print $4}')"
echo "Percentage memory usage: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
echo""

# Disk usage
echo "Total disk usage: $(df -h --total | tail -n 1)"

# Top 5 processes by CPU and Memory
echo "--- Top 5 processes ---"
echo "Top 5 by CPU usage:"
top -bn1 | head -n 12 | tail -n 5
echo ""

echo "Top 5 by Memomry usage:"
top -bn1 -o %MEM | head -n 12 | tail -n 5
echo ""
echo "--- It is all stats ---"
