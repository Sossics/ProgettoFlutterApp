<?php

/**
 * Edit note body 
 * 
 *  Modificare il corpo di una nota
 * 
 *  @method PATCH
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_note: l'id della nota da modificare
 *      @param body: il corpo della nota
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

$data = json_decode(file_get_contents('php://input'), true);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, PATCH, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if($_SERVER["REQUEST_METHOD"] != "PATCH") {
    echo "Method not allowed. Use PATCH method.";
    http_response_code(405);
    exit;
}else if(verifica_token()){

if (isset($data["id_note"]) && isset($data["body"]) && isset($data["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "UPDATE nota SET corpo = ? WHERE nota.id = ?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("si", $data["body"], $data["id_note"]);

    if ($stmt->execute()) {

        $xml->addChild('success', 'true');
        $xml->addChild('message', 'Corpo della nota aggiornato con successo!');
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
    echo "Missing parameters. Required: id_note, body, mod";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>