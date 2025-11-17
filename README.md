# 🛡️ Dali - Kali Container Manager with VPN

**Dali** is a CLI tool to easily manage isolated Kali Linux containers for pentesting, with **optional** Gluetun VPN integration via WireGuard or OpenVPN.

## ✨ Key Features

- ✅ **Complete Kali Linux** - Pre-built local image with 600+ tools
- ✅ **Optional VPN** - Choose whether to use VPN or not on each container
- ✅ **WireGuard & OpenVPN** - Automatic VPN connection via Gluetun (when desired)
- ✅ **Support for multiple VPN configurations** - Both .conf and .ovpn files
- ✅ **Interactive or direct choice** of VPN configuration
- ✅ **Containers without VPN** for local tests
- ✅ **Simple management** (start, stop, delete, rm)
- ✅ **Quick deletion** with `rm` - deletes ALL (container + data + Gluetun)
- ✅ **Interactive shell access**
- ✅ **IP/VPN verification** with mode indication
- ✅ **Persistent data** - bind mount on `/opt/dali/data/<name>` → `/data`
- ✅ **Complete image** kali-linux-large with 600+ pre-installed tools

## 🔧 Custom Image

Dali builds a local Docker image **dali-kali:latest** (~9 GB) which includes:

- **Base**: kalilinux/kali-rolling
- **Installation**: kali-linux-large (600+ tools)
- **Additional tools**: dirsearch (web directory scanner)
- **Customizable**: Modify the Dockerfile as needed

### First Download
⚠️ The first `dali build` will download ~9 GB and can take **20-40 minutes** depending on your connection. This is done **only once**. After that, container creation is instant!

## 🚀 Installation

### Prerequisites

- Root access (for system-wide installation)
- Docker (can be installed automatically during setup)
- VPN configuration files (optional, only for VPN mode):
  - WireGuard `.conf` files, OR
  - OpenVPN `.ovpn` files

### System-wide Installation (recommended)

Install Dali for all users on the system:

```bash
git clone <your-repo>
cd dali
chmod +x install.sh
sudo ./install.sh
```

This will:
- ✅ Install Docker automatically if not present (Ubuntu/Debian)
- ✅ Copy Dali to `/opt/dali/`
- ✅ Create symlink in `/usr/local/bin/dali`
- ✅ Create Docker network and data directory
- ✅ Add user to docker group
- ✅ Make it accessible to all users

After installation, log out and back in, then:

```bash
dali build        # No need for 'dali init'
dali create test
dali shell test
```

> **Note**: Log out and back in is required for docker group membership to take effect

### Local Installation (alternative)

For a single-user installation without sudo:

```bash
git clone <your-repo>
cd dali
chmod +x dali
./dali init
```

Then use `./dali` instead of `dali`.

### Uninstallation

To uninstall Dali from the system:

```bash
cd dali
sudo ./uninstall.sh
```

This will:
- ❌ Remove `/opt/dali/` directory
- ❌ Remove `/usr/local/bin/dali` symlink
- ℹ️  Keep containers, images, and data (manual cleanup available)

Optional cleanup after uninstall:

```bash
# Remove Docker images
docker rmi dali-kali:latest

# Remove Docker network
docker network rm dali_network

# Remove data directory
sudo rm -rf /opt/dali/data/

# Remove user configs (for each user)
rm -rf ~/.dali/
```

## 📖 Usage

### 1. Build the local Kali image

> Note: With system installation, `dali init` is automatically done. Only needed for local installation.

⚠️ **IMPORTANT**: Run this **once** before creating containers.

**Option A: LIGHT build (Recommended - Fast & Reliable)**

```bash
dali build light
```

This will:
- Download kalilinux/kali-rolling
- Install essential tools (nmap, metasploit, hydra, john, etc.)
- Install dirsearch
- Create the local image **dali-kali:latest**
- Takes ~5-10 minutes (only once)
- Size: ~4 GB

**Option B: FULL build (Complete Toolset)**

```bash
dali build
```

This will:
- Download kalilinux/kali-rolling
- Install kali-linux-large (600+ tools)
- Install dirsearch
- Create the local image **dali-kali:latest**
- Takes ~20-40 minutes (only once)
- Size: ~9 GB

> **Note**: If FULL build fails, use LIGHT build. See `BUILD_OPTIONS.md` for details.

### 2. Prepare your VPN configurations (optional)

Have your VPN config files ready. Dali supports:
- **WireGuard** (`.conf` files)
- **OpenVPN** (`.ovpn` files)

You can place them anywhere, e.g.:

```bash
mkdir -p ~/vpn-configs
cp my-wireguard.conf ~/vpn-configs/
cp my-openvpn.ovpn ~/vpn-configs/
```

### 3. Create a container

```bash
# Without VPN (local testing)
dali create local-test

# With VPN (interactive choice)
dali create pentest1 --vpn

# With specific WireGuard VPN
dali create pentest2 --vpn ~/vpn-configs/us-west.conf

# With specific OpenVPN
dali create pentest3 --vpn ~/vpn-configs/server.ovpn

# With automatic name (without VPN)
dali create

# With automatic name (with VPN)
dali create --vpn
```

### 4. Access the container shell

```bash
dali shell pentest1
```

You're now in the Kali container! All tools are pre-installed:

```bash
# Example - Web enumeration
nmap -sV target.com
dirsearch -u http://target.com
nikto -h target.com

# Data is persistent in /data
cd /data
echo "test" > results.txt
exit
```

### 5. Start a container

```bash
dali start pentest1
```

### 6. Check the IP

```bash
dali checkip pentest1
```

### 7. List all containers

```bash
dali ls
# or
dali list
```

### 8. Stop a container

```bash
dali stop pentest1
```

### 9. Delete a container

```bash
# Method 1: Quick deletion (ALL deleted)
dali rm pentest1              # Deletes container + data (no confirmation)

# Method 2: With confirmation and choice
dali delete pentest1          # Asks for confirmation + data choice
```

## 📦 Features

- ✅ Creation of isolated Kali containers
- ✅ **Optional VPN** - choose on container creation
- ✅ Automatic WireGuard VPN connection via Gluetun (if desired)
- ✅ Support for multiple WireGuard configurations
- ✅ Interactive or direct choice of VPN config
- ✅ Containers without VPN for local tests
- ✅ Simple management (start, stop, delete, rm)
- ✅ **Quick deletion** with `rm` - deletes ALL (container + data + Gluetun)
- ✅ Interactive shell access
- ✅ IP/VPN verification with mode indication
- ✅ **Persistent data** - bind mount on `/opt/dali/data/<name>` → `/data`
- ✅ **Complete image** kali-linux-large with 600+ pre-installed tools

## 📋 Available Commands

| Command | Description |
|---------|-------------|
| `init` | Initialize Dali (create vpn/ folder) |
| `build` | Build local Kali image (kali-linux-large) |
| `create` | Create with random name (without VPN) |
| `create <name>` | Create a named container (without VPN) |
| `create --vpn` | Create with random name and VPN |
| `create <name> --vpn` | Create with VPN (interactive choice) |
| `create <name> --vpn file.conf` | Create with specific VPN |
| `start <name>` | Start a container |
| `stop <name>` | Stop a container |
| `delete <name>` | Delete (with confirmation + data choice) |
| `rm <name>` | Delete ALL (container + data, no confirmation) |
| `list` / `ls` | List all containers |
| `shell <name>` | Access container shell |
| `checkip <name>` | Check container's IP |
| `help` | Show help |

## 📚 Usage Scenarios

### Scenario 1: Pentest with VPN

```bash
# Create container with VPN
dali create pentest1 --vpn ~/vpn-configs/us-west.conf

# Check VPN is active
dali checkip pentest1
# Result: Public IP: X.X.X.X [VPN]

# Access container
dali shell pentest1

# Inside container - all tools ready
nmap -sV target.com
dirsearch -u http://target.com
exit
```

### Scenario 2: Local test (without VPN)

```bash
# Create container WITHOUT VPN
dali create local-test

# Check IP (your real IP)
dali checkip local-test
# Result: Public IP: X.X.X.X [NO VPN]

# Use normally
dali shell local-test

# Delete ALL quickly when done
dali rm local-test
# → Container + data deleted
```

### Scenario 3: Multiple containers with different VPNs

```bash
# Create US container with VPN
dali create us-mission --vpn ~/vpn-configs/us-west.conf

# Create EU container with VPN
dali create eu-mission --vpn ~/vpn-configs/eu-france.conf

# Create local container
dali create local-tests

# List all
dali ls
# Result:
#   ● us-mission (running) [VPN]
#   ● eu-mission (running) [VPN]
#   ● local-tests (running) [NO VPN]
```

## 📁 Persistent Data

Each container has a persistent data directory:
- **On host**: `/opt/dali/data/<container_name>`
- **In container**: `/data`

Files placed in `/data` (in the container) are automatically saved on the host and persist between restarts and deletions/recreations.

### Usage Examples

```bash
# In container - save nmap scan
dali shell pentest1
cd /data
nmap -sV -oN scan_results.txt target.com
exit

# On host - read results
cat /opt/dali/data/pentest1/scan_results.txt

# Copy files from host to container
cp /home/user/wordlist.txt /opt/dali/data/pentest1/
# → Available immediately in container at /data/wordlist.txt

# Share files between multiple containers
cp /opt/dali/data/pentest1/results.txt /opt/dali/data/pentest2/
```

## 🔑 WireGuard File Format

Your `.conf` files must be in standard WireGuard format. Example:

```conf
[Interface]
PrivateKey = YOUR_PRIVATE_KEY
Address = 10.x.x.x/32
DNS = 1.1.1.1

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = vpn.example.com:51820
AllowedIPs = 0.0.0.0/0
```

## 🔧 Architecture

### Containers with VPN

- **Gluetun container**: Manages the VPN connection (WireGuard)
- **Kali container** (suffixed with `_kali`): Routes through Gluetun
- **Naming**: `name_kali` for the Kali container, `gluetun_<config>` for Gluetun
- **Gluetun reuse**: If a Gluetun for a VPN config already exists, it is reused

### Containers without VPN

- **Named**: `name`
- **Direct connection** (no VPN)
- **Displayed** with **[NO VPN]** badge
- **Perfect for local tests** or when VPN is not necessary

### General

- Docker network `dali_network` is created automatically
- Data is stored in `/opt/dali/data/<name>` (bind mount to `/data`)
- You can mix containers with and without VPN

---

**Simple, Flexible, Efficient** 🎯
