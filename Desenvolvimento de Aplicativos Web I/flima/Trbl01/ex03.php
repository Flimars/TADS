<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ex-Estado do Tanque</title>
</head>
<body>
    <?php
    /*
    * Estado do tanque
    * Escreva um algoritmo que recebe a temperatura de um tanque de gás. Então
    * mostra na tela o estado do tanque. Considere que o tanque está em estado Normal
    * entre 0ºC e 300ºC e que o tanque atinge o estado crítico em -50ºC e 500ºC. Para
    * todas as outras temperaturas, ele estará em estado de alerta.
    */

        $temperatura = -40;

        if ($temperatura >= 0 && $temperatura <= 300) {
            echo "Temperatura em $temperatura ºC Estado Normal!";
        } elseif ($temperatura <= -50 && $temperatura >= 500) {
            echo "Temperatura em $temperatura ºC Estado Crítico!";
        } else {
            echo "Temperatura em $temperatura ºC Estado de Alerta!";
        }

    ?>


</body>
</html>