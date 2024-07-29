--================================================================
-- USANDO ESTRUTURA DE REPETIÇÃO LOOP 
--================================================================
-- Remove a função
DROP FUNCTION IF EXISTS imprimir_numeros();

-- Cria a função
CREATE OR REPLACE PROCEDURE imprimir_numeros()
LANGUAGE plpgsql
AS $$
DECLARE
   contador INT := 1;
BEGIN
   LOOP
      EXIT WHEN contador > 10;
      RAISE NOTICE '%', contador;
      contador := contador + 1;
   END LOOP;
END;
$$;

CALL imprimir_numeros();

--================================================================
-- USANDO ESTRUTURA DE REPETIÇÃO WHILE
--================================================================
-- Remove a função
DROP FUNCTION IF EXISTS somar_naturais(INT);

-- Cria a função
CREATE OR REPLACE FUNCTION somar_naturais(n INT)
RETURNS INT AS $$
DECLARE
   soma INT := 0;
BEGIN
   WHILE n > 0 LOOP
      soma := soma + n;
      n := n - 1;
   END LOOP;
   RETURN soma;
END;
$$ LANGUAGE plpgsql;

-- Uso da função
SELECT somar_naturais(10);

--================================================================
-- USANDO ESTRUTURA DE REPETIÇÃO FOR
--================================================================
-- Remove a função
DROP FUNCTION IF EXISTS somar_naturais(INT);

-- Cria a função
CREATE OR REPLACE FUNCTION somar_naturais_for(n INT)
RETURNS INT AS $$
DECLARE
   soma INT := 0;
BEGIN
   FOR i IN 1..n LOOP
      soma := soma + i;
   END LOOP;
   RETURN soma;
END;
$$ LANGUAGE plpgsql;

-- Uso da função
SELECT somar_naturais_for(10);