--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: discount_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('discount_schedules_id_seq', 9, true);


--
-- Data for Name: discount_schedules; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE discount_schedules DISABLE TRIGGER ALL;

COPY discount_schedules (id, description, lock_version, updated_at, created_at, name) FROM stdin;
4	volunteer	0	2006-12-19 17:48:31	2006-12-19 17:48:31	volunteer
9	no discount	0	2006-12-20 08:31:27	2006-12-20 08:31:27	no_discount
8	bulk	0	2006-12-19 18:27:48	2006-12-19 18:27:48	bulk
5	friend	1	2006-12-20 08:31:02	2006-12-19 17:51:03	friend
\.


ALTER TABLE discount_schedules ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

