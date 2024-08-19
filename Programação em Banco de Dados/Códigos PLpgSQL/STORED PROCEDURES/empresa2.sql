
DROP DATABASE IF EXISTS empresa;
-- Criar o banco de dados
CREATE DATABASE empresa;

-- Conectar ao banco de dados
\c empresa

-- Criar a tabela de funcionários
CREATE TABLE funcionarios (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL
);

-- Inserir dados de exemplo
INSERT INTO funcionarios (cpf, nome, salario) VALUES
('12345678901', 'João Silva', 3500.00),
('23456789012', 'Maria Santos', 4200.50),
('34567890123', 'Pedro Oliveira', 3800.75),
('45678901234', 'Ana Rodrigues', 5000.00),
('48669001235', 'Renato Rodrigues', 3750.00),
('56789012345', 'Carlos Ferreira', 3200.25),
('67890123456', 'Juliana Lima', 4800.00),
('78901234567', 'Roberto Almeida', 3900.50),
('89012345678', 'Fernanda Costa', 4100.75),
('90123456789', 'Marcelo Souza', 3600.00),
('01234567890', 'Luciana Pereira', 4500.25);

CREATE TABLE funcionarios_excluidos (
    id INT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    data_exclusao DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Verificar os dados inseridos
SELECT * FROM funcionarios;

--=====================================================
-- Queries
--=====================================================
-- 1. Menor salário da empresa:
CREATE OR REPLACE FUNCTION obter_menor_salario()
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    menor_salario DECIMAL(10, 2);
BEGIN
    SELECT MIN(salario) INTO menor_salario FROM funcionarios;
    RETURN menor_salario;
END;
$$ LANGUAGE plpgsql;

-- 2. Nome do funcionário e valor do maior salário:
CREATE OR REPLACE FUNCTION obter_maior_salario()
RETURNS TABLE (nome VARCHAR(100), salario DECIMAL(10, 2)) AS $$
BEGIN
    RETURN QUERY
    SELECT f.nome, f.salario
    FROM funcionarios f
    WHERE f.salario = (SELECT MAX(fu.salario) FROM funcionarios fu);
END;
$$ LANGUAGE plpgsql;

-- 3. Reajustar salários em 10%:
CREATE OR REPLACE PROCEDURE reajustar_salarios_10_porcento()
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE funcionarios
    SET salario = salario * 1.10;
END;
$$;

-- 4. Reajustar salários com porcentagem definida:
CREATE OR REPLACE PROCEDURE reajustar_salarios(porcentagem DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE funcionarios
    SET salario = salario * (1 + porcentagem / 100);
END;
$$;

-- 5. Deletar funcionário e mover para tabela de excluídos:
CREATE OR REPLACE PROCEDURE excluir_funcionario(funcionario_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO funcionarios_excluidos (id, cpf, nome, salario)
    SELECT id, cpf, nome, salario
    FROM funcionarios
    WHERE id = funcionario_id;

    DELETE FROM funcionarios WHERE id = funcionario_id;
END;
$$;

-- 6. Restaurar funcionário excluído:
CREATE OR REPLACE PROCEDURE restaurar_funcionario(funcionario_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO funcionarios (id, cpf, nome, salario)
    SELECT id, cpf, nome, salario
    FROM funcionarios_excluidos
    WHERE id = funcionario_id;

    DELETE FROM funcionarios_excluidos WHERE id = funcionario_id;
END;
$$;

-- 7. Média dos salários dos funcionários com nome "Renato":
CREATE OR REPLACE FUNCTION media_salario_renato()
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    media DECIMAL(10, 2);
BEGIN
    SELECT AVG(salario) INTO media
    FROM funcionarios
    WHERE nome ILIKE 'Renato%';
    RETURN COALESCE(media, 0);
END;
$$ LANGUAGE plpgsql;

-- 8. Atualizar nomes para maiúsculo:
CREATE OR REPLACE PROCEDURE atualizar_nomes_maiusculo()
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE funcionarios
    SET nome = UPPER(nome);
END;
$$;

-- 9. Validação de CPF (tratar entrada de CPF com letras):
CREATE OR REPLACE FUNCTION validar_cpf()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.cpf !~ '^[0-9]{11}$' THEN
        RAISE EXCEPTION 'CPF inválido. Deve conter exatamente 11 dígitos numéricos.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_cpf
BEFORE INSERT OR UPDATE ON funcionarios
FOR EACH ROW
EXECUTE FUNCTION validar_cpf();

-- 10. Sortear um funcionário:
CREATE OR REPLACE FUNCTION sortear_funcionario()
RETURNS TABLE (id INT, nome VARCHAR(100)) AS $$
BEGIN
    RETURN QUERY
    SELECT f.id, f.nome
    FROM funcionarios f
    ORDER BY RANDOM()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Para usar estas Stored Procedures, você pode chamá-las da seguinte forma:
-- Exemplos de uso:
SELECT obter_menor_salario();
SELECT * FROM obter_maior_salario();
CALL reajustar_salarios_10_porcento();
CALL reajustar_salarios(5.5);
CALL excluir_funcionario(1);
CALL restaurar_funcionario(1);
SELECT media_salario_renato();
CALL atualizar_nomes_maiusculo();
SELECT * FROM sortear_funcionario();

