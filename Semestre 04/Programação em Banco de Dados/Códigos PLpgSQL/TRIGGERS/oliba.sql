DROP DATABASE IF EXISTS mercadinho;

CREATE DATABASE mercadinho;

\c mercadinho;

CREATE TABLE produto (
 cod_prod INTEGER PRIMARY KEY,
 descricao VARCHAR(50) UNIQUE,
 qtde_disponivel INT NOT NULL DEFAULT 0
);

INSERT INTO produto VALUES 
(1, 'Feijao', 10),
(2, 'Arroz', 5),
(3, 'Farinha', 15);

CREATE TABLE itens_venda (
 cod_venda  INTEGER,
 id_produto INTEGER,
 qtde_vendida INTEGER,
 FOREIGN KEY (id_produto) REFERENCES Produto(cod_prod) ON DELETE CASCADE
);

-- Criação da STORED PROCEDURE
CREATE OR REPLACE FUNCTION verificar_qtde_disponivel() RETURNS TRIGGER AS
$$
DECLARE
    qtde INTEGER; -- quatidade disponivel do produto em estoque
BEGIN
    SELECT qtde_disponivel FROM produto WHERE cod_prod = NEW.id_produto INTO qtde;
    IF qtde < NEW.qtde_vendida THEN
        RAISE EXCEPTION 'Quantidade indisponivel em estoque! Qtde disponivel %', qtde;
    ELSE
        UPDATE produto SET qtde_disponivel = qtde_disponivel - NEW.qtde_vendida
            WHERE cod_prod = NEW.id_produto;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criação da TRIGGER
CREATE TRIGGER t_atualiza_estoque
BEFORE INSERT OR UPDATE ON itens_venda
FOR EACH ROW
EXECUTE FUNCTION verificar_qtde_disponivel();

SELECT * FROM itens_venda;
SELECT * FROM produto;

INSERT INTO itens_venda VALUES
(1, 1, 3),
(2, 2, 5),
(3, 3, 10);

SELECT * FROM itens_venda;
SELECT * FROM produto;

INSERT INTO itens_venda VALUES
(4, 2, 3);

SELECT * FROM itens_venda;
SELECT * FROM produto;
