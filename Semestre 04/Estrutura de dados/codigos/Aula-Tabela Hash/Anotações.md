Tabela Hash
Busca exaustiva: 
    - Sequencial;
    - Binaria
Função Hash ou de Espalhamento:
    - Colisão;
    - Função Hash ruim: produz alto número de colisões;
    - Função Hash boa: 
        1. produz baixo número de colisões;
        2. Deve ser facilmente computável;
        3. Deve ser uniforme.
Fator de Carga: é o tamanho do  vetor divido pelo número máximo de elementos.
Quando:
     FC  = ne/tv ~= 0.5 a 0.6, Se FC for próximo de 1 aumenta o risco de colisões.

     Se Fc for próximo de 0(zero) existe disperdicio do recurso de memória.

- Encadeamento Exterior ou Separado:
  Principais funções
    - Inserção
    - Busca (Se o espaço da memória esta vazio o elemento não existe, fim da busca. Caso contrario efetua a comparação com o elemento existente e caso esse elemento não aponte para NULL, devemos percorrer os nós até encontrar o elemento desejado ou NULL que indica o fim da Lista.)
    - Remoção    
- Encadeamento Interior Heterogênio:
    - Inserção
    - Busca (Se o espaço da memória esta vazio o elemento não existe, fim da busca. Caso contrario efetua a comparação com o elemento existente e caso ainda não seja o elemento desejado, devemos percorrer os nós do vetor de colisões até encontrar o elemento desejado ou o próximo espaço vazio, fim da busca.)
    - Remoção    
  
- Encadeamento Interior Homogênio:
    Teste Linear

