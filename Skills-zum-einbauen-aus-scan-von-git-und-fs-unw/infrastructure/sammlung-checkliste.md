# Zu sammelnde Files - Infrastructure Documentation

## 📦 Aufgabe: Alle diese Files in ein Git-Repository packen

---

## 🐳 Docker-Compose Files

### BashScripts Verzeichnis
```bash
~/BashScripts/docker/pulse/docker-compose.yml
~/BashScripts/docker/yt-dlp-webui/docker-compose.yml
~/BashScripts/PBX_AsteriskForRpiDockerComposeDir/docker-compose.yaml
```

### Dokumente/GitProjects/home-docker-stacks
```bash
~/Dokumente/GitProjects/home-docker-stacks/firefox/docker-compose.yaml
~/Dokumente/GitProjects/home-docker-stacks/portainer/docker-compose.yml
~/Dokumente/GitProjects/home-docker-stacks/home-assistant/docker-compose.yml
~/Dokumente/GitProjects/home-docker-stacks/unify-networking/docker-compose.yml
~/Dokumente/GitProjects/home-docker-stacks/authentik/docker-compose.yml
~/Dokumente/GitProjects/home-docker-stacks/pbs/docker-compose.yaml
```

### Andere Projekte
```bash
~/Dokumente/GitProjects/Pulse/docker-compose.yml
~/Dokumente/GitProjects/homerCodebase/docker-compose.yml
```

### ~/docker Verzeichnis
```bash
~/docker/tareks-tower-wars-mobile/docker-compose.yml
~/docker/tareks-tower-wars-mobile/docker-compose.auto-deploy.yml
~/docker/tareks-tower-wars-mobile/docker-compose.portainer.yml
~/docker/tareks-tower-wars-mobile/docker-compose.portainer-build.yml
~/docker/ollama-docker-w-gpu/docker-compose.yml
~/docker/ollama-docker-w-gpu/ollama-gpt-nvidia-containerized/docker-compose.yml
~/docker/print-cupsd/docker-compose.yaml
~/docker/ollama-gpt-nvidia-containerized/docker-compose.yml
~/docker/portainer-agent/docker-compose.yml
```

### Unifi-Network-Application
```bash
~/git-projects/Unifi-Network-Application/OneLiner/docker-compose.yml
~/git-projects/Unifi-Network-Application/Unifi network Application - DietPi/docker-compose.yml
~/git-projects/Unifi-Network-Application/Unifi network Application - Generic/docker-compose.yml
~/git-projects/Unifi-Network-Application/Unifi network application - CasaOS/docker-compose.yml
```

---

## 🏠 Home Assistant Configs

```bash
~/BashScripts/ALTES_ZIGBEE_CONF.configuration.yaml
~/Downloads/proxmox_power.yaml
~/Downloads/julians_zimmer_clean.yaml
~/Downloads/mqtt.yaml
~/Downloads/klingel.yaml
```

---

## 📝 Bash Scripts (Optional, wenn relevant)

```bash
# Prüfe welche Scripts in ~/BashScripts/ relevant sind
ls -la ~/BashScripts/*.sh
```

---

## ✅ Nächste Schritte

### 1. Repository erstellen
```bash
cd ~
mkdir infrastructure-docs
cd infrastructure-docs
git init
```

### 2. Struktur anlegen
```bash
mkdir -p docker/{home-assistant,portainer,nginx-proxy-manager,n8n,freepbx,pulse,yt-dlp-webui,homer,unifi-controller,proxmox-backup-server,ollama-gpu,print-server,firefox-container,authentik}
mkdir -p network/opnsense
mkdir -p proxmox/{pve,pve-02,pve-03}
mkdir -p storage
mkdir -p runbooks
mkdir -p scripts
```

### 3. Files kopieren

**Docker-Compose-Files:**
```bash
# Home Assistant
cp ~/Dokumente/GitProjects/home-docker-stacks/home-assistant/docker-compose.yml \
   ~/infrastructure-docs/docker/home-assistant/

# Portainer
cp ~/Dokumente/GitProjects/home-docker-stacks/portainer/docker-compose.yml \
   ~/infrastructure-docs/docker/portainer/

# Authentik
cp ~/Dokumente/GitProjects/home-docker-stacks/authentik/docker-compose.yml \
   ~/infrastructure-docs/docker/authentik/

# PBS
cp ~/Dokumente/GitProjects/home-docker-stacks/pbs/docker-compose.yaml \
   ~/infrastructure-docs/docker/proxmox-backup-server/

# FreePBX
cp ~/BashScripts/PBX_AsteriskForRpiDockerComposeDir/docker-compose.yaml \
   ~/infrastructure-docs/docker/freepbx/

# Pulse
cp ~/BashScripts/docker/pulse/docker-compose.yml \
   ~/infrastructure-docs/docker/pulse/

# YT-DLP-WebUI
cp ~/BashScripts/docker/yt-dlp-webui/docker-compose.yml \
   ~/infrastructure-docs/docker/yt-dlp-webui/

# Homer
cp ~/Dokumente/GitProjects/homerCodebase/docker-compose.yml \
   ~/infrastructure-docs/docker/homer/

# Unifi (wähle eine Variante)
cp ~/git-projects/Unifi-Network-Application/OneLiner/docker-compose.yml \
   ~/infrastructure-docs/docker/unifi-controller/

# Ollama GPU
cp ~/docker/ollama-docker-w-gpu/docker-compose.yml \
   ~/infrastructure-docs/docker/ollama-gpu/

# Print Server
cp ~/docker/print-cupsd/docker-compose.yaml \
   ~/infrastructure-docs/docker/print-server/

# Portainer Agent
cp ~/docker/portainer-agent/docker-compose.yml \
   ~/infrastructure-docs/docker/portainer/portainer-agent.yml

# Firefox Container
cp ~/Dokumente/GitProjects/home-docker-stacks/firefox/docker-compose.yaml \
   ~/infrastructure-docs/docker/firefox-container/
```

**Home Assistant Automations:**
```bash
mkdir -p ~/infrastructure-docs/docker/home-assistant/automations
cp ~/Downloads/proxmox_power.yaml ~/infrastructure-docs/docker/home-assistant/automations/
cp ~/Downloads/julians_zimmer_clean.yaml ~/infrastructure-docs/docker/home-assistant/automations/
cp ~/Downloads/mqtt.yaml ~/infrastructure-docs/docker/home-assistant/automations/
cp ~/Downloads/klingel.yaml ~/infrastructure-docs/docker/home-assistant/automations/
cp ~/BashScripts/ALTES_ZIGBEE_CONF.configuration.yaml ~/infrastructure-docs/docker/home-assistant/automations/
```

### 4. .gitignore erstellen
```bash
cat > ~/infrastructure-docs/.gitignore << 'EOF'
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
```

### 5. README kopieren
```bash
# Kopiere die README die ich dir erstellt habe
# (die du gerade als Download bekommen hast)
cp /pfad/zur/INFRASTRUCTURE-README.md ~/infrastructure-docs/README.md
```

### 6. Initial Commit
```bash
cd ~/infrastructure-docs
git add .
git commit -m "Initial commit: Infrastructure documentation

- Docker compose files für alle Services
- Home Assistant Automations
- Repository-Struktur angelegt
"
```

### 7. GitHub Repository erstellen (optional)
```bash
# Auf GitHub ein neues privates Repo erstellen: infrastructure-docs
# Dann:
git remote add origin git@github.com:dajuly20/infrastructure-docs.git
git branch -M main
git push -u origin main
```

---

## ⚠️ WICHTIG - Vor dem Commit prüfen!

### Secrets entfernen
```bash
# Prüfe alle docker-compose.yml Files auf Passwörter/Secrets
grep -r "password" ~/infrastructure-docs/docker/
grep -r "secret" ~/infrastructure-docs/docker/
grep -r "token" ~/infrastructure-docs/docker/
```

**Ersetze Secrets durch Umgebungsvariablen:**
```yaml
# FALSCH:
environment:
  - MYSQL_ROOT_PASSWORD=supersecret123

# RICHTIG:
environment:
  - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

# Dann in .env (NICHT committen!):
MYSQL_ROOT_PASSWORD=supersecret123
```

---

## 📊 Statistik

**Gefundene Docker-Compose-Files:** ~25+  
**Home Assistant Configs:** 5  
**Verzeichnisse:** 3 (BashScripts, Dokumente/GitProjects, docker, git-projects)

---

## 🎯 Ziel

Nach diesem Setup hast du:
✅ Alle Docker-Compose-Files zentral an einem Ort  
✅ Versionskontrolle über Git  
✅ Saubere Struktur  
✅ Dokumentation deiner Infrastruktur  
✅ Backup deiner Konfigurationen

**Das kannst du dann im Lebenslauf erwähnen:**  
"Vollständig dokumentierte Self-Hosted Infrastruktur mit 25+ containerisierten Services unter Versionskontrolle"
