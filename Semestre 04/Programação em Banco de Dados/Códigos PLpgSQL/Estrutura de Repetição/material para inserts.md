Aqui estão as senhas MD5 geradas para os autores e leitores:

### Senhas MD5 para Autores
1. `senha_autor1`: `b0324fdb011779993800b6b91400053d`
2. `senha_autor2`: `06a15a2f5eb57a4a9fe5b6a54c1df42a`
3. `senha_autor3`: `d5caa356b874d9e800e13523f26dc1ce`
4. `senha_autor4`: `9c04431bfd91c92beceb639cd3579c3f`
5. `senha_autor5`: `3ecad39be5674f9c7428b59c9a5073df`
6. `senha_autor6`: `91c55fabd5a86d35aa27e540962bd9c7`

### Senhas MD5 para Leitores
1. `senha_leitor1`: `63b977eb84553d814d031b09723e01ec`
2. `senha_leitor2`: `e899c5d48f198024d7eeea433bbafe29`
3. `senha_leitor3`: `071312b094da11c8c0e94c73ffbd1dcb`
4. `senha_leitor4`: `6cbf2fa14c3b4417ecaa7afb6f1ae1a5`
5. `senha_leitor5`: `285c69c9ddc457ce2dbcab45c6b45586`
6. `senha_leitor6`: `6487759e291b246a8a37635300433cef`
7. `senha_leitor7`: `24448661953e9e6c88294455f95435a4`
8. `senha_leitor8`: `c4a68a8f86a1d165576e1341488773ad`
9. `senha_leitor9`: `1aebbb5ac81062d97a88656165724900`
10. `senha_leitor10`: `d1e9a5c605421cb92b286a43d3009b75`
11. `senha_leitor11`: `f4cce152735472a5c195c19cfa6add4a`
12. `senha_leitor12`: `94a58f85a513466b77f9c1f726243222`
13. `senha_leitor13`: `7b0f8daab95ff8350b20ae8231c0b9e4`
14. `senha_leitor14`: `77bf2445da5d4ac787cfe0168ee9d85b`
15. `senha_leitor15`: `8e28f14923fe30a540003c5ec6485695`

Essas são as senhas MD5 geradas para os autores e leitores. Você pode usar essas senhas ao inserir os dados no banco de dados.


Scripts[tabelas e inserts]
-- Criação das tabelas
CREATE TABLE Pessoa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    senha VARCHAR(100) NOT NULL,
    tipo CHAR(1) CHECK (tipo = 'L' OR tipo = 'A'),
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Endereco (
    id SERIAL PRIMARY KEY,
    bairro VARCHAR(100) NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(5) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    pessoa_id INTEGER NOT NULL REFERENCES Pessoa(id),
    CHECK (tipo = 'L')
);

CREATE TABLE Post (
    id SERIAL PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT current_timestamp,
    titulo VARCHAR(100) NOT NULL,
    texto TEXT NOT NULL,
    compartilhado BOOLEAN DEFAULT FALSE
);

CREATE TABLE Pessoa_Post (
    pessoa_id INTEGER NOT NULL REFERENCES Pessoa(id),
    post_id INTEGER NOT NULL REFERENCES Post(id),
    PRIMARY KEY (pessoa_id, post_id),
    CHECK (ehAutor(pessoa_id) IS TRUE),
    CHECK (verificaPost(post_id) IS TRUE)
);

-- Inserção de dados
INSERT INTO Pessoa (nome, senha, tipo, email) VALUES
('Autor1', md5('senha1'), 'A', 'autor1@example.com'),
('Autor2', md5('senha2'), 'A', 'autor2@example.com'),
('Autor3', md5('senha3'), 'A', 'autor3@example.com'),
('Autor4', md5('senha4'), 'A', 'autor4@example.com'),
('Autor5', md5('senha5'), 'A', 'autor5@example.com'),
('Autor6', md5('senha6'), 'A', 'autor6@example.com');

INSERT INTO Pessoa (nome, senha, tipo, email) VALUES
('Leitor1', md5('senha1'), 'L', 'leitor1@example.com'),
('Leitor2', md5('senha2'), 'L', 'leitor2@example.com'),
('Leitor3', md5('senha3'), 'L', 'leitor3@example.com'),
('Leitor4', md5('senha4'), 'L', 'leitor4@example.com'),
('Leitor5', md5('senha5'), 'L', 'leitor5@example.com'),
('Leitor6', md5('senha6'), 'L', 'leitor6@example.com'),
('Leitor7', md5('senha7'), 'L', 'leitor7@example.com'),
('Leitor8', md5('senha8'), 'L', 'leitor8@example.com'),
('Leitor9', md5('senha9'), 'L', 'leitor9@example.com'),
('Leitor10', md5('senha10'), 'L', 'leitor10@example.com'),
('Leitor11', md5('senha11'), 'L', 'leitor11@example.com'),
('Leitor12', md5('senha12'), 'L', 'leitor12@example.com'),
('Leitor13', md5('senha13'), 'L', 'leitor13@example.com'),
('Leitor14', md5('senha14'), 'L', 'leitor14@example.com'),
('Leitor15', md5('senha15'), 'L', 'leitor15@example.com');

INSERT INTO Endereco (bairro, rua, numero, cep, pessoa_id) VALUES
('Bairro1', 'Rua1', '1', '11111-111', 7),
('Bairro2', 'Rua2', '2', '22222-222', 8),
('Bairro3', 'Rua3', '3', '33333-333', 9),
('Bairro4', 'Rua4', '4', '44444-444', 10),
('Bairro5', 'Rua5', '5', '55555-555', 11),
('Bairro6', 'Rua6', '6', '66666-666', 12),
('Bairro7', 'Rua7', '7', '77777-777', 13),
('Bairro8', 'Rua8', '8', '88888-888', 14),
('Bairro9', 'Rua9', '9', '99999-999', 15),
('Bairro10', 'Rua10', '10', '10101-101', 16),
('Bairro11', 'Rua11', '11', '11111-111', 17),
('Bairro12', 'Rua12', '12', '12121-121', 18),
('Bairro13', 'Rua13', '13', '13131-131', 19),
('Bairro14', 'Rua14', '14', '14141-141', 20),
('Bairro15', 'Rua15', '15', '15151-151', 21);

INSERT INTO Post (titulo, texto, compartilhado) VALUES
('Post1', 'Texto do post 1', FALSE),
('Post2', 'Texto do post 2', TRUE),
('Post3', 'Texto do post 3', FALSE),
('Post4', 'Texto do post 4', TRUE),
('Post5', 'Texto do post 5', FALSE),
('Post6', 'Texto do post 6', TRUE);

INSERT INTO Pessoa_Post (pessoa_id, post_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6),
(1, 2), (2, 2), (3, 4), (4, 4), (5, 6), (6, 6);


INSERT INTO Endereco (bairro, rua, numero, cep, pessoa_id) VALUES 
('Jardim Paulista', 'Avenida Paulista', '1578', '01310-200', 1),
('Centro', 'Rua Sete de Setembro', '35', '20050-005', 2),
('Copacabana', 'Avenida Atlântica', '3020', '22070-000', 3);

INSERT INTO Endereco (bairro, rua, numero, cep, pessoa_id) VALUES 
('Centro', 'Avenida Eduardo Ribeiro', '500', '69010-001', 4);

INSERT INTO pessoa (nome, senha, tipo, email) VALUES 
('Juliana Blasina', md5('b0324fdb011779993800b6b91400053d'), 'A', 'jublasina@live.com'),
('Mario Sergio Cortella', md5('06a15a2f5eb57a4a9fe5b6a54c1df42a'),  'A', 'mario@gmail.com'),
('Djamila Ribeiro', md5('d5caa356b874d9e800e13523f26dc1ce'), 'A', 'djamila.ribeiro@outlook.com'),
('Leandro Karnal', md5('9c04431bfd91c92beceb639cd3579c3f'), 'A', 'leandro.karnal@gmail.com'),
('Andrea Berriell', md5('3ecad39be5674f9c7428b59c9a5073df'), 'A', 'aberriel@outlook.com'),
('Thiago Leite', md5('91c55fabd5a86d35aa27e540962bd9c7'), 'A', 'Thiago.leite@gmail.com'),
('Alice Silva', md5('63b977eb84553d814d031b09723e01ec'), 'L', 'alice.silva@gmail.com'),
('Sofia Oliveira', md5('63b977eb84553d814d031b09723e01ec'), 'L', 'sofia.oliveira@hotmail.com'),
('Joao Carlos', md5('63b977eb84553d814d031b09723e01ec'), 'L', 'jcarlos@terra.com'),
('Maria Elena', md5('e899c5d48f198024d7eeea433bbafe29'), 'L', 'marielena@hotmail.com'), 
('Ana Maria', md5('071312b094da11c8c0e94c73ffbd1dcb'), 'L', 'anamaria@live.com'), 
('Isabella Ferreira', md5('6cbf2fa14c3b4417ecaa7afb6f1ae1a5'), 'L', 'isa@yahoo.com'), 
('Rafael Martins', md5('285c69c9ddc457ce2dbcab45c6b45586'), 'L', 'rafa@terra.com.br'), 
('Joao Lucas Gomes',  md5('6487759e291b246a8a37635300433cef'), 'L', 'jl@outlook.com'), 
('Luiz Carlos Costa',  md5('24448661953e9e6c88294455f95435a4'), 'L', 'lucca@gmail.com'), 
('Fernanda Oliveira',  md5('c4a68a8f86a1d165576e1341488773ad'), 'L', 'fernanda.oliveira@outlook.com'), 
('Sophia Locatelli',  md5('1aebbb5ac81062d97a88656165724900'), 'L', 'sophi@hotmail.com'), 
('Solange Couto', md5('d1e9a5c605421cb92b286a43d3009b75'), 'L', 'sol@live.com'), 
('Pedro Gouvea',  md5('f4cce152735472a5c195c19cfa6add4a'), 'L', 'pedro.go@gmail.com'), 
('Rodrigo Santos',  md5('94a58f85a513466b77f9c1f726243222'), 'L', 'rodrigo@outlook.com');

INSERT INTO Endereco (bairro, rua, numero, cep, pessoa_id) VALUES 
('Centro', 'Rua Andrades Neves', '213', '98.280-970', 13),
('Centro', 'Praca Borges de Medeiros', '521', '97.544-100', 20),
('Sao Paulo', 'Rua Francisco Pastore', '79', '96.202-340', 19),
('Leblon',  'Avenida Borges de Medeiros', '1098', '22.430-042', 10),
('Gralha Azul',  'Travessa Zumbi dos Palmares', '973', '83.824-233', 18),
('Varjota', 'Rua Mestre Jerônimo', '147', '60.175-341', 17),
('Jardim Felicidade',  'Rua Ernesto Alves', '213', '15.052-363', 9),
('Parque Coelho', 'Avenida Presidente Vargas', '3079', '20.210-959', 11),
('Alphaville', 'Rua do Viveiro', '1690',  '06.539-305', 12),
('Novo Aleixo', 'Rua Grajau', '37',  '69.098-297', 8),
('Centro', 'Avenida Eduardo Ribeiro', '500', '69010-001', 16),
('Jardim Paulista', 'Avenida Paulista', '1578', '01310-200', 7),
('Copacabana', 'Avenida Atlântica', '3020', '22070-000', 14),
('Centro', 'Avenida Eduardo Ribeiro', '500', '69010-001', 15),
('Ponta Negra', 'Alameda Uruguai', '1283', '69.037-220', 12);

INSERT INTO post (titulo, texto, data_hora_publicacao, compartilhado) VALUES 
('Manifesto In Corpa', 'Texto 1: O manifesto In Corpa celebra a diversidade de corpos e promove a aceitação. Corpos são únicos, e cada um tem sua própria história. Valorize a saúde, o movimento e a autoaceitação. Seja gentil consigo mesmo e com os outros. Corpo e mente merecem amor e respeito.', NOW(), TRUE),
('O Novo Horror', 'Texto 2: O horror não se limita a filmes de terror. O mundo real também tem suas histórias assustadoras: desastres naturais, pandemias, conflitos. O novo horror é a incerteza, a vulnerabilidade e a busca por esperança. Enfrentá-lo requer resiliência, compaixão e solidariedade.', NOW(), FALSE);

INSERT INTO pessoa_post(pessoa_id, post_id) VALUES
(1, 1),
(2, 2),
(6, 1);