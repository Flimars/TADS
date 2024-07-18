DROP DATABASE IF EXISTS clicknews;
CREATE DATABASE clicknews;

\c clicknews;

CREATE TABLE autor (
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(60) NOT NULL,
    email CHARACTER VARYING(100) NOT NULL UNIQUE,
    senha CHARACTER VARYING(32) NOT NULL CHECK(length(senha) > 3 AND length(senha) <= 32)
);

INSERT INTO Autor (nome, email, senha) VALUES 
('Juliana Blasina', 'jublasina@live.com', md5('s3nh4123')),
('Mario Sergio Cortella', 'mario@gmail.com', md5('5enh4235')),
('Djamila Ribeiro', 'djamila.ribeiro@outlook.com', md5('s3nh4356')),
('Leandro Karnal', 'leandro.karnal@gmail.com', md5('senh4567')),
('Andrea Berriell', 'aberriel@outlook.com', md5('senha789')),
('Thiago Leite', 'Thiago.leite@gmail.com', md5('senha891'));

CREATE TABLE leitor (
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(60) NOT NULL,
    email CHARACTER VARYING(100) NOT NULL UNIQUE,
    senha CHARACTER VARYING(32) NOT NULL CHECK(length(senha) > 3 AND length(senha) <= 32)
);

INSERT INTO Leitor (nome, email, senha) VALUES
('Joao Carlos', 'jcarlos@email.com', md5('senha789')),
('Maria Elena', 'marielena@email.com', md5('senha012')), 
('Ana Maria', 'anamaria@email.com', md5('senha012')), 
('Isabella Ferreira', 'isa@email.com', md5('senha012')), 
('Rafael Martins', 'rafa@email.com', md5('senha012')), 
('Joao Lucas Gomes', 'jl@email.com', md5('senha012')), 
('Luiz Carlos Costa', 'lucca@email.com', md5('senha012')), 
('Fernanda Oliveira', 'fernanda.oliveira@email.com', md5('senha012')), 
('Sophia Locatelli', 'sophi@email.com', md5('senha912')), 
('Solange Couto', 'sol@email.com', md5('senha814')), 
('Pedro Gouvea', 'pedro.go@email.com', md5('#66senha')), 
('Rodrigo Santos', 'rodrigo@email.com', md5('123senh4'));

CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    titulo CHARACTER VARYING(100) NOT NULL,
    texto TEXT NOT NULL,
    data_hora_publicacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    compartilhado BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO post (titulo, texto, data_hora_publicacao, compartilhado) VALUES 
('Manifesto In Corpa', 'Texto 1: Pellentesque habitant morbi tristique senectus et netus et malesuada fames.', NOW(), TRUE),
('O Novo Horror', 'Texto 2: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ultrices sapien at metus dictum, vitae.', NOW(), FALSE),
('O Rastro da Serpente', 'Texto 3: Ut sit amet lacinia nunc. Sed auctor, nunc eget fermentum feugiat, justo risus.', NOW(), FALSE),
('O Poder da Mente: Como a Psicologia Influencia na sua Rotina de Bem-Estar', 'Texto 4: Integer suscipit velit id mauris ultrices, vel condimentum justo pharetra.', NOW(), FALSE);
-- ('Transforme sua Rotina Matinal: Hábitos para um Dia Mais Produtivo e Equilibrado', 'Texto 5:  Vivamus eget justo vel nunc lacinia tempus. Maecenas convallis a leo eu luctus.  Nam varius pharetra quam, a scelerisque nunc malesuada et. ', NOW(), 1, FALSE),
-- ('10 Passos Simples para uma Rotina Eficaz', 'Texto 6: Sed sagittis magna ac magna luctus, a dapibus neque posuere.', NOW(), 1, FALSE),
-- ('O Poder da Mente', 'Texto 7: In auctor ullamcorper augue sit amet ultricies.', NOW(), 1, FALSE),
-- ('Desvendando os Mitos da Nutrição', 'Texto 8: Proin a dui aliquet, suscipit lorem eget, cursus odio.', NOW(), 1, FALSE),
-- ('Como a Psicologia Influencia na sua Rotina de Bem-Estar', 'Texto 9: Morbi fermentum, mi nec lobortis dapibus, risus orci vestibulum tortor.', NOW(), 1, FALSE),
-- ('O que é Realmente Saudável?', 'Texto 10:  Nullam congue vel nisi non sodales. Suspendisse potenti.', NOW(), 1, TRUE);

CREATE TABLE post_autor (
    post_id INTEGER REFERENCES post (id),
    autor_id INTEGER REFERENCES autor (id)
    --PRIMARY KEY (post_id, autor_id)
);

INSERT INTO post_autor (post_id, autor_id) VALUES
(1, 1),
(2, 2);

CREATE TABLE post_leitor (
    post_id INTEGER REFERENCES post (id),
    leitor_id INTEGER REFERENCES leitor (id)
    --PRIMARY KEY (post_id, leitor_id)
);

INSERT INTO post_leitor (post_id, leitor_id) VALUES
(1, 1),
(1, 3),
(1, 5),
(1, 7),
(1, 8);

CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    leitor_id INTEGER REFERENCES leitor (id),
    rua TEXT NOT NULL,
    numero INTEGER NOT NULL,
    bairro TEXT NOT NULL,
    complemento TEXT NOT NULL,
    cep CHARACTER (10) NOT NULL CHECK(length(cep) = 10)
);

INSERT INTO Endereco (leitor_id, rua, numero, bairro, complemento, cep) VALUES 
(1, 'Rua Andrades Neves', '213', 'Centro', 'Apto 1', '98.280-970'),
(2, 'Praca Borges de Medeiros', '521', 'Centro', 'Apto 302', '97.544-100'),
(3, 'Rua Francisco Pastore', '79', 'Sao Paulo', 'Casa', '96.202-340'),
(10, 'Avenida Borges de Medeiros', '1098', 'Leblon',  'Apto 603', '22.430-042'),
(8, 'Travessa Zumbi dos Palmares', '973', 'Gralha Azul',  'Casa', '83.824-233'),
(4, 'Rua Mestre Jerônimo', '147', 'Varjota',  'Apto 501', '60.175-341'),
(9, 'Rua Ernesto Alves', '213', 'Jardim Felicidade',  'Casa', '15.052-363'),
(11, 'Avenida Presidente Vargas', '3079', 'Cidade Nova',  'Apto 904', '20.210-959'),
(12, 'Rua do Viveiro', '1690', 'Alphaville',  'Apto 1003 ', '06.539-305'),
(7, 'Rua Grajau', '37', 'Novo Aleixo',  'Casa', '69.098-297'),
(5, 'Alameda Uruguai', '1283', 'Ponta Negra',  'Casa', '69.037-220');

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Queries:
-- Desta forma, desenvolva:

-- 1) A implementação física (script.sql) (1,0)

-- 2) Um Stored Procedured para ser usado na cláusula check que permita que somente autores (pessoa do tipo = 'A') escrevam posts (1,0)

-- Em outras palavras: que somente pessoas do tipo = 'A' (autor) estejam envolvidos em tuplas da tabela em pessoa_post.

-- Além disso, deve verificar se o Post permite - ou não - que mais de um autor esteja relacionado (possa editá-lo), permitindo que um post tenha n tuplas em pessoa_post (com ligação com diversos autores).

-- 3) Um Stored Procedured que mostre as informações de todos as pessoas (leitores e autores) (1,0)

-- Caso seja leitor e tenha endereços cadastrados, estes endereços devem aparecer ao lado do nome e separados por vírgula. Se não tiver endereço cadastrado, coloque "LEITOR - SEM ENDEREÇO CADASTRADO".

-- Caso seja autor, coloque "AUTOR - SEM ENDEREÇO CADASTRADO".

-- Dica: use a função String_AGG do PostgreSQL.

-- 4) Um Stored Procedured para ser usado na cláusula check que permita verificar que somente Leitores (tipo = 'L') tenham endereço cadastrado (0,5)

-- 5) Um Stored Procedured que mostre a quantidade de autores envolvidos na escrita de cada Post (0,5)

-- Mostre o título de cada Post, sua data de publicação (formatada) e a quantidade correspondente de autores.
-- 6) Um Stored Procedured que mostre o título de cada Post e o nome de cada autor envolvido em sua escrita (0,5)

-- Caso tenha mais de um autor envolvido na escrita, estes nomes devem aparecer em uma mesma coluna separados por vírgula (Use String_Agg)
-- 7) Um Stored Procedured que autentique (login) Pessoas (Leitores e Autores) (0,5)

-- As senhas devem ser armazenadas em md5
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
