<?php
// Verificar se os números foram enviados
if (isset($_POST['numeros']) && is_array($_POST['numeros'])) {
    $numeros = $_POST['numeros'];
    $soma = array_sum($numeros);
    $media = $soma / count($numeros);

    // Exibir a média dos valores informados
    echo "A média dos valores informados é: " . $media;
} else {
    echo "Erro: Nenhum número foi informado.";
}
?>
