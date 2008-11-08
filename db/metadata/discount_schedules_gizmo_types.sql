--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: discount_schedules_gizmo_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('discount_schedules_gizmo_types_id_seq', 285, true);


--
-- Data for Name: discount_schedules_gizmo_types; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE discount_schedules_gizmo_types DISABLE TRIGGER ALL;

COPY discount_schedules_gizmo_types (id, gizmo_type_id, discount_schedule_id, multiplier, lock_version, updated_at, created_at) FROM stdin;
34	5	8	\N	0	2006-12-20 08:58:11	2006-12-20 08:58:11
35	5	9	\N	0	2006-12-20 08:58:11	2006-12-20 08:58:11
36	5	4	\N	0	2006-12-20 08:58:11	2006-12-20 08:58:11
37	5	5	\N	0	2006-12-20 08:58:11	2006-12-20 08:58:11
38	19	8	1.000	0	2006-12-30 15:01:16	2006-12-30 15:01:16
39	19	9	1.000	0	2006-12-30 15:01:16	2006-12-30 15:01:16
40	19	4	0.500	0	2006-12-30 15:01:16	2006-12-30 15:01:16
41	19	5	1.000	0	2006-12-30 15:01:16	2006-12-30 15:01:16
42	20	8	1.000	0	2006-12-30 15:02:32	2006-12-30 15:02:32
43	20	9	1.000	0	2006-12-30 15:02:32	2006-12-30 15:02:32
44	20	4	0.900	0	2006-12-30 15:02:32	2006-12-30 15:02:32
45	20	5	1.000	0	2006-12-30 15:02:32	2006-12-30 15:02:32
46	21	8	\N	0	2006-12-30 18:57:55	2006-12-30 18:57:55
47	21	9	\N	0	2006-12-30 18:57:55	2006-12-30 18:57:55
48	21	4	\N	0	2006-12-30 18:57:55	2006-12-30 18:57:55
49	21	5	\N	0	2006-12-30 18:57:55	2006-12-30 18:57:55
90	14	8	\N	0	2007-01-02 10:11:17	2007-01-02 10:11:17
91	14	9	\N	0	2007-01-02 10:11:17	2007-01-02 10:11:17
92	14	4	\N	0	2007-01-02 10:11:17	2007-01-02 10:11:17
93	14	5	\N	0	2007-01-02 10:11:18	2007-01-02 10:11:18
94	2	8	\N	0	2007-01-02 10:11:46	2007-01-02 10:11:46
95	2	9	\N	0	2007-01-02 10:11:46	2007-01-02 10:11:46
96	2	4	\N	0	2007-01-02 10:11:46	2007-01-02 10:11:46
97	2	5	\N	0	2007-01-02 10:11:46	2007-01-02 10:11:46
98	7	8	\N	0	2007-01-02 10:12:04	2007-01-02 10:12:04
99	7	9	\N	0	2007-01-02 10:12:04	2007-01-02 10:12:04
100	7	4	\N	0	2007-01-02 10:12:04	2007-01-02 10:12:04
101	7	5	\N	0	2007-01-02 10:12:04	2007-01-02 10:12:04
102	8	8	\N	0	2007-01-02 10:12:10	2007-01-02 10:12:10
103	8	9	\N	0	2007-01-02 10:12:10	2007-01-02 10:12:10
104	8	4	\N	0	2007-01-02 10:12:10	2007-01-02 10:12:10
105	8	5	\N	0	2007-01-02 10:12:10	2007-01-02 10:12:10
126	6	8	\N	0	2007-01-02 15:35:07	2007-01-02 15:35:07
127	6	9	\N	0	2007-01-02 15:35:07	2007-01-02 15:35:07
128	6	4	\N	0	2007-01-02 15:35:07	2007-01-02 15:35:07
129	6	5	\N	0	2007-01-02 15:35:07	2007-01-02 15:35:07
134	17	8	1.000	0	2007-01-02 15:35:38	2007-01-02 15:35:38
135	17	9	1.000	0	2007-01-02 15:35:38	2007-01-02 15:35:38
136	17	4	0.900	0	2007-01-02 15:35:38	2007-01-02 15:35:38
137	17	5	0.950	0	2007-01-02 15:35:38	2007-01-02 15:35:38
138	18	8	1.000	0	2007-01-02 15:36:07	2007-01-02 15:36:07
139	18	9	1.000	0	2007-01-02 15:36:07	2007-01-02 15:36:07
140	18	4	0.900	0	2007-01-02 15:36:07	2007-01-02 15:36:07
141	18	5	1.000	0	2007-01-02 15:36:07	2007-01-02 15:36:07
142	22	8	\N	0	2007-01-02 15:38:40	2007-01-02 15:38:40
143	22	9	\N	0	2007-01-02 15:38:40	2007-01-02 15:38:40
144	22	4	\N	0	2007-01-02 15:38:40	2007-01-02 15:38:40
145	22	5	\N	0	2007-01-02 15:38:40	2007-01-02 15:38:40
146	23	8	\N	0	2007-01-02 15:38:47	2007-01-02 15:38:47
147	23	9	\N	0	2007-01-02 15:38:48	2007-01-02 15:38:48
148	23	4	\N	0	2007-01-02 15:38:48	2007-01-02 15:38:48
149	23	5	\N	0	2007-01-02 15:38:48	2007-01-02 15:38:48
150	25	8	\N	0	2007-01-02 15:38:54	2007-01-02 15:38:54
151	25	9	\N	0	2007-01-02 15:38:54	2007-01-02 15:38:54
152	25	4	\N	0	2007-01-02 15:38:54	2007-01-02 15:38:54
153	25	5	\N	0	2007-01-02 15:38:54	2007-01-02 15:38:54
154	26	8	\N	0	2007-01-02 15:39:02	2007-01-02 15:39:02
155	26	9	\N	0	2007-01-02 15:39:02	2007-01-02 15:39:02
156	26	4	\N	0	2007-01-02 15:39:02	2007-01-02 15:39:02
157	26	5	\N	0	2007-01-02 15:39:02	2007-01-02 15:39:02
166	29	8	\N	0	2007-01-02 15:39:46	2007-01-02 15:39:46
167	29	9	\N	0	2007-01-02 15:39:46	2007-01-02 15:39:46
168	29	4	\N	0	2007-01-02 15:39:46	2007-01-02 15:39:46
169	29	5	\N	0	2007-01-02 15:39:46	2007-01-02 15:39:46
170	30	8	\N	0	2007-01-02 15:39:54	2007-01-02 15:39:54
171	30	9	\N	0	2007-01-02 15:39:54	2007-01-02 15:39:54
172	30	4	\N	0	2007-01-02 15:39:54	2007-01-02 15:39:54
173	30	5	\N	0	2007-01-02 15:39:54	2007-01-02 15:39:54
178	33	8	\N	0	2007-01-02 15:40:19	2007-01-02 15:40:19
179	33	9	\N	0	2007-01-02 15:40:19	2007-01-02 15:40:19
180	33	4	\N	0	2007-01-02 15:40:19	2007-01-02 15:40:19
181	33	5	\N	0	2007-01-02 15:40:19	2007-01-02 15:40:19
182	34	8	\N	0	2007-01-02 15:40:32	2007-01-02 15:40:32
183	34	9	\N	0	2007-01-02 15:40:32	2007-01-02 15:40:32
184	34	4	\N	0	2007-01-02 15:40:32	2007-01-02 15:40:32
185	34	5	\N	0	2007-01-02 15:40:32	2007-01-02 15:40:32
186	13	8	1.000	0	2007-01-04 19:06:35	2007-01-04 19:06:35
187	13	9	1.000	0	2007-01-04 19:06:35	2007-01-04 19:06:35
188	13	4	0.500	0	2007-01-04 19:06:35	2007-01-04 19:06:35
189	13	5	0.750	0	2007-01-04 19:06:35	2007-01-04 19:06:35
190	35	8	\N	0	2007-01-10 15:47:37	2007-01-10 15:47:37
191	35	9	\N	0	2007-01-10 15:47:37	2007-01-10 15:47:37
192	35	4	\N	0	2007-01-10 15:47:37	2007-01-10 15:47:37
193	35	5	\N	0	2007-01-10 15:47:37	2007-01-10 15:47:37
198	37	8	\N	0	2007-01-10 15:48:42	2007-01-10 15:48:42
199	37	9	\N	0	2007-01-10 15:48:42	2007-01-10 15:48:42
200	37	4	\N	0	2007-01-10 15:48:42	2007-01-10 15:48:42
201	37	5	\N	0	2007-01-10 15:48:42	2007-01-10 15:48:42
202	38	8	\N	0	2007-01-17 14:35:51	2007-01-17 14:35:51
203	38	9	\N	0	2007-01-17 14:35:51	2007-01-17 14:35:51
204	38	4	\N	0	2007-01-17 14:35:51	2007-01-17 14:35:51
205	38	5	\N	0	2007-01-17 14:35:51	2007-01-17 14:35:51
206	39	8	\N	0	2007-04-19 17:26:22	2007-04-19 17:26:22
207	39	9	\N	0	2007-04-19 17:26:22	2007-04-19 17:26:22
208	39	4	\N	0	2007-04-19 17:26:22	2007-04-19 17:26:22
209	39	5	\N	0	2007-04-19 17:26:22	2007-04-19 17:26:22
214	41	8	\N	0	2007-04-24 17:34:10	2007-04-24 17:34:10
215	41	9	\N	0	2007-04-24 17:34:10	2007-04-24 17:34:10
216	41	4	\N	0	2007-04-24 17:34:10	2007-04-24 17:34:10
217	41	5	\N	0	2007-04-24 17:34:10	2007-04-24 17:34:10
218	40	8	\N	0	2007-04-24 17:34:23	2007-04-24 17:34:23
219	40	9	\N	0	2007-04-24 17:34:23	2007-04-24 17:34:23
220	40	4	\N	0	2007-04-24 17:34:23	2007-04-24 17:34:23
221	40	5	\N	0	2007-04-24 17:34:23	2007-04-24 17:34:23
222	42	8	\N	0	2007-04-24 17:36:24	2007-04-24 17:36:24
223	42	9	\N	0	2007-04-24 17:36:24	2007-04-24 17:36:24
224	42	4	\N	0	2007-04-24 17:36:24	2007-04-24 17:36:24
225	42	5	\N	0	2007-04-24 17:36:24	2007-04-24 17:36:24
226	31	8	\N	0	2007-08-08 16:38:06	2007-08-08 16:38:06
227	31	9	\N	0	2007-08-08 16:38:06	2007-08-08 16:38:06
228	31	4	\N	0	2007-08-08 16:38:06	2007-08-08 16:38:06
229	31	5	\N	0	2007-08-08 16:38:06	2007-08-08 16:38:06
234	43	8	\N	0	2007-08-22 14:04:03	2007-08-22 14:04:03
235	43	9	\N	0	2007-08-22 14:04:03	2007-08-22 14:04:03
236	43	4	\N	0	2007-08-22 14:04:03	2007-08-22 14:04:03
237	43	5	\N	0	2007-08-22 14:04:03	2007-08-22 14:04:03
238	32	8	\N	0	2007-08-22 14:04:30	2007-08-22 14:04:30
239	32	9	\N	0	2007-08-22 14:04:30	2007-08-22 14:04:30
240	32	4	\N	0	2007-08-22 14:04:30	2007-08-22 14:04:30
241	32	5	\N	0	2007-08-22 14:04:30	2007-08-22 14:04:30
250	27	8	\N	0	2007-08-22 14:08:50	2007-08-22 14:08:50
251	27	9	\N	0	2007-08-22 14:08:50	2007-08-22 14:08:50
252	27	4	\N	0	2007-08-22 14:08:50	2007-08-22 14:08:50
253	27	5	\N	0	2007-08-22 14:08:50	2007-08-22 14:08:50
254	36	8	\N	0	2007-10-23 19:00:27	2007-10-23 19:00:27
255	36	9	\N	0	2007-10-23 19:00:27	2007-10-23 19:00:27
256	36	4	\N	0	2007-10-23 19:00:27	2007-10-23 19:00:27
257	36	5	\N	0	2007-10-23 19:00:27	2007-10-23 19:00:27
258	44	8	\N	0	2007-10-23 19:17:36	2007-10-23 19:17:36
259	44	9	\N	0	2007-10-23 19:17:36	2007-10-23 19:17:36
260	44	4	\N	0	2007-10-23 19:17:36	2007-10-23 19:17:36
261	44	5	\N	0	2007-10-23 19:17:36	2007-10-23 19:17:36
262	45	8	1.000	0	2007-12-11 17:01:35	2007-12-11 17:01:35
263	45	9	1.000	0	2007-12-11 17:01:35	2007-12-11 17:01:35
264	45	4	1.000	0	2007-12-11 17:01:35	2007-12-11 17:01:35
265	45	5	1.000	0	2007-12-11 17:01:35	2007-12-11 17:01:35
266	46	8	\N	0	2007-12-11 17:41:55	2007-12-11 17:41:55
267	46	9	\N	0	2007-12-11 17:41:55	2007-12-11 17:41:55
268	46	4	\N	0	2007-12-11 17:41:55	2007-12-11 17:41:55
269	46	5	\N	0	2007-12-11 17:41:55	2007-12-11 17:41:55
270	47	8	\N	0	2008-03-11 18:26:39	2008-03-11 18:26:39
271	47	9	\N	0	2008-03-11 18:26:39	2008-03-11 18:26:39
272	47	4	\N	0	2008-03-11 18:26:39	2008-03-11 18:26:39
273	47	5	\N	0	2008-03-11 18:26:39	2008-03-11 18:26:39
274	28	8	\N	0	2008-03-18 12:26:26	2008-03-18 12:26:26
275	28	9	\N	0	2008-03-18 12:26:26	2008-03-18 12:26:26
276	28	4	\N	0	2008-03-18 12:26:26	2008-03-18 12:26:26
277	28	5	\N	0	2008-03-18 12:26:26	2008-03-18 12:26:26
278	49	9	\N	0	2008-10-10 22:42:44.98167	2008-10-10 22:42:44.98167
279	49	4	\N	0	2008-10-10 22:42:45.02926	2008-10-10 22:42:45.02926
280	49	8	\N	0	2008-10-10 22:42:45.03671	2008-10-10 22:42:45.03671
281	49	5	\N	0	2008-10-10 22:42:45.044042	2008-10-10 22:42:45.044042
282	50	9	\N	0	2008-10-10 22:42:45.090185	2008-10-10 22:42:45.090185
283	50	4	\N	0	2008-10-10 22:42:45.097658	2008-10-10 22:42:45.097658
284	50	8	\N	0	2008-10-10 22:42:45.10505	2008-10-10 22:42:45.10505
285	50	5	\N	0	2008-10-10 22:42:45.112377	2008-10-10 22:42:45.112377
\.


ALTER TABLE discount_schedules_gizmo_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

