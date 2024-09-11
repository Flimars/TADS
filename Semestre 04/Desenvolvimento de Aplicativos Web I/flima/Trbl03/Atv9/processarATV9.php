<?php
// Crie um formulário em HTML com dois campos de texto para ler os valores do lado
// de um retângulo e um botão submit.
// Crie uma página em PHP que receba os dados e exiba o valor da área e do
// perímetro do retângulo.

if (isset($_POST['lado1'], $_POST['lado2'])) {
    $lado1 = $_POST['lado1'];
    $lado2 = $_POST['lado2'];

    $area = $lado1 * $lado2;
    $perimeter = 2 * ($lado1 + $lado2);

    echo "Área do retângulo: " . $area . "<br>";
    echo "Perímetro do retângulo: " . $perimeter;
}

?>