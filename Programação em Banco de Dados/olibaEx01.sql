CREATE FUNCTION olaMundo() RETURNS varchar AS
$$
DECLARE
   msg varchar := 'Olá Mundo!';
BEGIN
   RETURN msg;
END;
$$
LANGUAGE plpgsql;

SELECT olaMundo();