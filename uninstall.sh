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
echo "  Dali - Uninstallation"
echo "================================================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Do not run this script as root"
    print_info "Run as normal user: ./uninstall.sh"
    exit 1
fi

# Check if dali is installed
if [ ! -f "/usr/local/bin/dali" ] && [ ! -L "/usr/local/bin/dali" ]; then
    print_error "dali is not installed"
    exit 1
fi

print_warning "This will remove dali from your system"
read -p "Continue? [y/N] " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_info "Uninstallation cancelled"
    exit 0
fi

# Remove symlink
sudo rm /usr/local/bin/dali
print_success "dali removed from /usr/local/bin/"

echo ""
print_info "Optional cleanup:"
echo "  - Docker images: docker rmi dali-kali:latest"
echo "  - Containers: dali ls (use before uninstalling)"
echo "  - Data: sudo rm -rf /opt/dali/data/"
echo "  - Config: rm -rf ~/.dali/"
echo ""
print_success "Uninstallation complete!"

