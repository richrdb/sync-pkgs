#!/bin/bash
set -e

# Prüfen, ob yay installiert ist
if ! command -v yay &> /dev/null; then
    echo "❌ Fehler: yay ist nicht installiert."
    exit 1
fi

# Verschiedene Paketlisten
declare -A LISTEN
LISTEN["1"]="https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/pkglist.txt"
LISTEN["2"]="https://raw.githubusercontent.com/USERNAME/REPO/main/server.txt"

echo "Welche Paketliste? (1: Standard, 2: Server)"
read -p "Auswahl: " AUSWAHL

PKGLIST_URL="${LISTEN[$AUSWAHL]}"
[[ -z "$PKGLIST_URL" ]] && { echo "Ungültige Auswahl"; exit 1; }

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
yay -S --needed --noconfirm - < "$TMPFILE"
echo -e "\e[32m✅ Pakete synchronisiert.\e[0m"
