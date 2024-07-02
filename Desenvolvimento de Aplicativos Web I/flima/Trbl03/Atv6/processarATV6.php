<?php
// Escreva um programa que peça para o usuário inserir três números. No fim, escreva
// qual foi o maior e qual foi o menor.

if (isset($_POST['numero1']
    , $_POST['numero2']
    , $_POST['numero3']
)) {
    $numero1 = $_POST['numero1'];
    $numero2 = $_POST['numero2'];
    $numero3 = $_POST['numero3'];

    // Maior
    if ($numero1 >= $numero2 && $numero1 >= $numero3) {
      $maior = $numero1;
              
    } elseif ($numero2 >= $numero3 && $numero2 >= $numero1) {
        $maior = $numero2;
            
    } else {
        $maior = $numero3;
    }

    // Menor
    if ($numero1 <= $numero2 && $numero1 <= $numero3) {
        $menor = $numero1;
              
    } elseif ($numero2 <= $numero3 && $numero2 <= $numero1) {
        $menor = $numero2;
            
    } else {
        $menor = $numero3;
    }

    echo "O maior número é: $maior<br>",
         "O menor número é: $menor<br>";
}


?>