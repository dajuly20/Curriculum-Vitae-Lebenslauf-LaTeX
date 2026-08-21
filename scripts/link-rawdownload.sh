#!/usr/bin/env bash
# Erstellt/aktualisiert den Symlink /var/www/rawdownload/cv -> outPublish/ dieses Repos,
# damit die öffentlichen PDFs unter https://.../rawdownload/cv/ erreichbar sind.
# outPublish/ enthält bewusst nur cv.pdf (siehe COPYCV im Makefile) - bewerbung.pdf
# und application.pdf landen in outPrivate/ und werden hier NICHT verlinkt.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAKEFILE="$REPO_DIR/Makefile"

# Verzeichnisname kommt einzig aus dem Makefile (OUTPUBLISH=...), damit er
# nur an einer Stelle im Projekt gepflegt werden muss.
OUTPUBLISH_NAME="$(grep -m1 '^OUTPUBLISH[[:space:]]*=' "$MAKEFILE" | cut -d= -f2- | xargs)"
if [ -z "$OUTPUBLISH_NAME" ]; then
    echo "Fehler: OUTPUBLISH konnte nicht aus $MAKEFILE gelesen werden." >&2
    exit 1
fi

SOURCE_DIR="$REPO_DIR/$OUTPUBLISH_NAME"
TARGET_DIR="/var/www/rawdownload"
LINK_NAME="cv"
LINK_PATH="$TARGET_DIR/$LINK_NAME"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Fehler: $SOURCE_DIR existiert nicht. Erst 'make cv' (oder 'make') ausführen." >&2
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
