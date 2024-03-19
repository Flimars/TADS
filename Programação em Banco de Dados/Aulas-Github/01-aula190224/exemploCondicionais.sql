CREATE OR REPLACE FUNCTION condicionais(numero INTEGER) RETURNS text AS
$$
DECLARE
       resultado TEXT;

BEGIN
    -- Validação de um número
    IF numero = 0 THEN
        resultado := 'Zero';
    ELSIF numero > 0 THEN
        resultado := 'Positivo';
    ELSIF numero < 0 THEN
        resultado := 'Negativo';
	-- Outra posibilidade é o número ser NULO.		
    ELSIF numero IS NULL THEN
        resultado := 'Nulo';
	 ELSE
		resultado := 'Opção Inválida!';
END IF;
	return resultado;
END;
$$ language plpgsql;

-- Chamada da função
SELECT condicionais(23);

-- DROP FUNCTION  condicionais(numero INTEGER);