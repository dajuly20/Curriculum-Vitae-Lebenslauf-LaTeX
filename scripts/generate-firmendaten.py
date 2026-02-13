#!/usr/bin/env python3
"""Liest eine Bewerbung aus bewerbungen.json und generiert firmendaten.tex."""

import json
import re
import sys
import os

def escape_latex(text):
    """Escaped LaTeX-Sonderzeichen."""
    if not text:
        return ""
    replacements = [
        ('\\', '\\textbackslash{}'),
        ('&', '\\&'),
        ('%', '\\%'),
        ('$', '\\$'),
        ('#', '\\#'),
        ('_', '\\_'),
        ('{', '\\{'),
        ('}', '\\}'),
        ('~', '\\textasciitilde{}'),
        ('^', '\\textasciicircum{}'),
    ]
    for old, new in replacements:
        text = text.replace(old, new)
    return text

def find_bewerbung(data, key):
    """Findet eine Bewerbung per ID (Zahl) oder Firmenname (Text)."""
    # Versuch als ID
    try:
        bewerbung_id = int(key)
        for b in data['bewerbungen']:
            if b['id'] == bewerbung_id:
                return b
    except ValueError:
        pass

    # Suche per Firmenname (case-insensitive, Teilmatch)
    key_lower = key.lower().replace('-', ' ')
    for b in data['bewerbungen']:
        firma_lower = b['firma']['name'].lower()
        if key_lower in firma_lower or firma_lower in key_lower:
            return b

    # Suche per safe-name (z.B. "Virtual-Minds-GmbH")
    for b in data['bewerbungen']:
        safe = b['firma']['name'].replace(' ', '-').replace('/', '-').lower()
        if key_lower.replace(' ', '-') == safe:
            return b

    return None

def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <bewerbungen.json> <id|firmenname> [output-dir]", file=sys.stderr)
        sys.exit(1)

    json_path = sys.argv[1]
    key = sys.argv[2]
    output_dir = sys.argv[3] if len(sys.argv) > 3 else "."

    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    bewerbung = find_bewerbung(data, key)

    if not bewerbung:
        print(f"Fehler: Bewerbung '{key}' nicht gefunden.", file=sys.stderr)
        print(f"Verfuegbare Eintraege:", file=sys.stderr)
        for b in data['bewerbungen']:
            print(f"  ID {b['id']}: {b['firma']['name']}", file=sys.stderr)
        sys.exit(1)

    bewerbung_id = bewerbung['id']

    firma = bewerbung['firma']
    ap = bewerbung['ansprechpartner']
    adr = bewerbung['anschrift']
    stelle = bewerbung['stelle']
    qual = bewerbung['persoenliche_qualifikation']

    plz_ort = f"D-{adr['plz']} {adr['ort']}"

    # Anredetext: mit Leerzeichen davor fuer "Sehr geehrte Frau ..."
    anrede_text = f" {ap['anrede']}" if ap['anrede'] else "r Herr/Frau"
    anrede_kopf = ap['anrede'] if ap['anrede'] else "Herr/Frau"

    # Anschreibentext generieren
    anschreiben_parts = []
    if stelle.get('quelle') and stelle.get('referenznummer'):
        anschreiben_parts.append(
            f"Von der {stelle['quelle']} habe ich einen Vermittlungsvorschlag "
            f"für die ausgeschriebene Stelle als {stelle['bezeichnung']}, "
            f"(Referenznr.: {stelle['referenznummer']}) erhalten."
        )
    else:
        anschreiben_parts.append(
            f"mit großem Interesse habe ich Ihre Stellenausschreibung als "
            f"{stelle['bezeichnung']} gelesen."
        )
    anschreiben_parts.append("Sehr gerne bewerbe ich mich deshalb um diese Stelle bei Ihnen.")

    if qual.get('motivation'):
        anschreiben_parts.append(qual['motivation'])

    # Teile einzeln escapen, dann mit raw LaTeX-Befehl joinen
    anschreiben = "\n\n\\vspace{1em}\n\n".join(escape_latex(p) for p in anschreiben_parts)

    # Firmennamen fuer Dateinamen (sicher): Leerzeichen -> -, Sonderzeichen weg
    firma_safe = firma['name'].replace(' ', '-')
    firma_safe = re.sub(r'[^a-zA-Z0-9\-]', '', firma_safe)
    firma_safe = re.sub(r'-+', '-', firma_safe).strip('-')

    lines = [
        f"% Auto-generiert aus bewerbungen.json (ID: {bewerbung_id})",
        f"% Firma: {firma['name']}",
        f"",
        f"\\renewcommand*{{\\Firma}}{{{escape_latex(firma['name'])}}}",
        f"\\renewcommand*{{\\AdressatVorname}}{{{escape_latex(ap['vorname'])}}}",
        f"\\renewcommand*{{\\AdressatNachname}}{{{escape_latex(ap['nachname'])}}}",
        f"\\renewcommand*{{\\AnschriftStrasse}}{{{escape_latex(adr['strasse'])}}}",
        f"\\renewcommand*{{\\AnschriftPLZOrt}}{{{escape_latex(plz_ort)}}}",
        f"\\renewcommand*{{\\AnredeKopf}}{{{anrede_kopf}}}",
        f"\\renewcommand*{{\\AnredeText}}{{{anrede_text}}}",
        f"\\renewcommand*{{\\Bewerberstelle}}{{{escape_latex(stelle['bezeichnung'])}}}",
        f"\\renewcommand{{\\AnschreibenText}}{{%",
        f"    {{\\itshape",
        f"        {escape_latex(anschreiben)}",
        f"    }}",
        f"}}",
    ]

    os.makedirs(output_dir, exist_ok=True)
    tex_path = os.path.join(output_dir, "firmendaten.tex")
    with open(tex_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')

    # Metadaten-Datei mit Firmenname fuer Makefile
    meta_path = os.path.join(output_dir, "firma.txt")
    with open(meta_path, 'w', encoding='utf-8') as f:
        f.write(firma_safe)

    print(f"Generiert: {tex_path} ({firma['name']})")

if __name__ == '__main__':
    main()
