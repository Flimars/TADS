DROP DATABASE IF EXISTS doces_mary;

CREATE DATABASE doces_mary;

\c doces_mary;

CREATE TABLE cliente (
    id serial primary key,
    nome text not null
);
INSERT INTO cliente (nome) VALUES
('VINICIUS FRITZEN');

CREATE TABLE pedido (
    id serial primary key,
    data_hora timestamp default current_timestamp,
    cliente_id integer references cliente (id)
);
INSERT INTO pedido (cliente_id) values
(1);

CREATE TABLE doce (
    id serial primary key,
    nome character varying(100) not null,
    preco money check (cast(preco as numeric(8,2)) >= 0),
    estoque integer check (estoque >= 0)
);
INSERT INTO doce (nome, preco, estoque) VALUES
('BOMBOM', 1.99, 100);

CREATE TABLE item (
    pedido_id integer references pedido (id),
    doce_id integer references doce (id),
    qtde integer check (qtde >= 0),
    preco_unitario_atual money check (cast(preco_unitario_atual as numeric(8,2)) >= 0),
    primary key (pedido_id, doce_id)
);