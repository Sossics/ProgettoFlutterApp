<?php

/**
 * Unshare note 
 * 
 *  Elimina la condivisione di una nota
 * 
 *  @method DELETE
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_note: l'id della nota da eliminare
 *      @param id_user: l'id della nota da eliminare
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

if (isset($data["id_note"], $data["id_user"]) && $data["id_user"] != null && $data["id_note"] != null  && isset($data["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "DELETE FROM appartiene WHERE appartiene.id_nota = ? AND appartiene.id_utente = ?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("ii", $data["id_note"], $data["id_user"]);

    if ($stmt->execute()) {

        $xml->addChild('success', 'true');
        $xml->addChild('message', 'Condivisione eliminata con successo!');
        $xml->addChild('error', '');
        http_response_code(200);
    
    } else {
    
        $xml->addChild('success', 'false');
        $xml->addChild('message', 'Errore durante l\'eliminazione della condivisione!');
        $xml->addChild('error', 'Error during the deleting');
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
    echo "Missing parameters. Required: id_note, id_user, mod";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>