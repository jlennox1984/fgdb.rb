--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: gizmo_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gizmo_types_id_seq', 90, true);


--
-- Data for Name: gizmo_types; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE gizmo_types DISABLE TRIGGER ALL;

COPY gizmo_types (id, description, lock_version, updated_at, created_at, required_fee_cents, suggested_fee_cents, gizmo_category_id, name, covered, rank, effective_on, ineffective_on, parent_name, needs_id) FROM stdin;
5	zzz Old Fee Sys w/ monitor	6	2010-03-27 01:55:09.940426	2006-09-29 14:22:28	1000	0	1	old_sys_with_monitor	t	0	\N	2009-06-10 00:00:00	gizmo	t
19	zzz Old Data Gizmo	1	2008-05-30 22:30:58.534699	2006-12-30 15:01:16	0	0	4	old_data_gizmo	f	0	\N	2009-06-10 00:00:00	gizmo	f
37	Cable	1	2008-05-30 22:30:58.602659	2007-01-10 15:48:42	0	0	4	cable	f	0	\N	\N	gizmo	f
28	zzz Modem	3	2008-05-30 22:30:58.675204	2007-01-02 10:06:36	0	200	4	modem	f	0	\N	2009-06-10 00:00:00	gizmo	f
21	zzz Old Data CRT	1	2008-05-30 22:30:58.47611	2006-12-30 18:57:55	1000	0	2	old_data_crt	t	0	\N	2009-06-10 00:00:00	gizmo	f
3	zzz Old Fee CRT	4	2008-05-30 22:30:58.471207	2006-09-25 11:22:11	1000	0	2	old_crt	t	0	\N	2009-06-10 00:00:00	gizmo	f
25	zzz Stereo System	2	2008-05-30 22:30:58.568755	2007-01-02 10:04:58	0	400	4	stereo_system	f	0	\N	2009-06-10 00:00:00	gizmo	f
33	zzz Video Card	3	2008-05-30 22:30:58.588091	2007-01-02 11:50:20	0	0	4	video_card	f	0	\N	2009-06-10 00:00:00	gizmo	f
40	Laptop-As Is	2	2008-05-30 22:30:58.6221	2007-04-24 17:33:43	0	0	4	laptop_parts	f	0	\N	\N	gizmo	f
34	zzz Sound Card	2	2008-05-30 22:30:58.592979	2007-01-02 11:50:48	0	0	4	sound_card	f	0	\N	2009-06-10 00:00:00	gizmo	f
32	Optical Drive	3	2008-05-30 22:30:58.650888	2007-01-02 11:36:02	0	100	4	cd_burner	f	99	\N	\N	gizmo	f
20	zzz Old Data Schwag	1	2008-05-30 22:30:58.539574	2006-12-30 15:02:32	0	0	4	old_data_schwag	f	0	\N	2009-06-10 00:00:00	\N	f
16	zzz T-Shirt	2	2008-05-30 22:30:58.529744	2006-11-11 19:19:26	0	0	4	t-shirt	f	0	\N	2009-06-10 00:00:00	\N	f
52	Mac Part	0	\N	\N	0	0	4	mac_part	f	0	\N	\N	gizmo	f
50	System w/ CRT	1	2010-03-27 01:55:09.976426	2008-10-10 22:42:45.058719	700	0	1	system_crt	t	3	\N	\N	gizmo	t
57	PDA/MP3	1	2010-06-26 01:06:56.340275	2008-12-31 15:01:08.122445	0	100	4	pda_mp3	f	99	\N	\N	gizmo	f
15	zzz Sticker	2	2008-05-30 22:30:58.524829	2006-11-11 19:19:08	0	0	4	sticker	f	0	\N	2009-06-10 00:00:00	\N	f
13	Gizmo	5	2008-05-30 22:30:58.689829	2006-11-11 19:16:03	0	0	4	gizmo	f	0	\N	2009-11-02 00:00:00	\N	f
58	A/V	0	2008-12-31 15:01:08.126203	2008-12-31 15:01:08.126203	0	300	4	av_gizmo	f	99	\N	\N	gizmo	f
48	Fee Discount	0	2008-07-25 21:48:34.757712	2008-07-25 21:48:34.757712	0	0	4	fee_discount	f	0	\N	\N	\N	f
0	[root]	1	2008-05-30 22:30:58.680052	2008-03-27 10:41:53.50475	0	0	4	root	f	0	\N	\N	\N	f
56	Camera	0	2008-12-31 15:01:08.04977	2008-12-31 15:01:08.04977	0	200	4	camera	f	99	\N	\N	gizmo	f
43	Drive (other)	2	2008-05-30 22:30:58.636599	2007-08-22 14:03:55	0	100	4	drive_other	f	99	\N	\N	gizmo	f
26	Phone	2	2008-05-30 22:30:58.573576	2007-01-02 10:05:31	0	200	4	phone	f	99	\N	\N	gizmo	f
35	Case	1	2008-05-30 22:30:58.597832	2007-01-10 15:47:37	0	0	1	case	f	0	\N	\N	gizmo	f
31	Bag/Box Misc	3	2008-05-30 22:30:58.631744	2007-01-02 10:09:22	0	100	4	bag_box_misc	f	99	\N	\N	gizmo	f
41	RAM	1	2008-05-30 22:30:58.617271	2007-04-24 17:34:10	0	200	4	ram	f	99	\N	\N	gizmo	f
36	Network Device	2	2008-05-30 22:30:58.660627	2007-01-10 15:48:05	0	100	4	net_device	f	99	\N	\N	gizmo	f
30	Card	2	2008-05-30 22:30:58.583279	2007-01-02 10:08:06	0	100	4	card	f	99	\N	\N	gizmo	f
22	Keyboard	2	2008-05-30 22:30:58.559	2007-01-02 10:03:00	0	100	4	keyboard	f	99	\N	\N	gizmo	f
10	Printer	2	2008-05-30 22:30:58.45908	2006-11-11 19:09:26	0	400	3	printer	f	99	\N	\N	gizmo	f
17	T-Shirt/Sticker	6	2010-02-19 23:43:53.782732	2006-11-11 19:39:41	0	0	4	schwag	f	0	\N	2009-11-02 00:00:00	\N	f
12	Fax Machine	2	2008-05-30 22:30:58.443885	2006-11-11 19:13:34	0	400	3	fax_machine	f	99	\N	\N	gizmo	f
23	Mouse	2	2008-05-30 22:30:58.563893	2007-01-02 10:03:31	0	100	4	mouse	f	99	\N	\N	gizmo	f
82	T-Shirt/Sticker	0	2010-02-19 23:43:53.958732	2010-02-19 23:43:53.958732	0	0	4	schwag	f	0	2010-02-19 00:00:00	\N	gizmo	f
83	Ubuntu Book	0	2010-02-19 23:43:54.002731	2010-02-19 23:43:54.002731	0	0	4	ubuntu_book	f	99	2009-10-02 22:40:21.742427	\N	schwag	f
59	Multi-function Printer	1	2008-12-31 15:27:35.128929	2008-12-31 15:27:35.128929	0	100	3	mult_printer	f	99	\N	\N	gizmo	f
84	Scraptop--AS-IS	0	2010-02-19 23:43:54.098731	2010-02-19 23:43:54.098731	0	0	1	scraptop	f	99	2009-10-02 22:40:21.742427	\N	gizmo	f
44	TV-CRT	1	2008-05-30 22:30:58.665457	2007-10-23 19:17:36	1000	0	2	tv_crt	t	1	\N	\N	gizmo	f
49	Monitor-CRT	0	2008-10-10 22:42:44.86573	2008-10-10 22:42:44.86573	700	0	2	monitor_crt	t	2	\N	\N	gizmo	f
46	Service Fee	1	2008-05-30 22:30:58.699506	2007-12-11 17:41:55	100	0	4	service_fee	f	99	\N	\N	\N	f
29	Speaker Set	2	2008-05-30 22:30:58.578448	2007-01-02 10:07:34	0	100	4	speaker_set	f	99	\N	\N	gizmo	f
60	Miscellaneous Item	0	2008-12-31 15:27:35.20746	2008-12-31 15:27:35.20746	0	100	4	misc_item	f	99	\N	\N	gizmo	f
63	PC Part	0	2009-01-10 13:49:44.654128	2009-01-10 13:49:44.654128	0	100	4	pc_part	f	0	\N	\N	gizmo	f
42	Power supply	1	2008-05-30 22:30:58.626915	2007-04-24 17:36:24	0	100	4	power_supply	f	99	\N	\N	gizmo	f
11	Scanner	2	2008-05-30 22:30:58.454222	2006-11-11 19:09:38	0	300	3	scanner	f	99	\N	\N	gizmo	f
14	UPS	2	2008-05-30 22:30:58.544425	2006-11-11 19:18:08	0	500	4	ups	f	99	\N	\N	gizmo	f
61	Laptop Bag	0	2009-01-10 13:49:44.64376	2009-01-10 13:49:44.64376	0	100	4	laptop_bag	f	99	\N	\N	gizmo	f
62	Motherboard	0	2009-01-10 13:49:44.652469	2009-01-10 13:49:44.652469	0	100	4	motherboard	f	99	\N	\N	gizmo	f
27	Hard Drive	5	2008-05-30 22:30:58.655773	2007-01-02 10:06:08	0	100	4	hard_drive	f	99	\N	\N	gizmo	f
66	Custom Network Cable	0	2009-04-18 15:54:21.435108	2009-04-18 15:54:21.435108	0	100	4	store_test_1	f	99	\N	\N	gizmo	f
67	AC/DC Adapter	0	2009-04-18 15:54:21.439108	2009-04-18 15:54:21.439108	0	100	4	store_test_2	f	99	\N	\N	gizmo	f
7	zzz VCR	3	2008-05-30 22:30:58.549293	2006-11-11 19:08:37	0	300	4	vcr	f	0	\N	2009-06-10 00:00:00	gizmo	f
8	zzz DVD Player	3	2008-05-30 22:30:58.554147	2006-11-11 19:08:52	0	300	4	dvd_player	f	0	\N	2009-06-10 00:00:00	gizmo	f
55	TV-LCD	0	2008-12-30 13:39:46.377134	2008-12-30 13:39:46.377134	0	500	2	tv_lcd	t	5	\N	\N	gizmo	f
2	Monitor-LCD	4	2008-05-30 22:30:58.492476	2006-09-25 11:21:53	0	400	2	monitor_lcd	t	6	\N	\N	gizmo	f
65	Bargain Bin-As Is	1	2010-01-09 09:34:58.581038	2009-04-18 15:54:21.291099	0	100	4	bargain_bin	f	99	\N	2010-01-09 00:00:00	gizmo	f
80	Miscellaneous Item--AS-IS	1	2010-01-30 00:21:36.082273	2010-01-09 09:34:58.945035	0	0	4	misc_item_as_is	f	99	2009-10-02 22:40:21.742427	2010-01-30 00:00:00	\N	f
81	Miscellaneous Item--AS-IS	0	2010-01-30 00:21:36.274268	2010-01-30 00:21:36.274268	0	0	4	misc_item_as_is	f	99	2010-01-30 00:00:00	\N	gizmo	f
54	System w/ LCD	1	2010-03-27 01:55:09.984427	2008-12-30 13:39:46.30323	0	500	1	system_lcd	t	7	\N	\N	gizmo	t
75	System w/ LCD (Mac)	1	2010-03-27 01:55:09.992427	2009-11-06 13:08:57.718911	0	500	1	system_lcd_mac	t	8	2009-10-02 22:40:21.742427	\N	gizmo	t
74	System w/ CRT (Mac)	1	2010-03-27 01:55:10.008427	2009-11-06 13:07:31.542365	700	0	1	system_crt_mac	t	4	2009-10-02 22:40:21.742427	\N	gizmo	t
85	Cell Phone	0	2010-06-26 01:06:56.204274	2008-12-31 15:01:08.122445	0	100	4	cell_phone	f	99	\N	\N	gizmo	f
86	Scraptop (Mac)--AS-IS	0	2010-11-06 00:52:33.06619	2010-11-06 00:52:33.06619	0	0	1	scraptop_mac	f	99	2009-10-02 22:40:21.742427	\N	gizmo	f
88	Processor	0	2011-03-18 20:16:49.198731	2011-03-18 20:16:49.198731	0	0	4	processor	f	99	2009-10-02 22:40:21.742427	\N	gizmo	f
79	Distro CD	1	2010-02-19 23:43:53.990731	2009-11-07 10:15:35.297816	0	0	4	distro_cd	f	99	2009-10-02 22:40:21.742427	\N	schwag	f
76	Laptop (Mac)	1	2010-03-27 01:55:10.000427	2009-11-06 13:08:57.726911	0	400	1	laptop_mac	t	12	2009-10-02 22:40:21.742427	\N	gizmo	t
6	Laptop	3	2010-03-27 01:55:09.948426	2006-11-11 19:05:26	0	400	1	laptop	t	11	\N	\N	gizmo	t
4	System	8	2010-03-27 01:55:09.964426	2006-09-25 11:22:30	0	500	1	system	t	9	\N	\N	gizmo	t
39	System (Mac)	2	2010-03-27 01:55:09.956426	2007-04-19 17:26:22	0	500	1	system_mac	t	10	\N	\N	gizmo	t
45	Gift Cert	2	2011-07-16 10:37:34.000095	2007-12-11 17:01:35	0	0	4	gift_cert	f	0	\N	2011-07-15 00:00:00	\N	f
90	Server	0	2011-07-09 11:16:39.227202	2011-07-09 11:16:39.227202	0	500	1	server	f	99	2009-10-02 22:40:21.742427	\N	gizmo	t
72	T-Shirt/Sticker	0	\N	\N	0	0	4	schwag	f	99	2009-11-02 00:00:00	2010-02-19 00:00:00	\N	f
68	Store Credit	0	2009-08-12 01:46:01.251966	2009-08-12 01:46:01.251966	0	0	4	store_credit	f	99	\N	\N	\N	f
73	Gizmo	0	\N	\N	0	0	4	gizmo	f	99	2009-11-02 00:00:00	\N	\N	f
89	Game	0	2011-06-04 16:26:50.390878	2011-06-04 16:26:50.390878	0	200	4	game	f	99	2009-10-02 22:40:21.742427	\N	gizmo	f
\.


ALTER TABLE gizmo_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

