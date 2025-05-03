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
    http_response_code(405);
    exit;
}else if(verifica_token()){

if (isset($_POST["title"]) && isset($_POST["id_user"]) && isset($_POST["description"]) && isset($_POST["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "INSERT INTO blocco (id, id_utente, titolo, descrizione) VALUES (NULL,  ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("iss", $_POST["id_user"], $_POST["title"], $_POST["description"]);

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

    if ($_POST["mod"] == "xml") {
        header('Content-Type: application/xml');
        echo $xml->asXML();
    } else if ($_POST["mod"] == "json") {
        header('Content-Type: application/json');
        echo json_encode($xml);
    }
} else {
    http_response_code(400);
}

}else{
    http_response_code(401);
}

?>