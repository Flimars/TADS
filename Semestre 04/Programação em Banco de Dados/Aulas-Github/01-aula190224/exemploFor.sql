CREATE OR REPLACE FUNCTION calculadomaiorsalario(codigo INTEGER) RETURNS real AS
$$
DECLARE
       r_funcionario RECORD;
	   salario REAL;

BEGIN
   salario := 0;
   for r_funcionario IN SELECT  * FROM funcionario loop
   RAISE NOTICE 'funcionario: %, %, %, %', r_funcionario.codigo, r_funcionario.nome, r_funcionario.departamento, r_funcionario.salario;
   IF(r_funcionario.departamento = codigo) AND (r_funcionario.salario > salario) THEN
   		salario := r_funcionario;
	END IF;
  END loop;
  return salario;
END;
$$ language plpgsql;
