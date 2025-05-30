#!/bin/bash

# 📅 Datum und Uhrzeit für den Backup-Ordner
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M)
DAY_DIR="Backup $DATE"
TIME_DIR="Backup (Time $TIME)"

# 📂 Zielverzeichnis erstellen
BACKUP_DIR=$(pwd)/backups/"$DAY_DIR"/"$TIME_DIR"
mkdir -p "$BACKUP_DIR"

echo "🔁 Moodle-Backup wird erstellt nach: $BACKUP_DIR"

# 🗄️ Datenbank-Dump mit offiziellem MySQL-Container
docker run --rm \
  --network $(docker network ls --filter name=moodlenet --format "{{.Name}}") \
  -e MYSQL_PWD=deinpasswort \
  mysql:5.7 \
  mysqldump -h mariadb -u moodle moodle > "$BACKUP_DIR/db_backup.sql"

# 📦 moodledata-Verzeichnis komprimieren
docker run --rm \
  -v $(pwd)/moodledata:/data \
  -v "$BACKUP_DIR":/backup \
  alpine \
  tar czf /backup/moodledata_backup.tar.gz -C /data .

# ✅ Fertigmeldung
echo "✅ Backup abgeschlossen!"
echo "📁 Gespeichert in: $BACKUP_DIR"
