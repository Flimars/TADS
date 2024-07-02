<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atividades DAW1</title>
</head>
<body>
    <h3>Disciplina  de Desenvolvimento de Aplicativos Web I</h3>
    <p>Prof. Me. Cleber Shoeder Fonseca <br>
       Aluno: Flávio de Medeiros Lima 
    </p>
    <hr>
    <h2>Atividades em PHP</h2>
    <ol>
        <li>Média do Aluno</li>
        <li>Classificação Etária</li>
        <li>Estado do Tanque</li>
        <li>Financiamento</li>
        <li>Mês por Extenso</li>
    </ol>
    <hr>
    <h3>1. Média do aluno:</h3> 
    <p>Escreva um algoritmo que recebe três notas. Então calcule sua média aritmética.
        Verifique se o aluno obteve a nota 6 para aprovação. Por fim, mostre a média final
        e se o aluno foi aprovado ou reprovado.
    </p> 
    
    Resposta: 
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
    <hr>
    <h3>2. Classificação etária</h3>
    <p>Escreva um algoritmo que recebe a idade de uma pessoa. Então mostre na tela se
ele é criança (menor de 13 anos), adolescente (entre 13 e 19 anos), adulto (entre
20 e 60 anos) ou idoso (mais de 60 anos).
    </p>

    Resposta: 
    <?php
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
    <hr>  
    <h3>3. Estado do tanque</h3> 
    <p>Escreva um algoritmo que recebe a temperatura de um tanque de gás. Então
        mostra na tela o estado do tanque. Considere que o tanque está em estado Normal
        entre 0oC e 300oC e que o tanque atinge o estado crítico em -50oC e 500oC. Para
        todas as outras temperaturas, ele estará em estado de alerta.
    </p>
    Resposta: 
    <?php
        
        if ($temperatura >= 0 && $temperatura <= 300) {
            echo "Temperatura em $temperatura ºC Estado Normal!";
        } elseif ($temperatura <= -50 && $temperatura >= 500) {
            echo "Temperatura em $temperatura ºC Estado Crítico!";
        } else {
            echo "Temperatura em $temperatura ºC Estado de Alerta!";
        }
    ?>
    <hr> 
    <h3>4. Financiamento</h3> 
    <p>Escreva um programa que simule um financiamento. O sistema recebe o valor que
        a pessoa deseja financiar, além da renda e número de parcelas que ele deseja fazer
        o financiamento. Supondo que não há juros no financiamento, mostre na tela se o
        usuário terá seu financiamento aprovado ou não. Caso seja aprovado, mostre o
        valor da parcela que o usuário deverá pagar. O financiamento do usuário só será
        aprovado se o valor da parcela não ultrapassar 30% da sua renda, bem como o
        número de parcelas escolhidas for no máximo 180.
    </p>
    Resposta: 
    <?php
       
        $valorDaParcelArredondado = number_format($valorDaParcela, 2, ',', '.');
        // $percentualDeSeguranca = ($rendaFixa * 30) / 100;
        // echo $percentualDeSegurança;

        if ($valorDaParcela <= $rendaFixa * 0.3 && $numeroParcelas <= 180) {
            echo "Crédito de Finaciamento APROVADO - ", "Valor da parcela fixa R$ $valorDaParcelArredondado";
        } else {
            echo "Crédito de Financiamento INDEFERIDO.";
        }
    ?>
    <hr> 
    <h3>5. Mês por extenso</h3> 
    <p>Crie um programa que recebe um número entre 1 e 12 e com o comando switch
       mostre na tela o mês por extenso.
       Exemplo: Se receber 1 deverá mostrar Janeiro.
    </p>
    Resposta: 
    <?php
        $mes = 3;
        switch ($mes) {
            case 1:
                echo "JANEIRO";
                break;
            case 2:
                echo "FEVEREIRO";
                break;
            case 3:
                echo "MARÇO";
                break;
            case 4:
                echo "ABRIL";
                break;
            case 5:
                echo "MAIO";
                break;
            case 6:
                echo "JUNHO";
                break;
            case 7:
                echo "JULHO";
                break;
            case 8:
                echo "AGOSTO";
                break;
            case 9:
                echo "SETEMBRO";
                break;
            case 10:
                echo "OUTUBRO";
                break;
            case 11:
                echo "NOVEMBRO";
                break;
            case 12:
                echo "DEZEMBRO";
                break;                                
            
            default:
                echo "Valor digitado NÃO corresponde a nenhum mês conhecido";
                break;
        }
    ?>
    <hr> 
</body>
</html>