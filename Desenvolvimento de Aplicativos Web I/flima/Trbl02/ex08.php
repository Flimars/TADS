<?php
/*
    Entrar com 3 números e imprimi-los em ordem decrescente (suponha números
    diferentes).
    Ex: A = 7, B = 3, C = 9 Você deve imprimir na tela: ”9 7 3”
*/
$a = 3;
$b = 9;
$c = 1;
 
if ($a > $b && $a > $c && $b > $c) {
    echo "$c $b $a";
} elseif ($a > $b && $a > $c && $c > $b) {      
    echo "$b $c $a";  
} elseif ($b > $a && $b > $c && $a > $c) {
    echo "$c $a $b "; 
} elseif ($b > $a && $b > $c && $c > $a) {
    echo "$a $c $b "; 
} elseif ($c > $a && $c > $b && $b > $a) {
    echo " $a $b $c"; 
} else {
    echo " $b $a $c"; 
}
?>