# 🏗️ Dali Build Options

Dali offers two build options for the Kali image: **FULL** and **LIGHT**.

## 🎯 Quick Comparison

| Option | Time | Size | Tools | Use Case |
|--------|------|------|-------|----------|
| **LIGHT** | ~10 min | ~4 GB | Essential (~30) | Most pentests, faster builds |
| **FULL** | ~30 min | ~9 GB | Complete (600+) | Advanced testing, all tools |

## 🚀 LIGHT Build (Recommended)

**Fast and practical** - Contains all essential tools for 90% of pentests.

### Build Command

```bash
dali build light
```

### Build Time

- ⏱️ **5-10 minutes** (vs 30-40 min for FULL)
- Much more reliable (less likely to fail)

### Included Tools

#### Network Scanning
- nmap
- masscan
- netcat-traditional

#### Web Testing
- nikto
- dirb
- sqlmap
- gobuster
- wfuzz
- ffuf
- dirsearch

#### Exploitation
- metasploit-framework
- exploitdb

#### Password Cracking
- hydra
- john
- hashcat

#### Wireless
- aircrack-ng

#### Network Analysis
- wireshark
- tcpdump

#### Web Proxies
- burpsuite
- zaproxy

#### Wordlists
- wordlists
- seclists

#### Development
- git
- python3
- pip
- curl
- wget

### When to Use LIGHT

✅ Most penetration tests  
✅ CTF competitions  
✅ Web application testing  
✅ Network scanning  
✅ Quick deployments  
✅ Limited disk space  
✅ Faster container creation  

## 📦 FULL Build

**Complete toolset** - All 600+ Kali tools from `kali-linux-large` package.

### Build Command

```bash
dali build
# OR
dali build full
```

### Build Time

- ⏱️ **20-40 minutes**
- Can fail due to package conflicts (use LIGHT if issues)

### What's Included

Everything from LIGHT, plus:
- 600+ additional tools from kali-linux-large
- Specialized tools for:
  - Reverse engineering
  - Binary exploitation
  - Hardware hacking
  - Forensics
  - Reporting tools
  - And much more...

### When to Use FULL

✅ Advanced penetration testing  
✅ Need specialized tools  
✅ Full Kali desktop experience  
✅ One-time build for complete toolset  
✅ Stable internet connection  
✅ Plenty of disk space  

## 🔧 Build Issues?

### FULL Build Fails

If the FULL build fails (like dpkg errors):

**Solution 1**: Use LIGHT build (recommended)
```bash
dali build light
```

**Solution 2**: Retry FULL build (improved error handling)
```bash
dali build
```

The Dockerfile now includes:
- Automatic error recovery
- Fixed package handling
- Better reliability

**Solution 3**: Manual fix
```bash
# Remove failed build
docker rmi dali-kali:latest

# Try again
dali build light
```

## 💡 Recommendations

### For Most Users
```bash
dali build light
```
- Faster
- More reliable
- Has everything you need
- Easy to rebuild

### For Advanced Users
```bash
dali build
```
- Complete toolset
- All Kali capabilities
- One-time setup

### If Space is Limited
```bash
dali build light
```
- Saves ~5 GB per image

### If Time is Limited
```bash
dali build light
```
- 3-4x faster build

## 🔄 Switching Between Versions

You can rebuild at any time:

```bash
# Currently have FULL, want LIGHT
docker rmi dali-kali:latest
dali build light

# Currently have LIGHT, want FULL
docker rmi dali-kali:latest
dali build
```

> **Note**: Existing containers will continue to work even after rebuilding the image.

## 📊 Disk Space

### LIGHT Build
- Base image: ~0.5 GB
- After build: ~3-4 GB
- Per container: +50-100 MB

### FULL Build
- Base image: ~0.5 GB
- After build: ~9-10 GB
- Per container: +50-100 MB

Check your space:
```bash
df -h /var/lib/docker
docker images
```

## 🎓 Examples

### Quick Pentest Setup
```bash
# Install Dali
sudo ./install.sh

# Build LIGHT (fast)
dali build light

# Create and use
dali create pentest1
dali shell pentest1
nmap -sV target.com
```

### Full Toolset Setup
```bash
# Install Dali
sudo ./install.sh

# Build FULL (patient mode)
dali build

# Create and use
dali create advanced
dali shell advanced
# All 600+ tools available
```

## ❓ FAQ

**Q: Can I add tools later to LIGHT?**  
A: Yes! Inside container: `apt install <tool>`

**Q: Which is more stable?**  
A: LIGHT build is generally more reliable

**Q: Do containers differ?**  
A: Only in pre-installed tools

**Q: Can I have both?**  
A: No, one image at a time. Rebuild to switch.

**Q: What if FULL fails?**  
A: Use `dali build light` - works 99% of the time

## 🔗 See Also

- `README.md` - Complete documentation
- `QUICKSTART.md` - Getting started guide
- `EXAMPLES.md` - Usage examples

