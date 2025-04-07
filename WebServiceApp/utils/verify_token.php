<?php

    function verifica_token($token){

        $auth_conn = new mysqli("localhost", "DEV", "russofavaro", "authentication");
        if ($auth_conn->connect_error) {
            die("Connessione fallita: " . $auth_conn->connect_error);
        }
        //Check if token exists (not null) in table users
        $sql = "SELECT * FROM users WHERE token = ?";
        $stmt = $auth_conn->prepare($sql);
        $stmt->bind_param("s", $token);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        if ($row) {
            //Check if token is expired
            $expiration_time = $row['expiration_time'];
            $current_time = date("Y-m-d H:i:s");
            if ($current_time > $expiration_time) {
                return false; // Token expired
            } else {
                return true; // Token valid
            }
        } else {
            return false; // Token not found
        }

    }

?>

