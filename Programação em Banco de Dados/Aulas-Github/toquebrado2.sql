DROP DATABASE IF EXISTS toquebrado;
CREATE DATABASE toquebrado;

\c toquebrado;

CREATE TABLE fisioterapeuta (
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING(100) NOT NULL,
    cpf CHARACTER(11) UNIQUE, -- cpf CHARACTER(11) UNIQUE CHECK(validaCPF(cpf) is TRUE), 
    crefito TEXT NOT NULL,
    valor_por_hora MONEY
 );

-- SELECT nome, mascaraCPF(cpf) FROM fisioterapeuta;

 CREATE TABLE paciente (
    id SERIAL PRIMARY KEY,
    nome CHARACTER VARYING (100) NOT NULL,
    cpf CHARACTER(11) UNIQUE,
    telefone CHARACTER(12),
    bairro TEXT,
    rua TEXT,
    numero TEXT,
    cep CHARACTER(8)
 );

 CREATE TABLE atendimento (
    id SERIAL PRIMARY KEY,
    fisioterapeuta_id INTEGER REFERENCES fisioterapeuta(id),
    paciente_id INTEGER REFERENCES paciente(id), 
    data_hora_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_hora_fim TIMESTAMP,
    observacao TEXT,
    nota INTEGER CHECK(nota >= 0 and nota <= 5),
    valor_consulta MONEY DEFAULT 100,
    valor_por_hora_fisioterapeuta MONEY 
 );