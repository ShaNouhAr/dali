# 📦 Dali Installation Guide

## System-wide Installation (Recommended)

Install Dali for all users on the system.

### Prerequisites

- Root/sudo access
- Internet connection
- Supported OS: Ubuntu or Debian

> **Note**: Docker will be installed automatically if not present

### What Gets Installed

The installation script will:

1. **Check for Docker**
   - If not found, ask if you want to install it
   - Automatically install Docker from official repository
   - Support for Ubuntu and Debian

2. **Setup Docker**
   - Add user to docker group
   - Start and enable Docker service

3. **Install Dali**
   - Copy files to `/opt/dali/`
   - Create system-wide command
   - Setup network and data directory

### Installation Steps

1. **Clone the repository**

```bash
git clone <your-repo>
cd dali
```

2. **Run the installation script**

```bash
chmod +x install.sh
sudo ./install.sh
```

This will:
- ✅ Install Docker if not present (asks for confirmation)
- ✅ Add user to docker group automatically
- ✅ Copy all files to `/opt/dali/`
- ✅ Create symlink in `/usr/local/bin/dali`
- ✅ Create Docker network (`dali_network`)
- ✅ Create data directory (`/opt/dali/data/`)
- ✅ Set proper permissions
- ✅ Make `dali` available to all users

3. **Log out and back in**

For docker group membership to take effect:

```bash
exit
# Log back in
```

4. **Verify installation**

```bash
dali help
```

### Post-Installation

Build the Kali image (only once, ~20-40 min):

```bash
dali build
```

> Note: `dali init` is automatically done during installation

Start using Dali:

```bash
dali create test
dali shell test
```

## Local Installation (Alternative)

For single-user installation without root access.

### Installation Steps

1. **Clone the repository**

```bash
git clone <your-repo>
cd dali
```

2. **Make executable**

```bash
chmod +x dali
```

3. **Use with relative path**

```bash
./dali init
./dali build
./dali create test
```

### Optional: Add to PATH

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$PATH:/path/to/dali"
```

Then:

```bash
source ~/.bashrc
dali help
```

## Uninstallation

### System-wide

```bash
cd dali
sudo ./uninstall.sh
```

### Optional Cleanup

After uninstalling, you may want to remove:

```bash
# Docker images
docker rmi dali-kali:latest

# Docker network
docker network rm dali_network

# Data directory
sudo rm -rf /opt/dali/data/

# User configurations
rm -rf ~/.dali/
```

## Docker Group Setup

### Check if user is in docker group

```bash
groups $USER
```

### Add user to docker group

```bash
sudo usermod -aG docker $USER
```

### Apply changes

```bash
# Method 1: Log out and log back in
exit

# Method 2: Create new shell with group
newgrp docker

# Method 3: Reboot
sudo reboot
```

### Verify docker access

```bash
docker ps
# Should work without sudo
```

## Troubleshooting

### Docker installation fails

**Problem**: Automatic Docker installation failed

**Solution 1**: Install Docker manually
```bash
# Follow official guide
https://docs.docker.com/engine/install/
```

**Solution 2**: Check OS compatibility
```bash
cat /etc/os-release
# Supported: Ubuntu, Debian
```

### "Permission denied" when running docker

**Problem**: User not in docker group

**Solution**:
```bash
sudo usermod -aG docker $USER
# Log out and back in
```

Or reinstall with:
```bash
sudo ./install.sh
# Accepts adding user to docker group
```

### "dali: command not found"

**For system installation**:
- Check if installed: `ls -l /usr/local/bin/dali`
- Reinstall: `sudo ./install.sh`

**For local installation**:
- Use `./dali` instead of `dali`
- Or add to PATH

### "Dockerfile not found"

**Problem**: Installation incomplete

**Solution**: Reinstall with `sudo ./install.sh`

### "Docker is not running"

**Problem**: Docker daemon not started

**Solution**:
```bash
sudo systemctl start docker
sudo systemctl enable docker  # Start on boot
```

## Files Installed

### System-wide Installation

```
/opt/dali/
├── dali              # Main script
├── Dockerfile        # Image build definition
├── README.md         # Documentation
├── QUICKSTART.md     # Quick guide
├── EXAMPLES.md       # Usage examples
└── CHANGELOG.md      # Version history

/usr/local/bin/
└── dali              # Symlink to /opt/dali/dali

/opt/dali/data/
└── <containers>/     # Container data (created on init)
```

### Local Installation

```
~/dali/               # Or wherever you cloned it
├── dali              # Main script
├── Dockerfile
├── README.md
└── ...
```

## Next Steps

After installation:

1. **Build image**: `dali build` (~30 min first time)
2. **Create container**: `dali create test`
3. **Access shell**: `dali shell test`
4. **Check IP**: `dali checkip test`
5. **List containers**: `dali ls`

> Note: `dali init` is automatically done during system installation

See `README.md` for complete usage guide.

