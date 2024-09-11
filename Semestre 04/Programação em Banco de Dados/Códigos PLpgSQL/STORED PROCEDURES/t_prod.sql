-- 2. Crie um STORED PROCEDURE para atualizar a tabela abaixo, conforme as regras
-- que seguem:
-- PRODUTO categoria A deverão ser reajustados em 5%
-- PRODUTO categoria B deverão ser reajustados em 10%
-- PRODUTO categoria C deverão ser reajustados em 15%

DROP TABLE IF EXISTS PRODUTO;

CREATE TABLE PRODUTO (
CODIGO integer primary key,
CATEGORIA CHAR(1),
VALOR real
);

INSERT INTO PRODUTO VALUES
(1001,'A',7.56),
(1002,'B',5.99),
(1003,'C',3.45)
ON CONFLICT (codigo) DO NOTHING; -- A cláusula ON CONFLICT (codigo) DO NOTHING instrui o PostgreSQL a ignorar a inserção se a chave primária codigo já existir.

-- 2. STORED PROCEDURE para reajustar preços de PRODUTO:
CREATE OR REPLACE PROCEDURE reajustar_precos()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Reajuste para PRODUTO categoria A
    UPDATE PRODUTO
    SET VALOR = VALOR * 1.05
    WHERE CATEGORIA = 'A';

    -- Reajuste para PRODUTO categoria B
    UPDATE PRODUTO
    SET VALOR = VALOR * 1.10
    WHERE CATEGORIA = 'B';

    -- Reajuste para PRODUTO categoria C
    UPDATE PRODUTO
    SET VALOR = VALOR * 1.15
    WHERE CATEGORIA = 'C';
END;
$$;

-- CHAMADA:
CALL reajustar_precos();

SELECT * FROM PRODUTO;