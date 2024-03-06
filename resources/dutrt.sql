--
-- PostgreSQL database dump
--
-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: modules; Type: TABLE; Schema: public; Owner: testrt
--

CREATE TABLE public.modules (
    id_mod integer NOT NULL,
    ref_mod character varying(10) NOT NULL,
    descr_mod character varying(100) NOT NULL,
    coef_mod numeric(5,3) NOT NULL
);


ALTER TABLE public.modules OWNER TO testrt;

--
-- Name: modules_id_mod_seq; Type: SEQUENCE; Schema: public; Owner: testrt
--

CREATE SEQUENCE public.modules_id_mod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.modules_id_mod_seq OWNER TO testrt;

--
-- Name: modules_id_mod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testrt
--

ALTER SEQUENCE public.modules_id_mod_seq OWNED BY public.modules.id_mod;


--
-- Name: users; Type: TABLE; Schema: public; Owner: testrt
--

CREATE TABLE public.users (
    id_user integer NOT NULL,
    login character varying(30) NOT NULL,
    mdp character varying(200) NOT NULL,
    role character varying(30) DEFAULT 'user'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO testrt;

--
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: testrt
--

CREATE SEQUENCE public.users_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_user_seq OWNER TO testrt;

--
-- Name: users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testrt
--

ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;


--
-- Name: modules id_mod; Type: DEFAULT; Schema: public; Owner: testrt
--

ALTER TABLE ONLY public.modules ALTER COLUMN id_mod SET DEFAULT nextval('public.modules_id_mod_seq'::regclass);


--
-- Name: users id_user; Type: DEFAULT; Schema: public; Owner: testrt
--

ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);


--
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: testrt
--

COPY public.modules (id_mod, ref_mod, descr_mod, coef_mod) FROM stdin;
2	M1102	Initiation à la téléphonie d'entreprise	2.000
7	M1107	Initiation à la mesure du signal	1.500
5	M1105	Bases des systèmes d'exploitation	2.000
3	M1103	Architecture des équipements informatiques	1.500
12	M1203	PPP: Connaitre son champ d'activité	3.000
17	M1208	Adaptation et méthodologie pour la réussite Universitaire	1.000
11	M1202	EC: Éléments fondamentaux de la communication	2.000
18	M2101	Réseaux locaux et équipements actifs 	1.500
15	M1206	Circuits électroniques : mise à niveau	2.000
27	M2201	Développement de l\\'anglais technique et nouvelles technologies	3.000
30	M2204	Calcul différentiel et intégral	1.500
37	M3103	Technologies d\\'accès	1.500
40	M3106	Transmission large bande	1.500
48	M3205	Transmissions guidées en hyperfréquence et optique	2.000
54	M4202	Culture Communication : Communiquer pour mettre en valeur ses compétences	1.000
55	M4203	Monde de l\\'entreprise	1.000
6	M1106	Initiation au développement Web	1.500
8	M1108	Acquisition et codage de l\\'information	1.500
4	M1104	Principe et architecture des réseaux	2.000
9	M1109	PT : Mise en application de la communication et des techniques documentaires	1.000
10	M1201	Anglais général de communication et initiation au vocabulaire technique	2.000
14	M1205	Harmonisation des connaissances et des outils pour le signal	2.000
16	M1207	Bases de la programmation	2.000
13	M1204	Mise à niveau en numération et calculs	2.000
20	M2103	Technologie de l\\'Internet	3.000
19	M2102	Administration système	1.500
28	M2202	EC: Se documenter, informer et argumenter	2.000
22	M2105	Web dynamique	1.500
21	M2104	Bases de données	1.500
29	M2203	PPP: Savoir parler de soi	1.000
26	M2109	PT : Description et planification de projet	2.000
23	M2106	Bases des services réseaux	1.500
25	M2108	Chaines de transmission numérique 	3.000
24	M2107	Principes des transmissions radio	1.500
32	M2206	Bases de l\\'électromagnétisme pour la propagation	1.500
34	M2208	Consolidation de la méthodologie pour la réussite Universitaire	1.000
33	M2207	Consolidation des bases de la programmation	1.500
31	M2205	Analyse de Fourier	1.500
39	M3105	Services réseaux avancés	1.500
36	M3102	Technologie de réseaux d\\'opérateurs	3.000
38	M3104	Gestion d\\'annuaires unifiés	1.500
35	M3101	Infrastructure sans fil d\\'entreprise	1.500
47	M3204	Matrices et graphes	2.000
44	M3201	Anglais: Le monde du travail	3.000
43	M3109	PT :Gestion de projet	1.000
45	M3202	EC: S\\'insérer dans le milieu professionnel	2.000
49	M3206	Automatisation des tâches d\\'administration	2.000
50	M3207	Sécurité et performance	2.000
41	M3107	Réseaux cellulaires	1.500
46	M3203	PPP : Savoir collaborer	1.000
51	M4101	PT : Gestion de projet pour le projet tutoré	4.000
53	M4201	Anglais : L\\'insertion professionnelle	1.000
56	M4204	Connaissances de l\\'entreprise (économie, droit, gestion,..)	2.000
52	M4102	Stage	12.000
42	M3108C	Supervision des réseaux	2.000
1	M1101	Initiation aux réseaux d'entreprises	3.000
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: testrt
--

COPY public.users (id_user, login, mdp, role) FROM stdin;
\.


--
-- Name: modules_id_mod_seq; Type: SEQUENCE SET; Schema: public; Owner: testrt
--

SELECT pg_catalog.setval('public.modules_id_mod_seq', 57, true);


--
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: testrt
--

SELECT pg_catalog.setval('public.users_id_user_seq', 3, true);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: testrt
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id_mod);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: testrt
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- Name: TABLE modules; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL ON TABLE public.modules TO PUBLIC;


--
-- Name: COLUMN modules.id_mod; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL(id_mod) ON TABLE public.modules TO testrt;
GRANT ALL(id_mod) ON TABLE public.modules TO PUBLIC;


--
-- Name: COLUMN modules.ref_mod; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL(ref_mod) ON TABLE public.modules TO testrt;
GRANT ALL(ref_mod) ON TABLE public.modules TO PUBLIC;


--
-- Name: COLUMN modules.descr_mod; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL(descr_mod) ON TABLE public.modules TO testrt;
GRANT ALL(descr_mod) ON TABLE public.modules TO PUBLIC;


--
-- Name: COLUMN modules.coef_mod; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL(coef_mod) ON TABLE public.modules TO testrt;
GRANT ALL(coef_mod) ON TABLE public.modules TO PUBLIC;


--
-- Name: SEQUENCE modules_id_mod_seq; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL ON SEQUENCE public.modules_id_mod_seq TO PUBLIC;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL ON TABLE public.users TO PUBLIC;


--
-- Name: COLUMN users.id_user; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL(id_user) ON TABLE public.users TO testrt;
GRANT ALL(id_user) ON TABLE public.users TO PUBLIC;


--
-- Name: COLUMN users.login; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL(login) ON TABLE public.users TO testrt;
GRANT ALL(login) ON TABLE public.users TO PUBLIC;


--
-- Name: COLUMN users.mdp; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL(mdp) ON TABLE public.users TO testrt;
GRANT ALL(mdp) ON TABLE public.users TO PUBLIC;


--
-- Name: SEQUENCE users_id_user_seq; Type: ACL; Schema: public; Owner: testrt
--

GRANT ALL ON SEQUENCE public.users_id_user_seq TO PUBLIC;


--
-- PostgreSQL database dump complete
--

