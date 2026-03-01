#!/bin/bash
# infrastructure-docs-collector.sh
# Sammelt alle Docker-Compose-Files und Configs für das Infrastructure Documentation Repository

set -e  # Exit bei Fehlern

# Farben für Output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Basis-Verzeichnis
BASE_DIR="$HOME/infrastructure-docs"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Infrastructure Documentation Collector${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Prüfe ob Verzeichnis existiert
if [ -d "$BASE_DIR" ]; then
    echo -e "${YELLOW}⚠️  Warnung: $BASE_DIR existiert bereits!${NC}"
    read -p "Möchtest du fortfahren? (Dies könnte Dateien überschreiben) [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Abgebrochen.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Erstelle neues Verzeichnis: $BASE_DIR${NC}"
    mkdir -p "$BASE_DIR"
fi

# Git Repository initialisieren (falls nicht vorhanden)
if [ ! -d "$BASE_DIR/.git" ]; then
    echo -e "${GREEN}✓ Initialisiere Git-Repository${NC}"
    cd "$BASE_DIR"
    git init
fi

# Erstelle Verzeichnisstruktur
echo -e "${BLUE}Erstelle Verzeichnisstruktur...${NC}"
mkdir -p "$BASE_DIR/docker/"{home-assistant,portainer,nginx-proxy-manager,n8n,freepbx,pulse,yt-dlp-webui,homer,unifi-controller,proxmox-backup-server,ollama-gpu,print-server,firefox-container,authentik,tower-wars}
mkdir -p "$BASE_DIR/network/opnsense"
mkdir -p "$BASE_DIR/proxmox/"{pve,pve-02,pve-03}
mkdir -p "$BASE_DIR/storage"
mkdir -p "$BASE_DIR/runbooks"
mkdir -p "$BASE_DIR/scripts"
mkdir -p "$BASE_DIR/docker/home-assistant/automations"
echo -e "${GREEN}✓ Verzeichnisstruktur erstellt${NC}"

# Zähler für kopierte Files
COPIED=0
SKIPPED=0

# Funktion zum sicheren Kopieren
safe_copy() {
    local src="$1"
    local dst="$2"
    
    if [ -f "$src" ]; then
        cp "$src" "$dst"
        echo -e "${GREEN}  ✓ Kopiert: $(basename $src)${NC}"
        ((COPIED++))
    else
        echo -e "${YELLOW}  ⚠ Nicht gefunden: $src${NC}"
        ((SKIPPED++))
    fi
}

echo ""
echo -e "${BLUE}Sammle Docker-Compose-Files...${NC}"

# Home Assistant
echo -e "${BLUE}[Home Assistant]${NC}"
safe_copy "$HOME/Dokumente/GitProjects/home-docker-stacks/home-assistant/docker-compose.yml" \
          "$BASE_DIR/docker/home-assistant/docker-compose.yml"

# Portainer
echo -e "${BLUE}[Portainer]${NC}"
safe_copy "$HOME/Dokumente/GitProjects/home-docker-stacks/portainer/docker-compose.yml" \
          "$BASE_DIR/docker/portainer/docker-compose.yml"
safe_copy "$HOME/docker/portainer-agent/docker-compose.yml" \
          "$BASE_DIR/docker/portainer/portainer-agent.yml"

# Authentik
echo -e "${BLUE}[Authentik]${NC}"
safe_copy "$HOME/Dokumente/GitProjects/home-docker-stacks/authentik/docker-compose.yml" \
          "$BASE_DIR/docker/authentik/docker-compose.yml"

# Proxmox Backup Server
echo -e "${BLUE}[Proxmox Backup Server]${NC}"
safe_copy "$HOME/Dokumente/GitProjects/home-docker-stacks/pbs/docker-compose.yaml" \
          "$BASE_DIR/docker/proxmox-backup-server/docker-compose.yaml"

# FreePBX
echo -e "${BLUE}[FreePBX]${NC}"
safe_copy "$HOME/BashScripts/PBX_AsteriskForRpiDockerComposeDir/docker-compose.yaml" \
          "$BASE_DIR/docker/freepbx/docker-compose.yaml"

# Pulse
echo -e "${BLUE}[Pulse]${NC}"
safe_copy "$HOME/BashScripts/docker/pulse/docker-compose.yml" \
          "$BASE_DIR/docker/pulse/docker-compose.yml"

# YT-DLP-WebUI
echo -e "${BLUE}[YT-DLP-WebUI]${NC}"
safe_copy "$HOME/BashScripts/docker/yt-dlp-webui/docker-compose.yml" \
          "$BASE_DIR/docker/yt-dlp-webui/docker-compose.yml"

# Homer
echo -e "${BLUE}[Homer]${NC}"
safe_copy "$HOME/Dokumente/GitProjects/homerCodebase/docker-compose.yml" \
          "$BASE_DIR/docker/homer/docker-compose.yml"

# Unifi Controller (OneLiner Variante)
echo -e "${BLUE}[Unifi Controller]${NC}"
safe_copy "$HOME/git-projects/Unifi-Network-Application/OneLiner/docker-compose.yml" \
          "$BASE_DIR/docker/unifi-controller/docker-compose.yml"

# Ollama GPU
echo -e "${BLUE}[Ollama GPU]${NC}"
safe_copy "$HOME/docker/ollama-docker-w-gpu/docker-compose.yml" \
          "$BASE_DIR/docker/ollama-gpu/docker-compose.yml"

# Print Server
echo -e "${BLUE}[Print Server]${NC}"
safe_copy "$HOME/docker/print-cupsd/docker-compose.yaml" \
          "$BASE_DIR/docker/print-server/docker-compose.yaml"

# Firefox Container
echo -e "${BLUE}[Firefox Container]${NC}"
safe_copy "$HOME/Dokumente/GitProjects/home-docker-stacks/firefox/docker-compose.yaml" \
          "$BASE_DIR/docker/firefox-container/docker-compose.yaml"

# Tower Wars (alle Varianten)
echo -e "${BLUE}[Tarek's Tower Wars]${NC}"
safe_copy "$HOME/docker/tareks-tower-wars-mobile/docker-compose.yml" \
          "$BASE_DIR/docker/tower-wars/docker-compose.yml"
safe_copy "$HOME/docker/tareks-tower-wars-mobile/docker-compose.auto-deploy.yml" \
          "$BASE_DIR/docker/tower-wars/docker-compose.auto-deploy.yml"
safe_copy "$HOME/docker/tareks-tower-wars-mobile/docker-compose.portainer.yml" \
          "$BASE_DIR/docker/tower-wars/docker-compose.portainer.yml"
safe_copy "$HOME/docker/tareks-tower-wars-mobile/docker-compose.portainer-build.yml" \
          "$BASE_DIR/docker/tower-wars/docker-compose.portainer-build.yml"

echo ""
echo -e "${BLUE}Sammle Home Assistant Configs...${NC}"

# Home Assistant Automations
echo -e "${BLUE}[Home Assistant Automations]${NC}"
safe_copy "$HOME/Downloads/proxmox_power.yaml" \
          "$BASE_DIR/docker/home-assistant/automations/proxmox_power.yaml"
safe_copy "$HOME/Downloads/julians_zimmer_clean.yaml" \
          "$BASE_DIR/docker/home-assistant/automations/julians_zimmer_clean.yaml"
safe_copy "$HOME/Downloads/mqtt.yaml" \
          "$BASE_DIR/docker/home-assistant/automations/mqtt.yaml"
safe_copy "$HOME/Downloads/klingel.yaml" \
          "$BASE_DIR/docker/home-assistant/automations/klingel.yaml"
safe_copy "$HOME/BashScripts/ALTES_ZIGBEE_CONF.configuration.yaml" \
          "$BASE_DIR/docker/home-assistant/automations/ALTES_ZIGBEE_CONF.configuration.yaml"

echo ""
echo -e "${BLUE}Erstelle Dokumentations-Files...${NC}"

# Erstelle .gitignore
cat > "$BASE_DIR/.gitignore" << 'EOF'
# Environment files mit Secrets
.env
*.env
**/secrets.yaml
**/secrets.yml

# Temporary files
*.tmp
*.bak
*.swp
*~

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Logs
*.log
logs/
EOF
echo -e "${GREEN}  ✓ .gitignore erstellt${NC}"

# Erstelle README-Platzhalter für Unterverzeichnisse
create_section_readme() {
    local dir="$1"
    local title="$2"
    local desc="$3"
    
    cat > "$dir/README.md" << EOF
# $title

$desc

## Struktur

\`\`\`
$(tree -L 2 "$dir" 2>/dev/null || ls -la "$dir")
\`\`\`

## Services

TODO: Liste der Services mit Beschreibung

## Konfiguration

TODO: Wichtige Konfigurationsoptionen

## Troubleshooting

TODO: Häufige Probleme und Lösungen
EOF
}

echo -e "${GREEN}  ✓ Erstelle Platzhalter-READMEs${NC}"
create_section_readme "$BASE_DIR/docker" "Docker Services" "Alle containerisierten Services"
create_section_readme "$BASE_DIR/network" "Netzwerk-Dokumentation" "OPNsense, VLANs, DNS/DHCP"
create_section_readme "$BASE_DIR/proxmox" "Proxmox Cluster" "VMs, Container, Storage"
create_section_readme "$BASE_DIR/storage" "Storage & Backup" "ZFS Pools, Backup-Strategie"
create_section_readme "$BASE_DIR/runbooks" "Runbooks" "Prozeduren und Troubleshooting"

echo ""
echo -e "${BLUE}Erstelle Docker-Services-Übersicht...${NC}"

# Erstelle Docker-Services-Übersicht
cat > "$BASE_DIR/docker/SERVICES.md" << 'EOF'
# Docker Services Übersicht

## Host-Zuordnung

### pve (192.168.188.177)
- [ ] Portainer Server
- [ ] Home Assistant
- [ ] n8n
- [ ] Nginx Proxy Manager

### pve-02 (192.168.188.153)
- [ ] Portainer Agent
- [ ] Authentik
- [ ] Vaultwarden

### pve-03
- [ ] Portainer Agent
- [ ] Uptime Kuma

## Service-Liste

| Service | Host | Port | Beschreibung |
|---------|------|------|--------------|
| Portainer | pve | 9000 | Docker Management |
| Home Assistant | pve | 8123 | Smart Home Hub |
| FreePBX | ? | 80 | VoIP Telephony |
| n8n | ? | 5678 | Workflow Automation |
| Authentik | pve-02 | 9000 | SSO Provider |
| Nginx Proxy Manager | ? | 81 | Reverse Proxy |
| Homer | ? | 8080 | Dashboard |
| Pulse | ? | ? | Monitoring |
| Ollama | ? | 11434 | Local LLM |

TODO: Ports und Hosts ergänzen
EOF
echo -e "${GREEN}  ✓ SERVICES.md erstellt${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ Sammlung abgeschlossen!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Statistik:"
echo -e "  ${GREEN}✓ Kopiert:${NC} $COPIED Dateien"
echo -e "  ${YELLOW}⚠ Übersprungen:${NC} $SKIPPED Dateien (nicht gefunden)"
echo ""
echo -e "${BLUE}Nächste Schritte:${NC}"
echo ""
echo -e "1. Prüfe die gesammelten Dateien:"
echo -e "   ${YELLOW}cd $BASE_DIR${NC}"
echo -e "   ${YELLOW}tree -L 3${NC}"
echo ""
echo -e "2. Prüfe auf Secrets/Passwörter:"
echo -e "   ${YELLOW}grep -r \"password\" docker/*/docker-compose.yml${NC}"
echo -e "   ${YELLOW}grep -r \"secret\" docker/*/docker-compose.yml${NC}"
echo -e "   ${YELLOW}grep -r \"token\" docker/*/docker-compose.yml${NC}"
echo ""
echo -e "3. Ersetze Secrets durch Umgebungsvariablen (.env)"
echo ""
echo -e "4. Kopiere die heruntergeladene README:"
echo -e "   ${YELLOW}# Kopiere INFRASTRUCTURE-README.md nach $BASE_DIR/README.md${NC}"
echo ""
echo -e "5. Initial Commit:"
echo -e "   ${YELLOW}git add .${NC}"
echo -e "   ${YELLOW}git commit -m \"Initial commit: Infrastructure documentation\"${NC}"
echo ""
echo -e "6. GitHub Repository erstellen und pushen:"
echo -e "   ${YELLOW}# Auf GitHub: Neues privates Repo 'infrastructure-docs' erstellen${NC}"
echo -e "   ${YELLOW}git remote add origin git@github.com:dajuly20/infrastructure-docs.git${NC}"
echo -e "   ${YELLOW}git branch -M main${NC}"
echo -e "   ${YELLOW}git push -u origin main${NC}"
echo ""
echo -e "${GREEN}🎉 Ready to go!${NC}"
