DROP DATABASE IF EXISTS amigo;

CREATE DATABASE amigo;

\c amigo;

CREATE TABLE evento (
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(200) NOT NULL,
    dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE participante (
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(200) NOT NULL,
    dataNascimento DATE NOT NULL,
    sorteado BOOLEAN DEFAULT FALSE,
    amigoSecreto INTEGER REFERENCES participante (id),
    eventoId INTEGER REFERENCES evento (id)
);

CREATE TABLE lista_desejo (
    id SERIAL PRIMARY KEY,
    descricao CHARACTER VARYING(200) NOT NULL,
    participante INTEGER REFERENCES participante (id)
);

INSERT INTO evento (nome) VALUES ('Amigo Secreto do IF'), ('Amigo Secreto da Família Godoi');

INSERT INTO participante (nome, dataNascimento, eventoId) VALUES 
                         ('Ana Flavia','1999-07-02',1),
                         ('Igor','1991-05-21',1),
                         ('Josué','1998-03-15',1),
                         ('Manuela', '2002-07-26',1),
                         ('Heitor','1998-03-11',2),
                         ('Thiago','1998-03-27',2);

UPDATE participante SET amigoSecreto = 2 WHERE id = 1;
INSERT INTO participante (nome, dataNascimento, eventoId) VALUES 
                         ('Heitor','1998-03-11',2),
                         ('Thiago','1998-03-27',2);



INSERT INTO lista_desejo (descricao, participante) VALUES 
                         ('Iphone X', 1),
                         ('Playstation 5',2),
                         ('Monitor Gamer', 3),
                         ('Notebook',4),
                         ('GTA VI',5),
                         ('Carro', 6);


-- Verifica se é menor de idade

CREATE OR REPLACE FUNCTION verificar_idade()
RETURNS TRIGGER AS $$
DECLARE
    idade INTEGER;
BEGIN
    SELECT EXTRACT(YEAR FROM NEW.dataNascimento) INTO idade FROM participante;
    idade :=  EXTRACT(YEAR FROM CURRENT_DATE) - idade;
    RAISE NOTICE 'Idade: %', idade;
    IF idade  >= 18 THEN
        RETURN NEW;
    ELSE
        RAISE NOTICE 'Participante menor de idade!';
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_idade
BEFORE INSERT ON participante
FOR EACH ROW
EXECUTE FUNCTION verificar_idade();

INSERT INTO participante (nome, dataNascimento, eventoId) VALUES ('Criança','2019-07-02',1);

-- Adiciona Meia na lista de presente de um novo participante

CREATE OR REPLACE FUNCTION adicionarPresente()
RETURNS TRIGGER AS $$
DECLARE

BEGIN
    INSERT INTO lista_desejo (descricao, participante) VALUES ('Meias',NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_adicinarPresente
AFTER INSERT ON participante
FOR EACH ROW
EXECUTE FUNCTION adicionarPresente();

INSERT INTO participante (nome, dataNascimento, eventoId) VALUES ('Márcio','2000-07-02',1);

--Listar todos os participantes com amigos
CREATE OR REPLACE FUNCTION listar_participantes(idEvento INTEGER)
RETURNS TABLE (nomeParticipante CHARACTER VARYING(200), 
               nomeAmigoSecreto CHARACTER VARYING(200))
AS 
$$
BEGIN
    RETURN QUERY
    SELECT p.nome, participante.nome FROM participante AS p 
        INNER JOIN participante ON p.amigoSecreto = participante.id
        WHERE p.eventoId = idEvento;
END;
$$ LANGUAGE plpgsql;

-- Não fiz o sortear :(


