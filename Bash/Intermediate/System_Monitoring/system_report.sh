#!/bin/bash
#
# Script: system_report.sh
# Description: Show system report (short / standard / full)
# Author: Kacper
# Version: 1.3
# Usage: ./system_report.sh [--short|--full]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../config/default.conf"
source "$SCRIPT_DIR/../../config/common_functions.sh"

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "system_report.sh - Show system report"
    echo
    echo " Usage: $0 [--short|--full]"
    echo
    echo " Options:"
    echo "  --short   Show minimal system report"
    echo "  --full    Show extended system report"
    echo "  -h, --help   Show this help message"
    echo
    echo " Examples:"
    echo "  $0"
    echo "  $0 --short"
    echo "  $0 --full"
    echo
    exit 0
fi

check_dependencies "uptime" "lscpu" "free" "df" "ps"

mode="standard"

[[ "$1" == "--short" ]] && mode="short"
[[ "$1" == "--full" ]] && mode="full"

echo "========================"
echo "     SYSTEM REPORT      "
echo "========================"

log_info "Collecting system informations (mode: "$mode")..."

echo "Date:    $(date)"
echo "Uptime:  $(uptime -p)"
echo

cpu_model=$(lscpu | grep -m1 "Model name" | sed 's/Model name:\s*//')
echo "CPU:        $cpu_model"
echo

echo "Memory:"
free -h | awk 'NR==1 || NR==2 {print}'
echo


if [[ "$mode" == "standard" || "$mode" == "full" ]]; then
    echo "Disk usage:"
    if [[ "$mode" == "full" ]]; then
        df -h | awk 'NR==1 || /^\/dev/'
    else
        df -h / | awk 'NR==1 || NR==2 {print}'
    fi
    echo
fi

if [[ "$mode" == "short" ]]; then
    log_success "Short system report generated"
    exit 0
fi

if [[ "$mode" == "full" ]]; then
    echo "Top 10 CPU-consuming processes:"
    ps -eo pid,user,pcpu,comm --sort=-pcpu | head -n 11
else
    echo "Top 5 CPU-consuming processes:"
    ps -eo pid,user,pcpu,comm --sort=-pcpu | head -n 6
fi
echo

log_success "System report generated successfully"



