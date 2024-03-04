--
-- PostgreSQL database dump
--

-- Dumped from database version 11.3
-- Dumped by pg_dump version 11.3

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

SET default_with_oids = false;

--
-- Name: region; Type: TABLE; Schema: public; Owner: bruno
--

CREATE TABLE public.Region (
    id_region integer NOT NULL,
    ref_region character varying(9) NOT NULL,
    nom_region character varying(30) NOT NULL
);


ALTER TABLE public.Region OWNER TO bruno;

--
-- Data for Name: Region; Type: TABLE DATA; Schema: public; Owner: bruno
--

COPY public.Region (id_region, ref_region, nom_region) FROM stdin;
1	region91	Guadeloupe
2	region92	Martinique
3	region93	Guyane
4	region94	La Réunion
5	region95	Mayotte
6	region11	Île-de-France
7	region24	Centre-Val de Loire
8	region2	Bourgogne-Franche-Comté
9	region7	Normandie
10	region9	Hauts-de-France
11	region1	Grand Est
12	region8	Pays de la Loire
13	region6	Bretagne
14	region10	Nouvelle-Aquitaine
15	region5	Occitanie
16	region3	Auvergne-Rhône-Alpes
17	region4	Provence-Alpes-Côte d'Azur
18	region96	Corse
19	regioncom	Collectivités d'Outre-Mer
\.


--
-- Name: Region pk_region; Type: CONSTRAINT; Schema: public; Owner: bruno
--

ALTER TABLE ONLY public.Region
    ADD CONSTRAINT pk_region PRIMARY KEY (id_region);


--
-- Name: region_pk; Type: INDEX; Schema: public; Owner: bruno
--

CREATE UNIQUE INDEX region_pk ON public.Region USING btree (id_region);


--
-- PostgreSQL database dump complete
--

