Para fazer o DROP de uma função no PostgreSQL, você precisa usar o comando DROP FUNCTION. No entanto, é importante notar que o PostgreSQL suporta sobrecarga de funções, o que significa que pode haver múltiplas funções com o mesmo nome, mas com diferentes parâmetros. Portanto, ao fazer o DROP, você precisa especificar não apenas o nome da função, mas também os tipos de seus parâmetros.

Para a função `soma` que você mencionou, assumindo que ela tem dois parâmetros TEXT, você pode usar o seguinte comando:

```sql
DROP FUNCTION IF EXISTS soma(TEXT, TEXT);
```

Explicação do comando:
- `DROP FUNCTION`: Este é o comando para remover uma função.
- `IF EXISTS`: Esta cláusula é opcional, mas recomendada. Ela evita que um erro seja lançado se a função não existir.
- `soma`: Este é o nome da sua função.
- `(TEXT, TEXT)`: Estes são os tipos dos parâmetros da função.

Se você não tiver certeza sobre os tipos exatos dos parâmetros ou se houver múltiplas versões da função, você pode usar o seguinte comando para listar todas as funções com o nome 'soma':

```sql
SELECT proname, proargtypes::regtype[] 
FROM pg_proc 
WHERE proname = 'soma';
```

Isso mostrará o nome da função e os tipos de seus argumentos. Com essa informação, você pode então executar o DROP FUNCTION correto.

Se você quiser remover todas as versões da função 'soma', independentemente dos tipos de parâmetros, você pode usar:

```sql
DROP FUNCTION IF EXISTS soma(TEXT, TEXT);
DROP FUNCTION IF EXISTS soma(VARCHAR, VARCHAR);
-- Adicione mais linhas se houver outras combinações de tipos de parâmetros
```

Lembre-se de que remover uma função pode afetar outras partes do seu banco de dados que dependem dela, então certifique-se de que está removendo a função correta e que isso não causará problemas em outras partes do seu sistema.