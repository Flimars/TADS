-- SINTAXE FUNCTION
CREATE OR REPLACE FUNCTION mensagem() RETURNS TEXT AS
$$
DECLARE -- opcional (Serve para declarar variaveis)
    msg TEXT;
BEGIN -- inicio da implementação
    msg:= 'Ola!';
    RETURN msg;

END
$$ LANGUAGE plpgsql;

-- CHAMADA DA FUNCTION
SELECT MENSAGEM();
--==========================================================

-- SINTAXE  DA FUNCTION PASSADA COM PARÂMETROS NA FUNCTION
DROP FUNCTION IF EXISTS aplicataxa(real,real);

CREATE OR REPLACE FUNCTION aplicaTaxa(valor1 real, valor2 real) RETURNS REAL AS
 $$
BEGIN
    RETURN (valor1 + valor2) * 0.1;
END;
$$ LANGUAGE plpgsql;  

-- CHAMADA DA FUNCTION
SELECT aplicaTaxa(10, 20);
--==========================================================

-- SINTAXE  DA FUNCTION PASSADA SEM PARÂMETROS NA FUNCTION
CREATE OR REPLACE FUNCTION soma(INTEGER, INTEGER) RETURNS INTEGER AS
$$
DECLARE
 -- OUTRO MODO DE DECLARAR $n
 -- valor1 ALIAS FOR $1;
 -- valor2 ALIAS FOR $2;
 resultado INTEGER;

BEGIN
    resultado := $1 + $2;

    RETURN resultado;

END;
$$ LANGUAGE plpgsql;

SELECT soma(50, 49);

--==========================================================

-- SINTAXE DA FUNCTION VOID
CREATE OR REPLACE FUNCTION lista_usuario(in_array TEXT[]) RETURNS VOID AS
$$
DECLARE
    nome TEXT;
BEGIN
    FOREACH nome IN ARRAY in_array LOOP 
        RAISE NOTICE 'nome: %', nome;
    END LOOP;    
END;
$$ LANGUAGE plpgsql;

-- CHAMADA DA FUNCTION
SELECT lista_usuario(array['Ana', 'Katiane', 'Isabel']);
--==========================================================
-- SINTAXE DA FUNCTION PARA VALIDAÇÃO DE UM NÚMERO
CREATE OR REPLACE FUNCTION valida_numero(INTEGER) RETURNS TEXT AS
$$
DECLARE
    resultado TEXT;
BEGIN
    IF $1 = 0 THEN
        resultado:= 'Zero';
    ELSEIF $1 > 0 THEN
        resultado:= 'Positivo';
    ELSEIF $1 < 0 THEN
        resultado:= 'Negativo';  
    ELSE
        resultado:= 'NULL';
    END IF;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

-- CHAMADA DA FUNCTION
SELECT valida_numero(-5);
SELECT valida_numero(10);
SELECT valida_numero(0);
--==========================================================