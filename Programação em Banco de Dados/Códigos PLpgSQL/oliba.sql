DROP DATABASE IF EXISTS mercadinho;

CREATE DATABASE mercadinho;

\c mercadinho;

CREATE TABLE produto
(
 cod_prod INT PRIMARY KEY,
 descricao VARCHAR(50) UNIQUE,
 qtde_disponivel INT NOT NULL DEFAULT 0
);

INSERT INTO produto VALUES (1, 'Feijão', 10);
INSERT INTO produto VALUES (2, 'Arroz', 5);
INSERT INTO produto VALUES (3, 'Farinha', 15);

CREATE TABLE itens_venda
(
 cod_venda  INT,
 id_produto VARCHAR(3),
 qtde_vendida INT,
 FOREIGN KEY (cod_venda) REFERENCES Produto(cod_prod) ON DELETE CASCADE
);