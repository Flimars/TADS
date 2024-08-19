-- Remover tabela se já existe
DROP TABLE IF EXISTS funcionario;

-- Cria a tabela funcionário
CREATE TABLE funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL,
    data_admissao TIMESTAMP NOT NULL
);

-- Insere as tuplas de funcionario
INSERT INTO funcionario (nome, sobrenome, cargo, salario) VALUES 
-- Insert 1 Gerente
('Joelton', 'Silva', 'Gerente', 5000.00, '2023-04-01 12:34:56'),
-- Insert 1 Coordenador
('Maria', 'Santos', 'Coordenadora', 4000.00, '2022-03-31 08:30:12'),
-- Insert 3 Vendedores
 ('Betina', 'Oliveira', 'Vendedor', 3000.00, '2021-12-03 08:47:29'),
 ('Ana', 'Costa', 'Vendedor', 3200.00),
 ('Richard', 'Pereira', 'Vendedor', 3300.00, '2022-07-31 14:05:52'),
-- Insert 1 Auxiliar Administrativo
 ('Lucas', 'Gomes', 'Auxiliar Administrativo', 2000.00, '2024-01-30 11:30:40');

 --================================================================================================================
-- Exemplo 1: Usando RECORD para armazenar o resultado de uma consulta
--================================================================================================================
DROP FUNCTION IF EXISTS obter_info_empregado(INTEGER);

 CREATE OR REPLACE FUNCTION obter_info_empregado(empregado_id INTEGER) RETURNS TEXT AS
 $$
 DECLARE
    meu_empregado RECORD;
 BEGIN
    SELECT id, nome, sobrenome, cargo, salario
    INTO meu_empregado
    FROM funcionario 
    WHERE id = empregado_id;

    IF NOT FOUND THEN
        RETURN 'EMPREGADO NÃO ENCONTADO';
    END IF;

    RETURN 'ID: ' || meu_empregado.id || ', NOME: ' || meu_empregado.nome || ' ' || meu_empregado.sobrenome || ', cargo: ' || meu_empregado.cargo || ', salario: ' || meu_empregado.salario;

 END;
 $$ LANGUAGE plpgsql;

 -- Uso:
SELECT obter_info_empregado(1);

--================================================================================================================
-- Exemplo 2: Usando RECORD em um loop FOR
--================================================================================================================
DROP FUNCTION IF EXISTS lista_maior_salario(NUMERIC);

CREATE OR REPLACE FUNCTION lista_maior_salario(maior_salario NUMERIC)
RETURNS TABLE (empregado_nome TEXT, empregado_salario NUMERIC) AS 
$$
DECLARE
    meu_empregado RECORD;
BEGIN
    FOR meu_empregado IN 
        SELECT nome, sobrenome, salario 
        FROM funcionario 
        WHERE salario >= maior_salario
    LOOP
        empregado_nome := meu_empregado.nome || ' ' || meu_empregado.sobrenome;
        empregado_salario := meu_empregado.salario;
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Uso:
SELECT * FROM lista_maior_salario(5000);

--================================================================================================================
-- Exemplo 3: Usando RECORD com consultas dinâmicas
--================================================================================================================
DROP FUNCTION IF EXISTS obter_info_tabela(TEXT);

CREATE OR REPLACE FUNCTION obter_info_tabela(p_tabela_nome TEXT)
RETURNS TABLE (column_name TEXT, data_type TEXT) AS $$
DECLARE
    col_record RECORD;
BEGIN
    FOR col_record IN 
        EXECUTE format('SELECT column_name::TEXT, data_type::TEXT 
                        FROM information_schema.columns 
                        WHERE table_name = %L', p_tabela_nome)
    LOOP
        column_name := col_record.column_name;
        data_type := col_record.data_type;
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Uso:
SELECT * FROM obter_info_tabela('funcionario');
--================================================================================================================
-- Exemplo 4: Usando ROWTYPE 
--================================================================================================================
CREATE OR REPLACE FUNCTION media_salario(empregado_id INT) RETURNS NUMERIC AS
$body$
DECLARE
    linhaFuncionario  funcionario%ROWTYPE;
    mediaSalario      NUMERIC(9,2);
    totalSalarios     NUMERIC(9,2);
    periodo           INT;       
BEGIN
    SELECT * INTO linhaFuncionario FROM funcionario WHERE id = empregado_id;

    periodo := (CURRENT_DATE - linhaFuncionario.data_admissao);

    SELECT SUM(salario) INTO totalSalarios from funcionario WHERE id = empregado_id;

    mediaSalario := totalSalarios / periodo;
    RETURN mediaSalario;

END;
$body$ LANGUAGE plpgsql;

-- Uso
SELECT media_salario(2);






