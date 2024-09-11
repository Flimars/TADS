<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ex-Média do Aluno</title>
</head>
<body>
    <?php 
        
        $nota1 = 10;
        $nota2 = 6.2;
        $nota3 = 1.6;
        $idade = 35;
        $temperatura = -40;
        $valorFinaciado = 100000;
        $rendaFixa = 2800;
        $numeroParcelas = 180;
        $valorDaParcela = $valorFinaciado/$numeroParcelas;


        $media = ($nota1 + $nota2 + $nota3)/3; 

        echo "A média do aluno eh: $media - ";

        if ($media >= 6) {
            print("Aprovado");
        } else {
            print("Reprovado"); 
        }

    ?>
</body>
</html>