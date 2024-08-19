-- Removendo a função se ela existir.
-- Drop the function if it exists
DROP FUNCTION IF EXISTS ftoc(float8);

-- Create the function
CREATE OR REPLACE FUNCTION ftoc(f float8)
RETURNS float8 AS
$$
    SELECT ((f - 32.0) * 5.0 / 9.0)
$$ LANGUAGE SQL;

-- Test the function
SELECT ftoc(68::float8);
