<?php

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
require_once './../../WebSerivceAuth\vendor\autoload.php';
include '../config.php';

    function verifica_token(){

        $headers = apache_request_headers();
        $auth = $headers['Authorization'] ?? null;

        $jwt_token = $auth ?? null;
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
        if ($row["id"] == $decoded->uid) {
            return true;
        } else {
            header('Content-Type: application/json');
            echo json_encode(array("error" => "Id del token non corrispondente con id della persona"), JSON_PRETTY_PRINT);
            return false;
        }

    }

?>

