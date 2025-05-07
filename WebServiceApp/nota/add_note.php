<?php

/**
 * Add note 
 * 
 *  Aggiunge una nuova nota
 * 
 *  @method POST
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_notepad: l'id del blocco appunti associato
 *      @param title: il titolo della nota
 *      @param body: il corpo della nota
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

if ($_SERVER["REQUEST_METHOD"] != "POST") {
    echo "Method not allowed. Only POST is allowed";
    http_response_code(405);
    exit;
} else if (verifica_token()) {
    $input = json_decode(file_get_contents("php://input"), true);
    if (isset($input["id_notepad"]) && isset($input["title"]) && isset($input["body"]) && isset($input["mod"])) {

        $xml = new SimpleXMLElement('<result/>');

        $sql = "INSERT INTO nota (id_blocco, titolo, corpo) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($sql);

        $stmt->bind_param("iss", $input["id_notepad"], $input["title"], $input["body"]);

        if ($stmt->execute()) {

            $xml->addChild('success', 'true');
            $xml->addChild('message', 'Nota creata con successo!');
            $xml->addChild('error', '');
            http_response_code(200);
        } else {
            $xml->addChild('success', 'false');
            $xml->addChild('message', 'Nota non creata');
            $xml->addChild('error', 'Error during the creation');
            http_response_code(401);
        }
        $stmt->close();

        if ($input["mod"] == "xml") {
            header('Content-Type: application/xml');
            echo $xml->asXML();
        } else if ($input["mod"] == "json") {
            header('Content-Type: application/json');
            echo json_encode($xml);
        }
    } else {
        echo "Missing parameters. Required parameters are: id_notepad, title, body and mod";
        http_response_code(400);
    }

} else {
    echo "Token non valido";
    http_response_code(401);
}

?>