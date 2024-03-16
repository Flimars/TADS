<?php
/*
    Crie um algoritmo para calcular a média final de um aluno, para isso, receba como
    entrada três notas e as insira em um array, por fim, calcule a média geral. Caso a
    média seja maior ou igual a seis, exiba aprovado, caso contrário, exiba reprovado.
    Exiba também a média final calculada.
    Ex: N1 = 5 | N2 = 10 | N3 = 4 | MG = 6,33 [Aprovado]
*/

$soma = 0;
$notas = array(5.5, 6, 8);

for ($i=0; $i < count($notas); $i++) { 
    $soma += $notas[$i];
}

$media = $soma/count($notas);

if ($media >= 6) {
  echo "A média obtida é $media - [APROVADO]";
} else {
    echo "A média obtida é $media - [REPROVADO]";
}

?>