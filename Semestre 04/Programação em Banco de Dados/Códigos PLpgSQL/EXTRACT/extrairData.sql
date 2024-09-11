


No PostgreSQL, a função `EXTRACT` é usada para extrair subpartes de uma data ou timestamp, como o ano, mês, dia, hora, etc. Quando se trata de extrair ou manipular datas dentro de um mês corrente, `EXTRACT` pode ser combinado com outras funções de data.

### Usando `EXTRACT` para Extrair Partes de uma Data

```sql
SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS ano_corrente,
       EXTRACT(MONTH FROM CURRENT_DATE) AS mes_corrente,
       EXTRACT(DAY FROM CURRENT_DATE) AS dia_corrente;
```

### Exemplo 1: Obter o Primeiro e o Último Dia do Mês Corrente

Para pegar o primeiro e o último dia do mês corrente, você pode usar as seguintes funções:

```sql
-- Primeiro dia do mês corrente
SELECT DATE_TRUNC('month', CURRENT_DATE) AS primeiro_dia_do_mes;

-- Último dia do mês corrente
SELECT (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day') AS ultimo_dia_do_mes;
```

Aqui está o que está acontecendo:

1. `DATE_TRUNC('month', CURRENT_DATE)` retorna o primeiro dia do mês, truncando a data para o início do mês.
2. Para obter o último dia do mês, adicionamos um mês ao início do mês corrente e subtraímos um dia (`INTERVAL '1 month - 1 day'`).

### Exemplo 2: Obter Datas Específicas dentro do Mês Corrente

Se você quiser selecionar datas específicas dentro do mês corrente, pode fazer isso assim:

```sql
-- 10º dia do mês corrente
SELECT DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '9 days' AS decimo_dia_do_mes;

-- 20º dia do mês corrente
SELECT DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '19 days' AS vigesimo_dia_do_mes;
```

### Exemplo 3: Comparando Datas dentro do Mês Corrente

Para comparar datas dentro do mês corrente, pode-se fazer algo como:

```sql
-- Selecionar registros de uma tabela que tenham datas no mês corrente
SELECT *
FROM sua_tabela
WHERE EXTRACT(MONTH FROM data_coluna) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM data_coluna) = EXTRACT(YEAR FROM CURRENT_DATE);
```

Esse exemplo compara o mês e o ano da coluna de data `data_coluna` com o mês e o ano correntes.

### Exemplo 4: Verificar se uma Data está dentro do Mês Corrente

```sql
SELECT *
FROM sua_tabela
WHERE data_coluna BETWEEN DATE_TRUNC('month', CURRENT_DATE) 
                      AND (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day');
```

Isso retornará todos os registros onde `data_coluna` está dentro do mês corrente.

Esses são alguns exemplos de como usar `EXTRACT` e outras funções de data do PostgreSQL para manipular e comparar datas dentro do mês corrente.