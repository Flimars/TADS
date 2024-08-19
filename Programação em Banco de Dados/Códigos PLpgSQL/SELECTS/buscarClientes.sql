/*
 Comando SQL para buscar clientes do estado de São Paulo:

 Explicação do comando SQL:

Selecionamos os campos necessários da tabela cliente.
Usamos JOIN para conectar com a tabela estado.
Utilizamos LEFT JOIN com a tabela telefone para incluir todos os clientes, mesmo aqueles sem telefones cadastrados.
A função STRING_AGG é usada para concatenar todos os números de telefone de um cliente em uma única string, separados por vírgula.
A cláusula WHERE filtra apenas os clientes do estado de São Paulo.
Agrupamos pelo ID, razão social e e-mail do cliente para evitar duplicatas.
Ordenamos o resultado pela razão social do cliente.
Este comando retornará uma lista de clientes do estado de São Paulo, mostrando o código (id), razão social, e-mail e todos os telefones concatenados em uma única coluna.

*/

SELECT 
    c.id AS codigo, 
    c.razao_social, 
    c.email, 
    STRING_AGG(t.numero, ', ') AS telefones
FROM 
    cliente c
    JOIN estado e ON c.estado_id = e.id
    LEFT JOIN telefone t ON c.id = t.cliente_id
WHERE 
    e.sigla = 'SP'
GROUP BY 
    c.id, c.razao_social, c.email
ORDER BY 
    c.razao_social;