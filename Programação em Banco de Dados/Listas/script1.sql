/*
    Lista 1
1. Máscara de Telefone

2. Máscara de Cep

3. Validar CEP? É possível?

4. Validação e Máscara de CPF

5. Stored Procedure que retorne os agendamentos anteriores de um paciente

6. Stored Procedure que determina o paciente que mais realizou atendimentos

7. Stored Procedure que determina o fisioterapeura que mais realizou atendimentos

8. Stored Procedure que gere um relatório de faturamento (do dia, da semana, do mês e do ano)

9. Mês mais rentável dado um ano

10. Qual o melhor fisioterapeuta -> data inicio - data fim

11. Qual o fisioterapeuta que mais atendeu -> data inicio data fim

12. Qual o paciente que mais frequentou -> quem mais veio atendimento Atendimento com mais horas Média de horas por atendimento

13. Faturamento -> mes, ano da clinica Remuneração -> por mes, por ano de cada fisio último que tem maior nota possível

14. Média das avaliações por fisioterapeutas

15. Um stored procedure que crie um novo atendimento e que atribuia, automaticamente, o fim de um atendimento para 2 horas após o início

16. Liste os fisitorapeutas que não realizaram atendimentos em um determinado período de tempo

*/

DROP DATABASE IF EXISTS toquebrado;
CREATE DATABASE toquebrado;

\c toquebrado;

CREATE TABLE paciente(
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(100) NOT NULL,
    cpf CHARACTER(11) UNIQUE,
    telefone CHARACTER(12),
    bairro TEXT,
    rua TEXT,
    complemento TEXT,
    numero TEXT,
    cep CHARACTER(8)
);

INSERT INTO paciente (nome, cpf, telefone, bairro, rua, complemento, numero, cep)
VALUES
    ('Lucas Rossales', '11122233344', '519990099', 'Centro', 'Rua A', 'Apto 101', '123', '12345678'),   
    ('Pedro Almeida', '87654321098', '21987654321', 'Centro', 'Rua das Flores', 'Ap. 101', '10', '20030000'),
    ('Luciana Ferreira', '76543210987', '22654321098', 'Jardim', 'Avenida das Palmas', 'Bloco B', '202', '22050001'),
    ('Rafael Mendonca', '65432109876', '23543210987', 'Vila', 'Travessa dos Passaros', 'Lado A', '203', '23060002'),
    ('Gabriel Ribeiro', '54321098765', '24432109876', 'Santa Tereza', 'Estrada dos Ipes', 'Casa 104', '204', '24070003'),
    ('Maria Isabel', '43210987654', '53321098765', 'Pina', 'Alameda das Mangueiras', 'Lado Impar', '665', '96200214'),
    ('Karla Bittencurt', '70794835066', '53321098765', 'Pinhal', 'Francisco Pastore', 'Casa', '251', '96211014'),
    ('Emerson Goncalves', '86027618051', '53321098765', 'Parque Marinha', 'Atol das Rocas', 'Casa', '153', '96202350'),
    ('Cristiano Azevedo', '89313155036', '53321098765', 'Cidade Nova', 'Tiradentes', 'Apto 205', '225', '96202060'),
    ('Yasmim Saraiva', '96747262093', '54321098765', 'Centro', 'Galopoles', 'Casa', '2631', '95050000'),
    ('Priscila Alvares', '32643310047', '51321098765', 'Santa Tereza', 'Vila Mangueiras', 'Casa', '705', '92450690'),
    ('Cleinton Machado', '98508461003', '51321098765', 'Parque Marinha', 'Independencia', 'Lado Par', '880', '90830492'),
    ('Hugo Souza', '22310801097', '51321098765', 'Juncao', 'Henrique Dias', 'Casa', '111', '92110042'),
    ('Alice Sanches', '66024071043', '54321098765', 'Centro', 'Bento Goncalves', 'Casa', '451', '25045110');


CREATE TABLE fisioterapeuta(
     id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(100) NOT NULL,
    cpf CHARACTER(11) UNIQUE,
    crefito TEXT NOT NULL,
    valor_por_hora MONEY
);

INSERT INTO fisioterapeuta (nome, cpf, crefito, valor_por_hora)
VALUES
    ('Jonas', '12345678901', 'CRF1234', 80),
    ('Maria', '98765432101', 'CRF5678', 90),
    ('Pedro', '11122233344', 'CRF9876', 75),
    ('Ana', '55566677788', 'CRF5432', 85),
    ('Carlos', '99988877766', 'CRF2468', 70);


CREATE TABLE atendimento(
    id SERIAL PRIMARY KEY,
    fisioterapeuta_id INTEGER REFERENCES fisioterapeuta(id),
    paciente_id INTEGER REFERENCES paciente(id),
    data_hora_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_hora_fim TIMESTAMP,
    observacao TEXT,
    nota INTEGER CHECK(nota > 0 and nota <= 5),
    valor_consulta MONEY DEFAULT 100,
    valor_por_hora_fisioterapeuta MONEY
);

INSERT INTO atendimento (fisioterapeuta_id, paciente_id, data_hora_inicio, data_hora_fim, observacao, nota, valor_por_hora_fisioterapeuta)
VALUES
    (2, 3, '2023-10-27 14:30:09', '2023-10-27 15:28:39', 'Acompanhamento pos-cirurgico', 5, 90),    
    (1, 1, '2023-04-01 14:38:42', '2023-04-01 15:38:42', 'Atendimento normal', 5, 150.00),
    (2, 2, '2023-04-02 16:28:12', '2023-04-02 17:28:02', 'Atendimento com dificuldade', 4, 120.00),
    (3, 3, '2023-04-03 18:18:06', '2023-04-03 19:18:00', 'Atendimento eficiente', 5, 180.00),
    (4, 4, '2023-04-04 20:18:36', '2023-04-04 21:18:36', 'Atendimento tranquilo', 4, 160.00),
    (5, 5, '2023-04-05 22:05:36', '2023-04-06 00:05:16', 'Atendimento prolongado', 5, 140.00),
    (5, 1, '2024-4-07 08:00:00', '2024-4-07 09:00:00', 'Atendimento matinal', 5, 150.00),
    (2, 8, '2024-4-08 10:00:00', '2024-4-08 11:00:00', 'Atendimento diurno', 4, 120.00),
    (3, 13, '2024-05-09 12:00:00', '2024-05-09 13:00:00', 'Atendimento vespertino', 5, 180.00),
    (1, 4, '2024-05-10 14:00:00', '2024-05-10 15:00:00', 'Atendimento a tarde', 4, 160.00),
    (5, 5, '2024-06-11 16:00:00', '2024-06-11 17:00:00', 'Atendimento noturno', 5, 140.00),
    (1, NULL, '2024-07-12 18:00:00', '2024-07-12 19:00:00', 'Fisioterapeuta sem atendimento', NULL, NULL),
    (2, 6, '2024-07-13 20:00:00', '2024-07-13 21:00:00', 'Atendimento especial', 5, 150.00),
    (3, 7, '2024-07-14 22:00:00', '2024-07-15 00:00:00', 'Atendimento prolongado', 4, 120.00),
    (4, 8, '2024-07-15 08:00:00', '2024-07-15 09:00:00', 'Atendimento matinal', 5, 180.00),
    (5, 9, '2024-07-16 10:00:00', '2024-07-16 11:00:00', 'Atendimento diurno', 4, 160.00),
    (2, 10, '2024-07-17 12:00:00', '2024-07-17 13:00:00', 'Atendimento vespertino', 5, 140.00),
    (3, 11, '2024-07-18 14:00:00', '2024-07-18 15:00:00', 'Atendimento a tarde', 4, 150.00),
    (4, 12, '2024-07-19 16:00:00', '2024-07-19 17:00:00', 'Atendimento noturno', 5, 120.00),
    (5, 13, '2024-07-20 18:00:00', '2024-07-20 19:00:00', 'Atendimento especial', 5, 180.00),
    (5, 14, '2024-07-21 20:00:00', '2024-07-21 21:00:00', 'Atendimento prolongado', 4, 160.00);

--==============================================================================================
-- EXERCÍCIOS:

-- 1. Máscara de telefone: criar uma função que mostre os telefones formatados: Ex.: (53)3235-7799
CREATE OR REPLACE FUNCTION formata_telefone(telefone CHARACTER(12)) RETURNS TEXT AS $$
BEGIN
    RETURN '(' || SUBSTRING(telefone, 1, 3) || ') ' ||
           SUBSTRING(telefone, 4, 3) || '-' ||
           SUBSTRING(telefone, 7);
END;
$$ LANGUAGE plpgsql;

-- 2. Máscara de CEP: criar uma função que mostre os ceps formatados: Ex.: 96.214-200
CREATE OR REPLACE FUNCTION formata_cep(cep CHARACTER(8)) RETURNS TEXT AS $$
BEGIN
    RETURN SUBSTRING(cep, 1, 2) || '.' ||
           SUBSTRING(cep, 3, 3) || '-' ||
           SUBSTRING(cep, 6);
END;
$$ LANGUAGE plpgsql;
-- 3. Validação e Máscara de CPF: criar uma função que mostre os CPFs formatados: Ex.: 952.818.086-75
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

    ** Esta função:

    Recebe um parâmetro do tipo character (provavelmente um CPF)
    Retorna uma tabela com duas colunas: data_hora_inicio e data_hora_fim
    Busca todos os atendimentos de um paciente específico, identificado pelo CPF

    ** Para usar esta função, você pode fazer uma chamada como:

        SELECT * FROM atendimentos_anteriores('123.456.789-00');

    Isso retornará todas as datas de início e fim dos atendimentos para o paciente com o CPF especificado.

    Esta função é útil para rapidamente recuperar o histórico de atendimentos de um paciente específico sem ter que escrever a query completa toda vez que precisar dessa informação.

    Quanto à parte do ALTER FUNCTION para mudar o owner, isso é uma prática comum em scripts gerados pelo pg_dump para garantir que as permissões sejam corretamente configuradas quando o banco de dados for restaurado.    

*/

CREATE OR REPLACE FUNCTION atendimentos_anteriores(character)
RETURNS TABLE(data_hora_inicio timestamp without time zone, data_hora_fim timestamp without time zone)
AS $$
BEGIN
    RETURN QUERY 
    SELECT atendimento.data_hora_inicio, atendimento.data_hora_fim 
    FROM paciente 
    INNER JOIN atendimento ON (paciente.id = atendimento.paciente_id) 
    WHERE paciente.cpf = $1;
END;
$$ LANGUAGE plpgsql;

--CHAMADA DA FUNÇÃO
SELECT * FROM atendimentos_anteriores('123.456.789-00');


/*
    Vou refactorizar o código para o tornar mais legível e limpo e depois explico-o. Aqui está a versão refactorada:
    Agora, deixe-me explicar o código refatorado:

    ** Declaração de função:

    O nome da função e o tipo de retorno permanecem os mesmos.
    Alteramos 'plpgsql' para plpgsql (sem aspas), pois é a maneira padrão de especificar a linguagem.
    Expressões de tabela comuns (CTEs):
    ** Introduzimos dois CTEs para tornar a lógica mais clara e modular:

        a. atendimentos_por_paciente: Este CTE calcula o número de consultas para cada paciente.
        b. max_atendimentos: Este CTE encontra o número máximo de atendimentos entre todos os pacientes.

    ** Consulta Principal:

    A consulta principal seleciona a partir de atendimentos_por_paciente e max_atendimentos.
    Ela filtra para incluir apenas os pacientes com o número máximo de consultas.
    Os resultados são ordenados por ID do paciente.

    ** Melhorias na legibilidade:

    Utilizámos aliases significativos (p para paciente, a para atendimento).
    A consulta está devidamente recuada e formatada para melhor legibilidade.
    Separamos a lógica em etapas distintas usando CTEs, tornando-a mais fácil de entender e manter.

    ** Considerações sobre desempenho:

    Ao usar CTEs, evitamos a repetição de cálculos complexos, melhorando potencialmente o desempenho.
    Esta versão refatorada alcança o mesmo resultado que a função original, mas é mais legível e de fácil manutenção. Ela separa claramente as etapas de:

    1. Calcular as consultas por doente
    2. Encontrar o número máximo de consultas
    3. Seleção de doentes com esse número máximo
    Esta estrutura torna a lógica mais fácil de compreender e modificar, se necessário, no futuro.
*/

CREATE OR REPLACE FUNCTION paciente_nro_atendimentos() 
RETURNS TABLE(id INTEGER, nome VARCHAR(100), qtde BIGINT) AS
$$
BEGIN
    RETURN QUERY
    WITH atendimentos_por_paciente AS (
        SELECT 
            p.id,
            p.nome,
            COUNT(*) AS qtde_atendimentos
        FROM 
            paciente p
            INNER JOIN atendimento a ON a.paciente_id = p.id
        GROUP BY 
            p.id, p.nome
    ),
    max_atendimentos AS (
        SELECT MAX(qtde_atendimentos) AS max_qtde
        FROM atendimentos_por_paciente
    )
    SELECT 
        ap.id,
        ap.nome,
        ap.qtde_atendimentos AS qtde
    FROM 
        atendimentos_por_paciente ap,
        max_atendimentos m
    WHERE 
        ap.qtde_atendimentos = m.max_qtde
    ORDER BY 
        ap.id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM paciente_nro_atendimentos();

/*
    Com certeza! Posso melhorar este código para o tornar mais conciso, legível e eficiente. Aqui está uma versão melhorada da função:

    Passo a explicar as melhorias:

    ** Parâmetro da função:
    Nomeámos o parâmetro de entrada duracao em vez de usar $1. Isto melhora a legibilidade.
    Especificamos explicitamente o tipo de entrada como INTERVALO.

    ** Cálculo simplificado:
    Em vez de extrair separadamente horas e minutos, usamos EXTRACT(EPOCH FROM duracao) para obter o número total de segundos.
    Depois dividimos por 3600.0 (número de segundos numa hora) para converter em horas.
    Essa abordagem é mais precisa, pois também leva em conta quaisquer segundos no intervalo.

    ** Remoção de variáveis desnecessárias:
    As variáveis intermediárias horas e minutos não são mais necessárias.

    ** Declaração de retorno única:
    A função agora usa uma única instrução RETURN, tornando-a mais concisa.

    ** Comentários removidos:
    O código comentado e as instruções de depuração (RAISE NOTICE) foram removidos para fins de limpeza.

    ** Especificação da linguagem:
    Alterado 'plpgsql' para plpgsql (sem aspas), pois é a forma padrão de especificar a linguagem.
    Esta versão melhorada é mais eficiente e mais fácil de ler. Converte diretamente o intervalo para horas (como um número real) numa única operação, o que é mais preciso e mais rápido do que a abordagem original de separar horas e minutos.

    A função devolverá agora um número real que representa o número total de horas, incluindo as partes fraccionárias dos minutos e segundos. Por exemplo, 2 horas e 30 minutos retornaria 2,5, e 1 hora, 15 minutos e 30 segundos retornaria aproximadamente 1,2583.

*/

CREATE OR REPLACE FUNCTION transforma_para_horas(duracao INTERVAL) 
RETURNS REAL AS
$$
BEGIN
    RETURN EXTRACT(EPOCH FROM duracao) / 3600.0;
END;
$$ LANGUAGE plpgsql;

-- CHAMADAS DA FUNÇÕES
SELECT transforma_para_horas(INTERVAL '2 hours 30 minutes');

SELECT id, observacao, transforma_para_horas(INTERVAL '2 hours 15 minutes') AS duracao_horas
FROM atendimento;

SELECT *
FROM atendimento
WHERE transforma_para_horas(INTERVAL '1 hour') < 2;

/*
    Com certeza! Vamos melhorar essa função para torná-la mais eficiente, legível e de fácil manutenção. Aqui está uma versão refatorada da função faturamento_por_mes:

    ** Vejamos as melhorias:

    ** Parâmetro da função:
    Nomeamos o parâmetro de entrada mes em vez de usar $1. Isso melhora a legibilidade.

    ** Cálculo simplificado:
    Em vez de usar um loop, usamos uma única consulta SQL com SUM() para calcular o total.
    Esta abordagem é geralmente mais eficiente, uma vez que aproveita as capacidades de otimização do motor da base de dados.

    ** Remoção de variáveis desnecessárias:
    A variável registro não é mais necessária.

    ** Declaração de depuração removida:
    A instrução RAISE NOTICE foi removida. Se a depuração for necessária, é melhor usar uma função de depuração separada ou ativar o registro de consultas do PostgreSQL.

    ** Tratamento de NULL:
    Nós usamos COALESCE() para garantir que retornamos 0 (como dinheiro) se não houver registros correspondentes, ao invés de NULL.
    
    ** Especificação da Linguagem:
    Mudamos 'plpgsql' para plpgsql (sem aspas), pois é a maneira padrão de especificar a linguagem.

    ** Melhoria da legibilidade:
    A consulta SQL está formatada para uma melhor legibilidade.
    Esta versão melhorada é mais concisa e provavelmente mais eficiente, especialmente para conjuntos de dados maiores. Ela calcula o faturamento total de um determinado mês em uma única operação de banco de dados, em vez de buscar linhas uma a uma e somá-las em PL/pgSQL.

    Para utilizar esta função, pode chamá-la da seguinte forma:

        SELECT faturamento_por_mes(1); -- Para janeiro
        SELECT faturamento_por_mes(12); -- Para dezembro

    Esta função retornará o faturamento total do mês especificado, levando em conta o valor da consulta e o valor da hora do fisioterapeuta multiplicado pela duração de cada atendimento.

*/

CREATE OR REPLACE FUNCTION faturamento_por_mes(mes INTEGER) 
RETURNS MONEY AS
$$
DECLARE
    somatorio MONEY;
BEGIN
    SELECT COALESCE(SUM(
        valor_consulta + 
        valor_por_hora_fisioterapeuta * 
        transforma_para_horas(data_hora_fim - data_hora_inicio)
    ), 0::MONEY) INTO somatorio
    FROM atendimento
    WHERE EXTRACT(MONTH FROM data_hora_inicio) = mes
    AND data_hora_fim IS NOT NULL;

    RETURN somatorio;
END;
$$ LANGUAGE plpgsql;

-- CHAMADAS DA FUNÇÃO
SELECT faturamento_por_mes(6);
SELECT * FROM faturamento_por_mes(7);



