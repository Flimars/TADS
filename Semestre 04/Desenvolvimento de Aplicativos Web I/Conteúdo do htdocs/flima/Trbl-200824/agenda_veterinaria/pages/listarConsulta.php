<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header("Location: login.php");
    exit;
}

include('./database/conn.php');
// include('./agenda_veterinaria/includes/header.php');

try {
    $sql = "SELECT * FROM consultas WHERE id_usuario = :id";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':id', $id_usuario);
    $id_usuario = $_SESSION['usuario_id'];
    $stmt->execute();
    $consultas = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    echo "Erro: Consulta não autorizada." . $e->getMessage();
}

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

?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Consultas Agendadas</h2>
        <?php if (count($consultas) > 0): ?>
            <table class="table table-striped">
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
                            <td><?= $consulta['data'] ?></td>
                            <td><?= $consulta['hora'] ?></td>
                            <td><?= $consulta['motivo'] ?></td>
                            <td>
                                <?php if ($consulta['id_usuario'] == $_SESSION['usuario_id']): ?>
                                    <a href="editar_consulta.php?id=<?= $consulta['id'] ?>" class="btn btn-warning btn-sm">Editar</a>
                                    <a href="excluir_consulta.php?id=<?= $consulta['id'] ?>" class="btn btn-danger btn-sm">Excluir</a>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <p>Não há consultas marcadas.</p>
        <?php endif; ?>
        <a href="marcar_consulta.php" class="btn btn-primary">Marcar Nova Consulta</a>
        <a href="index.php" class="btn btn-page-main">Página Inicial</a>
    </div>
</body>
</html>
