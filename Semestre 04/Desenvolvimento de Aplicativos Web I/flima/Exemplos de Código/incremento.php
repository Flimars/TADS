<?php
/*
    Exemplos de Incremento.
*/

echo "Pré-Incremento \n";
$a = 5;
echo "Deve mostrar 6: " . ++$a . "\n"; 
echo "Deve mostrar 6: " . $a   . "\n"; 
printf("===============\n");

echo "Pós-Incremento \n";
$a = 5;
echo "Deve mostrar 5: " . $a++ . "\n"; 
echo "Deve mostrar 6: " . $a   . "\n"; 
printf("===============\n");

echo "OBSERVAÇÃO INCRESMENTO DE NULL É IGUAL A 1" . "\n";
$a = null;
echo "Deve mostrar 1: " . ++$a . "\n"; 
echo "Deve mostrar 1: " . $a   . "\n";
printf("===============\n");

$a = null;
echo "Deve mostrar NULL: " . $a++ . "\n"; 
echo "Deve mostrar    1: " . $a   . "\n";
printf("===============\n");

?>