<?php
session_start();
include('../database/conn.php');

if (!isset($_SESSION['id_usuario'])) {
    header("Location: ../index.php");
    exit;
}

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
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>Excluir Consulta</h2>
        <form action="excluir.php" method="post">
            <p>Tem certeza que deseja excluir esta consulta?</p>
            <button type="submit" class="btn btn-danger">Excluir</button>
            <a href="listar.php" class="btn btn-secondary">Voltar à Lista de Consultas</a>
        </form>
    </div>
</body>
</html>
