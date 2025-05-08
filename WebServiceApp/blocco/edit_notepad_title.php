<?php

/**
 * Edit notepad title 
 * 
 *  Modificare il titolo di un blocco
 * 
 *  @method PATCH
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_notepad: l'id della nota da modificare
 *      @param title: il titolo del blocco
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, PATCH, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$data = json_decode(file_get_contents('php://input'), true);

if($_SERVER["REQUEST_METHOD"] != "PATCH") {
    echo "Method not allowed. Use PATCH method.";
    http_response_code(405);
    exit;
}else if(verifica_token()){

if (isset($data["id_notepad"]) && isset($data["title"]) && isset($data["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "UPDATE blocco SET titolo = ? WHERE blocco.id = ?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("si", $data["title"], $data["id_notepad"]);

    if ($stmt->execute()) {

        $xml->addChild('success', 'true');
        $xml->addChild('message', 'Titolo del blocco aggiornato con successo!');
        $xml->addChild('error', '');
        http_response_code(200);
    } else {
        $xml->addChild('success', 'false');
        $xml->addChild('message', 'Blocco non aggiornato!');
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
    echo "Missing parameters. Required: id_notepad, mod, title";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>