#!/bin/bash
#
# Script: disk_check.sh
# Description: Monitor disk usage and warn if usage exceeds threshold
# Author: Kacper
# Version: 1.1
# Usage: ./disk_check.sh [path] [threshold]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../config/default.conf"
source "$SCRIPT_DIR/../../config/common_functions.sh"

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "disk_check.sh - Monitor disk usage"
    echo
    echo " Usage: $0 [path] [threshold]"
    echo " Arguments:"
    echo "  path       Directory or mount point to check (default: /)"
    echo "  threshold  Warning threshold in percent (default: \$DISK_THRESHOLD or 80)"
    echo
    echo " Options:"
    echo "  -h, --help   Show this help message"
    echo
    echo " Examples:"
    echo "  $0"
    echo "  $0 /home 90"
    echo
    exit 0
fi

target_path="${1:-/}"
threshold="${2:-${DISK_THRESHOLD:-80}}"

check_dependencies "df" "awk" "tr"

if [ ! -d "$target_path" ]; then
	log_error "Target path '$target_path' does not exist or is not a directory)"
	exit 1
fi

log_info "Checking disk usage for: '$target_path' (threshold: ${threshold})"

used=$(df "$target_path" | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$used" -ge "$threshold" ]; then
    log_warn "Warning: disk usage on '$target_path' is at ${used}% (>= ${threshold}%)"
else
    log_success "Disk usage on '$target_path' is OK: ${used}%"
fi
