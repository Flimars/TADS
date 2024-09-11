<?php
$frutas = ["banana", "maça", "uva", "pera"];

$contador = count($frutas);

$i = 0;
do {

    if ($frutas[$i] == "pera") {
        break;
    }
    echo $frutas[$i] . "\n";
    $i++;

} while($i < $contador);

?>


