# 📝 Changelog

All notable changes to this project will be documented in this file.

## [1.9.0] - 2025-11-17

### 🔐 OpenVPN Support

#### Major additions
- ✅ **OpenVPN support** - Now accepts `.ovpn` files in addition to `.conf`
- ✅ **Automatic VPN type detection** - Based on file extension
- ✅ **Dual VPN protocol support** - WireGuard AND OpenVPN
- ✅ **Unified interface** - Same commands for both VPN types

#### Technical improvements
- 🔧 **New function**: `get_vpn_type()` - Detects if config is WireGuard or OpenVPN
- 🔧 **Updated function**: `check_vpn_file()` - Now validates both `.conf` and `.ovpn`
- 🔧 **Smart Gluetun creation** - Adapts configuration based on VPN type
  - WireGuard: mounts to `/gluetun/wireguard/wg0.conf`
  - OpenVPN: mounts to `/gluetun/custom.conf` with `OPENVPN_CUSTOM_CONFIG`

#### Updated messages
- 📝 Interactive prompt now mentions both file types
- 📝 Help updated with examples for both protocols
- 📝 `list` command shows VPN type in brackets

#### New documentation
- 📖 **VPN_SETUP.md** - Complete guide for WireGuard and OpenVPN setup
- 📖 Examples for major VPN providers (Mullvad, ProtonVPN, NordVPN)
- 📖 Troubleshooting section for VPN issues

#### Usage examples
```bash
# WireGuard
dali create pentest1 --vpn ~/vpn/server.conf

# OpenVPN
dali create pentest2 --vpn ~/vpn/server.ovpn

# Interactive (both types)
dali create --vpn
# Will ask: "Enter path to VPN config (.conf or .ovpn)"
```

---

## [1.5.0] - 2025-11-13

### 🔗 Bind mount system for persistent data

#### Major change
- ✅ **Bind mount instead of Docker volumes** - Data accessible on host
- ✅ Storage on host: `/opt/dali/data/<container_name>`
- ✅ Mount point in container: `/data`
- ✅ Automatic directory creation during initialization
- ✅ Permissions automatically managed (chmod 755)

#### Advantages
- 📁 **Direct access to data** from host
- 📁 **Easy sharing** of files between host and container
- 📁 **Simplified backup** - visible directory in `/opt/dali/data/`
- 📁 **Easy migration** - copy/paste the folder
- 📁 **No hidden Docker volume** - everything is transparent

#### Updated commands
- `init` → Creates `/opt/dali/data/` with sudo
- `create` → Automatically mounts `/opt/dali/data/<name>` to `/data`
- `delete` → Asks for confirmation to delete `/opt/dali/data/<name>`
- `rm` → Automatically deletes `/opt/dali/data/<name>` without confirmation

#### Updated Dockerfile
- 📄 Creation of `/data` folder in image
- 📄 Replacement of `/root/workspace` with `/data`

#### `ls` alias
- ✅ **New command** - `dali ls` is now an alias for `dali list`
- ✅ Faster to type, more intuitive

---

## [1.4.0] - 2025-11-13

### 🏗️ Local image build system

#### New `build` command
- ✅ **`dali build`** - Builds a custom local Kali image
- ✅ Uses `kalilinux/kali-rolling` + `apt install kali-linux-large`
- ✅ Creates the `dali-kali:latest` image (~9 GB)
- ✅ Build once, reused for all containers
- ✅ Easy update with `dali build`

#### Automatic image check
- ⚠️ Warning if image doesn't exist during `create`
- ⚠️ Clear message to run `dali build` first
- ⚠️ Prevents creating containers without the image

#### Included Dockerfile
- 📄 Dockerfile in the project
- 📄 Base: `kalilinux/kali-rolling`
- 📄 Install: `kali-linux-large` (600+ tools)
- 📄 Additional tools: **dirsearch** (web directory scanner)
- 📄 Customizable as needed

---

## [1.3.0] - 2025-11-13

### ✨ New command: `rm`

#### Quick and complete deletion
- ✅ **`rm` command** - deletion without confirmation
- ✅ `dali rm <name>` - deletes **ALL**: container + data + Gluetun
- ✅ Pure and simple deletion, no questions asked
- ✅ Automatically handles containers with and without VPN
- ✅ Ideal for temporary containers and quick cleanup

---

## [1.2.0] - 2025-11-13

### ✨ New features

#### Automatic names
- ✅ **Automatic name generation** if not specified
- ✅ Format: `adjective-noun-number` (e.g., `stealth-fox-123`)
- ✅ Cool and memorable names for your containers
- ✅ `dali create` → generates automatic name
- ✅ `dali create --vpn` → generates name with VPN

#### Bug fixes
- 🐛 Fix: The `list` command now correctly displays container status without VPN
- 🐛 Fix: "Running" containers display correctly (no more false "stopped")

---

## [1.1.0] - 2025-11-13

### ✨ Major new feature: Optional VPN

#### Changes
- ✅ **VPN now optional** - you choose on container creation
- ✅ Ability to create containers **without VPN** for local tests
- ✅ Ability to create containers **with VPN** for external pentest
- ✅ `--vpn` option to enable Gluetun
- ✅ Visual badges **[VPN]** and **[NO VPN]** in all commands
- ✅ `list` command shows mode of each container
- ✅ `checkip` command indicates if VPN is active
- ✅ Updated documentation with examples for both modes

#### Updated commands
- `create <name>` → Creates container without VPN
- `create <name> --vpn` → Creates with VPN (interactive choice)
- `create <name> --vpn file.conf` → Creates with specific VPN
- All other commands automatically handle both types

---

## [1.0.0] - 2025-11-13

### ✨ First version

#### Features
- ✅ Complete Kali Linux container management
- ✅ WireGuard VPN integration via Gluetun
- ✅ Support for multiple WireGuard configurations
- ✅ Interactive or direct choice of VPN configuration
- ✅ Persistent data per container
- ✅ Automatic installation of basic tools
- ✅ IP/VPN verification
- ✅ Colorful and intuitive CLI interface

#### Available commands
- `init` - Initialization and vpn/ folder creation
- `create` - Create new container with VPN
- `start` - Start a container
- `stop` - Stop a container
- `delete` - Delete a container
- `list` - List all containers
- `shell` - Access container shell
- `checkip` - Check container's public IP

#### Architecture
- Gluetun container for WireGuard VPN
- Kali Linux container routing via Gluetun
- Dedicated Docker network `dali_network`
- Docker volumes for persistence

#### Pre-installed tools
- kali-linux-core
- nmap
- curl, wget
- git
- netcat-traditional

#### Documentation
- Complete README.md
- QUICKSTART.md for quick start
- Guide on WireGuard configurations
- .conf file examples
