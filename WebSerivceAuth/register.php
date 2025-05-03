<?php

/**
 * Register User
 * 
 *  Registra un nuovo utente nel database AUTH e APP
 * 
 *  @method 
 * 
 *  I parametri richiesti sono:
 * 			@param username: nome utente
 * 			@param email: email dell'utente
 * 			@param password: password dell'utente
 * 			@param name: nome dell'utente
 * 			@param surname: cognome dell'utente
 * 
 *   La risposta è in formato json
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/



require 'config.php';
require 'db.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
require_once 'vendor/autoload.php';

header('Content-Type: application/json');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}


$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['username'], $data['email'], $data['password'], $data['name'], $data['surname'])) {
	http_response_code(400);
    echo json_encode(['error' => 'Parametri mancanti']);
    exit;
}
$username_auth = $auth_conn->real_escape_string($data['username']);
$email_auth = $auth_conn->real_escape_string($data['email']);
$password_auth = password_hash($data['password'], PASSWORD_DEFAULT);

$email_app = $app_conn->real_escape_string($data['email']);
$name_app = $app_conn->real_escape_string($data['name']);
$surname_app = $app_conn->real_escape_string($data['surname']);

$sql_app = "INSERT INTO utente (email, nome, cognome) VALUES (?, ?, ?)";
$stmt_app = $app_conn->prepare($sql_app);
$stmt_app->bind_param("sss", $email_app, $name_app, $surname_app);
if($stmt_app->execute()){

	//Retrieve the user ID from the last inserted record
	$last_id = $app_conn->insert_id;
	
	//JWT TOKEN
	$secret_key = JWT_TOKEN_KEY;
	$issuedAt   = time();
	$expiration = $issuedAt + (6 * 60 * 60); // 6 hours

	$payload = [
		'iat' => $issuedAt,
		'exp' => $expiration,
		'username' => $username_auth,
		'email' => $email_auth,
		'uid' => $last_id // id utente dell'app
	];
	
	//Get JWT TOKEN
	$token = JWT::encode($payload, $secret_key, 'HS256');

	// Now insert into the auth database ====================


	$sql_auth = "INSERT INTO users (username, email, password, token, service_user_id) VALUES (?, ?, ?, ?, ?)";
	$stmt = $auth_conn->prepare($sql_auth);
	$stmt->bind_param("ssssi", $username_auth, $email_auth, $password_auth, $token, $last_id);
	if($stmt->execute()) {
		echo json_encode(['message' => 'Registrazione riuscita', 'token' => $token, 'username' => $username_auth, 'email' => $email_auth]);
	} else {
		echo json_encode(['error' => 'Errore registrazione [AUTH]']);
	}
} else {
	echo json_encode(['error' => 'Errore registrazione [APP]']);
}

?>
