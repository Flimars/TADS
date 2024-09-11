<!-- Exemplo #1 Ilustrando operadores lógicos -->

<?php
// --------------------
// foo() nunca será chamada porque toda a expressão sofre curto circuito

$a = (false && foo());
$b = (true  || foo());
$c = (false and foo());
$d = (true  or  foo());

// --------------------
// "||" tem maior precedência que "or"

// O resultado da expressão (false || true) é atribuido em $e
// Funciona como: ($e = (false || true))
$e = false || true;

// A constante false é atribuída a $f antes que o "or" ocorra
// Funciona como: (($f = false) or true)
$f = false or true;

var_dump($e, $f);

// --------------------
// "&&" tem maior precedência que "and"

// O resultado da expressão (true && false) é atribuído em $g
// Funciona como: ($g = (true && false))
$g = true && false;

// A constante true é atribuída em $h antes que o "and" ocorra
// Funciona como: (($h = true) and false)
$h = true and false;

var_dump($g, $h);
?>

<!-- O exemplo acima produzirá algo semelhante a:

bool(true)
bool(false)
bool(false)
bool(true)  -->