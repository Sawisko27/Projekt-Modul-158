# 📘Projekt-Modul-158 Anleitung: Moodle und Docker
-----------------------------------------------
Dieses Repository dokumentiert Schritt für Schritt, wie eine bestehende Moodle 3.10.11 Instanz in eine moderne, containerisierte Umgebung überführt und anschliessend auf Moodle 5.0 aktualisiert wird.  
* * * * *
🧰 Voraussetzungen
------------------
Zuerst muss sichergestellt werden, dass die folgenden Tools installiert sind:
-   Docker
-   Docker Compose (ab Docker v2 bereits integriert)
-   Moodle 3.10.11 Umgebung (alt):
    -   `moodledata/` Verzeichnis (Dateien, Kursmaterialien, etc.)
    -   SQL-Dump der Datenbank, z. B. `dump.sql`
* * * * *
📁 Projektstruktur
------------------
Die Verzeichnisstruktur des Projektes soll wie folgt aussehen:
- Projekt-Modul-158
  - **Configfiles**: Verzeichnis, das die Docker-Konfigurationsdateien enthält.
    - **Dockerfiles**:
      - **Dockerfile1**: Erste Konfigurationsdatei für Moodle Version 4.1.2
      - **Dockerfile2**: Zweite Konfigurationsdatei für Moodle Version 4.2.3
      - **Dockerfile3**: Dritte Konfigurationsdatei für Moodle Version 5.0
    - **backup_moodle.sh**: Datei für das Backup
    - **config.php**: Hauptkonfigurationsdatei für das Projekt.
    - **docker-compose.yml**: Datei zur Definition und Ausführung von Docker-Containern.
  - **README.md**: Diese Anleitung.
* * * * *
🚀 Schritt-für-Schritt-Anleitung
--------------------------------
🔄 1. Repository klonen
------------------------
```
git clone https://github.com/Sawisko27/Projekt-Modul-158.git
cd Projekt-Modul-158
```
🔐 2. Backup erstellen (aus Moodle 3.10.11)
-------------------------------------------
Bevor irgendetwas migriert oder aktualisiert wird, erstellen wir ein Backup der bestehenden Moodle 3.10.11 Datenbank mit der backup_moodle.sh Datei:
```
cd ./Configfiles
chmod +x backup_moodle.sh
./backup_moodle.sh
```
Als Alternative kann das Backup auch manuell gemacht werden:
```
mysqldump -u moodle -p moodle > moodle_dump.sql
```
Und dann:
```
cp -r /pfad/zur/alten/moodledata ./moodledata
```

🆙 Schritt 3: Migration vorbereiten
-----------------------------------
### 📦 3.1 Moodle 4.1.2 Umgebung starten
```
cp Configfiles/Dockerfile1 Dockerfile
```
Dateiberechtigungen setzen:
```
sudo chown -R 33:33 moodledata
sudo chmod -R 755 moodledata
```
Dann Container starten:
```
docker compose up --build -d
```

💾 Schritt 4: SQL-Dump importieren
----------------------------------
Sobald die Container laufen, kannst du die alte Datenbank importieren.
### 🔁 Variante A: CLI-Import
```
docker exec -i mariadb mysql -u moodle -pdeinpasswort moodle < moodle_dump.sql
```
### 🖥️ Variante B: Import über phpMyAdmin
1.  Öffne <http://localhost:8081>
2.  Login:
    -   Benutzer: `moodle`
    -   Passwort: `deinpasswort`
3.  Wähle die Datenbank `moodle`
4.  Navigiere zu **Importieren**
5.  Wähle die Datei ```moodle_dump.sql``` aus und starte den Import

🔧 Schritt 5: Web-Upgrade in Moodle
-----------------------------------
Rufe im Browser auf:
```
http://localhost:80
```
Moodle erkennt die alte Datenbankstruktur und startet die Aktualisierung über das Webinterface:
<img src="https://github.com/user-attachments/assets/6f58f780-f96b-45e5-a2c9-f5419be6086d" width="500"/> 
    
Danach geht man alle gefundene Services durch und scrollt bis ganz am Schluss auf ```Continue```:
<img src="https://github.com/user-attachments/assets/f0afb23a-d552-4c00-a95d-632cc5097d92" width="500"/>

Dann muss man seine eigene Mail-Adresse hinzufügen, wie hier im Beispiel:
<img src="https://github.com/user-attachments/assets/0040808d-3837-41f1-9503-e29769bf5235" width="500"/>

Hier wird man ebenfalls aufgefordert allfällige Einstellung und Änderungen vorzunehmen, jedoch kann man diese so stehen lassen und weiter unten auf ```Save Changes``` bestätigen.  
<img src="https://github.com/user-attachments/assets/16443ab2-3dbb-40fe-86b6-dd1af5e4bfa4" width="600"/>

Sobald man den gesamten Dialog durchgegangen ist, muss man sich mit den Credentials ```vmadmin / Riethuesli>12345``` anmelden und oben links auf ```Home``` gehen. Zum einen erkennt man hier die vollständig migrierten Kurse und Daten...
<img src="https://github.com/user-attachments/assets/72d7b999-205a-4ea8-ac48-5ac03cb3a2fc" width="600"/>

... und wenn man unten rechts auf das Fragezeichen-Symbol klickt, erkennt man ganz klar die aktuell geladene Version vom Moodle (Beispiel: Version 5.0):
  
<img src="https://github.com/user-attachments/assets/f2934d21-f17c-49b7-a5d3-5a7abc1a20d3" width="250"/>

🔄 Schritt 6: Weitere Upgrades durchführen
------------------------------------------
### ⬆️ Upgrade 4.1.2 → 4.2.3
Zuerst alles stoppen mit:
```
docker compose down -v
```
Und dann weiterforfahren:
```
cp Configfiles/Dockerfile2 Dockerfile
docker compose up --build -d
```
Danach im Browser wieder `http://localhost:80` aufrufen und die Datenbankmigration wie bei Schritt 5 durchführen.
### ⬆️ Upgrade 4.2.3 → 5.0
Wie vorhin, die folgenden drei Befehle durchführen:
```
docker compose down -v
cp Configfiles/Dockerfile3 Dockerfile
docker compose up --build -d
```
Und das ganze wieder im Browser upgraden.

📌 Hinweise
-----------
-   `mariadb` basiert auf `mariadb:latest`
-   `phpmyadmin` verwendet `phpmyadmin/phpmyadmin`
-   Die Datenbank `moodle` wird automatisch beim ersten Start erstellt
-   `config.php` und `moodledata/` sind versionenunabhängig verwendbar
-   Backup-Skript speichert Daten strukturiert mit Zeitstempel
