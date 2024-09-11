<?php
// Escreva um programa que peça para o usuário informar quantos pacientes uma
// clínica pediátrica atendeu. Então abra um imput para cada paciente para que
// sejam informadas as idades. Ao fim, mostre na tela a porcentagem de pacientes em
// cada uma das idades que possui pelo menos um paciente.


if (isset($_POST['qtdPacientes'])) {
    $qtdPacientes = $_POST["qtdPacientes"];
    $idades = [];
    for ($i = 1; $i <= $qtdPacientes; $i++) {
        $idade = $_POST["idade".$i];
        if (isset($idades[$idade])) {
            $idades[$idade]++;
        } else {
            $idades[$idade] = 1;
        }
    }
    foreach ($idades as $idade => $quantidade) {
        $porcentagem = ($quantidade / $qtdPacientes) * 100;
        echo "A porcentagem de pacientes com idade " . $idade . " é: " . $porcentagem . "%<br>";
    }
}

?>





