<?php

/**
 * Fetch singe notepad
 * 
 *  Ritorna le informazione di un blocco appunti
 * 
 *  @method GET
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_notepad: l'id del blocco appunti
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

if($_SERVER["REQUEST_METHOD"] != "GET") {
    http_response_code(405);
    exit;
}else if(verifica_token()){

if (isset($_GET["id_notepad"]) && isset($_GET["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "SELECT * FROM blocco WHERE id=?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("i", $_GET["id_notepad"]);

    if ($stmt->execute()) {

        $result = $stmt->get_result()->fetch_assoc();

        $xml->addChild('success', 'true');
        $xml->addChild('id_notepad', $result["id"]);
        $xml->addChild('id_user', $result["id_utente"]);
        $xml->addChild('title', $result["titolo"]);
        $xml->addChild('description', $result["descrizione"]);
        $xml->addChild('error', '');
        http_response_code(200);

    } else {
        
        $xml->addChild('success', 'false');
        $xml->addChild('id_notepad', $_GET["id_notepad"]);
        $xml->addChild('id_note', '');
        $xml->addChild('title', '');
        $xml->addChild('description', '');
        $xml->addChild('error', 'Error during the reading');
        http_response_code(401);
    }
    $stmt->close();

    if ($_GET["mod"] == "xml") {
        header('Content-Type: application/xml');
        echo $xml->asXML();
    } else if ($_GET["mod"] == "json") {
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