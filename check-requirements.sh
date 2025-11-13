#!/bin/bash

#############################################
# KaliTool - Vérification des prérequis
#############################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Vérification des prérequis KaliTool ===${NC}\n"

all_ok=true

# Vérifier Docker
echo -n "Docker installé... "
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
    docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    echo "  Version: $docker_version"
else
    echo -e "${RED}✗${NC}"
    echo "  Docker n'est pas installé"
    echo "  Installation: https://docs.docker.com/engine/install/"
    all_ok=false
fi

# Vérifier que Docker tourne
echo -n "Docker démarré... "
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "  Docker n'est pas démarré"
    echo "  Commande: sudo systemctl start docker"
    all_ok=false
fi

# Vérifier les permissions Docker
echo -n "Permissions Docker... "
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠${NC}"
    echo "  Vous devrez peut-être utiliser sudo"
    echo "  Ou ajouter votre utilisateur au groupe docker:"
    echo "  sudo usermod -aG docker $USER"
fi

# Vérifier l'image Gluetun
echo -n "Image Gluetun... "
if docker images | grep -q "qmcgaw/gluetun"; then
    echo -e "${GREEN}✓${NC} (déjà téléchargée)"
else
    echo -e "${YELLOW}⚠${NC} (sera téléchargée au premier usage)"
fi

# Vérifier l'image Kali
echo -n "Image Kali Linux... "
if docker images | grep -q "kalilinux/kali-rolling"; then
    echo -e "${GREEN}✓${NC} (déjà téléchargée)"
else
    echo -e "${YELLOW}⚠${NC} (sera téléchargée au premier usage)"
fi

# Vérifier le dossier vpn
echo -n "Dossier vpn/... "
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/vpn" ]; then
    conf_count=$(ls -1 "$SCRIPT_DIR/vpn"/*.conf 2>/dev/null | wc -l)
    if [ $conf_count -gt 0 ]; then
        echo -e "${GREEN}✓${NC} ($conf_count config(s) trouvée(s))"
    else
        echo -e "${YELLOW}⚠${NC} (aucune config WireGuard)"
        echo "  Ajoutez vos fichiers .conf dans vpn/"
    fi
else
    echo -e "${YELLOW}⚠${NC} (n'existe pas encore)"
    echo "  Sera créé avec 'kalitool init'"
fi

# Vérifier l'espace disque
echo -n "Espace disque... "
available=$(df -h . | awk 'NR==2 {print $4}')
echo -e "${GREEN}✓${NC}"
echo "  Disponible: $available"
echo "  Recommandé: Au moins 5 GB pour les images"

echo ""

if $all_ok; then
    echo -e "${GREEN}=== ✓ Tout est prêt! ===${NC}"
    echo ""
    echo "Prochaines étapes:"
    echo "  1. ./kalitool init"
    echo "  2. cp vos-configs/*.conf vpn/"
    echo "  3. ./kalitool create pentest1"
else
    echo -e "${RED}=== ✗ Certains prérequis manquent ===${NC}"
    echo ""
    echo "Installez les éléments manquants puis relancez ce script."
fi

