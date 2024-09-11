<?php
/*
    Crie um algoritmo que contêm a entrada de um número, e exiba a tabuada de 0 a
    10 de acordo com o número solicitado.
    Ex:
    Entrada = 4
    Saída = 4 X 0 = 0...4 X 10 = 40.
*/

$numero = 5;

for ($i = 0; $i < 11; $i++) {
    
    echo "$numero x $i = ", $numero*$i, "<br>";
   
}
echo "";
?>