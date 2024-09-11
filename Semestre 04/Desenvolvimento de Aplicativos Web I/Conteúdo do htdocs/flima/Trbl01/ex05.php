<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ex-Mês por Extenso</title>
</head>

<body>

    <?php
    /*
        * Mês por extenso
        * Crie um programa que recebe um número entre 1 e 12 e com o comando switch
        * mostre na tela o mês por extenso.
        * Exemplo: Se receber 1 deverá mostrar Janeiro. 
        */

    switch ($mes) {
        case 1:
            echo "JANEIRO";
            continue;
        case 2:
            echo "FEVEREIRO";
            continue;
        case 3:
            echo "MARÇO";
            continue;
        case 4:
            echo "ABRIL";
            continue;
        case 5:
            echo "MAIO";
            continue;
        case 6:
            echo "JUNHO";
            continue;
        case 7:
            echo "JULHO";
            continue;
        case 8:
            echo "AGOSTO";
            continue;
        case 9:
            echo "SETEMBRO";
            continue;
        case 10:
            echo "OUTUBRO";
            continue;
        case 11:
            echo "NOVEMBRO";
            continue;
        case 12:
            echo "DEZEMBRO";
            continue;

        default:
            echo "Valor digitado NÃO corresponde a nenhum mês conhecido";
            break;
    }

    ?>
</body>

</html>