#!/usr/bin/env bash
# Pullt Änderungen vom Git-Remote. Bei neuen Commits werden die PDFs neu
# gebaut und der Downloadlink unter /var/www/rawdownload/cv aktualisiert.
# Gedacht für periodischen Aufruf per Cron (siehe crontab -l).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

log() {
    printf '[%s] %s\n' "$(date '+%F %T')" "$1"
}

BEFORE="$(git rev-parse HEAD)"

if ! git pull --ff-only origin main; then
    log "git pull fehlgeschlagen (lokale Änderungen im Weg?) - breche ab."
    exit 1
fi

AFTER="$(git rev-parse HEAD)"

if [ "$BEFORE" = "$AFTER" ]; then
    log "Keine neuen Commits."
    exit 0
fi

log "Neue Commits gepullt ($BEFORE -> $AFTER), baue PDFs neu..."
make
scripts/link-rawdownload.sh
log "Build und Publish abgeschlossen."
