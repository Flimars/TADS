<?php
/*
    Exemplos de Descremento.
*/

echo "Pós-Decremento \n";
$a = 5;
echo "Deve mostrar 5: " . $a-- . "\n"; 
echo "Deve mostrar 4: " . $a   . "\n";
printf("===============\n");

echo "Pré-Decremento \n";
$a = 5;
echo "Deve mostrar 4: " . --$a . "\n"; 
echo "Deve mostrar 4: " . $a   . "\n";
printf("===============\n");

echo "OBSERVAÇÃO PRÉ OU PÓS DECRESMENTO DE NULL É SEMPRE NULL" . "\n";
$a = null;
echo "Deve mostrar NULL: " . --$a . "\n"; 
echo "Deve mostrar NULL: " . $a   . "\n";
printf("===============\n");

$a = null;
echo "Deve mostrar NULL: " . $a-- . "\n"; 
echo "Deve mostrar NULL: " . $a   . "\n";
printf("===============\n");

?>