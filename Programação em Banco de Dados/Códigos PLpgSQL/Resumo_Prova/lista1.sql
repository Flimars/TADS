/*
    Explicação com uma versão simplificada:    

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
-- *1. Implementar uma Máscara de Telefone: A máscara pode ser aplicada ao inserir ou consultar dados.
-- MODO 1:
CREATE OR REPLACE FUNCTION aplicar_mascara_telefone(telefone TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN '(' || SUBSTRING(telefone, 1, 2) || ') ' || SUBSTRING(telefone, 3, 4) || '-' || SUBSTRING(telefone, 7, 4);
END;
$$ LANGUAGE plpgsql;
-- MODO 2:
-- FUNÇÃO FORMATA TELEFONE
CREATE OR REPLACE FUNCTION formata_telefone(telefone CHARACTER(12)) RETURNS TEXT AS $$
BEGIN
    RETURN '(' || SUBSTRING(telefone, 1, 3) || ') ' ||
           SUBSTRING(telefone, 4, 3) || '-' ||
           SUBSTRING(telefone, 7);
END;
$$ LANGUAGE plpgsql;
-- *2. Máscara de Cep: Semelhante à máscara de telefone.
CREATE OR REPLACE FUNCTION aplicar_mascara_cep(cep TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN SUBSTRING(cep, 1, 5) || '-' || SUBSTRING(cep, 6, 3);
END;
$$ LANGUAGE plpgsql;

-- 3. Validar CEP? É possível? SIM
-- *4. Validação e Máscara de CPF: Validar se o CEP é composto por 8 dígitos.
CREATE OR REPLACE FUNCTION validar_cep(cep TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN LENGTH(cep) = 8 AND cep ~ '^[0-9]+$';
END;
$$ LANGUAGE plpgsql;

-- FUNÇÃO VALIDA CPF (MODO 1).
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

-- Validação básica do CPF (11 dígitos) e aplicação da máscara(MODO 2).
CREATE OR REPLACE FUNCTION aplicar_mascara_cpf(cpf TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN SUBSTRING(cpf, 1, 3) || '.' || SUBSTRING(cpf, 4, 3) || '.' || SUBSTRING(cpf, 7, 3) || '-' || SUBSTRING(cpf, 10, 2);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validar_cpf(cpf TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN LENGTH(cpf) = 11 AND cpf ~ '^[0-9]+$';
END;
$$ LANGUAGE plpgsql;

-- *5. Stored Procedure que retorne os agendamentos anteriores de um paciente
CREATE OR REPLACE FUNCTION listar_agendamentos_anteriores(paciente_id INTEGER)
RETURNS TABLE(
    atendimento_id INTEGER,
    fisioterapeuta_nome TEXT,
    data_hora_inicio TIMESTAMP,
    data_hora_fim TIMESTAMP,
    observacao TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id,
        f.nome,
        a.data_hora_inicio,
        a.data_hora_fim,
        a.observacao
    FROM 
        atendimento a
    INNER JOIN 
        fisioterapeuta f ON a.fisioterapeuta_id = f.id
    WHERE 
        a.paciente_id = paciente_id
        AND a.data_hora_inicio < NOW()
    ORDER BY 
        a.data_hora_inicio DESC;
END;
$$ LANGUAGE plpgsql;

-- *6. Stored Procedure que determina o paciente que mais realizou atendimentos
CREATE OR REPLACE FUNCTION paciente_mais_atendimentos()
RETURNS TABLE(
    paciente_id INTEGER,
    nome TEXT,
    quantidade_atendimentos INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.nome,
        COUNT(a.id) AS quantidade_atendimentos
    FROM 
        paciente p
    INNER JOIN 
        atendimento a ON a.paciente_id = p.id
    GROUP BY 
        p.id
    ORDER BY 
        quantidade_atendimentos DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- *7. Stored Procedure que determina o fisioterapeura que mais realizou atendimentos
CREATE OR REPLACE FUNCTION fisioterapeuta_mais_atendimentos()
RETURNS TABLE(
    fisioterapeuta_id INTEGER,
    nome TEXT,
    quantidade_atendimentos INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.id,
        f.nome,
        COUNT(a.id) AS quantidade_atendimentos
    FROM 
        fisioterapeuta f
    INNER JOIN 
        atendimento a ON a.fisioterapeuta_id = f.id
    GROUP BY 
        f.id
    ORDER BY 
        quantidade_atendimentos DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- **8. Stored Procedure que gere um relatório de faturamento (do dia, da semana, do mês e do ano)
CREATE OR REPLACE FUNCTION relatorio_faturamento(periodo TEXT)
RETURNS TABLE(
    periodo TEXT,
    faturamento MONEY
) AS $$
BEGIN
    IF periodo = 'dia' THEN
        RETURN QUERY
        SELECT 
            TO_CHAR(a.data_hora_inicio, 'YYYY-MM-DD') AS periodo,
            SUM(a.valor_consulta) AS faturamento
        FROM 
            atendimento a
        WHERE 
            a.data_hora_inicio::DATE = CURRENT_DATE
        GROUP BY 
            TO_CHAR(a.data_hora_inicio, 'YYYY-MM-DD');
    ELSIF periodo = 'semana' THEN
        RETURN QUERY
        SELECT 
            TO_CHAR(a.data_hora_inicio, 'IYYY-IW') AS periodo,
            SUM(a.valor_consulta) AS faturamento
        FROM 
            atendimento a
        WHERE 
            a.data_hora_inicio::DATE >= CURRENT_DATE - INTERVAL '7 days'
        GROUP BY 
            TO_CHAR(a.data_hora_inicio, 'IYYY-IW');
    ELSIF periodo = 'mes' THEN
        RETURN QUERY
        SELECT 
            TO_CHAR(a.data_hora_inicio, 'YYYY-MM') AS periodo,
            SUM(a.valor_consulta) AS faturamento
        FROM 
            atendimento a
        WHERE 
            EXTRACT(MONTH FROM a.data_hora_inicio) = EXTRACT(MONTH FROM CURRENT_DATE)
        GROUP BY 
            TO_CHAR(a.data_hora_inicio, 'YYYY-MM');
    ELSIF periodo = 'ano' THEN
        RETURN QUERY
        SELECT 
            EXTRACT(YEAR FROM a.data_hora_inicio) AS periodo,
            SUM(a.valor_consulta) AS faturamento
        FROM 
            atendimento a
        WHERE 
            EXTRACT(YEAR FROM a.data_hora_inicio) = EXTRACT(YEAR FROM CURRENT_DATE)
        GROUP BY 
            EXTRACT(YEAR FROM a.data_hora_inicio);
    ELSE
        RAISE EXCEPTION 'Período inválido. Utilize dia, semana, mes, ou ano.';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- **9. Mês mais rentável dado um ano
CREATE OR REPLACE FUNCTION mes_mais_rentavel(ano INTEGER)
RETURNS TABLE(
    mes TEXT,
    faturamento MONEY
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        TO_CHAR(a.data_hora_inicio, 'YYYY-MM') AS mes,
        SUM(a.valor_consulta) AS faturamento
    FROM 
        atendimento a
    WHERE 
        EXTRACT(YEAR FROM a.data_hora_inicio) = ano
    GROUP BY 
        TO_CHAR(a.data_hora_inicio, 'YYYY-MM')
    ORDER BY 
        faturamento DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- **10. Qual o melhor fisioterapeuta -> data inicio - data fim
CREATE OR REPLACE FUNCTION melhor_fisioterapeuta(data_inicio DATE, data_fim DATE)
RETURNS TABLE(fisioterapeuta_id INTEGER, nome VARCHAR, media_nota NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.id AS fisioterapeuta_id,
        f.nome,
        AVG(a.nota) AS media_nota
    FROM 
        fisioterapeuta f
    JOIN 
        atendimento a ON f.id = a.fisioterapeuta_id
    WHERE 
        a.data_hora_inicio BETWEEN data_inicio AND data_fim
    GROUP BY 
        f.id, f.nome
    ORDER BY 
        media_nota DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- **11. Qual o fisioterapeuta que mais atendeu -> data inicio data fim
CREATE OR REPLACE FUNCTION fisioterapeuta_mais_atendimentos(data_inicio DATE, data_fim DATE)
RETURNS TABLE(fisioterapeuta_id INTEGER, nome VARCHAR, total_atendimentos INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.id AS fisioterapeuta_id,
        f.nome,
        COUNT(a.id) AS total_atendimentos
    FROM 
        fisioterapeuta f
    JOIN 
        atendimento a ON f.id = a.fisioterapeuta_id
    WHERE 
        a.data_hora_inicio BETWEEN data_inicio AND data_fim
    GROUP BY 
        f.id, f.nome
    ORDER BY 
        total_atendimentos DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- **12. Qual o paciente que mais frequentou -> quem mais veio atendimento Atendimento com mais horas Média de horas por atendimento
CREATE OR REPLACE FUNCTION paciente_frequencia_horas()
RETURNS TABLE(paciente_id INTEGER, nome VARCHAR, total_atendimentos INTEGER, atendimento_mais_horas NUMERIC, media_horas NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id AS paciente_id,
        p.nome,
        COUNT(a.id) AS total_atendimentos,
        MAX(EXTRACT(EPOCH FROM (a.data_hora_fim - a.data_hora_inicio)) / 3600) AS atendimento_mais_horas,
        AVG(EXTRACT(EPOCH FROM (a.data_hora_fim - a.data_hora_inicio)) / 3600) AS media_horas
    FROM 
        paciente p
    JOIN 
        atendimento a ON p.id = a.paciente_id
    GROUP BY 
        p.id, p.nome
    ORDER BY 
        total_atendimentos DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- **13. Faturamento -> mes, ano da clinica Remuneração -> por mes, por ano de cada fisio último que tem maior nota possível
CREATE OR REPLACE FUNCTION faturamento_clinica_remuneracao_fisio(mes INTEGER, ano INTEGER)
RETURNS TABLE(tipo VARCHAR, valor MONEY) AS $$
BEGIN
    -- Faturamento da Clínica
    RETURN QUERY
    SELECT 
        'Faturamento Clínica' AS tipo,
        SUM(a.valor_consulta) AS valor
    FROM 
        atendimento a
    WHERE 
        EXTRACT(MONTH FROM a.data_hora_inicio) = mes 
        AND EXTRACT(YEAR FROM a.data_hora_inicio) = ano;

    -- Remuneração dos Fisioterapeutas
    RETURN QUERY
    SELECT 
        'Remuneração Fisioterapeuta: ' || f.nome AS tipo,
        SUM(a.valor_por_hora_fisioterapeuta) AS valor
    FROM 
        atendimento a
    JOIN 
        fisioterapeuta f ON f.id = a.fisioterapeuta_id
    WHERE 
        EXTRACT(MONTH FROM a.data_hora_inicio) = mes 
        AND EXTRACT(YEAR FROM a.data_hora_inicio) = ano
    GROUP BY 
        f.nome;
END;
$$ LANGUAGE plpgsql;

-- **14. Média das avaliações por fisioterapeutas
CREATE OR REPLACE FUNCTION media_avaliacoes_fisioterapeutas()
RETURNS TABLE(fisioterapeuta_id INTEGER, nome VARCHAR, media_nota NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.id AS fisioterapeuta_id,
        f.nome,
        AVG(a.nota) AS media_nota
    FROM 
        fisioterapeuta f
    JOIN 
        atendimento a ON f.id = a.fisioterapeuta_id
    GROUP BY 
        f.id, f.nome
    ORDER BY 
        media_nota DESC;
END;
$$ LANGUAGE plpgsql;

-- **15. Um stored procedure que crie um novo atendimento e que atribuia, automaticamente, o fim de um atendimento para 2 horas após o início
CREATE OR REPLACE FUNCTION criar_atendimento(fisioterapeuta_id INTEGER, paciente_id INTEGER, data_hora_inicio TIMESTAMP, observacao TEXT, nota INTEGER, valor_por_hora_fisioterapeuta MONEY)
RETURNS VOID AS $$
BEGIN
    INSERT INTO atendimento (fisioterapeuta_id, paciente_id, data_hora_inicio, data_hora_fim, observacao, nota, valor_consulta, valor_por_hora_fisioterapeuta)
    VALUES (
        fisioterapeuta_id, 
        paciente_id, 
        data_hora_inicio, 
        data_hora_inicio + INTERVAL '2 hours', 
        observacao, 
        nota, 
        valor_por_hora_fisioterapeuta * 2, 
        valor_por_hora_fisioterapeuta
    );
END;
$$ LANGUAGE plpgsql;

-- **16. Liste os fisitorapeutas que não realizaram atendimentos em um determinado período de tempo
CREATE OR REPLACE FUNCTION fisioterapeutas_sem_atendimentos(data_inicio DATE, data_fim DATE)
RETURNS TABLE(fisioterapeuta_id INTEGER, nome VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.id AS fisioterapeuta_id,
        f.nome
    FROM 
        fisioterapeuta f
    WHERE 
        NOT EXISTS (
            SELECT 1 
            FROM atendimento a 
            WHERE a.fisioterapeuta_id = f.id 
            AND a.data_hora_inicio BETWEEN data_inicio AND data_fim
        );
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