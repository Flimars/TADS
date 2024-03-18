-- REMOVENDO A FUNÇÃO
-- DROP FUNCTION test(TEXT[]);

CREATE OR REPLACE FUNCTION test(in_array TEXT[]) RETURNS void AS
$$
DECLARE
    t TEXT;

BEGIN
    FOREACH t IN ARRAY in_array LOOP
        raise notice 't: %', t;
    END loop;
END;
$$ LANGUAGE plpgsql;

-- CHAMADA DA FUNÇÃO.
SELECT test(array['a', 'b', 'c']);