#!/usr/bin/env bash
# Erstellt/aktualisiert den Symlink /var/www/rawdownload/cv -> output/ dieses Repos,
# damit die gebauten PDFs unter https://.../rawdownload/cv/ erreichbar sind.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_DIR/output"
TARGET_DIR="/var/www/rawdownload"
LINK_NAME="cv"
LINK_PATH="$TARGET_DIR/$LINK_NAME"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Fehler: $SOURCE_DIR existiert nicht. Erst 'make' ausführen." >&2
    exit 1
fi

if [ -e "$LINK_PATH" ] && [ ! -L "$LINK_PATH" ]; then
    echo "Fehler: $LINK_PATH existiert bereits und ist kein Symlink. Breche ab." >&2
    exit 1
fi

# www-data muss lesend zugreifen können (z.B. via Apache).
chgrp -R www-data "$SOURCE_DIR"
chmod -R g+rX "$SOURCE_DIR"

ln -sfn "$SOURCE_DIR" "$LINK_PATH"
echo "OK: $LINK_PATH -> $SOURCE_DIR (Gruppe www-data, lesbar)"
