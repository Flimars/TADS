<?php
/*
    Armazenar 15 números inteiros em um vetor e imprimir uma mensagem contendo o
    número e uma das mensagens: par ou ímpar.
*/
$numeros = array(81, 58, 73, 22, 3, 8, 1, 4, 11, 6, 13, 10, 33, 38, 24);

for ($i=0; $i <count($numeros) ; $i++) { 
   if ($numeros[$i] % 2 === 0) {
    echo "$numeros[$i] é par\n";
} else {
    echo "$numeros[$i] é ímpar\n";
   }
}

?>