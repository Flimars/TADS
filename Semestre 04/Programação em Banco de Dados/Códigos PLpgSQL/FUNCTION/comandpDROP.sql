/*
    Para remover essas funções, você usaria os comandos DROP FUNCTION da seguinte maneira:
*/

DROP FUNCTION nome_da_funcao(argumentos_da_funcao); -- Sintaxe padrão


DROP FUNCTION verificar_idade(INT);

DROP FUNCTION somar_naturais(INT);

DROP FUNCTION somar_naturais_for(INT);

/*
    Cada comando especifica o nome da função seguido pelos tipos de argumentos entre parênteses. Isso garante que o PostgreSQL saiba exatamente qual função você deseja remover.

Nota Adicional:
Se você tentar remover uma função que não existe, o PostgreSQL retornará um erro. Para evitar isso, você pode adicionar a opção IF EXISTS ao comando DROP FUNCTION, o que fará com que o comando seja executado sem erros mesmo se a função não existir:
Usar IF EXISTS é uma boa prática para evitar erros em scripts de migração ou quando você não tem certeza se uma função já foi criada.
*/

DROP FUNCTION IF EXISTS verificar_idade(INT);

DROP FUNCTION IF EXISTS somar_naturais(INT);

DROP FUNCTION IF EXISTS somar_naturais_for(INT);
