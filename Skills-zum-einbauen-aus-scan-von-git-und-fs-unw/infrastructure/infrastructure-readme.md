# Julian's Infrastructure Documentation

**Stand:** Februar 2026  
**Maintainer:** Julian Wiche (julian@wiche.eu)

---

## 📋 Übersicht

Dieses Repository dokumentiert meine komplette Self-Hosted Infrastruktur:
- **3-Node Proxmox Cluster** (pve, pve-02, pve-03)
- **OPNsense Firewall** mit VLAN-Segmentierung
- **Docker-basierte Services** über mehrere Hosts
- **Home Assistant** Smart Home Setup
- **FreePBX** VoIP Telephony
- **ZFS Storage** mit Backup-Strategie

---

## 🗂️ Repository-Struktur

```
infrastructure-docs/
├── README.md                          # Diese Datei
├── network/
│   ├── network-diagram.md             # Netzwerk-Übersicht (VLANs, IPs)
│   ├── opnsense/
│   │   ├── firewall-rules.md
│   │   └── dns-dhcp-config.md
│   └── device-inventory.md
├── proxmox/
│   ├── cluster-overview.md
│   ├── pve/
│   │   ├── vms.md
│   │   └── containers.md
│   ├── pve-02/
│   │   ├── vms.md
│   │   └── containers.md
│   └── pve-03/
│       ├── vms.md
│       └── containers.md
├── docker/
│   ├── README.md                      # Welcher Host hat welche Container
│   ├── home-assistant/
│   │   ├── docker-compose.yml
│   │   └── automations/
│   │       ├── proxmox_power.yaml
│   │       ├── julians_zimmer_clean.yaml
│   │       ├── mqtt.yaml
│   │       └── klingel.yaml
│   ├── portainer/
│   │   └── docker-compose.yml
│   ├── nginx-proxy-manager/
│   │   └── docker-compose.yml
│   ├── authentik/
│   │   └── docker-compose.yml
│   ├── n8n/
│   │   └── docker-compose.yml
│   ├── freepbx/
│   │   └── docker-compose.yaml
│   ├── pulse/
│   │   └── docker-compose.yml
│   ├── yt-dlp-webui/
│   │   └── docker-compose.yml
│   ├── homer/
│   │   └── docker-compose.yml
│   ├── unifi-controller/
│   │   └── docker-compose.yml
│   ├── proxmox-backup-server/
│   │   └── docker-compose.yaml
│   ├── ollama-gpu/
│   │   └── docker-compose.yml
│   ├── print-server/
│   │   └── docker-compose.yaml
│   └── firefox-container/
│       └── docker-compose.yaml
├── storage/
│   ├── zfs-pools.md
│   ├── backup-strategy.md
│   └── disk-layout.md
└── runbooks/
    ├── disaster-recovery.md
    ├── common-issues.md
    ├── deployment-procedures.md
    └── maintenance-tasks.md
```

---

## 🌐 Netzwerk-Übersicht

### VLANs
- **VLAN 188** (192.168.188.0/24) - Main Network
- **VLAN 10** (10.0.0.0/24) - IoT/Guest

### Wichtige IPs
| Device | IP | Funktion |
|--------|------------|----------|
| OPNsense | 192.168.188.254 | Firewall/Router |
| pve | 192.168.188.177 | Proxmox Node 1 |
| pve-02 | 192.168.188.153 | Proxmox Node 2 |
| pve-03 | ? | Proxmox Node 3 |
| Pi-hole | 192.168.188.222 | DNS/DHCP |
| Home Assistant | 192.168.188.178 | Smart Home |
| FreePBX | 192.168.188.42 | VoIP |
| Portainer | ? | Docker Management |

*(Vollständige Liste in `network/device-inventory.md`)*

---

## 🐳 Docker Services

### Deployed Services
- **n8n** - Workflow Automation
- **Home Assistant** - Smart Home Hub
- **FreePBX** - VoIP Telephony System
- **Portainer** - Docker Management
- **Nginx Proxy Manager** - Reverse Proxy
- **Authentik** - SSO/Identity Provider
- **Pi-hole** - DNS Ad-Blocking
- **Homer** - Service Dashboard
- **Pulse** - Monitoring
- **Ollama** - Local LLM (GPU)
- **yt-dlp-webui** - YouTube Downloader
- **Unifi Controller** - Network Management
- **Proxmox Backup Server** - Backup Solution
- **CUPS Print Server** - Network Printing

*(Detaillierte Konfigurationen in `docker/` Verzeichnis)*

---

## 💾 Storage & Backup

### ZFS Pools
- **BackupMagnetplatte** (2.6TB) - USB HDD für Backups
- *(Weitere Pools dokumentiert in `storage/zfs-pools.md`)*

### Backup-Strategie
- **3-2-1 Backup Rule**
  - 3 Kopien der Daten
  - 2 verschiedene Medien
  - 1 Offsite-Backup
- Proxmox Backup Server für VM/Container Backups
- ZFS Snapshots für kritische Daten

*(Details in `storage/backup-strategy.md`)*

---

## 📚 Runbooks

### Häufige Aufgaben
- [Disaster Recovery](runbooks/disaster-recovery.md)
- [VM Migration zwischen Nodes](runbooks/deployment-procedures.md)
- [Docker Container Deployment](runbooks/deployment-procedures.md)
- [Backup Restore](runbooks/disaster-recovery.md)

### Bekannte Probleme
- [DNS Resolution Issues](runbooks/common-issues.md)
- [Cluster Quorum Failures](runbooks/common-issues.md)
- [Docker Container Startup Failures](runbooks/common-issues.md)

---

## 🔧 Wartung

### Regelmäßige Tasks
- [ ] **Wöchentlich**: Docker Image Updates
- [ ] **Monatlich**: Proxmox Updates
- [ ] **Monatlich**: Backup-Test
- [ ] **Quartalsweise**: Hardware-Check

*(Vollständiger Wartungsplan in `runbooks/maintenance-tasks.md`)*

---

## 📖 GitHub Repositories

### Eigene Projekte
- [node-red-contrib-pylips-philips-tv-control](https://github.com/dajuly20/node-red-contrib-pylips-philips-tv-control)
- [Onkyo-RI-Rasperrypi](https://github.com/dajuly20/Onkyo-RI-Rasperrypi)
- [freepbx_voicemail_handler](https://github.com/dajuly20/freepbx_voicemail_handler)
- [homerCodebase](https://github.com/dajuly20/homerCodebase)
- [SolarData](https://github.com/dajuly20/SolarData)

---

## 🚀 Quick Start

### Neuen Docker Service deployen
```bash
cd ~/infrastructure-docs/docker/<service-name>
docker compose up -d
```

### Backup erstellen
```bash
# Proxmox VM/Container
vzdump <vmid> --storage <storage-name>

# ZFS Snapshot
zfs snapshot tank@backup-$(date +%Y%m%d)
```

### Cluster Status prüfen
```bash
pvecm status
pvecm nodes
```

---

## ⚠️ Wichtige Hinweise

### Sicherheit
- **Nie** Passwörter im Git-Repository committen
- `.env` Files sind in `.gitignore`
- Secrets werden über Vault/env-files verwaltet

### Naming Conventions
- VMs: `<service>-vm-<node>`
- Container: `<service>-ct-<node>`
- Docker Compose Projects: `<service-name>`

---

## 📝 Changelog

### 2026-02-13
- Initiales Repository erstellt
- Alle Docker-Compose-Files gesammelt
- Netzwerk-Dokumentation begonnen

---

## 📧 Kontakt

**Julian Wiche**  
Email: julian@wiche.eu  
GitHub: [dajuly20](https://github.com/dajuly20)
