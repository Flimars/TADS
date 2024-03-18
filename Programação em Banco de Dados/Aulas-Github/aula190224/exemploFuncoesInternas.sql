-- Exemplos de Concatenação de Strings (dois pipes ||).
SELECT 'A-E'||'-I-O'||'-U' AS vogais;

SELECT CHR(67)||CHR(65)||CHR(84) AS "Dog";

-- Exemplo de Quantidade de Caracteres de String (char_length).
SELECT CHAR_LENGTH('UNIFOR');
-- Or
SELECT LENGTH('Database');

-- Exemplo de Converter para minúsculas
SELECT LOWER('UNIFOR');

-- Exemplo de Converter para maiúsculas
SELECT UPPER('universidade');

-- Exemplo de Encontrar a Posição de caractere.
SELECT POSITION ('@' IN 'ribafs@gmail.com');  -- Retorna 7
Ou SELECT STRPOS('Ribamar' ,'mar');           -- Retorna 5