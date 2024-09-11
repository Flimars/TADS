<?php
    // array 
    $arrayNumeros = [1,2,3,4,5,6,7,8,9,10];
    $qtd_elementos_array = count($arrayNumeros);

    var_dump($qtd_elementos_array);

    // for ($i= 0; $i  < $qtd_elementos_array; $i++) { 
    //    print_r($arrayNumeros[$i] . "\n"); 
    // }

    foreach($arrayNumeros as $indice => $value) {
        if ($value % 2 === 0) {
            continue;
        }       
        echo "Valor do índice : " . $indice . " valor : " . $value . "\n";
    }
?>