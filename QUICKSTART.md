# 🚀 Dali - Quick Start

Get started with Dali in 5 minutes!

## 📦 Installation

```bash
# Clone the repository
git clone <your-repo>
cd dali

# Make executable
chmod +x dali

# Initialize
./dali init
```

## 🏗️ First Use - Build the Image

⚠️ **Important**: Build the local Kali image ONCE before creating containers.

```bash
./dali build
```

This takes ~20-40 minutes (only once). It installs 600+ pentest tools.

☕ Go grab a coffee!

---

## 🎯 Quick Usage

### Scenario 1: Pentest with VPN

```bash
# Add your WireGuard config
cp my-vpn.conf vpn/

# Create container with VPN
./dali create pentest1 --vpn

# Choose your VPN config interactively
# → Select: 1

# Check VPN is working
./dali checkip pentest1
# → Public IP: X.X.X.X [VPN]
# → Country: United States (example)

# Access container
./dali shell pentest1
```

### Scenario 2: Quick Test (without VPN)

```bash
# Create container WITHOUT VPN
./dali create local

# Instant creation (image already built)
# Access immediately
./dali shell local
```

---

## 📁 Persistent Data

Each container has its own data directory:
- **Host**: `/opt/dali/data/<container_name>`
- **Container**: `/data`

```bash
# In container
cd /data
nmap target.com -oN scan.txt

# On host (in another terminal)
cat /opt/dali/data/pentest1/scan.txt

# Copy files from host
sudo cp wordlist.txt /opt/dali/data/pentest1/
```

---

## Essential Commands

```bash
# List your containers
./dali ls

# Result:
#   ● pentest1 (running) [VPN]
#   ● local (running) [NO VPN]

# Stop
./dali stop pentest1

# Restart
./dali start pentest1

# Delete (with confirmation)
./dali delete pentest1

# Quick delete ALL (no confirmation)
./dali rm local
```

---

## 💡 Pro Tips

### Quick Workflow with Random Names

```bash
# Create with automatic name
./dali create --vpn

# Generated name: stealth-fox-123

# Use it
./dali shell stealth-fox-123

# Quick cleanup
./dali rm stealth-fox-123
```

### Multiple Containers, Multiple VPNs

```bash
# Create US container with VPN
./dali create us-mission --vpn us-west.conf

# Create EU container with VPN
./dali create eu-mission --vpn eu-france.conf

# Create local container without VPN
./dali create local-tests

# List all
./dali ls
# Result:
#   ● us-mission (running) [VPN]
#   ● eu-mission (running) [VPN]
#   ● local-tests (running) [NO VPN]
```

### Check IPs

```bash
# Check US container
./dali checkip us-mission
# → Public IP: X.X.X.X [VPN]
# → Country: United States

# Check EU container
./dali checkip eu-mission
# → Public IP: Y.Y.Y.Y [VPN]
# → Country: France

# Check local container
./dali checkip local-tests
# → Public IP: Z.Z.Z.Z [NO VPN]
```

---

## 🛠️ All Pre-installed Tools

The `dali-kali:latest` image includes **600+ tools** from kali-linux-large:

**Network Analysis**:
- nmap, masscan, zmap
- wireshark, tcpdump
- netcat, socat

**Web**:
- burpsuite, sqlmap
- nikto, dirsearch
- wpscan, whatweb

**Exploitation**:
- metasploit-framework
- exploit-db
- commix

**Password Attacks**:
- john, hashcat
- hydra, medusa
- crunch

**Wireless**:
- aircrack-ng
- reaver, pixiewps
- wifite

**And many more...**

---

## 📚 Full Documentation

For complete documentation, see:
- `README.md` - Full documentation
- `EXAMPLES.md` - Practical examples
- `CHANGELOG.md` - Version history

---

**Happy Hacking! 🎯**
