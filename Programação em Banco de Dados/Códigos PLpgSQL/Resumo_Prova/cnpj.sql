/*
    Vamos abordar a lógica das funções e procedures que você implementou, focando em uma explicação didática para quem está começando a estudar bancos de dados.

### Função `aplica_mascara_cnpj()`

**Objetivo**: Aplicar a máscara no CNPJ para formatá-lo de forma padronizada, como `XX.XXX.XXX/0001-XX`.

**Lógica**:
1. **Estrutura do CNPJ**: Um CNPJ é um número de 14 dígitos que deve ser formatado com pontos, barras e traços.
2. **Processo de Mascaramento**:
   - A função usa a função `substring()` para extrair partes do CNPJ.
   - Depois, essas partes são combinadas com os caracteres de formatação (`.` `/` `-`).
   - O resultado é um CNPJ formatado no padrão que vemos em documentos.

**Exemplo**: Se você passar o valor `12345678000195`, a função retornará `12.345.678/0001-95`.

### Função `validar_cnpj()`

**Objetivo**: Verificar se um CNPJ é válido, usando um algoritmo de validação específico.

**Lógica**:
1. **Verificação de Formato**:
   - Primeiro, a função verifica se o CNPJ tem exatamente 14 dígitos.
   - Se não tiver, já sabemos que ele não é válido.

2. **Cálculo dos Dígitos Verificadores**:
   - Um CNPJ é composto por 12 dígitos seguidos de 2 dígitos verificadores.
   - A função recalcula esses dígitos usando um algoritmo específico, que envolve multiplicar cada dígito do CNPJ por um fator e somar os resultados.
   - Depois, essa soma passa por um cálculo mod (`mod 11`), que verifica o dígito verificador.
   - Se o cálculo corresponder aos dígitos verificadores originais do CNPJ, ele é considerado válido.

**Exemplo**: Um CNPJ como `12.345.678/0001-95` será desmascarado para `12345678000195`, e a função calculará se os dígitos `95` estão corretos conforme o algoritmo.

### Importância e Aplicação

Essas funções são muito úteis no dia a dia de um sistema que lida com registros de empresas. A função de mascaramento formata o CNPJ para exibição em relatórios e telas, enquanto a função de validação garante que os dados inseridos sejam corretos, evitando erros e fraudes no cadastro de empresas.

Se precisar de mais detalhes ou exemplos, estou aqui para ajudar!
*/

-- Essa função valida o CNPJ com base nos dígitos verificadores.
-- CREATE OR REPLACE FUNCTION validar_cnpj(cnpj_input VARCHAR)
-- RETURNS BOOLEAN AS $$
-- DECLARE
--     cnpj_digits VARCHAR := regexp_replace(cnpj_input, '\D', '', 'g');
--     digito1 INT; 
--     digito2 INT; 
--     soma INT; 
--     peso INT;
--     digito_verificador VARCHAR;
-- BEGIN
--     -- Verifica se o CNPJ possui 14 dígitos
--     IF LENGTH(cnpj_digits) != 14 THEN
--         RETURN FALSE;
--     END IF;

--     -- Cálculo do primeiro dígito verificador
--     soma := 0;
--     peso := 5;
--     FOR i IN 1..12 LOOP
--         soma := soma + (CAST(SUBSTRING(cnpj_digits FROM i FOR 1) AS INT) * peso);
--         peso := peso - 1;
--         IF peso < 2 THEN
--             peso := 9;
--         END IF;
--     END LOOP;
    
--     digito1 := 11 - (soma % 11);
--     IF digito1 >= 10 THEN
--         digito1 := 0;
--     END IF;

--     -- Cálculo do segundo dígito verificador
--     soma := 0;
--     peso := 6;
--     FOR i IN 1..13 LOOP
--         soma := soma + (CAST(SUBSTRING(cnpj_digits FROM i FOR 1) AS INT) * peso);
--         peso := peso - 1;
--         IF peso < 2 THEN
--             peso := 9;
--         END IF;
--     END LOOP;
    
--     digito2 := 11 - (soma % 11);
--     IF digito2 >= 10 THEN
--         digito2 := 0;
--     END IF;

--     digito_verificador := SUBSTRING(cnpj_digits FROM 13 FOR 2);

--     -- Compara os dígitos verificadores calculados com os fornecidos
--     IF digito1 || digito2 = digito_verificador THEN
--         RETURN TRUE;
--     ELSE
--         RETURN FALSE;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validar_cnpj(cnpj TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    digito1 INT;
    digito2 INT;
    soma INT;
    peso INT;
BEGIN
    -- Lógica para desmascarar o CNPJ e verificar os dígitos
    -- Extrair os 12 primeiros dígitos
    cnpj := REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '/', ''), '-', '');
    
    IF LENGTH(cnpj) != 14 THEN
        RETURN FALSE;
    END IF;
    
    -- Cálculo do primeiro dígito verificador
    soma := 0;
    peso := 5;
    FOR i IN 1..12 LOOP
        soma := soma + (CAST(SUBSTRING(cnpj FROM i FOR 1) AS INT) * peso);
        peso := peso - 1;
        IF peso < 2 THEN
            peso := 9;
        END IF;
    END LOOP;

    digito1 := (soma * 10) % 11;
    IF digito1 = 10 THEN
        digito1 := 0;
    END IF;

    -- Cálculo do segundo dígito verificador
    soma := 0;
    peso := 6;
    FOR i IN 1..13 LOOP
        soma := soma + (CAST(SUBSTRING(cnpj FROM i FOR 1) AS INT) * peso);
        peso := peso - 1;
        IF peso < 2 THEN
            peso := 9;
        END IF;
    END LOOP;

    digito2 := (soma * 10) % 11;
    IF digito2 = 10 THEN
        digito2 := 0;
    END IF;

    -- Verificação final
    IF digito1 = CAST(SUBSTRING(cnpj FROM 13 FOR 1) AS INT) AND 
       digito2 = CAST(SUBSTRING(cnpj FROM 14 FOR 1) AS INT) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Para validar um CNPJ:
SELECT validar_cnpj('12.345.678/0001-95');

-- Essa função formata o CNPJ para o formato XX.XXX.XXX/XXXX-XX.
CREATE OR REPLACE FUNCTION mascarar_cnpj(cnpj_input VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    cnpj_formatado VARCHAR;
BEGIN
    -- Verifica se o CNPJ possui 14 dígitos
    IF LENGTH(cnpj_input) = 14 THEN
        cnpj_formatado := 
            SUBSTRING(cnpj_input FROM 1 FOR 2) || '.' ||
            SUBSTRING(cnpj_input FROM 3 FOR 3) || '.' ||
            SUBSTRING(cnpj_input FROM 6 FOR 3) || '/' ||
            SUBSTRING(cnpj_input FROM 9 FOR 4) || '-' ||
            SUBSTRING(cnpj_input FROM 13 FOR 2);
    ELSE
        RAISE EXCEPTION 'CNPJ inválido. Deve conter 14 dígitos.';
    END IF;
    
    RETURN cnpj_formatado;
END;
$$ LANGUAGE plpgsql;

-- Exemplo de uso: Para aplicar a máscara:
SELECT mascarar_cnpj('12345678000195');
