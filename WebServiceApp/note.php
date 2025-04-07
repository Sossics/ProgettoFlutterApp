<?php


/**
 * Web Service note.php
 */

 /**
 * DocBlock riferito alla classe MyClass.
 *
 * Il web service funziona con un'autenticazione tramite token: 
 *   - Alla registrazione di un nuovo utente viene creato un token di 16 cifre alfanumeriche
 *    - ad ogni accesso sarà necessario questo token 
 * 
 * 
 * Il web service prevede le seguenti operazioni:
 * - auth, che attraverso il token verifica la validità di quest'ultimo (metodo GET, restituisce l'id dell'utente)
 * - checkUsername, che verifica se uno username è già stato utilizzato (metodo GET, restituisce true o false)
 * - fetchNotepads, che restituisce tutti i blocchi appunti e le note associate ad un utente (metodo GET)
 * - addUser, aggiunge uno user ricenvendo username, nome, cognome e generando il suo token (metodo POST, restituisce il token)
 * - createNotepad, crea un blocco appunti (metodo PUT)
 * - newNote, crea una nuova nota (metodo PUT)
 * - shareNote, condifide una nota ad un utente (metodo PUT)
 * - createNotepad, crea un blocco appunti (metodo PUT)
 * - editNoteTitle, modifica il titolo di una nota (metodo PUT)
 * - editNoteBody, modifica il corpo di una nota (metodo PUT)
 * - editNotepadBody, modifica il nome di un blocco appunti (metodo PUT)
 * - deleteNotepad, elimina un blocco appunti (metodo DELETE)
 * - deleteNote, elimina una nota (metodo DELETE)
 * 
 * 
 * Specificando il parametro mod, il web service sarà in grado di generare ogni risposta in XML o in JSON ("xml" o "json" nel parametro mod)
 * 
 * 
 */



$conn = new mysqli("localhost", "root", "", "notely");

//funzione che verifica se un token è presente
function isTokenUsed($token)
{

    global $conn;

    $sql = "SELECT COUNT(*) AS num FROM utente WHERE utente.token = ?";
    $stmt = $conn->prepare($sql);

    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();

    if (isset($row['num']) && $row['num'] == 0) {
        return false;
    } else if ($row['num'] > 0) {
        return true;
    } else {
        return false;
    }
}

//funzione che genera il token
function generateToken($length = 16)
{

    do {
        $token = substr(bin2hex(random_bytes($length)), 0, $length);
    } while (isTokenUsed($token) == true);

    return $token;
}


//operazioni GET
if ($_SERVER['REQUEST_METHOD'] == "GET") {

    //autenticazione (si controlla che il token corrisponda)
    if (isset($_GET["auth"])) {

        if (isset($_GET["token"]) && isset($_GET["mod"])) {
            $xml = new SimpleXMLElement('<AuthenticationResults/>');

            $sql = "SELECT id FROM utente WHERE token = ?";
            $stmt = $conn->prepare($sql);

            $stmt->bind_param("s", $_GET["token"]);
            $stmt->execute();
            $result = $stmt->get_result();
            $row = $result->fetch_assoc();

            if (isset($row['id'])) {
                $id = $row['id'];
                $xml->addChild('success', 'true');
                $xml->addChild('userID', $id);
                $xml->addChild('message', 'Autenticazione riuscita. Benvenuto!');
                $xml->addChild('error', '');
                http_response_code(200);
            } else {
                $xml->addChild('success', 'false');
                $xml->addChild('userID', "-1");
                $xml->addChild('message', 'Autenticazione fallita. Username o password errati');
                $xml->addChild('error', 'Wrong username or password');
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

    //si controlla che lo username esista
    } else if (isset($_GET["checkUsername"])) {

        if (isset($_GET["username"]) && isset($_GET["mod"])) {
            $xml = new SimpleXMLElement('<AuthenticationResults/>');

            $sql = "SELECT COUNT(*) AS num FROM utente WHERE utente.login = ?";
            $stmt = $conn->prepare($sql);

            $stmt->bind_param("s", $_GET["username"]);
            $stmt->execute();
            $result = $stmt->get_result();
            $row = $result->fetch_assoc();

            if (isset($row['num']) && $row['num'] == 0) {
                $xml->addChild('success', 'true');
                $xml->addChild('message', 'Username disponibile!');
                $xml->addChild('error', '');
                http_response_code(200);
            } else {
                $xml->addChild('success', 'false');
                $xml->addChild('userID', "-1");
                $xml->addChild('message', 'Username in uso');
                $xml->addChild('error', 'Usarname already in use');
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

    //si restituiscono tutti i blocchi appunti di un utente 
    } else if (isset($_GET["fetchNotepads"])) {

        if (isset($_GET['token'], $_GET['mod'])) {
            $xml = new SimpleXMLElement('<Store/>'); // Radice <Store>
    
            $sql = "SELECT id, titolo, descrizione FROM blocco b WHERE id_utente = (SELECT id FROM utente WHERE token = ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("s", $_GET["token"]);
            $stmt->execute();
            $result = $stmt->get_result();
            
            if ($result->num_rows > 0) {
                while ($notepad_row = $result->fetch_assoc()) {
                    
                    // Per ogni Notepad, crea un nodo <Notepad> dentro <Store>
                    $notepad = $xml->addChild('NotePad');
                    $notepad->addAttribute('id', $notepad_row['id']);
                    $notepad->addChild('title', $notepad_row['titolo']);
                    $notepad->addChild('description', $notepad_row['descrizione']);

                    // Query per ottenere le Note associate al Notepad
                    $sql_notes = "SELECT id, titolo, corpo FROM nota WHERE id_blocco = ?";
                    $stmt_notes = $conn->prepare($sql_notes);
                    $stmt_notes->bind_param("i", $notepad_row['id']);
                    $stmt_notes->execute();
                    $notes_result = $stmt_notes->get_result();
    
                    while ($note_row = $notes_result->fetch_assoc()) {
                        $note = $notepad->addChild('Note');
                        $note->addAttribute('id', $note_row['id']);  // Attributo id
                        $note->addChild('title', htmlspecialchars($note_row['titolo']));
                        $note->addChild('body', htmlspecialchars($note_row['corpo']));
                    }

                    
                    $stmt_notes->close();
                }
                
                $sql_shared = "SELECT n.id, n.titolo, n.corpo FROM utente t JOIN appartiene ap ON ap.id_utente = t.id JOIN nota n ON ap.id_nota = n.id WHERE t.token = ?";
                $stmt_shared = $conn->prepare($sql_shared);
                $stmt_shared->bind_param("s", $_GET["token"]);
                $stmt_shared->execute();
                $result_shared = $stmt_shared->get_result();

                $notepad = $xml->addChild('NotePad');
                $notepad->addAttribute('id', -2);
                $notepad->addChild('title', "Shared Notes");
                $notepad->addChild('description', "...");

                while ($shared_row = $result_shared->fetch_assoc()) {
                    $note = $notepad->addChild('Note');
                    $note->addAttribute('id', $shared_row['id']);  // Attributo id
                    $note->addChild('title', htmlspecialchars($shared_row['titolo']));
                    $note->addChild('body', htmlspecialchars($shared_row['corpo']));
                }

                $stmt_shared->close();
    
                http_response_code(200);
            } else {
                http_response_code(404); // Nessun Notepad trovato
            }
    
            $stmt->close();
    
            // Output in base al formato richiesto
            if ($_GET["mod"] == "xml") {
                header('Content-Type: application/xml');
                echo $xml->asXML();
            } else if ($_GET["mod"] == "json") {
                header('Content-Type: application/json');
                echo json_encode($xml);
            }
        }
    } else {
        http_response_code(400);
    }
}


//operazioni POST
if ($_SERVER['REQUEST_METHOD'] == "POST") {

    if (isset($_POST["addUser"])) {

        if (isset($_POST["username"]) && isset($_POST["name"]) && isset($_POST["surname"]) && isset($_POST["mod"])) {
            $xml = new SimpleXMLElement('<AuthenticationResults/>');

            $token = generateToken();

            $sql = "INSERT INTO utente (login, token, nome, cognome) VALUES (?, ?, ?, ?);";
            $stmt = $conn->prepare($sql);

            $stmt->bind_param("ssss", $_POST["username"], $token, $_POST["name"], $_POST["surname"]);

            if ($stmt->execute()) {

                $sql2 = "SELECT id FROM utente WHERE utente.login = ?";
                $stmt2 = $conn->prepare($sql2);

                $stmt2->bind_param("s", $_POST["username"]);
                $stmt2->execute();
                $result2 = $stmt2->get_result();
                $row2 = $result2->fetch_assoc();

                $id = $row2['id'];
                $xml->addChild('success', 'true');
                $xml->addChild('userID', $id);
                $xml->addChild('token', $token);
                $xml->addChild('message', 'Utente inserito con successo (token: "' . $token . '")');
                $xml->addChild('error', '');
                http_response_code(200);
            } else {
                $xml->addChild('success', 'false');
                $xml->addChild('userID', "-1");
                $xml->addChild('token', '');
                $xml->addChild('message', 'Utente non inserito');
                $xml->addChild('error', 'Erro during the insertion');
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
    } else {
        http_response_code(400);
    }

//operazioni PUT
} else if ($_SERVER['REQUEST_METHOD'] == "PUT") {

    // Recupero i dati dal php://input
    $data = json_decode(file_get_contents('php://input'), true);

    if(isset($data['route'], $data['title'] , $data['description'], $data['token']) && $data['route'] == "createNotepad"){
        //Aggiugo il blocco note nel database
        $sql = "INSERT INTO blocco (titolo, descrizione, id_utente) VALUES (?, ?, (SELECT id FROM utente WHERE token = ?))";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sss", $data['title'], $data['description'], $data['token']);
        if($stmt->execute()){
            http_response_code(201);
        }else{
            http_response_code(400);
        }
        
    } else if(isset($data['route'], $data['title'], $data['body'], $data['token'], $data['notepad_id']) && $data['route'] == "newNote"){
        //Aggiugo la nota nel database
        $sql = "INSERT INTO nota (titolo, corpo, id_blocco) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssi", $data['title'], $data['body'], $data['notepad_id']);
        if($stmt->execute()){
            http_response_code(201);
        }else{
            http_response_code(400);
        }
        
    } else if(isset($data["route"]) && $data["route"] == "shareNote"){
        if(isset($data['noteID'], $data['usernameTarget'], $data['perx'])){
            //Aggiungo associazione tra utente e nota in appartiene specificando il permesso
            $sql = "INSERT INTO appartiene (id_nota, id_utente, permesso) VALUES (?, (SELECT id FROM utente WHERE login = ?), ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("isi", $data['noteID'], $data['usernameTarget'], $data['perx']);
            if($stmt->execute()){
                http_response_code(201);
            }else{
                http_response_code(400);
            }
        }
    } else if(isset($data["route"]) && $data["route"] == "editNoteTitle"){
        if(isset($data["newTitle"], $data["noteID"])){
            //Modifico il titolo della nota specificata
            $sql = "UPDATE nota SET titolo = ? WHERE id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("si", $data["newTitle"], $data["noteID"]);
            if($stmt->execute()){
                http_response_code(200);
            }else{
                http_response_code(400);
            }
        }
    } else if(isset($data["route"]) && $data["route"] == "editNoteBody"){
        if(isset($data["newBody"], $data["noteID"])){
            //Modifico il titolo della nota specificata
            $sql = "UPDATE nota SET corpo = ? WHERE id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("si", $data["newBody"], $data["noteID"]);
            if($stmt->execute()){
                http_response_code(200);
            }else{
                http_response_code(400);
            }
        }
    } else if(isset($data["route"]) && $data["route"] == "editNotepadBody"){
        if(isset($data["newTitle"], $data["notepadID"])){
            //Modifico il titolo del blocco specificata
            $sql = "UPDATE blocco SET titolo = ? WHERE id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("si", $data["newTitle"], $data["notepadID"]);
            if($stmt->execute()){
                http_response_code(200);
            }else{
                http_response_code(400);
            }
        }
    } 


//operazioni DELETE
} else if ($_SERVER['REQUEST_METHOD'] == "DELETE"){
    
    // Recupero i dati dal php://input
    $data = json_decode(file_get_contents('php://input'), true);

    //eliminazione blocchi appunti
    if(isset($data['route'], $data['notepadID']) && $data['route'] == "deleteNotepad"){
        //Elinino il blocco note nel database
        $sql = "DELETE FROM blocco WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $data['notepadID']);
        if($stmt->execute()){
            http_response_code(200);
        }else{
            http_response_code(400);
        }

    //eliminazione nota
    } else if(isset($data['route'], $data['noteID']) && $data['route'] == "deleteNote"){
        //Elinino la nota nel database
        $sql = "DELETE FROM nota WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $data['noteID']);
        if($stmt->execute()){
            http_response_code(200);
        }else{
            http_response_code(400);
        }
    }

}

$conn->close();

?>