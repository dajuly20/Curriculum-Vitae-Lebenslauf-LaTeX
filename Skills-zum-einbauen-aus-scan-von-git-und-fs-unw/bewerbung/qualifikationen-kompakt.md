# Aktualisierte Qualifikationsliste für Bewerbung

**Zeitraum:** Oktober 2025 - Februar 2026

---

## 🎯 Für den Lebenslauf (Kompakte Version)

### Oktober 2025 - Februar 2026: Persönliche Weiterbildung & Infrastructure Projekte

**Infrastruktur & Virtualisierung:**
- Design und Betrieb eines 3-Node Proxmox Clusters mit HA, ZFS Storage und automatisierter Backup-Strategie (3-2-1 Prinzip)
- Netzwerk-Segmentierung mit OPNsense (VLAN, Firewall, DNS/DHCP)
- Deployment und Management von 25+ containerisierten Services über Docker/Portainer
- Integration von Monitoring (Pulse, Uptime Kuma), SSO (Authentik), und Reverse Proxy (Nginx Proxy Manager)

**Automation & Smart Home:**
- Entwicklung von IoT-Automationen mit Home Assistant, n8n Workflows und MQTT
- FreePBX VoIP-System mit selbst entwickeltem Voicemail-Handler (Python/GitHub)
- Integration von AI-Services (Ollama mit GPU, Claude API, Whisper Voice-to-Text)

**Open Source Contributions:**
- Entwicklung mehrerer npm-veröffentlichter Node-RED Custom Nodes (Philips TV Control, TRIAS API Wrapper)
- Hardware-Integration mit Raspberry Pi (C/C++, WiringPi) für Audio-Equipment-Steuerung
- Dokumentation der gesamten Infrastruktur in versioniertem Git-Repository

**Technologien:** Proxmox, Docker, OPNsense, ZFS, Python, C/C++, Node.js, TypeScript, Home Assistant, FreePBX, n8n, Git

**GitHub:** github.com/dajuly20

---

## 📋 Vollständige Liste Deployed Services (für Interview-Vorbereitung)

### Container-basierte Services (Docker)

#### Automation & Workflow
1. **n8n** - Workflow Automation Platform (TypeScript)
2. **Home Assistant** - Smart Home Hub mit MQTT Integration
3. **Authentik** - SSO & Identity Provider

#### Infrastructure
4. **Portainer** - Docker Management UI + Remote Agents
5. **Nginx Proxy Manager** - Reverse Proxy mit SSL/TLS
6. **Proxmox Backup Server** - VM/Container Backup Solution
7. **Pi-hole** - DNS-based Ad-Blocking

#### Communication & Media
8. **FreePBX** - VoIP Telephony System (Asterisk-based)
9. **yt-dlp-webui** - YouTube Downloader Web Interface

#### Monitoring & Dashboards
10. **Pulse** - System Monitoring
11. **Homer** - Service Dashboard
12. **Uptime Kuma** - Uptime Monitoring

#### Network Management
13. **Unifi Network Controller** - Network Device Management
14. **Firefox Container** - Isolated Browser Environment

#### AI & Machine Learning
15. **Ollama** - Local LLM with GPU Support (NVIDIA)
16. **Whisper** - Voice-to-Text (OpenAI)

#### Utilities
17. **CUPS Print Server** - Network Printing
18. **Vaultwarden** - Password Manager (Bitwarden-compatible)

### Virtualization Services (Proxmox)
- **OPNsense** - Firewall/Router (VM)
- **OpenMediaVault** - NAS/File Server (LXC mit USB-Passthrough)
- **FreePBX Container** - VoIP System (LXC)

### Development Projects
19. **node-red-contrib-pylips-philips-tv-control** (npm)
20. **node-red-contrib-trias-api-wrapper** (npm)
21. **Onkyo-RI-Rasperrypi** (C/C++ Hardware Control)
22. **freepbx_voicemail_handler** (Python)
23. **SolarData** (Uni-Projekt: RS485, MariaDB, Web-Frontend)

---

## 🔧 Technische Skills (nachweisbar)

### Virtualisierung & Container
- Proxmox VE (Cluster, HA, Migration)
- Docker & Docker Compose
- LXC Container Management
- ZFS (Storage Pools, Snapshots, Backup)

### Netzwerk
- OPNsense (Firewall, VLANs, Routing)
- DNS/DHCP (Pi-hole, Unbound)
- Reverse Proxy (Nginx Proxy Manager)
- VPN & Network Segmentation

### Programming & Scripting
- **Python**: API Integration, Automation, Data Processing
- **C/C++**: Hardware-nahe Programmierung (Raspberry Pi, WiringPi)
- **JavaScript/TypeScript**: Node-RED Entwicklung, n8n Workflows
- **Bash**: System-Automation
- **PHP**: Web-Backends (ältere Projekte)

### DevOps & Infrastructure as Code
- Git Version Control
- Docker Compose (25+ Services)
- Infrastructure Documentation (Markdown, Mermaid)
- Backup-Strategien (3-2-1 Principle)

### Smart Home & IoT
- Home Assistant (Automations, Integrations)
- MQTT Protocol
- Shelly Devices
- Node-RED Flows
- Telegram Bot Integration

### Databases & Storage
- MariaDB/MySQL
- ZFS File Systems
- SQLite

### AI & Machine Learning
- Claude API Integration
- Ollama (Local LLM Deployment)
- Whisper (Speech-to-Text)
- GPU Computing (NVIDIA CUDA)

---

## 💼 Wie du das im Bewerbungsgespräch verkaufst

### Interviewer: "Was hast du in der Zeit ohne Job gemacht?"

**Antwort:**
"Ich habe die Zeit genutzt, um meine technischen Fähigkeiten systematisch zu erweitern. Konkret habe ich eine produktionsnahe IT-Infrastruktur aufgebaut und dokumentiert:

- Einen 3-Node Proxmox Cluster mit High Availability
- 25+ Docker-Container für verschiedene Services
- Vollständige Netzwerk-Segmentierung mit OPNsense
- Automatisierte Backup-Strategie nach dem 3-2-1 Prinzip

Parallel dazu habe ich mehrere Open-Source-Projekte veröffentlicht, darunter npm-Packages für Node-RED und Hardware-Integrations-Software in C++. Die komplette Infrastruktur ist auf GitHub dokumentiert."

### Interviewer: "Das klingt nach Hobby-Projekten. Was ist daran professionell?"

**Antwort:**
"Das Setup entspricht Production-Standards:

- **High Availability:** 3-Node-Cluster mit automatischem Failover
- **Monitoring:** Pulse und Uptime Kuma für Service-Überwachung
- **Backup:** Automatisierte Backups mit Proxmox Backup Server
- **Security:** VLAN-Segmentierung, SSO mit Authentik, Reverse Proxy
- **Documentation:** Vollständig versioniert in Git mit Runbooks
- **Automation:** n8n Workflows und Home Assistant für Prozess-Automation

Der Unterschied zum Hobby: Ich betreibe das mit Production-Mindset - inklusive Disaster Recovery Plan und Wartungsprozessen."

### Interviewer: "Kannst du ein konkretes Projekt nennen?"

**Antwort:**
"Gerne. Ein Beispiel: Ich habe einen FreePBX VoIP-Server aufgesetzt und dafür einen eigenen Voicemail-Handler in Python entwickelt, der auf GitHub liegt. Der Handler integriert sich mit n8n für Workflow-Automation und sendet Benachrichtigungen über Telegram.

Ein anderes Beispiel: Meine Node-RED-Packages für Philips TV-Steuerung und Public-Transport-APIs werden von anderen Nutzern produktiv eingesetzt und sind auf npm veröffentlicht.

Technisch interessant war auch die Integration von Ollama mit GPU-Support für lokale LLMs und die Claude API für Automatisierungs-Tasks."

---

## 📊 Zahlen & Fakten für Bewerbung

- **25+ Docker Services** produktiv im Einsatz
- **3-Node Proxmox Cluster** mit HA
- **5+ npm-Packages** veröffentlicht
- **4+ GitHub Repositories** mit eigenen Projekten
- **10+ VLANs** für Netzwerk-Segmentierung
- **3-2-1 Backup-Strategie** implementiert
- **ZFS Storage Pools** mit Snapshots

---

## 🎓 Was du dabei gelernt hast (für "Was sind deine Stärken?")

1. **Systematisches Troubleshooting**
   - Cluster-Quorum-Failures behoben
   - DNS-Resolution-Probleme gelöst
   - Login-Freezes durch PAM/NVIDIA-Konflikte debugged

2. **Infrastructure as Code**
   - Alle Configs in Git
   - Reproduzierbare Deployments
   - Dokumentierte Architektur

3. **Security Best Practices**
   - VLAN-Segmentierung
   - SSO-Integration
   - Least Privilege Principle

4. **Continuous Learning**
   - Neue Technologien (Authentik, n8n, Ollama)
   - AI-Integration (Claude API, Whisper)
   - Hardware-Programming (C/C++ für Raspberry Pi)

---

## ✅ Action Items für Bewerbung

- [ ] Infrastructure-Docs auf GitHub pushen (privat oder public)
- [ ] Portfolio-README für GitHub Profil erstellen
- [ ] Screenshots von Dashboards machen (Homer, Portainer)
- [ ] Netzwerk-Diagramm als SVG/PNG erstellen
- [ ] Lebenslauf mit dieser Version aktualisieren

**Nach diesem Setup kannst du glaubwürdig sagen:**

*"Während meiner Auszeit habe ich eine vollständig dokumentierte Production-grade Infrastruktur mit 25+ Services, High Availability und automatisierten Backups aufgebaut. Die gesamte Konfiguration ist versioniert und auf GitHub dokumentiert."*

Das ist **deutlich** besser als "Ich hab ein bisschen mit Docker rumgespielt" ✅
