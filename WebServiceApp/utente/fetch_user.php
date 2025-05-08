<?php

/**
 * Fetch User
 * 
 *  Recupera i dati di un utente dal database:
 * 
 *  @method GET
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id: id dell'utente
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione 
 *   con l'evetuale id dell'utente
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

if($_SERVER["REQUEST_METHOD"] != "GET") {
    http_response_code(405);
    exit;
}else if (isset($_GET["id"]) && isset($_GET["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "SELECT * FROM utente WHERE id = ?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("i", $_GET["id"]);

    if ($stmt->execute()) {

        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        $xml->addChild('success', 'true');
        $xml->addChild('userID', $row['id']);
        $xml->addChild('name', $row['nome']);
        $xml->addChild('surname', $row['cognome']);
        $xml->addChild('email', $row['email']);
        $xml->addChild('error', '');
        http_response_code(200);
    } else {
        $xml->addChild('success', 'false');
        $xml->addChild('userID', "-1");
        $xml->addChild('name', "");
        $xml->addChild('surname', "");
        $xml->addChild('email', "");
        $xml->addChild('error', 'Utente non trovato');
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
    echo "Missing parameters. Required: id, mod";
    http_response_code(400);
}

?>