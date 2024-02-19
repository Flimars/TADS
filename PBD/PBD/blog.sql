-

/*4) Um Stored Procedured para ser usado na cláusula check que permita verificar que somente 
Leitores (tipo = 'L') tenham endereço cadastrado (0,5) (OK)*/

CREATE OR REPLACE FUNCTION ehLeitor(integer) RETURNS BOOLEAN AS 
$$
DECLARE
    tipo_pessoa CHARACTER(1);
BEGIN
    SELECT INTO tipo_pessoa tipo FROM pessoa WHERE id = $1;
    IF (tipo_pessoa = 'L') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;           
    END IF;
END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION ehAutor(integer) RETURNS BOOLEAN AS 
$$
DECLARE
    tipo_pessoa CHARACTER(1);
BEGIN
    SELECT INTO tipo_pessoa tipo FROM pessoa WHERE id = $1;
    IF (tipo_pessoa = 'A') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;           
    END IF;
END;
$$ LANGUAGE 'plpgsql';

/*2) Um Stored Procedured para ser usado na cláusula check que permita que somente autores (pessoa do tipo = 'A') escrevam posts (1,0)*/
-- Recebe id do post e verifica se é compartilhado ou não
CREATE OR REPLACE FUNCTION verificaPost(INTEGER) RETURNS BOOLEAN AS 
$$
DECLARE
    isCompartilhado BOOLEAN;
    quantidade INTEGER;
BEGIN
-- Quantidade de pessoas que escreveram o post
    SELECT COUNT(DISTINCT pessoa_post.pessoa_id) INTO quantidade FROM pessoa_post 
        INNER JOIN post ON post.id = pessoa_post.post_id 
        WHERE post.id = $1;
    SELECT INTO isCompartilhado compartilhado FROM post WHERE post.id = $1;
    IF (quantidade = 0 AND isCompartilhado = FALSE) THEN
        isCompartilhado = TRUE;
    END IF;
    RETURN isCompartilhado;
END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION quantidadeAutoresPost(INTEGER)
RETURNS TABLE (titulo CHARACTER VARYING(100), 
                data_formatada TEXT, 
                qtde_autores INTEGER)
AS
$$
DECLARE 
    contador INTEGER;
    var_r RECORD;
BEGIN
    SELECT COUNT(DISTINCT pessoa_post.pessoa_id) INTO contador FROM pessoa_post 
        INNER JOIN post ON post.id = pessoa_post.post_id 
        WHERE post.id = $1;
    RETURN QUERY
        SELECT post.titulo, TO_CHAR(post.data_hora, 'DD/MM/YYYY'), contador FROM post 
        WHERE id = $1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION listar_pessoas()
RETURNS TABLE (pessoa_id INTEGER, 
               nome CHARACTER VARYING(100),
               info_endereco TEXT)
AS 
$$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS pessoa_id,
        p.nome,
        CASE
            WHEN p.tipo = 'L' AND e.id IS NOT NULL 
            THEN
                STRING_AGG(e.bairro || ', ' || e.rua || ' ' || e.nro || ', ' || e.cep, ', ') 
            WHEN p.tipo = 'L' THEN 'LEITOR - SEM ENDEREÇO CADASTRADO'
            WHEN p.tipo = 'A' THEN 'AUTOR - SEM ENDEREÇO CADASTRADO'
        END AS info_endereco
    FROM pessoa p
    LEFT JOIN endereco e ON p.id = e.pessoa_id
    GROUP BY p.id, p.nome, p.tipo, e.id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_post_autor()
RETURNS TABLE (nome CHARACTER VARYING(100),
               autor TEXT)
AS 
$$
DECLARE
    quantidade INTEGER;
BEGIN
    RETURN QUERY
    SELECT
        pt.titulo, STRING_AGG(p.nome, ', ')
    FROM pessoa p
    INNER JOIN pessoa_post pp ON p.id = pp.pessoa_id
    INNER JOIN post pt ON pp.post_id = pt.id
    WHERE p.tipo = 'A' GROUP BY  pt.titulo;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION autenticar_pessoa(
    p_email CHARACTER VARYING(100),
    p_senha CHARACTER VARYING(32)
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_tipo CHARACTER(1);
    id_pessoa INTEGER;
BEGIN
    SELECT id, tipo INTO id_pessoa, v_tipo FROM pessoa WHERE email = p_email AND senha = MD5(p_senha);
    IF FOUND THEN 
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;


CREATE TABLE pessoa (
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(100) NOT NULL,
    senha CHARACTER VARYING(100) NOT NULL,
    tipo CHARACTER(1) CHECK (tipo = 'L' OR tipo = 'A'),
    email CHARACTER VARYING(100) UNIQUE
);

CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    bairro CHARACTER VARYING(100),
    rua CHARACTER VARYING(100),
    nro CHARACTER VARYING(5),
    cep CHARACTER VARYING(10),
    pessoa_id INTEGER REFERENCES pessoa(id) CHECK (ehLeitor(pessoa_id) IS TRUE)
);

CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    titulo CHARACTER VARYING(100) NOT NULL,
    texto TEXT,
    compartilhado BOOLEAN DEFAULT FALSE
);


CREATE TABLE pessoa_post (
    pessoa_id INTEGER REFERENCES pessoa(id) CHECK (ehAutor(pessoa_id) IS TRUE),
    post_id INTEGER REFERENCES post(id) CHECK (verificaPost(post_id) IS TRUE),
    PRIMARY KEY (pessoa_id, post_id)
);

INSERT INTO pessoa (nome, senha, tipo, email) VALUES
        ('Ana Flavia',MD5('123456'),'L','ana@email.com'),
        ('Igor',MD5('456789'),'L','igor@email.com'),
        ('Machado de Assis',MD5('capitu123'),'A','machadinho_assis@email.com'),
        ('Agatha Christie', MD5('misterio456'),'A', 'agatha@email.com'),
        ('Léo Dias', MD5('fofoqueiro'),'A','leodias@email.com'),
        ('Márcio',MD5('amoPOO'),'L','marcio.torres@email.com');

INSERT INTO endereco (bairro, rua, nro, cep, pessoa_id) VALUES
        ('Parque Marinha', 'Av. Grandes Lagos', '113','96215010',1),
        ('Cidade Nova', 'Buarque de Macedo', '75','96212080',2);
        -- Autores não podem ter o endereço cadastrado!
        -- ('Tijuca', 'Av. Brasil', '25','9620010',3),
        -- ('ABC', 'Av. Paulista', '456','9524070',4);

INSERT INTO post (titulo, texto, compartilhado) VALUES
    ('Capitu traiu bentinho?', 'Capitu e Bentinho são dois personagens do romance de Machado de Assis, Dom Casmurro, publicado em 1899. \n 
    Essa obra é um marco do realismo no Brasil e levanta a polêmica da traição de Capitu com o melhor amigo de Bentinho: Escobar.', TRUE),
    ('Pedro Rubião: interesseiro ou companheiro?', 'Com a morte dele, Pedro Rubião de Alvarenga, discípulo do filósofo e seu enfermeiro particular, 
    é agraciado com uma grande herança. Além disso, Rubião fica encarregado de cuidar do cão de seu amigo, que também se chamava Quincas Borba.', TRUE);

INSERT INTO post (titulo, texto) VALUES
    ('Homens e multiverso dos traidores', 'Luiza Sonza, Bruna Biancardi e Bella Campos foram os últimos alvos dos chifres dos seus pares romanticos');

INSERT INTO pessoa_post (pessoa_id, post_id) VALUES (3, 1);
INSERT INTO pessoa_post (pessoa_id, post_id) VALUES (4, 1);
-- Não será adicionado, pois a chave primária é composta e será a mesma!
INSERT INTO pessoa_post (pessoa_id, post_id) VALUES (4, 1);  
INSERT INTO pessoa_post (pessoa_id, post_id) VALUES (4, 2);
-- VerificaPost permite apenas que post compartilhados sejam adicionados no pessoas_post
INSERT INTO pessoa_post (pessoa_id, post_id) VALUES (5, 3);
-- O post 3 não é compartilhado, logo, o autor 3 não pode editá-lo
INSERT INTO pessoa_post (pessoa_id, post_id) VALUES (3,3); 


--3) Um Stored Procedured que mostre as informações de todos as pessoas (leitores e autores) (1,0)
SELECT * FROM listar_pessoas();

-- 5) Um Stored Procedured que mostre a quantidade de autores envolvidos 
--na escrita de cada Post (0,5)
SELECT * FROM quantidadeAutoresPost(1);
SELECT * FROM quantidadeAutoresPost(3);


-- 6) Um Stored Procedured que mostre o título de cada Post
-- e o nome de cada autor envolvido em sua escrita (0,5)
SELECT * FROM listar_post_autor();


-- 7) Um Stored Procedured que autentique (login) Pessoas (Leitores e Autores) (0,5)
-- Login válido
SELECT autenticar_pessoa('ana@email.com','123456');
-- Login Inválido
SELECT autenticar_pessoa('ana@email.com','1256523');


-- psql -h localhost -U postgres



