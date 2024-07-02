<?php

// Variáveis Superglobais do PHP
// 1. $GLOBALS - Exemplo:
    $x = 10;
    $y = 15;

    function soma() {
        //Para conseguir acessar variáveis globais de dentro da função(escobo local).
        echo $GLOBALS['x'] + $GLOBALS['y'];
    }
    soma();

//    2. $_SERVER: é uma superglobal que contém informações sobre cabeçalhos, caminhos e locais de script. 
//    Nada mais é que um array que contém vários índices.
    echo "\n";
    echo $_SERVER['PHP_SELF']."\n";
    echo $_SERVER['SERVER_NAME']."\n";
    echo $_SERVER['SERVER_PORT']."\n";
    echo $_SERVER['SCRIPT_FILENAME']."\n";
    echo $_SERVER['DOCUMENT_ROOT']."\n";
    echo $_SERVER['REMOTE_ADDR']."\n";

//    3. $_REQUEST
//    4. $_POST
//    5. $_GET
//    6. $_FILES
//    7. $_ENV
//    8. $_COOKIE
//    9. $_SESSION



// echo $_REQUEST['nome'];
// if (isset($_REQUEST['nome'])) {
//     $nome = $_REQUEST['nome'];
//     echo "Olá, $nome!";
// } else {
//     echo "Nome não informado.";
// }

?>
