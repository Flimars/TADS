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
    cidade CHARACTER VARYING(60) NOT NULL,
    bairro CHARACTER VARYING(60) NOT NULL,
    rua CHARACTER VARYING(100) NOT NULL,
    complemento CHARACTER VARYING(60),
    numero CHARACTER VARYING(10) NOT NULL,
    tamanho VARCHAR(10) CHECK (tamanho IN ('pequena', 'media', 'grande')) NOT NULL,
    responsavel_id INTEGER REFERENCES responsavel(id)
);

-- Faxina
CREATE TABLE faxina (
    id SERIAL PRIMARY KEY,    
    data_faxina DATE NOT NULL,
    realizada BOOLEAN NOT NULL DEFAULT FALSE,
    valor_definido DECIMAL(10, 2) NOT NULL,
    valor_pago DECIMAL(10, 2),
    feedback TEXT,
    diarista_id INTEGER REFERENCES diarista(id),
    residencia_id INTEGER REFERENCES residencia(id),
    UNIQUE (diarista_id, data_faxina)
);

-- Agendamento
CREATE TABLE Agendamento (
    id SERIAL PRIMARY KEY,
    diarista_id INTEGER REFERENCES diarista(id),
    residencia_id INTEGER REFERENCES residencia(id),
    data_agendamento DATE NOT NULL
);

--==============================================================
-- Inserts
--==============================================================
-- Inserts na Tabela Diarista
INSERT INTO diarista (cpf, nome) VALUES
('12345678901', 'Maria Silva'),
('23456789012', 'João Souza'),
('34567890123', 'Ana Lima'),
('45678901234', 'Carlos Oliveira'),
('56789012345', 'Lucia Mendes'),
('67890123456', 'Pedro Santos'),
('78901234567', 'Juliana Costa'),
('89012345678', 'Roberto Ferreira'),
('90123456789', 'Paula Almeida'),
('01234567890', 'Fernando Nunes');

-- Inserts na Tabela Responsável
INSERT INTO responsavel (cpf, nome) VALUES
('98765432101', 'Lucas Martins'),
('87654321012', 'Mariana Souza'),
('76543210123', 'Felipe Dias'),
('65432101234', 'Larissa Gomes'),
('54321012345', 'Ricardo Pereira'),
('43210123456', 'Beatriz Oliveira'),
('32101234567', 'Thiago Santos'),
('21012345678', 'Camila Fernandes'),
('10987654321', 'Gustavo Lima'),
('01987654321', 'Aline Ramos');

-- Inserts na Tabela Residência
INSERT INTO residencia (cidade, bairro, rua, complemento, numero, tamanho, responsavel_id) VALUES
('São Paulo', 'Centro', 'Rua 1', 'Apto 101', '100', 'pequena', 1),
('São Paulo', 'Jardins', 'Rua 2', 'Casa 2', '200', 'media', 2),
('São Paulo', 'Morumbi', 'Rua 3', '', '300', 'grande', 3),
('São Paulo', 'Pinheiros', 'Rua 4', 'Apto 402', '400', 'pequena', 4),
('São Paulo', 'Vila Madalena', 'Rua 5', '', '500', 'media', 5),
('São Paulo', 'Moema', 'Rua 6', 'Apto 606', '600', 'grande', 6),
('São Paulo', 'Liberdade', 'Rua 7', '', '700', 'pequena', 7),
('São Paulo', 'Butantã', 'Rua 8', 'Casa 8', '800', 'media', 8),
('São Paulo', 'Brooklin', 'Rua 9', '', '900', 'grande', 9),
('São Paulo', 'Santana', 'Rua 10', 'Apto 1001', '1000', 'pequena', 10);

-- Inserts na Tabela Faxina
INSERT INTO faxina (data_faxina, realizada, valor_definido, valor_pago, feedback, diarista_id, residencia_id) VALUES ('2024-01-05', TRUE, 130.00, 130.00, 'Otimo serviço', 1, 1),
('2024-01-10', TRUE, 180.00, 190.00, 'Deixou a casa impecavel', 2, 2),
('2024-01-15', FALSE, 230.00, 0.00, 'Diarista nao compareceu', 3, 3),
('2024-01-20', TRUE, 130.00, 120.00, 'Quebrou um vaso', 4, 4),
('2024-01-25', TRUE, 180.00, 180.00, 'Muito satisfeita', 5, 5),
('2024-02-01', TRUE, 230.00, 250.00, 'Recebeu uma gorjeta', 6, 6),
('2024-02-07', TRUE, 130.00, 130.00, 'Muito bom', 7, 7),
('2024-02-12', TRUE, 180.00, 170.00, 'Esqueceu de limpar a varanda', 8, 8),
('2024-02-17', FALSE, 230.00, 0.00, 'Nao apareceu', 9, 9),
('2024-02-22', TRUE, 130.00, 140.00, 'Muito cuidadosa', 10, 10);

-- Inserts na Tabela Agendamento
INSERT INTO agendamento (diarista_id, residencia_id, data_agendamento) VALUES 
(1, 1, '2024-01-01'),
(2, 2, '2024-01-08'),
(3, 3, '2024-01-15'),
(4, 4, '2024-01-22'),
(5, 5, '2024-01-29'),
(6, 6, '2024-02-05'),
(7, 7, '2024-02-12'),
(8, 8, '2024-02-19'),
(9, 9, '2024-02-26'),
(10, 10, '2024-03-04');

--==============================================================
-- Queries
--==============================================================

-- 1. Stored Procedure para Agendamento de Faxinas
CREATE OR REPLACE PROCEDURE agendar_faxinas(
    diarista INTEGER,
    residencia INTEGER,
    tipo_agendamento VARCHAR,
    data_limite DATE DEFAULT NULL,
    qtd_maxima INTEGER DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    data DATE := CURRENT_DATE;
    intervalo INTERVAL;
    contador INTEGER := 0;
BEGIN
    IF tipo_agendamento = 'quinzenal' THEN
        intervalo := '14 days';
    ELSIF tipo_agendamento = 'mensal' THEN
        intervalo := '1 month';
    ELSE
        RAISE EXCEPTION 'Tipo de agendamento inválido';
    END IF;

    WHILE (data_limite IS NULL OR data <= data_limite) AND (qtd_maxima IS NULL OR contador < qtd_maxima) LOOP
        INSERT INTO Agendamento (diarista_id, residencia_id, data_agendamento) VALUES (diarista, residencia, data);
        data := data + intervalo;
        contador := contador + 1;
    END LOOP;
END;
$$;

--==============================================================

-- Stored Procedure para Calcular Porcentagem de Presenças
CREATE OR REPLACE PROCEDURE calcular_presenca_anual(
    diarista INTEGER,
    ano INTEGER,
    OUT presenca_percentual NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    total_faxinas INTEGER;
    faxinas_realizadas INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_faxinas FROM Faxina WHERE diarista_id = diarista AND EXTRACT(YEAR FROM data) = ano;
    SELECT COUNT(*) INTO faxinas_realizadas FROM Faxina WHERE diarista_id = diarista AND EXTRACT(YEAR FROM data) = ano AND realizada = TRUE;

    IF total_faxinas = 0 THEN
        presenca_percentual := 0;
    ELSE
        presenca_percentual := (faxinas_realizadas::NUMERIC / total_faxinas::NUMERIC) * 100;
    END IF;
END;
$$;

--==============================================================

-- Trigger para Excluir Diarista com Presença Inferior a 75%
CREATE OR REPLACE FUNCTION verificar_presenca_diarista()
RETURNS TRIGGER AS $$
DECLARE
    presenca_percentual NUMERIC;
BEGIN
    IF (SELECT COUNT(*) FROM Faxina WHERE diarista_id = NEW.id) >= 5 THEN
        PERFORM calcular_presenca_anual(NEW.id, EXTRACT(YEAR FROM CURRENT_DATE), presenca_percentual);
        IF presenca_percentual < 75 THEN
            DELETE FROM Diarista WHERE id = NEW.id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_excluir_diarista
AFTER INSERT OR UPDATE ON Faxina
FOR EACH ROW
EXECUTE FUNCTION verificar_presenca_diarista();

--==============================================================
-- Chamadas das Stored Procedures
agendar_faxinas (1, 1, 'quinzenal', '2024-12-31', NULL);
calcular_presenca_anual (1, 1, 'mensal', NULL, 30);
verificar_presenca_diarista ();
