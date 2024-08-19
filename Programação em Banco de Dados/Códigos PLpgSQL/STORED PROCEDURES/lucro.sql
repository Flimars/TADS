DROP TABLE IF EXISTS LUCRO;
DROP TABLE IF EXISTS SALARIO;


CREATE TABLE LUCRO (
ANO INTEGER PRIMARY KEY,
VALOR NUMERIC(10,2) --REAL
);

INSERT INTO LUCRO VALUES 
(2007,1200000),
(2008,1500000),
(2009,1400000);
-- ON CONFLICT (codigo) DO NOTHING;

CREATE TABLE SALARIO (
MATRICULA INTEGER PRIMARY KEY,
VALOR NUMERIC(10,2) --REAL
);

INSERT INTO SALARIO VALUES 
(1001,2500),
(1002,3200);
-- ON CONFLICT (codigo) DO NOTHING;

-- 4. Crie uma procedure que receba o ano (tabela LUCRO) e número de matricula
-- do funcionário e devolva o valor do seu respectivo bônus.
CREATE OR REPLACE PROCEDURE calcular_bonus(
    IN p_ano INTEGER,
    IN p_matricula INTEGER,
    OUT p_bonus NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_lucro NUMERIC;
    v_salario NUMERIC;
BEGIN
    -- Obter o lucro do ano especificado
    SELECT valor INTO v_lucro
    FROM lucro
    WHERE ano = p_ano;

    -- Obter o salário do funcionário
    SELECT valor INTO v_salario
    FROM salario
    WHERE matricula = p_matricula;

    -- Calcular o bônus
    p_bonus := (v_lucro * 0.01) + (v_salario * 0.05);

    -- Verificar se os dados foram encontrados
    IF v_lucro IS NULL THEN
        RAISE EXCEPTION 'Lucro nao encontrado para o ano %', p_ano;
    END IF;

    IF v_salario IS NULL THEN
        RAISE EXCEPTION 'Salário nao encontrado para a matricula %', p_matricula;
    END IF;

    -- Arredondar o bônus para duas casas decimais
    p_bonus := ROUND(p_bonus, 2);
END;
$$;

-- Para chamar esta procedure e obter o resultado, você pode usar o seguinte código:
DO $$
DECLARE
    v_bonus NUMERIC;
BEGIN
    CALL calcular_bonus(2008, 1001, v_bonus);
    RAISE NOTICE 'O bonus calculado eh: R$ %', v_bonus;
END;
$$;

SELECT * FROM LUCRO;
SELECT * from SALARIO;

/*
Excelente! Vamos criar uma STORED PROCEDURE para calcular o bônus dos funcionários com base no lucro líquido e no salário, seguindo as melhores práticas de SQL. Aqui está a implementação:

```SQL
CREATE OR REPLACE PROCEDURE calcular_bonus(
    IN p_ano INTEGER,
    IN p_matricula INTEGER,
    OUT p_bonus NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_lucro NUMERIC;
    v_salario NUMERIC;
BEGIN
    -- Obter o lucro do ano especificado
    SELECT valor INTO v_lucro
    FROM lucro
    WHERE ano = p_ano;

    -- Obter o salário do funcionário
    SELECT valor INTO v_salario
    FROM salario
    WHERE matricula = p_matricula;

    -- Calcular o bônus
    p_bonus := (v_lucro * 0.01) + (v_salario * 0.05);

    -- Verificar se os dados foram encontrados
    IF v_lucro IS NULL THEN
        RAISE EXCEPTION 'Lucro não encontrado para o ano %', p_ano;
    END IF;

    IF v_salario IS NULL THEN
        RAISE EXCEPTION 'Salário não encontrado para a matrícula %', p_matricula;
    END IF;

    -- Arredondar o bônus para duas casas decimais
    p_bonus := ROUND(p_bonus, 2);
END;
$$;
```

Explicação da PROCEDURE:

1. A procedure recebe dois parâmetros de entrada (IN): `p_ano` e `p_matricula`.
2. Ela tem um parâmetro de saída (OUT): `p_bonus`, que retornará o valor calculado do bônus.
3. Usamos variáveis locais `v_lucro` e `v_salario` para armazenar os valores obtidos das tabelas.
4. A fórmula do bônus é aplicada conforme especificado: `BONUS = LUCRO * 0.01 + SALARIO * 0.05`.
5. Incluímos verificações para garantir que tanto o lucro quanto o salário foram encontrados.
6. O resultado é arredondado para duas casas decimais para maior precisão financeira.

Para chamar esta procedure e obter o resultado, você pode usar o seguinte código:

```SQL
DO $$
DECLARE
    v_bonus NUMERIC;
BEGIN
    CALL calcular_bonus(2008, 1001, v_bonus);
    RAISE NOTICE 'O bônus calculado é: R$ %', v_bonus;
END;
$$;
```

Este código chamará a procedure para o ano 2008 e o funcionário com matrícula 1001, e exibirá o resultado.

Algumas observações importantes:

1. Esta implementação segue as melhores práticas de SQL, usando maiúsculas para palavras-chave SQL e snake_case para nomes de variáveis e parâmetros.

2. A procedure inclui tratamento de erros básico, lançando exceções se o lucro ou o salário não forem encontrados.

3. O arredondamento para duas casas decimais é importante em cálculos financeiros para evitar problemas com precisão de ponto flutuante.

4. Certifique-se de que as tabelas LUCRO e SALARIO estejam criadas e populadas conforme especificado antes de executar a procedure.

5. É uma boa prática testar a procedure com diferentes cenários, incluindo casos limite, antes de usá-la em um ambiente de produção.

6. Considere adicionar mais validações ou logging, dependendo dos requisitos específicos do seu sistema.

Esta implementação fornece uma solução robusta e eficiente para o cálculo de bônus, seguindo as melhores práticas de SQL e desenvolvimento de stored procedures no PostgreSQL.

*/
