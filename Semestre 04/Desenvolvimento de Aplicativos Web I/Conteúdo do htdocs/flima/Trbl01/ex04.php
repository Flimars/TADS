<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ex-Financiamento</title>
</head>
<body>
    <?php
    /*
    * Financiamento
    * Escreva um programa que simule um financiamento. O sistema recebe o valor que
    * a pessoa deseja financiar, além da renda e número de parcelas que ele deseja fazer
    * o financiamento. Supondo que não há juros no financiamento, mostre na tela se o
    * usuário terá seu financiamento aprovado ou não. Caso seja aprovado, mostre o
    * valor da parcela que o usuário deverá pagar. O financiamento do usuário só será
    * aprovado se o valor da parcela não ultrapassar 30% da sua renda, bem como o
    * número de parcelas escolhidas for no máximo 180.
    */

        $valorFinanciamento = 10000; // Insira o valor do financiamento aqui
        $renda = 3000; // Insira a renda aqui
        $numeroParcelas = 60; // Insira o número de parcelas aqui

        $valorParcela = $valorFinanciamento / $numeroParcelas;

        if ($valorParcela <= $renda * 0.3 && $numeroParcelas <= 180) {
            echo "Financiamento aprovado! O valor da parcela será de R$ " . number_format($valorParcela, 2, ',', '.');
        } else {
            echo "Financiamento não aprovado.";
        }
    ?>
    
</body>
</html>