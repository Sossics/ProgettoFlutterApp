<?php

/**
 * Login
 * 
 *  Questo file gestisce il login degli utenti.
 * 
 *  @method 
 * 
 *  I parametri richiesti sono:
 * 			@param email: email dell'utente
 * 			@param password: password dell'utente
 * 
 *   La risposta è in formato json
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/


require 'config.php';
require 'db.php';
require_once 'vendor/autoload.php';

use Firebase\JWT\JWT;

header('Content-Type: application/json');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['email'], $data['password'])) {
    echo json_encode(['error' => 'Parametri mancanti']);
    exit;
}

$email = $auth_conn->real_escape_string($data['email']);
$password = $data['password'];

$sql = "SELECT * FROM users WHERE email = ?";
$stmt = $auth_conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();

    if (password_verify($password, $user['password'])) {
        // Genera JWT
        $secret_key = JWT_TOKEN_KEY;
        $issuedAt = time();
        $expiration = $issuedAt + (6 * 60 * 60); // 6 ore

        $payload = [
            'iat' => $issuedAt,
            'exp' => $expiration,
            'uid' => $user['id'],
            'username' => $user['username'],
            'email' => $user['email']
        ];

        $token = JWT::encode($payload, $secret_key, 'HS256');

        $updateSql = "UPDATE users SET token = ? WHERE id = ?";
        $updateStmt = $auth_conn->prepare($updateSql);
        $updateStmt->bind_param("si", $token, $user['id']);
        $updateStmt->execute();
        $updateStmt->close();

        echo json_encode([
            'message' => 'Login riuscito',
            'token' => $token,
            'username' => $user['username'],
            'email' => $user['email']
        ]);
    } else {
        echo json_encode(['error' => 'Credenziali errate']);
    }
} else {
    echo json_encode(['error' => 'Utente non trovato']);
}
?>
