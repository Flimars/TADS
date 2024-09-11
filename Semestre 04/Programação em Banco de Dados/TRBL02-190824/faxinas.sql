DROP DATABASE IF EXISTS faxinas;

CREATE DATABASE faxinas;

\c faxinas;

CREATE FUNCTION agendar_faxinas_mensais(diaristaID integer, residenciaID integer, valorCobrado numeric, numFaxinas integer) RETURNS TABLE( 
    diarista integer, residencia integer, data_agendamento date, valor_faxina money)
    LANGUAGE plpgsql
    AS $$

    DECLARE 
        dataFaxina date = CURRENT_DATE + INTERVAL '1 MONTH';
        valorCobradoAux money;
        i integer;

    BEGIN
        SELECT valorCobrado::numeric::money INTO valorCobradoAux;
        i := 0;
        WHILE (i < numFaxinas) LOOP
            BEGIN
                INSERT INTO faxina  (diarista_id, residencia_id, data_realizacao, valor_cobrado) VALUES
                (diaristaID,residenciaID,dataFaxina,valorCobradoAux);
            END;
                dataFaxina = dataFaxina + INTERVAL '1 MONTH';
                i := i + 1;
        END LOOP;
        RETURN query SELECT diarista_id as diarista, residencia_id as residencia, data_realizacao as data_agendamento, valor_cobrado as valor_faxina FROM faxina WHERE diarista_id = diaristaID AND residencia_id = residenciaID;
    END;
$$;

CREATE FUNCTION agendar_faxinas_quinzenais(diaristaID integer, residenciaID integer, valorCobrado numeric, numFaxinas integer) RETURNS TABLE( 
    diarista integer, residencia integer, data_agendamento date, valor_faxina money)
    LANGUAGE plpgsql
    AS $$

    DECLARE 
        dataFaxina date = CURRENT_DATE + INTERVAL '15 DAYS';
        valorCobradoAux money;
        i integer;

    BEGIN
        SELECT valorCobrado::numeric::money INTO valorCobradoAux;
        i := 0;
        WHILE (i < numFaxinas) LOOP
                BEGIN
                INSERT INTO faxina  (diarista_id, residencia_id, data_realizacao, valor_cobrado) VALUES
                (diaristaID,residenciaID,dataFaxina,valorCobradoAux);
            END;
                dataFaxina = dataFaxina + INTERVAL '15 DAYS';
                i := i + 1;
        END LOOP;
        RETURN query SELECT diarista_id as diarista, residencia_id as residencia, data_realizacao as data_agendamento, valor_cobrado as valor_faxina FROM faxina WHERE diarista_id = diaristaID AND residencia_id = residenciaID;
    END;
$$;

CREATE FUNCTION frequencia_diarista(diaristaID integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$

    DECLARE 
        nomeDiarista varchar(50);
        numFaxinasRealizadas integer;
        numPresenca integer;
        porcentagemPresenca numeric;
    BEGIN
        SELECT nome FROM diarista WHERE id=diaristaID INTO nomeDiarista;
	    IF NOT found THEN
		    RAISE EXCEPTION 'Diarista não encontrada';
		END IF;

        SELECT COUNT(*) FROM faxina WHERE diarista_id = diaristaID AND data_realizacao < CURRENT_DATE INTO numFaxinasRealizadas;
        SELECT COUNT(*) FROM faxina WHERE diarista_id = diaristaID AND data_realizacao < CURRENT_DATE AND realizou = true INTO numPresenca;

        IF (numFaxinasRealizadas > 0) THEN
            porcentagemPresenca=(numPresenca*100)/numFaxinasRealizadas;
            RAISE NOTICE 'A(o) diarista % tem % porcento de presença', nomeDiarista, porcentagemPresenca;
        ELSE
            porcentagemPresenca=0;
            RAISE NOTICE 'A(o) diarista % ainda não tem nenhuma faxina com o agendamento vencido', nomeDiarista;
        END IF;
     
        RETURN porcentagemPresenca;
    END;
$$;

CREATE TABLE responsavel (
    id serial primary key,
    nome varchar(50) not null,
    cpf character(11) unique
);

INSERT INTO responsavel  (nome, cpf) VALUES
('Maria','11111111111'),
('Carlos', '22222222222'),
('Rosa','33333333333'),
('Luis', '44444444444');

CREATE TABLE residencia (
    id serial primary key,
    responsavel_id integer REFERENCES responsavel(id),
    cidade varchar(100) not null,
    bairro varchar(100) not null,
    rua text not null,
    complemento text,
    numero varchar(10) not null,
    tamanho character(1) not null CHECK(tamanho='P' or tamanho='M' or tamanho='G')
);

INSERT INTO residencia  (responsavel_id, cidade, bairro, rua, complemento, numero, tamanho) VALUES
(1, 'Rio Grande', 'Parque Marinha', 'Rua Ernesto Alves', null, '32', 'M'),
(2, 'Rio Grande', 'Centro', 'Rua Marechal Deodoro', 'apt 708', '421', 'M'),
(3, 'Rio Grande', 'Centro', 'Rua 24 de Maio', 'apt 101', '68', 'P'),
(3, 'Rio Grande', 'Cassino', 'Avenida Beira Mar', null, '207', 'G'),
(4, 'Rio Grande', 'Bolaxa', 'Rua 3', null, '68', 'P');

CREATE TABLE diarista (
    id serial primary key,
    nome varchar(50) not null,
    cpf character(11) unique
);

INSERT INTO diarista  (nome, cpf) VALUES
('Claudia','55555555555'),
('José', '66666666666'),
('Tati','77777777777'),
('Pedro', '88888888888'),
('Thais', '99999999999'),
('Rodrigo','12345678912'),
('Luisa', '78945612378');

CREATE TABLE faxina (
    diarista_id integer REFERENCES diarista(id),
    residencia_id integer REFERENCES residencia(id),
    data_realizacao date not null,
    valor_cobrado money CHECK(CAST(valor_cobrado AS NUMERIC(8,2)) > 0),
    valor_pago money DEFAULT 0.0,
    realizou boolean DEFAULT false,
    feedback text,
    PRIMARY KEY(diarista_id,data_realizacao)
   );

INSERT INTO faxina  (diarista_id, residencia_id, data_realizacao, valor_cobrado, valor_pago, realizou, feedback) VALUES
(1,1,'2024-08-11',150,0,false,''),
(3,4,'2024-08-09',300,350,true,'Excelente diarista, estou muito satisfeito'),
(1,5,'2024-08-10',110,0,false,''),
(4,3,'2024-08-07',200,0,false,''),
(2,2,'2024-08-20',200,0,false,''),

(3,2,'2024-08-01',250,260,true,''),
(3,1,'2024-08-02',250,250,true,''),
(3,3,'2024-08-03',100,0,false,''),

(5,1,'2024-07-01',200,250,true,''),
(5,2,'2024-07-02',200,200,true,''),
(5,1,'2024-07-03',200,180,true,''),
(5,2,'2024-07-04',200,200,true,''),
(5,1,'2024-07-05',200,200,true,''),
(5,2,'2024-07-06',200,170,true,''),
(5,1,'2024-07-07',200,300,true,''),
(5,2,'2024-07-08',200,210,true,''),
(5,1,'2024-07-09',200,200,true,''),
(5,2,'2024-07-10',200,190,true,''),

(6,3,'2024-07-01',100,95,true,''),
(6,4,'2024-07-02',300,300,true,''),
(6,4,'2024-07-03',300,0,true,''),
(6,3,'2024-07-04',100,120,true,''),
(6,3,'2024-07-05',100,100,true,''),
(6,3,'2024-07-06',100,0,true,''),
(6,4,'2024-07-07',300,400,true,''),
(6,3,'2024-07-08',100,150,true,''),
(6,4,'2024-07-09',300,0,false,''),
(6,4,'2024-07-10',300,300,true,''),

(7,5,'2024-07-01',100,0,false,''),
(7,5,'2024-07-02',100,0,false,''),
(7,5,'2024-07-03',100,0,false,''),
(7,5,'2024-07-04',100,100,true,''),
(7,5,'2024-07-05',100,0,false,''),
(7,5,'2024-07-06',100,0,false,''),
(7,5,'2024-07-07',100,100,true,''),
(7,5,'2024-07-08',100,0,false,''),
(7,5,'2024-07-09',100,0,false,''),
(7,5,'2024-07-10',100,0,false,'');

CREATE OR REPLACE FUNCTION validar_faxina() RETURNS TRIGGER AS
$$
DECLARE
    realizouFaxina boolean;
    confirmado boolean = false;
BEGIN
    SELECT realizou FROM faxina where diarista_id = NEW.diarista_id AND data_realizacao=NEW.data_realizacao INTO realizouFaxina;
    
    IF (NEW.data_realizacao < CURRENT_DATE) THEN
        confirmado=true;
    ELSE
        IF(NEW.realizou) THEN
            RAISE NOTICE 'Faxina não pode ter sido confirmada ANTES da DATA AGENDADA';   
            confirmado=false; 
        ELSE
            confirmado=true; 
        END IF;
    END IF; 

    IF TG_OP = 'INSERT' THEN
        IF(confirmado) THEN
            IF (NEW.realizou) THEN
                IF(CAST(NEW.valor_pago AS NUMERIC(8,2)) = 0.0) THEN
                    RAISE NOTICE 'A faxina REALIZADA deve ser PAGA!';   
                    RETURN NULL;                
                ELSE
                    RETURN NEW;
                END IF;            
            ELSE
                IF(CAST(NEW.valor_pago AS NUMERIC(8,2)) = 0.0) THEN
                    RETURN NEW;
                ELSE
                    RAISE NOTICE 'Faxina não realizada, NÃO pode ser PAGA!';   
                    RETURN NULL;   
                END IF; 
            END IF;                 
        ELSE
            RETURN NULL;
        END IF;       
    ELSE
        IF TG_OP = 'UPDATE' THEN       
            IF(confirmado) THEN
                IF (realizouFaxina) THEN
                    IF(CAST(NEW.valor_pago AS NUMERIC(8,2)) > 0.0) THEN
                        RETURN NEW;
                    ELSE
                        RAISE NOTICE 'A faxina REALIZADA deve ser PAGA!';
                        RETURN NULL;
                    END IF;
                ELSE
                    IF(CAST(NEW.valor_pago AS NUMERIC(8,2)) = 0.0) THEN
                        RETURN NEW;
                    ELSE
                        RAISE NOTICE 'Faxineira ausente, a faxina NÃO vai ser PAGA!';
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

CREATE OR REPLACE FUNCTION deletar_diarista_frequencia() RETURNS TRIGGER AS
$$
DECLARE
    frequenciaDiarista numeric;
    numFaxinasRealizadas integer;
    nomeDiarista varchar(50);
    BEGIN
        SELECT nome FROM diarista WHERE id=NEW.diarista_id INTO nomeDiarista;
	    IF NOT found THEN
		    RAISE EXCEPTION 'Diarista não encontrada';
		END IF;

    SELECT * FROM frequencia_diarista(NEW.diarista_id) INTO frequenciaDiarista;
    SELECT COUNT(*) FROM faxina WHERE diarista_id = NEW.diarista_id AND data_realizacao < CURRENT_DATE INTO numFaxinasRealizadas;

        IF (numFaxinasRealizadas >= 5 AND frequenciaDiarista <= 75) THEN
            DELETE FROM faxina WHERE diarista_id = NEW.diarista_id;
            DELETE FROM diarista WHERE id = NEW.diarista_id;
            RAISE NOTICE 'A(o) diarista % retirada(o) da plataforma!',nomeDiarista;
             RETURN NULL;
        ELSE 
            RAISE NOTICE 'A(o) diarista % tem menos de 5 faxinas com agendamento vencido registradas ou com mais de 75 porcento de presença, por enquanto continuará na plataforma!',nomeDiarista;
            RETURN NEW;
        END IF;
       
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER validar_valor_pago_e_ralizacao_faxina BEFORE INSERT OR UPDATE on faxina 
FOR EACH ROW EXECUTE PROCEDURE validar_faxina();

CREATE TRIGGER deletar_diarista_pela_frequencia AFTER INSERT OR UPDATE on faxina 
FOR EACH ROW EXECUTE PROCEDURE deletar_diarista_frequencia();

-- Crie um STORE PROCEDURE que permita agendar quinzenalmente ou mensalmente faxinas em uma determinada residência:
SELECT * FROM agendar_faxinas_mensais(3,4,290.00,4);
SELECT * FROM agendar_faxinas_quinzenais(2,3,150.00,10);

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
SELECT * FROM faxina ORDER BY diarista_id ASC;

UPDATE faxina SET data_realizacao='2024-05-25' WHERE diarista_id = 3 AND data_realizacao = '2024-11-12';

INSERT INTO faxina  (diarista_id, residencia_id, data_realizacao, valor_cobrado, valor_pago, realizou, feedback) VALUES
(6,1,'2024-08-23',200,0,false,''),
(7,4,'2024-08-17',350,0,false,'');

SELECT * FROM diarista;
SELECT * FROM faxina ORDER BY diarista_id ASC;