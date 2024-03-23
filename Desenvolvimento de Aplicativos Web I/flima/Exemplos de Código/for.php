<?php
    // array 
    $arrayNumeros = [3, 5, 6, 1, 2];
    $qtd_elementos_array = count($arrayNumeros);

    var_dump($qtd_elementos_array);

    for ($i= 0; $i  < $qtd_elementos_array; $i++) { 
       print_r($arrayNumeros[$i]); 
    }
?>