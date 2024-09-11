<?php
/*
    Criar um algoritmos que entre com uma palavra e imprima conforme o exemplo.
    Palavra: sonho
    • SONHO
    • SONHO SONHO
    • SONHO SONHO SONHO
    • SONHO SONHO SONHO SONHO
*/

$palavra = "SONHO";
$contador = 0;

do {
    switch ($contador) {
        case 0:
            echo "$palavra <br>";
            break;
        case 1:
            echo "$palavra $palavra <br>";
            break;
        case 2:
            echo "$palavra $palavra $palavra <br>";
            break;
        case 3:
            echo "$palavra $palavra $palavra $palavra <br>";
            break;
        
        default:
            echo "Valor Inválido";
            break;
    }
    $contador++;
    
} while ($contador <= 3);

?>