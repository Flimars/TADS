
CREATE OR REPLACE FUNCTION calculaMaiorSalario(codigo INTEGER) RETURNS REAL AS
$$
DECLARE
    r_funcionario RECORD;
    salario REAL := 0;

BEGIN   
    FOR r_funcionario IN SELECT * FROM funcionario LOOP 
        RAISE NOTICE 'funcionario: %, %, %, %, %, %', r_funcionario.codigo, r_funcionario.nome, r_funcionario.sobrenome, r_funcionario.cargo, r_funcionario.salario, r_funcionario.data_admissao;
        IF r_funcionario.codigo = cargo AND r_funcionario.salario > salario THEN
            salario := r_funcionario.salario;
        END IF;
    END LOOP;
    
    RETURN salario;        
END;
$$ LANGUAGE plpgsql;

SELECT calculaMaiorSalario(5);

-- Definição da função calculaMaiorSalario
CREATE OR REPLACE FUNCTION calculaMaiorSalario2(qtd_funcionarios integer)
RETURNS numeric AS $$
DECLARE
    maior_salario numeric := 0;
BEGIN
    SELECT MAX(salario) INTO maior_salario FROM funcionario;
    RETURN maior_salario;
END;
$$ LANGUAGE plpgsql;

-- -- Chamada da função
SELECT calculaMaiorSalario2(5);

-- INSERT INTO funcionario (nome, sobrenome, cargo, salario, data_admissao) VALUES ('Pedro', 'Silva', 'Analista de Sistemas', 5000.00, '2024-08-18');
-- INSERT INTO funcionario (nome, sobrenome, cargo, salario, data_admissao) VALUES ('Maria', 'Santos', 'Gerente de Projetos', 7000.00, '2023-06-10');
-- INSERT INTO funcionario (nome, sobrenome, cargo, salario, data_admissao) VALUES ('Carlos', 'Costa', 'Desenvolvedor Web', 4500.00, '2024-01-22');
-- INSERT INTO funcionario (nome, sobrenome, cargo, salario, data_admissao) VALUES ('Ana', 'Oliveira', 'Analista de Dados', 5500.00, '2022-11-30');
-- INSERT INTO funcionario (nome, sobrenome, cargo, salario, data_admissao) VALUES ('Luiz', 'Fernandes', 'Designer Gráfico', 4000.00, '2023-09-15');