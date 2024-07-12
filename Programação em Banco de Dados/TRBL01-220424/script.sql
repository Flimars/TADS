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

-- Queries
-- Consulta que apareçam somente os autores que tem post.
select a.id, a.nome from autor a  join post_autor pa on a.id = pa.autor_id join post p on pa.post_id = p.id;