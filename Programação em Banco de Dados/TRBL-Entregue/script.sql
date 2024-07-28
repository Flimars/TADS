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

CREATE OR REPLACE FUNCTION verificaPost(p_pessoa_id INTEGER, p_post_id INTEGER) RETURNS BOOLEAN AS 
$$
DECLARE
    eh_compartilhado BOOLEAN;
    autor_count INTEGER;
BEGIN
    --Verifica se o post é compartilhado
    SELECT compartilhado INTO eh_compartilhado FROM post WHERE id = p_post_id;

    -- Se for compartilhado, permite multiplos autores
    IF eh_compartilhado THEN
        RETURN TRUE;
    -- Se não for compartilhado, verifica se já existe um autor
    ELSE 
        SELECT COUNT(*) INTO autor_count FROM pessoa_post WHERE post_id = p_post_id;
        -- Permite a inserção apenas se não houver autores ou se for o primeiro autor
        RETURN (autor_count = 0);
    END IF;        
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
    -- CONSTRAINT endereco_tipo_check CHECK ((tipo = 'L'))
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
    CHECK (ehAutor(pessoa_id)),
    CHECK (verificaPost(pessoa_id, post_id))
);

--===========================================================================================

-- Queries:
-- Desta forma, desenvolva:

-- 1) A implementação física (script.sql) (1,0)

-- 2) Um Stored Procedured para ser usado na cláusula check que permita que somente autores (pessoa do tipo = 'A') escrevam posts (1,0)

-- Em outras palavras: que somente pessoas do tipo = 'A' (autor) estejam envolvidos em tuplas da tabela em pessoa_post.

-- Além disso, deve verificar se o Post permite - ou não - que mais de um autor esteja relacionado (possa editá-lo), permitindo que um post tenha n tuplas em pessoa_post (com ligação com diversos autores).

-- Criação da função para verificar se o post permite múltiplos autores
CREATE OR REPLACE FUNCTION post_permite_multiplos_autores(post_id INTEGER) RETURNS BOOLEAN AS 
$$
BEGIN
    RETURN (SELECT compartilhado FROM post WHERE id = post_id);
END;
$$ LANGUAGE plpgsql;

-- Criação da função que verifica as duas condições
CREATE OR REPLACE FUNCTION verifica_autor_e_post(pessoa_id INTEGER, post_id INTEGER) RETURNS BOOLEAN AS 
$$
DECLARE
    e_autor BOOLEAN;
    permite_multiplos BOOLEAN;
BEGIN
    e_autor := ehAutor(pessoa_id);
    permite_multiplos := post_permite_multiplos_autores(post_id);
    IF NOT e_autor THEN
        RETURN FALSE;
    ELSIF NOT permite_multiplos THEN
        -- Verificar se já existe algum autor para este post
        RETURN (SELECT COUNT(*) FROM pessoa_post WHERE post_id = post_id) = 0;
    ELSE
        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- 3) Um Stored Procedured que mostre as informações de todos as pessoas (leitores e autores) (1,0)
-- Caso seja leitor e tenha endereços cadastrados, estes endereços devem aparecer ao lado do nome e separados por vírgula. Se não tiver endereço cadastrado, coloque "LEITOR - SEM ENDEREÇO CADASTRADO".
-- Caso seja autor, coloque "AUTOR - SEM ENDEREÇO CADASTRADO".
-- Dica: use a função String_AGG do PostgreSQL.

CREATE OR REPLACE FUNCTION mostrar_info_pessoas()
RETURNS TABLE (nome CHARACTER VARYING(100), tipo CHAR, info TEXT) AS 
$$
BEGIN
    RETURN QUERY
    SELECT 
        p.nome,
        p.tipo,
        CASE
            WHEN p.tipo = 'L' THEN
                COALESCE('LEITOR - ' || STRING_AGG(e.rua || ', ' || e.numero || ' - ' || e.bairro || ' - ' || e.cep, '; '), 'LEITOR - SEM ENDERECO CADASTRADO')
            ELSE 'AUTOR - SEM ENDERECO CADASTRADO'
        END AS info
    FROM pessoa p
    LEFT JOIN endereco e ON p.id = e.pessoa_id
    GROUP BY p.id, p.nome, p.tipo
    ORDER BY p.nome;
END;
$$ LANGUAGE plpgsql;


-- 4) Um Stored Procedured para ser usado na cláusula check que permita verificar que somente Leitores (tipo = 'L') tenham endereço cadastrado (0,5)

CREATE OR REPLACE FUNCTION verificar_leitor_endereco(pessoa_id INTEGER) RETURNS BOOLEAN AS
$$
DECLARE
    eh_tipo_leitor CHAR;
BEGIN
    SELECT tipo INTO eh_tipo_leitor FROM pessoa WHERE id = pessoa_id;
    IF eh_tipo_leitor != 'L' THEN
        RAISE EXCEPTION 'Apenas leitores podem ter endereco cadastrado';
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- 5) Um Stored Procedured que mostre a quantidade de autores envolvidos na escrita de cada Post (0,5)
-- Mostre o título de cada Post, sua data de publicação (formatada) e a quantidade correspondente de autores.

-- Criação da Stored Procedure
CREATE OR REPLACE FUNCTION quantidade_autores_por_post()
RETURNS TABLE(titulo CHARACTER VARYING(100), data_publicacao TEXT, quantidade_autores BIGINT) AS 
$$
BEGIN
    RETURN QUERY
    SELECT 
        p.titulo,
        TO_CHAR(p.data_hora_publicacao, 'DD/MM/YYYY HH24:MI:SS') AS data_publicacao,
        COUNT(pp.pessoa_id) AS quantidade_autores
    FROM 
        post p
    LEFT JOIN 
        pessoa_post pp ON p.id = pp.post_id
    LEFT JOIN 
        pessoa pe ON pp.pessoa_id = pe.id
    WHERE 
        pe.tipo = 'A'
    GROUP BY 
        p.id, p.titulo, p.data_hora_publicacao
    ORDER BY 
        p.data_hora_publicacao;
END;
$$ LANGUAGE plpgsql;


-- 6) Um Stored Procedured que mostre o título de cada Post e o nome de cada autor envolvido em sua escrita (0,5)
-- Caso tenha mais de um autor envolvido na escrita, estes nomes devem aparecer em uma mesma coluna separados por vírgula (Use String_Agg)

CREATE OR REPLACE FUNCTION mostrar_post_autores()
RETURNS TABLE (titulo VARCHAR, autores TEXT) AS 
$$
BEGIN
    RETURN QUERY
    SELECT 
            p.titulo,
            STRING_AGG(pes.nome, ', ') AS autores
      FROM post p
 LEFT JOIN pessoa_post pp ON p.id = pp.post_id
 LEFT JOIN pessoa pes ON pp.pessoa_id = pes.id    
  GROUP BY p.id, p.titulo
  ORDER BY p.titulo; 

END;
$$ LANGUAGE plpgsql;     

-- 7) Um Stored Procedured que autentique (login) Pessoas (Leitores e Autores) (0,5)
-- As senhas devem ser armazenadas em md5

CREATE OR REPLACE FUNCTION autenticar_pessoa(p_email CHARACTER VARYING(100), p_senha CHARACTER VARYING(100))
RETURNS TABLE (id INTEGER, nome CHARACTER VARYING(100), tipo CHAR) AS 
$$
BEGIN
    RETURN QUERY
    SELECT pessoa.id, pessoa.nome, pessoa.tipo
    FROM pessoa
    WHERE pessoa.email = p_email AND pessoa.senha = MD5(p_senha);

END;
$$ LANGUAGE plpgsql;

--===========================================================================================
-- INSERTS: 
INSERT INTO pessoa (nome, senha, tipo, email) VALUES 
('Juliana Blasina', md5('b0324fdb011779993800b6b91400053d'), 'A', 'jublasina@live.com'),
('Mario Sergio Cortella', md5('06a15a2f5eb57a4a9fe5b6a54c1df42a'), 'A', 'mario@gmail.com'),
('Djamila Ribeiro', md5('d5caa356b874d9e800e13523f26dc1ce'), 'A', 'djamila.ribeiro@outlook.com'),
('Leandro Karnal', md5('9c04431bfd91c92beceb639cd3579c3f'), 'A', 'leandro.karnal@gmail.com'),
('Andrea Berriell', md5('3ecad39be5674f9c7428b59c9a5073df'), 'A', 'aberriel@outlook.com'),
('Thiago Leite', md5('91c55fabd5a86d35aa27e540962bd9c7'), 'A', 'Thiago.leite@gmail.com'),
('Alice Silva', md5('63b977eb84553d814d031b09723e01ec'), 'A', 'alice.silva@gmail.com'),
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
('Copacabana', 'Avenida Atlântica', '3020', '22070-000', 14),
('Centro', 'Avenida Eduardo Ribeiro', '500', '69010-001', 15),
('Ponta Negra', 'Alameda Uruguai', '1283', '69.037-220', 12);

INSERT INTO post (titulo, texto, data_hora_publicacao, compartilhado) VALUES 
('Manifesto In Corpa', 'Texto 1: O manifesto In Corpa celebra a diversidade de corpos e promove a aceitacao. Corpos sao unicos, e cada um tem sua propria historia. Valorize a saude, o movimento e a autoaceitacao. Seja gentil consigo mesmo e com os outros. Corpo e mente merecem amor e respeito.', NOW(), TRUE),
('O Novo Horror', 'Texto 2: O horror nao se limita a filmes de terror. O mundo real tambem tem suas historias assustadoras: desastres naturais, pandemias, conflitos. O novo horror e a incerteza, a vulnerabilidade e a busca por esperança. Enfrenta-lo requer resiliencia, compaixao e solidariedade.
', NOW(), FALSE),
('O Rastro da Serpente', 'Texto 3:A serpente, simbolo de transformacao, deixa seu rastro na jornada humana. Ela nos ensina a soltar o passado, a renovar e a nos adaptar. Assim como a serpente troca de pele, nos também podemos nos reinventar e seguir em frente, deixando um rastro de crescimento.', NOW(), FALSE),
('O Poder da Mente: Como a Psicologia Influencia na sua Rotina de Bem-Estar', 'Texto 4: A mente e uma ferramenta poderosa. Nossos pensamentos moldam nossas emocoes e comportamentos. A psicologia nos ensina a reconhecer padroes negativos, a desenvolver resiliencia e a cultivar uma mentalidade positiva. A mente e o alicerce do nosso bem-estar fisico e emocional.', NOW(), FALSE),
('Transforme sua Rotina Matinal: Habitos para um Dia Mais Produtivo e Equilibrado', 'Texto 5:  A maneira como começamos o dia influencia todo o restante. Crie uma rotina matinal que inclua hidratação, alongamento, meditação ou leitura. Evite o hábito de verificar o celular imediatamente após acordar. Priorize atividades que nutram sua mente e corpo. ', NOW(), FALSE),
('10 Passos Simples para uma Rotina Eficaz', 'Texto 6: Simplificar nossa rotina pode melhorar nossa produtividade e bem-estar. Comece com pequenas mudanças: estabeleça metas realistas, priorize tarefas importantes, durma bem, faça pausas regulares e mantenha-se organizado. A simplicidade é a chave para uma vida mais eficiente e satisfatória.
', NOW(), FALSE),
('O Poder da Mente', 'Texto 7: In auctor ullamcorper augue sit amet ultricies.', NOW(), TRUE),
('Desvendando os Mitos da Nutricao', 'Texto 8: Proin a dui aliquet, suscipit lorem eget, cursus odio.', NOW(), FALSE),
('Como a Psicologia Influencia na sua Rotina de Bem-Estar', 'Texto 9: A mente e o corpo estao intrinsecamente ligados. A psicologia desempenha um papel fundamental em nosso bem-estar. Nossos pensamentos, emocoes e comportamentos afetam nossa saude fisica. Praticar mindfulness, gerenciar o estresse e cultivar relacionamentos saudaveis sao estrategias que impactam positivamente nossa qualidade de vida.', NOW(), FALSE),
('O que e Realmente Saudavel?', 'Texto 10:  A busca pela saude muitas vezes nos leva a questionar o que é verdadeiramente saudável. É importante lembrar que não existe uma fórmula unica. O que e saudavel para uma pessoa pode nao ser para outra. Equilibrio, variedade e moderacao sao principios essenciais. Priorize alimentos naturais, evite ultraprocessados e consulte um profissional de saude para orientações personalizadas.', NOW(), TRUE);

INSERT INTO pessoa_post(pessoa_id, post_id) VALUES
(1,	1),
(3, 1),
(5, 2),
(2, 4),
(4, 9),
(6, 6),
(5, 3),
(2, 7),
(4, 7),
(7, 5),
(7, 8),
(1, 10),
(7, 10);

--============================================================================================
-- CHAMADAS DAS STORED PROCEDURES

SELECT * FROM verifica_autor_e_post(10, 1);
SELECT * FROM mostrar_info_pessoas();
SELECT * FROM verificar_leitor_endereco(10);
SELECT * FROM quantidade_autores_por_post(); 
SELECT * FROM  mostrar_post_autores();
SELECT * FROM autenticar_pessoa('jublasina@live.com', 'b0324fdb011779993800b6b91400053d'); 
