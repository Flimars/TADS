<?php
// Entrar com um número e informar se ele é divisível por 10, por 5, por 2 ou se não é
// divisível por nenhum destes.

    if (isset($_POST['numero'])) {
        $numero = $_POST["numero"];

        if ($numero % 10 == 0) {
            echo "O número é divisível por 10.<br>";
        }
        if ($numero % 5 == 0) {
            echo "O número é divisível por 5.<br>";
        }
        if ($numero % 2 == 0) {
            echo "O número é divisível por 2.<br>";
        }
        if ($numero % 10 != 0 && $numero % 5 != 0 && $numero % 2 != 0) {
            echo "O número não é divisível por 10, 5 ou 2.";
        }
    }

?>