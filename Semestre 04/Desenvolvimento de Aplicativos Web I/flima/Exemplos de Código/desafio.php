<?php
// Desafio - ALGORITMO BOGOSORT

$arr = [1, 5, 3, 0];  //Saída esperada:  0, 1, 3, 5
// Usando m´rodo sort() para ordenar um array.
sort($arr);
print_r($arr) . "\n";

echo "===============================================\n";
// Lógica similar ao método sort().  
$qtd_elementos_array = count($arr);

for ($i = 0; $i < $qtd_elementos_array-1; $i++) {
    for ($posicaoAtual = 0; $posicaoAtual < $qtd_elementos_array -$i -1; $posicaoAtual++) {
        $proximaPosicao = $posicaoAtual + 1; //0

        if ($arr[$proximaPosicao] < $arr[$posicaoAtual]) {
            $auxiliar = $arr[$posicaoAtual];
            $arr[$posicaoAtual] = $arr[$proximaPosicao];
            $arr[$proximaPosicao] = $auxiliar;
        }
    }
}

print_r($arr) . "\n";
