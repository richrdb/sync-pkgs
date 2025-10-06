#!/bin/bash
set -e

# 🔗 Dein GitHub-Link
PKGLIST_URL="https://raw.githubusercontent.com/richrdb/pkglist/refs/heads/main/pkglist.txt"

# 📁 Temporäre Datei
TMPFILE=$(mktemp)

echo "📦 Lade Paketliste..."
curl -fsSL "$PKGLIST_URL" -o "$TMPFILE"

echo "📦 Installiere/aktualisiere Pakete..."
yay -S --needed --noconfirm - < "$TMPFILE"

echo "✅ Pakete synchronisiert."