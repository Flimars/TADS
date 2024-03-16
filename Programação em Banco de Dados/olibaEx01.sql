CREATE FUNCTION olaMundo() RETURNS varchar AS
$$
DECLARE
   msg varchar := 'Olá Mundo!';
BEGIN

END;
$$
LANGUAGE plpgsql;

SELECT olaMundo();