#!/usr/bin/env bash

# ============================================================
#  install.sh — Installiert den "fokus" Website-Blocker
# ============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BOLD}  fokus — Installation${NC}"
echo ""

# Überprüfungen
if [[ ! -f "$SCRIPT_DIR/fokus.py" ]]; then
    echo -e "  ${RED}Fehler:${NC} fokus.py wurde nicht im Ordner gefunden."
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo -e "  ${RED}Fehler:${NC} python3 ist nicht installiert."
    exit 1
fi

if ! command -v chattr &>/dev/null; then
    echo -e "  ${RED}Warnung:${NC} 'chattr' nicht gefunden. Manipulationsschutz könnte eingeschränkt sein."
    echo -e "  Bitte installiere 'e2fsprogs' (Arch: pacman -S e2fsprogs, Ubuntu: apt install e2fsprogs)"
    echo ""
fi

# Installation
sudo cp "$SCRIPT_DIR/fokus.py" /usr/local/bin/fokus
sudo chmod +x /usr/local/bin/fokus
echo -e "  ${GREEN}✓${NC} fokus installiert nach /usr/local/bin/fokus"

# Backup der hosts-Datei (falls nicht existent)
if [[ ! -f /etc/hosts.backup ]]; then
    sudo cp /etc/hosts /etc/hosts.backup
    echo -e "  ${GREEN}✓${NC} Backup erstellt: /etc/hosts.backup"
fi

# Initiale Config erstellen
sudo fokus status > /dev/null
echo -e "  ${GREEN}✓${NC} Konfiguration angelegt in /etc/fokus.conf"

echo ""
echo -e "  ${GREEN}${BOLD}Installation abgeschlossen!${NC}"
echo ""
echo -e "  Befehle:"
echo -e "  ${CYAN}sudo fokus start${NC}           Blockierung aktivieren"
echo -e "  ${CYAN}sudo fokus stop${NC}            Blockierung aufheben"
echo -e "  ${CYAN}sudo fokus lock 60${NC}         Stop-Befehl für 60 Min. sperren"
echo -e "  ${CYAN}fokus status${NC}               Status abfragen"
echo ""
