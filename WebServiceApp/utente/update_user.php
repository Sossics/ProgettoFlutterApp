<?php

/**
 * Update User
 * 
 *  Modifica un utente:
 * 
 *  @method PUT
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id: id dell'utente
 *      @param name: nome dell'utente
 *      @param surname: cognome dell'utente
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';

$data = json_decode(file_get_contents('php://input'), true);

if(isset($data["token"]) && verifica_token($data["token"])){

    if (isset($data["name"]) && isset($data["id"])&& isset($data["surname"]) && isset($data["mod"])) {
        $xml = new SimpleXMLElement('<UpdateResult/>');

        $sql = "UPDATE utente SET nome = ?, cognome = ? WHERE utente.id = ?";
        $stmt = $conn->prepare($sql);

        $stmt->bind_param("ssi", $data["name"], $data["surname"], $data["id"]);

        if ($stmt->execute()) {

            $xml->addChild('success', 'true');
            $xml->addChild('message', 'Utente modificato con successo');
            $xml->addChild('error', '');
            http_response_code(200);
        } else {
            $xml->addChild('success', 'false');
            $xml->addChild('message', 'Utente non modificato');
            $xml->addChild('error', 'Error during the update');
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
        http_response_code(400);
    }

}else{
    http_response_code(401);
}

?>