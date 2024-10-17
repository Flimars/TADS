### 3. @RequestBody
A anotação **@RequestBody** é usada para vincular o corpo da requisição **HTTP** ao objeto **Java** que será passado como argumento para o método. Neste caso, o conteúdo da requisição (em formato **JSON**) será mapeado para o objeto **NovoAluno**.

Uso: Converte o **JSON** recebido no corpo da requisição para o objeto Java **NovoAluno**.
Exemplo de **JSON** esperado:
```
json

{
  "nome": "João Silva",
  "email": "joao.silva@email.com",
  "cpf": "123.456.789-00"
}
```
Esse **JSON** será mapeado automaticamente para a classe **NovoAluno** quando a requisição for recebida.