<?php

    // include('../database.php');
    if (include('../database/conn.php')) {
        echo "Arquivo incluído com sucesso.";
    } else {
        echo "Falha ao incluir o arquivo.";
        exit;
    }

    // Consultar os dados da usuária "Ana Clara Rosa"
    $sql = "SELECT * FROM usuario WHERE nome = :nome";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':nome', $nome);
    $nome = "Ana Clara Rosa";
    $stmt->execute();

    // Exibir os resultados
    if ($stmt->rowCount() > 0) {
        echo "<table border='1'>";
        echo "<tr><th>ID</th><th>Email</th><th>Senha</th><th>Nome</th><th>Idade</th></tr>";

        while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "<tr>";
            echo "<td>" . $row["id"] . "</td>";
            echo "<td>" . $row["email"] . "</td>";
            echo "<td>" . $row["senha"] . "</td>";
            echo "<td>" . $row["nome"] . "</td>";
            echo "<td>" . $row["idade"] . "</td>";
            echo "</tr>";
        }

        echo "</table>";

    } else {
        echo "Nenhum usuário encontrado.";
    }
// Fecha a conexão    
// $conn = null;
?>