#!/bin/bash
#
# Script: file_counting.sh
# Description: Count files and directories in specified path
# Author: Kacper  
# Version: 1.1
# Usage: ./file_counting.sh [directory]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../config/default.conf"
source "$SCRIPT_DIR/../../config/common_functions.sh"

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
	echo "file_counting.sh - Count files and directories"
	echo
	echo " Usage: $0 [directory]"
	echo " Arguments:"
	echo "  directory  --  Directory to analyze (default: current directory)"
	echo
	echo " Options:"
	echo "  -h, --help -- Show this help message"
	echo
	echo " Examples:"
	echo " $0"
	echo " $0 /home/user"
	echo
	exit 0
fi

if [ $# -eq 0 ]; then
	target_dir="$DEFAULT_DIRECTORY"
else
	target_dir="$1"
fi

if [ ! -e "$target_dir" ]; then
	log_error "Path '$target_dir' does not exist"
	exit 1
fi

if [ ! -d "$target_dir" ]; then
	log_error "'$target_dir' is not a directory"
	exit 1 
fi

if [ ! -r "$target_dir" ]; then
	log_error "No read permission for directory: '$target_dir'"
       	exit 1
fi

log_info "Analyzing directory: '$target_dir'"

files_count=$(find "$target_dir" -maxdepth 1 -type f | wc -l)
dirs_count=$(find "$target_dir" -maxdepth 1 -type d | wc -l)
((dirs_count--)) 

echo
echo " Directory: '$target_dir'"
echo " Files: '$files_count'"
echo " Subdirectories '$dirs_count'"
echo


if [ "$files_count" -eq 0 ] && [ "$dirs_count" -eq 0 ]; then
	log_warn "Directory appears to be empty"
else
	log_success "Analysis completed successfully"
fi
