<?php

/**
 * Fetch notes
 * 
 *  Ritorna tutte le note contenute in un blocco appunti
 * 
 *  @method GET
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_notepad: l'id del blocco appunti associato
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

    $sql = "SELECT * FROM nota WHERE id_blocco=?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("i", $_GET["id_notepad"]);

    if ($stmt->execute()) {



        $notes_result = $stmt->get_result();

        $xml->addChild('success', 'true');
        $xml->addChild('error', '');
        $xml->addChild('id_notepad', $_GET["id_notepad"]);
        $notes = $xml->addChild('notes');

        while ($note_row = $notes_result->fetch_assoc()) {
            $note = $notes->addChild('Note');
            $note->addChild('id', $note_row['id']);  // Attributo id
            $note->addChild('title', htmlspecialchars($note_row['titolo']));
            $note->addChild('body', htmlspecialchars($note_row['corpo']));
        }

        http_response_code(200);
    } else {


        $xml->addChild('success', 'false');
        $xml->addChild('error', 'Error during the reading');
        $xml->addChild('id_notepad', $_GET["id_notepad"]);
        $notes = $xml->addChild('notes', '');
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