<?php
// Crie um formulário em HTML com dois campos de formulário (um para o peso e
// outro para a altura de uma pessoa) e um botão submit. Crie uma página PHP que
// receba os dados e calcule o índice de massa corporal (IMC). O IMC é calculado da
// seguinte forma:
// imc = peso / (altura * altura)
// Se o valor do IMC for maior do que 25 deverá ser exibida a mensagem “Você está
// acima do peso!”. Caso contrário exiba a mensagem “Você está saudável”.

if (isset($_POST['altura'], $_POST['peso'])) {
    $altura = $_POST['altura'];
    $peso = $_POST['peso'];

    $imc = $peso / ($altura * $altura);
    echo "Seu IMC é : $imc <br>";

    if ($imc > 25) {
       echo "Você está acima do peso!";
    } else {
        echo "Você está saudável.";
    }
}

?>