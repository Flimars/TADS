<?php
/*
Crie um algoritmo que receba um número informado no próprio código e verifique
se esse valor é positivo, negativo ou igual a zero. A saída deve ser: ”Valor
Positivo”, ”Valor Negativo”ou ”Igual a Zero”.
*/

$numeroInformado = -10;

if( $numeroInformado < 0) {
    echo"Valor Negativo";   
} elseif ($numeroInformado > 0) {    
    echo"Valor Positivo";
} else {
    echo"Valor Igual a Zero";
}

?>