-- STORED PROCEDURE
-- Convertendo temperatura de Fahrenheit para Celsius.

-- REMOVENDO A FUNÇÃO
-- DROP FUNCTION temperatura();

-- CRIANDO A DA FUNÇÃO
CREATE FUNCTION temperatura (float) RETURNS float AS $$
SELECT (($1 - 32.0) * 5.0 / 9.0);
$$ LANGUAGE SQL;

-- CHAMANDO A FUNÇÃO
SELECT temperatura (77);