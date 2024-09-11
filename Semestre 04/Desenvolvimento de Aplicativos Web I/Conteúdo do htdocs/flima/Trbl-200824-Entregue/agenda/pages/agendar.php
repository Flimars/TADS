<?php
session_start();
include('../database/conn.php');

// Verifica se o usuário está logado
if (!isset($_SESSION['id_usuario'])) {
    header("Location: ./index.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = $_POST['data'];
    $hora = $_POST['hora'];
    $motivo = $_POST['motivo'];
    $id_usuario = $_SESSION['id_usuario'];

    $sql = "INSERT INTO consultas (id_usuario, data, hora, motivo) VALUES (:id_usuario, :data, :hora, :motivo)";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':id_usuario', $id_usuario);
    $stmt->bindParam(':data', $data);
    $stmt->bindParam(':hora', $hora);
    $stmt->bindParam(':motivo', $motivo);
    $stmt->execute();

    header("Location: listar.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendar Consulta</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>Agendar Consulta</h2>
        <form action="agendar.php" method="POST">
            <div class="form-group">
                <label for="data">Data:</label>
                <input type="date" id="data" name="data" required>
            </div>
            <div class="form-group">
                <label for="hora">Hora:</label>
                <input type="time" id="hora" name="hora" required>
            </div>
            <div class="form-group">
                <label for="motivo">Motivo:</label>
                <input type="text" id="motivo" name="motivo" required>
            </div>
            <button type="submit" class="btn btn-primary">Agendar</button>
        </form>
        <a href="listar.php" class="btn btn-secondary">Voltar à Consulta</a>
        <a href="login.php" class="btn btn-secondary">Voltar à Página Principal</a>
    </div>
</body>
</html>
