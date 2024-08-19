DROP TABLE IF EXISTS alunos;

CREATE TABLE alunos (
    ra CHARACTER VARYING(10) PRIMARY KEY,
    nome TEXT NOT NULL,
    a1 NUMERIC(5,2),
    a2 NUMERIC(5,2),
    a3 NUMERIC(5,2),
    a4 NUMERIC(5,2)
);

-- 3. STORED PROCEDURE para inserir dados de aluno:
CREATE OR REPLACE PROCEDURE inserir_aluno(
    p_ra CHARACTER VARYING,
    p_nome TEXT,
    p_a1 NUMERIC,
    p_a2 NUMERIC,
    p_a3 NUMERIC,
    p_a4 NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO alunos (ra, nome, a1, a2, a3, a4)
    VALUES (p_ra, p_nome, p_a1, p_a2, p_a3, p_a4);
END;
$$;

-- Para chamar estas procedures, você pode usar:
CALL inserir_aluno('12344', 'Joana Silveira', 8.5, 7.0, 9.0, 8.5);
CALL inserir_aluno('12345', 'Joao Silva', 8.5, 7.0, 9.0, 8.5);
CALL inserir_aluno('12346', 'Maria Oliveira', 7.5, 8.0, 8.5, 9.0);
CALL inserir_aluno('12347', 'Carlos Santos', 6.0, 7.5, 7.0, 8.0);
CALL inserir_aluno('12348', 'Ana Souza', 9.0, 8.5, 9.5, 9.0);
CALL inserir_aluno('12349', 'Pedro Lima', 7.0, 6.5, 7.5, 8.0);

SELECT * FROM alunos;