<?php  // Moodle configuration file

// Grundkonfiguration
unset($CFG);
global $CFG;
$CFG = new stdClass();

// Datenbankeinstellungen
$CFG->dbtype    = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'mariadb';
$CFG->dbname    = 'moodle';
$CFG->dbuser    = 'moodle';
$CFG->dbpass    = 'deinpasswort';
$CFG->prefix    = 'mdl_';

// Erweiterte DB-Optionen
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => '',
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

// Pfade & Verzeichnisse
$CFG->wwwroot   = 'http://localhost';
$CFG->dataroot  = '/var/www/moodledata';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 0777;

// Moodle Bootstrap
require_once(__DIR__ . '/lib/setup.php');

// Kein PHP-Schluss-Tag zur Vermeidung von Whitespace-Problemen
