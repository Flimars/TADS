/*
    Neste exemplo, a função verificar_idade recebe um parâmetro idade e retorna uma string indicando se a pessoa é maior ou menor de idade.
*/


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
