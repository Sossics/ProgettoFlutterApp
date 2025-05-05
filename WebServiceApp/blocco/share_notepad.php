<?php

/**
 * Share notepad
 * 
 *  Condivide un blocco con un altro utente
 * 
 *  @method GET
 * 
 *  I parametri richiesti sono:
 *      @param mod: formato di risposta (xml o json)
 *      @param id_notepad: id della nota da condividere
 *      @param email: email dell'utente con cui condividere la nota
 *      @param permission: permesso di condivisione (1 = lettura, 2 = scrittura)
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

if (isset($_GET["id_notepad"]) && isset($_GET["mod"]) && isset($_GET["email"]) && isset($_GET["permission"])) {
    $xml = new SimpleXMLElement('<result/>');

    $sql = "SELECT * FROM utente WHERE email = ?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("s", $_GET["email"]);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {

        $row = $result->fetch_assoc();

        $id_utente = $row["id"];

        $sql1 = "SELECT id FROM nota WHERE id_blocco = ?";
        $stmt1 = $conn->prepare($sql1);
        $stmt1->bind_param("i", $_GET["id_notepad"]);

        if($stmt1->execute()){

            $result1 = $stmt1->get_result();

            if ($result1->num_rows > 0) {
                
                $sql2 = "INSERT INTO appartiene (id_utente, id_nota, permesso) VALUES (?, ?, ?)";
                $stmt2 = $conn->prepare($sql2);
                $stmt2->bind_param("iii", $id_utente, $id_nota, $_GET["permission"]);

                while ($row1 = $result1->fetch_assoc()) {
                    $id_nota = $row1["id"];
                    $stmt2->execute();
                }

                $xml->addChild('success', 'true');
                $xml->addChild('message', 'Blocco condiviso con successo!');
                $xml->addChild('error', '');
                http_response_code(200);

            }else{
                $xml->addChild('success', 'false');
                $xml->addChild('message', 'Blocco non trovato!');
                $xml->addChild('error', 'Error during the share notepad operation');
                http_response_code(404);
            }

        }else{

            $xml->addChild('success', 'false');
            $xml->addChild('message', 'Errore durante la condivisione');
            $xml->addChild('error', 'Error during the share notepad operation');
            http_response_code(400);

        }

    } else {


        $xml->addChild('success', 'false');
        $xml->addChild('message', 'Utente non trovato!');
        $xml->addChild('error', 'Error during the share notepad operation');
        http_response_code(404);
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
    echo "Missing parameters. Required: id_notepad, mod, email, permission";
    http_response_code(400);
}

}else{
    echo "Token non valido";
    http_response_code(401);
}

?>