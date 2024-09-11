<?php
    $nota = [9, 7, 8];
    $smTotla = 0;

    
    for($i = 0; $i < count($nota); $i++){        
        $smTotal += $nota[$i];
    }

    $resultado = $smTotal/count($nota);

    if ($resultado >= 6) {
    echo "Aprovado, média final {$resultado}\n";
    } else {
    echo "Reprovado, média final {$resultado}\n";
    }
    
 ?>