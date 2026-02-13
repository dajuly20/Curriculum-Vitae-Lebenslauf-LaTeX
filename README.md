# application-template-latex

Wenn jemand einen Pull-Request macht, der dazu führt dass ich einen nen Vertrag unterschreibe kriegt ein Kasten Bier!

## Minimum Dependencies

```bash
sudo apt-get install texlive texlive-latex-extra texlive-lang-german
```

Diese Installation enthält alle notwendigen Pakete für das Projekt:
- KOMA-Script (scrartcl)
- Charter-Schrift
- ngerman (deutsche Silbentrennung)
- und weitere Standard-Pakete

## Make-Befehle

### Hauptbefehle

| Befehl | Beschreibung |
|--------|--------------|
| `make cv` | Kompiliert den Lebenslauf komplett (3 LaTeX-Durchläufe mit Biber für Bibliographie). Öffnet das PDF automatisch. |
| `make bewerbung <firmenname>` | Generiert Bewerbungsunterlagen für eine Firma aus `bewerbungen.json`. Beispiel: `make bewerbung Virtual-Minds-GmbH` |
| `make draft` | Schnelle Draft-Version ohne Bibliographie-Updates. Gut für schnelle Vorschau während der Bearbeitung. |

### Hilfsbefehle

| Befehl | Beschreibung |
|--------|--------------|
| `make scan` | Scannt Fotos im Verzeichnis `Bewerbungs-Adressen/Fotos/` |
| `make glossaries` | Erstellt Glossare (falls verwendet) |
| `make count` | Zählt die Wörter im Dokument |
| `make lua` | Kompiliert mit LuaLaTeX statt pdfLaTeX |
| `make beam` | Öffnet das PDF in Okular im Präsentationsmodus |

### PDF-Komprimierung

| Befehl | Beschreibung |
|--------|--------------|
| `make resize` | Komprimiert das PDF auf 300 DPI (gute Qualität, kleinere Dateigröße) |
| `make resize_minimal` | Komprimiert das PDF auf 75 DPI (minimale Dateigröße, reduzierte Qualität) |

### Aufräumen

| Befehl | Beschreibung |
|--------|--------------|
| `make clean` | Löscht alle Dateien im `output/`-Verzeichnis |
| `make clean-all` | Löscht alle temporären LaTeX-Dateien (*.aux, *.log, *.bbl, etc.) im gesamten Projekt |
