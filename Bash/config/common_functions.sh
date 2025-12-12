#!/bin/bash
#
# Common functions for Bash Scripts Collection
# File: config/common_functions.sh
# Author: Kacper
# Version: 1.0
#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { 
    echo -e "${BLUE}[INFO]${NC} $1"; 
}

log_warn() { 
    echo -e "${YELLOW}[WARN]${NC} $1"; 
}

log_error() { 
    echo -e "${RED}[ERROR]${NC} $1" >&2; 
}

log_success() { 
    echo -e "${GREEN}[SUCCESS]${NC} $1"; 
}

# Generic help function
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help     Show help message"
    echo "  -v, --verbose  Verbose mode"
    echo "  -V, --version  Show version"
}

# Check if required commands are available
check_dependencies() {
    local missing_deps=()
    
    for cmd in "$@"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing_deps[*]}"
        log_info "Please install missing packages and try again"
        exit 1
    fi
}

# Check if value is a number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}
