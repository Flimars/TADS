DROP DATABASE IF EXISTS lista15;

CREATE DATABASE lista15;

\c lista15;

CREATE TABLE cliente (
id serial primary key,
cpf character(11),
nome text,
rg character(11),
sexo char(1),
uf char(2)
);

INSERT INTO cliente (cpf, nome, rg, sexo, uf) VALUES
('12345678901', 'João Silva', '123456789', 'M', 'SP'),
('23456789012', 'Maria Santos', '234567890', 'F', 'RJ'),
('34567890123', 'Pedro Oliveira', '345678901', 'M', 'MG'),
('45678901234', 'Ana Rodrigues', '456789012', 'F', 'RS'),
('56789012345', 'Carlos Ferreira', '567890123', 'M', 'PR');

CREATE TABLE operadora (
id serial primary key,
nome text,
cnpj character(14)
);

INSERT INTO operadora (nome, cnpj) VALUES
('TeleBrasil', '12345678000101'),
('ConectaMais', '23456789000102'),
('FoneRápido', '34567890000103'),
('LinkTotal', '45678901000104'),
('TelecomBR', '56789012000105');

-- 02/06/2022 19:05 Listas · IgorAvilaPereira/bd2022_1sem Wiki

-- https://github.com/IgorAvilaPereira/bd2022_1sem/wiki/Listas#lista-14---store-procedure 3/14


-- 3. Crie uma procedure que receberá um RA (Registro Acadêmico),um NOME e quatro
-- notas conforme a sequência:
CREATE TABLE plano (
id serial primary key,
valor real,
descricao text,
operadora_id integer references operadora (id)
);

INSERT INTO plano (valor, descricao, operadora_id) VALUES
(49.90, 'Plano Básico', 1),
(69.90, 'Plano Intermediário', 2),
(99.90, 'Plano Avançado', 3),
(129.90, 'Plano Premium', 4),
(39.90, 'Plano Econômico', 5);

CREATE TABLE telefone (
id serial primary key,
numero text,
cliente_id integer references cliente (id)
);

INSERT INTO telefone (numero, cliente_id) VALUES
('11987654321', 1),
('21976543210', 2),
('31965432109', 3),
('51954321098', 4),
('41943210987', 5);

CREATE TABLE contrato (
id serial primary key,
plano_id integer references plano (id),
telefone_id integer references telefone (id),
data_inicio date DEFAULT CURRENT_DATE,
data_fim date,
valor_final real
);

INSERT INTO contrato (plano_id, telefone_id, data_inicio, data_fim, valor_final) VALUES
(1, 1, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year', 49.90),
(2, 2, CURRENT_DATE, CURRENT_DATE + INTERVAL '2 years', 69.90),
(3, 3, CURRENT_DATE, CURRENT_DATE + INTERVAL '18 months', 99.90),
(4, 4, CURRENT_DATE, CURRENT_DATE + INTERVAL '13 months', 129.90),
(5, 5, CURRENT_DATE, CURRENT_DATE + INTERVAL '6 months', 39.90);

/*
Vou ajudar você com esses três STORED PROCEDURES em PostgreSQL, seguindo as melhores práticas de SQL. Vamos abordar cada um separadamente:

STORED PROCEDURE para verificar e aplicar desconto ou criar novo contrato:
sql

Copiar
CREATE OR REPLACE PROCEDURE verificar_e_aplicar_desconto(
    p_cliente_id INTEGER,
    p_operadora_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tem_telefone BOOLEAN;
    v_maior_valor_contrato NUMERIC;
    v_menor_valor_plano NUMERIC;
    v_plano_id INTEGER;
    v_telefone_id INTEGER;
BEGIN
    -- Verifica se o cliente já possui telefone da operadora
    SELECT EXISTS (
        SELECT 1
        FROM telefone t
        JOIN contrato c ON t.id = c.telefone_id
        JOIN plano p ON c.plano_id = p.id
        WHERE t.cliente_id = p_cliente_id
        AND p.operadora_id = p_operadora_id
    ) INTO v_tem_telefone;

    IF v_tem_telefone THEN
        -- Aplica desconto de 50% no contrato de maior valor
        UPDATE contrato
        SET valor_final = valor_final * 0.5
        WHERE id = (
            SELECT c.id
            FROM contrato c
            JOIN plano p ON c.plano_id = p.id
            JOIN telefone t ON c.telefone_id = t.id
            WHERE t.cliente_id = p_cliente_id
            AND p.operadora_id = p_operadora_id
            ORDER BY c.valor_final DESC
            LIMIT 1
        );
    ELSE
        -- Cria novo contrato com o plano de menor valor
        SELECT id, valor INTO v_plano_id, v_menor_valor_plano
        FROM plano
        WHERE operadora_id = p_operadora_id
        ORDER BY valor ASC
        LIMIT 1;

        -- Cria novo telefone para o cliente
        INSERT INTO telefone (numero, cliente_id)
        VALUES (CONCAT('NOVO-', p_cliente_id), p_cliente_id)
        RETURNING id INTO v_telefone_id;

        -- Cria novo contrato
        INSERT INTO contrato (plano_id, telefone_id, valor_final)
        VALUES (v_plano_id, v_telefone_id, v_menor_valor_plano);
    END IF;
END;
$$;
STORED PROCEDURE para reajustar preços de produtos:
sql

Copiar
CREATE OR REPLACE PROCEDURE reajustar_precos()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Reajuste para produtos categoria A
    UPDATE produtos
    SET preco = preco * 1.05
    WHERE categoria = 'A';

    -- Reajuste para produtos categoria B
    UPDATE produtos
    SET preco = preco * 1.10
    WHERE categoria = 'B';

    -- Reajuste para produtos categoria C
    UPDATE produtos
    SET preco = preco * 1.15
    WHERE categoria = 'C';
END;
$$;
STORED PROCEDURE para inserir dados de aluno:
sql

Copiar
CREATE OR REPLACE PROCEDURE inserir_aluno(
    p_ra CHARACTER VARYING,
    p_nome TEXT,
    p_a1 NUMERIC,
    p_a2 NUMERIC,
    p_a3 NUMERIC,
    p_a4 NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO alunos (ra, nome, a1, a2, a3, a4)
    VALUES (p_ra, p_nome, p_a1, p_a2, p_a3, p_a4);
END;
$$;
Observações importantes:

Estas procedures seguem as melhores práticas de SQL, incluindo o uso de maiúsculas para palavras-chave SQL e snake_case para nomes de variáveis e parâmetros.
A primeira procedure é mais complexa e inclui verificações e atualizações em várias tabelas. Certifique-se de que todas as tabelas mencionadas (cliente, operadora, plano, telefone, contrato) existam e tenham as estruturas corretas.
A segunda procedure assume que existe uma tabela chamada 'produtos' com colunas 'preco' e 'categoria'. Ajuste conforme necessário para sua estrutura de tabela real.
A terceira procedure assume que existe uma tabela chamada 'alunos' com as colunas ra, nome, a1, a2, a3 e a4. Ajuste se necessário.
Lembre-se de testar cada procedure em um ambiente de desenvolvimento antes de aplicá-las em produção.
Considere adicionar tratamento de erros e logging para melhorar a robustez e facilitar a depuração.
Para chamar estas procedures, você pode usar:

sql

Copiar
CALL verificar_e_aplicar_desconto(1, 1);
CALL reajustar_precos();
CALL inserir_aluno('12345', 'João Silva', 8.5, 7.0, 9.0, 8.5);
Certifique-se de substituir os valores de exemplo pelos valores reais ao chamar as procedures.
*/

-- 1. STORED PROCEDURE para verificar e aplicar desconto ou criar novo contrato
CREATE OR REPLACE PROCEDURE verificar_e_aplicar_desconto(
    p_cliente_id INTEGER,
    p_operadora_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tem_telefone BOOLEAN;
    v_maior_valor_contrato NUMERIC;
    v_menor_valor_plano NUMERIC;
    v_plano_id INTEGER;
    v_telefone_id INTEGER;
BEGIN
    -- Verifica se o cliente já possui telefone da operadora
    SELECT EXISTS (
        SELECT 1
        FROM telefone t
        JOIN contrato c ON t.id = c.telefone_id
        JOIN plano p ON c.plano_id = p.id
        WHERE t.cliente_id = p_cliente_id
        AND p.operadora_id = p_operadora_id
    ) INTO v_tem_telefone;

    IF v_tem_telefone THEN
        -- Aplica desconto de 50% no contrato de maior valor
        UPDATE contrato
        SET valor_final = valor_final * 0.5
        WHERE id = (
            SELECT c.id
            FROM contrato c
            JOIN plano p ON c.plano_id = p.id
            JOIN telefone t ON c.telefone_id = t.id
            WHERE t.cliente_id = p_cliente_id
            AND p.operadora_id = p_operadora_id
            ORDER BY c.valor_final DESC
            LIMIT 1
        );
    ELSE
        -- Cria novo contrato com o plano de menor valor
        SELECT id, valor INTO v_plano_id, v_menor_valor_plano
        FROM plano
        WHERE operadora_id = p_operadora_id
        ORDER BY valor ASC
        LIMIT 1;

        -- Cria novo telefone para o cliente
        INSERT INTO telefone (numero, cliente_id)
        VALUES (CONCAT('NOVO-', p_cliente_id), p_cliente_id)
        RETURNING id INTO v_telefone_id;

        -- Cria novo contrato
        INSERT INTO contrato (plano_id, telefone_id, valor_final)
        VALUES (v_plano_id, v_telefone_id, v_menor_valor_plano);
    END IF;
END;
$$;

-- Para chamar estas procedures, você pode usar:
CALL verificar_e_aplicar_desconto(1, 1);
