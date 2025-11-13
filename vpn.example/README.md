# 🔑 Configurations WireGuard

Ce dossier contient un exemple de fichier de configuration WireGuard.

## Comment obtenir vos fichiers .conf ?

### Fournisseurs VPN populaires

**Mullvad VPN** (Recommandé pour l'anonymat)
- Site: https://mullvad.net
- Télécharger les configs: Account → WireGuard configuration
- Format: Directement au format .conf

**ProtonVPN**
- Site: https://protonvpn.com
- Downloads → WireGuard configuration
- Sélectionnez votre serveur et téléchargez le .conf

**NordVPN**
- Nécessite d'extraire les configs manuellement
- Ou utiliser: https://github.com/whitefox82/NordVPN-WireGuard-Config-Generator

**IVPN**
- Site: https://ivpn.net
- Account → WireGuard → Generate Config

### Votre propre serveur WireGuard

Si vous avez votre propre serveur WireGuard:
1. Générez une paire de clés sur le serveur
2. Créez le fichier .conf avec les informations du serveur
3. Copiez-le dans le dossier `vpn/`

## Structure du fichier .conf

```ini
[Interface]
PrivateKey = VOTRE_CLE_PRIVEE
Address = 10.x.x.x/32        # IP attribuée au client
DNS = 1.1.1.1                # Serveur DNS à utiliser

[Peer]
PublicKey = CLE_PUBLIQUE_SERVEUR
Endpoint = server.vpn.com:51820  # Adresse du serveur VPN
AllowedIPs = 0.0.0.0/0, ::/0     # Tout le trafic via VPN
PersistentKeepalive = 25         # Maintenir la connexion active
```

## 🚨 Sécurité

**IMPORTANT:**
- ⚠️ Ne jamais partager vos fichiers .conf (contiennent votre clé privée)
- ⚠️ Ne jamais commiter vos .conf dans Git
- ⚠️ Le dossier `vpn/` est dans .gitignore pour votre protection

## Utilisation avec KaliTool

```bash
# 1. Copier vos configs dans le dossier vpn/
mkdir -p ../vpn
cp mes-configs/*.conf ../vpn/

# 2. Créer un conteneur
cd ..
./kalitool create pentest1

# 3. Vérifier l'IP
./kalitool checkip pentest1
```

