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

### Tesseract OCR (optional)

Für die Texterkennung in gescannten Dokumenten (`make scan`):

```bash
sudo apt-get install tesseract-ocr tesseract-ocr-deu
```

- `tesseract-ocr` - OCR-Engine
- `tesseract-ocr-deu` - Deutsche Sprachdaten

## Make-Befehle

### Hauptbefehle

| Befehl | Beschreibung |
|--------|--------------|
| `make` / `make all` | Erstellt alle 3 PDFs: vollständiges Dokument (`Lebenslauf Julian Wiche.pdf`), nur Lebenslauf (`cv.pdf`) und nur Anschreiben (`application.pdf`). 3 LaTeX-Durchläufe mit Biber. Öffnet das PDF automatisch. |
| `make cv` | Erstellt nur den Lebenslauf als `cv.pdf` (ohne Anschreiben und Anlagen). |
| `make application` | Erstellt nur das Anschreiben als `application.pdf`. |
| `make bewerbung <firmenname>` | Generiert Bewerbungsunterlagen für eine Firma aus `bewerbungen.json` (alle 3 PDFs). Beispiel: `make bewerbung Virtual-Minds-GmbH` |
| `make draft` | Schnelle Draft-Version ohne Bibliographie-Updates. Gut für schnelle Vorschau während der Bearbeitung. |

### Erzeugte PDF-Dateien

| Datei | Inhalt |
|-------|--------|
| `Lebenslauf Julian Wiche.pdf` | Vollständiges Dokument (Anschreiben + Lebenslauf + Anlagen) |
| `cv.pdf` | Nur Lebenslauf (MeineSeite + Tabellarischer Lebenslauf) |
| `application.pdf` | Nur Anschreiben |

### Hilfsbefehle

| Befehl | Beschreibung |
|--------|--------------|
| `make check-deps` | Prüft ob alle benötigten Tools (`lualatex`, `biber`, `python3`) und LaTeX-Pakete installiert sind. Wird automatisch vor jedem Build ausgeführt. |
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
