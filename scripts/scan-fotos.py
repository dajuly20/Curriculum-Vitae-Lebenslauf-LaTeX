#!/usr/bin/env python3
"""Scannt Fotos im Fotos-Ordner per OCR und gibt erkannte Daten als JSON aus.
Erstellt automatisch pro Firma einen Ordner mit firmendaten.json."""

import json
import os
import re
import subprocess
import sys
from datetime import datetime

FOTOS_DIR = "Bewerbungs-Adressen/Fotos"
GENERIERT_DIR = "Bewerbungs-Adressen/Generierte Bewerbungsdaten"
BEWERBUNGEN_JSON = "Bewerbungs-Adressen/bewerbungen.json"

def check_tesseract():
    try:
        subprocess.run(["tesseract", "--version"], capture_output=True, check=True)
        return True
    except (FileNotFoundError, subprocess.CalledProcessError):
        return False

def ocr_image(path):
    """Fuehrt OCR auf einem Bild aus und gibt den Text zurueck."""
    result = subprocess.run(
        ["tesseract", path, "stdout", "-l", "deu"],
        capture_output=True, text=True
    )
    return result.stdout

def extract_field(text, label):
    """Extrahiert ein Feld nach einem Label."""
    pattern = rf"{label}\s*[:\.]?\s*(.+)"
    match = re.search(pattern, text, re.IGNORECASE)
    return match.group(1).strip() if match else ""

def parse_vermittlungsvorschlag(text):
    """Parst einen Vermittlungsvorschlag vom Jobcenter/Arbeitsagentur."""
    data = {
        "firma": {
            "name": extract_field(text, "Arbeitgeber"),
            "branche": "",
            "webseite": ""
        },
        "ansprechpartner": {
            "anrede": "",
            "vorname": "",
            "nachname": "",
            "position": "",
            "email": "",
            "telefon": ""
        },
        "anschrift": {
            "strasse": "",
            "plz": "",
            "ort": "",
            "land": "Deutschland"
        },
        "stelle": {
            "bezeichnung": extract_field(text, "Stellenangebot"),
            "referenznummer": extract_field(text, "Referenznummer"),
            "quelle": "",
            "arbeitsort": extract_field(text, "Arbeitsort"),
            "arbeitsmodell": extract_field(text, "Arbeitszeit")
        },
        "bewerbung": {
            "datum": extract_field(text, "Datum"),
            "status": "entwurf",
            "foto": ""
        },
        "persoenliche_qualifikation": {
            "staerken": [""],
            "relevante_projekte": [""],
            "motivation": ""
        }
    }

    # Quelle erkennen
    text_lower = text.lower()
    if "jobcenter" in text_lower:
        data["stelle"]["quelle"] = "Jobcenter"
    elif "agentur" in text_lower:
        data["stelle"]["quelle"] = "Agentur fuer Arbeit"

    # Ansprechpartner aus Arbeitgeberkontakt
    kontakt_match = re.search(r"Arbeitgeberkontakt.*?(Frau|Herr)\s+(\w+)\s+(\w+)", text, re.DOTALL)
    if kontakt_match:
        data["ansprechpartner"]["anrede"] = kontakt_match.group(1)
        data["ansprechpartner"]["vorname"] = kontakt_match.group(2)
        data["ansprechpartner"]["nachname"] = kontakt_match.group(3)

    # Adresse aus Arbeitgeberkontakt-Block
    addr_match = re.search(r"(\w[\w\s.-]+(?:Str|str|Straße|straße|Weg|weg|Platz|platz)[\s.]+\d+\w?)\s*\n\s*(\d{5})\s+(.+)", text)
    if addr_match:
        data["anschrift"]["strasse"] = addr_match.group(1).strip()
        data["anschrift"]["plz"] = addr_match.group(2).strip()
        data["anschrift"]["ort"] = addr_match.group(3).strip()

    # URL extrahieren
    url_match = re.search(r"https?://\S+", text)
    if url_match:
        data["firma"]["webseite"] = url_match.group(0)

    return data

def firma_safe_name(name):
    """Erzeugt einen dateisystem-sicheren Firmennamen: Leerzeichen -> -, Sonderzeichen weg."""
    safe = name.replace(' ', '-')
    safe = re.sub(r'[^a-zA-Z0-9\-]', '', safe)
    safe = re.sub(r'-+', '-', safe).strip('-')
    return safe

def next_id(bewerbungen_path):
    """Ermittelt die naechste freie ID aus bewerbungen.json."""
    if not os.path.exists(bewerbungen_path):
        return 1
    with open(bewerbungen_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    ids = [b['id'] for b in data.get('bewerbungen', [])]
    return max(ids) + 1 if ids else 1

def firma_exists(bewerbungen_path, firma_name):
    """Prueft ob eine Firma bereits in bewerbungen.json existiert."""
    if not os.path.exists(bewerbungen_path):
        return False
    with open(bewerbungen_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return any(b['firma']['name'] == firma_name for b in data.get('bewerbungen', []))

def add_to_bewerbungen(bewerbungen_path, entry):
    """Fuegt einen Eintrag zu bewerbungen.json hinzu."""
    if os.path.exists(bewerbungen_path):
        with open(bewerbungen_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    else:
        data = {"bewerbungen": []}

    data['bewerbungen'].append(entry)
    with open(bewerbungen_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    return entry['id']

def create_firma_file(data, foto_filename):
    """Erstellt einen Firmen-Ordner mit firmendaten.json."""
    firma_name = data['firma']['name']
    if not firma_name:
        return None

    safe_name = firma_safe_name(firma_name)
    firma_dir = os.path.join(GENERIERT_DIR, safe_name)
    os.makedirs(firma_dir, exist_ok=True)

    # firmendaten.json mit allen extrahierten Daten
    info = {
        "firma": data["firma"],
        "ansprechpartner": data["ansprechpartner"],
        "anschrift": data["anschrift"],
        "stelle": data["stelle"],
        "bewerbung": data["bewerbung"],
        "persoenliche_qualifikation": data["persoenliche_qualifikation"],
        "scan_info": {
            "gescannt_am": datetime.now().strftime("%Y-%m-%d %H:%M"),
            "quelldatei": foto_filename
        }
    }

    info_path = os.path.join(firma_dir, "firmendaten.json")
    with open(info_path, 'w', encoding='utf-8') as f:
        json.dump(info, f, ensure_ascii=False, indent=2)

    return firma_dir

def main():
    if not check_tesseract():
        print("Fehler: tesseract ist nicht installiert.", file=sys.stderr)
        print("Installieren mit: sudo apt-get install tesseract-ocr tesseract-ocr-deu", file=sys.stderr)
        sys.exit(1)

    if not os.path.isdir(FOTOS_DIR):
        print(f"Fehler: Ordner {FOTOS_DIR} nicht gefunden.", file=sys.stderr)
        sys.exit(1)

    images = [f for f in os.listdir(FOTOS_DIR)
              if f.lower().endswith(('.jpg', '.jpeg', '.png', '.bmp', '.tiff'))]

    if not images:
        print(f"Keine Bilder in {FOTOS_DIR} gefunden.", file=sys.stderr)
        sys.exit(1)

    results = []
    for img in sorted(images):
        img_path = os.path.join(FOTOS_DIR, img)
        print(f"Scanne: {img_path}...", file=sys.stderr)
        text = ocr_image(img_path)
        data = parse_vermittlungsvorschlag(text)
        data["bewerbung"]["foto"] = f"Fotos/{img}"

        # Firmen-Ordner mit firmendaten.json erstellen
        firma_dir = create_firma_file(data, img)
        if firma_dir:
            print(f"  -> Firmen-Ordner erstellt: {firma_dir}", file=sys.stderr)

        # Automatisch zu bewerbungen.json hinzufuegen
        firma_name = data['firma']['name']
        if firma_name and not firma_exists(BEWERBUNGEN_JSON, firma_name):
            new_id = next_id(BEWERBUNGEN_JSON)
            entry = {
                "id": new_id,
                "firma": data["firma"],
                "ansprechpartner": data["ansprechpartner"],
                "anschrift": data["anschrift"],
                "stelle": data["stelle"],
                "bewerbung": data["bewerbung"],
                "persoenliche_qualifikation": data["persoenliche_qualifikation"]
            }
            add_to_bewerbungen(BEWERBUNGEN_JSON, entry)
            print(f"  -> Zu bewerbungen.json hinzugefuegt (ID: {new_id})", file=sys.stderr)
            print(f"  -> Bewerbung generieren mit: make bewerbung ID={new_id}", file=sys.stderr)
        elif firma_name:
            print(f"  -> {firma_name} existiert bereits in bewerbungen.json", file=sys.stderr)

        data["_ocr_rohtext"] = text
        data["_quelldatei"] = img
        results.append(data)

    output = {"scans": results}

    # Scan-Ergebnis speichern
    output_path = os.path.join(FOTOS_DIR, "scan-ergebnis.json")
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    # Auch auf stdout ausgeben (ohne Rohtext fuer Lesbarkeit)
    clean_output = {"scans": []}
    for r in results:
        clean = {k: v for k, v in r.items() if not k.startswith('_')}
        clean_output["scans"].append(clean)
    print(json.dumps(clean_output, ensure_ascii=False, indent=2))

    print(f"\nGespeichert: {output_path}", file=sys.stderr)

if __name__ == '__main__':
    main()
