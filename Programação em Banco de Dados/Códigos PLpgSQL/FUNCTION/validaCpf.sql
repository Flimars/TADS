/*
Este código cria uma função chamada valida_cpf que recebe um CPF como entrada (uma string de 11 caracteres) e retorna um booleano (verdadeiro ou falso) indicando se o CPF é válido ou não.

Explicação por partes:

Verificação inicial:
Verifica se o CPF tem menos de 11 dígitos. Se sim, retorna falso.
Verifica se todos os dígitos são iguais (ex: 11111111111). Se sim, retorna falso.
Cálculo do primeiro dígito verificador:
Multiplica os 9 primeiros dígitos por pesos de 10 a 2.
Soma os resultados.
Calcula o resto da divisão por 11.
Se o resto for menor que 2, o dígito é 0. Senão, é 11 menos o resto.
Cálculo do segundo dígito verificador:
Similar ao primeiro, mas inclui o primeiro dígito verificador.
Multiplica os 10 primeiros dígitos por pesos de 11 a 2.
Verificação final:
Compara os dígitos calculados com os dois últimos dígitos do CPF fornecido.
Esta versão simplificada:

Usa expressões regulares para verificar CPFs com todos os dígitos iguais.
Utiliza loops FOR mais concisos para os cálculos.
Usa a expressão CASE para simplificar a lógica de cálculo dos dígitos verificadores.
Remove as declarações RAISE NOTICE, que eram usadas para depuração.
Simplifica a lógica de retorno final.
Esta versão mantém a mesma funcionalidade, mas é mais fácil de ler e entender.

*/
CREATE OR REPLACE FUNCTION valida_cpf(cpf CHARACTER(11)) RETURNS BOOLEAN AS $$
DECLARE
    soma INTEGER;
    resto INTEGER;
    digito1 INTEGER;
    digito2 INTEGER;
BEGIN
    -- Verifica se o CPF tem 11 dígitos
    IF LENGTH(cpf) != 11 THEN
        RETURN FALSE;
    END IF;

    -- Verifica se todos os dígitos são iguais
    IF cpf ~ '^(\d)\1{10}$' THEN
        RETURN FALSE;
    END IF;

    -- Calcula o primeiro dígito verificador
    soma := 0;
    FOR i IN 1..9 LOOP
        soma := soma + (SUBSTRING(cpf FROM i FOR 1)::INTEGER * (11 - i));
    END LOOP;
    resto := soma % 11;
    digito1 := CASE WHEN resto < 2 THEN 0 ELSE 11 - resto END;

    -- Calcula o segundo dígito verificador
    soma := 0;
    FOR i IN 1..10 LOOP
        soma := soma + (SUBSTRING(cpf FROM i FOR 1)::INTEGER * (12 - i));
    END LOOP;
    resto := soma % 11;
    digito2 := CASE WHEN resto < 2 THEN 0 ELSE 11 - resto END;

    -- Verifica se os dígitos calculados são iguais aos do CPF
    RETURN SUBSTRING(cpf FROM 10 FOR 1)::INTEGER = digito1 
       AND SUBSTRING(cpf FROM 11 FOR 1)::INTEGER = digito2;
END;
$$ LANGUAGE plpgsql;