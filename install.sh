#!/bin/bash

# Dali Installation Script

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
echo "  Dali - Installation"
echo "================================================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Do not run this script as root"
    print_info "Run as normal user: ./install.sh"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DALI_SCRIPT="$SCRIPT_DIR/dali"

# Check if dali script exists
if [ ! -f "$DALI_SCRIPT" ]; then
    print_error "dali script not found in $SCRIPT_DIR"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_warning "Docker is not installed"
    print_info "Install Docker first: https://docs.docker.com/engine/install/"
    exit 1
fi

# Create symbolic link to /usr/local/bin
print_info "Installing dali to /usr/local/bin/..."

if [ -f "/usr/local/bin/dali" ] || [ -L "/usr/local/bin/dali" ]; then
    print_warning "dali is already installed"
    read -p "Overwrite existing installation? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi
    sudo rm /usr/local/bin/dali
fi

# Create symlink
sudo ln -s "$DALI_SCRIPT" /usr/local/bin/dali

# Verify installation
if command -v dali &> /dev/null; then
    print_success "dali installed successfully!"
    echo ""
    print_info "You can now use: dali <command>"
    print_info "Example: dali init"
    echo ""
    print_info "Next steps:"
    echo "  1. dali init    # Initialize"
    echo "  2. dali build   # Build Kali image (~30 min)"
    echo "  3. dali create  # Create a container"
    echo ""
else
    print_error "Installation failed"
    exit 1
fi

