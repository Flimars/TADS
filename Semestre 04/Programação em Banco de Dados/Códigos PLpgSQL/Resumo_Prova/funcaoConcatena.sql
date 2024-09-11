
--================================================================================================================
-- Exemplo 1: Usando Funções
--================================================================================================================
-- Removendo a função se ela existir
DROP FUNCTION IF EXISTS soma(TEXT, TEXT);

-- Criando a função soma com dois argumentos tipos texto.
CREATE FUNCTION soma(text, text) RETURNS char AS
$$
DECLARE
resultado text;
BEGIN
resultado := $1 || $2;
return resultado;
END;
$$ LANGUAGE plpgsql;


-- Chamada
select soma('Sidney', 'Silva');

--================================================================================================================
-- Exemplo 2: Usando Funções
--================================================================================================================
DROP FUNCTION IF EXISTS soma_inteiros(INT, INT);

CREATE FUNCTION soma_inteiros(INT, INT) RETURNS char AS
$$
DECLARE
 resultado text;
BEGIN
 resultado := $1 + $2;
 return resultado;
END;
$$ LANGUAGE 'plpgsql';

select soma_inteiros(50, 49);
--================================================================================================================
-- Exemplo 3: Usando Funções
--================================================================================================================
DROP FUNCTION IF EXISTS clientesComMaisPedidos();

CREATE OR REPLACE FUNCTION clientesComMaisPedidos() RETURNS TABLE (cliente_id int) AS
$$
BEGIN
       RETURN QUERY SELECT cliente.id FROM cliente inner join pedido on (cliente.id = pedido.cliente_id) group by cliente.id having count(*) = (SELECT count(*) FROM cliente inner join pedido on (cliente.id = pedido.cliente_id) group by cliente.id ORDER BY COUNT(*) DESC LIMIT 1);
END;
$$ LANGUAGE 'plpgsql';

SELECT clientesComMaisPedidos();