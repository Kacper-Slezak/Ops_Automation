#!/bin/bash
#
# Script: random_pass.sh
# Description: Generate secure random passwords
# Author: Kacper
# Version: 1.1  
# Usage: ./random_pass.sh [length]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../config/default.conf"
source "$SCRIPT_DIR/../../config/common_functions.sh"


if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
	echo "random_pass.sh - Secure password generator"
	echo
	echo " Usage: $0 [length]"
	echo " Arguments:"
	echo "	length   Password length ( '$MIN_PASSWORD_LENGTH'-'$MAX_PASSWORD_LENGTH, default: '$DEFAULT_PASSWORD_LENGTH')"
	echo
	echo " Options:"
	echo "	-h, --help   Show this help message"
	echo
	echo " Examples:"
	echo "  '$0'"
	echo "  '$0' 16"
	echo
	exit 0
fi

check_dependencies "head" "tr"

length=${1:-$DEFAULT_PASSWORD_LENGTH}

if ! is_number "$length"; then
	log_error "Length must be a number"
	exit 1
fi

if [ "$length" -lt "$MIN_PASSWORD_LENGTH" ] || [ "$length" -gt "$MAX_PASSWORD_LENGTH" ]; then
	log_error "Length must be between '$MIN_PASSWORD_LENGTH' and '$MAX_PASSWORD_LENGTH'"
	exit 1
fi

log_info "Generating ${length}-character password..."

password=$(< /dev/urandom tr -dc A_Za-z0-9 | head -c"$length")

if [ -n "$password" ]; then
	log_success "Generated password: '$password'"
else
	log_error "Failed to generate password"
	exit 1
fi
