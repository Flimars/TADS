
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ex-Classificação Etária</title>
    </head>
    <body>
        
        <?php
        /*
        * Classificação etária
        * Escreva um algoritmo que recebe a idade de uma pessoa. Então mostre na tela se
        * ele é criança (menor de 13 anos), adolescente (entre 13 e 19 anos), adulto (entre
        * 20 e 60 anos) ou idoso (mais de 60 anos).
        */
        echo "<br>";
        echo "<br>";

        $idade = 35;

        if ($idade < 13) {
            print("É uma criança de $idade anos de idade <br>");
        } elseif ($idade >= 13 && $idade <= 19) {
            print("É um adolecente de $idade anos de idade <br>");
        } elseif ($idade >= 20 && $idade <= 60 ) {
            print("É um adulto de $idade anos de idade <br>");
        } else {
            print("É um idoso de $idade anos de idade <br>");
        }
    ?>
    
</body>
</html>