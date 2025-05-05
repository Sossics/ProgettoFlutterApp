<?php

/**
 * Edit note title 
 * 
 *  Modificare il titolo di una nota
 * 
 *  @method PATCH
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_note: l'id della nota da modificare
 *      @param title: il titolo della nota
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

$data = json_decode(file_get_contents('php://input'), true);

if($_SERVER["REQUEST_METHOD"] != "PATCH") {
    echo "Method not allowed. Use PATCH method.";
    http_response_code(405);
    exit;
}else if(verifica_token()){

if (isset($data["id_note"]) && isset($data["title"]) && isset($data["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "UPDATE nota SET titolo = ? WHERE nota.id = ?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("si", $data["title"], $data["id_note"]);

    if ($stmt->execute()) {

        $xml->addChild('success', 'true');
        $xml->addChild('message', 'Titolo della nota aggiornato con successo!');
        $xml->addChild('error', '');
        http_response_code(200);
    } else {
        $xml->addChild('success', 'false');
        $xml->addChild('message', 'Nota non aggiornata!');
        $xml->addChild('error', 'Error during the updating');
        http_response_code(401);
    }
    $stmt->close();

    if ($data["mod"] == "xml") {
        header('Content-Type: application/xml');
        echo $xml->asXML();
    } else if ($data["mod"] == "json") {
        header('Content-Type: application/json');
        echo json_encode($xml);
    }
} else {
    echo "Missing parameters. Required: id_note, title, mod";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>