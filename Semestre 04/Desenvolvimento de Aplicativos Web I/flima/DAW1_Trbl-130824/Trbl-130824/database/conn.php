<?php
// Dados de conexão com o banco de dados
$servername = "localhost";
$dbname = "usuarios";
$username = "root";
$password = "";

try {
    // Criar conexão com o banco de dados usando PDO
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Fechar a conexão
    //$conn = null;

} catch(PDOException $e) {
    echo "Erro: " . $e->getMessage();
}
?>