<?php

/**
 * Add notepads
 * 
 *  Aggiunge un nuovo blocco appunti
 * 
 *  @method POST
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_user: id dell'utente
 *      @param title: il titolo del blocco
 *      @param description: la descizione del blocco
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

if($_SERVER["REQUEST_METHOD"] != "POST") {
    echo "Method not allowed. Only POST is allowed";
    http_response_code(405);
    exit;
}else if(verifica_token()){
    $input = json_decode(file_get_contents("php://input"), true);
if (isset($input["title"]) && isset($input["id_user"]) && isset($input["description"]) && isset($input["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "INSERT INTO blocco (id, id_utente, titolo, descrizione) VALUES (NULL,  ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("iss", $input["id_user"], $input["title"], $input["description"]);

    if ($stmt->execute()) {

        $xml->addChild('success', 'true');
        $xml->addChild('message', 'Blocco creato con successo!');
        $xml->addChild('id_notepad', $stmt->insert_id);
        $xml->addChild('error', '');
        http_response_code(200);
    } else {
        $xml->addChild('success', 'false');
        $xml->addChild('message', 'Blocco non creato');
        $xml->addChild('id_notepad', '-1');
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
    echo "Missing parameters. Required: id_user, title, description, mod";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>