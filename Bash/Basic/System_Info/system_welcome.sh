#!/bin/bash
#
# Script: system_welcome.sh
# Description: Displays system welcome message with basic info
# Author: Kacper
# Version: 1.1
# Usage: ./system_welcome.sh [options]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../config/common_functions.sh"

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
	echo "system.welcom.sh - Display system welcome message"
	echo
	echo " Usage: $0 [options]"
	echo " Options:"
	echo "  -h, --help  Show this help message"
	echo
	exit 0
fi


echo
log_success " Welcome $(whoami)!"
echo
log_info " Today is: $(date)"
log_info " You're using: $(hostname)"
log_info " System uptime: $(uptime -p 2>/dev/null || echo "unknown")"
echo
