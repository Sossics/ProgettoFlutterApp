<?php

/**
 * Delete User
 * 
 *  Eimina un utente:
 * 
 *  @method DELETE
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id: id dell'utente
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

$data = json_decode(file_get_contents('php://input'), true);

if($_SERVER["REQUEST_METHOD"] != "DELETE") {
    echo "Method not allowed. Use DELETE method.";
    http_response_code(405);
    exit;
}else if(verifica_token()){

    if (isset($data["id"]) && isset($data["mod"])) {
        $xml = new SimpleXMLElement('<result/>');

        $sql = "DELETE FROM utente WHERE utente.id = ?";
        $stmt = $conn->prepare($sql);

        $stmt->bind_param("i", $data["id"]);

        if ($stmt->execute()) {
            $xml->addChild('success', 'true');
            $xml->addChild('message', 'Utente eliminato con successo');
            $xml->addChild('error', '');
            http_response_code(200);
        } else {
            $xml->addChild('success', 'false');
            $xml->addChild('message', 'Utente non eliminato');
            $xml->addChild('error', 'Error');
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
        echo "Missing parameters. Required: id, mod";
        http_response_code(400);
    }

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>