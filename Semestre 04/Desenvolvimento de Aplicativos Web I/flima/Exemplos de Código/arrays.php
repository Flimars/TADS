<?php
/*
    Exemplos:
*/
// Usando a função array().
$array = array( 
    "chave" => "valor",
);

// A partir do PHP 5.4, usando colchetes.
$array = [
    "chave" => "valor",
];

$carros = ['Ferrari', 'Porsche', 'Lamborghini', 'Mercedes'];
print_r($carros);
print_r($carros[2]);

$endereço = [
    "Cep" => "96.214-200",
    "Logradouro" => "Rua Antônio Machado Magalhães",
    "Número" => "154",
    "Bairro" => "Castelo Branco",
    "Municipio" => "Rio Grande",
    "Estado" => "RS",
];
print_r($endereço);
print_r($endereço['Logradouro']);
echo ", ";
print_r($endereço['Número']);

$endereçoPessoas = [
    'pessoa1' => array(
        "cep"    => "96202-350",
        "cidade" => "Rio Grande",
        "uf"     => "RS", 
    ),
    'pessoa2' => array(
        "cep"    => "90020-020",
        "cidade" => "Porto Alegre",
        "uf"     => "RS", 
    ),
    'pessoa3' => array(
        "cep"    => "40026-900",
        "cidade" => "Salvador",
        "uf"     => "BA", 
    ),
];
printf("");
print_r($endereçoPessoas['pessoa3']);
printf("");
print_r($endereçoPessoas['pessoa3']['cep']);
?>