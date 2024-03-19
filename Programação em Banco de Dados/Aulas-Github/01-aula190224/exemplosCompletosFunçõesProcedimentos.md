### Copilot:
Aqui estão alguns exemplos de funções e procedimentos em PLpgSQL para cada um dos itens que você mencionou:

0. **Atribuições e Declarações**
```sql
-- Função
CREATE OR REPLACE FUNCTION soma(a INTEGER, b INTEGER) RETURNS INTEGER AS $$
DECLARE
    resultado INTEGER;
BEGIN
    resultado := a + b;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_numero(n INTEGER) LANGUAGE plpgsql AS $$
DECLARE
    numero INTEGER := n;
BEGIN
    RAISE NOTICE '%', numero;
END $$;
```

1. **Condicionais: IF, ELSIF, ELSE e SWITCH CASE**
```sql
-- Função
CREATE OR REPLACE FUNCTION verifica_numero(n INTEGER) RETURNS TEXT AS $$
BEGIN
    IF n > 0 THEN
        RETURN 'Positivo';
    ELSIF n < 0 THEN
        RETURN 'Negativo';
    ELSE
        RETURN 'Zero';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_dia(dia INTEGER) LANGUAGE plpgsql AS $$
BEGIN
    CASE dia
        WHEN 1 THEN RAISE NOTICE 'Domingo';
        WHEN 2 THEN RAISE NOTICE 'Segunda-feira';
        WHEN 3 THEN RAISE NOTICE 'Terça-feira';
        WHEN 4 THEN RAISE NOTICE 'Quarta-feira';
        WHEN 5 THEN RAISE NOTICE 'Quinta-feira';
        WHEN 6 THEN RAISE NOTICE 'Sexta-feira';
        WHEN 7 THEN RAISE NOTICE 'Sábado';
        ELSE RAISE NOTICE 'Dia inválido';
    END CASE;
END $$;
```

2. **Estruturas de repetição: FOR, FOREACH, WHILE e DO WHILE**
```sql
-- Função
CREATE OR REPLACE FUNCTION soma_ate_n(n INTEGER) RETURNS INTEGER AS $$
DECLARE
    soma INTEGER := 0;
    i INTEGER;
BEGIN
    FOR i IN 1..n LOOP
        soma := soma + i;
    END LOOP;
    RETURN soma;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_ate_n(n INTEGER) LANGUAGE plpgsql AS $$
DECLARE
    i INTEGER := 1;
BEGIN
    WHILE i <= n LOOP
        RAISE NOTICE '%', i;
        i := i + 1;
    END LOOP;
END $$;
```

3. **Vetores**
```sql
-- Função
CREATE OR REPLACE FUNCTION soma_vetor(v INTEGER[]) RETURNS INTEGER AS $$
DECLARE
    soma INTEGER := 0;
    elemento INTEGER;
BEGIN
    FOREACH elemento IN ARRAY v LOOP
        soma := soma + elemento;
    END LOOP;
    RETURN soma;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_vetor(v INTEGER[]) LANGUAGE plpgsql AS $$
DECLARE
    elemento INTEGER;
BEGIN
    FOREACH elemento IN ARRAY v LOOP
        RAISE NOTICE '%', elemento;
    END LOOP;
END $$;
```

4. **LOOP**
```sql
-- Função
CREATE OR REPLACE FUNCTION conta_ate_n(n INTEGER) RETURNS INTEGER AS $$
DECLARE
    contador INTEGER := 0;
BEGIN
    LOOP
        EXIT WHEN contador >= n;
        contador := contador + 1;
    END LOOP;
    RETURN contador;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_ate_n(n INTEGER) LANGUAGE plpgsql AS $$
DECLARE
    i INTEGER := 1;
BEGIN
    LOOP
        EXIT WHEN i > n;
        RAISE NOTICE '%', i;
        i := i + 1;
    END LOOP;
END $$;
```

5. **RAISE NOTICE**
```sql
-- Função
CREATE OR REPLACE FUNCTION imprime_mensagem(mensagem TEXT) RETURNS TEXT AS $$
BEGIN
    RAISE NOTICE '%', mensagem;
    RETURN mensagem;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_ola() LANGUAGE plpgsql AS $$
BEGIN
    RAISE NOTICE 'Olá, mundo!';
END $$;
```

6. **ROWTYPE**
```sql
-- Função
CREATE OR REPLACE FUNCTION retorna_primeiro_cliente() RETURNS clientes%ROWTYPE AS $$
DECLARE
    primeiro_cliente clientes%ROWTYPE;
BEGIN
    SELECT INTO primeiro_cliente * FROM clientes LIMIT 1;
    RETURN primeiro_cliente;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_primeiro_cliente() LANGUAGE plpgsql AS $$
DECLARE
    primeiro_cliente clientes%ROWTYPE;
BEGIN
    SELECT INTO primeiro_cliente * FROM clientes LIMIT 1;
    RAISE NOTICE 'Primeiro cliente: %', primeiro_cliente.nome;
END $$;
```

7. **RECORD**
```sql
-- Função
CREATE OR REPLACE FUNCTION retorna_cliente(id INTEGER) RETURNS RECORD AS $$
DECLARE
    cliente RECORD;
BEGIN
    SELECT INTO cliente * FROM clientes WHERE clientes.id = id;
    RETURN cliente;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_cliente(id INTEGER) LANGUAGE plpgsql AS $$
DECLARE
    cliente RECORD;
BEGIN
    SELECT INTO cliente * FROM clientes WHERE clientes.id = id;
    RAISE NOTICE 'Cliente: %', cliente.nome;
END $$;
```

8. **SELECT INTO**
```sql
-- Função
CREATE OR REPLACE FUNCTION conta_clientes() RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT INTO total COUNT(*) FROM clientes;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Procedimento
CREATE OR REPLACE PROCEDURE imprime_total_clientes() LANGUAGE plpgsql AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT INTO total COUNT(*) FROM clientes;
    RAISE NOTICE 'Total de clientes: %', total;
END $$;
```

Por favor, note que você precisa substituir `clientes` e `nome` pelos nomes reais da sua tabela e coluna. Além disso, esses exemplos assumem que você tem uma tabela `clientes` em seu banco de dados.

Espero que isso ajude! Se você tiver mais perguntas, sinta-se à vontade para perguntar. 😊
___
### Phind: 

Vamos elaborar exemplos de funções e procedimentos em PLpgSQL para PostgreSQL, abordando os tópicos solicitados. PLpgSQL é uma linguagem procedural que permite a criação de funções e procedimentos no PostgreSQL, oferecendo recursos avançados de programação, como estruturas de controle, manipulação de exceções e acesso a dados.

### 0. Atribuições e Declarações

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION soma_numeros(a INTEGER, b INTEGER)
RETURNS INTEGER AS $$
DECLARE
    resultado INTEGER;
BEGIN
    resultado := a + b;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_soma(a INTEGER, b INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    resultado INTEGER;
BEGIN
    resultado := a + b;
    RAISE NOTICE 'A soma de % e % é %', a, b, resultado;
END;
$$;
```

### 1. Condicionais: IF, ELSIF, ELSE e SWITCH CASE

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION verifica_idade(idade INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF idade < 18 THEN
        RETURN 'Menor de idade';
    ELSIF idade >= 18 AND idade < 60 THEN
        RETURN 'Adulto';
    ELSE
        RETURN 'Idoso';
    END IF;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_idade(idade INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    IF idade < 18 THEN
        RAISE NOTICE 'Menor de idade';
    ELSIF idade >= 18 AND idade < 60 THEN
        RAISE NOTICE 'Adulto';
    ELSE
        RAISE NOTICE 'Idoso';
    END IF;
END;
$$;
```

### 2. Estruturas de repetição: FOR, FOREACH, WHILE e DO WHILE

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION soma_numeros_for(n INTEGER)
RETURNS INTEGER AS $$
DECLARE
    i INTEGER;
    soma INTEGER := 0;
BEGIN
    FOR i IN 1..n LOOP
        soma := soma + i;
    END LOOP;
    RETURN soma;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_numeros_for(n INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..n LOOP
        RAISE NOTICE '%', i;
    END LOOP;
END;
$$;
```

### 3. Vetores

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION soma_vetor(vetor INTEGER[])
RETURNS INTEGER AS $$
DECLARE
    soma INTEGER := 0;
    i INTEGER;
BEGIN
    FOREACH i IN ARRAY vetor LOOP
        soma := soma + i;
    END LOOP;
    RETURN soma;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_vetor(vetor INTEGER[])
LANGUAGE plpgsql AS $$
DECLARE
    i INTEGER;
BEGIN
    FOREACH i IN ARRAY vetor LOOP
        RAISE NOTICE '%', i;
    END LOOP;
END;
$$;
```

### 4. LOOP

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION soma_numeros_loop(n INTEGER)
RETURNS INTEGER AS $$
DECLARE
    i INTEGER := 1;
    soma INTEGER := 0;
BEGIN
    LOOP
        soma := soma + i;
        i := i + 1;
        EXIT WHEN i > n;
    END LOOP;
    RETURN soma;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_numeros_loop(n INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    i INTEGER := 1;
BEGIN
    LOOP
        RAISE NOTICE '%', i;
        i := i + 1;
        EXIT WHEN i > n;
    END LOOP;
END;
$$;
```

### 5. RAISE NOTICE

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION retorna_idade(idade INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RAISE NOTICE 'A idade informada é %', idade;
    RETURN idade;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_idade_notice(idade INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    RAISE NOTICE 'A idade informada é %', idade;
END;
$$;
```

### 6. ROWTYPE

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION retorna_linha_pessoa(id INTEGER)
RETURNS pessoa%ROWTYPE AS $$
DECLARE
    linha pessoa%ROWTYPE;
BEGIN
    SELECT * INTO linha FROM pessoa WHERE id = id;
    RETURN linha;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_linha_pessoa(id INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    linha pessoa%ROWTYPE;
BEGIN
    SELECT * INTO linha FROM pessoa WHERE id = id;
    RAISE NOTICE 'Nome: %, Idade: %', linha.nome, linha.idade;
END;
$$;
```

### 7. RECORD

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION retorna_linha_pessoa_record(id INTEGER)
RETURNS RECORD AS $$
DECLARE
    linha RECORD;
BEGIN
    SELECT * INTO linha FROM pessoa WHERE id = id;
    RETURN linha;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_linha_pessoa_record(id INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    linha RECORD;
BEGIN
    SELECT * INTO linha FROM pessoa WHERE id = id;
    RAISE NOTICE 'Nome: %, Idade: %', linha.nome, linha.idade;
END;
$$;
```

### 8. SELECT INTO

**Função com Retorno:**

```sql
CREATE OR REPLACE FUNCTION retorna_idade_pessoa(id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    idade INTEGER;
BEGIN
    SELECT idade INTO idade FROM pessoa WHERE id = id;
    RETURN idade;
END;
$$ LANGUAGE plpgsql;
```

**Procedimento (VOID):**

```sql
CREATE OR REPLACE PROCEDURE imprime_idade_pessoa(id INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    idade INTEGER;
BEGIN
    SELECT idade INTO idade FROM pessoa WHERE id = id;
    RAISE NOTICE 'A idade da pessoa é %', idade;
END;
$$;
```

Esses exemplos demonstram como utilizar diferentes recursos da linguagem PLpgSQL para criar funções e procedimentos no PostgreSQL, abordando desde atribuições e declarações até a manipulação de dados complexos e a interação com o banco de dados.