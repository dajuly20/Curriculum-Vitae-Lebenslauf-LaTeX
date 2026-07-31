# CLAUDE.md — Curriculum-Vitae-Lebenslauf-LaTeX

## Projektübersicht

LaTeX-Bewerbungsvorlage für Julian Wiche. Erzeugt bis zu 3 PDFs aus einer gemeinsamen Quelldatei:
- `Lebenslauf Julian Wiche.pdf` — vollständiges Dokument (Anschreiben + Lebenslauf + Anlagen)
- `cv.pdf` — nur Lebenslauf
- `application.pdf` — nur Anschreiben

## Build-System

```bash
make          # alle 3 PDFs bauen (Standard)
make cv       # nur cv.pdf
make application  # nur application.pdf
make bewerbung <Firma>  # Firmenbewerbung aus bewerbungen.json
make draft    # Schnell-Vorschau ohne Biber
make clean    # output/ leeren
make clean-all  # alle temporären LaTeX-Dateien löschen
```

Compiler: **lualatex** (nicht pdflatex). Ausgabe nach `output/`.

## Dateistruktur

```
src/
  bewerbung.tex       # Hauptdatei: Inhalte + Metadaten (Name, Adresse, etc.)
  befehle.tex         # Pakete, Makros, Layout-Definitionen
  cv.tex              # Wrapper: setzt \NurLebenslauf, lädt bewerbung.tex
  application.tex     # Wrapper: setzt \NurAnschreiben, lädt bewerbung.tex
  firmendaten.tex     # Temporär: wird von generate-firmendaten.py erzeugt
bilder/               # Bewerbungsfoto, Signatur
pdf_anlagen/          # Zeugnisse als PDF (werden per \includepdf eingebunden)
Bewerbungs-Adressen/
  bewerbungen.json    # Firmendaten für make bewerbung
  Generierte Bewerbungsdaten/  # Ausgabe von make bewerbung
scripts/
  generate-firmendaten.py  # Generiert firmendaten.tex aus JSON
  scan-fotos.py            # OCR für gescannte Fotos
output/               # LaTeX-Ausgabeverzeichnis (gitignored bis auf PDFs)
```

## Bedingte Kompilierung

`bewerbung.tex` nutzt zwei Flags (gesetzt in den Wrapper-Dateien):

| Flag | Effekt |
|------|--------|
| `\NurLebenslauf` | Überspringt Anschreiben; Anlagen werden nicht eingebunden |
| `\NurAnschreiben` | Überspringt Lebenslauf und Anlagen |
| (keins) | Vollständiges Dokument |

## Wichtige LaTeX-Details

- **Babel**: `\babelprovide[main, import]{ngerman}` — nicht `\usepackage[ngerman]{babel}` (inkompatibel mit LuaLaTeX + neuem babel)
- **Fonts**: `\usepackage[T1]{fontenc}` + `\usepackage{charter}` — kein `inputenc` (nicht nötig bei LuaLaTeX, war Ursache des ß-Problems) und kein `lmodern` (wird von charter ersetzt)
- Dokumentklasse: `scrartcl` (KOMA-Script)
- Firmendaten werden über `\IfFileExists{firmendaten.tex}{\input{firmendaten.tex}}{}` geladen und überschreiben die Standardwerte in `bewerbung.tex`

## Inhalt anpassen

Persönliche Daten, Anschreiben-Text und Lebenslauf-Einträge stehen direkt in `src/bewerbung.tex` ab Zeile ~15. Neue Firmen für `make bewerbung` werden in `Bewerbungs-Adressen/bewerbungen.json` gepflegt.
