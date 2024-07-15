/*
    Entrando pelo Terminal
# 1
psql -U postgres

# 2  
export PGPASSWORD='postgres'; psql -h 'localhost' -U 'postgres' 

# 3
psql -h 'localhost' -U 'postgres' 
 */

DROP DATABASE IF EXISTS locadora;
CREATE DATABASE locadora;

\c locadora;


- Criação da tabela CLIENTES
CREATE TABLE CLIENTES (
  codCliente SERIAL PRIMARY KEY,
  nome_cliente VARCHAR(100),
  endereco VARCHAR(100),
  telefone VARCHAR(20),
  data_nasc DATE,
  cpf VARCHAR(14)
);

-- Criação da tabela CATEGORIA
CREATE TABLE CATEGORIA (
  codCategoria SERIAL PRIMARY KEY,
  nome_categoria VARCHAR(50)
);

-- Criação da tabela FILME
CREATE TABLE FILME (
  codFilme SERIAL PRIMARY KEY,
  nome_filme VARCHAR(100),
  codCategoria INT REFERENCES CATEGORIA(codCategoria),
  diaria DECIMAL(8,2)
);

-- Criação da tabela STATUS
CREATE TABLE STATUS (
  codStatus SERIAL PRIMARY KEY,
  nome_status VARCHAR(50)
);

-- Criação da tabela DVD
CREATE TABLE DVD (
  codDVD SERIAL PRIMARY KEY,
  codFilme INT REFERENCES FILME(codFilme),
  codStatus INT REFERENCES STATUS(codStatus)
);

-- Criação da tabela LOCACAO
CREATE TABLE LOCACAO (
  codLocacao SERIAL PRIMARY KEY,
  codDVD INT REFERENCES DVD(codDVD),
  codCliente INT REFERENCES CLIENTES(codCliente),
  data_locacao DATE,
  data_devolucao DATE
);

-- Criação da tabela RESERVA
CREATE TABLE RESERVA (
  codReserva SERIAL PRIMARY KEY,
  codDVD INT REFERENCES DVD(codDVD),
  codCliente INT REFERENCES CLIENTES(codCliente),
  data_reserva DATE,
  data_validade DATE
);

-- INSERTS:
-- Inserts para a tabela CLIENTES
INSERT INTO CLIENTES (nome_cliente, endereco, telefone, data_nasc, cpf)
VALUES ('João Silva', 'Rua A, 123', '987654321', '1990-05-15', '123.456.789-01'),
       ('Maria Santos', 'Avenida B, 456', '123456789', '1992-10-20', '987.654.321-09'),
       ('Carlos Oliveira', 'Rua C, 789', '789456123', '1988-03-08', '456.789.123-45'),
       ('Ana Pereira', 'Avenida D, 321', '321654987', '1995-12-01', '789.123.456-78'),
       ('Pedro Ferreira', 'Rua E, 987', '654987321', '1998-07-25', '321.654.987-01');

-- Inserts para a tabela CATEGORIA
INSERT INTO CATEGORIA (nome_categoria)
VALUES ('Drama'),
       ('Ação'),
       ('Aventura'),
       ('Comédia'),
       ('Terror');

-- Inserts para a tabela FILME
INSERT INTO FILME (nome_filme, codCategoria, diaria)
VALUES ('A Sociedade dos poetas mortos', 1, 9.99),
       ('Comando Delta', 2, 8.50),
       ('As Aventruras de Benji', 3, 7.99),
       ('Locademia de Policia', 4, 6.50),
       ('A Hora do Pesadelo', 5, 9.50);

-- Inserts para a tabela STATUS
INSERT INTO STATUS (nome_status)
VALUES ('Locado'),
       ('Disponível'),
       ('Reservado');

-- Inserts para a tabela DVD
INSERT INTO DVD (codFilme, codStatus)
VALUES (1, 2),
       (2, 2),
       (3, 1),
       (4, 3),
       (5, 2);

-- Inserts para a tabela LOCACAO
INSERT INTO LOCACAO (codDVD, codCliente, data_locacao, data_devolucao)
VALUES (1, 3, '2024-07-10', '2024-07-15'),
       (2, 1, '2024-07-11', '2024-07-16'),
       (3, 5, '2024-07-12', '2024-07-17'),
       (4, 2, '2024-07-13', '2024-07-18'),
       (5, 4, '2024-07-14', '2024-07-19');

-- Inserts para a tabela RESERVA
INSERT INTO RESERVA (codDVD, codCliente, data_reserva, data_validade)
VALUES (3, 2, '2024-07-10', '2024-07-13'),
       (4, 4, '2024-07-11', '2024-07-14'),
       (2, 1, '2024-07-12', '2024-07-15'),
       (5, 3, '2024-07-13', '2024-07-16'),
       (1, 5, '2024-07-14', '2024-07-17');

/* Consultas:

1. Faça uma função que apaga um cliente de código x que deve ser passado como parâmetro.

2. Faça uma função que insere um cliente, os parâmetros necessários devem ser passados (com exceção do código do cliente).

3. Faça uma função que imprima o número de filmes e dvds disponíveis de uma categoria X. Onde X é o parâmetro.

4. Faça uma função que retorne o nome do filme mais locado.

5. Fazer uma função que receba como parâmetro o nome de um cliente e retorne a quantidade de DVDs locados por ele. E se existirem dois clientes com o mesmo nome?

6. Faça um procedimento que insere um item na tabela Locação, passe como parâmetro apenas o nome do filme e o nome do cliente. Para a data de locação utilize a data atual do sistema. Não esqueça de alterar o status para locado. A função deve retornar verdadeiro ou falso caso consiga efetuar a locação (tenha algum DVD disponível)

7. Refaça o exercício anterior, agora gerando criando uma exceção, caso o filme solicitado não tenha nenhum dvd disponível.

8. Faça um procedimento que altere o status dos DVDs com reserva vencida. Isso só deve ser feito se o status do DVD está reservado. Não se esqueça que um DVD pode estar reservado e já ter sido reservado outras vezes e obviamente apenas a última reserva é que não estará vencida e com isso o DVD não deverá ter seu status modificado.

9. Crie um trigger que gera um log de todas as alterações na tabela DVD (linha por linha). Para isso crie uma tabela de log com os campos código (serial), comando (INSERT, DELETE ou UPDATE) e descrição (o que ocorreu).

10. Faça um trigger que modifica o status de um DVD, baseado em cada um dos eventos:

a. Entrega de um DVD alugado

b. Reserva de um DVD. Considere uma reserva de 4 dias, a contar do dia atual caso o DVD esteja disponível, caso contrário a reserva não deve ser efetuada.

11. Fazer um gatilho que controla o evento de uma locação e testa o status do DVD desejado para locação:

a. Caso o DVD esteja disponível, apenas é necessário mudar o status do DVD e efetivar a operação

b. Caso esteja reservado, deve ser verificado se a locação esta sendo realizada pelo mesmo cliente que possui a reserva: i. caso seja, permita a operação e altere o status do DVD; ii. caso não esteja, não permita a realização da operação (gere um erro com a mensagem: "Reserva para outro cliente!")

c. Caso esteja locado, não permita a realização da operação e gere um erro com a mensagem: "DVD locado!"

*** Pauta de Hoje:
Quem sabe antecipar nossa avaliação?

Quem sabe mostrar matéria nova? O que está faltando da ementa é trigger.

Quem sabe continuar o código da aula passada?

Quem sabe terminar a lista de exercícios?

*/
