/*
Esta função calcula a soma dos números naturais de n até 1 usando um loop WHILE.

Dicas Finais:
Sempre teste suas funções e procedimentos com diferentes entradas para garantir que eles funcionem como esperado em todas as situações.

Use RAISE NOTICE para depurar seu código e entender o fluxo de execução.
Lembre-se de que o PL/pgSQL é sensível ao caso em palavras-chave, então certifique-se de usar a capitalização correta.


*/ 

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

