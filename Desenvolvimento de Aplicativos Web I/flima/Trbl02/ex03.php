<?php
/*
    Criar um vetor com 20 elementos inteiros. Imprimir o maior e o menor, sem
    ordenar, o percentual de números pares e a média dos elementos do vetor.
*/

$vetor = array(45, 701, -1, 2, 8, 3,  9, -21, 10, 20, 22, 33, 59, 69, 34, 35, 46, 57, 47, 58);
$menor = 100;
$maior = 0;
$pares = 0;
$somar = 0;
$aux = 0;

for ($i=0; $i < 20; $i++) {     
   if($vetor[$i] < $menor) {
    $aux = $vetor[$i]; 
    $menor = $aux;
   }

   if($vetor[$i] > $maior) {
    $aux = $vetor[$i]; 
    $maior = $aux;
   }

   if ($vetor[$i] % 2 === 0) {
        $pares ++;
   }  

   $somar += $vetor[$i];
}

 $percentual = $pares/20 * 100; // ($pares/20) * 100;
 $media = $somar/20;

echo "Menor número é: ", $menor,"<br>",
     "Maior número é: ", $maior, "<br>",
     "Percentual de números pares: ", $percentual, "% <br>",
     "Media dos elementos: ", $media;
?>