#!/bin/bash
set -e

# Prüfen, ob yay installiert ist
if ! command -v yay &> /dev/null; then
    echo "❌ Fehler: yay ist nicht installiert."
    exit 1
fi

# Paketlisten
LISTEN=(
    "https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/default.txt"
    "https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/optical.txt"
    "https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/gaming.txt"
)
DEFAULT=1

# Menü
echo "Welche Paketlisten möchten Sie synchronisieren?"
echo "1) default"
echo "2) optical"
echo "3) gaming"
read -p "Auswahl [Enter = 1]: " AUSWAHL

# Enter = Standard
AUSWAHL=${AUSWAHL:-$DEFAULT}

# Prüfen, ob gültig
if ! [[ "$AUSWAHL" =~ ^[1-3]$ ]]; then
    echo "❌ Ungültige Auswahl"
    exit 1
fi

PKGLIST_URL="${LISTEN[$((AUSWAHL-1))]}"

# Temporäre Datei
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

# Download
echo "📦 Lade Paketliste..."
curl -fsSL "$PKGLIST_URL" -o "$TMPFILE"

# Installation
echo "📦 Installiere Pakete..."
yay -S --needed --noconfirm - < "$TMPFILE"

echo -e "\e[32m✅ Pakete synchronisiert.\e[0m"
