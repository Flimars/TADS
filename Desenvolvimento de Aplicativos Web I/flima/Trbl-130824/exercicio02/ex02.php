<?php
// Dados de conexão com o banco de dados
$servername = "192.168.2.102";
$username = "mysql";
$password = "mysql";
$dbname = "usuarios";

try {
    // Criar conexão com o banco de dados usando PDO
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Consultar os dados da usuária "Ana Clara Rosa"
    $sql = "SELECT * FROM usuarios WHERE nome = :nome";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':nome', $nome);
    $nome = "Ana Clara Rosa";
    $stmt->execute();

    // Exibir os resultados
    if ($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        echo "ID: " . $row["id"] . "<br>";
        echo "Email: " . $row["email"] . "<br>";
        echo "Senha: " . $row["senha"] . "<br>";
        echo "Nome: " . $row["nome"] . "<br>";
        echo "Idade: " . $row["idade"] . "<br>";
    } else {
        echo "Nenhum usuário encontrado.";
    }
} catch(PDOException $e) {
    echo "Erro: " . $e->getMessage();
}

$conn = null;
?>