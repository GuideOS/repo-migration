#!/bin/bash

# Skript zum Austauschen der GuideOS Repository-URL
# Ändert https://guideos.eu/repo zu https://repo.guideos.de

SOURCE_FILE="/etc/apt/sources.list.d/guideos.sources"
OLD_URI="https://guideos.eu/repo"
NEW_URI="https://repo.guideos.de"

# Prüfen ob die Datei existiert
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Fehler: Datei $SOURCE_FILE nicht gefunden!"
    exit 1
fi

# Prüfen ob die alte URI in der Datei vorhanden ist
if ! grep -q "$OLD_URI" "$SOURCE_FILE"; then
    echo "Warnung: $OLD_URI wurde nicht in $SOURCE_FILE gefunden."
    echo "Möglicherweise wurde die Änderung bereits durchgeführt."
    exit 0
fi

# Backup erstellen
BACKUP_FILE="${SOURCE_FILE}.backup.$(date +%Y%m%d-%H%M%S)"
echo "Erstelle Backup: $BACKUP_FILE"
cp "$SOURCE_FILE" "$BACKUP_FILE"

# URI austauschen
echo "Tausche $OLD_URI gegen $NEW_URI aus..."
sed -i "s|$OLD_URI|$NEW_URI|g" "$SOURCE_FILE"

# Überprüfen ob die Änderung erfolgreich war
if grep -q "$NEW_URI" "$SOURCE_FILE"; then
    echo "✓ Erfolgreich! Die URI wurde aktualisiert."
    echo "Backup wurde gespeichert unter: $BACKUP_FILE"
else
    echo "✗ Fehler: Die Änderung konnte nicht durchgeführt werden."
    echo "Stelle Backup wieder her..."
    cp "$BACKUP_FILE" "$SOURCE_FILE"
    exit 1
fi
