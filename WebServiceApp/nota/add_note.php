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

if($_SERVER["REQUEST_METHOD"] != "POST") {
    http_response_code(405);
    exit;
}else if(verifica_token()){

if (isset($_POST["id_notepad"]) && isset($_POST["title"]) && isset($_POST["body"]) && isset($_POST["mod"])) {
    $xml = new SimpleXMLElement('<AddingResults/>');

    $sql = "INSERT INTO nota (id, id_blocco, titolo, corpo) VALUES (NULL,  ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("iss", $_POST["id_notepad"], $_POST["title"], $_POST["body"]);

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