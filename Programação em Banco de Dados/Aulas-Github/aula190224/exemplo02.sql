-- Exemplo: Função que concatena textos

-- Criando a função
CREATE FUNCTION soma(text, text) RETURNS char AS
$$
DECLARE
resultado text;
BEGIN
resultado := $1 || $2;
return resultado;
END;
$$ LANGUAGE plpgsql;

-- Chamada
SELECT soma('Sidney ','Silva');
