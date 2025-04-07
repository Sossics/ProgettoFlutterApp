<?php
$auth_conn = new mysqli(AUTH_DB_HOST, AUTH_DB_USER, AUTH_DB_PASS, AUTH_DB_NAME);
if ($auth_conn->connect_error) {
    die("Connessione fallita: " . $auth_conn->connect_error);
}

$app_conn = new mysqli(APP_DB_HOST, APP_DB_USER, APP_DB_PASS, APP_DB_NAME);
if ($app_conn->connect_error) {
	die("Connessione fallita: " . $app_conn->connect_error);
}
?>