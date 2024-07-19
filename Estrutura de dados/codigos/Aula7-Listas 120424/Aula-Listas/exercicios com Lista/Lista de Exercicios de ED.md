### Lista de Exercícios



1. Crie estruturas de dados para representar as informações referentes: endereço e pessoa.

2. Declare uma estrutura (struct) capaz de criar variáveis para armazenar os seguintes dados de funcionário:
    a) nome com no máximo 30 caracteres,
    b) código de matrícula com exatamente 8 caracteres,
    c) código do seu cargo profissional com exatamente 2 caracteres,
    d) número de dependentes,
    e) salário.

3. Faça um algoritmo para ler os dados de 200 alunos e em seguida exibi-los. Os dados são nome, quantidade de faltas, 5 notas avaliativas e uma indicação se é bolsista ou não.

4. uponha dois vetores, um de estrutura de estudantes e outro de estrutura de funcionários. Cada registro de estudante contém campos para um último nome, um primeiro nome, e um índice de pontos de graduação. Cada registro de funcionário contém campos para um último nome, um primeiro nome e um salário. Ambos os vetores são classificados em ordem alfabética pelo último e pelo primeiro nome. Dois registros com o último e o primeiro nome iguais não aparecem no mesmo vetor. Escreva uma função em C para conceder um aumento de 10% a todos os funcionários que tenha um registro de estudante cujo índice de pontos de graduação seja maior que 3.0.

5. Faça um algoritmo que controla o consumo de energia dos eletrodomésticos de uma casa. Leia um inteiro n e:
    a) Crie e leia n eletrodomésticos que contém nome (máximo 15 letras), potencia  (real, em kw) e tempo ativo por dia (real, em horas).
    b) Leia um tempo t (em dias), calcule e mostre o consumo total na casa e o consumo  relativo de cada eletrodomésticos (consumo/consumo total) nesse período de tempo. Apresente este último dado em porcentagem.

6. Faça um algoritmo que controle contas de banco. Leia um inteiro n e:
    a) Crie e leia um vetor de contas de banco, com código (inteiro), cliente (máximo   l15 letras), saldo.
    b) Leia um inteiro. Se for lido 1, execute depósito. Se for lido 2, execute saque.  Se for lido 3, listar as contas em ordem crescente(por cliente). Se for 4, imprimir  a conta indicada. Se for lido 0, finalize o programa. Repita este processo enquanto  não for lido um valor válido.
    c) Depósito: leia um código de conta e um valor. Some o valor lido no saldo da conta    lida. Mostre o nome do cliente e o saldo resultante na tela.
    d) Saque: leia um código de conta e um valor. Se o saldo for suficiente, deduza o   valor lido no saldo da conta lida. Mostre o nome do cliente e o saldo resultante na   tela.

7. Faça um algoritmo que controle o fluxo de voos nos aeroportos de um país. Leia dois inteiros v(voos) e a(aeroportos) e :
    a) Crie e leia um vetor de voos, sendo que cada voo contém um código de aeroporto de origem e um de destino.
    b)Crie um vetor de aeroportos, sendo que cada aeroporto contém seu código, quantidade de voos que saem e quantidade de voos que chegam
    c) Cada aeroporto é identificado por um código inteiro entre 0 e a-1. Não aceite aeroportos de código inexistente.

8. Declare estruturas e variáveis capazes de armazenar: uma agenda composta de 50 contatos. Cada contato possui o nome da empresa (máximo de 30 caracteres), o nome da pessoa responsável (máximo de 40 caracteres) e uma lista com até 10 telefones com DDD.

9. Um ponto é formado por duas coordenadas: x e y. Uma figura formada por retas no plano cartesiano (considere apenas o 1º quadrante) possui vários pontos para determinação destas retas. Cada ponto deste deve ter a indicação da ordem em que é desenhado. Sabe-se que cada figura tem entre 2 a 400 pontos. Crie uma modelagem de dados (usando structs e vetores) para armazenar 50 figuras.

10. Usando a estrutura fornecida, referente a atletas, elabore um programa para ler os dados de 15 atletas de uma equipe, calcular a média das idades e das alturas, e finalmente, exibir os dados lidos e as duas médias calculadas.
struct TipoAtleta{
     int  matricula;
     int  idade;
     float altura; 
};

11. Usando a estrutura TipoAtleta do exercício anterior, crie um vetor para armazenar os dados dos 15 atletas da equipe. Crie também uma estrutura para representar os dados de uma equipe: a relação de 15 atletas, o nome fantasia da equipe, e a data em que ela foi fundada. Para armazenamento da data, crie uma estrutura contendo dia, mês e ano. São ao todo 10 equipes.

12. Faça um algoritmo para ler o nome e a média de 5 alunos. Ao final exiba o nome do aluno que possui a maior média. Use uma estrutura para representar os dados do aluno.

13. Desenvolva um algoritmo para armazenar os dados de 100 equipamentos elétricos digitados pelo usuário. Cada equipamento é caracterizado pelas seguintes informações: a sua descrição (máximo de 30 caracteres), a sua potência em watts (número real) e a quantidade de fases elétricas necessárias (número inteiro). Após o cadastro exiba o nome dos equipamentos que usam duas fases. Obs.: use uma estrutura para o armazenamento dos dados do equipamento elétrico.

14. Elabore um algoritmo para armazenar os dados de 80 pessoas digitadas pelo usuário. Cada pessoa é caracterizada pelas seguintes informações: o seu nome (máximo de 30 caracteres), o seu peso e a sua idade. Após o cadastro exiba o nome dos adolescentes, ou seja, pessoas com idade de 12 a 17 anos. Obs.: use uma estrutura para o armazenamento dos dados de cada pessoa.

15. Elabore um algoritmo para armazenar os dados de várias equações do 2º grau. Use uma struct para representar os coeficientes da equação. Após o armazenamento, exiba as equações, formatadas, e as suas raízes ou ainda informe que a equação não possui raízes reais. Exemplo de formato de uma equação: 5x2 + 3x - 2 = 0
