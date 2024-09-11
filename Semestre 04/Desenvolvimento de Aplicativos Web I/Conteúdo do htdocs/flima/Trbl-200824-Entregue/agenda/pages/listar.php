<?php
include('../database/conn.php');
session_start();

if (!isset($_SESSION['id_usuario'])) {
    header('Location: ../pages/login.php');
    exit();
}

$id_usuario = $_SESSION['id_usuario'];

if (!$conn) {
    die('Falha na conexão com o banco de dados');
}

$sql = "SELECT * FROM consultas WHERE id_usuario = :id";
$stmt = $conn->prepare($sql);
$stmt->bindParam(':id', $id_usuario);
$stmt->execute();
$consultas = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultas Marcadas</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>Consultas Marcadas</h2>
        <a href="agendar.php" class="btn btn-primary btn-group">Marcar Nova Consulta</a>
        <?php if (count($consultas) > 0): ?>
            <table class="table mt-3">
                <thead>
                    <tr>
                        <th>Data</th>
                        <th>Hora</th>
                        <th>Motivo</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($consultas as $consulta): ?>
                        <tr>
                            <td><?php echo $consulta['data']; ?></td>
                            <td><?php echo $consulta['hora']; ?></td>
                            <td><?php echo $consulta['motivo']; ?></td>
                            <td>
                                <?php if ($consulta['id_usuario'] == $id_usuario): ?>
                                    <a href="editar.php?id=<?php echo $consulta['id']; ?>" class="btn btn-warning btn-group">Editar</a>
                                    <a href="excluir.php?id=<?php echo $consulta['id']; ?>" class="btn btn-danger btn-group" onclick="return confirm('Quer mesmo excluir esta consulta ?')">Excluir</a>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <p>Não há consultas marcadas.</p>
        <?php endif; ?>
        <a href="../index.php" class="btn btn-primary">Voltar à Página Principal</a>
    </div>
</body>
</html>
