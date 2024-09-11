<?php
session_start();
include('../database/conn.php');

// Verifica se o usuário está logado
if (!isset($_SESSION['id_usuario'])) {
    header("Location: ../index.php");
    exit;
}

// Obtém o ID da consulta a ser excluída
$id_consulta = $_GET['id'] ?? null;

if ($id_consulta) {
    $sql = "DELETE FROM consultas WHERE id = :id AND id_usuario = :id_usuario";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':id', $id_consulta);
    $stmt->bindParam(':id_usuario', $_SESSION['id_usuario']);
    $stmt->execute();

    header("Location: listar.php");
    exit;
} else {
    echo "Consulta não encontrada ou você não tem permissão para excluí-la.";
    exit;
}
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Excluir Consulta</title>
</head>
<body>
    <h1>Excluir Consulta</h1>
    <form action="excluir.php" method="post">
        <!-- Formulário para excluir a consulta -->
    </form>
    <a href="listar.php">Voltar à Lista de Consultas</a>
    <a href="login.php">Voltar à Página Principal</a><br>
</body>
</html>
