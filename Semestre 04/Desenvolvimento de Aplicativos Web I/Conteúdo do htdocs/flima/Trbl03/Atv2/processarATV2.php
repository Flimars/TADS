<?php
    // Verificar se os valores foram enviados via POST
    if (isset($_POST['numero1']
        , $_POST['numero2'] 
        , $_POST['respostaSoma']
        , $_POST['respostaSubtracao']
        , $_POST['respostaMultiplicacao']
        , $_POST['respostaDivisao'])) 
        {
        $numero1 = $_POST['numero1'];
        $numero2 = $_POST['numero2'];
        $respostaSoma = $_POST['respostaSoma'];
        $respostaSubtracao = $_POST['respostaSubtracao'];
        $respostaMultiplicacao = $_POST['respostaMultiplicacao'];
        $respostaDivisao = $_POST['respostaDivisao'];
    
        // Calcular as operações matemáticas
        $soma = $numero1 + $numero2;
        $subtracao = $numero1 - $numero2;
        $multiplicacao = $numero1 * $numero2;
        $divisao = $numero1 / $numero2;
    
        // Contar os acertos
        $acertos = 0;
        if ($respostaSoma == $soma) $acertos++;
        if ($respostaSubtracao == $subtracao) $acertos++;
        if ($respostaMultiplicacao == $multiplicacao) $acertos++;
        if ($respostaDivisao == $divisao) $acertos++;
    
        // Exibir o resultado
        echo "Você acertou $acertos respostas.";
    } else {
        echo "Nenhum dado foi enviado.";
    }

?>
    