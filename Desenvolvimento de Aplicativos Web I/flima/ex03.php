/*
* Estado do tanque
* Escreva um algoritmo que recebe a temperatura de um tanque de gás. Então
* mostra na tela o estado do tanque. Considere que o tanque está em estado Normal
* entre 0ºC e 300ºC e que o tanque atinge o estado crítico em -50ºC e 500ºC. Para
* todas as outras temperaturas, ele estará em estado de alerta.
*/

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php

        echo "<br>";
        echo "<br>";

        $temperatura = (-39);

        if ($temperatura >= 0 || $temperatura <= 300) {
            echo "Temperatura em $ttg ºC Estado Normal!";
        } elseif ($temperatura <= -50 || $temperatura >= 500) {
            echo "Temperatura em $ttg ºC Estado Crítico!";
        } else {
            echo "Temperatura em $ttg ºC Estado de Alerta!";
        }


        // Aqui está um exemplo de como você pode implementar essa solução em PHP:

        // ```php
        // <?php
        // function estadoDoTanque($temperatura) {
        //     if ($temperatura >= 0 && $temperatura <= 300) {
        //         echo "Estado do tanque: Normal";
        //     } elseif ($temperatura >= -50 && $temperatura <= 500) {
        //         echo "Estado do tanque: Crítico";
        //     } else {
        //         echo "Estado do tanque: Alerta";
        //     }
        // }

        // // Testando a função
        // estadoDoTanque(100); // Deve imprimir "Estado do tanque: Normal"
        // estadoDoTanque(400); // Deve imprimir "Estado do tanque: Crítico"
        // estadoDoTanque(-100); // Deve imprimir "Estado do tanque: Alerta"
        // ?>
        // ```

        // Neste código, a função `estadoDoTanque` recebe a temperatura do tanque como argumento.
        // Em seguida, ela verifica a temperatura e imprime o estado do tanque de acordo com as condições especificadas. 
        // Finalmente, a função é testada com diferentes temperaturas para verificar se está funcionando corretamente. 
        // Espero que isso ajude! 


    ?>


</body>
</html>