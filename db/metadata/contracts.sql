--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE contracts DISABLE TRIGGER ALL;

COPY contracts (id, name, description, label, notes, created_at, updated_at, instantiable) FROM stdin;
1	default	normal	No Sticker	\N	2008-11-01 03:36:20.074472	2009-10-02 22:40:21.882428	t
\.


ALTER TABLE contracts ENABLE TRIGGER ALL;

--
-- Name: contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contracts_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

