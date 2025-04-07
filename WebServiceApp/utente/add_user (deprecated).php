<?php

/**
 * Add User (Deprecato)
 * 
 *  Aggiunge un nuovo utente al database:
 * 
 *  @method POST
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param email: email dell'utente
 *      @param name: nome dell'utente
 *      @param surname: cognome dell'utente
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione 
 *   con l'evetuale id dell'utente
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

require '../utils/db.php';
if (isset($_POST["email"]) && isset($_POST["name"]) && isset($_POST["surname"]) && isset($_POST["mod"])) {
    $xml = new SimpleXMLElement('<AuthenticationResults/>');

    $sql = "INSERT INTO utente (email, nome, cognome) VALUES (?, ?, ?);";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("sss", $_POST["email"], $_POST["name"], $_POST["surname"]);

    if ($stmt->execute()) {

        $sql2 = "SELECT id FROM utente WHERE utente.email = ?";
        $stmt2 = $conn->prepare($sql2);

        $stmt2->bind_param("s", $_POST["email"]);
        $stmt2->execute();
        $result2 = $stmt2->get_result();
        $row2 = $result2->fetch_assoc();

        $id = $row2['id'];
        $xml->addChild('success', 'true');
        $xml->addChild('userID', $id);
        $xml->addChild('message', 'Utente inserito con successo (id: ' . $id . ')');
        $xml->addChild('error', '');
        http_response_code(200);
    } else {
        $xml->addChild('success', 'false');
        $xml->addChild('userID', "-1");
        $xml->addChild('message', 'Utente non inserito');
        $xml->addChild('error', 'Error during the insertion');
        http_response_code(401);
    }
    $stmt->close();

    if ($_POST["mod"] == "xml") {
        header('Content-Type: application/xml');
        echo $xml->asXML();
    } else if ($_POST["mod"] == "json") {
        header('Content-Type: application/json');
        echo json_encode($xml);
    }
} else {
    http_response_code(400);
}

?>