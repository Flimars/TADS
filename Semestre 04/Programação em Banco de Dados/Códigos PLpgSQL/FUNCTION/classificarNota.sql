/*
    Vamos criar um exemplo completo de uma função PL/pgSQL que utiliza a estrutura CASE. Esta função será chamada classificar_nota, e ela receberá uma nota numérica como argumento. Com base na nota fornecida, a função classificará a nota em diferentes categorias: "Insuficiente", "Suficiente", "Bom", "Muito Bom" ou "Excelente".

    Neste exemplo, a função classificar_nota recebe um parâmetro nota, que é do tipo NUMERIC. Dentro da função, usamos uma expressão CASE para verificar a faixa em que a nota se encontra e retornar a classificação correspondente como uma string (VARCHAR). Se a nota fornecida não estiver dentro do intervalo esperado (0 a 10), a função retorna 'Nota inválida'.

*/



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
