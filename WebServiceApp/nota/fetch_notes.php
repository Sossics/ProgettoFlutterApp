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
 *      @param id_notepad: l'id del blocco appunti associato (Facoltativo)
 * 
 *   La risposta è in formato xml o json a seconda del parametro mod e restituisce il risultato dell'operazione
 * 
 *  @version 1.0
 *  @author:  Marco Favaro e Michele Russo
 * 
 **/

 require '../utils/db.php';
 require_once './../../WebSerivceAuth\vendor\autoload.php';
 
 use Firebase\JWT\JWT;
 use Firebase\JWT\Key;
 
 if ($_SERVER["REQUEST_METHOD"] != "GET") {
     http_response_code(405);
     exit;
 } elseif (verifica_token()) {
     
     $headers = apache_request_headers();
     $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
 
     if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
         http_response_code(401);
         exit;
     }
 
     $token = str_replace('Bearer ', '', $authHeader);
 
     try {
         $secret_key = JWT_TOKEN_KEY;
         $decoded = JWT::decode($token, new Key($secret_key, 'HS256'));
         $userId = $decoded->uid;
     } catch (Exception $e) {
         http_response_code(401);
         exit;
     }
 
     if (isset($_GET["mod"])) {
        $xml = new SimpleXMLElement('<result/>');
    
        if (!empty($_GET["id_notepad"])) {
            // Note da un blocco specifico in cui l'utente è l'autore
            $sql = "SELECT n.*
                    FROM nota n
                    INNER JOIN blocco b ON b.id = n.id_blocco
                    WHERE n.id_blocco = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("i", $_GET["id_notepad"]);  // Controllo se l'utente è l'autore o se la nota è condivisa
        } else {
            // Tutte le note dell'utente (da tutti i blocchi che ha creato o che sono stati condivisi con lui)
            $sql = "SELECT n.* 
                    FROM nota n
                    JOIN blocco b ON b.id = n.id_blocco
                    WHERE b.id_utente = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("i", $userId);  // Controllo se l'utente è l'autore del blocco o se la nota è stata condivisa
        }
 
         if ($stmt->execute()) {
             $notes_result = $stmt->get_result();
 
             $xml->addChild('success', 'true');
             $xml->addChild('error', '');
             $xml->addChild('id_notepad', $_GET["id_notepad"] ?? '');
             $notes = $xml->addChild('notes');
 
             while ($note_row = $notes_result->fetch_assoc()) {
                 $note = $notes->addChild('Note');
                 $note->addChild('id', $note_row['id']);
                 $note->addChild('title', htmlspecialchars($note_row['titolo']));
                 $note->addChild('body', htmlspecialchars($note_row['corpo']));
             }
 
             http_response_code(200);
         } else {
             $xml->addChild('success', 'false');
             $xml->addChild('error', 'Error during the reading');
             $xml->addChild('id_notepad', $_GET["id_notepad"] ?? '');
             $xml->addChild('notes', '');
             http_response_code(500);
         }

         $stmt->close();

         if (empty($_GET["id_notepad"])) {

            //recupera le note condivise con un utente
            $sql2 = "SELECT n.*, a.permesso
                    FROM nota n
                    INNER JOIN appartiene a ON a.id_nota = n.id
                    WHERE a.id_utente = ?";
            $stmt2 = $conn->prepare($sql2);
            $stmt2->bind_param("i", $userId);  // Controllo se l'utente è l'autore o se la nota è condivisa
            $shared_notes = $xml->addChild('SharedNotes');

            if ($stmt2->execute()) {
                $shared_result = $stmt2->get_result();
                while ($shared_row = $shared_result->fetch_assoc()) {
                    $note = $shared_notes->addChild('SharedNote');
                    $note->addChild('id', $shared_row['id']);
                    $note->addChild('title', htmlspecialchars($shared_row['titolo']));
                    $note->addChild('body', htmlspecialchars($shared_row['corpo']));
                    $note->addChild('pex', $shared_row['permesso']);
                }
    
                http_response_code(200);
            } else {
                $xml->addChild('notes', '');
                http_response_code(500);
            }
            
         }
 
         if ($_GET["mod"] == "xml") {
             header('Content-Type: application/xml');
             echo $xml->asXML();
         } else {
             header('Content-Type: application/json');
             echo json_encode($xml);
         }
 
     } else {
         http_response_code(400);
     }
 
 } else {
     http_response_code(401);
 }
 ?>