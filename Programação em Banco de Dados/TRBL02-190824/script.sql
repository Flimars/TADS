/*
    Construa um Banco de Dados (B.D.)de gerenciamento de faxinas para diaristas:

    O banco de dados deve controlar o histórico de faxinas realizados por cada diarista em cada residência.

    Cada Diarista possui um identificador (id), cpf e nome;
    Cada Residência possui um responsável. Para o responsável é importante armazenar seu nome e seu cpf;
    Além do responsável, cada Residência possui um identificador (id), cidade, bairro, rua, complemento e número e Tamanho (pequena, média ou grande);
    Um Responsável pode ser responsável por mais de uma Residência mas uma Residência tem somente um Responsável;
    Dependendo do Tamanho da Residência, a Faxina tem um preço;
    Uma Diarista realiza uma Faxina por dia, ou seja, atende uma Residência por dia;
    Uma Diarista pode atender várias residências, e uma residência pode ser atendida por várias Diaristas;
    Faxinas podem ser agendadas (por data);
    É importante saber se a Diarista não foi, ou seja, faltou a uma Faxina, previamente, agendada;
    Faxinas agendadas e não-realizadas não devem ser pagas, independente do motivo;
    É importante armazenar feedbacks de avaliação por cada Faxina realizada. Estes comentários devem ser realizados pelo Responsável da Residência no momento da conclusão da Faxina;
    O valor final pago pela Faxina deve ser também armazenado pois o valor pode ser: maior devido à gorjetas, menor devido à algum dano/prejuízo causado pela diarista ou igual ao valor definido para residências de mesmo Tamanho. Lembrando que, ao longo do tempo, o valor da Faxina atribuído pelo Tamanho da Residência pode também mudar. Logo, é importante armazenar também este valor que foi realmente pago por cada Faxina a fim de saber, especificamente, o que cada Diarista recebeu pelas Faxinas que fez ao longo do tempo.

    Exigências:
    Crie o Modelo Relacional

    Implemente no PostgreSQL o Banco de Dados projetado no Modelo Relacional (construa um script.sql)

    1. Crie um STORE PROCEDURE que permita agendar quinzenalmente ou mensalmente faxinas em uma determinada residência:

    2. A diarista e a residência devem ser considerados parâmetros de entrada. Por outro lado, pode-se realizar o stored procedure de 2 formas: 
    Opções:
     1) Utilizar uma data limite (ex: até 31/12 do ano atual). 
     2) Utilizar uma quantidade máxima de agendamentos (ex: marcar 30 faxinas mensalmente).

    3. Crie um STORE PROCEDURE que calcule a porcentagem de presenças que uma diarista obteve em suas faxinas ao longo do ano:
    Ex: 75% de presença

    4. Crie uma TRIGGER que exclua a diarista caso suas presenças fiquem menores que 75% (quando a diarista já tem no mínimo 5 faxinas cadastradas).

*/

DROP DATABASE IF EXISTS faxina;

CREATE DATABASE faxina;

\c faxina;

-- Diarista
CREATE TABLE diarista (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL
);

-- Responsável
CREATE TABLE responsavel (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL
);

-- Residência
CREATE TABLE residencia (
    id SERIAL PRIMARY KEY,
    cidade VARCHAR(50) NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    rua VARCHAR(100) NOT NULL,
    complemento VARCHAR(50),
    numero VARCHAR(10) NOT NULL,
    tamanho ENUM('pequena', 'media', 'grande') NOT NULL,
    responsavel_id INTEGER REFERENCES responsavel(id)
);

-- Preço_Faxina
CREATE TABLE preco_faxina (
    id SERIAL PRIMARY KEY,
    tamanho ENUM('pequena', 'media', 'grande') NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE
);

-- Faxina
CREATE TABLE faxina (
    id SERIAL PRIMARY KEY,
    diarista_id INTEGER REFERENCES diarista(id),
    residencia_id INTEGER REFERENCES residencia(id),
    data_agendada DATE NOT NULL,
    realizada BOOLEAN NOT NULL DEFAULT FALSE,
    valor_pago DECIMAL(10, 2),
    feedback TEXT,
    UNIQUE (diarista_id, data_agendada)
);