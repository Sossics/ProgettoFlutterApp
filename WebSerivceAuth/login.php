<?php
require 'config.php';
require 'db.php';
header('Content-Type: application/json');
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['email'], $data['password'])) {
    echo json_encode(['error' => 'Parametri mancanti']);
    exit;
}
$email = $conn->real_escape_string($data['email']);
$password = $data['password'];

$sql = "SELECT * FROM users WHERE email = '$email'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    if (password_verify($password, $user['password'])) {
        echo json_encode(['message' => 'Login riuscito', 'token' => bin2hex(random_bytes(16))]);
    } else {
        echo json_encode(['error' => 'Credenziali errate']);
    }
} else {
    echo json_encode(['error' => 'Utente non trovato']);
}
?>