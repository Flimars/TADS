DROP DATABASE IF EXISTS locadora110522;


CREATE DATABASE locadora110522;

\c locadora110522;

DROP TABLE IF EXISTS  LOCACAO;
DROP TABLE IF EXISTS  RESERVA;
DROP TABLE IF EXISTS  DVD;
DROP TABLE IF EXISTS  STATUS;
DROP TABLE IF EXISTS  FILME;
DROP TABLE IF EXISTS  CATEGORIA;
DROP TABLE IF EXISTS  CLIENTE;


CREATE TABLE  CLIENTE
   (    CODCLIENTE serial, 
    	NOME_CLIENTE VARCHAR(30) NOT NULL, 
    	ENDERECO VARCHAR(50) NOT NULL, 
    	TELEFONE VARCHAR(12) NOT NULL, 
    	DATA_NASC DATE NOT NULL, 
    	CPF VARCHAR(11) NOT NULL, 
     	CONSTRAINT PK_CLIENTE PRIMARY KEY (CODCLIENTE),
	CONSTRAINT CPF_UNIQUE UNIQUE (CPF)
   );

CREATE TABLE  CATEGORIA 
   (    CODCATEGORIA serial, 
    	NOME_CATEGORIA VARCHAR(100) NOT NULL, 
     	CONSTRAINT CATEGORIA_PK PRIMARY KEY (CODCATEGORIA), 
     	CONSTRAINT CHECK_NOME_CATEGORIA CHECK ( NOME_CATEGORIA in ('drama','terror','ação','aventura','comédia'))
   );

CREATE TABLE  FILME 
   (    CODFILME serial, 
    	CODCATEGORIA int, 
    	NOME_FILME VARCHAR(100) NOT NULL, 
    	DIARIA numeric(10,2) NOT NULL, 
     	CONSTRAINT PK_FILME PRIMARY KEY (CODFILME), 
     	CONSTRAINT FK_FIL_CAT FOREIGN KEY (CODCATEGORIA)
      		REFERENCES  CATEGORIA (CODCATEGORIA)
		ON DELETE NO ACTION ON UPDATE CASCADE
   );

CREATE TABLE  STATUS 
   (    CODSTATUS SERIAL, 
    	NOME_STATUS VARCHAR(30) NOT NULL, 
     	CONSTRAINT PK_STATUS PRIMARY KEY (CODSTATUS),
     	CONSTRAINT CHECK_NOME_STATUS CHECK ( NOME_STATUS in ('reservado','disponível','indisponível','locado'))

   );

CREATE TABLE  DVD 
   (    CODDVD SERIAL, 
    	CODFILME int NOT NULL, 
    	CODSTATUS int NOT NULL, 
     	CONSTRAINT PK_DVD PRIMARY KEY (CODDVD), 
     	CONSTRAINT FK_DVD_FIL FOREIGN KEY (CODFILME)
      		REFERENCES  FILME (CODFILME) ON UPDATE CASCADE, 
     	CONSTRAINT FK_DVD_STA FOREIGN KEY (CODSTATUS)
      		REFERENCES  STATUS (CODSTATUS) ON UPDATE CASCADE
   );

CREATE TABLE  LOCACAO 
   (    CODLOCACAO SERIAL, 
    	CODDVD int NOT NULL, 
    	CODCLIENTE int NOT NULL, 
    	DATA_LOCACAO DATE NOT NULL DEFAULT NOW(), 
    	DATA_DEVOLUCAO DATE, 
     	CONSTRAINT PK_LOCACAO PRIMARY KEY (CODLOCACAO), 
     	CONSTRAINT FK_LOC_DVD FOREIGN KEY (CODDVD)
      		REFERENCES  DVD (CODDVD) ON DELETE SET NULL ON UPDATE CASCADE, 
     	CONSTRAINT FK_LOC_CLI FOREIGN KEY (CODCLIENTE)
      		REFERENCES  CLIENTE (CODCLIENTE) ON DELETE SET NULL ON UPDATE CASCADE
   );

CREATE TABLE  RESERVA 
   (    CODRESERVA SERIAL, 
    	CODDVD int NOT NULL, 
    	CODCLIENTE int NOT NULL, 
 	DATA_RESERVA DATE DEFAULT NOW(), 
    	DATA_VALIDADE DATE NOT NULL, 
     	CONSTRAINT PK_RESERVA PRIMARY KEY (CODRESERVA), 
     	CONSTRAINT FK_RES_DVD FOREIGN KEY (CODDVD)
      		REFERENCES  DVD (CODDVD) ON DELETE SET NULL ON UPDATE CASCADE, 
     	CONSTRAINT FK_RES_CLI FOREIGN KEY (CODCLIENTE)
      		REFERENCES  CLIENTE (CODCLIENTE) ON DELETE SET NULL ON UPDATE CASCADE
   );

--inserts

INSERT INTO STATUS (NOME_STATUS) VALUES ('reservado');
INSERT INTO STATUS (NOME_STATUS) VALUES ('disponível');    
INSERT INTO STATUS (NOME_STATUS) VALUES ('locado');
INSERT INTO STATUS (NOME_STATUS) VALUES ('indisponível');
    
INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES ('comédia');    
INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES ( 'aventura');
INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES ( 'terror');    
INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES ( 'ação');
INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES ( 'drama');

INSERT INTO CLIENTE (NOME_CLIENTE,ENDERECO,TELEFONE,DATA_NASC,CPF ) VALUES ('João Paulo', 'rua XV de novembro, n:18', '88119922','05-02-1990','09328457398');
INSERT INTO CLIENTE (NOME_CLIENTE,ENDERECO,TELEFONE,DATA_NASC,CPF ) VALUES ('Maria', 'rua XV de novembro, n:20', '88225422','07-01-1991','93573923168');
INSERT INTO CLIENTE (NOME_CLIENTE,ENDERECO,TELEFONE,DATA_NASC,CPF ) VALUES ('Joana', 'rua XV de novembro, n:10', '99778122','09-07-1980','71398987234');
INSERT INTO CLIENTE (NOME_CLIENTE,ENDERECO,TELEFONE,DATA_NASC,CPF ) VALUES ('Jeferson', 'rua XV de novembro, n:118', '84549922','09-12-1982','02128443298');
INSERT INTO CLIENTE (NOME_CLIENTE,ENDERECO,TELEFONE,DATA_NASC,CPF ) VALUES ('Paula', 'rua XV de novembro, n:128', '82324232','11-04-1970','57398093284');

INSERT INTO FILME (CODCATEGORIA, NOME_FILME,DIARIA ) VALUES (1,'Entrando numa fria', 1.50);    
INSERT INTO FILME (CODCATEGORIA, NOME_FILME,DIARIA ) VALUES (2,'O Hobbit', 3.00);    
INSERT INTO FILME (CODCATEGORIA, NOME_FILME,DIARIA ) VALUES (3,'Sobrenatural 2', 4.50);    
INSERT INTO FILME (CODCATEGORIA, NOME_FILME,DIARIA ) VALUES (5,'Um sonho de liberdade', 1.50);
INSERT INTO FILME (CODCATEGORIA, NOME_FILME,DIARIA ) VALUES (2,'Thor 2', 4.50);
INSERT INTO FILME (CODCATEGORIA, NOME_FILME,DIARIA ) VALUES (4,'Velozes e Furiosos', 1.50);

INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (1,1);
INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (2,2);
INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (2,3);
INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (3,2);
INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (4,2);
INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (4,3);
INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (5,1);
INSERT INTO DVD (CODFILME,CODSTATUS) VALUES (6,3);

INSERT INTO RESERVA (CODDVD,CODCLIENTE,DATA_RESERVA,DATA_VALIDADE) VALUES(1,2,current_date,(current_date+4)); 
INSERT INTO RESERVA (CODDVD,CODCLIENTE,DATA_RESERVA,DATA_VALIDADE) VALUES(5,1,current_date,(current_date+4)); 
INSERT INTO RESERVA (CODDVD,CODCLIENTE,DATA_RESERVA,DATA_VALIDADE) VALUES(6,2,(current_date-30),(current_date-26)); 
INSERT INTO RESERVA (CODDVD,CODCLIENTE,DATA_RESERVA,DATA_VALIDADE) VALUES(6,3,(current_date-4),(current_date-1)); 
INSERT INTO RESERVA (CODDVD,CODCLIENTE,DATA_RESERVA,DATA_VALIDADE) VALUES(6,1,(current_date-20),(current_date-16)); 

INSERT INTO LOCACAO (CODDVD,CODCLIENTE,DATA_LOCACAO, DATA_DEVOLUCAO) VALUES(1,1,(current_date-30),(current_date-28));
INSERT INTO LOCACAO (CODDVD,CODCLIENTE,DATA_LOCACAO, DATA_DEVOLUCAO) VALUES(2,3,(current_date-25),(current_date-23));
INSERT INTO LOCACAO (CODDVD,CODCLIENTE,DATA_LOCACAO, DATA_DEVOLUCAO) VALUES(1,1,(current_date-1),current_date);
INSERT INTO LOCACAO (CODDVD,CODCLIENTE,DATA_LOCACAO, DATA_DEVOLUCAO) VALUES(3,2,(current_date-1),null); 
INSERT INTO LOCACAO (CODDVD,CODCLIENTE,DATA_LOCACAO, DATA_DEVOLUCAO) VALUES(6,2,current_date,null); 
INSERT INTO LOCACAO (CODDVD,CODCLIENTE,DATA_LOCACAO, DATA_DEVOLUCAO) VALUES(8,2,current_date,null);

--=======================================================================================
-- Exercicios:
--=======================================================================================

-- 1. Faça uma função que apaga um cliente de código x que deve ser passado como parâmetro.
CREATE OR REPLACE FUNCTION apagar_cliente(x INT) RETURNS VOID AS $$
BEGIN
    DELETE FROM CLIENTE WHERE CODCLIENTE = x;
END;
$$ LANGUAGE plpgsql;

-- 2. Faça uma função que insere um cliente, os parâmetros necessários devem ser passados (com exceção do código do cliente).
CREATE OR REPLACE FUNCTION inserir_cliente(
    nome_cliente VARCHAR,
    endereco VARCHAR,
    telefone VARCHAR,
    data_nasc DATE,
    cpf VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO CLIENTE (NOME_CLIENTE, ENDERECO, TELEFONE, DATA_NASC, CPF)
    VALUES (nome_cliente, endereco, telefone, data_nasc, cpf);
END;
$$ LANGUAGE plpgsql;

-- 3. Faça uma função que imprima o número de filmes e dvds disponíveis de uma categoria X. Onde X é o parâmetro.
CREATE OR REPLACE FUNCTION contar_filmes_dvds_disponiveis(categoria_x VARCHAR) 
RETURNS TABLE (num_filmes INT, num_dvds_disponiveis INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT COUNT(DISTINCT F.CODFILME) AS num_filmes,
           COUNT(D.CODDVD) AS num_dvds_disponiveis
    FROM FILME F
    JOIN CATEGORIA C ON F.CODCATEGORIA = C.CODCATEGORIA
    JOIN DVD D ON F.CODFILME = D.CODFILME
    WHERE C.NOME_CATEGORIA = categoria_x
      AND D.CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível');
END;
$$ LANGUAGE plpgsql;

-- 4. Faça uma função que retorne o nome do filme mais locado.
CREATE OR REPLACE FUNCTION filme_mais_locado() 
RETURNS VARCHAR AS $$
DECLARE
    nome_filme VARCHAR;
BEGIN
    SELECT F.NOME_FILME 
    INTO nome_filme
    FROM LOCACAO L
    JOIN DVD D ON L.CODDVD = D.CODDVD
    JOIN FILME F ON D.CODFILME = F.CODFILME
    GROUP BY F.NOME_FILME
    ORDER BY COUNT(L.CODLOCACAO) DESC
    LIMIT 1;
    
    RETURN nome_filme;
END;
$$ LANGUAGE plpgsql;

-- 5. Fazer uma função que receba como parâmetro o nome de um cliente e retorne a quantidade de DVDs locados por ele. E se existirem dois clientes com o mesmo nome?
CREATE OR REPLACE FUNCTION contar_dvds_locados_por_cliente(nome_cliente VARCHAR) 
RETURNS INT AS $$
DECLARE
    qtd_dvds INT;
BEGIN
    SELECT COUNT(L.CODLOCACAO)
    INTO qtd_dvds
    FROM LOCACAO L
    JOIN CLIENTE C ON L.CODCLIENTE = C.CODCLIENTE
    WHERE C.NOME_CLIENTE = nome_cliente;

    RETURN qtd_dvds;
END;
$$ LANGUAGE plpgsql;

-- 6. Faça um procedimento que insere um item na tabela Locação, passe como parâmetro apenas o nome do filme e o nome do cliente. Para a data de locação utilize a data atual do sistema. Não esqueça de alterar o status para locado. A função deve retornar verdadeiro ou falso caso consiga efetuar a locação (tenha algum DVD disponível)
CREATE OR REPLACE FUNCTION locar_filme(nome_filme VARCHAR, nome_cliente VARCHAR) 
RETURNS BOOLEAN AS $$
DECLARE
    cod_filme INT;
    cod_cliente INT;
    cod_dvd INT;
BEGIN
    -- Buscar o código do filme
    SELECT CODFILME INTO cod_filme 
    FROM FILME 
    WHERE NOME_FILME = nome_filme;

    -- Buscar o código do cliente
    SELECT CODCLIENTE INTO cod_cliente 
    FROM CLIENTE 
    WHERE NOME_CLIENTE = nome_cliente;

    -- Buscar o código do DVD disponível
    SELECT CODDVD INTO cod_dvd 
    FROM DVD 
    WHERE CODFILME = cod_filme 
    AND CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível')
    LIMIT 1;

    -- Verificar se encontrou o DVD disponível
    IF cod_dvd IS NULL THEN
        RETURN FALSE;
    ELSE
        -- Inserir na tabela LOCACAO
        INSERT INTO LOCACAO (CODDVD, CODCLIENTE, DATA_LOCACAO) 
        VALUES (cod_dvd, cod_cliente, CURRENT_DATE);

        -- Atualizar o status do DVD para 'locado'
        UPDATE DVD 
        SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'locado') 
        WHERE CODDVD = cod_dvd;

        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 7. Refaça o exercício anterior, agora gerando criando uma exceção, caso o filme solicitado não tenha nenhum dvd disponível.
CREATE OR REPLACE FUNCTION locar_filme_com_excecao(nome_filme VARCHAR, nome_cliente VARCHAR) 
RETURNS BOOLEAN AS $$
DECLARE
    cod_filme INT;
    cod_cliente INT;
    cod_dvd INT;
BEGIN
    -- Buscar o código do filme
    SELECT CODFILME INTO cod_filme 
    FROM FILME 
    WHERE NOME_FILME = nome_filme;

    -- Buscar o código do cliente
    SELECT CODCLIENTE INTO cod_cliente 
    FROM CLIENTE 
    WHERE NOME_CLIENTE = nome_cliente;

    -- Buscar o código do DVD disponível
    SELECT CODDVD INTO cod_dvd 
    FROM DVD 
    WHERE CODFILME = cod_filme 
    AND CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível')
    LIMIT 1;

    -- Verificar se encontrou o DVD disponível
    IF cod_dvd IS NULL THEN
        RAISE EXCEPTION 'Nenhum DVD disponível para este filme.';
    ELSE
        -- Inserir na tabela LOCACAO
        INSERT INTO LOCACAO (CODDVD, CODCLIENTE, DATA_LOCACAO) 
        VALUES (cod_dvd, cod_cliente, CURRENT_DATE);

        -- Atualizar o status do DVD para 'locado'
        UPDATE DVD 
        SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'locado') 
        WHERE CODDVD = cod_dvd;

        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 8. Faça um procedimento que altere o status dos DVDs com reserva vencida. Isso só deve ser feito se o status do DVD está reservado. Não se esqueça que um DVD pode estar reservado e já ter sido reservado outras vezes e obviamente apenas a última reserva é que não estará vencida e com isso o DVD não deverá ter seu status modificado.
CREATE OR REPLACE FUNCTION atualizar_status_reserva_vencida() 
RETURNS VOID AS $$
DECLARE
    cod_dvd INT;
BEGIN
    FOR cod_dvd IN 
        SELECT CODDVD 
        FROM RESERVA 
        WHERE DATA_VALIDADE < CURRENT_DATE
        AND CODDVD IN (SELECT CODDVD FROM DVD WHERE CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'reservado'))
    LOOP
        -- Atualizar status do DVD para 'disponível'
        UPDATE DVD 
        SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível') 
        WHERE CODDVD = cod_dvd;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 9. Crie um trigger que gera um log de todas as alterações na tabela DVD (linha por linha). Para isso crie uma tabela de log com os campos código (serial), comando (INSERT, DELETE ou UPDATE) e descrição (o que ocorreu).
CREATE TABLE LOG_DVD (
    CODLOG SERIAL PRIMARY KEY,
    COMANDO VARCHAR(10),
    DESCRICAO TEXT
);

CREATE OR REPLACE FUNCTION log_dvd_alteracao()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO LOG_DVD (COMANDO, DESCRICAO) 
        VALUES ('INSERT', 'DVD ' || NEW.CODDVD || ' foi inserido.');
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO LOG_DVD (COMANDO, DESCRICAO) 
        VALUES ('UPDATE', 'DVD ' || OLD.CODDVD || ' foi atualizado.');
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO LOG_DVD (COMANDO, DESCRICAO) 
        VALUES ('DELETE', 'DVD ' || OLD.CODDVD || ' foi deletado.');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_dvd
AFTER INSERT OR UPDATE OR DELETE ON DVD
FOR EACH ROW EXECUTE FUNCTION log_dvd_alteracao();

-- 10. Faça um trigger que modifica o status de um DVD, baseado em cada um dos eventos:
-- a. Entrega de um DVD alugado
CREATE OR REPLACE FUNCTION atualiza_status_entrega()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE DVD 
    SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível') 
    WHERE CODDVD = NEW.CODDVD;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualiza_entrega
AFTER UPDATE ON LOCACAO
FOR EACH ROW
WHEN (NEW.DATA_DEVOLUCAO IS NOT NULL)
EXECUTE FUNCTION atualiza_status_entrega();

-- b. Reserva de um DVD. Considere uma reserva de 4 dias, a contar do dia atual caso o DVD esteja disponível, caso contrário a reserva não deve ser efetuada.
CREATE OR REPLACE FUNCTION atualiza_status_reserva()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM DVD WHERE CODDVD = NEW.CODDVD AND CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível')) THEN
        UPDATE DVD 
        SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'reservado') 
        WHERE CODDVD = NEW.CODDVD;
    ELSE
        RAISE EXCEPTION 'Reserva não pode ser realizada, DVD não está disponível.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualiza_reserva
BEFORE INSERT ON RESERVA
FOR EACH ROW EXECUTE FUNCTION atualiza_status_reserva();

-- 11. Fazer um gatilho que controla o evento de uma locação e testa o status do DVD desejado para locação:
-- a. Caso o DVD esteja disponível, apenas é necessário mudar o status do DVD e efetivar a operação
-- b. Caso esteja reservado, deve ser verificado se a locação esta sendo realizada pelo mesmo cliente que possui a reserva: i. caso seja, permita a operação e altere o status do DVD; ii. caso não esteja, não permita a realização da operação (gere um erro com a mensagem: "Reserva para outro cliente!")
CREATE OR REPLACE FUNCTION controla_locacao_dvd()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT CODSTATUS FROM DVD WHERE CODDVD = NEW.CODDVD) = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível') THEN
        -- Atualizar status para 'locado'
        UPDATE DVD 
        SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'locado') 
        WHERE CODDVD = NEW.CODDVD;
        RETURN NEW;
    ELSIF (SELECT CODSTATUS FROM DVD WHERE CODDVD = NEW.CODDVD) = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'reservado') THEN
        IF (SELECT CODCLIENTE FROM RESERVA WHERE CODDVD = NEW.CODDVD ORDER BY DATA_VALIDADE DESC LIMIT 1) = NEW.CODCLIENTE THEN
            -- Atualizar status para 'locado'
            UPDATE DVD 
            SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'locado') 
            WHERE CODDVD = NEW.CODDVD;
            RETURN NEW;
        ELSE
            RAISE EXCEPTION 'Reserva para outro cliente!';
        END IF;
    ELSE
        RAISE EXCEPTION 'DVD locado!';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_controla_locacao_dvd
BEFORE INSERT ON LOCACAO
FOR EACH ROW EXECUTE FUNCTION controla_locacao_dvd();

-- c. Caso esteja locado, não permita a realização da operação e gere um erro com a mensagem: "DVD locado!"
CREATE OR REPLACE FUNCTION controla_locacao_dvd()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT CODSTATUS FROM DVD WHERE CODDVD = NEW.CODDVD) = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'disponível') THEN
        -- Caso o DVD esteja disponível, atualizar status para 'locado'
        UPDATE DVD 
        SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'locado') 
        WHERE CODDVD = NEW.CODDVD;
        RETURN NEW;
    ELSIF (SELECT CODSTATUS FROM DVD WHERE CODDVD = NEW.CODDVD) = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'reservado') THEN
        -- Caso o DVD esteja reservado, verificar se a reserva é do cliente que está locando
        IF (SELECT CODCLIENTE FROM RESERVA WHERE CODDVD = NEW.CODDVD ORDER BY DATA_VALIDADE DESC LIMIT 1) = NEW.CODCLIENTE THEN
            -- Atualizar status para 'locado'
            UPDATE DVD 
            SET CODSTATUS = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'locado') 
            WHERE CODDVD = NEW.CODDVD;
            RETURN NEW;
        ELSE
            RAISE EXCEPTION 'Reserva para outro cliente!';
        END IF;
    ELSIF (SELECT CODSTATUS FROM DVD WHERE CODDVD = NEW.CODDVD) = (SELECT CODSTATUS FROM STATUS WHERE NOME_STATUS = 'locado') THEN
        -- Caso o DVD esteja locado, gerar erro
        RAISE EXCEPTION 'DVD locado!';
    ELSE
        -- Caso para outros status, gerar erro genérico
        RAISE EXCEPTION 'Operação não permitida. Status atual do DVD: %', (SELECT NOME_STATUS FROM STATUS WHERE CODSTATUS = (SELECT CODSTATUS FROM DVD WHERE CODDVD = NEW.CODDVD));
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_controla_locacao_dvd
BEFORE INSERT ON LOCACAO
FOR EACH ROW EXECUTE FUNCTION controla_locacao_dvd();
