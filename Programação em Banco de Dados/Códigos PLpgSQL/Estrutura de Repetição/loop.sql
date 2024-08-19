/*
Estruturas de Repetição no PL/pgSQL
As estruturas de repetição permitem que seu código execute um bloco de instruções repetidamente até que uma condição seja atendida. As principais estruturas de repetição no PL/pgSQL são LOOP, WHILE e FOR.

Dicas Finais:
Sempre teste suas funções e procedimentos com diferentes entradas para garantir que eles funcionem como esperado em todas as situações.

Use RAISE NOTICE para depurar seu código e entender o fluxo de execução.
Lembre-se de que o PL/pgSQL é sensível ao caso em palavras-chave, então certifique-se de usar a capitalização correta.

Exemplo de LOOP
*/

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

--Chamada da function
CALL imprimir_numeros();
