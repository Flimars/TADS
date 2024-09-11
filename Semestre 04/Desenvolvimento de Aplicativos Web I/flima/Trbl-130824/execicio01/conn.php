<?php
// Dados de conexão com o banco de dados
$servername = "localhost";
$username = "mysql";
$password = "mysql";
$dbname = "usuarios";

try {
    // Criar conexão com o banco de dados usando PDO
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Consultar todos os usuários
    $sql = "SELECT * FROM usuarios";
    $result = $conn->query($sql);

    // Exibir os resultados
    echo "<table border='1'>";
    echo "<tr><th>ID</th><th>Email</th><th>Senha</th><th>Nome</th><th>Idade</th></tr>";
    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
        echo "<tr>";
        echo "<td>" . $row["id"] . "</td>";
        echo "<td>" . $row["email"] . "</td>";
        echo "<td>" . $row["senha"] . "</td>";
        echo "<td>" . $row["nome"] . "</td>";
        echo "<td>" . $row["idade"] . "</td>";
        echo "</tr>";
    }
    echo "</table>";
} catch(PDOException $e) {
    echo "Erro: " . $e->getMessage();
}

$conn = null;
?>