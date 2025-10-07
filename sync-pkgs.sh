#!/bin/bash
set -e

# Paketlisten
LISTEN=(
    "https://raw.githubusercontent.com/richrdb/sync-pkgs/refs/heads/main/pkgs-lists/default.txt"
    "https://raw.githubusercontent.com/richrdb/sync-pkgs/refs/heads/main/pkgs-lists/optical.txt"
    "https://raw.githubusercontent.com/richrdb/sync-pkgs/refs/heads/main/pkgs-lists/gaming.txt"
)
DEFAULT=1

# Menü
echo "Welche Paketlisten möchten Sie synchronisieren?"
echo "1) default"
echo "2) optical"
echo "3) gaming"
read -p "Auswahl [Enter = 1]: " AUSWAHL

AUSWAHL=${AUSWAHL:-$DEFAULT}

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
