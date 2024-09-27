//1. Soma de Dois números
function somar(num1, num2) {
    return num1 + num2;
}

console.log(somar(5, 7));

//2. Verificar par ou impar
function parOuImpar(numero){
    if (numero % 2 === 0) {
        console.log('Par');
    } else {
        console.log('Impar');
    }
}
console.log(parOuImpar(4));
console.log(parOuImpar(7));

//3. Contagrm regressiva
for (let index = 10; index >= 1 ; index--) {
    const element = index;
    console.log(element);    
}

//4. Função de Saudação Personalizada
function saudar(nome){
    return `Olá, ${nome}!`;
 }
 console.log(saudar('João'));

//  5. Números Pares em um Array
// Crie uma função encontrarPares que receba um array de números e retorne um novo array contendo
// apenas os números pares.
function adicionarElemento(array, elemento){
    array[array.length] = elemento;
    return array.length;
}

function encontrarPares(numeros){
    let pares = [];
    for(let i = 0; i < numeros.length; i++){
        if(numeros[i] % 2 === 0){
            adicionarElemento(pares, numeros[i]);
        }
    }
    return pares;
}
console.log(encontrarPares([1, 2, 3, 4, 5, 6])); // Saída esperada: [2, 4, 6]

// 6. Soma dos Elementos do Array
// Escreva uma função chamada somarElementos que receba um array de números e retorne a soma de todos os elementos.
function somarElementos(arr) {
    let soma = 0;
    for (let i = 0; i < arr.length; i++) {
        soma += arr[i];        
    }
    return soma;
}
console.log(somarElementos([1, 2, 3, 4])); // Saída esperada: 10

// 7. Multiplicar por Dois
// Escreva uma função chamada multiplicarPorDois que receba um array de números e retorne um novo
// array onde cada número é multiplicado por 2.
function multiplicarPorDois(arr) {
    let dobro = 0;
    let novoArr = [];
    for (let i = 0; i < arr.length; i++) {
        dobro = arr[i] * 2; 
        adicionarElemento(novoArr, dobro);       
    }
    return novoArr;
}
console.log(multiplicarPorDois([1, 2, 3])); // Saída esperada: [2, 4, 6]

// 8. Remover Números Menores que 10
// Crie uma função removerMenoresQueDez que receba um array de números e retorne um novo array sem os números menores que 10. 
function removerMenoresQueDez(arr) {
    let dezOumaior = [];
    for(let i = 0; i < arr.length; i++){
        if(arr[i] >= 10){
            adicionarElemento(dezOumaior, arr[i]);
        }
    }
    return dezOumaior;
}
console.log(removerMenoresQueDez([3, 15, 8, 22, 5])); // Saída esperada: [15, 22]

// Exercícios com Objetos

// 9. Objeto Pessoa
// Crie um objeto chamado pessoa que tenha as propriedades nome, idade e profissao. Adicione um método chamado apresentar que retorne uma string dizendo "Olá, meu nome é [nome], eu tenho [idade] anos e sou [profissão]".

let pessoa = {
 nome: "Maria",
 idade: 30,
 profissao: "Engenheira",
 apresentar: function() {
    return `Olá, meu nome é ${this.nome}, eu tenho ${this.idade}
        anos e sou ${this.profissao}.`
 }
};
console.log(pessoa.apresentar()); 
// Saída esperada: "Olá, meu nome é Maria, eu tenho 30 anos e sou Engenheira."

// 10. Verificar Propriedade no Objeto
// Escreva uma função chamada verificarPropriedade que receba um objeto e uma string representando uma propriedade. A função deve retornar true se o objeto tiver essa propriedade e false caso contrário.
function verificarPropriedade(obj, propriedade) {
 if(propriedade in obj) {
    return true;
 } else {
     return false;
 }
}
const carro = { marca: "Ford", modelo: "Fiesta" };
console.log(verificarPropriedade(carro, "modelo")); // Saída esperada: true
console.log(verificarPropriedade(carro, "ano")); // Saída esperada: false

// 11. Adicionar Propriedade ao Objeto
// Crie uma função adicionarPropriedade que receba um objeto, uma chave e um valor, e adicione essa chave e valor ao objeto.
function adicionarPropriedade(obj, chave, valor) {
    return obj[chave] = valor;
}
let livro = {
 titulo: "O Senhor dos Anéis",
 autor: "J.R.R. Tolkien"
};
adicionarPropriedade(livro, "ano", 1954);
console.log(livro);
// Saída esperada: { titulo: "O Senhor dos Anéis", autor: "J.R.R. Tolkien", ano:1954 }

// 12. Contar Propriedades de um Objeto
// Crie uma função contarPropriedades que receba um objeto e retorne o número de propriedades que ele  possui.
function contarPropriedades(obj) {
 let numeroPropriedades = Object.keys(obj).length;
 return numeroPropriedades;
}
let pessoa2 = {
 nome: "Carlos",
 idade: 28,
 cidade: "São Paulo"
};
console.log(contarPropriedades(pessoa2)); // Saída esperada: 3
