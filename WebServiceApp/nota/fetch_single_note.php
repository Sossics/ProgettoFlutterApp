<?php

/**
 * Fetch singe note
 * 
 *  Ritorna le informazione di una nota
 * 
 *  @method GET
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_note: l'id della nota
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

if($_SERVER["REQUEST_METHOD"] != "GET") {
    echo "Method not allowed. Use GET method.";
    http_response_code(405);
    exit;
}else if(verifica_token()){

if (isset($_GET["id_note"]) && isset($_GET["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "SELECT * FROM nota WHERE id=?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("i", $_GET["id_note"]);

    if ($stmt->execute()) {

        $result = $stmt->get_result()->fetch_assoc();

        $xml->addChild('success', 'true');
        $xml->addChild('id_note', $result["id"]);
        $xml->addChild('id_notepad', $result["id_blocco"]);
        $xml->addChild('title', $result["titolo"]);
        $xml->addChild('body', $result["corpo"]);
        $xml->addChild('error', '');
        http_response_code(200);

    } else {
        
        $xml->addChild('success', 'false');
        $xml->addChild('id_note', $_GET["id_note"]);
        $xml->addChild('id_notepad', '');
        $xml->addChild('title', '');
        $xml->addChild('body', '');
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
    echo "Missing parameters. Required: id_note, mod";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>