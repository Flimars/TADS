
<?php
// Peça para o usuário informar sua idade. Então mostre na tela se ele é criança
// (menor de 13 anos), adolescente (entre 13 e 19 anos), adulto (entre 20 e 60 anos)
// ou idoso (mais de 60 anos).

if (isset($_POST['idade'])) {
    $idade = $_POST['idade'];     

    if ($idade < 13) {
       $faixaEtaria = "crianca";        
    } elseif ($idade >= 13 && $idade <= 19) {
        $faixaEtaria = "adolecente";        
    } elseif ($idade >= 19 && $idade <= 60 ) {
        $faixaEtaria = "adulto";          
    } else {
        $faixaEtaria = "idoso";          
    }
    echo "Você é $faixaEtaria com idade igual a $idade anos.";   
}

?>
   
