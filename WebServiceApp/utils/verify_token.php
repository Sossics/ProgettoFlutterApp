<?php

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
require_once './../../WebSerivceAuth\vendor\autoload.php';
include '../config.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

    function verifica_token(){

        $headers = apache_request_headers();
        $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? null;

        $jwt_token = $auth ?? null;

        if (isset($headers['Authorization'])) {
            $jwt_token = $headers['Authorization'];
        }

        if (isset($headers['authorization'])) {
            $jwt_token = $headers['authorization'];
        }

        $secret_key = JWT_TOKEN_KEY; // deve essere uguale a quella usata per generare il token
        
        //echo json_encode($auth, JSON_PRETTY_PRINT);
        
        if (!$jwt_token || !str_starts_with($jwt_token, 'Bearer ')) {
            header('Content-Type: application/json');
            echo json_encode(array("error" => "Token non valido o assente"), JSON_PRETTY_PRINT);
            return false;
        }

        $token = str_replace('Bearer ', '', $jwt_token);

        try {
            $decoded = JWT::decode($token, new Key($secret_key, 'HS256'));
        } catch (Exception $e) {
            header('Content-Type: application/json');
            echo json_encode(array("error" => "Token non valido o scaduto"), JSON_PRETTY_PRINT);
            return false;
        }

        $auth_conn = new mysqli("localhost", "root", "", "authentication");
        if ($auth_conn->connect_error) {
            die("Connessione fallita: " . $auth_conn->connect_error);
        }

        $sql = "SELECT * FROM users WHERE token = ?";
        $stmt = $auth_conn->prepare($sql);
        $stmt->bind_param("s", $token);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        if (isset($row["service_user_id"]) && $row["service_user_id"] == $decoded->uid) {
            return true;
        } else {
            header('Content-Type: application/json');
            echo json_encode(array("error" => "Id del token non corrispondente con id della persona"), JSON_PRETTY_PRINT);
            return false;
        }

    }

?>

