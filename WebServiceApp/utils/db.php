<?php

$conn = new mysqli("localhost", "root", "", "notely");
if ($conn->connect_error) {
    die("Connessione fallita: " . $conn->connect_error);
}

require 'verify_token.php';

?>

