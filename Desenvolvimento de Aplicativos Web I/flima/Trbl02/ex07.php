<?php
/*
    Construir um algoritmo que leia 2 números e efetue a adição. Caso o valor somado
    seja maior que 20, este deverá ser apresentando somando-se a ele mais 8; caso o
    valor somado seja menor ou igual a 20, este deverá ser apresentado subtraindo-se 5.
*/

$num1 = 7;
$num2 = 8;
$soma = $num1 + $num2;

if ($soma > 20) {
    $soma += 8; 
    echo "$soma";
} else {
    $soma -= 5; 
    echo "$soma";
}

?>