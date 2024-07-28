/*
    Explicação co uma versão simplificada:    

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
    Aqui está uma versão simplificada e mais legível da função:

    Esta versão simplificada:abaixo.

    Usa expressões regulares para verificar CPFs com todos os dígitos iguais.
    Utiliza loops FOR mais concisos para os cálculos.
    Usa a expressão CASE para simplificar a lógica de cálculo dos dígitos verificadores.
    Remove as declarações RAISE NOTICE, que eram usadas para depuração.
    Simplifica a lógica de retorno final.
    Esta versão mantém a mesma funcionalidade, mas é mais fácil de ler e entender.

*/

-- FUNÇÃO VALIDA CPF.
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

/*
Explicar  de forma didática e depois apresentar versão simplificada.

Função formata_telefone:
Esta função recebe um número de telefone como uma string de 12 caracteres e retorna o número formatado.

Explicação:

A função recebe um número de telefone no formato "XXXYYYZZZZZZZ".
Ela divide o número em três partes: código de área (XXX), prefixo (YYY) e número (ZZZZZZZ).
Formata o número como "(XXX) YYY-ZZZZZZZ".

Esta versão simplificada:

    * Usa diretamente o parâmetro 'telefone' ao invés de $1.
    * Combina todas as operações em uma única instrução RETURN.
    * Usa a função SUBSTRING de forma mais concisa.

*/
-- FUNÇÃO FORMATA TELEFONE
CREATE OR REPLACE FUNCTION formata_telefone(telefone CHARACTER(12)) RETURNS TEXT AS $$
BEGIN
    RETURN '(' || SUBSTRING(telefone, 1, 3) || ') ' ||
           SUBSTRING(telefone, 4, 3) || '-' ||
           SUBSTRING(telefone, 7);
END;
$$ LANGUAGE plpgsql;

/*
    Função formata_cep:
    Esta função recebe um CEP como uma string de 8 caracteres e retorna o CEP formatado.

    Explicação:

    A função recebe um CEP no formato "XXXYYZZZ".
    Ela divide o CEP em três partes: XX.YYY-ZZZ.
    Formata o CEP como "XX.YYY-ZZZ".
    Versão simplificada:

    Esta versão simplificada:

    Usa diretamente o parâmetro 'cep' ao invés de $1.
    Combina todas as operações em uma única instrução RETURN.
    Usa a função SUBSTRING de forma mais concisa.
    Ambas as funções simplificadas mantêm a mesma funcionalidade das originais, mas são mais concisas e fáceis de ler. Elas utilizam a concatenação de strings (||) e a função SUBSTRING para formatar os números de telefone e CEPs de maneira mais direta.

    Estas funções são úteis para apresentação de dados, garantindo que números de telefone e CEPs sejam exibidos em um formato padronizado e legível, independentemente de como estão armazenados no banco de dados.
*/

CREATE OR REPLACE FUNCTION formata_cep(cep CHARACTER(8)) RETURNS TEXT AS $$
BEGIN
    RETURN SUBSTRING(cep, 1, 2) || '.' ||
           SUBSTRING(cep, 3, 3) || '-' ||
           SUBSTRING(cep, 6);
END;
$$ LANGUAGE plpgsql;