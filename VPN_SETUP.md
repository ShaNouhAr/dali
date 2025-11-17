# 🔐 VPN Setup Guide for Dali

Dali supports both **WireGuard** and **OpenVPN** configurations through Gluetun.

## Supported VPN Types

| Type | File Extension | Description |
|------|----------------|-------------|
| **WireGuard** | `.conf` | Modern, fast, secure VPN protocol |
| **OpenVPN** | `.ovpn` | Traditional, widely supported VPN protocol |

## 🔹 WireGuard Setup

### 1. Get your WireGuard config

From your VPN provider (Mullvad, ProtonVPN, etc.) or your own WireGuard server.

### 2. Save the config file

```bash
mkdir -p ~/vpn-configs
nano ~/vpn-configs/my-vpn.conf
```

### 3. WireGuard config example

```ini
[Interface]
PrivateKey = YOUR_PRIVATE_KEY_HERE
Address = 10.2.0.2/32
DNS = 10.64.0.1

[Peer]
PublicKey = SERVER_PUBLIC_KEY_HERE
AllowedIPs = 0.0.0.0/0
Endpoint = vpn.server.com:51820
```

### 4. Use with Dali

```bash
dali create pentest1 --vpn ~/vpn-configs/my-vpn.conf
```

## 🔹 OpenVPN Setup

### 1. Get your OpenVPN config

From your VPN provider or your own OpenVPN server.

### 2. Save the config file

```bash
mkdir -p ~/vpn-configs
# Download or copy your .ovpn file
cp downloaded.ovpn ~/vpn-configs/my-vpn.ovpn
```

### 3. OpenVPN config example

```conf
client
dev tun
proto udp
remote vpn.server.com 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-CBC
auth SHA256
verb 3

<ca>
-----BEGIN CERTIFICATE-----
YOUR_CA_CERTIFICATE_HERE
-----END CERTIFICATE-----
</ca>

<cert>
-----BEGIN CERTIFICATE-----
YOUR_CLIENT_CERTIFICATE_HERE
-----END CERTIFICATE-----
</cert>

<key>
-----BEGIN PRIVATE KEY-----
YOUR_PRIVATE_KEY_HERE
-----END PRIVATE KEY-----
</key>
```

### 4. Use with Dali

```bash
dali create pentest1 --vpn ~/vpn-configs/my-vpn.ovpn
```

## 📦 Common VPN Providers

### Mullvad (WireGuard)

1. Login to Mullvad account
2. Go to "WireGuard configuration"
3. Download `.conf` file
4. Use with Dali:

```bash
dali create mullvad-test --vpn ~/Downloads/mullvad-*.conf
```

### ProtonVPN (OpenVPN)

1. Login to ProtonVPN account
2. Go to "Downloads" → "OpenVPN configuration files"
3. Download desired server `.ovpn` file
4. Use with Dali:

```bash
dali create proton-test --vpn ~/Downloads/us-free-*.ovpn
```

### NordVPN (OpenVPN)

1. Login to NordVPN account
2. Go to "NordVPN" → "Download area"
3. Download server config (e.g., `us1234.nordvpn.com.udp.ovpn`)
4. Use with Dali:

```bash
dali create nord-test --vpn ~/Downloads/us1234.nordvpn.com.udp.ovpn
```

### Custom OpenVPN Server

If you have your own OpenVPN server:

```bash
# Make sure you have all required files
ls ~/vpn-configs/
# my-server.ovpn  (should contain embedded certs/keys)

dali create my-server --vpn ~/vpn-configs/my-server.ovpn
```

## 🔄 VPN Container Reuse

Dali is smart about VPN containers:

```bash
# First container creates new Gluetun
dali create test1 --vpn ~/vpn/us-east.conf
# Creates: test1_kali + gluetun_us-east

# Second container REUSES existing Gluetun
dali create test2 --vpn ~/vpn/us-east.conf
# Creates: test2_kali (shares gluetun_us-east)

# Different VPN = new Gluetun
dali create test3 --vpn ~/vpn/us-west.conf
# Creates: test3_kali + gluetun_us-west
```

**Benefits:**
- ✅ Saves resources
- ✅ Faster container creation
- ✅ Same exit IP for multiple containers

## ✅ Verify VPN is Working

After creating a container with VPN:

```bash
# Check public IP
dali checkip pentest1

# Expected output:
[OK] Public IP: 123.45.67.89 [VPN]
[INFO] Country: United States
```

## 🐛 Troubleshooting

### VPN not connecting

```bash
# Check Gluetun logs
docker logs gluetun_<config-name>

# Look for connection errors
```

### "invalid configuration" error

**For WireGuard (.conf):**
- Ensure `[Interface]` and `[Peer]` sections are present
- Check that PrivateKey and PublicKey are valid
- Verify Endpoint has correct format (host:port)

**For OpenVPN (.ovpn):**
- Ensure `client` directive is present
- Check that certificates/keys are embedded or referenced correctly
- Verify `remote` directive has correct format

### Container can't reach internet

```bash
# Restart Gluetun container
docker restart gluetun_<config-name>

# Wait 10 seconds
sleep 10

# Start your Kali container
dali start <name>

# Test connection
dali shell <name>
curl -s https://ifconfig.me
```

## 📚 Additional Resources

- **Gluetun docs**: https://github.com/qdm12/gluetun
- **WireGuard**: https://www.wireguard.com/
- **OpenVPN**: https://openvpn.net/

## 💡 Pro Tips

### Multiple VPN configs

Organize your configs:

```bash
mkdir -p ~/vpn-configs/{wireguard,openvpn}
mv *.conf ~/vpn-configs/wireguard/
mv *.ovpn ~/vpn-configs/openvpn/

# Use them
dali create wg-test --vpn ~/vpn-configs/wireguard/us.conf
dali create ovpn-test --vpn ~/vpn-configs/openvpn/server.ovpn
```

### Naming conventions

Use descriptive Gluetun container names by naming your config files clearly:

```bash
# Good naming
us-west-mullvad.conf     → gluetun_us-west-mullvad
fr-paris-proton.ovpn     → gluetun_fr-paris-proton

# Bad naming
config1.conf             → gluetun_config1
download.ovpn            → gluetun_download
```

### Quick VPN switch

```bash
# Delete old VPN container
dali rm pentest1

# Recreate with different VPN
dali create pentest1 --vpn ~/vpn/different-server.ovpn
```

## 🔒 Security Notes

- Store VPN configs in a secure location
- Don't commit VPN configs to git repositories
- Use strong encryption (configs contain sensitive keys)
- Rotate VPN configs periodically

```bash
# Secure your configs
chmod 600 ~/vpn-configs/*.conf
chmod 600 ~/vpn-configs/*.ovpn
```

