<?php
// Inclui o arquivo de configuração da conexão
include('../database/conn.php');

try {
    // Consulta SQL para atualizar o email do usuário com id = 1
    $sql = "UPDATE usuario SET email = :novo_email WHERE id = :id";

    // Preparando a consulta
    $stmt = $conn->prepare($sql);

    // Parâmetros a serem substituídos na consulta
    $novo_email = "profcleberfonseca@gmail.com";
    $id = 1;

    // Vinculando os parâmetros
    $stmt->bindParam(':novo_email', $novo_email);
    $stmt->bindParam(':id', $id);

    // Executando a consulta
    $stmt->execute();

    // Verifica se a consulta foi bem-sucedida
    if ($stmt->rowCount() > 0) {
        echo "O email do usuário foi atualizado com sucesso.";
    } else {
        echo "Nenhuma alteração foi feita. Verifique se o ID do usuário está correto.";
    }
} catch (PDOException $e) {
    echo "Erro: " . $e->getMessage();
}

// Fecha a conexão
$conn = null;
?>
