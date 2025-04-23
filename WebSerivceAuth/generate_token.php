<?php

/**
 * Genetate Token
 * 
 *  Questo file genera un token JWT per l'utente autenticato.
 * 
 *  @method 
 * 
 *  I parametri richiesti sono:
 * 			@param email: email dell'utente
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
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['email'])) {
    echo json_encode(['error' => 'Parametri mancanti']);
    exit;
}

$email = $auth_conn->real_escape_string($data['email']);

$sql = "SELECT * FROM users WHERE email = ?";
$stmt = $auth_conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
	
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

	echo json_encode([
		'message' => 'Login riuscito',
		'token' => $token,
		'username' => $user['username'],
		'email' => $user['email']
	]);
} else {
    echo json_encode(['error' => 'Utente non trovato']);
}
?>
