<?php
session_start();
include('./database/conn.php');

if (isset($_SESSION['usuario_id'])) {
    // Redireciona para a página de listagem de consultas se o usuário estiver logado
    header("Location: ./pages/listar.php");
    exit;

} else {
    // Redireciona para a página de login se o usuário não estiver logado
    header("Location: ./pages/login.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Principal</title>
</head>
<body>
    <h1>Página Principal</h1><br>
    <!-- <a href="login.php">Login</a><br>
    <a href="cadastro.php">Cadastrar</a><br>
    <a href="agendar.php">Agendar Consultas</a><br>    
    <a href="pages/listar.php">Consultas marcadas</a><br>
    <a href="pages/editar.php">Editar Consulta</a><br>
    <a href="pages/excluir.php">Excluir marcadas</a><br>       -->
   
</body>
</html>

