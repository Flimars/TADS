DROP DATABASE IF EXISTS loja;
CREATE DATABASE loja;

\c loja;

CREATE TABLE Produto (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(5,2)
);

INSERT INTO Produto (nome, preco) VALUES
('Ovo de Páscoa Trufado', 59.90),
('Caixa de Bombons Finos', 29.90),
('Barra de Chocolate ao Leite', 12.90),
('Ovo de Páscoa de Chocolate Branco', 49.90),
('Trufa Tradicional', 3.80),
('Caixa de Mini Ovos', 19.90),
('Ovo de Páscoa de Chocolate ao Leite', 39.90),
('Barra de Chocolate Amargo', 14.90),
('Caixa de Trufas Sortidas', 24.90),
('Ovo de Páscoa de Chocolate com Avelã', 64.90);


CREATE TABLE Venda (
    id SERIAL PRIMARY KEY,
    produto_id INTEGER REFERENCES Produto(id),
    quantidade INTEGER,
    data_venda DATE
);

INSERT INTO Venda (produto_id, quantidade, data_venda) VALUES
(1, ROUND(28952.18 / 59.90), '2024-04-01'),
(2, ROUND(28952.18 / 29.90), '2024-04-01'),
(3, ROUND(28952.18 / 12.90), '2024-04-01'),
(4, ROUND(28952.18 / 49.90), '2024-04-01'),
(5, ROUND(28952.18 / 3.80), '2024-04-01'),
(6, ROUND(28952.18 / 19.90), '2024-04-01'),
(7, ROUND(28952.18 / 39.90), '2024-04-01'),
(8, ROUND(28952.18 / 14.90), '2024-04-01'),
(9, ROUND(28952.18 / 24.90), '2024-04-01'),
(10, ROUND(28952.18 / 64.90), '2024-04-01');



