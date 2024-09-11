<?php
    // include('../database.php');
    if (include('../database/conn.php')) {
        echo "Arquivo incluído com sucesso.";
    } else {
        echo "Falha ao incluir o arquivo.";
    }

     // Consultar todos os usuários
     $sql = "SELECT * FROM usuario";
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
?>