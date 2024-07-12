<?php
// Entrar com 3 números e imprimi-los em ordem decrescente (suponha números
// diferentes).

if (isset($_POST['numero1']
, $_POST['numero2'] 
, $_POST['numero3'] 
)) {
$numero1 = $_POST['numero1'];
$numero2 = $_POST['numero2'];
$numero3 = $_POST['numero3'];

if ($numero1 !== $numero2 && 
    $numero1 !== $numero3 &&
    $numero2 !== $numero3) 
    {
      $numeros = array($numero1, $numero2, $numero3); 
      
      for ($i=0; $i < count($numeros) -1 ; $i++) { 
            for ($j=0; $j < count($numeros) -$i -1 ; $j++) { 
                if ($numeros[$j] < $numeros[$j +1]) {
                    
                    $auxiliar = $numeros[$j];
                    $numeros[$j] = $numeros[$j +1];
                    $numeros[$j + 1] = $auxiliar;
                }
            }
        }
     
    echo "Números em ordem decrecente: " .implode(", ", $numeros);   

    } else {
        echo "Por favor, insira números diferentes.";
    }
}


?>