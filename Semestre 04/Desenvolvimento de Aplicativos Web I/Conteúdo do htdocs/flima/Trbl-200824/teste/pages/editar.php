<?php
include('../database/conn.php');
session_start();

if (!isset($_SESSION['id_usuario'])) {
    die("Você precisa estar logado para alterar uma consulta.");
}

$id = $_GET['id'] ?? null;

// Verifica se o formulário foi enviado
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = $_POST['data'];
    $hora = $_POST['hora'];
    $motivo = $_POST['motivo'];
    
    // Atualiza a consulta no banco de dados
    $stmt = $conn->prepare("UPDATE consultas SET Data = ?, Hora = ?, motivo = ? WHERE id = ? AND id_usuario = ?");
    if ($stmt->execute([$data, $hora, $motivo, $id, $_SESSION['id_usuario']])) {
        echo "<div class='alert alert-success'>Consulta atualizada com sucesso!</div>";
    } else {
        echo "<div class='alert alert-danger'>Erro ao atualizar consulta.</div>";
    }
}

// Busca a consulta para edição
$stmt = $conn->prepare("SELECT * FROM consultas WHERE id = ? AND id_usuario = ?");
$stmt->execute([$id, $_SESSION['id_usuario']]);
$consulta = $stmt->fetch();

if (!$consulta) {
    die("Consulta não encontrada ou você não tem permissão para editá-la.");
}

// Preenche as variáveis com os dados da consulta
$data = htmlspecialchars($consulta['data']);
$hora = htmlspecialchars($consulta['hora']);
$motivo = htmlspecialchars($consulta['motivo']);

// Verifica se os dados foram encontrados corretamente
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
    <!--  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous"> -->
</head>
<body>
    <div class="container mt-4">
        <h2>Alterar Consulta</h2>
        <form action="editar.php?id=<?php echo $id; ?>" method="post">
            <div class="mb-3">
                <label for="data" class="form-label">Data:</label>
                <input type="date" class="form-control" id="data" name="data" value="<?php echo $data; ?>" required>
            </div>
            <div class="mb-3">
                <label for="hora" class="form-label">Hora:</label>
                <input type="time" class="form-control" id="hora" name="hora" value="<?php echo $hora; ?>" required>
            </div>
            <div class="mb-3">
                <label for="motivo" class="form-label">Motivo:</label>
                <textarea class="form-control" id="motivo" name="motivo" rows="3" required><?php echo $motivo; ?></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Atualizar Consulta</button>
            <a href="listar.php" class="btn btn-secondary">Voltar</a>
        </form>
    </div>
</body>
</html>



