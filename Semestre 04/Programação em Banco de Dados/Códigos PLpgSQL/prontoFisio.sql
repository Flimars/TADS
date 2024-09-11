/*
Exercícios de PLPGSQL, Stored Procedures, Funções e sub-selects:

01. Crie uma função que retorne o número total de atendimentos.
02. Crie uma stored procedure para adicionar um novo atendimento.
03. Crie uma função que retorne o valor médio das consultas.
04. Crie uma stored procedure para atualizar o valor por hora de um fisioterapeuta.
05. Crie uma função que retorne o fisioterapeuta com mais atendimentos.
06. Crie uma stored procedure para deletar um paciente.
07. Crie uma função que retorne o paciente com mais atendimentos.
08. Crie uma stored procedure para adicionar um novo paciente.
09. Crie uma função que retorne a média de notas de um fisioterapeuta.
10. Crie uma stored procedure para atualizar a nota de um atendimento.
11. Crie uma função que retorne o valor total recebido por um fisioterapeuta.
12. Crie uma stored procedure para atualizar o bairro de um paciente.
13. Crie uma função que retorne o número de pacientes em um determinado bairro.
14. Crie uma stored procedure para atualizar o telefone de um paciente.
15. Crie uma função que retorne o número de atendimentos em um determinado período.
*/

DROP DATABASE IF EXISTS "prontoFisio";
CREATE DATABASE "prontoFisio";

\c prontoFisio;

CREATE TABLE Fisioterapeuta (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE,
    crefito TEXT NOT NULL,
    valor_por_hora MONEY
);

CREATE TABLE Paciente (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE,
    telefone CHAR(12),
    bairro TEXT,
    rua TEXT,
    complemento TEXT,
    numero TEXT,
    cep CHAR(8)
);

CREATE TABLE Atendimento (
    id SERIAL PRIMARY KEY,
    fisioterapeuta_id INTEGER REFERENCES Fisioterapeuta (id),
    paciente_id INTEGER REFERENCES Paciente (id),
    data_hora_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_hora_fim TIMESTAMP,
    observacao TEXT,
    nota INTEGER CHECK (nota >= 0 AND nota <= 5),
    valor_consulta MONEY DEFAULT 100,
    valor_por_hora_fisioterapeuta MONEY
);

-- INSERTS
INSERT INTO Fisioterapeuta (nome, cpf, crefito, valor_por_hora) VALUES
('Joao Silva', '12345678901', 'CRM 12345', 200),
('Maria Santos', '98765432109', 'CRM 67890', 250),
('Carlos Oliveira', '11223344556', 'CRM 11223', 220),
('Ana Beatriz', '22334455667', 'CRM 22334', 230),
('Ricardo Pereira', '33445566778', 'CRM 33445', 240),
('Sofia Antunes', '44556677889', 'CRM 44556', 210),
('Paulo Ferreira', '55667788990', 'CRM 55667', 260),
('Lucas Gomes', '66778899001', 'CRM 66778', 270),
('Isabela Mendes', '77889900101', 'CRM 77889', 280),
('Rafael Martins', '88990011223', 'CRM 88990', 290),
('Maria Fernanda', '99001122334', 'CRM 99001', 300),
('Pedro Vidal', '00112233445', 'CRM 00112', 310),
('Carla Silva', '13788220058', 'CRM 11223', 320),
('Rodrigo Santos', '22334455766', 'CRM 22334', 330),
('Fernanda Costa', '33123466778', 'CRM 33445', 340),
('Ricardo Almeida', '44556677089', 'CRM 44556', 350),
('Lucas Ferreira', '55667788090', 'CRM 55667', 360),
('Isabela Gomes', '66778899011', 'CRM 66778', 370),
('Rafael Mendes', '77889900122', 'CRM 77889', 380),
('Maria Moura', '88910011223', 'CRM 88990', 390),
('Jessica Almeida', '99001122034', 'CRM 99001', 400);

INSERT INTO Paciente (nome, cpf, telefone, bairro, rua, complemento, numero, cep) VALUES
('Sandra Costa', '94057946047', '987654321', 'Centro', 'Rua Principal', 'Apto 101', '101', '12345678'),
('Carlos Pereira', '22334104667', '987654322', 'Jardim', 'Rua Secundaria', 'Sala 202', '202', '23456789'),
('Maria Fernanda', '33445556788', '987654323', 'São Geraldo', 'Rua Terceira', 'Bloco 303', '303', '34567890'),
('Ricardo Freire', '44556557889', '987654324', 'Vila Olímpia', 'Rua Quarta', 'Apto 404', '404', '45678901'),
('Lucas Ferreira', '55667788991', '987654325', 'Vila Mariana', 'Rua Quinta', 'Sala 505', '505', '56789012'),
('Isabela Gomes', '61778899001', '987654326', 'Vila Guilherme', 'Rua Sexta', 'Bloco 606', '606', '67890123'),
('Rafael Mendes', '77889900012', '987654327', 'Vila Leopoldina', 'Rua Setima', 'Apto 707', '707', '78901234'),
('Maria Martins', '88990011203', '987654328', 'Vila Maria', 'Rua Oitava', 'Sala 808', '808', '89012345'),
('Gilnei Santos Almeida', '98001122034', '987654329', 'Vila Formosa', 'Rua Nona', 'Bloco 909', '909', '90123456'),
('Carla Silva', '00312233445', '987654330', 'Vila Clementino', 'Rua Decima', 'Apto 1010', '1010', '10234567'),
('Rodrigo Santana', '23556918005', '987654331', 'Vila Guilherme', 'Rua Onze', 'Sala 1111', '1111', '11345678'),
('Fernanda Costa', '25624455667', '987654332', 'Vila Maria', 'Rua Doze', 'Bloco 1212', '1212', '12456789'),
('Ricardo Almeida', '33445560078', '987654333', 'Vila Leopoldina', 'Rua Treze', 'Apto 1313', '1313', '13567890'),
('Lucas Ferreira', '44556677489', '987654334', 'Vila Guilherme', 'Rua Quatorze', 'Sala 1414', '1414', '14678901'),
('Isabela Gomes', '05667788990', '987654335', 'Vila Maria', 'Rua Quinze', 'Bloco 1515', '1515', '15789012'),
('Rafael Mendes', '66008899001', '987654336', 'Vila Leopoldina', 'Rua Dezesseis', 'Apto 1616', '1616', '16890123'),
('Maria Mello Medeiros', '77889900022', '987654337', 'Vila Guilherme', 'Rua Dezessete', 'Sala 1717', '1717', '17901234'),
('Alice Almeida', '80990011223', '987654338', 'Vila Maria', 'Rua Dezoito', 'Bloco 1818', '1818', '18023456'),
('Carla Regina Silva', '99001122344', '987654339', 'Vila Leopoldina', 'Rua Dezenove', 'Apto 1919', '1919', '19134567'),
('Rodrigo Santos', '00112233045', '987654340', 'Vila Guilherme', 'Rua Vinte', 'Sala 2020', '2020', '20245678');

INSERT INTO Atendimento (fisioterapeuta_id, paciente_id, data_hora_fim, observacao, nota, valor_por_hora_fisioterapeuta) VALUES
(1, 1, '2023-04-01 14:00:00', 'Atendimento inicial de Reabilitacao', 4, 200),
(2, 2, '2023-04-02 15:00:00', 'Seguimento do tratamento fortalecimento muscular', 5, 250),
(3, 3, '2023-04-03 16:00:00', 'Atendimento de rotina', 3, 220),
(4, 4, '2023-04-04 17:00:00', 'Consulta de acompanhamento', 4, 230),
(5, 5, '2023-04-05 18:00:00', 'Reavaliacao do tratamento', 5, 240),
(1, 6, '2023-04-06 19:00:00', 'Atendimento de rotina', 4, 220),
(7, 7, '2023-04-07 20:00:00', 'Consulta de acompanhamento', 3, 230),
(8, 8, '2023-04-08 21:00:00', 'Reavaliacao do tratamento', 4, 240),
(9, 9, '2023-04-09 22:00:00', 'Atendimento de rotina', 5, 220),
(10, 10, '2023-04-10 23:00:00', 'Consulta de acompanhamento', 4, 230),
(8, 11, '2023-04-11 00:00:00', 'Reavaliacao do tratamento', 5, 240),
(12, 12, '2023-04-12 01:00:00', 'Atendimento de rotina para coluna cervical', 4, 220),
(13, 13, '2023-04-13 02:00:00', 'Consulta de acompanhamento a Tendinite', 3, 230),
(14, 14, '2023-04-14 03:00:00', 'Reavaliacao do tratamento tendinite no ombro', 4, 240),
(15, 15, '2023-04-15 04:00:00', 'Atendimento de rotina com turbilhao para menbros inferiores', 5, 220),
(16, 16, '2023-04-16 05:00:00', 'Consulta de acompanhamento', 4, 230),
(11, 17, '2023-04-17 06:00:00', 'Reavaliacao do tratamento', 5, 240),
(1, 18, '2023-04-18 07:00:00', 'Atendimento de rotina', 4, 220),
(9, 19, '2023-04-19 08:00:00', 'Consulta de acompanhamento', 3, 230),
(1, 20, '2023-04-20 09:00:00', 'Reavaliacao do tratamento ', 4, 240);

-- Resolução dos Exercicios:

-- 1)
-- CREATE OR REPLACE FUNCTION total_de_atendimentos() RETURNS INTEGER AS
-- $$
-- DECLARE
--     total INTEGER;
-- BEGIN
--     SELECT COUNT(*) INTO total from atendimento;

-- RETURN total;
-- END;
-- $$ LANGUAGE "plpgsql";

-- -- Chamada da Função;
-- SELECT total_de_atendimentos();

-- 2)
CREATE OR REPLACE function AdicionaAtendimento(fisioterapeuta_id INTEGER, paciente_id INTEGER, data_hora_fim TIMESTAMP, observacao TEXT, nota INTEGER, valor_por_hora_fisioterapeuta MONEY) RETURNS void AS
$$
BEGIN
    INSERT INTO Atendimento VALUES (fisioterapeuta_id, paciente_id, data_hora_fim, observacao, nota, valor_por_hora_fisioterapeuta);
END;
$$ LANGUAGE "plpgsql";

AdicionaAtendimento(8, 16, '2024-04-04 16:23:18', 'Reabilitacao movimento do joelho', 3, 285);

