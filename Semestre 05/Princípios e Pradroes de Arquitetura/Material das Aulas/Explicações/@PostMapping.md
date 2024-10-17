### 2. @PostMapping(path = "/api/v1/alunos", consumes = MediaType.APPLICATION_JSON_VALUE)
A anotação **@PostMapping** é usada para mapear requisições **HTTP** do tipo **POST** para um método específico do controlador. O parâmetro path define o endpoint da API que será acessado, e o parâmetro consumes indica que o método aceitará apenas dados no formato **JSON** na requisição.

***path = "/api/v1/alunos":*** Isso indica que o método novoAluno será chamado quando houver uma requisição **POST** enviada para o caminho /api/v1/alunos.
***consumes = MediaType.APPLICATION_JSON_VALUE:*** Indica que o método espera receber dados no formato **JSON**.

Exemplo:
```
java

@PostMapping(path = "/api/v1/alunos", consumes = MediaType.APPLICATION_JSON_VALUE)
public void novoAluno(@RequestBody NovoAluno aluno) {
    // lógica para processar os dados do novo aluno
}
```