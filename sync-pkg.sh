#!/bin/bash
set -e

PKGLIST_URL="https://raw.githubusercontent.com/richrdb/sync-pkg/refs/heads/main/pkglist.txt"

# Temporäre Datei
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

echo "📦 Lade Paketliste..."
curl -fsSL "$PKGLIST_URL" -o "$TMPFILE"

echo "📦 Installiere Pakete..."
yay -S --needed --noconfirm - < "$TMPFILE"

echo -e "\e[32m✅ Pakete synchronisiert.\e[0m"
