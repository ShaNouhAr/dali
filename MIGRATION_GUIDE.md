# 🔄 Guide de Migration - VPN Optionnel

KaliTool v1.1.0 introduit la possibilité de créer des conteneurs **avec ou sans VPN**.

## 📊 Comparaison

### Avant (v1.0.0)
```bash
kalitool create pentest1        # VPN obligatoire
```

### Maintenant (v1.1.0+)
```bash
kalitool create pentest1         # SANS VPN (par défaut)
kalitool create pentest1 --vpn   # AVEC VPN
```

## 🆕 Nouvelles options

### Créer un conteneur SANS VPN (nouveau)

```bash
# Syntaxe simple
kalitool create local

# Ou explicitement
kalitool create local --no-vpn
```

**Cas d'usage :**
- Tests locaux
- Développement
- Apprentissage
- Scan de votre réseau local

### Créer un conteneur AVEC VPN (amélioré)

```bash
# Choix interactif
kalitool create pentest1 --vpn

# Config spécifique
kalitool create pentest1 --vpn us-west.conf
```

**Cas d'usage :**
- Bug bounty
- Pentest externe
- Anonymat
- Contournement géographique

## 🎨 Nouvelles indications visuelles

### Commande `list`

```bash
$ kalitool list

Conteneurs KaliTool:

  ● pentest1 (en cours) [VPN]      ← Avec VPN
  ● local (en cours) [NO VPN]       ← Sans VPN
  ● us-mission (arrêté) [VPN]       ← Avec VPN
```

### Commande `checkip`

```bash
$ kalitool checkip pentest1
[OK] IP publique: 1.2.3.4 [VPN]   ← Indication du mode
[INFO] Pays: United States

$ kalitool checkip local
[OK] IP publique: 5.6.7.8 [NO VPN]  ← IP réelle
[INFO] Pays: France
```

## ✅ Compatibilité

Toutes les commandes existantes fonctionnent avec les deux types de conteneurs :
- `start`, `stop`, `delete`
- `shell`
- `checkip`
- `list`

Le script détecte automatiquement le type de conteneur.

## 🔧 Architecture technique

### Conteneur SANS VPN
```
[Kali Container]
    ↓
[kalitool_network]
    ↓
[Hôte Docker]
```

### Conteneur AVEC VPN
```
[Kali Container] ←→ [Gluetun Container]
                         ↓
                    [WireGuard VPN]
                         ↓
                     [Internet]
```

## 💡 Recommandations

1. **Tests locaux** → Utilisez sans VPN pour plus de rapidité
2. **Pentest externe** → Utilisez avec VPN pour l'anonymat
3. **Mélange possible** → Vous pouvez avoir les deux types simultanément

## 📚 Documentation

- [README.md](README.md) - Documentation complète
- [QUICKSTART.md](QUICKSTART.md) - Guide de démarrage rapide
- [CHANGELOG.md](CHANGELOG.md) - Historique détaillé des versions

