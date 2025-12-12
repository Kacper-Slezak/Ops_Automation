#!/bin/bash
#
# Script: backup.sh
# Description: Create compressed backup of a directory and clean old backups
# Author: Kacper
# Version: 1.1
# Usage: ./backup.sh [source_dir] [destination_dir]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../config/default.conf"
source "$SCRIPT_DIR/../../config/common_functions.sh"

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
	echo "backup.sh - Create directory backup"
	echo
	echo " Usage: $0 [source_dir] [destination_dir]"
	echo " Arguments:"
	echo "  source_dir       Directory to back up (default: \$DEFAULT_BACKUP_SOURCE)"
	echo "  destination_dir  Backup location (default: \$DEFAULT_BACKUP_DEST)"
	echo
	echo " Options:"
	echo "  -h, --help       Show this help message"
	echo
	echo " Examples:"
	echo "  $0 /home/user /mnt/backup"
	echo "  $0"
	echo
	exit 0
fi

# ustawienia domyślne z configa lub argumenty
src="${1:-$DEFAULT_BACKUP_SOURCE}"
dest="${2:-$DEFAULT_BACKUP_DEST}"

check_dependencies "tar" "find" "date" "mkdir"

if [ ! -d "$src" ]; then
	log_error "Source directory '$src' does not exist"
	exit 1
fi

if [ ! -r "$src" ]; then
	log_error "No read permission for source directory: '$src'"
	exit 1
fi

mkdir -p "$dest" || {
	log_error "Failed to create destination directory '$dest'"
	exit 1
}

backup="$dest/backup-$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

log_info "Creating backup from '$src' to '$backup'..."
if tar -czf "$backup" "$src"; then
	log_success "Backup created successfully: '$backup'"
else
	log_error "Backup failed"
	exit 1
fi

log_info "Cleaning backups older than ${BACKUP_RETENTION_DAYS:-7} days..."
find "$dest" -type f -name "backup-*.tar.gz" -mtime +"${BACKUP_RETENTION_DAYS:-7}" -print -delete

log_success "Backup process finished"

