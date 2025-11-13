# 📚 Dali - Practical Examples

Collection of practical usage examples for Dali.

## 🎯 Scenario 1: Quick Random Container

```bash
# Create with automatic name
./dali create

# Output:
# [INFO] Generated automatic name: stealth-fox-123
# [INFO] Creating Kali container 'stealth-fox-123' (WITHOUT VPN)...
# [OK] Kali container created
# [OK] Container 'stealth-fox-123' created successfully!

# List
./dali ls
# [INFO] Dali containers:
#   ● stealth-fox-123 (running) [NO VPN]

# Use
./dali shell stealth-fox-123
```

## 🌍 Scenario 2: Multiple Projects

```bash
# Internal project (without VPN)
./dali create internal-project

# Bug bounty client A (with VPN)
./dali create bugbounty-clientA --vpn us-west.conf

# Bug bounty client B (with VPN)
./dali create bugbounty-clientB --vpn eu-france.conf

# List all
./dali ls
# [INFO] Dali containers:
#   ● internal-project (running) [NO VPN]
#   ● bugbounty-clientA (running) [VPN]
#   ● bugbounty-clientB (running) [VPN]
```

## 🚀 Scenario 3: Quick Multiple Tests

```bash
# Create 3 containers quickly without thinking about names
./dali create
./dali create
./dali create

# Result:
# → cyber-wolf-111
# → stealth-hawk-222
# → shadow-tiger-333

./dali ls
# [INFO] Dali containers:
#   ● cyber-wolf-111 (running) [NO VPN]
#   ● stealth-hawk-222 (running) [NO VPN]
#   ● shadow-tiger-333 (running) [NO VPN]
```

## 🌐 Scenario 4: Multi-Region Pentest

```bash
# Create containers for different regions
./dali create us-target --vpn us-west.conf
./dali create eu-target --vpn eu-france.conf
./dali create asia-target --vpn asia-japan.conf

# Verify IPs
./dali checkip us-target
# → Public IP: X.X.X.X [VPN]
# → Country: United States

./dali checkip eu-target
# → Public IP: Y.Y.Y.Y [VPN]
# → Country: France

./dali checkip asia-target
# → Public IP: Z.Z.Z.Z [VPN]
# → Country: Japan
```

## 🔧 Scenario 5: VPN Testing

```bash
# Create container with VPN
./dali create vpn-test --vpn

# Check IP BEFORE running tests
./dali checkip vpn-test
# [INFO] Checking IP for 'vpn-test'...
# [OK] Public IP: 45.67.89.123 [VPN]
# [INFO] Country: Netherlands

# Run tests
./dali shell vpn-test
curl https://api.ipify.org
# → 45.67.89.123 (VPN IP confirmed)
exit

# Stop and restart (VPN persists)
./dali stop vpn-test
./dali start vpn-test
./dali checkip vpn-test
# → Same IP (Gluetun automatically reconnected)
```

## 🗑️ Deletion: `delete` vs `rm`

### Differences

**`delete`** - With confirmation and data choice
```bash
./dali delete pentest1

# Output:
# Are you sure you want to delete 'pentest1'? [y/N] y
# [INFO] Deleting 'pentest1'...
# [OK] Container 'pentest1' deleted
# Also delete data (/opt/dali/data/pentest1)? [y/N] 
```

**`rm`** - COMPLETE and FAST deletion (no confirmation)
```bash
# Deletes ALL: container + data + Gluetun
./dali rm pentest1

# Output:
# [INFO] Complete deletion of 'pentest1'...
# [INFO] Data deleted: /opt/dali/data/pentest1
# [OK] Container 'pentest1' and data deleted
```

### Use Cases

#### Use `delete` when:
- ✅ Important container - you want to be sure
- ✅ You want to keep the data
- ✅ You're unsure what to delete

#### Use `rm` when:
- ✅ Temporary/disposable container
- ✅ You want to delete EVERYTHING quickly
- ✅ Complete cleanup without questions
- ✅ Automated scripts
- ✅ Freeing disk space

### Practical Examples

```bash
# Quick workflow with rm
./dali create
# → stealth-fox-123 created
./dali shell stealth-fox-123
# ... work ...
exit
./dali rm stealth-fox-123
# → ALL deleted instantly (container + data)

# Container with VPN
./dali create mission1 --vpn us-west.conf
# ... pentest ...
./dali rm mission1
# → Deletes mission1_kali + Gluetun + /opt/dali/data/mission1

# Important container (keep data)
./dali create important-project
# ... work ...
./dali delete important-project
# → Asks confirmation + choice to keep/delete data
```

## 📁 Using the /data Folder

### Sharing Files Between Host and Container

```bash
# Create container
./dali create scan-web --vpn

# Copy wordlist from host
sudo cp /usr/share/wordlists/rockyou.txt /opt/dali/data/scan-web/

# In container
./dali shell scan-web
cd /data
ls -lh rockyou.txt  # File available immediately
dirsearch -u http://target.com -w rockyou.txt -o results.txt
exit

# On host - read results
cat /opt/dali/data/scan-web/results.txt
```

### Backing Up Scan Results

```bash
# In container
./dali shell pentest1
cd /data
nmap -A -oN full_scan.txt 192.168.1.0/24
nikto -h target.com -o nikto_scan.txt
exit

# On host - archive results
cd /opt/dali/data/pentest1
tar -czf results_$(date +%Y%m%d).tar.gz *.txt

# Backup elsewhere
cp results_*.tar.gz ~/Backups/
```

### Sharing Between Multiple Containers

```bash
# Create multiple containers
./dali create mission-A --vpn us-west.conf
./dali create mission-B --vpn eu-france.conf

# Scan with mission-A
./dali shell mission-A
cd /data
nmap -sV target.com -oN scan.txt
exit

# Copy results to mission-B
sudo cp /opt/dali/data/mission-A/scan.txt /opt/dali/data/mission-B/

# mission-B can now read results
./dali shell mission-B
cat /data/scan.txt
```

## 🔥 Practical One-Liners

```bash
# Create and access directly
./dali create && ./dali shell $(./dali list | tail -1 | awk '{print $2}')

# Create with VPN and check IP
name=$(./dali create --vpn 2>&1 | grep "Generated automatic name" | awk '{print $6}') && \
sleep 3 && ./dali checkip $name

# Stop all containers
./dali list | grep "running" | awk '{print $2}' | xargs -I {} ./dali stop {}

# Delete all stopped containers
./dali list | grep "stopped" | awk '{print $2}' | xargs -I {} ./dali rm {}

# Check IPs of all running containers
for c in $(./dali list | grep "running" | awk '{print $2}'); do 
  echo "=== $c ===" 
  ./dali checkip $c
done
```

## 🛠️ Advanced Workflows

### Workflow 1: Automated Pentest Pipeline

```bash
#!/bin/bash

# Create container with VPN
container=$(./dali create --vpn 2>&1 | grep "Generated" | awk '{print $6}')

# Wait for VPN
sleep 5

# Run automated scans
./dali shell $container << 'SCRIPT'
cd /data
echo "[*] Starting scans..."
nmap -sV target.com -oN nmap.txt
dirsearch -u http://target.com -o dirsearch.txt
nikto -h target.com -o nikto.txt
echo "[*] Scans complete!"
SCRIPT

# Archive results
tar -czf results_$container.tar.gz /opt/dali/data/$container/

# Cleanup
./dali rm $container
```

### Workflow 2: Testing Multiple VPN Servers

```bash
#!/bin/bash

vpn_configs=("us-west.conf" "eu-france.conf" "asia-japan.conf")

for config in "${vpn_configs[@]}"; do
    name="test-${config%.conf}"
    ./dali create $name --vpn $config
    sleep 8
    ./dali checkip $name
    ./dali rm $name
done
```

### Workflow 3: Parallel Scanning

```bash
#!/bin/bash

targets=("target1.com" "target2.com" "target3.com")

for target in "${targets[@]}"; do
    container=$(./dali create 2>&1 | grep "Generated" | awk '{print $6}')
    (
        ./dali shell $container << SCRIPT
cd /data
nmap -sV $target -oN scan_$target.txt
SCRIPT
    ) &
done

wait
echo "[*] All scans complete!"
```

## 📊 Useful dirsearch Commands

```bash
# In container
./dali shell pentest1

# Basic directory scan
cd /data
dirsearch -u http://target.com

# With custom wordlist
dirsearch -u http://target.com -w /data/custom_wordlist.txt

# Multiple extensions
dirsearch -u http://target.com -e php,html,js,txt

# Save results
dirsearch -u http://target.com -o results.txt

# Recursive scan
dirsearch -u http://target.com -r

# With specific status codes
dirsearch -u http://target.com -i 200,301,302

# Multiple URLs from file
dirsearch -l /data/urls.txt -o scan_results.txt
```

## 🎓 Tips and Tricks

### Tip 1: Quick Temporary Container
```bash
# Create, use, and delete in one session
alias quickhack='name=$(./dali create 2>&1 | grep Generated | awk "{print \$6}") && ./dali shell $name; ./dali rm $name'
```

### Tip 2: Save IP Before Tests
```bash
# Always check IP first
./dali checkip pentest1 | tee /opt/dali/data/pentest1/ip_used.txt
```

### Tip 3: Data Backup Before Deletion
```bash
# Auto-backup before rm
dali_safe_rm() {
    tar -czf ~/backup_$1_$(date +%Y%m%d).tar.gz /opt/dali/data/$1/
    ./dali rm $1
}
```

### Tip 4: Monitor All Containers
```bash
# Watch container status
watch -n 5 './dali list'
```

---

**More examples coming soon!** 🚀

