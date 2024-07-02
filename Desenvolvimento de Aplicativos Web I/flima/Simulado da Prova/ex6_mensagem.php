<?php
    function MensagemDeApresentacao($lIdentificacaoPadrao = "presado(a) cliente", $lNome){
    return "Seja bem vindo $lIdentificacaoPadrao $lNome ao módulo administrativo do nosso sistema.";
    }

    echo MensagemDeApresentacao("Carlos Alberto");
 ?>