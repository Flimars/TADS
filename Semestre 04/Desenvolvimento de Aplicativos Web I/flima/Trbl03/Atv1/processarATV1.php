<?php

/*
Crie o formulário abaixo para:
Aplicar uma operação nos dois valores
Operações: soma, subtração, multiplicação, divisão e potenciação
Crie uma página PHP para receber e calcular a operação selecionada.

*/


// Verificar se os valores foram enviados
if (isset($_POST['valor1']) && isset($_POST['valor2']) && isset($_POST['operacao'])) {
    $valor1 = $_POST['valor1'];
    $valor2 = $_POST['valor2'];
    $operacao = $_POST['operacao'];

    // Realizar a operação matemática selecionada
    switch ($operacao) {
        case 'soma':
            $resultado = $valor1 + $valor2;
            break;
        case 'subtracao':
            $resultado = $valor1 - $valor2;
            break;
        case 'multiplicacao':
            $resultado = $valor1 * $valor2;
            break;
        case 'divisao':
            if ($valor2 != 0) {
                $resultado = $valor1 / $valor2;
            } else {
                echo "Erro: Divisão por zero não é permitida.";
                //exit;
            }
            break;
        case 'potenciacao':
            $resultado = pow($valor1, $valor2);
            break;
        default:
            echo "Erro: Operação inválida.";
            //exit;
    }

    // Exibir o resultado
    echo "O resultado da operação é: " . $resultado;
} else {
    echo "Erro: Valores ou operação não fornecidos.";
}
?>



