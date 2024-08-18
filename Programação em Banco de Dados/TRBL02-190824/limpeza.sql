DROP DATABASE IF EXISTS limpeza;

CREATE DATABASE limpeza;

\c limpeza;

CREATE TABLE responsavel (
    id serial primary key,
    nome character varying(50) not null,
    cpf character(11) unique
);

CREATE TABLE residencia (
    id serial primary key,
    responsavel_id integer REFERENCES responsavel(id),
    cidade character varying(100) not null,
    bairro character varying(100) not null,
    rua text not null,
    complemento text,
    numero character varying(10) not null,
    tamanho character(1) not null CHECK(tamanho IN ('P', 'M', 'G'))
);

CREATE TABLE diarista (
    id serial primary key,
    nome character varying(50) not null,
    cpf character(11) unique
);

CREATE TABLE servico (
    diarista_id integer REFERENCES diarista(id) ON DELETE CASCADE,
    residencia_id integer REFERENCES residencia(id),
    data_agendada date not null,
    valor_estipulado money CHECK(CAST(valor_estipulado AS NUMERIC(8,2)) > 0),
    valor_recebido money DEFAULT 0.0,
    realizado boolean DEFAULT false,
    observacao text,
    PRIMARY KEY(diarista_id, data_agendada)
);

INSERT INTO responsavel (nome, cpf) VALUES
('Ana', '33344455566'),
('João', '55566677788'),
('Carlos', '88899911122'),
('Julia', '22233344455');


INSERT INTO residencia (responsavel_id, cidade, bairro, rua, complemento, numero, tamanho) VALUES
(1, 'São Paulo', 'Vila Mariana', 'Rua Santa Cruz', 'Apt 12', '100', 'M'),
(2, 'Rio de Janeiro', 'Copacabana', 'Av Atlântica', null, '500', 'G'),
(3, 'Belo Horizonte', 'Savassi', 'Rua Pernambuco', 'Casa', '200', 'P'),
(4, 'Curitiba', 'Centro', 'Rua XV de Novembro', null, '150', 'M');


INSERT INTO diarista (nome, cpf) VALUES
('Fernando', '44455566677'),
('Mariana', '66677788899'),
('Rafael', '99911122233'),
('Bruna', '11122233344');


INSERT INTO servico (diarista_id, residencia_id, data_agendada, valor_estipulado, valor_recebido, realizado, observacao) VALUES
(1, 1, '2024-09-01', 180, 0, false, ''),
(2, 2, '2024-09-02', 400, 420, true, 'Muito bom trabalho'),
(3, 3, '2024-09-03', 120, 0, false, ''),
(4, 4, '2024-09-04', 220, 0, false, '');

-- Agendamento de Serviços Mensais
CREATE FUNCTION agendar_servicos_mensais(diaristaID integer, residenciaID integer, valorEstipulado numeric, numServicos integer) 
RETURNS TABLE(diarista integer, residencia integer, data_agendamento date, valor_servico money)
LANGUAGE plpgsql
AS $$
DECLARE 
    dataServico date := CURRENT_DATE + INTERVAL '1 MONTH';
    valorEstipuladoAux money;
    i integer;
BEGIN
    SELECT valorEstipulado::numeric::money INTO valorEstipuladoAux;
    i := 0;
    WHILE i < numServicos LOOP
        INSERT INTO servico (diarista_id, residencia_id, data_agendada, valor_estipulado) 
        VALUES (diaristaID, residenciaID, dataServico, valorEstipuladoAux);
        dataServico := dataServico + INTERVAL '1 MONTH';
        i := i + 1;
    END LOOP;
    RETURN QUERY SELECT diarista_id, residencia_id, data_agendada, valor_estipulado 
                 FROM servico WHERE diarista_id = diaristaID AND residencia_id = residenciaID;
END;
$$;

-- Agendamento de Serviços Quinzenais
CREATE FUNCTION agendar_servicos_quinzenais(diaristaID integer, residenciaID integer, valorEstipulado numeric, numServicos integer) 
RETURNS TABLE(diarista integer, residencia integer, data_agendamento date, valor_servico money)
LANGUAGE plpgsql
AS $$
DECLARE 
    dataServico date := CURRENT_DATE + INTERVAL '15 DAYS';
    valorEstipuladoAux money;
    i integer;
BEGIN
    SELECT valorEstipulado::numeric::money INTO valorEstipuladoAux;
    i := 0;
    WHILE i < numServicos LOOP
        INSERT INTO servico (diarista_id, residencia_id, data_agendada, valor_estipulado) 
        VALUES (diaristaID, residenciaID, dataServico, valorEstipuladoAux);
        dataServico := dataServico + INTERVAL '15 DAYS';
        i := i + 1;
    END LOOP;
    RETURN QUERY SELECT diarista_id, residencia_id, data_agendada, valor_estipulado 
                 FROM servico WHERE diarista_id = diaristaID AND residencia_id = residenciaID;
END;
$$;

-- Função para Calcular a Frequência do diarista
CREATE FUNCTION frequencia_diarista(diaristaID integer) RETURNS numeric
LANGUAGE plpgsql
AS $$
DECLARE 
    nomediarista character varying(50);
    numServicosRealizados integer;
    numPresencas integer;
    porcentagemPresenca numeric;
BEGIN
    SELECT nome FROM diarista WHERE id = diaristaID INTO nomediarista;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'diarista não encontrado';
    END IF;

    SELECT COUNT(*) FROM servico WHERE diarista_id = diaristaID AND data_agendada < CURRENT_DATE INTO numServicosRealizados;
    SELECT COUNT(*) FROM servico WHERE diarista_id = diaristaID AND data_agendada < CURRENT_DATE AND realizado = true INTO numPresencas;

    IF numServicosRealizados > 0 THEN
        porcentagemPresenca := (numPresencas * 100) / numServicosRealizados;
        RAISE NOTICE 'O diarista % tem % porcento de presença', nomediarista, porcentagemPresenca;
    ELSE
        porcentagemPresenca := 0;
        RAISE NOTICE 'O diarista % ainda não tem nenhum serviço com o agendamento vencido', nomediarista;
    END IF;
    
    RETURN porcentagemPresenca;
END;
$$;

-- Trigger para Validar Serviços
CREATE OR REPLACE FUNCTION validar_servico() RETURNS TRIGGER AS
$$
DECLARE
    realizadoServico boolean;
    confirmado boolean := false;
BEGIN
    SELECT realizado FROM servico WHERE diarista_id = NEW.diarista_id AND data_agendada = NEW.data_agendada INTO realizadoServico;
    
    IF NEW.data_agendada < CURRENT_DATE THEN
        confirmado := true;
    ELSE
        IF NEW.realizado THEN
            RAISE NOTICE 'Serviço não pode ter sido confirmado ANTES da DATA AGENDADA';   
            confirmado := false; 
        ELSE
            confirmado := true; 
        END IF;
    END IF; 

    IF TG_OP = 'INSERT' THEN
        IF confirmado THEN
            IF NEW.realizado THEN
                IF CAST(NEW.valor_recebido AS NUMERIC(8,2)) = 0.0 THEN
                    RAISE NOTICE 'O serviço REALIZADO deve ser PAGO!';   
                    RETURN NULL;                
                ELSE
                    RETURN NEW;
                END IF;            
            ELSE
                IF CAST(NEW.valor_recebido AS NUMERIC(8,2)) = 0.0 THEN
                    RETURN NEW;
                ELSE
                    RAISE NOTICE 'Serviço não realizado, NÃO pode ser PAGO!';   
                    RETURN NULL;   
                END IF; 
            END IF;                 
        ELSE
            RETURN NULL;
        END IF;       
    ELSE
        IF TG_OP = 'UPDATE' THEN       
            IF confirmado THEN
                IF realizadoServico THEN
                    IF CAST(NEW.valor_recebido AS NUMERIC(8,2)) > 0.0 THEN
                        RETURN NEW;
                    ELSE
                        RAISE NOTICE 'O serviço REALIZADO deve ser PAGO!';
                        RETURN NULL;
                    END IF;
                ELSE
                    IF CAST(NEW.valor_recebido AS NUMERIC(8,2)) = 0.0 THEN
                        RETURN NEW;
                    ELSE
                        RAISE NOTICE 'diarista ausente, o serviço NÃO vai ser PAGO!';
                        RETURN NULL;
                    END IF;
                END IF;
            ELSE
                RETURN NULL;
            END IF;      
        END IF;
    END IF;   
END;
$$ LANGUAGE 'plpgsql';

-- Trigger para Deletar diarista com Baixa Frequência
CREATE OR REPLACE FUNCTION deletar_diarista_frequencia() RETURNS TRIGGER AS
$$
DECLARE
    frequenciadiarista numeric;
    numServicosRealizados integer;
    nomediarista character varying(50);
BEGIN
    SELECT nome FROM diarista WHERE id = NEW.diarista_id INTO nomediarista;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'diarista não encontrado';
    END IF;

    SELECT * FROM frequencia_diarista(NEW.diarista_id) INTO frequenciadiarista;
    SELECT COUNT(*) FROM servico WHERE diarista_id = NEW.diarista_id AND data_agendada < CURRENT_DATE INTO numServicosRealizados;

    IF frequenciadiarista <= 40 AND numServicosRealizados >= 3 THEN
        DELETE FROM servico WHERE diarista_id = NEW.diarista_id;
        DELETE FROM diarista WHERE id = NEW.diarista_id;
        RAISE NOTICE 'O diarista % foi removido por baixa frequência', nomediarista;
        RETURN OLD;
    ELSE
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER validar_servico_trigger
BEFORE INSERT OR UPDATE
ON servico
FOR EACH ROW
EXECUTE PROCEDURE validar_servico();

CREATE TRIGGER deletar_diarista_frequencia_trigger
BEFORE INSERT OR UPDATE
ON servico
FOR EACH ROW
EXECUTE PROCEDURE deletar_diarista_frequencia();


-- Crie um STORE PROCEDURE que permita agendar quinzenalmente ou mensalmente faxinas em uma determinada residência:
SELECT * FROM agendar_servicos_mensais(3,4,290.00,4);
SELECT * FROM agendar_servicos_quinzenais(2,3,150.00,10);

-- Crie um STORE PROCEDURE que calcule a porcentagem de presenças que uma diarista obteve em suas faxinas ao longo do ano
--75% de presença mas apenas 4 Faxinas registradas
SELECT * FROM frequencia_diarista(3);
--100% de presença
SELECT * FROM frequencia_diarista(5);
--70% de presença
SELECT * FROM frequencia_diarista(6);
--20% de presença
SELECT * FROM frequencia_diarista(7);

-- Crie uma TRIGGER que exclua a diarista caso suas presenças fiquem menores que 75% (quando a diarista já tem no mínimo 5 faxinas cadastradas)
SELECT * FROM diarista;
SELECT * FROM servico ORDER BY diarista_id ASC;

UPDATE servico SET data_agendada='2024-05-25' WHERE diarista_id = 3 AND data_agendada = '2024-11-12';

INSERT INTO servico  (diarista_id, residencia_id, data_agendada, valor_estipulado, valor_recebido, realizado, observacao) VALUES
(6,1,'2024-08-23',200,0,false,''),
(7,4,'2024-08-17',350,0,false,'');

SELECT * FROM diarista;
SELECT * FROM servico ORDER BY diarista_id ASC;