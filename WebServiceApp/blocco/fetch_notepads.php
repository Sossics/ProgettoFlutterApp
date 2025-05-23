<?php

/**
 * Fetch notepads
 * 
 *  Ritorna tutti i blocchi appunti di un utente
 * 
 *  @method GET
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_user: l'id dell'utente associato
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

if (isset($_GET["id_user"]) && isset($_GET["mod"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "SELECT * FROM blocco WHERE id_utente=?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("i", $_GET["id_user"]);

    if ($stmt->execute()) {



        $notepads_result = $stmt->get_result();

        $xml->addChild('success', 'true');
        $xml->addChild('error', '');
        $xml->addChild('id_user', $_GET["id_user"]);
        $notepads = $xml->addChild('notepads');

        while ($notepads_row = $notepads_result->fetch_assoc()) {
            $notepad = $notepads->addChild('Notepad');
            $notepad->addChild('id', $notepads_row['id']);  // Attributo id
            $notepad->addChild('title', htmlspecialchars($notepads_row['titolo']));
            $notepad->addChild('Description', htmlspecialchars($notepads_row['descrizione']));
        }

        http_response_code(200);
    } else {


        $xml->addChild('success', 'false');
        $xml->addChild('error', 'Error during the reading');
        $xml->addChild('id_user', $_GET["id_user"]);
        $notes = $xml->addChild('notes', '');
        http_response_code(401);
    }
    $stmt->close();

    if ($_GET["mod"] == "xml") {
        header('Content-Type: application/xml');
        echo $xml->asXML();
    } else if ($_GET["mod"] == "json") {
        header('Content-Type: application/json');
    
        $json = [
            "success" => "true",
            "error" => [],
            "id_user" => $_GET["id_user"],
            "notepads" => []
        ];
    
        $stmt = $conn->prepare("SELECT * FROM blocco WHERE id_utente=?");
        $stmt->bind_param("i", $_GET["id_user"]);
    
        if ($stmt->execute()) {
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $json["notepads"][] = [
                    "id" => $row["id"],
                    "title" => $row["titolo"],
                    "Description" => $row["descrizione"]
                ];
            }
            http_response_code(200);
        } else {
            $json["success"] = "false";
            $json["error"] = "Errore nella lettura";
            http_response_code(401);
        }
    
        $stmt->close();
        echo json_encode($json);
    }
    
} else {
    echo "Missing parameters. Required: id_user, mod";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>