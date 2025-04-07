<?php
require 'config.php';
$conn = new mysqli(DB_HOST, DB_USER, DB_PASS);
if ($conn->connect_error) {
    die("Connessione fallita: " . $conn->connect_error);
}
$sql = "CREATE DATABASE IF NOT EXISTS " . DB_NAME;
if ($conn->query($sql) === TRUE) {
    echo "Database creato con successo.";
} else {
    echo "Errore nella creazione del database: " . $conn->error;
}
$conn->select_db(DB_NAME);
$tableSql = "CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
)";
if ($conn->query($tableSql) === TRUE) {
    echo "Tabella users creata con successo.";
} else {
    echo "Errore nella creazione della tabella: " . $conn->error;
}
$conn->close();
?> 