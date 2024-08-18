--===========================================================
-- Script Corrigido
--===========================================================

DROP DATABASE IF EXISTS faxina2;

CREATE DATABASE faxina2;

\c faxina2;

-- Diarista
CREATE TABLE diarista (
    id SERIAL PRIMARY KEY,
    cpf CHARACTER(11) UNIQUE NOT NULL,
    nome CHARACTER VARYING(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- Responsável
CREATE TABLE responsavel (
    id SERIAL PRIMARY KEY,
    cpf CHARACTER(11) UNIQUE NOT NULL,
    nome CHARACTER VARYING(100) NOT NULL
);

-- Residência
CREATE TABLE residencia (
    id SERIAL PRIMARY KEY,
    responsavel_id INTEGER REFERENCES responsavel(id),
    cidade CHARACTER VARYING(50) NOT NULL,
    bairro CHARACTER VARYING(50) NOT NULL,
    rua CHARACTER VARYING(100) NOT NULL,
    complemento CHARACTER VARYING(50),
    numero CHARACTER VARYING(5) NOT NULL,
    tamanho CHARACTER VARYING(7) NOT NULL,
    CONSTRAINT check_tamanho_residencia CHECK (tamanho IN ('pequena', 'media', 'grande'))
);

-- Preço_Faxina
CREATE TABLE preco_faxina (
    id SERIAL PRIMARY KEY,
    tamanho CHARACTER VARYING(7) NOT NULL,
    preco MONEY NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    CONSTRAINT check_tamanho_preco_faxina CHECK (tamanho IN ('pequena', 'media', 'grande'))
);

-- Faxina
CREATE TABLE faxina (
    id SERIAL PRIMARY KEY,
    diarista_id INTEGER REFERENCES diarista(id) ON DELETE CASCADE,
    residencia_id INTEGER REFERENCES residencia(id),
    data_faxina DATE NOT NULL,
    realizada BOOLEAN NOT NULL DEFAULT FALSE,
    valor_definido MONEY,
    valor_pago MONEY,
    feedback TEXT
);

--===========================================================
-- Inserts
--===========================================================
-- Inserts para a tabela diarista
INSERT INTO diarista (cpf, nome) VALUES
('12345678901', 'Maria Silva'),
('23456789012', 'Joana Santos'),
('11223344556', 'Patrícia Souza'),
('01234567890', 'Marcela Pereira');

-- Inserts para a tabela responsavel
INSERT INTO responsavel (cpf, nome) VALUES
('11111111111', 'Antônio Gomes'),
('22222222222', 'Beatriz Martins'),
('33333333333', 'Cláudio Nunes'),
('44444444444', 'Daniela Rocha'),
('55555555555', 'Eduardo Santos'),
('66666666666', 'Flávia Oliveira'),
('77777777777', 'Gustavo Lima'),
('88888888888', 'Helena Castro'),
('99999999999', 'Igor Ferreira'),
('00000000000', 'Júlia Carvalho');

-- Inserts para a tabela residencia
INSERT INTO residencia (responsavel_id, cidade, bairro, rua, complemento, numero, tamanho) VALUES
(1, 'São Paulo', 'Moema', 'Rua das Flores', 'Apto 101', '123', 'pequena'),
(2, 'Rio de Janeiro', 'Copacabana', 'Av. Atlântica', NULL, '456', 'media'),
(3, 'Belo Horizonte', 'Savassi', 'Rua Pium-í', 'Casa', '789', 'grande'),
(4, 'Curitiba', 'Batel', 'Rua Bispo Dom José', 'Sobrado', '321', 'pequena'),
(5, 'Porto Alegre', 'Moinhos de Vento', 'Rua Padre Chagas', NULL, '654', 'media'),
(6, 'Salvador', 'Barra', 'Av. Oceânica', 'Apto 202', '987', 'grande'),
(7, 'Recife', 'Boa Viagem', 'Av. Boa Viagem', NULL, '741', 'pequena'),
(8, 'Fortaleza', 'Meireles', 'Av. Beira Mar', 'Apto 303', '852', 'media'),
(9, 'Brasília', 'Asa Sul', 'SQS 308', 'Bloco A', '963', 'grande'),
(10, 'Manaus', 'Adrianópolis', 'Av. Darcy Vargas', 'Casa', '159', 'pequena');

-- Inserts para a tabela preco_faxina
INSERT INTO preco_faxina (tamanho, preco, data_inicio, data_fim) VALUES
('pequena', 130.00, '2024-01-01', NULL),
('media', 180.00, '2024-01-01', NULL),
('grande', 230.00, '2024-01-01', NULL);

-- Inserts para a tabela faxina
INSERT INTO faxina (diarista_id, residencia_id, data_faxina, realizada, valor_definido,  valor_pago, feedback) VALUES
(1, 1, '2024-01-15', TRUE, 130.00, 130.00, 'Ótimo trabalho, muito atenciosa'),
(2, 2, '2024-02-10', TRUE, 180.00, 190.00, 'Faxina bem feita, pontual'),
(3, 3, '2024-03-05', TRUE, 230.00, 230.00, 'Excelente serviço, superou expectativas'),
(4, 4, '2024-04-20', TRUE, 130.00, 130.00, 'Bom trabalho, mas pode melhorar em alguns detalhes'),
(1, 5, '2024-05-12', TRUE, 180.00, 180.00, 'Muito satisfeito com o resultado'),
(4, 6, '2024-06-30', FALSE, 230.00, NULL, 'Diarista não compareceu'),
(2, 7, '2024-07-18', TRUE, 130.00, 120.00,  'Quebrou um vaso desconto de R$10.00'),
(3, 8, '2024-08-22', TRUE, 180.00, 200.00, 'Faxina impecável, recomendo'),
(3, 9, '2024-09-14', TRUE, 230.00, 230.00, 'Serviço de alta qualidade'),
(2, 10, '2024-10-05', TRUE, 130.00, 130.00, 'Muito boa, mas chegou um pouco atrasada'),
(1, 2, '2024-11-11', TRUE, 180.00, 200.00, 'Ótimo trabalho novamente'),
(2, 3, '2024-12-03', TRUE, 230.00,230.00, 'Muito profissional e eficiente'),
(3, 4, '2024-01-25', TRUE, 130.00, 130.00, 'Faxina rápida e bem feita'),
(4, 5, '2024-02-28', TRUE, 180.00, 180.00, 'Atenção aos detalhes impressionante'),
(3, 6, '2024-03-17', TRUE, 230.00, 300.00, 'Superou minhas expectativas'),
(4, 7, '2024-04-09', FALSE, 180.00, NULL, 'Não apareceu'),
(1, 8, '2024-05-21', TRUE, 180.00, 180.00, 'Excelente como sempre'),
(2, 9, '2024-06-14', TRUE, 230.00, 230.00, 'Muito satisfeito com o serviço'),
(1, 10, '2024-07-30', TRUE, 130.00, 130.00,  'Ótimo trabalho, voltarei a contratar'),
(1, 1, '2024-08-08', TRUE, 130.00, 130.00, 'Pontual e eficiente');

--===========================================================
-- Queries
--===========================================================
CREATE OR REPLACE FUNCTION verificar_presenca_diarista()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_faxinas INTEGER;
    v_porcentagem_presenca DECIMAL;
BEGIN
    -- Calcula o total de faxinas realizadas pela diarista
    SELECT COUNT(*) INTO v_total_faxinas
    FROM Faxina
    WHERE diarista_id = NEW.diarista_id;

    -- Verifica se a diarista tem 5 ou mais faxinas realizadas
    IF v_total_faxinas >= 5 THEN
        -- Calcula a porcentagem de presença
        SELECT (100.0 * COUNT(*) / v_total_faxinas) INTO v_porcentagem_presenca
        FROM Faxina
        WHERE diarista_id = NEW.diarista_id AND realizada = TRUE;

        -- Verifica se a porcentagem de presença é menor que 70%
        IF v_porcentagem_presenca < 70 THEN
            UPDATE Diarista SET ativo = FALSE WHERE id = NEW.diarista_id;             
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_verificar_presenca_diarista
AFTER INSERT OR UPDATE ON Faxina
FOR EACH ROW EXECUTE FUNCTION verificar_presenca_diarista();

-- Definição da Procedure agendar_faxinas (certificando que os tipos são coerentes)
CREATE PROCEDURE agendar_faxinas(
    diarista_id INT,
    residencia_id INT,
    frequencia VARCHAR,
    data_limite DATE,
    total_faxinas INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    data DATE := CURRENT_DATE;
BEGIN
    FOR i IN 1..total_faxinas LOOP
        INSERT INTO faxina (diarista_id, residencia_id, data_faxina)
        VALUES (diarista_id, residencia_id, data);
        data := data + (CASE frequencia WHEN 'quinzenal' THEN 14 WHEN 'mensal' THEN 30 ELSE 1 END);
        IF data > data_limite THEN
            EXIT;
        END IF;
    END LOOP;
END;
$$;

-- Definição da Procedure calcular_presenca_anual (certificando que os tipos são coerentes)
CREATE PROCEDURE calcular_presenca_anual(
    diarista_id_param INT,
    ano INT,
    OUT presenca NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    total_faxinas INT;
    faxinas_realizadas INT;
BEGIN
    SELECT COUNT(*) INTO total_faxinas
    FROM faxina
    WHERE diarista_id = calcular_presenca_anual.diarista_id_param
    AND EXTRACT(YEAR FROM data_faxina) = ano;
    
    SELECT COUNT(*) INTO faxinas_realizadas
    FROM faxina
    WHERE diarista_id = calcular_presenca_anual.diarista_id_param
    AND realizada = TRUE
    AND EXTRACT(YEAR FROM data_faxina) = ano;
    
    presenca := faxinas_realizadas::NUMERIC / total_faxinas::NUMERIC * 100;
END;
$$;


--==============================================================
-- Chamadas das Stored Procedures
CALL agendar_faxinas(1, 1, 'mensal', '2024-12-31', 3);
-- CALL calcular_presenca_anual(2, 2024, presenca);

-- Para calcular_presenca_anual, vamos usar uma variável para capturar o resultado
DO $$
DECLARE
    presenca NUMERIC;
BEGIN
    CALL calcular_presenca_anual(2, 2024, presenca);
    RAISE NOTICE 'Presenca percentual: %', presenca;
END $$;

-- Não precisamos chamar verificar_presenca_diarista() diretamente,
-- pois é uma função trigger que será acionada automaticamente.

-- Para demonstrar o funcionamento do trigger, podemos inserir uma nova faxina:
INSERT INTO faxina (data_faxina, realizada, valor_definido, valor_pago, feedback, diarista_id, residencia_id) 
VALUES (CURRENT_DATE, TRUE, 180.00, 180.00, 'Bom serviço', 4, 1);