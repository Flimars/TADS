<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h3>
    Escreva um algoritmo que recebe três notas. Então calcule sua média aritmética.
    Verifique se o aluno obteve a nota 6 para aprovação. Por fim, mostre a média final
    e se o aluno foi aprovado ou reprovado.
    </h3>
    <?php 
    
        $nota1 = 10;
        $nota2 = 8;
        $nota3 = 5.6;
        $media = ($nota1 + $nota2 + $nota3)/3; 

        echo "A média do aluno é: $media <br>";

        if ($media >= 6) {
            print("Aprovado");
        } else {
            print("Reprovado"); 
        }

    ?>
    
</body>
</html>