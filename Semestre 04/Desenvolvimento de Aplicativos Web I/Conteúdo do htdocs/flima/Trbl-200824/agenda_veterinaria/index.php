<!-- PHP -->
<?php
include('database/conn.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nome = $_POST['nome'];
    $email = $_POST['email'];
    $senha = md5($_POST['senha']); // Criptografando a senha com MD5

    try {
        $sql = "INSERT INTO usuario (nome, email, senha) VALUES (:nome, :email, :senha)";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':email', $email);
        $stmt->bindParam(':senha', $senha);

        if ($stmt->execute()) {
            echo "Usuário cadastrado com sucesso!";
        } else {
            echo "Erro ao cadastrar usuário.";
        }
    } catch (PDOException $e) {
        echo "Erro: Verifique se e-mail e senha estão corretos." . $e->getMessage();
    }
}
?>


<!-- HTML  -->
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agenda Veterinária</title>
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> -->
    <link rel="stylesheet" href="./css/style.css"> 
    <!-- <link rel="stylesheet" href="./css/reset.css">-->
    
</head>
<body>
    <h2>LOGIN</h2>
    <br>
    <br>

    <!-- <form action="index.php" method="post">
        <label for="nome">Nome:</label>
        <input type="text" name=nome required><br>
        <label for="email">E-mail:</label>
        <input type="email" name=email required><br>
        <label for="senha">Senha:</label>
        <input type="password" name=senha required><br><br>
        <button type="submit" value="entrar">Entrar</button>
    </form>
    <br> -->
    <a href="cadastro.php">Cadatre-se</a>
</body>
</html>