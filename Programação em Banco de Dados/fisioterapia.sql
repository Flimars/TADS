##Tabelas

### Fisioterapeuta
    - id
    - nome
    - cpf unique
    - crefito
    - salario base default(10k) 
    - valor_por_atendimento default(50)
  ___  
### Atendimento
    - fisio_id Integer (pk) (fk)
    - paciente_id Integer (pk) (fk)
    - data_hora_inicio timestamp default current_timestamp - ex: 2024-02-19 20:00:00 - 2024-02-19 22:00:00
    - data_hora_fim timestamp 
    - observacao text
    - nota Interger default not null(nota >= 0 and <= 5)
    - valor_consulta money default (100)
    - valor_por_hora_fisioterapeuta_atual money default (100)
___
### Paciente
    - id (pk) 
    - nome
    - cpf 
    - telefone
    - bairro 
___   
