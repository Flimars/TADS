<?php
/*
    Entrar com 3 números e imprimi-los em ordem decrescente (suponha números
    diferentes).
    Ex: A = 7, B = 3, C = 9 Você deve imprimir na tela: ”9 7 3”
*/
$a = 1;
$b = 9;
$c = 3;
 
if ($a > $b && $a > $c && $b > $c) {
    echo "$a $b $c";
} elseif ($a > $b && $a > $c && $c > $b) {      
    echo "$a $c $b ";  
} elseif ($b > $a && $b > $c && $a > $c) {
    echo "$b $a $c"; 
} elseif ($b > $a && $b > $c && $c > $a) {
    echo "$b $c $a"; 
} elseif ($c > $a && $c > $b && $b > $a) {
    echo "$c $b $a"; 
} else {
    echo "$c $a $b"; 
}

?>