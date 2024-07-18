DROP DATABASE IF EXISTS clicknews;
CREATE DATABASE clicknews;

\c clicknews;
--===========================================================================
-- FUNCTIONS:

CREATE OR REPLACE FUNCTION ehLeitor(pessoa_id INTEGER) RETURNS BOOLEAN AS 
$$
BEGIN
    RETURN (SELECT tipo FROM Pessoa WHERE id = pessoa_id) = 'L';
END;
$$ LANGUAGE plpgsql;
--===========================================================================

CREATE OR REPLACE FUNCTION ehAutor(pessoa_id INTEGER) RETURNS BOOLEAN AS 
$$
BEGIN
    RETURN (SELECT tipo FROM Pessoa WHERE id = pessoa_id) = 'A';
END;
$$ LANGUAGE plpgsql;
--===========================================================================

CREATE OR REPLACE FUNCTION verificaPost(post_id INTEGER) RETURNS BOOLEAN AS 
$$
BEGIN
    RETURN (SELECT compartilhado FROM Post WHERE id = post_id);
END;
$$ LANGUAGE plpgsql;

--===========================================================================
-- TABLES:
CREATE TABLE pessoa (
    id SERIAL PRIMARY KEY,
    nome character varying(100) NOT NULL,
    senha character varying(100) NOT NULL,
    tipo character(1) CHECK (tipo = 'L' OR tipo = 'A'),
    email character varying(100) NOT NULL   
);

CREATE TABLE Endereco (
    id SERIAL PRIMARY KEY,
    bairro VARCHAR(100) NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(5) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    pessoa_id INTEGER REFERENCES Pessoa(id),
    CHECK (ehLeitor(pessoa_id) IS TRUE)
);

CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    titulo CHARACTER VARYING(100) NOT NULL,
    texto TEXT NOT NULL,
    data_hora_publicacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    compartilhado BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE pessoa_post (
    pessoa_id INTEGER REFERENCES pessoa(id),
    post_id INTEGER REFERENCES post(id),
    PRIMARY KEY (pessoa_id, post_id),
    CHECK (ehAutor(pessoa_id))
    -- CHECK (verificaPost(post_id))
);
--===========================================================================
-- INSERTS: 
INSERT INTO pessoa (nome, senha, tipo, email) VALUES 
('Juliana Blasina', md5('b0324fdb011779993800b6b91400053d'), 'A', 'jublasina@live.com'),
('Mario Sergio Cortella', md5('06a15a2f5eb57a4a9fe5b6a54c1df42a'), 'A', 'mario@gmail.com'),
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
('O Novo Horror', 'Texto 2: O horror não se limita a filmes de terror. O mundo real também tem suas histórias assustadoras: desastres naturais, pandemias, conflitos. O novo horror é a incerteza, a vulnerabilidade e a busca por esperança. Enfrentá-lo requer resiliência, compaixão e solidariedade.
', NOW(), FALSE);
-- ('O Rastro da Serpente', 'Texto 3:A serpente, símbolo de transformação, deixa seu rastro na jornada humana. Ela nos ensina a soltar o passado, a renovar e a nos adaptar. Assim como a serpente troca de pele, nós também podemos nos reinventar e seguir em frente, deixando um rastro de crescimento.', NOW(), FALSE),
-- ('O Poder da Mente: Como a Psicologia Influencia na sua Rotina de Bem-Estar', 'Texto 4: A mente é uma ferramenta poderosa. Nossos pensamentos moldam nossas emoções e comportamentos. A psicologia nos ensina a reconhecer padrões negativos, a desenvolver resiliência e a cultivar uma mentalidade positiva. A mente é o alicerce do nosso bem-estar físico e emocional.', NOW(), FALSE),
-- ('Transforme sua Rotina Matinal: Hábitos para um Dia Mais Produtivo e Equilibrado', 'Texto 5:  A maneira como começamos o dia influencia todo o restante. Crie uma rotina matinal que inclua hidratação, alongamento, meditação ou leitura. Evite o hábito de verificar o celular imediatamente após acordar. Priorize atividades que nutram sua mente e corpo. ', NOW(), FALSE),
-- ('10 Passos Simples para uma Rotina Eficaz', 'Texto 6: Simplificar nossa rotina pode melhorar nossa produtividade e bem-estar. Comece com pequenas mudanças: estabeleça metas realistas, priorize tarefas importantes, durma bem, faça pausas regulares e mantenha-se organizado. A simplicidade é a chave para uma vida mais eficiente e satisfatória.
-- ', NOW(), FALSE),
-- ('O Poder da Mente', 'Texto 7: In auctor ullamcorper augue sit amet ultricies.', NOW(), TRUE),
-- ('Desvendando os Mitos da Nutrição', 'Texto 8: Proin a dui aliquet, suscipit lorem eget, cursus odio.', NOW(), FALSE),
-- ('Como a Psicologia Influencia na sua Rotina de Bem-Estar', 'Texto 9: A mente e o corpo estão intrinsecamente ligados. A psicologia desempenha um papel fundamental em nosso bem-estar. Nossos pensamentos, emoções e comportamentos afetam nossa saúde física. Praticar mindfulness, gerenciar o estresse e cultivar relacionamentos saudáveis são estratégias que impactam positivamente nossa qualidade de vida.', NOW(), FALSE),
-- ('O que é Realmente Saudável?', 'Texto 10:  A busca pela saúde muitas vezes nos leva a questionar o que é verdadeiramente saudável. É importante lembrar que não existe uma fórmula única. O que é saudável para uma pessoa pode não ser para outra. Equilíbrio, variedade e moderação são princípios essenciais. Priorize alimentos naturais, evite ultraprocessados e consulte um profissional de saúde para orientações personalizadas.', NOW(), TRUE);

INSERT INTO pessoa_post(pessoa_id, post_id) VALUES
(1,	1),
(2, 2);

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
