DROP DATABASE IF EXISTS trabalho;

CREATE DATABASE trabalho;

\c trabalho;


CREATE OR REPLACE FUNCTION registraEntrada(registro_id integer, data_entrada timestamp, funcionario_id integer) RETURNS BOOLEAN AS
$$
DECLARE
    data_encontrada TIMESTAMP;
BEGIN
    SELECT INTO data_encontrada data_hora_entrada FROM registro WHERE id = $1;
    IF (data_encontrada IS NULL) THEN
            INSERT INTO registro (funcionario_id) VALUES ($3);
            UPDATE registro SET data_hora_entrada = $2  WHERE id = registro_id;
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION registraSaida(registro_id integer) RETURNS BOOLEAN AS
$$
DECLARE
    data_encontrada TIMESTAMP;
BEGIN
    SELECT INTO data_encontrada data_hora_saida FROM registro WHERE id = $1;
    IF (data_encontrada IS NULL) THEN
            UPDATE registro SET data_hora_saida = CURRENT_TIMESTAMP  WHERE id = registro_id;
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$ LANGUAGE 'plpgsql';

-- Não coloquei a quantidade de horas trabalhadas
-- Estava tentando com (EXTRACT(HOUR FROM registro.data_hora_saida) - EXTRACT(HOUR FROM registro.data_hora_entrada))  
-- No SELECT, mas estava me retornando sempre a tabela vazia, então optei em tirar
CREATE OR REPLACE FUNCTION funcionariosComMaisHoras() 
    RETURNS TABLE (funcionario_id INTEGER, nomeFuncionario VARCHAR(100)) AS
$$
BEGIN
       RETURN 
            QUERY SELECT funcionario.id, funcionario.nome  FROM funcionario 
                    INNER JOIN registro ON (funcionario.id = registro.funcionario_id) GROUP BY funcionario.id, funcionario.nome
                        HAVING COUNT(*) = (SELECT count(*) FROM funcionario INNER JOIN registro ON (funcionario.id = registro.funcionario_id) 
                        GROUP BY funcionario.id ORDER BY COUNT(*) DESC LIMIT 1);
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION funcionariosSemSaida() 
    RETURNS TABLE (funcionario_id INTEGER, nome VARCHAR(100), data_entrada TIMESTAMP) AS
$$
BEGIN
       RETURN QUERY 
            SELECT funcionario.id, funcionario.nome, data_hora_entrada  FROM funcionario 
                    INNER JOIN registro ON (funcionario.id = registro.funcionario_id) WHERE data_hora_saida IS NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TABLE funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    senha VARCHAR(30) NOT NULL
);

CREATE TABLE registro (
    id SERIAL PRIMARY KEY,
    data_hora_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_hora_saida TIMESTAMP,
    funcionario_id INTEGER REFERENCES funcionario(id)
);

INSERT INTO funcionario (nome, senha) VALUES 
                        ('Ana Flavia', '12345'),
                        ('Igor','65478'),
                        ('Marcio', '25789'),
                        ('Cibele','45632'); 

INSERT INTO registro (data_hora_entrada,funcionario_id) VALUES
                     ('2023-10-20 : 08:30:00', 1),
                     ('2023-10-20 : 13:30:00', 2),
                     ('2023-10-20 : 17:30:00', 3);

SELECT registraEntrada(4,'2023-10-20 : 12:00:00',1);

SELECT registraSaida(1);
SELECT registraSaida(2);

SELECT registraSaida(4);

SELECT * FROM funcionariosSemSaida();

SELECT * FROM funcionariosComMaisHoras();