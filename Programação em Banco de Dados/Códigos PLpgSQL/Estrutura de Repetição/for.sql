/* Este exemplo faz o mesmo que o anterior, mas usando um loop FOR, que é mais conciso para iterar sobre um intervalo de números.

Dicas Finais:
Sempre teste suas funções e procedimentos com diferentes entradas para garantir que eles funcionem como esperado em todas as situações.

Use RAISE NOTICE para depurar seu código e entender o fluxo de execução.
Lembre-se de que o PL/pgSQL é sensível ao caso em palavras-chave, então certifique-se de usar a capitalização correta.

*/
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
