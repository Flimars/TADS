<?php

// A função gettype() retorna apenas o tipo da variavel.
    $num = 123; // variável do tipo inteiro
    $str = "Olá, Mundo!"; // variável do tipo string
    $bool = true; // variável do tipo booleano
    $arr = array(1, 2, 3); // variável do tipo array

    echo "O tipo da variável num é: " . gettype($num) . "\n";
    echo "O tipo da variável str é: " . gettype($str) . "\n";
    echo "O tipo da variável bool é: " . gettype($bool) . "\n";
    echo "O tipo da variável arr é: " . gettype($arr) . "\n" . "\n";

    

// A função var_dump() retorna o tipo e o valor da variavel.
    $a = 10;
    $b = 'casa'; 
    $c = true;
    $d = 9.658;
    $e = 'A';

    var_dump($a, $b, $c, $d, $e);

?>