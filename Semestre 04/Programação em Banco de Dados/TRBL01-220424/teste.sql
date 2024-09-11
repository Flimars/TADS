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
    v_compartilhado BOOLEAN;
    v_autor_count INTEGER;
BEGIN
    --Verifica se o post é compartilhado
    SELECT compartilhado INTO v_compartilhado FROM post WHERE id = p_post_id;

    -- Se for compartilhado, permite multiplos autores
    IF v_compartilhado THEN
        RETURN TRUE;
    -- Se não for compartilhado, verifica se já existe um autor
    ELSE 
        SELECT COUNT(*) INTO v_autor_count FROM pessoa_post WHERE post_id = p_post_id;
        -- Permite a inserção apenas se não houver autores ou se for o primeiro autor
        RETURN (v_autor_count = 0);
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

-- 1) A implementação física (script.sql) (1,0)

-- 2) Um Stored Procedured para ser usado na cláusula check que permita que somente autores (pessoa do tipo = 'A') escrevam posts (1,0)

-- Em outras palavras: que somente pessoas do tipo = 'A' (autor) estejam envolvidos em tuplas da tabela em pessoa_post.

-- Além disso, deve verificar se o Post permite - ou não - que mais de um autor esteja relacionado (possa editá-lo), permitindo que um post tenha n tuplas em pessoa_post (com ligação com diversos autores).

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
        RAISE EXCEPTION 'Apenas leitores podem ter endereço cadastrado';
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- 5) Um Stored Procedured que mostre a quantidade de autores envolvidos na escrita de cada Post (0,5)
-- Mostre o título de cada Post, sua data de publicação (formatada) e a quantidade correspondente de autores.

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
('Luiz Felipe Pondé', md5('84d961568a65073a3bcf0eb216b2a576'), 'A', 'lfp@uol.com.br');

INSERT INTO post (titulo, texto, compartilhado) VALUES 
('Filosofia Grega', 'O legado dos filósofos gregos', false),
('História do Brasil', 'Os principais eventos da história do Brasil', true),
('Psicologia Moderna', 'Conceitos e práticas da psicologia moderna', true),
('Literatura Clássica', 'Análise de obras clássicas da literatura mundial', false),
('Ciência Política', 'Teorias e práticas da ciência política', true);

INSERT INTO pessoa_post (pessoa_id, post_id) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
