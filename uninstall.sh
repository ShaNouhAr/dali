#!/bin/bash

# Dali Uninstallation Script

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo ""
echo "================================================================"
echo "  Dali - System Uninstallation"
echo "================================================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "This script must be run as root"
    print_info "Run with: sudo ./uninstall.sh"
    exit 1
fi

INSTALL_DIR="/opt/dali"

# Check if dali is installed
if [ ! -d "$INSTALL_DIR" ] && [ ! -L "/usr/local/bin/dali" ]; then
    print_error "Dali is not installed"
    exit 1
fi

print_warning "This will remove Dali from your system"
print_info "Installation directory: $INSTALL_DIR"
print_info "Symlink: /usr/local/bin/dali"
echo ""
read -p "Continue? [y/N] " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_info "Uninstallation cancelled"
    exit 0
fi

# Remove symlink
if [ -L "/usr/local/bin/dali" ] || [ -f "/usr/local/bin/dali" ]; then
    print_info "Removing symlink..."
    rm /usr/local/bin/dali
    print_success "Symlink removed"
fi

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    print_info "Removing installation directory..."
    rm -rf "$INSTALL_DIR"
    print_success "Installation directory removed"
fi

echo ""
print_success "Dali uninstalled successfully!"
echo ""
print_info "Optional cleanup (if needed):"
echo "  - Docker images:   docker rmi dali-kali:latest"
echo "  - Docker network:  docker network rm dali_network"
echo "  - Data directory:  rm -rf /opt/dali/data/"
echo "  - User configs:    rm -rf ~/.dali/ (for each user)"
echo ""

