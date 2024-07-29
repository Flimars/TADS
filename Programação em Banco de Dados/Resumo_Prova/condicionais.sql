--================================================================
-- USANDO CONDICIONAL IF...THEN...ELSE
--================================================================
-- Remove a função
DROP FUNCTION IF EXISTS verificar_idade(INT);

-- Cria a função
CREATE OR REPLACE FUNCTION verificar_idade(idade INT)
RETURNS VARCHAR AS $$
BEGIN
   IF idade >= 18 THEN
      RETURN 'Maior de idade';
   ELSE
      RETURN 'Menor de idade';
   END IF;
END;
$$ LANGUAGE plpgsql;

-- Uso da função
SELECT verificar_idade(20);


--================================================================
-- USANDO CONDICIONAL CASE
--================================================================
-- Remove a função
DROP FUNCTION IF EXISTS classificar_nota(NUMERIC);

-- Cria a função
CREATE OR REPLACE FUNCTION classificar_nota(nota NUMERIC)
RETURNS VARCHAR AS $$
BEGIN
   RETURN (
      CASE
         WHEN nota >= 0 AND nota <= 4 THEN 'Insuficiente'
         WHEN nota > 4 AND nota <= 6 THEN 'Suficiente'
         WHEN nota > 6 AND nota <= 8 THEN 'Bom'
         WHEN nota > 8 AND nota <= 9 THEN 'Muito Bom'
         WHEN nota > 9 AND nota <= 10 THEN 'Excelente'
         ELSE 'Nota inválida'
      END
   );
END;
$$ LANGUAGE plpgsql;

-- Uso da função
SELECT classificar_nota(7.5) AS Classificacao;

-- Uso da função
SELECT nome, nota, classificar_nota(nota) AS Classificacao
FROM estudantes;


--================================================================