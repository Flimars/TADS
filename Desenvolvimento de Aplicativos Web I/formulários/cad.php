<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro PHP</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
    <header>
        <h1>Resultado do processamento</h1>
    </header>
    <main>
        <?php
            // var_dump($_REQUEST); // Contem variável Super Global $_GET, $_POST, $_COOKIE.
            // var_dump($_GET);     // Contem variável Super Global $_GET.
            // var_dump($_POST);    // Contem variável Super Global $_POST.
            // var_dump($_COOKIE);  // Contem variável Super Global $_COOKIES.

            $nome = $_GET["nome"] ?? "sem nome";
            $sobrenome = $_GET["sobrenome"] ?? "desconhecido";
            echo "<p>Prazer em te conhecer, <strong>$nome $sobrenome</strong>! Esté é o meu site. Seja bem-vindo.</p>"


        ?>
        <p><a href="javascript:history.go(-1)">Voltar para página anterior</a></p>
    </main>


</body>

</html>