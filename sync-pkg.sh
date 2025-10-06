#!/bin/bash
set -e

# Prüfen, ob yay installiert ist
if ! command -v yay &> /dev/null; then
    echo "❌ Fehler: yay ist nicht installiert."
    exit 1
fi

# Verschiedene Paketlisten
declare -A LISTEN
LISTEN["1"]="https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/default.txt"
LISTEN["2"]="https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/optical.txt"
LISTEN["3"]="https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/gaming.txt"

# Standardwert auf 1
DEFAULT=("1")

# Menü anzeigen
echo "Welche Paketlisten möchten Sie synchronisieren? [Enter = 1]"
echo "1) Desktop"
echo "2) Server"
echo "3) Gaming"

read -p "Auswahl: " AUSWAHL

# Wenn Enter gedrückt wird, Standard setzen
if [[ -z "$AUSWAHL" ]]; then
    AUSWAHL="${DEFAULT[*]}"
fi

# Temporäre Datei
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

# Download
echo "📦 Lade Paketliste..."
if ! curl -fsSL "$PKGLIST_URL" -o "$TMPFILE"; then
    echo "❌ Fehler: Paketliste konnte nicht geladen werden."
    exit 1
fi

# Installation
echo "📦 Installiere Pakete..."
yay -S --needed - < "$TMPFILE"
echo -e "\e[32m✅ Pakete synchronisiert.\e[0m"
