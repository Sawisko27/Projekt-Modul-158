#!/bin/bash
 
# Datum und Zeit für Ordnernamen
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M)
 
# Schöne Namen
DAY_DIR="Backup $DATE"
TIME_DIR="Backup (Time $TIME)"
 
# Zielpfad
BACKUP_DIR=$(pwd)/backups/"$DAY_DIR"/"$TIME_DIR"
mkdir -p "$BACKUP_DIR"
 
echo "🔁 Moodle-Backup wird erstellt nach: $BACKUP_DIR"
 
# SQL-Dump via Tool-Container
docker run --rm \
  --network $(docker network ls --filter name=moodlenet --format "{{.Name}}") \
  -e MYSQL_PWD=deinpasswort \
  mysql:5.7 \
  mysqldump -h mariadb -u moodle moodle > "$BACKUP_DIR/db_backup.sql"
 
# moodledata sichern
docker run --rm \
  -v $(pwd)/moodledata:/data \
  -v "$BACKUP_DIR":/backup \
  alpine \
  tar czf /backup/moodledata_backup.tar.gz -C /data .
 
echo "✅ Backup abgeschlossen!"
echo "📁 Gespeichert in: $BACKUP_DIR"