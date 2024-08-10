/*
    Construa um Banco de Dados (B.D.)de gerenciamento de faxinas para diaristas:

    O banco de dados deve controlar o histórico de faxinas realizados por cada diarista em cada residência.

    Cada Diarista possui um identificador (id), cpf e nome;

    Cada Residência possui um responsável. Para o responsável é importante armazenar seu nome e seu cpf;

    Além do responsável, cada Residência possui um identificador (id), cidade, bairro, rua, complemento e número e Tamanho (pequena, média ou grande);

    Um Responsável pode ser responsável por mais de uma Residência mas uma Residência tem somente um Responsável;
    Dependendo do Tamanho da Residência, a Faxina tem um preço;

    Uma Diarista realiza uma Faxina por dia, ou seja, atende uma Residência por dia;

    Uma Diarista pode atender várias residências, e uma residência pode ser atendida por várias Diaristas;
    Faxinas podem ser agendadas (por data);

    É importante saber se a Diarista não foi, ou seja, faltou a uma Faxina, previamente, agendada;

    Faxinas agendadas e não-realizadas não devem ser pagas, independente do motivo;

    É importante armazenar feedbacks de avaliação por cada Faxina realizada. Estes comentários devem ser realizados pelo Responsável da Residência no momento da conclusão da Faxina;

    O valor final pago pela Faxina deve ser também armazenado pois o valor pode ser: maior devido à gorjetas, menor devido à algum dano/prejuízo causado pela diarista ou igual ao valor definido para residências de mesmo Tamanho. Lembrando que, ao longo do tempo, o valor da Faxina atribuído pelo Tamanho da Residência pode também mudar. Logo, é importante armazenar também este valor que foi realmente pago por cada Faxina a fim de saber, especificamente, o que cada Diarista recebeu pelas Faxinas que fez ao longo do tempo.

    Exigências:
    Crie o Modelo Relacional

    Implemente no PostgreSQL o Banco de Dados projetado no Modelo Relacional (construa um script.sql)

    1. Crie um STORE PROCEDURE que permita agendar quinzenalmente ou mensalmente faxinas em uma determinada residência:

    2. A diarista e a residência devem ser considerados parâmetros de entrada. Por outro lado, pode-se realizar o stored procedure de 2 formas: 
    Opções:
     1) Utilizar uma data limite (ex: até 31/12 do ano atual). 
     2) Utilizar uma quantidade máxima de agendamentos (ex: marcar 30 faxinas mensalmente).

    3. Crie um STORE PROCEDURE que calcule a porcentagem de presenças que uma diarista obteve em suas faxinas ao longo do ano:
    Ex: 75% de presença

    4. Crie uma TRIGGER que exclua a diarista caso suas presenças fiquem menores que 75% (quando a diarista já tem no mínimo 5 faxinas cadastradas).

*/

--==============================================================
-- Script
--==============================================================

DROP DATABASE IF EXISTS faxina;

CREATE DATABASE faxina;

\c faxina;

-- Diarista
CREATE TABLE diarista (
    id SERIAL PRIMARY KEY,
    cpf CHARACTER(11) UNIQUE NOT NULL,
    nome CHARACTER VARYING(100) NOT NULL
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
    data_fim DATE
    CONSTRAINT check_tamanho_preco_faxina CHECK (tamanho IN ('pequena', 'media', 'grande'))
);

-- Faxina
CREATE TABLE faxina (
    id SERIAL PRIMARY KEY,
    diarista_id INTEGER REFERENCES diarista(id),
    residencia_id INTEGER REFERENCES residencia(id),
    data_faxina DATE NOT NULL,
    realizada BOOLEAN NOT NULL DEFAULT FALSE,
    valor_pago MONEY,
    feedback TEXT,
    UNIQUE (diarista_id, data_faxina)
);

--==============================================================
-- Inserts
--==============================================================
-- Inserts para a tabela diarista
INSERT INTO diarista (cpf, nome) VALUES
('12345678901', 'Maria Silva'),
('23456789012', 'João Santos'),
('34567890123', 'Ana Oliveira'),
('45678901234', 'Carlos Ferreira'),
('56789012345', 'Juliana Costa'),
('67890123456', 'Pedro Almeida'),
('78901234567', 'Fernanda Lima'),
('89012345678', 'Ricardo Souza'),
('90123456789', 'Camila Rodrigues'),
('01234567890', 'Marcelo Pereira');

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
INSERT INTO faxina (diarista_id, residencia_id, data_faxina, realizada, valor_pago, feedback) VALUES
(1, 1, '2024-01-15', TRUE, 130.00, 'Ótimo trabalho, muito atenciosa'),
(2, 2, '2024-02-10', TRUE, 180.00, 'Faxina bem feita, pontual'),
(3, 3, '2024-03-05', TRUE, 230.00, 'Excelente serviço, superou expectativas'),
(4, 4, '2024-04-20', TRUE, 130.00, 'Bom trabalho, mas pode melhorar em alguns detalhes'),
(5, 5, '2024-05-12', TRUE, 180.00, 'Muito satisfeito com o resultado'),
(6, 6, '2024-06-30', FALSE, NULL, NULL),
(7, 7, '2024-07-18', TRUE, 130.00, 'Ótima diarista, muito cuidadosa'),
(8, 8, '2024-08-22', TRUE, 180.00, 'Faxina impecável, recomendo'),
(9, 9, '2024-09-14', TRUE, 230.00, 'Serviço de alta qualidade'),
(10, 10, '2024-10-05', TRUE, 130.00, 'Muito boa, mas chegou um pouco atrasada');

-- Mais 10 inserts para a tabela faxina para completar os 20 solicitados
INSERT INTO faxina (diarista_id, residencia_id, data_faxina, realizada, valor_pago, feedback) VALUES
(1, 2, '2024-11-11', TRUE, 180.00, 'Ótimo trabalho novamente'),
(2, 3, '2024-12-03', TRUE, 230.00, 'Muito profissional e eficiente'),
(3, 4, '2024-01-25', TRUE, 130.00, 'Faxina rápida e bem feita'),
(4, 5, '2024-02-28', TRUE, 180.00, 'Atenção aos detalhes impressionante'),
(5, 6, '2024-03-17', TRUE, 230.00, 'Superou minhas expectativas'),
(6, 7, '2024-04-09', FALSE, NULL, NULL),
(7, 8, '2024-05-21', TRUE, 180.00, 'Excelente como sempre'),
(8, 9, '2024-06-14', TRUE, 230.00, 'Muito satisfeito com o serviço'),
(9, 10, '2024-07-30', TRUE, 130.00, 'Ótimo trabalho, voltarei a contratar'),
(10, 1, '2024-08-08', TRUE, 130.00, 'Pontual e eficiente');

--==============================================================
-- Queries
--==============================================================
-- 1. Procedura para agendar faxinas
CREATE OR REPLACE PROCEDURE agendar_faxinas(
    p_diarista_id INTEGER,
    p_residencia_id INTEGER,
    p_data_inicio DATE,
    p_tipo_agendamento TEXT,
    p_limite TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_data_agendamento DATE := p_data_inicio;
    v_contador INTEGER := 0;
    v_data_limite DATE;
    v_quantidade_limite INTEGER;
BEGIN
    IF p_tipo_agendamento NOT IN ('quinzenal', 'mensal') THEN
        RAISE EXCEPTION 'Tipo de agendamento inválido. Use "quinzenal" ou "mensal".';
    END IF;

    IF p_limite ~ '^\d{4}-\d{2}-\d{2}$' THEN
        v_data_limite := p_limite::DATE;
    ELSIF p_limite ~ '^\d+$' THEN
        v_quantidade_limite := p_limite::INTEGER;
    ELSE
        RAISE EXCEPTION 'Formato de limite inválido. Use uma data (AAAA-MM-DD) ou um número inteiro.';
    END IF;

    WHILE (v_data_limite IS NULL OR v_data_agendamento <= v_data_limite)
          AND (v_quantidade_limite IS NULL OR v_contador < v_quantidade_limite)
    LOOP
        INSERT INTO faxina (diarista_id, residencia_id, data_faxina)
        VALUES (p_diarista_id, p_residencia_id, v_data_agendamento)
        ON CONFLICT (diarista_id, data_faxina) DO NOTHING;

        IF p_tipo_agendamento = 'quinzenal' THEN
            v_data_agendamento := v_data_agendamento + INTERVAL '14 days';
        ELSE
            v_data_agendamento := v_data_agendamento + INTERVAL '1 month';
        END IF;

        v_contador := v_contador + 1;
    END LOOP;
END;
$$;

--==============================================================
-- Procedure para calcular a porcentagem de presença
CREATE OR REPLACE FUNCTION calcular_porcentagem_presenca(
    p_diarista_id INTEGER,
    p_ano INTEGER
)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_faxinas INTEGER;
    v_faxinas_realizadas INTEGER;
    v_porcentagem DECIMAL;
BEGIN
    SELECT COUNT(*), COUNT(*) FILTER (WHERE realizada = TRUE)
    INTO v_total_faxinas, v_faxinas_realizadas
    FROM faxina
    WHERE diarista_id = p_diarista_id
    AND EXTRACT(YEAR FROM data_faxina) = p_ano;

    IF v_total_faxinas = 0 THEN
        RETURN 0;
    END IF;

    v_porcentagem := (v_faxinas_realizadas::DECIMAL / v_total_faxinas) * 100;
    RETURN ROUND(v_porcentagem, 2);
END;
$$;

--==============================================================
-- Gatilho para excluir diaristas com presença abaixo de 75%
CREATE OR REPLACE FUNCTION verificar_presenca_diarista()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_faxinas INTEGER;
    v_porcentagem_presenca DECIMAL;
BEGIN
    SELECT COUNT(*) INTO v_total_faxinas
    FROM faxina
    WHERE diarista_id = NEW.diarista_id;

    IF v_total_faxinas >= 5 THEN
        v_porcentagem_presenca := calcular_porcentagem_presenca(NEW.diarista_id, EXTRACT(YEAR FROM NEW.data_faxina)::INTEGER);

        IF v_porcentagem_presenca < 75 THEN
            DELETE FROM diarista WHERE id = NEW.diarista_id;
            RAISE NOTICE 'Diarista com ID % foi excluída devido à baixa presença (%.2f%%)', NEW.diarista_id, v_porcentagem_presenca;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_verificar_presenca_diarista
AFTER INSERT OR UPDATE ON faxina
FOR EACH ROW
EXECUTE FUNCTION verificar_presenca_diarista();

--==============================================================
-- Chamada das funções
-- Agendar faxinas
CALL agendar_faxinas(1, 1, '2023-06-01', 'quinzenal', '2023-12-31');
-- ou
CALL agendar_faxinas(1, 1, '2023-06-01', 'mensal', '10');
-- 

-- Calcular porcentagem de presença
-- SELECT calcular_porcentagem_presenca(1, 2023);