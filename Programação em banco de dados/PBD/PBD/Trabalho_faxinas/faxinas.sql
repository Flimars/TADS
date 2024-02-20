DROP DATABASE IF EXISTS faxinas;

CREATE DATABASE faxinas;

\c faxinas;

CREATE TABLE diarista (
    id SERIAL PRIMARY KEY,
    cpf CHARACTER(11) UNIQUE NOT NULL,
    nome CHARACTER VARYING(200) NOT NULL
);

CREATE TABLE responsavel (
    id SERIAL PRIMARY KEY,
    cpf CHARACTER(11) UNIQUE NOT NULL,
    nome CHARACTER VARYING(200) NOT NULL  
);

CREATE TABLE tamanho_residencia (
    id SERIAL PRIMARY KEY,
    tamanho CHARACTER(1) CHECK (tamanho = 'P' OR tamanho = 'M' OR tamanho = 'G') NOT NULL,
    valor_tamanho MONEY NOT NULL
);

CREATE TABLE residencia (
    id SERIAL PRIMARY KEY,
    cidade CHARACTER VARYING(100) NOT NULL,
    bairro CHARACTER VARYING(100) NOT NULL,
    rua CHARACTER VARYING(150) NOT NULL,
    complemento CHARACTER VARYING(100),
    numero CHARACTER VARYING(5) NOT NULL,
    tamanho INTEGER REFERENCES tamanho_residencia(id) NOT NULL,
    responsavel INTEGER REFERENCES responsavel(id) NOT NULL
);

CREATE TABLE limpeza (
    id SERIAL PRIMARY KEY,
    diarista INTEGER REFERENCES diarista(id) ON DELETE CASCADE NOT NULL,
    residencia INTEGER REFERENCES residencia(id) NOT NULL,
    data_agendamento DATE NOT NULL,
    realizada BOOLEAN NOT NULL,
    valor_pago MONEY,
    comentarios TEXT
);

INSERT INTO diarista (cpf, nome) VALUES 
                     ('11122233375', 'Maria Silva'),
                     ('77799988850', 'Brenda Cruz'),
                     ('66644433322', 'Renata Oliveira'),
                     ('33368744426', 'Francisca Souza');

INSERT INTO responsavel (cpf, nome) VALUES 
                        ('00033355599', 'Ana Flavia'),
                        ('44411177766', 'Igor Avila'),
                        ('55511133378', 'Marcio Torres');

INSERT INTO tamanho_residencia (tamanho, valor_tamanho) VALUES
                                ('P', 150.00),
                                ('M', 250.00),
                                ('G', 400.00);

INSERT INTO residencia (cidade, bairro, rua, numero ,tamanho, responsavel) VALUES
                       ('Rio Grande', 'Centro', 'Rua Eng. Alfredo Huck', '475', 3, 2),
                       ('Rio Grande', 'COAHB', 'Rua Dom Bosco', '1037', 1, 1),
                       ('Rio Grande', 'Cassino', 'Avenida Rio Grande', '100', 2, 2),
                       ('Rio Grande', 'Cidade Nova', 'Rua Visconde do Rio Branco', '50', 2, 2);

INSERT INTO limpeza (diarista, residencia, data_agendamento, realizada, valor_pago) VALUES
                    (1, 1, '2023-09-01', TRUE, 400.00),
                    (1, 1, '2023-09-10', TRUE, 400.00),
                    (1, 1, '2023-09-20', TRUE, 400.00),
                    (1, 2, '2023-09-20', TRUE, 150.00),
                    (1, 1, '2023-10-01', TRUE, 500.00),
                    (1, 1, '2023-10-10', TRUE, 500.00),
                    (1, 1, '2023-10-20', TRUE, 500.00),
                    (1, 1, '2023-11-01', TRUE, 500.00),
                    (1, 1, '2023-11-10', TRUE, 500.00),
                    (1, 1, '2023-11-24', TRUE, 500.00),
                    (2, 2, '2023-09-01', TRUE, 150.00),
                    (2, 2, '2023-09-10', TRUE, 150.00),
                    (2, 2, '2023-09-20', TRUE, 150.00),
                    (2, 2, '2023-10-01', TRUE, 150.00),
                    (2, 2, '2023-10-10', TRUE, 150.00),
                    (2, 2, '2023-10-20', TRUE, 150.00),
                    (2, 2, '2023-11-01', TRUE, 150.00),
                    (2, 2, '2023-11-10', TRUE, 150.00),
                    (2, 2, '2023-11-15', TRUE, 150.00),
                    (2, 2, '2023-11-24', TRUE, 150.00),
                    (3, 3, '2023-11-01', TRUE, 300.00),
                    (3, 3, '2023-11-10', TRUE, 300.00),
                    (3, 3, '2023-11-15', FALSE, 300.00),
                    (3, 3, '2023-11-20', FALSE, 300.00),
                    (3, 3, '2023-11-24', FALSE, 300.00),
                    (3, 3, '2023-11-26', FALSE, 300.00),
                    (4, 4, '2023-11-01', TRUE, 220.00),
                    (4, 4, '2023-11-10', TRUE, 220.00);

CREATE OR REPLACE FUNCTION agendar_faxinas(
    diarista_id INTEGER,
    residencia_id INTEGER,
    frequencia CHARACTER(1), -- 'Q' para quinzenal, 'M' para mensal
    limite DATE DEFAULT NULL, -- Data limite para agendamento
    quantidade_maxima INTEGER DEFAULT NULL -- Quantidade máxima de agendamentos
)
RETURNS BOOLEAN AS
$$
DECLARE
    data_agendamento DATE;
    contador INTEGER := 0;
BEGIN
    IF frequencia = 'Q' THEN
        data_agendamento := CURRENT_DATE + INTERVAL '14 days';
    ELSIF frequencia = 'M' THEN
        data_agendamento := CURRENT_DATE + INTERVAL '1 month';
    ELSE
        RAISE EXCEPTION 'Frequência inválida. Utilize ''Q'' para quinzenal ou ''M'' para mensal.';
        RETURN FALSE;
    END IF;

    WHILE (limite IS NULL OR data_agendamento <= limite) AND (quantidade_maxima IS NULL OR contador < quantidade_maxima) LOOP
        INSERT INTO limpeza (diarista, residencia, data_agendamento, realizada)
        VALUES (diarista_id, residencia_id, data_agendamento, FALSE);

        IF frequencia = 'Q' THEN
            data_agendamento := data_agendamento + INTERVAL '14 days';
        ELSIF frequencia = 'M' THEN
            data_agendamento := data_agendamento + INTERVAL '1 month';
        END IF;

        contador := contador + 1;
    END LOOP;
    RETURN TRUE;
END;

$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION calcular_presenca(id_diarista INTEGER) RETURNS DECIMAL AS $$
DECLARE
    total_faxinas INTEGER;
    presencas INTEGER;
    porcentagem DECIMAL;
BEGIN
    -- Contar o total de faxinas agendadas para a diarista
    SELECT COUNT(*) INTO total_faxinas
    FROM limpeza WHERE diarista =  id_diarista;

    -- Contar o total de faxinas realizadas pela diarista
    SELECT COUNT(*) INTO presencas
    FROM limpeza
    WHERE diarista = id_diarista AND realizada = TRUE;

    -- Calcular a porcentagem de presenças
    IF total_faxinas > 0 THEN
        porcentagem := (presencas * 100.0) / total_faxinas;
    ELSE
        porcentagem := 0;
    END IF;


    RETURN porcentagem;
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION verificar_presencas()
RETURNS TRIGGER AS $$
DECLARE
    total_faxinas INTEGER;
    percentual_presencas NUMERIC;
BEGIN
    -- Obtém o total de faxinas cadastradas para a diarista
    SELECT COUNT(*) INTO total_faxinas
    FROM limpeza
    WHERE NEW.diarista = limpeza.diarista;
    IF total_faxinas >= 5 THEN
        SELECT calcular_presenca(NEW.diarista) INTO percentual_presencas;
        -- Exclui a diarista se o percentual de presenças for menor que 75%
        IF percentual_presencas < 75 THEN
            DELETE FROM diarista WHERE diarista.id = NEW.diarista;
            RAISE NOTICE 'Apagando diarista pois sua presenca eh de apenas %', percentual_presencas;
            RETURN OLD;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_verificar_presencas
BEFORE INSERT ON limpeza
FOR EACH ROW
EXECUTE FUNCTION verificar_presencas();

-- Para agendar quinzenalmente até uma data limite
SELECT agendar_faxinas(1, 1, 'Q', '2023-12-31');

-- Agendando mensalmente com uma quantidade máxima
SELECT agendar_faxinas(2, 3, 'M', NULL, 3);

SELECT calcular_presenca(2);

-- Diarista 3 tem menos de 75% e mais de 5 diarias
INSERT INTO limpeza (diarista, residencia, data_agendamento, realizada) VALUES (3,1,'2023-12-02', FALSE);
SELECT * FROM diarista;



