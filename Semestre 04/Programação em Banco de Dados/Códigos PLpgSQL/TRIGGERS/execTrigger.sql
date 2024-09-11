-- Triggers são executados automaticamente em resposta a eventos de banco de dados, como inserções, atualizações ou exclusões. Eles não são chamados diretamente, mas são acionados pelo sistema quando o evento ocorre.
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
id serial primary key,
cpf character(11),
nome text,
data_nascimento date,
rg character(11),
sexo char(1),
uf char(2)
);

INSERT INTO clientes (cpf, nome, data_nascimento, rg, sexo, uf)
VALUES 
('12345678901', 'João da Silva', '1985-01-15', '123456789', 'M', 'SP'),
('23456789012', 'Maria Pereira', '1995-11-05', '234567890', 'F', 'RJ'),
('34567890123', 'Pedro Santos', '2001-08-19', '345678901', 'M', 'MG');

-- O trigger atualizar_idade_cliente_trigger é acionado quando a data de nascimento de um cliente é alterada, e chama o stored procedure para atualizar a idade.
CREATE OR REPLACE PROCEDURE atualizar_idade_cliente(cliente_id integer) AS $$
BEGIN
    UPDATE clientes
    SET idade = calcular_idade(data_nascimento)
    WHERE id = cliente_id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizar_idade_cliente_trigger
AFTER UPDATE OF data_nascimento ON clientes
FOR EACH ROW
EXECUTE PROCEDURE atualizar_idade_cliente(NEW.id);

-- Ou, se for uma função:
-- CREATE TRIGGER atualizar_idade
-- BEFORE INSERT OR UPDATE ON clientes
-- FOR EACH ROW
-- PERFORM atualizar_idade_cliente(NEW.id);


UPDATE clientes
SET data_nascimento = '1990-01-01'
WHERE id = 1;

SELECT * FROM clientes;
-- Exemplo de um trigger que atualiza um campo de auditoria ao inserir um novo registro
-- CREATE TRIGGER atualizar_auditoria
-- AFTER INSERT ON clientes
-- FOR EACH ROW
-- EXECUTE PROCEDURE atualizar_campo_auditoria();