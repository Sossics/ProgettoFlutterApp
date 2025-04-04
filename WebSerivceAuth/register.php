<?php
require 'config.php';
require 'db.php';
header('Content-Type: application/json');
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['username'], $data['email'], $data['password'])) {
    echo json_encode(['error' => 'Parametri mancanti']);
    exit;
}
$username = $conn->real_escape_string($data['username']);
$email = $conn->real_escape_string($data['email']);
$password = password_hash($data['password'], PASSWORD_DEFAULT);

$sql = "INSERT INTO users (username, email, password) VALUES ('$username', '$email', '$password')";
if ($conn->query($sql) === TRUE) {
    echo json_encode(['message' => 'Registrazione riuscita', 'token' => bin2hex(random_bytes(16))]);
} else {
    echo json_encode(['error' => 'Errore registrazione']);
}
?>
