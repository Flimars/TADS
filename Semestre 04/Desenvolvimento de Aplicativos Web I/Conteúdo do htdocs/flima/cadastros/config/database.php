<?php
// config/database.php

$dsn = 'mysql:dbname=cadastros; host=localhost';
$username = 'root';
$password = '';

try {
    $conn = new PDO($dsn, $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

      // Fecha explicitamente a conexão
      //$conn = null;
      
} catch (PDOException $e) {
    echo "Erro de conexão: " . $e->getMessage();
    exit;
}
?>
