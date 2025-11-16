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
echo "  Dali - System-wide Installation"
echo "================================================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "This script must be run as root"
    print_info "Run with: sudo ./install.sh"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/opt/dali"

# Check if required files exist
if [ ! -f "$SCRIPT_DIR/dali" ]; then
    print_error "dali script not found in $SCRIPT_DIR"
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/Dockerfile" ]; then
    print_error "Dockerfile not found in $SCRIPT_DIR"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_warning "Docker is not installed"
    print_info "Install Docker first: https://docs.docker.com/engine/install/"
    exit 1
fi

# Check if already installed
if [ -d "$INSTALL_DIR" ]; then
    print_warning "Dali is already installed in $INSTALL_DIR"
    read -p "Overwrite existing installation? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi
    print_info "Removing old installation..."
    rm -rf "$INSTALL_DIR"
fi

# Create installation directory
print_info "Creating installation directory..."
mkdir -p "$INSTALL_DIR"

# Copy files
print_info "Copying files to $INSTALL_DIR..."
cp "$SCRIPT_DIR/dali" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/Dockerfile" "$INSTALL_DIR/"

# Copy documentation if exists
[ -f "$SCRIPT_DIR/README.md" ] && cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/"
[ -f "$SCRIPT_DIR/QUICKSTART.md" ] && cp "$SCRIPT_DIR/QUICKSTART.md" "$INSTALL_DIR/"
[ -f "$SCRIPT_DIR/EXAMPLES.md" ] && cp "$SCRIPT_DIR/EXAMPLES.md" "$INSTALL_DIR/"
[ -f "$SCRIPT_DIR/CHANGELOG.md" ] && cp "$SCRIPT_DIR/CHANGELOG.md" "$INSTALL_DIR/"

# Set permissions
print_info "Setting permissions..."
chmod 755 "$INSTALL_DIR/dali"
chmod 644 "$INSTALL_DIR/Dockerfile"
[ -f "$INSTALL_DIR/README.md" ] && chmod 644 "$INSTALL_DIR/README.md"
[ -f "$INSTALL_DIR/QUICKSTART.md" ] && chmod 644 "$INSTALL_DIR/QUICKSTART.md"
[ -f "$INSTALL_DIR/EXAMPLES.md" ] && chmod 644 "$INSTALL_DIR/EXAMPLES.md"
[ -f "$INSTALL_DIR/CHANGELOG.md" ] && chmod 644 "$INSTALL_DIR/CHANGELOG.md"

# Remove old symlink if exists
[ -L "/usr/local/bin/dali" ] && rm /usr/local/bin/dali
[ -f "/usr/local/bin/dali" ] && rm /usr/local/bin/dali

# Create symlink
print_info "Creating symlink in /usr/local/bin/..."
ln -s "$INSTALL_DIR/dali" /usr/local/bin/dali

# Create Docker network
print_info "Creating Docker network..."
NETWORK_NAME="dali_network"
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    print_info "Docker network already exists"
else
    docker network create "$NETWORK_NAME" >/dev/null 2>&1
    print_success "Docker network created: $NETWORK_NAME"
fi

# Create data directory
DATA_DIR="/opt/dali/data"
print_info "Creating data directory..."
if [ ! -d "$DATA_DIR" ]; then
    mkdir -p "$DATA_DIR"
    chmod 755 "$DATA_DIR"
    print_success "Data directory created: $DATA_DIR"
else
    print_info "Data directory already exists"
fi

# Verify installation
if command -v dali &> /dev/null; then
    print_success "Dali installed successfully for all users!"
    echo ""
    print_info "Installation directory: $INSTALL_DIR"
    print_info "Executable: /usr/local/bin/dali"
    print_info "Docker network: $NETWORK_NAME"
    print_info "Data directory: $DATA_DIR"
    echo ""
    print_info "All users can now use: dali <command>"
    echo ""
    print_info "Next steps (as any user):"
    echo "  1. dali build   # Build Kali image (~30 min)"
    echo "  2. dali create  # Create a container"
    echo "  3. dali shell   # Access container"
    echo ""
    print_warning "Note: Users need to be in the 'docker' group"
    print_info "Add user to docker group: sudo usermod -aG docker <username>"
    echo ""
else
    print_error "Installation failed"
    exit 1
fi

