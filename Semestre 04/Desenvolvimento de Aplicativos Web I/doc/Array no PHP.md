Sim, as formas que você utilizou para declarar e instanciar um array em PHP estão corretas. 

No PHP, existem basicamente duas maneiras de declarar e instanciar um array:

1. Usando a função `array()`. Por exemplo:
```php
$cursos = array("PHP", "Java", "C#", "C");
```
Neste caso, você criou um array chamado `$cursos` que contém quatro elementos.

2. Usando a sintaxe de colchetes `[]`. Por exemplo:
```php
$numerosPares = [0, 2, 4, 6, 8, 10];
```
Neste caso, você criou um array chamado `$numerosPares` que contém seis elementos.

Além disso, você pode declarar e instanciar um array associativo, onde cada valor é associado a uma chave específica. Por exemplo:

```php
$pessoa = array(
    "nome" => "João",
    "idade" => 30,
    "cidade" => "Rio de Janeiro"
);
```
Ou usando a sintaxe de colchetes:

```php
$pessoa = [
    "nome" => "João",
    "idade" => 30,
    "cidade" => "Rio de Janeiro"
];
```
Neste caso, cada elemento do array é acessado através de sua chave correspondente, por exemplo, `$pessoa["nome"]` retornará "João". 

Espero que isso ajude a esclarecer suas dúvidas sobre arrays em PHP! Se você tiver mais perguntas, fique à vontade para perguntar. 😊