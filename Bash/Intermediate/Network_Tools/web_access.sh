#!/bin/bash
#
# Script: web_access.sh
# Description: Check website availability and return HTTP status
# Author: Kacper
# Version: 1.2
# Usage: ./web_access.sh [url1] [url2] ...

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../config/default.conf"
source "$SCRIPT_DIR/../../config/common_functions.sh"

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
	echo "web_access.sh - Check website availability"
	echo
	echo " Usage: "$0" [url1] [url2] ..."
	echo " Arguments:"
	echo " 	url  -- One or more website addresses to check"
	echo
	echo " Options:"
	echo "  -h, --help   Show this help message"
	echo
	echo " Examples:"
	echo " "$0" https://example.com"
	echo " "$0" http://google.com https://example.com"
	echo
	exit 0
fi


if [ $# -eq 0 ]; then
	log_error "No URL provided"
	exit 1
fi

check_dependencies "curl"

for url in "$@"; do
	log_info "Checking website: '$url'"

	response=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" -L "$url")
	status=$(echo "$response" | awk '{print $1}')
	time_total=$(echo "$response" | awk '{print $2}')

	case ${status} in 
		200)
			log_success "Website '$url' is available (code $status, response ${time_total}s)"
			;;
		301|302)
			log_warn "Website '$url' is redirected (code $status, response ${time_total}s)"
			;;
		403)
			log_error "Website '$url' is forbidden (code $status, response ${time_total}s)"
			;;
		404)
			log_error "Website '$url' not found (code $status, response ${time_total}s)"
			;;
		500)
			log_error "Website '$url' returns server error (code $status, response ${time_total}s)"
			;;
		*)
			log_warn "Website '$url' returned code: $status (response ${time_total}s)"
			;;
	esac
done
