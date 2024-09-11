<?php
include('../database/conn.php');
session_start();

if (!isset($_SESSION['id_usuario'])) {
    die("Você precisa estar logado para alterar uma consulta.");
}

$id = $_GET['id'] ?? null;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = $_POST['data'];
    $hora = $_POST['hora'];
    $motivo = $_POST['motivo'];
    
    $stmt = $conn->prepare("UPDATE consultas SET data = ?, hora = ?, motivo = ? WHERE id = ? AND id_usuario = ?");
    if ($stmt->execute([$data, $hora, $motivo, $id, $_SESSION['id_usuario']])) {
        echo "<div class='alert alert-success'>Consulta atualizada com sucesso!</div>";
    } else {
        echo "<div class='alert alert-danger'>Erro ao atualizar consulta.</div>";
    }
}

$stmt = $conn->prepare("SELECT * FROM consultas WHERE id = ? AND id_usuario = ?");
$stmt->execute([$id, $_SESSION['id_usuario']]);
$consulta = $stmt->fetch();

if (!$consulta) {
    die("Consulta não encontrada ou você não tem permissão para editá-la.");
}

$data = htmlspecialchars($consulta['data']);
$hora = htmlspecialchars($consulta['hora']);
$motivo = htmlspecialchars($consulta['motivo']);

if (!$data || !$hora) {
    die("Erro: Data ou Hora não encontrados na consulta.");
}
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Alterar Consulta - Agenda Veterinária</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>Alterar Consulta</h2>
        <form action="editar.php?id=<?php echo $id; ?>" method="post">
            <div class="form-group">
                <label for="data">Data:</label>
                <input type="date" id="data" name="data" value="<?php echo $data; ?>" required>
            </div>
            <div class="form-group">
                <label for="hora">Hora:</label>
                <input type="time" id="hora" name="hora" value="<?php echo $hora; ?>" required>
            </div>
            <div class="form-group">
                <label for="motivo">Motivo:</label>
                <textarea id="motivo" name="motivo" rows="3" required><?php echo $motivo; ?></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Atualizar Consulta</button>
            <a href="listar.php" class="btn btn-secondary">Voltar</a>
        </form>
    </div>
</body>
</html>
