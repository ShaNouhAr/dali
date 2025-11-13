.PHONY: install uninstall test help

help:
	@echo "KaliTool - Makefile"
	@echo ""
	@echo "Commandes disponibles:"
	@echo "  make install    - Installer kalitool dans /usr/local/bin"
	@echo "  make uninstall  - Désinstaller kalitool"
	@echo "  make test       - Tester l'installation Docker"
	@echo "  make help       - Afficher cette aide"

install:
	@echo "Installation de kalitool..."
	@chmod +x kalitool
	@sudo ln -sf $(PWD)/kalitool /usr/local/bin/kalitool
	@echo "✓ KaliTool installé dans /usr/local/bin/kalitool"
	@echo ""
	@echo "Vous pouvez maintenant utiliser: kalitool init"

uninstall:
	@echo "Désinstallation de kalitool..."
	@sudo rm -f /usr/local/bin/kalitool
	@echo "✓ KaliTool désinstallé"

test:
	@echo "Test de l'environnement..."
	@docker --version || (echo "✗ Docker non installé" && exit 1)
	@docker ps > /dev/null 2>&1 || (echo "✗ Docker non démarré" && exit 1)
	@echo "✓ Docker est opérationnel"
	@echo ""
	@echo "Prêt à utiliser KaliTool!"

