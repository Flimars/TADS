--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: atendimentos_anteriores(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.atendimentos_anteriores(character) RETURNS TABLE(data_hora_inicio timestamp without time zone, data_hora_fim timestamp without time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY 
    SELECT atendimento.data_hora_inicio, atendimento.data_hora_fim 
    FROM paciente 
    INNER JOIN atendimento ON (paciente.id = atendimento.paciente_id) 
    WHERE paciente.cpf = $1;
END;
$_$;


ALTER FUNCTION public.atendimentos_anteriores(character) OWNER TO postgres;

--
-- Name: faturamento_por_mes(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.faturamento_por_mes(mes integer) RETURNS money
    LANGUAGE plpgsql
    AS $$
DECLARE
    somatorio MONEY;
BEGIN
    SELECT COALESCE(SUM(
        valor_consulta + 
        valor_por_hora_fisioterapeuta * 
        transforma_para_horas(data_hora_fim - data_hora_inicio)
    ), 0::MONEY) INTO somatorio
    FROM atendimento
    WHERE EXTRACT(MONTH FROM data_hora_inicio) = mes
    AND data_hora_fim IS NOT NULL;

    RETURN somatorio;
END;
$$;


ALTER FUNCTION public.faturamento_por_mes(mes integer) OWNER TO postgres;

--
-- Name: formata_cep(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.formata_cep(cep character) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN SUBSTRING(cep, 1, 2) || '.' ||
           SUBSTRING(cep, 3, 3) || '-' ||
           SUBSTRING(cep, 6);
END;
$$;


ALTER FUNCTION public.formata_cep(cep character) OWNER TO postgres;

--
-- Name: formata_telefone(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.formata_telefone(telefone character) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN '(' || SUBSTRING(telefone, 1, 3) || ') ' ||
           SUBSTRING(telefone, 4, 3) || '-' ||
           SUBSTRING(telefone, 7);
END;
$$;


ALTER FUNCTION public.formata_telefone(telefone character) OWNER TO postgres;

--
-- Name: paciente_nro_atendimentos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.paciente_nro_atendimentos() RETURNS TABLE(id integer, nome character varying, qtde bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH atendimentos_por_paciente AS (
        SELECT 
            p.id,
            p.nome,
            COUNT(*) AS qtde_atendimentos
        FROM 
            paciente p
            INNER JOIN atendimento a ON a.paciente_id = p.id
        GROUP BY 
            p.id, p.nome
    ),
    max_atendimentos AS (
        SELECT MAX(qtde_atendimentos) AS max_qtde
        FROM atendimentos_por_paciente
    )
    SELECT 
        ap.id,
        ap.nome,
        ap.qtde_atendimentos AS qtde
    FROM 
        atendimentos_por_paciente ap,
        max_atendimentos m
    WHERE 
        ap.qtde_atendimentos = m.max_qtde
    ORDER BY 
        ap.id;
END;
$$;


ALTER FUNCTION public.paciente_nro_atendimentos() OWNER TO postgres;

--
-- Name: transforma_para_horas(interval); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.transforma_para_horas(duracao interval) RETURNS real
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN EXTRACT(EPOCH FROM duracao) / 3600.0;
END;
$$;


ALTER FUNCTION public.transforma_para_horas(duracao interval) OWNER TO postgres;

--
-- Name: valida_cpf(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.valida_cpf(cpf character) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
    soma INTEGER;
    resto INTEGER;
    digito1 INTEGER;
    digito2 INTEGER;
BEGIN
    -- Verifica se o CPF tem 11 dÃ­gitos
    IF LENGTH(cpf) != 11 THEN
        RETURN FALSE;
    END IF;

    -- Verifica se todos os dÃ­gitos sÃ£o iguais
    IF cpf ~ '^(\d)\1{10}$' THEN
        RETURN FALSE;
    END IF;

    -- Calcula o primeiro dÃ­gito verificador
    soma := 0;
    FOR i IN 1..9 LOOP
        soma := soma + (SUBSTRING(cpf FROM i FOR 1)::INTEGER * (11 - i));
    END LOOP;
    resto := soma % 11;
    digito1 := CASE WHEN resto < 2 THEN 0 ELSE 11 - resto END;

    -- Calcula o segundo dÃ­gito verificador
    soma := 0;
    FOR i IN 1..10 LOOP
        soma := soma + (SUBSTRING(cpf FROM i FOR 1)::INTEGER * (12 - i));
    END LOOP;
    resto := soma % 11;
    digito2 := CASE WHEN resto < 2 THEN 0 ELSE 11 - resto END;

    -- Verifica se os dÃ­gitos calculados sÃ£o iguais aos do CPF
    RETURN SUBSTRING(cpf FROM 10 FOR 1)::INTEGER = digito1 
       AND SUBSTRING(cpf FROM 11 FOR 1)::INTEGER = digito2;
END;
$_$;


ALTER FUNCTION public.valida_cpf(cpf character) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: atendimento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atendimento (
    id integer NOT NULL,
    fisioterapeuta_id integer,
    paciente_id integer,
    data_hora_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    data_hora_fim timestamp without time zone,
    observacao text,
    nota integer,
    valor_consulta money DEFAULT 100,
    valor_por_hora_fisioterapeuta money,
    CONSTRAINT atendimento_nota_check CHECK (((nota > 0) AND (nota <= 5)))
);


ALTER TABLE public.atendimento OWNER TO postgres;

--
-- Name: atendimento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.atendimento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.atendimento_id_seq OWNER TO postgres;

--
-- Name: atendimento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.atendimento_id_seq OWNED BY public.atendimento.id;


--
-- Name: fisioterapeuta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fisioterapeuta (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    cpf character(11),
    crefito text NOT NULL,
    valor_por_hora money
);


ALTER TABLE public.fisioterapeuta OWNER TO postgres;

--
-- Name: fisioterapeuta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fisioterapeuta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fisioterapeuta_id_seq OWNER TO postgres;

--
-- Name: fisioterapeuta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fisioterapeuta_id_seq OWNED BY public.fisioterapeuta.id;


--
-- Name: paciente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paciente (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    cpf character(11),
    telefone character(12),
    bairro text,
    rua text,
    complemento text,
    numero text,
    cep character(8)
);


ALTER TABLE public.paciente OWNER TO postgres;

--
-- Name: paciente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paciente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paciente_id_seq OWNER TO postgres;

--
-- Name: paciente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paciente_id_seq OWNED BY public.paciente.id;


--
-- Name: atendimento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atendimento ALTER COLUMN id SET DEFAULT nextval('public.atendimento_id_seq'::regclass);


--
-- Name: fisioterapeuta id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fisioterapeuta ALTER COLUMN id SET DEFAULT nextval('public.fisioterapeuta_id_seq'::regclass);


--
-- Name: paciente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente ALTER COLUMN id SET DEFAULT nextval('public.paciente_id_seq'::regclass);


--
-- Data for Name: atendimento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.atendimento (id, fisioterapeuta_id, paciente_id, data_hora_inicio, data_hora_fim, observacao, nota, valor_consulta, valor_por_hora_fisioterapeuta) FROM stdin;
1	2	3	2023-10-27 14:30:09	2023-10-27 15:28:39	Acompanhamento pos-cirurgico	5	R$ 100,00	R$ 90,00
2	1	1	2023-04-01 14:38:42	2023-04-01 15:38:42	Atendimento normal	5	R$ 100,00	R$ 150,00
3	2	2	2023-04-02 16:28:12	2023-04-02 17:28:02	Atendimento com dificuldade	4	R$ 100,00	R$ 120,00
4	3	3	2023-04-03 18:18:06	2023-04-03 19:18:00	Atendimento eficiente	5	R$ 100,00	R$ 180,00
5	4	4	2023-04-04 20:18:36	2023-04-04 21:18:36	Atendimento tranquilo	4	R$ 100,00	R$ 160,00
6	5	5	2023-04-05 22:05:36	2023-04-06 00:05:16	Atendimento prolongado	5	R$ 100,00	R$ 140,00
7	5	1	2024-04-07 08:00:00	2024-04-07 09:00:00	Atendimento matinal	5	R$ 100,00	R$ 150,00
8	2	8	2024-04-08 10:00:00	2024-04-08 11:00:00	Atendimento diurno	4	R$ 100,00	R$ 120,00
9	3	13	2024-05-09 12:00:00	2024-05-09 13:00:00	Atendimento vespertino	5	R$ 100,00	R$ 180,00
10	1	4	2024-05-10 14:00:00	2024-05-10 15:00:00	Atendimento a tarde	4	R$ 100,00	R$ 160,00
11	5	5	2024-06-11 16:00:00	2024-06-11 17:00:00	Atendimento noturno	5	R$ 100,00	R$ 140,00
12	1	\N	2024-07-12 18:00:00	2024-07-12 19:00:00	Fisioterapeuta sem atendimento	\N	R$ 100,00	\N
13	2	6	2024-07-13 20:00:00	2024-07-13 21:00:00	Atendimento especial	5	R$ 100,00	R$ 150,00
14	3	7	2024-07-14 22:00:00	2024-07-15 00:00:00	Atendimento prolongado	4	R$ 100,00	R$ 120,00
15	4	8	2024-07-15 08:00:00	2024-07-15 09:00:00	Atendimento matinal	5	R$ 100,00	R$ 180,00
16	5	9	2024-07-16 10:00:00	2024-07-16 11:00:00	Atendimento diurno	4	R$ 100,00	R$ 160,00
17	2	10	2024-07-17 12:00:00	2024-07-17 13:00:00	Atendimento vespertino	5	R$ 100,00	R$ 140,00
18	3	11	2024-07-18 14:00:00	2024-07-18 15:00:00	Atendimento a tarde	4	R$ 100,00	R$ 150,00
19	4	12	2024-07-19 16:00:00	2024-07-19 17:00:00	Atendimento noturno	5	R$ 100,00	R$ 120,00
20	5	13	2024-07-20 18:00:00	2024-07-20 19:00:00	Atendimento especial	5	R$ 100,00	R$ 180,00
21	5	14	2024-07-21 20:00:00	2024-07-21 21:00:00	Atendimento prolongado	4	R$ 100,00	R$ 160,00
\.


--
-- Data for Name: fisioterapeuta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fisioterapeuta (id, nome, cpf, crefito, valor_por_hora) FROM stdin;
1	Jonas	12345678901	CRF1234	R$ 80,00
2	Maria	98765432101	CRF5678	R$ 90,00
3	Pedro	11122233344	CRF9876	R$ 75,00
4	Ana	55566677788	CRF5432	R$ 85,00
5	Carlos	99988877766	CRF2468	R$ 70,00
\.


--
-- Data for Name: paciente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paciente (id, nome, cpf, telefone, bairro, rua, complemento, numero, cep) FROM stdin;
1	Lucas Rossales	11122233344	519990099   	Centro	Rua A	Apto 101	123	12345678
2	Pedro Almeida	87654321098	21987654321 	Centro	Rua das Flores	Ap. 101	10	20030000
3	Luciana Ferreira	76543210987	22654321098 	Jardim	Avenida das Palmas	Bloco B	202	22050001
4	Rafael Mendonca	65432109876	23543210987 	Vila	Travessa dos Passaros	Lado A	203	23060002
5	Gabriel Ribeiro	54321098765	24432109876 	Santa Tereza	Estrada dos Ipes	Casa 104	204	24070003
6	Maria Isabel	43210987654	53321098765 	Pina	Alameda das Mangueiras	Lado Impar	665	96200214
7	Karla Bittencurt	70794835066	53321098765 	Pinhal	Francisco Pastore	Casa	251	96211014
8	Emerson Goncalves	86027618051	53321098765 	Parque Marinha	Atol das Rocas	Casa	153	96202350
9	Cristiano Azevedo	89313155036	53321098765 	Cidade Nova	Tiradentes	Apto 205	225	96202060
10	Yasmim Saraiva	96747262093	54321098765 	Centro	Galopoles	Casa	2631	95050000
11	Priscila Alvares	32643310047	51321098765 	Santa Tereza	Vila Mangueiras	Casa	705	92450690
12	Cleinton Machado	98508461003	51321098765 	Parque Marinha	Independencia	Lado Par	880	90830492
13	Hugo Souza	22310801097	51321098765 	Juncao	Henrique Dias	Casa	111	92110042
14	Alice Sanches	66024071043	54321098765 	Centro	Bento Goncalves	Casa	451	25045110
\.


--
-- Name: atendimento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.atendimento_id_seq', 21, true);


--
-- Name: fisioterapeuta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fisioterapeuta_id_seq', 5, true);


--
-- Name: paciente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paciente_id_seq', 14, true);


--
-- Name: atendimento atendimento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atendimento
    ADD CONSTRAINT atendimento_pkey PRIMARY KEY (id);


--
-- Name: fisioterapeuta fisioterapeuta_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fisioterapeuta
    ADD CONSTRAINT fisioterapeuta_cpf_key UNIQUE (cpf);


--
-- Name: fisioterapeuta fisioterapeuta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fisioterapeuta
    ADD CONSTRAINT fisioterapeuta_pkey PRIMARY KEY (id);


--
-- Name: paciente paciente_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_cpf_key UNIQUE (cpf);


--
-- Name: paciente paciente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_pkey PRIMARY KEY (id);


--
-- Name: atendimento atendimento_fisioterapeuta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atendimento
    ADD CONSTRAINT atendimento_fisioterapeuta_id_fkey FOREIGN KEY (fisioterapeuta_id) REFERENCES public.fisioterapeuta(id);


--
-- Name: atendimento atendimento_paciente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atendimento
    ADD CONSTRAINT atendimento_paciente_id_fkey FOREIGN KEY (paciente_id) REFERENCES public.paciente(id);


--
-- PostgreSQL database dump complete
--

