-- ==========================================================
-- SCRIPT:
-- ==========================================================

DROP DATABASE IF EXISTS natal;

CREATE DATABASE natal;

\c natal;

-- Criação da tabela evento_amigo_secreto
CREATE TABLE evento_amigo_secreto (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_hora_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela participante
CREATE TABLE participante (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    evento_id INTEGER NOT NULL,
    amigo_id INTEGER,
    FOREIGN KEY (evento_id) REFERENCES evento_amigo_secreto(id),
    FOREIGN KEY (amigo_id) REFERENCES participante(id)
);

-- Criação da tabela desejo
CREATE TABLE desejo (
    id SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    participante_id INTEGER NOT NULL,
    FOREIGN KEY (participante_id) REFERENCES participante(id)
);

-- ==========================================================
-- INSERTS:
-- ==========================================================
-- INSERTs para a tabela evento_amigo_secreto
INSERT INTO evento_amigo_secreto (nome) VALUES
('Amigo Secreto da Empresa X'),
('Amigo Secreto da Família Y');

-- INSERTs para a tabela participante
INSERT INTO participante (nome, data_nascimento, evento_id) VALUES
('Joao Silva', '1990-05-15', 1),
('Maria Santos', '1985-10-20', 1),
('Pedro Oliveira', '1988-03-25', 1),
('Ana Rodrigues', '1992-07-30', 1),
('Carlos Ferreira', '1987-12-10', 2),
('Lucia Pereira', '1995-09-05', 2),
('Roberto Alves', '1993-01-18', 2),
('Fernanda Lima', '1991-06-22', 2);

-- INSERTs para a tabela desejo
INSERT INTO desejo (descricao, participante_id) VALUES
('Livro de ficção cientifica', 1),
('Fone de ouvido bluetooth', 2),
('Smartwatch', 3),
('Kit de maquiagem', 4),
('Camiseta de time de futebol', 5),
('Jogo de tabuleiro', 6),
('Caneca personalizada', 7),
('Perfume importado', 8);

-- ==========================================================
-- QUERIES:
-- ==========================================================
-- 2. STORED PROCEDURE para sortear amigo secreto
CREATE OR REPLACE PROCEDURE sortear_amigo_secreto(participante_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    evento_id_var INT;
    amigo_id_var INT;
BEGIN
    -- Obter o evento_id do participante
    SELECT evento_id INTO evento_id_var FROM participante WHERE id = participante_id;

    -- Sortear um amigo aleatório que não seja o próprio participante e que não tenha sido sorteado ainda
    SELECT id INTO amigo_id_var
    FROM participante
    WHERE evento_id = evento_id_var
      AND id != participante_id
      AND id NOT IN (SELECT amigo_id FROM participante WHERE evento_id = evento_id_var AND amigo_id IS NOT NULL)
    ORDER BY RANDOM()
    LIMIT 1;

    -- Atualizar o amigo sorteado para o participante
    UPDATE participante SET amigo_id = amigo_id_var WHERE id = participante_id;
END;
$$;

-- 3. STORED PROCEDURE para listar participantes e seus amigos secretos
-- MODO 1:
-- CREATE OR REPLACE FUNCTION listar_participantes_e_amigos(evento_id_param INT)
-- RETURNS TABLE (participante VARCHAR, amigo_secreto VARCHAR)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT p.nome AS participante, a.nome AS amigo_secreto
--     FROM participante p
--     LEFT JOIN participante a ON p.amigo_id = a.id
--     WHERE p.evento_id = evento_id_param
--     ORDER BY p.nome;
-- END;
-- $$;

-- MODO 2:
CREATE OR REPLACE FUNCTION listar_participantes_e_amigos_secretos(evento_id_param INT)
RETURNS TABLE (
    participante VARCHAR,
    amigo_secreto VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.nome AS participante,
        COALESCE(a.nome, 'Não sorteado ainda') AS amigo_secreto
    FROM 
        participante p
    LEFT JOIN 
        participante a ON p.amigo_id = a.id
    WHERE 
        p.evento_id = evento_id_param
    ORDER BY 
        p.nome;
END;
$$;

-- 4. TRIGGER para adicionar "Meias" como item desejado para novos participantes
CREATE OR REPLACE FUNCTION adicionar_meias_desejo()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO desejo (descricao, participante_id)
    VALUES ('Meias', NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_adicionar_meias_desejo
AFTER INSERT ON participante
FOR EACH ROW
EXECUTE FUNCTION adicionar_meias_desejo();

-- 5. TRIGGER para verificar a idade do participante
CREATE OR REPLACE FUNCTION verificar_idade_participante()
RETURNS TRIGGER AS $$
BEGIN
    IF (EXTRACT(YEAR FROM AGE(NEW.data_nascimento)) < 18) THEN
        RAISE EXCEPTION 'Participante deve ter 18 anos ou mais.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_idade_participante
BEFORE INSERT ON participante
FOR EACH ROW
EXECUTE FUNCTION verificar_idade_participante();

-- ==========================================================
-- CHAMADAS e OPERAÇÕES DE ATIVAÇÃO DAS TRIGGERS:
-- ==========================================================
-- Sortear amigo secreto para o participante com ID 1
CALL sortear_amigo_secreto(1);
CALL sortear_amigo_secreto(2);
CALL sortear_amigo_secreto(3);
CALL sortear_amigo_secreto(4);
CALL sortear_amigo_secreto(5);
CALL sortear_amigo_secreto(6);
CALL sortear_amigo_secreto(7);
CALL sortear_amigo_secreto(8);

-- Listar participantes e amigos do evento com ID 1
-- CALL listar_participantes_e_amigos(1);
SELECT * FROM listar_participantes_e_amigos_secretos(1);
SELECT * FROM listar_participantes_e_amigos_secretos(2);
SELECT * FROM listar_participantes_e_amigos_secretos(3);
SELECT * FROM listar_participantes_e_amigos_secretos(4);
SELECT * FROM listar_participantes_e_amigos_secretos(5);
SELECT * FROM listar_participantes_e_amigos_secretos(6);
SELECT * FROM listar_participantes_e_amigos_secretos(7);
SELECT * FROM listar_participantes_e_amigos_secretos(8);

INSERT INTO participante (nome, data_nascimento, evento_id)
VALUES ('Mariana Costa', '1989-11-25', 1);

-- Para verificar se a trigger funcionou, podemos consultar a tabela de desejos:
SELECT * FROM desejo WHERE participante_id = (SELECT id FROM participante WHERE nome = 'Mariana Costa');

-- Esta inserção deve falhar devido à trigger
INSERT INTO participante (nome, data_nascimento, evento_id)
VALUES ('João Junior', '2010-05-15', 1);

-- Esta inserção deve ser bem-sucedida
INSERT INTO participante (nome, data_nascimento, evento_id)
VALUES ('Ana Beatriz', '2000-08-20', 1);

-- Teste para participante maior de idade (deve ser bem-sucedido)
INSERT INTO participante (nome, data_nascimento, evento_id)
VALUES ('Teste Maior', '2000-01-01', 1);

-- Teste para participante menor de idade (deve falhar)
INSERT INTO participante (nome, data_nascimento, evento_id)
VALUES ('Teste Menor', '2011-01-01', 1);

-- Verificar se 'Meias' foi adicionado para o participante maior de idade
SELECT * FROM desejo WHERE participante_id = (SELECT id FROM participante WHERE nome = 'Teste Maior');

-- Após chamar o procedimento para todos os participantes
SELECT nome, amigo_id FROM participante WHERE evento_id = 1;

