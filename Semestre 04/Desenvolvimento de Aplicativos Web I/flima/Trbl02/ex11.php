<?php
/*
    Escreva um programa recebe 5 números salvos em um array, e então mostre na tela
    a lista dos que são maiores do que a média
*/
$lista = array(10, 29, 71, 19, 6);
$somar = 0;

for ($i=0; $i < count($lista); $i++) { 
    $somar += $lista[$i];
}

$media = $somar/count($lista);  
echo "A Média é = $media <br>"; 

for ($i=0; $i < count($lista); $i++) { 
    if ($lista[$i] > $media) {
        echo "Elemento acima da média: $lista[$i]<br>";
    }
}

?>
