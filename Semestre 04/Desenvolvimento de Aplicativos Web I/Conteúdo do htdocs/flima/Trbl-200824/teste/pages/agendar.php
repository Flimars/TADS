<?php
session_start();
include('../database/conn.php');

// Verifica se o usuário está logado
if (!isset($_SESSION['id_usuario'])) {  // usuario_id
    header("Location: ./index.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = $_POST['data'];
    $hora = $_POST['hora'];
    $motivo = $_POST['motivo'];
    $id_usuario = $_SESSION['id_usuario']; // usuario_id

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
</head>

<body>
    <!-- Formulário de agendamento -->
    <form action="agendar.php" method="POST">
        Data: <input type="date" name="data" required><br>
        Hora: <input type="time" name="hora" required><br>
        Motivo: <input type="text" name="motivo" required><br>
        <input type="submit" value="Agendar">
    </form>
    <a href="listar.php" class="">Voltar à Consulta</a>
    <a href="login.php">Voltar à Página Principal</a><br>
</body>

</html>