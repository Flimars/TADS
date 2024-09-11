-- Remover tabela se já existe
DROP TABLE IF EXISTS funcionario;

-- Cria a tabela funcionário
CREATE TABLE funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

-- Insere as tuplas de funcionario
INSERT INTO funcionario (nome, cargo, salario) VALUES 
-- Insert 1 Gerente
('João Silva', 'Gerente', 5000.00),
-- Insert 1 Coordenador
('Maria Santos', 'Coordenadora', 4000.00),
-- Insert 3 Vendedores
 ('Carlos Oliveira', 'Vendedor', 3000.00),
 ('Ana Costa', 'Vendedor', 3200.00),
 ('Ricardo Pereira', 'Vendedor', 3300.00),
-- Insert 1 Auxiliar Administrativo
 ('Lucas Gomes', 'Auxiliar Administrativo', 2000.00);



-- Remove a função
DROP FUNCTION IF EXISTS altera_salario();

--Cria a função
CREATE OR REPLACE FUNCTION altera_salario() RETURNS INTEGER AS
$$
BEGIN
    UPDATE funcionario SET salario = salario * 1.1;
    -- SUB-BLOCO
    DECLARE
        x INTEGER;

    BEGIN
        UPDATE funcionario set salario = 5000;
        -- GERAÇÃO DO ERRO PROPOSITALMENTE
        X := 1/0;
        RETURN 1;
    EXCEPTION
        WHEN division_by_zero THEN RAISE NOTICE 'DIVISAO POR ZERO';
        RETURN 0;
    END;
END;
$$ LANGUAGE plpgsql;

-- Chama a função
SELECT altera_salario();
