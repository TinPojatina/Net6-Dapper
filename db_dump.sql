--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2023-04-05 00:03:52

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

DROP DATABASE my_database;
--
-- TOC entry 3336 (class 1262 OID 16514)
-- Name: my_database; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE my_database WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Croatian_Croatia.1252';


ALTER DATABASE my_database OWNER TO postgres;

\connect my_database

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3337 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16541)
-- Name: machines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.machines (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.machines OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16540)
-- Name: machines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.machines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.machines_id_seq OWNER TO postgres;

--
-- TOC entry 3338 (class 0 OID 0)
-- Dependencies: 214
-- Name: machines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.machines_id_seq OWNED BY public.machines.id;


--
-- TOC entry 217 (class 1259 OID 16548)
-- Name: malfunctions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.malfunctions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    machineid integer,
    priority character varying(50) NOT NULL,
    starttime timestamp without time zone NOT NULL,
    endtime timestamp without time zone,
    description text NOT NULL,
    isfixed boolean NOT NULL
);


ALTER TABLE public.malfunctions OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16547)
-- Name: malfunctions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.malfunctions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.malfunctions_id_seq OWNER TO postgres;

--
-- TOC entry 3339 (class 0 OID 0)
-- Dependencies: 216
-- Name: malfunctions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.malfunctions_id_seq OWNED BY public.malfunctions.id;


--
-- TOC entry 3178 (class 2604 OID 16544)
-- Name: machines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.machines ALTER COLUMN id SET DEFAULT nextval('public.machines_id_seq'::regclass);


--
-- TOC entry 3179 (class 2604 OID 16551)
-- Name: malfunctions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.malfunctions ALTER COLUMN id SET DEFAULT nextval('public.malfunctions_id_seq'::regclass);


--
-- TOC entry 3328 (class 0 OID 16541)
-- Dependencies: 215
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.machines (id, name) FROM stdin;
1	Machine A
2	Machine B
3	Machine C
4	Works?
5	Machine D
\.


--
-- TOC entry 3330 (class 0 OID 16548)
-- Dependencies: 217
-- Data for Name: malfunctions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.malfunctions (id, name, machineid, priority, starttime, endtime, description, isfixed) FROM stdin;
1	Malfunction 1	1	Low	2023-05-01 08:00:00	2023-05-01 09:00:00	Issue with motor	t
2	Malfunction 2	1	High	2023-05-02 10:00:00	2023-05-02 12:00:00	Broken belt	t
3	Malfunction 3	2	Medium	2023-05-03 14:00:00	2023-05-03 15:30:00	Overheating issue	f
4	Malfunction 4	3	Low	2023-05-04 16:00:00	2023-05-04 16:30:00	Loose screw	t
5	Malfunction 5	1	High	2023-05-05 18:00:00	\N	Severe electrical issue	f
6	Malfunction 6	2	Medium	2023-05-06 20:00:00	2023-05-06 22:00:00	Leaking oil	t
7	Malfunction 7	3	Low	2023-05-07 23:00:00	2023-05-08 00:00:00	Noisy operation	t
8	Malfunction 8	3	High	2023-05-08 02:00:00	2023-05-08 06:00:00	Failed component	f
9	Malfunction 9	2	Medium	2023-05-09 08:00:00	2023-05-09 10:00:00	Software error	t
10	Malfunction 10	1	Low	2023-05-10 12:00:00	2023-05-10 12:30:00	Dust buildup	t
\.


--
-- TOC entry 3340 (class 0 OID 0)
-- Dependencies: 214
-- Name: machines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.machines_id_seq', 5, true);


--
-- TOC entry 3341 (class 0 OID 0)
-- Dependencies: 216
-- Name: malfunctions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.malfunctions_id_seq', 10, true);


--
-- TOC entry 3181 (class 2606 OID 16546)
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id);


--
-- TOC entry 3183 (class 2606 OID 16555)
-- Name: malfunctions malfunctions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.malfunctions
    ADD CONSTRAINT malfunctions_pkey PRIMARY KEY (id);


--
-- TOC entry 3184 (class 2606 OID 16556)
-- Name: malfunctions malfunctions_machineid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.malfunctions
    ADD CONSTRAINT malfunctions_machineid_fkey FOREIGN KEY (machineid) REFERENCES public.machines(id) ON DELETE CASCADE;


-- Completed on 2023-04-05 00:03:52

--
-- PostgreSQL database dump complete
--

