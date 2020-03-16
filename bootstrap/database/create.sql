--
-- PostgreSQL database dump
--

-- Dumped from database version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    code character varying(191) NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    completed_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.activations OWNER TO postgres;

--
-- Name: activations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activations_id_seq OWNER TO postgres;

--
-- Name: activations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activations_id_seq OWNED BY public.activations.id;


--
-- Name: annotations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.annotations (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    multi integer DEFAULT 1 NOT NULL,
    name character varying(255) NOT NULL,
    type integer,
    "order" integer
);


ALTER TABLE public.annotations OWNER TO postgres;

--
-- Name: commands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commands (
    id integer NOT NULL,
    user_id integer NOT NULL,
    job_id integer NOT NULL,
    process_id integer NOT NULL,
    command_type integer NOT NULL,
    command text NOT NULL,
    output text NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    completed_at timestamp(0) without time zone
);


ALTER TABLE public.commands OWNER TO postgres;

--
-- Name: commands_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commands_id_seq OWNER TO postgres;

--
-- Name: commands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commands_id_seq OWNED BY public.commands.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    job_id integer NOT NULL,
    url character varying(255),
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.documents OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documents_id_seq OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: documents_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documents_meta_id_seq OWNER TO postgres;

--
-- Name: documents_meta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents_meta (
    id integer DEFAULT nextval('public.documents_meta_id_seq'::regclass) NOT NULL,
    document_id integer NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    value_number integer,
    value_date timestamp without time zone
);


ALTER TABLE public.documents_meta OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    type_id integer DEFAULT 1 NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(255),
    started timestamp(0) without time zone,
    ended timestamp(0) without time zone,
    locate text,
    status integer,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: training; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.training (
    id integer NOT NULL,
    job_id integer NOT NULL,
    url character varying(255),
    file character varying(255) NOT NULL,
    labels integer DEFAULT 0 NOT NULL,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.training OWNER TO postgres;

--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq OWNER TO postgres;

--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.links_id_seq OWNED BY public.training.id;


--
-- Name: persistences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persistences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    code character varying(191) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.persistences OWNER TO postgres;

--
-- Name: persistences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persistences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persistences_id_seq OWNER TO postgres;

--
-- Name: persistences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persistences_id_seq OWNED BY public.persistences.id;


--
-- Name: role_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_users (
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.role_users OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    slug character varying(191) NOT NULL,
    name character varying(191) NOT NULL,
    permissions text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: targets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.targets_id_seq OWNER TO postgres;

--
-- Name: targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.targets_id_seq OWNED BY public.annotations.id;


--
-- Name: throttle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.throttle (
    id integer NOT NULL,
    user_id integer,
    type character varying(191) NOT NULL,
    ip character varying(191),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.throttle OWNER TO postgres;

--
-- Name: throttle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.throttle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.throttle_id_seq OWNER TO postgres;

--
-- Name: throttle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.throttle_id_seq OWNED BY public.throttle.id;


--
-- Name: tmp_242; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_242 (
    item_id integer NOT NULL,
    document_id integer NOT NULL,
    description text,
    id text,
    owner text,
    address text,
    permit text,
    outcome text,
    lat numeric(10,7) DEFAULT '0'::numeric NOT NULL,
    lng numeric(10,7) DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.tmp_242 OWNER TO postgres;

--
-- Name: tmp_242_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tmp_242_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmp_242_item_id_seq OWNER TO postgres;

--
-- Name: tmp_242_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tmp_242_item_id_seq OWNED BY public.tmp_242.item_id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(191) NOT NULL,
    email character varying(191) NOT NULL,
    password character varying(191) NOT NULL,
    last_name character varying(191),
    first_name character varying(191),
    permissions text NOT NULL,
    last_login timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: view_jobs_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_jobs_list AS
 SELECT j.id,
    j.owner_id,
    j.type_id,
    j.title,
    j.description,
    j.started,
    j.ended,
    j.locate,
    j.status,
    j.created_at,
    j.updated_at,
    l2.url AS public_url,
    l2.id AS link_id,
    ( SELECT COALESCE(sum(l_1.labels), (0)::bigint) AS sum
           FROM public.training l_1
          WHERE (l_1.job_id = j.id)) AS labels,
    ( SELECT count(l3.id) AS count
           FROM public.training l3
          WHERE (l3.job_id = j.id)) AS link_count
   FROM ((public.jobs j
     LEFT JOIN ( SELECT DISTINCT max(training.id) AS id,
            training.job_id
           FROM public.training
          GROUP BY training.job_id) l ON ((j.id = l.job_id)))
     LEFT JOIN public.training l2 ON ((l.id = l2.id)));


ALTER TABLE public.view_jobs_list OWNER TO postgres;

--
-- Name: activations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activations ALTER COLUMN id SET DEFAULT nextval('public.activations_id_seq'::regclass);


--
-- Name: annotations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.annotations ALTER COLUMN id SET DEFAULT nextval('public.targets_id_seq'::regclass);


--
-- Name: commands id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commands ALTER COLUMN id SET DEFAULT nextval('public.commands_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: persistences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persistences ALTER COLUMN id SET DEFAULT nextval('public.persistences_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: throttle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.throttle ALTER COLUMN id SET DEFAULT nextval('public.throttle_id_seq'::regclass);


--
-- Name: tmp_242 item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tmp_242 ALTER COLUMN item_id SET DEFAULT nextval('public.tmp_242_item_id_seq'::regclass);


--
-- Name: training id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.training ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: activations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activations (id, user_id, code, completed, completed_at, created_at, updated_at) FROM stdin;
6	106	PSzFH3K7J4oMpvp1pQHZcPFz2w71eUxM	t	2019-05-01 11:24:05	2019-05-01 11:24:05	2019-05-01 11:24:05
\.


--
-- Data for Name: annotations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.annotations (id, title, multi, name, type, "order") FROM stdin;
8	Description	1	description	1	8
1	Document Source	0	document_source	1	1
2	Document City	0	document_city	1	2
3	Document Date	0	document_date	3	3
4	ID	0	id	1	4
5	Owner	0	owner	1	5
6	Address	0	address	1	6
7	Permit	0	permit	1	7
9	Outcome	0	outcome	1	9
\.


--
-- Data for Name: commands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commands (id, user_id, job_id, process_id, command_type, command, output, created_at, completed_at) FROM stdin;
37	106	242	30050	0	nohup /var/www/sites/nima/nerd/console/bin/crawl -j 242 > /dev/null 2>&1 & echo $!	30050	2019-06-05 11:32:06	2019-06-05 12:45:41
38	106	242	32524	0	nohup /var/www/sites/nima/nerd/console/bin/crawl -j 242 > /dev/null 2>&1 & echo $!	32524	2019-06-05 13:58:48	2019-06-05 13:59:03
39	106	242	618	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	618	2019-06-05 14:28:46	2019-06-05 14:28:48
40	106	242	657	2	nohup /var/www/sites/nima/nerd/console/bin/tag -j 242 > /dev/null 2>&1 & echo $!	657	2019-06-05 14:29:28	2019-06-05 14:29:29
41	106	242	6105	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	6105	2019-06-05 15:27:04	2019-06-05 15:27:03
42	106	242	5115	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	5115	2019-06-05 18:17:31	2019-06-05 18:17:36
43	106	242	5164	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	5164	2019-06-05 18:17:43	2019-06-05 18:17:45
44	106	242	5782	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	5782	2019-06-05 18:26:15	2019-06-05 18:26:17
45	106	242	5873	0	nohup /var/www/sites/nima/nerd/console/bin/crawl -j 242 > /dev/null 2>&1 & echo $!	5873	2019-06-05 18:34:56	2019-06-05 18:35:11
46	106	242	5885	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	5885	2019-06-05 18:35:31	2019-06-05 18:35:33
47	106	242	6007	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	6007	2019-06-05 18:39:48	2019-06-05 18:39:50
48	106	242	6038	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	6038	2019-06-05 18:39:56	2019-06-05 18:39:58
49	106	242	6067	2	nohup /var/www/sites/nima/nerd/console/bin/tag -j 242 > /dev/null 2>&1 & echo $!	6067	2019-06-05 18:40:04	2019-06-05 18:40:20
50	106	242	6204	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	6204	2019-06-05 18:40:20	2019-06-05 18:40:20
51	106	242	25596	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	25596	2019-06-06 18:35:22	2019-06-06 18:35:23
52	106	242	25629	2	nohup /var/www/sites/nima/nerd/console/bin/tag -j 242 > /dev/null 2>&1 & echo $!	25629	2019-06-06 18:35:42	2019-06-06 18:35:46
53	106	242	25666	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	25666	2019-06-06 18:36:00	2019-06-06 18:36:00
54	106	242	25699	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	25699	2019-06-06 18:37:02	2019-06-06 18:37:02
55	106	242	26424	2	nohup /var/www/sites/nima/nerd/console/bin/tag -j 242 > /dev/null 2>&1 & echo $!	26424	2019-06-06 19:07:38	2019-06-06 19:07:47
56	106	242	26571	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	26571	2019-06-06 19:08:03	2019-06-06 19:08:03
57	106	242	32182	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	32182	2019-06-07 13:25:59	2019-06-07 13:26:04
58	106	242	32283	2	nohup /var/www/sites/nima/nerd/console/bin/tag -j 242 > /dev/null 2>&1 & echo $!	32283	2019-06-07 13:26:26	2019-06-07 13:26:38
59	106	242	32434	2	nohup /var/www/sites/nima/nerd/console/bin/tag -j 242 > /dev/null 2>&1 & echo $!	32434	2019-06-07 13:27:42	2019-06-07 13:27:52
60	106	242	32587	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	32587	2019-06-07 13:28:06	2019-06-07 13:28:05
61	106	242	4094	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	4094	2019-06-07 14:40:35	2019-06-07 14:40:35
62	106	242	21133	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	21133	2019-06-22 11:09:26	2019-06-22 11:09:27
63	106	242	21156	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	21156	2019-06-22 11:10:15	2019-06-22 11:10:20
64	106	242	21199	2	nohup /var/www/sites/nima/nerd/console/bin/tag -j 242 > /dev/null 2>&1 & echo $!	21199	2019-06-22 11:11:47	2019-06-22 11:12:06
65	106	242	21352	3	nohup /var/www/sites/nima/nerd/console/bin/result -j 242 > /dev/null 2>&1 & echo $!	21352	2019-06-22 11:12:15	2019-06-22 11:12:16
66	106	242	21802	1	nohup /var/www/sites/nima/nerd/console/bin/model -j 242 > /dev/null 2>&1 & echo $!	21802	2019-06-22 11:33:37	2019-06-22 11:33:40
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, job_id, url, created_at) FROM stdin;
33658	242	http://commissions.sfplanning.org/cpcpackets/20180111_cal_min.pdf	2019-07-09 14:30:44
33659	242	http://commissions.sfplanning.org/cpcpackets/20180118_cal_min.pdf	2019-07-09 14:30:44
33660	242	http://commissions.sfplanning.org/cpcpackets/20180125_cal_min.pdf	2019-07-09 14:30:44
33661	242	http://commissions.sfplanning.org/cpcpackets/20180201_cal_min.pdf	2019-07-09 14:30:44
33662	242	http://commissions.sfplanning.org/cpcpackets/20180208_cal_min.pdf	2019-07-09 14:30:44
33663	242	http://commissions.sfplanning.org/cpcpackets/20180222_cal_min.pdf	2019-07-09 14:30:44
33664	242	http://commissions.sfplanning.org/cpcpackets/20180301_cal_min.pdf	2019-07-09 14:30:44
33665	242	http://commissions.sfplanning.org/cpcpackets/20180315_cal_min.pdf	2019-07-09 14:30:44
33666	242	http://commissions.sfplanning.org/cpcpackets/20180322_cal_min.pdf	2019-07-09 14:30:45
33667	242	http://commissions.sfplanning.org/cpcpackets/20180329_cal_min.pdf	2019-07-09 14:30:45
33668	242	http://commissions.sfplanning.org/cpcpackets/20180412_cal_min.pdf	2019-07-09 14:30:45
33669	242	http://commissions.sfplanning.org/cpcpackets/20180419_cal_min.pdf	2019-07-09 14:30:45
33670	242	http://commissions.sfplanning.org/cpcpackets/20180426_cal_min.pdf	2019-07-09 14:30:45
33671	242	http://commissions.sfplanning.org/cpcpackets/20180503_cal_min.pdf	2019-07-09 14:30:45
33672	242	http://commissions.sfplanning.org/cpcpackets/20180510_cal_min.pdf	2019-07-09 14:30:45
33673	242	http://commissions.sfplanning.org/cpcpackets/20180517_cal_min.pdf	2019-07-09 14:30:45
33674	242	http://commissions.sfplanning.org/cpcpackets/20180524_cal_min.pdf	2019-07-09 14:30:45
33675	242	http://commissions.sfplanning.org/cpcpackets/20180607_cal_min.pdf	2019-07-09 14:30:45
33676	242	http://commissions.sfplanning.org/cpcpackets/20180614_cal_min.pdf	2019-07-09 14:30:45
33677	242	http://commissions.sfplanning.org/cpcpackets/20180621_cal_min.pdf	2019-07-09 14:30:45
33678	242	http://commissions.sfplanning.org/cpcpackets/20180628_cal_min.pdf	2019-07-09 14:30:45
33679	242	http://commissions.sfplanning.org/cpcpackets/20180712_cal_min.pdf	2019-07-09 14:30:45
33680	242	http://commissions.sfplanning.org/cpcpackets/20180726_cal_min.pdf	2019-07-09 14:30:45
33681	242	http://commissions.sfplanning.org/cpcpackets/20180823_cal_min.pdf	2019-07-09 14:30:45
33682	242	http://commissions.sfplanning.org/cpcpackets/20180830_cal_min.pdf	2019-07-09 14:30:45
33683	242	\N	2019-07-09 14:30:45
33684	242	http://commissions.sfplanning.org/cpcpackets/20180913_cal_min.pdf	2019-07-09 14:30:45
33685	242	http://commissions.sfplanning.org/cpcpackets/20180927_cal_min.pdf	2019-07-09 14:30:45
33686	242	http://commissions.sfplanning.org/cpcpackets/20181004_cal_min.pdf	2019-07-09 14:30:45
33687	242	http://commissions.sfplanning.org/cpcpackets/20181011_cal_min.pdf	2019-07-09 14:30:46
33688	242	http://commissions.sfplanning.org/cpcpackets/20181018_cal_min.pdf	2019-07-09 14:30:46
33689	242	http://commissions.sfplanning.org/cpcpackets/20181025_cal_min.pdf	2019-07-09 14:30:46
33690	242	http://commissions.sfplanning.org/cpcpackets/20181108_cal_min.pdf	2019-07-09 14:30:46
33691	242	http://commissions.sfplanning.org/cpcpackets/20181115_cal_min.pdf	2019-07-09 14:30:46
33692	242	http://commissions.sfplanning.org/cpcpackets/20181129_cal_min.pdf	2019-07-09 14:30:46
33693	242	http://commissions.sfplanning.org/cpcpackets/20181206_cal_min.pdf	2019-07-09 14:30:46
33694	242	http://commissions.sfplanning.org/cpcpackets/20181213_cal_min.pdf	2019-07-09 14:30:46
33695	242	http://commissions.sfplanning.org/cpcpackets/20181220_cal_min.pdf	2019-07-09 14:30:46
33696	242	http://commissions.sfplanning.org/cpcpackets/20190110_cal_min.pdf	2019-07-09 14:30:46
33697	242	http://commissions.sfplanning.org/cpcpackets/20190117_cal_min.pdf	2019-07-09 14:30:46
33698	242	http://commissions.sfplanning.org/cpcpackets/20190124_cal_min.pdf	2019-07-09 14:30:46
33699	242	http://commissions.sfplanning.org/cpcpackets/20190131_cal_min.pdf	2019-07-09 14:30:46
33700	242	http://commissions.sfplanning.org/cpcpackets/20190214_cal_min.pdf	2019-07-09 14:30:46
33701	242	http://commissions.sfplanning.org/cpcpackets/20190221_cal_min.pdf	2019-07-09 14:30:46
33702	242	http://commissions.sfplanning.org/cpcpackets/20190228_cal_min.pdf	2019-07-09 14:30:46
33703	242	http://commissions.sfplanning.org/cpcpackets/20190307_cal_min.pdf	2019-07-09 14:30:46
33704	242	http://commissions.sfplanning.org/cpcpackets/20190314_cal_min.pdf	2019-07-09 14:30:46
33705	242	http://commissions.sfplanning.org/cpcpackets/20190411_cal_min.pdf	2019-07-09 14:30:47
33706	242	http://commissions.sfplanning.org/cpcpackets/20190418_cal_min.pdf	2019-07-09 14:30:47
33707	242	http://commissions.sfplanning.org/cpcpackets/20190425_cal_min.pdf	2019-07-09 14:30:47
33708	242	http://commissions.sfplanning.org/cpcpackets/20190502_cal_min.pdf	2019-07-09 14:30:47
33709	242	http://commissions.sfplanning.org/cpcpackets/20190509_cal_min.pdf	2019-07-09 14:30:47
33710	242	http://commissions.sfplanning.org/cpcpackets/20190516_cal_min.pdf	2019-07-09 14:30:47
33711	242	http://commissions.sfplanning.org/cpcpackets/20190523_cal_min.pdf	2019-07-09 14:30:47
33712	242	http://commissions.sfplanning.org/cpcpackets/20190606_cal_min.pdf	2019-07-09 14:30:47
33713	242	http://commissions.sfplanning.org/cpcpackets/20190613_cal_min.pdf	2019-07-09 14:30:47
\.


--
-- Data for Name: documents_meta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents_meta (id, document_id, name, value, value_number, value_date) FROM stdin;
11221	33659	document_date	\N	\N	2018-01-18 12:00:00
11224	33660	document_date	\N	\N	2018-01-18 12:00:00
11227	33661	document_date	\N	\N	2018-01-18 12:00:00
11230	33662	document_date	\N	\N	2018-02-08 12:00:00
11233	33663	document_date	\N	\N	2018-02-08 12:00:00
11236	33664	document_date	\N	\N	2018-02-08 12:00:00
11239	33665	document_date	\N	\N	2018-02-08 12:00:00
11242	33666	document_date	\N	\N	2018-02-08 12:00:00
11245	33667	document_date	\N	\N	2018-03-29 12:00:00
11248	33668	document_date	\N	\N	2018-04-12 12:00:00
11251	33669	document_date	\N	\N	2018-04-19 12:00:00
11254	33670	document_date	\N	\N	2018-04-26 12:00:00
11257	33671	document_date	\N	\N	2018-04-26 12:00:00
11260	33672	document_date	\N	\N	2018-04-26 12:00:00
11263	33673	document_date	\N	\N	2018-05-17 12:00:00
11266	33674	document_date	\N	\N	2018-05-17 12:00:00
11269	33675	document_date	\N	\N	2018-05-17 12:00:00
11272	33676	document_date	\N	\N	2018-06-14 12:00:00
11275	33677	document_date	\N	\N	2018-06-21 12:00:00
11278	33678	document_date	\N	\N	2018-06-21 12:00:00
11281	33679	document_date	\N	\N	2018-06-21 12:00:00
11284	33680	document_date	\N	\N	2018-06-21 12:00:00
11287	33681	document_date	\N	\N	2018-08-23 12:00:00
11290	33682	document_date	\N	\N	2018-08-30 12:00:00
11293	33685	document_date	\N	\N	2018-09-27 12:00:00
11296	33686	document_date	\N	\N	2018-09-27 12:00:00
11299	33687	document_date	\N	\N	2018-10-11 12:00:00
11302	33688	document_date	\N	\N	2018-10-18 12:00:00
11305	33689	document_date	\N	\N	2018-10-25 12:00:00
11219	33659	document_source	Planning Department	\N	\N
11222	33660	document_source	Planning Department	\N	\N
11225	33661	document_source	Planning Department	\N	\N
11228	33662	document_source	Planning Department	\N	\N
11231	33663	document_source	Planning Department	\N	\N
11234	33664	document_source	Planning Department	\N	\N
11237	33665	document_source	Planning Department	\N	\N
11240	33666	document_source	Planning Department	\N	\N
11243	33667	document_source	Planning Department	\N	\N
11246	33668	document_source	Planning Department	\N	\N
11249	33669	document_source	Planning Department	\N	\N
11252	33670	document_source	Planning Department	\N	\N
11255	33671	document_source	Planning Department	\N	\N
11258	33672	document_source	Planning Department	\N	\N
11261	33673	document_source	Planning Department	\N	\N
11264	33674	document_source	Planning Department	\N	\N
11267	33675	document_source	Planning Department	\N	\N
11270	33676	document_source	Planning Department	\N	\N
11273	33677	document_source	Planning Department	\N	\N
11276	33678	document_source	Planning Department	\N	\N
11279	33679	document_source	Planning Department	\N	\N
11282	33680	document_source	Planning Department	\N	\N
11285	33681	document_source	Planning Department	\N	\N
11288	33682	document_source	Planning Department	\N	\N
11291	33685	document_source	Planning Department	\N	\N
11294	33686	document_source	Planning Department	\N	\N
11297	33687	document_source	Planning Department	\N	\N
11300	33688	document_source	Planning Department	\N	\N
11303	33689	document_source	Planning Department	\N	\N
11220	33659	document_city	San Francisco	\N	\N
11223	33660	document_city	San Francisco	\N	\N
11226	33661	document_city	San Francisco	\N	\N
11229	33662	document_city	San Francisco	\N	\N
11232	33663	document_city	San Francisco	\N	\N
11235	33664	document_city	San Francisco	\N	\N
11238	33665	document_city	San Francisco	\N	\N
11241	33666	document_city	San Francisco	\N	\N
11244	33667	document_city	San Francisco	\N	\N
11247	33668	document_city	San Francisco	\N	\N
11250	33669	document_city	San Francisco	\N	\N
11253	33670	document_city	San Francisco	\N	\N
11256	33671	document_city	San Francisco	\N	\N
11259	33672	document_city	San Francisco	\N	\N
11262	33673	document_city	San Francisco	\N	\N
11265	33674	document_city	San Francisco	\N	\N
11268	33675	document_city	San Francisco	\N	\N
11271	33676	document_city	San Francisco	\N	\N
11274	33677	document_city	San Francisco	\N	\N
11277	33678	document_city	San Francisco	\N	\N
11280	33679	document_city	San Francisco	\N	\N
11283	33680	document_city	San Francisco	\N	\N
11286	33681	document_city	San Francisco	\N	\N
11289	33682	document_city	San Francisco	\N	\N
11292	33685	document_city	San Francisco	\N	\N
11295	33686	document_city	San Francisco	\N	\N
11298	33687	document_city	San Francisco	\N	\N
11301	33688	document_city	San Francisco	\N	\N
11304	33689	document_city	San Francisco	\N	\N
11376	33713	document_city	San Francisco	\N	\N
11306	33690	document_source	Planning Department	\N	\N
11309	33691	document_source	Planning Department	\N	\N
11312	33692	document_source	Planning Department	\N	\N
11315	33693	document_source	Planning Department	\N	\N
11318	33694	document_source	Planning Department	\N	\N
11321	33695	document_source	Planning Department	\N	\N
11324	33696	document_source	Planning Department	\N	\N
11327	33697	document_source	Planning Department	\N	\N
11330	33698	document_source	Planning Department	\N	\N
11333	33699	document_source	Planning Department	\N	\N
11336	33700	document_source	Planning Department	\N	\N
11339	33701	document_source	Planning Department	\N	\N
11342	33702	document_source	Planning Department	\N	\N
11345	33703	document_source	Planning Department	\N	\N
11348	33704	document_source	Planning Department	\N	\N
11351	33705	document_source	Planning Department	\N	\N
11354	33706	document_source	Planning Department	\N	\N
11357	33707	document_source	Planning Department	\N	\N
11360	33708	document_source	Planning Department	\N	\N
11363	33709	document_source	Planning Department	\N	\N
11366	33710	document_source	Planning Department	\N	\N
11369	33711	document_source	Planning Department	\N	\N
11372	33712	document_source	Planning Department	\N	\N
11375	33713	document_source	Planning Department	\N	\N
11307	33690	document_city	San Francisco	\N	\N
11310	33691	document_city	San Francisco	\N	\N
11313	33692	document_city	San Francisco	\N	\N
11316	33693	document_city	San Francisco	\N	\N
11319	33694	document_city	San Francisco	\N	\N
11322	33695	document_city	San Francisco	\N	\N
11325	33696	document_city	San Francisco	\N	\N
11328	33697	document_city	San Francisco	\N	\N
11331	33698	document_city	San Francisco	\N	\N
11334	33699	document_city	San Francisco	\N	\N
11337	33700	document_city	San Francisco	\N	\N
11308	33690	document_date	\N	\N	2018-11-08 12:00:00
11311	33691	document_date	\N	\N	2018-11-15 12:00:00
11314	33692	document_date	\N	\N	2018-11-29 12:00:00
11317	33693	document_date	\N	\N	2018-12-06 12:00:00
11320	33694	document_date	\N	\N	2018-12-06 12:00:00
11323	33695	document_date	\N	\N	2018-12-06 12:00:00
11326	33696	document_date	\N	\N	2018-12-06 12:00:00
11329	33697	document_date	\N	\N	2018-12-06 12:00:00
11332	33698	document_date	\N	\N	2018-12-06 12:00:00
11335	33699	document_date	\N	\N	2019-01-31 12:00:00
11338	33700	document_date	\N	\N	2019-02-14 12:00:00
11341	33701	document_date	\N	\N	2019-02-14 12:00:00
11344	33702	document_date	\N	\N	2019-02-28 12:00:00
11347	33703	document_date	\N	\N	2019-02-28 12:00:00
11350	33704	document_date	\N	\N	2019-03-14 12:00:00
11353	33705	document_date	\N	\N	2019-04-11 12:00:00
11356	33706	document_date	\N	\N	2019-04-18 12:00:00
11359	33707	document_date	\N	\N	2019-04-25 12:00:00
11362	33708	document_date	\N	\N	2019-05-02 12:00:00
11365	33709	document_date	\N	\N	2019-05-09 12:00:00
11368	33710	document_date	\N	\N	2019-05-16 12:00:00
11371	33711	document_date	\N	\N	2019-05-23 12:00:00
11374	33712	document_date	\N	\N	2019-05-23 12:00:00
11377	33713	document_date	\N	\N	2019-06-13 12:00:00
11340	33701	document_city	San Francisco	\N	\N
11343	33702	document_city	San Francisco	\N	\N
11346	33703	document_city	San Francisco	\N	\N
11349	33704	document_city	San Francisco	\N	\N
11352	33705	document_city	San Francisco	\N	\N
11355	33706	document_city	San Francisco	\N	\N
11358	33707	document_city	San Francisco	\N	\N
11361	33708	document_city	San Francisco	\N	\N
11364	33709	document_city	San Francisco	\N	\N
11367	33710	document_city	San Francisco	\N	\N
11370	33711	document_city	San Francisco	\N	\N
11373	33712	document_city	San Francisco	\N	\N
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, owner_id, type_id, title, description, started, ended, locate, status, created_at, updated_at) FROM stdin;
242	106	1	CA, San Fransciso		\N	\N	{{i.address}} {{d.document_city}}	3	2019-05-31 13:51:36	2019-07-05 14:39:35
244	106	1	CA, Los Angeles		\N	\N	\N	\N	2019-07-11 14:26:46	2019-07-11 14:26:46
\.


--
-- Data for Name: persistences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persistences (id, user_id, code, created_at, updated_at) FROM stdin;
118	106	SbRH2GwyC59iB7FmVRqOujhfK0FfRRM4	2019-05-01 11:24:05	2019-05-01 11:24:05
119	106	r1nJYujfIsbRP7WRRxwiI8JPEeRdf0yk	2019-05-02 12:28:25	2019-05-02 12:28:25
121	106	ORLreUBaX3ibFtatkgYNhLdrVgiZTo0I	2019-05-27 12:03:01	2019-05-27 12:03:01
122	106	jidyoNPsCLnP5I2Lpm8sK2I6uys2jtkn	2019-05-31 13:51:12	2019-05-31 13:51:12
123	106	pzWrYY25RgmUxb32J62IZ7OqgzDC6r7O	2019-06-01 10:02:40	2019-06-01 10:02:40
124	106	SrRDDzkUs5sgVr2YZp1fRkwwASda5UWY	2019-06-01 17:54:57	2019-06-01 17:54:57
125	106	Jqde26IxD3lWmLrGRjM3ZYvgKrudNIzk	2019-06-02 12:57:40	2019-06-02 12:57:40
126	106	AAU5DjFTkWnSHyr1OPmLfaE0IScnNyF0	2019-06-02 16:13:40	2019-06-02 16:13:40
127	106	xwaUOthe4zP4a1x6SNhgoDMiGZ0YET7T	2019-06-02 18:57:25	2019-06-02 18:57:25
128	106	a4E5eQ3aOMkxfCeWoTgRLUx0mzI7dirN	2019-06-03 11:54:09	2019-06-03 11:54:09
129	106	TpWmMvB9jYJLbbH1B88VkgBebUKlbK7g	2019-06-03 16:13:54	2019-06-03 16:13:54
130	106	KRZTCfQrzjiTcp8VJB2ZOhTfm94sT3np	2019-06-03 16:41:32	2019-06-03 16:41:32
131	106	9deQ8cZFUoJDFQbgwU7KTUv0RtNf6WER	2019-06-04 12:27:14	2019-06-04 12:27:14
132	106	xqWsryjkEUReg8pII6XL0cCQVHe0WWMU	2019-06-04 14:49:16	2019-06-04 14:49:16
133	106	puuak7wdePrYV72A5blIlLq7P1lR1j5m	2019-06-04 17:31:05	2019-06-04 17:31:05
134	106	uvKRzVUYVU8lzw81VokOW4PBPrvopktW	2019-06-05 10:01:19	2019-06-05 10:01:19
135	106	svH1cdlJ3VxsbbN0CYGk1kGHVMfNRmiW	2019-06-05 12:48:02	2019-06-05 12:48:02
136	106	SOvhS2wcY4f5IEvM3r6HbovV98QA3YM7	2019-06-05 15:26:51	2019-06-05 15:26:51
137	106	Ts9I94Nqhf26MvnBS1giGmkNm3TRQcNP	2019-06-05 17:57:34	2019-06-05 17:57:34
138	106	qqAZoBasJCBlOTsgcc0L9PMilweltIWz	2019-06-05 18:14:52	2019-06-05 18:14:52
139	106	5Rli3gprJ0ZUalqkRjsozsYIamf1V6Qd	2019-06-06 17:17:26	2019-06-06 17:17:26
140	106	fp45LuecIxNrBhfiDmLmKISoDuqNdXQP	2019-06-07 10:40:55	2019-06-07 10:40:55
141	106	ls3jd7AlhEUEjAYilPrJEdvLBr8LWT9t	2019-06-07 14:13:43	2019-06-07 14:13:43
142	106	PXngLvr6W7EN2PrlZrgcTkbtVxC05XJj	2019-06-07 16:29:27	2019-06-07 16:29:27
143	106	fgNNwSA0RrJfvCEwx57tx2nvQ6Nk1uPE	2019-06-08 10:09:23	2019-06-08 10:09:23
144	106	SvrGbdR02KUUQVmPiGb7DoLcfKH3aFLL	2019-06-08 12:13:35	2019-06-08 12:13:35
145	106	u86czBXiq0SkCo3ck0JSnm2veOepp7UB	2019-06-08 14:12:38	2019-06-08 14:12:38
146	106	w8PL9nhTpFfFwXFIUdOtxtemC1z4qTVs	2019-06-08 17:28:44	2019-06-08 17:28:44
147	106	NZlD9UaZhqN9xedT3hCnGon5rqIwDQxt	2019-06-08 22:30:08	2019-06-08 22:30:08
148	106	j4XTFHJXwmu8rDKezCOy9E68BrUHPJKd	2019-06-09 10:33:34	2019-06-09 10:33:34
149	106	ltwBsdYvNAldTdn0IKvDvT1DtqPDKffR	2019-06-09 15:11:07	2019-06-09 15:11:07
150	106	o4wgFan6h8HG4lM9tJNgKfjmwD6Hm2Zp	2019-06-10 11:09:21	2019-06-10 11:09:21
151	106	isn2oXzYBpoTlP5enQF6t3CHwbciH4PO	2019-06-22 11:08:42	2019-06-22 11:08:42
152	106	47s5Eoqkr3500yezUDZE4yhpmlXKypKT	2019-06-22 15:03:31	2019-06-22 15:03:31
153	106	yLETqjH0AeU6JcSuCN9m6OpaT1eIsXNl	2019-06-22 17:26:00	2019-06-22 17:26:00
154	106	0ZltWJz7RnuCrGIvuglyE4HFrbIq5Rxc	2019-06-22 18:26:15	2019-06-22 18:26:15
155	106	ItPSvA7phmyFdzI8vfXtiJCPDooOqX4z	2019-06-30 13:22:49	2019-06-30 13:22:49
156	106	BI55Dp8lowsvBNcVvGFC55FVWnC9nLf1	2019-06-30 15:14:43	2019-06-30 15:14:43
157	106	bt4ZbYPpTkvMECtUTS0gWhmZvKqwbEc4	2019-06-30 18:35:39	2019-06-30 18:35:39
158	106	s9cQ8BWsXEu9KhuNbCDws3faWfNVXl6L	2019-07-01 14:06:55	2019-07-01 14:06:55
159	106	qbt0b8ierAJjFXWpMHGkV3bx14mtRBXz	2019-07-01 15:50:59	2019-07-01 15:50:59
160	106	9B94mVJau6pa7j3CAnMzLxOhvBCYtGNI	2019-07-02 16:14:58	2019-07-02 16:14:58
161	106	bkcqj4TezJVlu1JT40imbYWwuRCH9wlP	2019-07-02 18:29:31	2019-07-02 18:29:31
162	106	N5dRT8vJULe2IuZfURdDHyyn3BZensWg	2019-07-02 19:16:31	2019-07-02 19:16:31
163	106	LzPZAMCxLv5kWaakb3Q9GFwYooa1nldU	2019-07-03 10:17:29	2019-07-03 10:17:29
164	106	bjoYbydLIst7706AGQqHiyVnrsLwruhZ	2019-07-03 13:54:53	2019-07-03 13:54:53
165	106	KSxfPGpgzFs1lGxHs4sBQhfGUJrHdsDF	2019-07-03 16:18:26	2019-07-03 16:18:26
166	106	sSUo1DQtVsR3qLG1DZ1vPx4Z9al8nnJ0	2019-07-04 17:54:18	2019-07-04 17:54:18
167	106	fj8evR4ZUc9klESD31f3HN5mX1zKc0vu	2019-07-04 20:46:01	2019-07-04 20:46:01
169	106	l76TKUtJczd5x1WHUNq5RrgJoU7auEnx	2019-07-05 11:03:51	2019-07-05 11:03:51
170	106	iyBfpdwXsEq8wMxexnO15TxO2URO09a8	2019-07-05 15:39:52	2019-07-05 15:39:52
171	106	M7E2hWezwqgmIdsM70JT0RCyJhI2Jt8b	2019-07-06 11:19:43	2019-07-06 11:19:43
172	106	rBFsAttwZDjyxA1qzIDtjQTkOBSH7UeF	2019-07-07 12:07:01	2019-07-07 12:07:01
173	106	40OGBoplCXRatKHSmjKRL3kgVrf5rKc6	2019-07-07 17:41:32	2019-07-07 17:41:32
174	106	wMBI0eIORkMbWbesnXQbNpr6h31uomLp	2019-07-07 19:07:10	2019-07-07 19:07:10
175	106	oMxOItC0iztf6pRhLyjArcvVkpYRPD9T	2019-07-08 13:22:30	2019-07-08 13:22:30
176	106	OUtg3gNTPbzc07vLuerwZYeyiCs7IjgA	2019-07-08 18:48:45	2019-07-08 18:48:45
177	106	yslZCT4E9PTffaTnia06ZpbJBxvoEq2y	2019-07-09 14:10:24	2019-07-09 14:10:24
178	106	biOCR60vB8vDh8lMEq81SvBNc4badix3	2019-07-09 17:09:56	2019-07-09 17:09:56
179	106	aISxieEY3szKsF19nbGYgwJSSy3SZR4W	2019-07-11 14:15:38	2019-07-11 14:15:38
180	106	moXbqO2OiygEbaGbAVnqXAMqhXVJ4z1O	2019-07-11 15:38:39	2019-07-11 15:38:39
181	106	9BeF5rSN2Qpx06k40vDT5w7fW7I4bQ6I	2019-07-12 13:53:02	2019-07-12 13:53:02
182	106	kIb3An7C9tw8ENxpFGe1MKFPJ6ynYrmR	2019-07-12 14:43:37	2019-07-12 14:43:37
183	106	gpjbpHq2GtfuspPawIUnAZRA8XPVVXL0	2019-07-17 11:07:28	2019-07-17 11:07:28
\.


--
-- Data for Name: role_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_users (user_id, role_id, created_at, updated_at) FROM stdin;
106	2	2019-05-01 11:24:05	2019-05-01 11:24:05
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, slug, name, permissions, created_at, updated_at) FROM stdin;
1	admin	Admin	{"user.create":true,"user.update":true,"user.delete":true}	2019-03-01 14:35:39	2019-03-01 14:35:39
2	user	User	{"user.update":true}	2019-03-01 14:35:39	2019-03-01 14:35:39
\.


--
-- Data for Name: throttle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.throttle (id, user_id, type, ip, created_at, updated_at) FROM stdin;
79	\N	global	\N	2019-05-01 11:18:33	2019-05-01 11:18:33
80	\N	ip	127.0.0.1	2019-05-01 11:18:33	2019-05-01 11:18:33
81	\N	global	\N	2019-05-01 11:19:52	2019-05-01 11:19:52
82	\N	ip	127.0.0.1	2019-05-01 11:19:52	2019-05-01 11:19:52
83	\N	global	\N	2019-05-01 11:20:40	2019-05-01 11:20:40
84	\N	ip	127.0.0.1	2019-05-01 11:20:40	2019-05-01 11:20:40
85	\N	global	\N	2019-05-01 11:20:48	2019-05-01 11:20:48
86	\N	ip	127.0.0.1	2019-05-01 11:20:48	2019-05-01 11:20:48
87	\N	global	\N	2019-05-02 11:18:31	2019-05-02 11:18:31
88	\N	ip	127.0.0.1	2019-05-02 11:18:31	2019-05-02 11:18:31
89	\N	global	\N	2019-05-02 11:18:39	2019-05-02 11:18:39
90	\N	ip	127.0.0.1	2019-05-02 11:18:39	2019-05-02 11:18:39
91	\N	global	\N	2019-05-02 11:18:40	2019-05-02 11:18:40
92	\N	ip	127.0.0.1	2019-05-02 11:18:40	2019-05-02 11:18:40
93	\N	global	\N	2019-05-02 12:27:55	2019-05-02 12:27:55
94	\N	ip	127.0.0.1	2019-05-02 12:27:55	2019-05-02 12:27:55
95	\N	global	\N	2019-05-27 10:11:27	2019-05-27 10:11:27
96	\N	ip	127.0.0.1	2019-05-27 10:11:27	2019-05-27 10:11:27
97	\N	global	\N	2019-05-27 10:11:33	2019-05-27 10:11:33
98	\N	ip	127.0.0.1	2019-05-27 10:11:33	2019-05-27 10:11:33
99	\N	global	\N	2019-05-27 10:11:49	2019-05-27 10:11:49
100	\N	ip	127.0.0.1	2019-05-27 10:11:50	2019-05-27 10:11:50
101	\N	global	\N	2019-05-27 10:12:09	2019-05-27 10:12:09
102	\N	ip	127.0.0.1	2019-05-27 10:12:09	2019-05-27 10:12:09
103	\N	global	\N	2019-05-27 10:12:25	2019-05-27 10:12:25
104	\N	ip	127.0.0.1	2019-05-27 10:12:25	2019-05-27 10:12:25
105	\N	global	\N	2019-05-27 10:12:31	2019-05-27 10:12:31
106	\N	ip	127.0.0.1	2019-05-27 10:12:31	2019-05-27 10:12:31
107	\N	global	\N	2019-05-27 11:11:56	2019-05-27 11:11:56
108	\N	ip	127.0.0.1	2019-05-27 11:11:56	2019-05-27 11:11:56
109	\N	global	\N	2019-05-27 12:02:56	2019-05-27 12:02:56
110	\N	ip	127.0.0.1	2019-05-27 12:02:56	2019-05-27 12:02:56
111	106	user	\N	2019-05-27 12:02:56	2019-05-27 12:02:56
\.


--
-- Data for Name: tmp_242; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tmp_242 (item_id, document_id, description, id, owner, address, permit, outcome, lat, lng) FROM stdin;
521	33693	demolition of the existing two-story, 30- to 45-foot-tall, 91,088 gross-square-foot (gsf) building, which most recently operated as the San Francisco Honda auto dealership and is a historic resource built in 1927, and construction of up to 984 residential units, in a mixed-use residential building with either two 41-story, 420-foot-tall towers over podiums, or one 55- story, 590-foot-tall tower over a single podium. bicycle parking spaces would be provided 	2015-004568ENV 	(R. SCHUETT: (415) 575-9030) 	10 SOUTH VAN NESS AVENUE 		Under Review	37.7755945	-122.4192604
536	33694	demolition of the existing two-story, 30- to 45-foot-tall, 91,088 gross-square-foot (gsf) building, which most recently operated as the San Francisco Honda auto dealership and is a historic resource built in 1927, and construction of up to 984 residential units, in a mixed-use residential building with either two 41-story, 420-foot-tall towers over podiums, or one 55- story, 590-foot-tall tower over a single podium. bicycle parking spaces would be provided 	2015-004568ENV 	(R. SCHUETT: (415) 575-9030) 	10 SOUTH VAN NESS AVENUE 		Under Review	37.7755945	-122.4192604
551	33695	demolition of the existing two-story, 30- to 45-foot-tall, 91,088 gross-square-foot (gsf) building, which most recently operated as the San Francisco Honda auto dealership and is a historic resource built in 1927, and construction of up to 984 residential units, in a mixed-use residential building with either two 41-story, 420-foot-tall towers over podiums, or one 55- story, 590-foot-tall tower over a single podium. bicycle parking spaces would be provided 	2015-004568ENV 	(R. SCHUETT: (415) 575-9030) 	10 SOUTH VAN NESS AVENUE 		Under Review	37.7755945	-122.4192604
566	33696	demolition of the existing two-story, 30- to 45-foot-tall, 91,088 gross-square-foot (gsf) building, which most recently operated as the San Francisco Honda auto dealership and is a historic resource built in 1927, and construction of up to 984 residential units, in a mixed-use residential building with either two 41-story, 420-foot-tall towers over podiums, or one 55- story, 590-foot-tall tower over a single podium. bicycle parking spaces would be provided 	2015-004568ENV 	(R. SCHUETT: (415) 575-9030) 	10 SOUTH VAN NESS AVENUE 		Under Review	37.7755945	-122.4192604
596	33698	demolition of the existing two-story, 30- to 45-foot-tall, 91,088 gross-square-foot (gsf) building, which most recently operated as the San Francisco Honda auto dealership and is a historic resource built in 1927, and construction of up to 984 residential units, in a mixed-use residential building with either two 41-story, 420-foot-tall towers over podiums, or one 55- story, 590-foot-tall tower over a single podium. bicycle parking spaces would be provided 	2015-004568ENV 	(R. SCHUETT: (415) 575-9030) 	10 SOUTH VAN NESS AVENUE 		Under Review	37.7755945	-122.4192604
628	33700		2018-016562PCA 	(J. BINTLIFF: (415) 	575-9170) INCLUSIONARY HOUSING FEE 		Disapproved 	37.7749295	-122.4194155
635	33700	construction of a rear horizontal addition at the lower basement level, front façade alterations, and relocation of the lower unit to the garden level 	2016-009554DRP 	(D. WINSLOW: (415) 575-9159) 	27 FOUNTAIN STREET 		Approved	37.7503650	-122.4413200
654	33701	construction of a rear horizontal addition at the lower basement level, front façade alterations, and relocation of the lower unit to the garden level 	2016-009554DRP 	(D. WINSLOW: (415) 575-9159) 	27 FOUNTAIN STREET 		Approved	37.7503650	-122.4413200
647	33701		2018-016562PCA 	(J. BINTLIFF: (415) 	575-9170) INCLUSIONARY HOUSING FEE 		Disapproved 	37.7749295	-122.4194155
695	33705		2016-013850PCAMAP 	(V. FLORES: (415) 575-9173) 	915 CAYUGA AVENUE 915 Cayuga Avenue 		Approved	37.7232384	-122.4385182
713	33706		1996.0013CWP 	AMBATI: (415) 575-9183) 	2018 HOUSING INVENTORY 		Approved	37.7749295	-122.4194155
701	33705		2016-013156SRV 	(P. LAVALLEY: (415) 	575-9084) CITYWIDE CULTURAL RESOURCES 		Under Review	37.7749295	-122.4194155
715	33706	vacant retail space 	2018-016549CUA 	(D. WEISSGLASS: (415) 575-9177) 	40 WEST PORTAL AVENUE 		Approved	37.7405192	-122.4665495
771	33710	residential lots renovate the existing nine-unit residential building construct 31 new residential buildings with a total of 273 dwelling units, including accessory resident amenity facilities and parking. 	2017-003559PRJ 	(C. MAY: (415) 575-9087) 	3700 CALIFORNIA STREET 		Under Review	37.7865706	-122.4560109
784	33711	demolition of three existing buildings and associated parking lots and construction of two new buildings with 960 residential dwelling units ground-floor retail and 2,484 square feet of retail/indoor privately-owned public open space private open space outdoor (POPOS). 	2014-000203ENX 	(L. HOAGLAND: (415) 575-6823) 	655 4TH STREET 		Under Review	37.7777723	-122.3953984
762	33709		2019-003581PCA 	(D. SANCHEZ: (415) 	575-9082) UPPER MARKET 		Approved	37.7543235	-122.4435550
801	33712	demolition of three existing buildings and associated parking lots and construction of two new buildings with 960 residential dwelling units ground-floor retail and 2,484 square feet of retail/indoor privately-owned public open space private open space outdoor (POPOS). 	2014-000203ENX 	(L. HOAGLAND: (415) 575-6823) 	655 4TH STREET 		Under Review	37.7777723	-122.3953984
470	33690		2018-013893PCAMAP 	(E. JARDINES: (415) 575-9144) 	1550 EVANS AVENUE 		Approved	37.7429616	-122.3871248
466	33690		2018-009951CUA 	(B. HICKS: (415) 575-9054) 	1541 SLOAT BOULEVARD 		Approved	37.7324100	-122.4906324
467	33690	allow a single retail use greater than 50,000 square feet 	2018-011019CUA 	(L. HOAGLAND: (415) 575-6823) 	400 WINSTON DRIVE 		Approved	37.7288104	-122.4788806
469	33690	new garage within an existing three-dwelling-unit building. 	2017-007215DRM 	(E. TUFFY: (415) 575-9191) 	506 VALLEJO STREET 		Approved	37.7991170	-122.4058820
475	33690	demolish the existing buildings on the site, and construct a six-story, 65-foot tall, approximately 25,756 square-foot (sf) mixed-use building 	2016-008438DRP 	(K. DURANDET: (415) 575-6816) 	1075-1089 FOLSOM STREET 		Approved	37.7769710	-122.4071498
484	33691	change of use from a vacant general retail sales and service use 	2018-011926CUA 	(B. HICKS: (415) 575-9054) 	162 WEST PORTAL AVENUE 		Approved	37.7392933	-122.4679046
485	33691	No interior or exterior alterations and no signage alterations are proposed as a part of this project. 	2017-016089CUA 	(D. WEISSGLASS: (415) 575-9177) 	1200 IRVING STREET 		Approved	37.7641482	-122.4711457
503	33692	ground floor on certain commercial streets; excluding certain Child Care units from the calculation of maximum density permitted on the site; making environmental findings; and making findings of consistency with the General Plan and the eight priority policies 	2017-012001PCA 	(S. NICKOLOPOULOS: (415) 	575-9089) DESIGNATED CHILD CARE 		Approved	37.7749295	-122.4194155
524	33693	demolish an existing two-story single- family dwelling and construct a new four-story structure with three dwelling 	2017-015810CUA 	(L. HOAGLAND: (415) 575-6823) 	830 RHODE ISLAND STREET 		Approved	37.7592172	-122.4023154
526	33693	No interior or exterior alterations and no signage alterations are proposed as a part of this project. 	2018-010482CUA 	(A. KIRBY: (415) 575-9133) 	3509 CALIFORNIA STREET 		Approved	37.7864650	-122.4517097
539	33694	demolish an existing two-story single- family dwelling and construct a new four-story structure with three dwelling 	2017-015810CUA 	(L. HOAGLAND: (415) 575-6823) 	830 RHODE ISLAND STREET 		Approved	37.7592172	-122.4023154
541	33694	No interior or exterior alterations and no signage alterations are proposed as a part of this project. 	2018-010482CUA 	(A. KIRBY: (415) 575-9133) 	3509 CALIFORNIA STREET 		Approved	37.7864650	-122.4517097
554	33695	demolish an existing two-story single- family dwelling and construct a new four-story structure with three dwelling 	2017-015810CUA 	(L. HOAGLAND: (415) 575-6823) 	830 RHODE ISLAND STREET 		Approved	37.7592172	-122.4023154
556	33695	No interior or exterior alterations and no signage alterations are proposed as a part of this project. 	2018-010482CUA 	(A. KIRBY: (415) 575-9133) 	3509 CALIFORNIA STREET 		Approved	37.7864650	-122.4517097
630	33700	“Health Services” use mixed-use building 	2018-007049CUA 	(L. AJELLO: (415) 575-9142) 	3378 SACRAMENTO STREET 		Approved	37.7881484	-122.4483365
569	33696	demolish an existing two-story single- family dwelling and construct a new four-story structure with three dwelling 	2017-015810CUA 	(L. HOAGLAND: (415) 575-6823) 	830 RHODE ISLAND STREET 		Approved	37.7592172	-122.4023154
571	33696	No interior or exterior alterations and no signage alterations are proposed as a part of this project. 	2018-010482CUA 	(A. KIRBY: (415) 575-9133) 	3509 CALIFORNIA STREET 		Approved	37.7864650	-122.4517097
584	33697	demolish an existing two-story single- family dwelling and construct a new four-story structure with three dwelling 	2017-015810CUA 	(L. HOAGLAND: (415) 575-6823) 	830 RHODE ISLAND STREET 		Approved	37.7592172	-122.4023154
586	33697	No interior or exterior alterations and no signage alterations are proposed as a part of this project. 	2018-010482CUA 	(A. KIRBY: (415) 575-9133) 	3509 CALIFORNIA STREET 		Approved	37.7864650	-122.4517097
632	33700	establish a Cannabis Retail Use convert a ground floor commercial space floor area to Cannabis Retail Use mixed-use building. 	2018-014721CUA 	(L. AJELLO: (415) 575-9142) 	1685 HAIGHT STREET 		Approved	37.7694223	-122.4502572
599	33698	demolish an existing two-story single- family dwelling and construct a new four-story structure with three dwelling 	2017-015810CUA 	(L. HOAGLAND: (415) 575-6823) 	830 RHODE ISLAND STREET 		Approved	37.7592172	-122.4023154
601	33698	No interior or exterior alterations and no signage alterations are proposed as a part of this project. 	2018-010482CUA 	(A. KIRBY: (415) 575-9133) 	3509 CALIFORNIA STREET 		Approved	37.7864650	-122.4517097
610	33699		2018-012850CND 	(K. WILBORN: (415) 575-9114) 	3132-3140 SCOTT STREET 		Approved	37.7988810	-122.4405990
611	33699	vacant ground floor commercial space 	2018-009587CUA 	(L. AJELLO: (415) 575-9142) 	3535 CALIFORNIA STREET 		Approved	37.7863027	-122.4521865
615	33699	demolition of a non-contributing one-story garden house and construction of a new, four-story, eight-unit residential building 	2016-010079CUA 	(L. AJELLO: (415) 575-9142) 	3620 BUCHANAN STREET 		Approved	37.8036044	-122.4332097
624	33700	establish a Retail Use greater than 6,000 square feet 	2018-013462CUA 	(L. HOAGLAND: (415) 575-6823) 	3995 ALEMANY BOULEVARD 		Approved	37.7103849	-122.4676282
625	33700	allow a change of use from an existing Limited Restaurant to a Restaurant 	2018-015439CUA 	(D. WEISSGLASS: (415) 575-9177) 	205 HUGO STREET 		Approved	37.7651756	-122.4602591
626	33700		2018-015471CRV 	(D. LANDIS: (415) 575-9118) FY 	2019-2021 PROPOSED DEPARTMENT 		Approved	37.7749295	-122.4194155
643	33701	establish a Retail Use greater than 6,000 square feet 	2018-013462CUA 	(L. HOAGLAND: (415) 575-6823) 	3995 ALEMANY BOULEVARD 		Approved	37.7103849	-122.4676282
644	33701	allow a change of use from an existing Limited Restaurant to a Restaurant 	2018-015439CUA 	(D. WEISSGLASS: (415) 575-9177) 	205 HUGO STREET 		Approved	37.7651756	-122.4602591
645	33701		2018-015471CRV 	(D. LANDIS: (415) 575-9118) FY 	2019-2021 PROPOSED DEPARTMENT 		Approved	37.7749295	-122.4194155
649	33701	“Health Services” use mixed-use building 	2018-007049CUA 	(L. AJELLO: (415) 575-9142) 	3378 SACRAMENTO STREET 		Approved	37.7881484	-122.4483365
651	33701	establish a Cannabis Retail Use convert a ground floor commercial space floor area to Cannabis Retail Use mixed-use building. 	2018-014721CUA 	(L. AJELLO: (415) 575-9142) 	1685 HAIGHT STREET 		Approved	37.7694223	-122.4502572
668	33703	allow for dwelling establish a Community Facility vertical and horizontal addition to an existing two-story building. result in a four-story mixed-use building with six dwelling units ground floor Community Facility, and six off-street parking spaces 	2018-003324CUA 	(E. JARDINES: (415) 575-9144) 	2779 FOLSOM STREET 		Approved	37.7529650	-122.4137130
680	33704	existing food mart space located within an existing automobile gas station and formula retail food mart convenience store 	2498 LOMBARD STREET 	(P. IKEZOE: (415) 	175 Golden Gate Avenue 		Approved	37.7816135	-122.4130570
682	33704	Residential Density of three units allow construction of a four-story two-family dwelling currently occupied by a three-story, single-family residential building 	2018-007204CUA 	(L. AJELLO: (415) 575-9142) 	754 35TH AVENUE 		Approved	37.7747845	-122.4947000
684	33704	legalize the establishment of group housing within the existing three-story, residential building legalizing the establishment of group housing within the existing three-story, residential building single-family and two-family residential use) that will allow for a total of 7 bedrooms for group housing within the building. 	2018-007460CUA 	(S. YOUNG: (415) 558-6346) 	1226 10TH AVENUE 		Approved	37.7653212	-122.4672681
686	33704	3 -story horizontal addition to an existing 3-story residential building 	2017-014420DRP 	(D. WINSLOW: (415) 575-9159) 	2552 BAKER STREET 		Approved	37.7947128	-122.4449324
693	33705	to permit change of use from Limited Restaurant to Restaurant at an existing vacant storefront ground floor space. No interior or exterior work proposed under this request. 	2018-017057CUA 	(A. LINDSAY: (415) 575-9178) 	1226 9TH AVENUE 		Approved	37.7653776	-122.4661183
696	33705	the development project with various public benefits including significantly more below market rate units than otherwise required; making findings under the California Environmental Quality Act 	2016-013850DVA 	(V. FLORES: (415) 575-9173) 	915 CAYUGA AVENUE 		Approved	37.7232384	-122.4385182
704	33705	retail use to office use at the ground floor two buildings and the addition of a 962 square-foot retail structure in the plaza. 	2018-004711DNX 	(S. ADINA: (415) 575-8722) 	555 - 575 MARKET STREET 		Approved	37.7899845	-122.3998704
705	33705	renovate the existing plaza between the buildings and a partial change of use from retail to office at the ground floor 	2018-004711CUA 	(S. ADINA: (415) 575-8722) 	555 - 575 MARKET STREET 		Approved	37.7899845	-122.3998704
706	33705	establish a 4,000 square foot General Entertainment Use (dba Escape SF) at the ground floor of an existing vacant space most recently used for private parking 	2018-012330CUA 	(M. CHANDLER: (415) 575-9048) 	447 BROADWAY 		Approved	37.7979148	-122.4048266
712	33706	increase the projected housing balance to 22%. 	2019-000475CND 	(K. WILBORN: (415) 575-9114) 	863 HAIGHT STREET 		Approved	37.7710760	-122.4363130
724	33707	allow an increase in student enrollment 414 students to 450 students over a two-year period maximum student enrollment of 400 students 	2018-017254CUA 	(D. GANETSOS: (415) 575-9172) 	2750 JACKSON STREET 		Approved	37.7920178	-122.4400886
728	33707	rehabilitation of the existing 13-story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces. 	2016-007303DNX 	(S. ADINA: (415) 575-8722) 	5 THIRD STREET 		Approved	37.7874792	-122.4032481
729	33707	establish a hotel rehabilitation of the existing 13-story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces. 	2016-007303CUA 	(S. ADINA: (415) 575-8722) 	5 THIRD STREET 		Approved	37.7874792	-122.4032481
734	33707	change of use of an existing personal service establishment accessory foot/chair massage use Massage Establishment Use accessory personal service use second floor of the two-story commercial building. 	2017-012697CUA 	(S. YOUNG: (415) 558-6346) 	3944A GEARY BOULEVARD 		Approved	37.7814963	-122.4618726
744	33708	allow a change of use from retail professional service to a massage establishment ground floor of an existing mixed-use three-story building with ground floor commercial space, 	2019-001017CUA 	(B. HICKS (415) 575-9054) 	1700 IRVING STREET 		Approved	37.7637883	-122.4762741
745	33708	allow an amusement game arcade use with more than eleven machines, to establish a nonresidential use size greater than 3,000 square feet, and an individual nonresidential use with more than 75 contiguous feet of linear frontage for the first 25 feet of depth operate as a restaurant / amusement game arcade and will occupy the entire ground floor existing 5-story mixed-use building 	2019-003637CUA 	(B. HICKS (415) 575-9054) 	2200 MARKET STREET 		Approved	37.7658011	-122.4315507
748	33708	install a permanent AT&T Mobility Macro Wireless Telecommunications Facility 8 new antennas on rooftop screened behind FRP boxes, and ancillary equipment proposed at roof level 	2018-012709CUA 	(A. LINDSAY: (415) 575-9178) 	990 PACIFIC AVENUE 		Approved	37.7965324	-122.4114419
749	33708	install a new AT&T Mobility macro wireless telecommunications facility panel antennas screened behind one (1) FRP box and six (6) faux vents; back-up equipment proposed in basement area. 	2018-013395CUA 	(A. LINDSAY: (415) 575-9178) 	10 29TH STREET 		Approved	37.7441410	-122.4209920
750	33708	demolish the existing 2-story parking garage and construct a new 37-unit residential building ground floor level that has full site coverage, providing accessory parking for 28 vehicles and 57 Class 1 bicycle parking spaces. two buildings that are separated by an inner court: one fronting 24 dwelling units ground floor retail; and the other along Larkin Street that contains 13 dwelling units. 	2017-000280CUA 	(A. PERRY: (415) 575-9017) 	915 NORTH POINT STREET 		Approved	37.8052820	-122.4224838
769	33710	establish a Restaurant commercial tenant space operate as a bona fide eating establishment with on-sale beer and wine, pending approval of ABC license 	2018-016996CUA 	(M. CHANDLER: (415) 575-9048) 	517 CLEMENT STREET 		Approved	37.7826936	-122.4647805
786	33711	Cannabis Retail use (Suite 110) within a four-story mixed-use building. 	2019-000186CUA 	(M. CHRISTENSEN: (415) 575-8742) 	828 INNES AVENUE 		Approved	37.7315730	-122.3744662
787	33711	allow the establishment of a 6,180 square foot Industrial Agriculture existing two-story warehouse building to allow the cultivation of cannabis, 	2019-000697CUA 	(M. CHRISTENSEN: (415) 575-8742) 	1370 WALLACE AVENUE 		Approved	37.7253660	-122.3865190
803	33712	Cannabis Retail use (Suite 110) within a four-story mixed-use building. 	2019-000186CUA 	(M. CHRISTENSEN: (415) 575-8742) 	828 INNES AVENUE 		Approved	37.7315730	-122.3744662
804	33712	allow the establishment of a 6,180 square foot Industrial Agriculture existing two-story warehouse building to allow the cultivation of cannabis, 	2019-000697CUA 	(M. CHRISTENSEN: (415) 575-8742) 	1370 WALLACE AVENUE 		Approved	37.7253660	-122.3865190
814	33713	cannabis retail use entire ground floor of an existing two- story mixed-use building 	2019-004216CUA 	(B. HICKS: (415) 575-9054) 	3989 17TH STREET 		Approved	37.7624010	-122.4348123
614	33699	rear yard setback requirements, 	2018-007259VAR 	(J. HORN: (415) 575-6925) 	88 MUSEUM WAY 		Under Review	37.7645309	-122.4402448
669	33703	vertical and horizontal addition, which would result in a four-story mixed-use building with six dwelling units ground floor Community Facility, and six off-street parking spaces 	2018-003324VAR 	(E. JARDINES: (415) 575-9144) 	2779 FOLSOM STREET 		Under Review	37.7529650	-122.4137130
751	33708	allow for a modified rear yard configuration on a project that would demolish the existing 2-story parking garage and construct a new 37-unit residential building 	2017-000280VAR 	(A. PERRY: (415) 575-9017) 	915 NORTH POINT STREET 		Under Review	37.8052820	-122.4224838
534	33694	recommend the item. 	2018-002409DRP 	(D. WINSLOW: (415) 575-9159) 	1973 BROADWAY STREET 		Under Review	37.7946960	-122.4294760
464	33690	install a new rooftop AT&T Mobility Macro Wireless Telecommunications Facility consisting of (2) new FRP enclosures; (9) new antennas; (24) new RRHs; (1) GPS antenna; ancillary equipment; and (1) equipment room within the existing building as part of the AT&T Mobility Telecommunications Network. 	2016-015675CUA 	(A. LINDSAY: (415) 575-9178) 	2990 24TH STREET 		Under Review	37.7528450	-122.4117517
465	33690	construction of four single family houses 	2015-008351DRP-06 	(D. WINSLOW: (415) 575-9159) 	380 HOLLADAY AVENUE 		Under Review	37.7437764	-122.4064344
473	33690	mixed-use building containing 66 residential dwelling units above 26 ground floor parking spaces commercial uses 	2016-000378VAR 	(N. FOSTER: (415) 575-9167) 	1600 JACKSON STREET 		Under Review	37.7943514	-122.4218618
480	33691	demolish an existing two-story, single- family dwelling and construct a new four-story, 3-unit residential building 	2015-018150CUA 	(C. MAY: (415) 575-9087) 	137 CLAYTON STREET 		Under Review	37.7739054	-122.4496653
482	33691	conversion of existing ground floor Retail Use to Restaurant Use and the establishment of a Nighttime Entertainment Use upper-story uses of pre-existing structures 	2017-001270CUA 	(D. VU: (415) 575-9120) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
483	33691	rear yard requirement 	2017-001270VAR 	(D. VU: (415) 575-9120) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
493	33692	demolish an existing ft., one-story over basement single- family dwelling and construct a 	2016-004478CUA 	(D. VU: (415) 575-9120) 	589 TEXAS STREET 		Under Review	37.7589799	-122.3949361
497	33692	construct 1- and 3-story horizontal rear additions, construct 3rd and 4th floor vertical additions, and lower all floor plates in the existing single-family dwelling include a one-bedroom accessory dwelling unit rear yard for a sunken terrace, façade alterations, and interior modifications including the expansion of the existing basement level garage to accommodate another vehicle 	2017-002545DRP 	(C. MAY: (415) 575-9087) 	2417 GREEN STREET 		Under Review	37.7955233	-122.4393295
501	33692	install a permanent rooftop AT&T Mobility Macro Wireless Telecommunications Facility installation of (4) FRP enclosures; (16) panel antennas; (24) RRH’s, (1) GPS antenna; (6) surge suppressors; coax cable trays from equipment area to antennas; additional equipment proposed at ground level will not be visible from public views; FRP screens will be painted white to match existing rooftop penthouse as part of the AT&T Mobility Telecommunications Network. 	2018-006212CUA 	(A. LINDSAY: (415) 575-9178) 	145 LAUREL STREET 		Under Review	37.7897334	-122.4510143
504	33692	Care Facilities with seven or more persons as a principally permitted 	2018-013472PCA 	(A. BUTKUS: (415) 	575-9129) RESIDENTIAL CARE 		Under Review	37.7494785	-122.4070692
507	33692	allow a change of use from an existing grocery store to a restaurant includes the removal of the white signage band obscuring the second-story windows, and the removal of all paint and other features obscuring the transparency of the second-story windows. 	2018-006127CUA 	(D. WEISSGLASS: (415) 575-9177) 	201 19TH AVENUE 		Under Review	37.7839856	-122.4789101
508	33692	existing real estate brokerage existing three-story mixed-use building 	2017-007943CUA 	(G. PANTOJA: (415) 575-8747) 	3848 24TH STREET 		Under Review	37.7518363	-122.4284760
510	33692	allow the construction of four two-family, two- to three-story dwellings covered parking one two-family, three-story 	2013.0655VAR 	(D. VU: (415) 575-9120) 	1513 YORK STREET 		Under Review	37.7474652	-122.4073113
512	33692	rear yard setback requirement construct a new third floor level and a roof deck to the existing two-story building, containing commercial space and three dwelling units. existing building already encroaches into the required rear yard setback, a portion of the new third floor would require a rear yard 	2016-005555VAR 	(M. WOODS: (415) 558-6315) 1794-1798 FILBERT 	STREET/2902 OCTAVIA STREET 		Under Review	37.7990547	-122.4290320
517	33693	establish a hotel use; and a Planning Code Text allow terrace infill on an existing nonconforming structure rehabilitation of the existing 13- story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces at the 4th and 13th floors. 	2016-007303DNXCUA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
519	33693	recommend the item. 	2018-002409DRP 	(D. WINSLOW: (415) 575-9159) 	1973 BROADWAY STREET 		Under Review	37.7946960	-122.4294760
532	33694	establish a hotel use; and a Planning Code Text allow terrace infill on an existing nonconforming structure rehabilitation of the existing 13- story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces at the 4th and 13th floors. 	2016-007303DNXCUA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
547	33695	establish a hotel use; and a Planning Code Text allow terrace infill on an existing nonconforming structure rehabilitation of the existing 13- story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces at the 4th and 13th floors. 	2016-007303DNXCUA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
549	33695	recommend the item. 	2018-002409DRP 	(D. WINSLOW: (415) 575-9159) 	1973 BROADWAY STREET 		Under Review	37.7946960	-122.4294760
562	33696	establish a hotel use; and a Planning Code Text allow terrace infill on an existing nonconforming structure rehabilitation of the existing 13- story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces at the 4th and 13th floors. 	2016-007303DNXCUA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
665	33703	rear yard setback and dwelling unit 	2018-007204VAR 	(L. AJELLO: (415) 575-9142) 	754 35TH AVENUE 		Under Review	37.7747845	-122.4947000
579	33697	recommend the item. 	2018-002409DRP 	(D. WINSLOW: (415) 575-9159) 	1973 BROADWAY STREET 		Under Review	37.7946960	-122.4294760
592	33698	establish a hotel use; and a Planning Code Text allow terrace infill on an existing nonconforming structure rehabilitation of the existing 13- story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces at the 4th and 13th floors. 	2016-007303DNXCUA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
594	33698	recommend the item. 	2018-002409DRP 	(D. WINSLOW: (415) 575-9159) 	1973 BROADWAY STREET 		Under Review	37.7946960	-122.4294760
604	33699	demolition of an existing mixed-use building containing a residential unit and new construction of a three-story-over- basement mixed-use building with three residential units and one ground commercial unit 	2017-009635CUA 	(V. FLORES: (415) 575-9173) 	432 CORTLAND AVENUE 		Under Review	37.7389372	-122.4170170
605	33699	establish a new Restaurant within an existing, ground-floor commercial tenant space The Project involves interior and exterior tenant improvements, including a 4’-4” horizontal expansion of the tenant space into a recessed opening fronting 	2018-007366CUA 	(N. FOSTER: (415) 575-9167) 	838 GRANT AVENUE 		Under Review	37.7948544	-122.4060656
607	33699	a one-story vertical addition and a three-story rear horizontal addition, including alterations to the front façade 	2018-016494PCA 	(L. CHEN: (415) 	575-9124) CENTRAL SOMA 		Under Review	37.7785189	-122.4056395
608	33699	existing vacant space most recently used for private parking 	2018-012330CUA 	(M. CHANDLER: (415) 575-9048) 	447 BROADWAY 		Under Review	37.7979148	-122.4048266
612	33699		2018-016562PCA 	(J. BINTLIFF: (415) 	575-9170) INCLUSIONARY HOUSING FEE 		Under Review	37.7749295	-122.4194155
619	33700	allow a change of use from an existing grocery store to a restaurant in a Limited Commercial Use space includes the removal of the white signage band obscuring the second-story windows, and the removal of all paint and other features obscuring the transparency of the second-story windows. 	2018-006127CUA 	(D. WEISSGLASS: (415) 575-9177) 	201 19TH AVENUE 		Under Review	37.7839856	-122.4789101
621	33700	rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses. 	2017-001270VAR 	(R. SUCRE: (415) 575-9108) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
638	33701	allow a change of use from an existing grocery store to a restaurant in a Limited Commercial Use space includes the removal of the white signage band obscuring the second-story windows, and the removal of all paint and other features obscuring the transparency of the second-story windows. 	2018-006127CUA 	(D. WEISSGLASS: (415) 575-9177) 	201 19TH AVENUE 		Under Review	37.7839856	-122.4789101
640	33701	rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses. 	2017-001270VAR 	(R. SUCRE: (415) 575-9108) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
657	33702	rear yard setback and dwelling unit 	2018-007204VAR 	(L. AJELLO: (415) 575-9142) 	754 35TH AVENUE 		Under Review	37.7747845	-122.4947000
666	33703	Limited Restaurant use as an Accessory Use; amending the Police Code to eliminate certain duplicative inspections and signoffs in connection with Place of Entertainment permits, and amending the definition of Limited Live Performance Locale to remove the requirement for food and beverage service; affirming the Planning Department's determination under the California Environmental Quality Act; and making findings of consistency with the General Plan, and the eight priority policies 	2019-000048PCA 	(A. BUTKUS: (415) 	575-9129) SMALL BUSINESS PERMIT 		Under Review	37.7749295	-122.4194155
673	33704	establish a hotel use; and a Planning Code Text allow terrace infill on an existing nonconforming structure rehabilitation of the existing 13- story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces at the 4th and 13th floors. 	2016-007303DNXCUA 	(S. ADINA: (415) 575-8722) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
675	33704	change of use from retail to office at the ground floor ground floor of both buildings and a conversion of 3,359 square feet of retail use to office use at the ground floor two buildings and the addition of a 962 square-foot retail structure in the plaza. 	2018-004711DNXCUA 	(S. ADINA: (415) 575-8722) 	555 - 575 MARKET STREET 		Under Review	37.7899845	-122.3998704
676	33704	construction of a 3 -story residential building 	2016-009503DRP 	(D. WINSLOW: (415) 575-9159) 	149 MANGELS AVENUE 	2016.0712.2060 	Under Review	37.7328710	-122.4407590
677	33704	allow up to one dwelling unit construction of four two-family, two- to three-story dwellings covered parking one two-family, three-story dwelling 	2013.0655CUA 	(R. SUCRE: (415) 575-9108) 	1513A-F YORK STREET 		Under Review	37.7474652	-122.4073113
678	33704	rear yard and exposure requirements allow the construction of four two-family, two- to three-story dwellings covered parking one two-family, three-story 	2013.0655VAR 	(R. SUCRE: (415) 575-9108) 	1513A-F YORK STREET 		Under Review	37.7474652	-122.4073113
689	33705	new construction of a one-story horizontal addition to a one-family house 	2018-003223DRP 	(D. WINSLOW: (415) 575-9159) 	15 EL SERENO COURT 		Under Review	37.7385422	-122.4445785
691	33705	demolish the existing parking lot and construct a new mixed-use development entertainment venue that would primarily house a theater space four-story hotel building that would accommodate a maximum of 192 guestrooms; and an approximately 14,000 gsf privately financed and maintained public park. 	2015-016326CUA 	(C. ALEXANDER: (415) 	575-8724) SEAWALL LOTS 		Under Review	37.8018293	-122.4004457
692	33705	to establish a retail professional service use with an accessory art gallery (retail sales and service use) in an existing and vacant first floor tenant space, last permitted as a retail sales and service use. No interior tenant improvements or changes to any building façade are associated with this proposal. 	2018-016667CUA 	(D. GANETSOS: (415) 575-9172) 	3307 SACRAMENTO STREET– 		Under Review	37.7880090	-122.4471359
710	33706	discontinue a Movie Theatre propose a Retail Sales and Service 	2017-009224CUA 	(M. WOODS: (415) 558-6315) 	601 VAN NESS AVENUE 		Under Review	37.7811165	-122.4213309
719	33707	demolish an existing single-family residence construct a new four-story, two-unit residence two off-street parking spaces. 	2017-013537CUA 	(K. DURANDET: (415) 575-6816) 	233 SAN CARLOS STREET 		Under Review	37.7596511	-122.4197458
721	33707	office space 	2016-010589OFA 	(L. HOAGLAND: (415) 575-6823) 	2300 HARRISON STREET 		Under Review	37.7604190	-122.4132499
792	33712	subdivision of an existing lot currently containing a single-family dwelling unit into four new lots, two which will be substandard lots, single-family dwelling units, and alter the existing single-family dwelling unit. 	2018-015554CUA 	(G. PANTOJA: (415) 575-8741) 	95 NORDHOFF STREET 		Under Review	37.7343360	-122.4413051
732	33707		2018-000547VAR 	(J. HORN: (415) 575-6925) 	42 ORD COURT 		Under Review	37.7641023	-122.4410950
737	33708	increase the enrollment cap for an existing school, Schools of the Sacred Heart (Broadway campus), with a student enrollment increase from 850 to 1050 students increase in the number of faculty and staff from 200 to 205 	2016-004403CUA 	(S. YOUNG: (415) 558-6346) 	2222 BROADWAY 		Under Review	37.7948351	-122.4338688
738	33708	demolish an existing single-family dwelling and construct a new six-family dwelling. 	2015-015199CUA 	(M. DITO: (415) 575-9164) 	562 28TH AVENUE 		Under Review	37.7787228	-122.4876535
740	33708	rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses. 	2017-001270VAR 	(R. SUCRE: (415) 575-9108) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
742	33708	allow the tantamount to demolition of an existing two-story two-family dwelling and the construction of vertical and horizontal additions to create a four-story three-family dwelling 	2019-000189CUA 	(J. HORN: (415) 575-6925) 	1860 9TH AVENUE 		Under Review	37.7536243	-122.4653664
743	33708	Cannabis Retail use (Suite 110) within a four-story mixed-use building. 	2019-000186CUA 	(M. CHRISTENSEN: (415) 575-8742) 	828 INNES AVENUE 		Under Review	37.7315730	-122.3744662
754	33709	demolish an existing over-garage single-family home construct a new over-garage single-family home 	2017-007582CUA 	(J. HORN: (415) 575-6925) 	225 VASQUEZ AVENUE 		Under Review	37.7434997	-122.4612534
756	33709	demolish an existing single-family residence construct a new four-story, two-unit residence two off-street parking spaces. 	2017-013537CUA 	(K. DURANDET: (415) 575-6816) 	233 SAN CARLOS STREET 		Under Review	37.7596511	-122.4197458
759	33709	office space 	2016-010589OFA 	(L. HOAGLAND: (415) 575-6823) 	2300 HARRISON STREET 		Under Review	37.7604190	-122.4132499
766	33709		2018-009551VAR 	(D. WINSLOW: (415) 575-9159) 	3847-3849 18TH STREET 		Under Review	37.7609832	-122.4293786
774	33711	rear yard modification to substitute the required rear yard with an open area on the second floor equal to 25% of the lot area at the interior corner of the lot. 	2017-013801VAR 	(C. CAMPBELL: (415) 575-8732) 	250 RANDOLPH STREET 		Under Review	37.7144426	-122.4651343
775	33711	subdivision of an existing lot currently containing a single-family dwelling unit into four new lots, two which will be substandard lots, single-family dwelling units, and alter the existing single-family dwelling unit. 	2018-015554CUA 	(G. PANTOJA: (415) 575-8741) 	95 NORDHOFF STREET 		Under Review	37.7343360	-122.4413051
777	33711	existing building rear yard requirements for one proposed ADU. rear yard and denied the Variance to exposure for two proposed ADUs facing onto the rear yard 	2017-008412DRP 	(K. PHUNG: (415) 558-6373) 	2230 TURK BOULEVARD 		Under Review	37.7790550	-122.4459670
779	33711	demolish an existing over-garage single-family home construct a new over-garage single-family home with an accessory dwelling unit 	2017-007582CUA 	(J. HORN: (415) 575-6925) 	225 VASQUEZ AVENUE 		Under Review	37.7434997	-122.4612534
780	33711	allow a Planned Unit Development demolish an automotive service station, a car wash, and 3 dwelling units and construct a 3- to 6-story building with 184 dwelling units, approximately 8,100 square feet of commercial/retail use, 57 parking spaces, and 184 bicycle spaces, totaling approximately 150,000 square feet. bay window projections over streets dwelling unit density increase conversion of a service station demolition of residential units 	2015-007816CUA 	(M. WOODS: (415) 558-6315) 	400-444 DIVISADERO STREET 1048-1064 OAK STREET 		Under Review	37.7734065	-122.4365936
791	33712	rear yard modification to substitute the required rear yard with an open area on the second floor equal to 25% of the lot area at the interior corner of the lot. 	2017-013801VAR 	(C. CAMPBELL: (415) 575-8732) 	250 RANDOLPH STREET 		Under Review	37.7144426	-122.4651343
794	33712	existing building rear yard requirements for one proposed ADU. rear yard and denied the Variance to exposure for two proposed ADUs facing onto the rear yard 	2017-008412DRP 	(K. PHUNG: (415) 558-6373) 	2230 TURK BOULEVARD 		Under Review	37.7790550	-122.4459670
796	33712	demolish an existing over-garage single-family home construct a new over-garage single-family home with an accessory dwelling unit 	2017-007582CUA 	(J. HORN: (415) 575-6925) 	225 VASQUEZ AVENUE 		Under Review	37.7434997	-122.4612534
797	33712	allow a Planned Unit Development demolish an automotive service station, a car wash, and 3 dwelling units and construct a 3- to 6-story building with 184 dwelling units, approximately 8,100 square feet of commercial/retail use, 57 parking spaces, and 184 bicycle spaces, totaling approximately 150,000 square feet. bay window projections over streets dwelling unit density increase conversion of a service station demolition of residential units 	2015-007816CUA 	(M. WOODS: (415) 558-6315) 	400-444 DIVISADERO STREET 1048-1064 OAK STREET 		Under Review	37.7734065	-122.4365936
807	33713	merge three lots into one lot for the construction 	2016-003994CUA 	(C. TOWNES: (415) 575-9195) 	55 BELCHER STREET 		Under Review	37.7685109	-122.4298420
500	33692		2016-000378VAR 	(N. FOSTER: (415) 575-9167) 	1600 JACKSON STREET 		Under Review	37.7943514	-122.4218618
652	33701	proposing to construct a new third floor level and a roof deck to the existing two-story building, containing commercial space and three dwelling existing building already encroaches into the required rear yard setback, a portion of the new third floor would require a Variance from the rear yard 	2016-005555DRP-02 	(M. WOODS: (415) 558-6315) 1794-1798 FILBERT 	STREET/2902 OCTAVIA STREET 	2016.09.27.8915S 	Under Review	37.7990547	-122.4290320
700	33705		2017-016416PCA 	(A. STARR: (415) 	558-6362) CODE REORGANIZATION 		Under Review	37.7749295	-122.4194155
476	33690	vertical addition to an existing single-family home. 	2015-004717DRP 	(M. CHRISTENSEN: (415) 575-8742) 	11 GLADYS STREET 		Under Review	37.7399924	-122.4223122
463	33690	demolish an existing two-story single-family dwelling and construct a new four-story structure with two dwelling units. 	2017-015810CUA 	(L. HOAGLAND: (415) 575-6823) 	830 RHODE ISLAND 		Under Review	37.7592172	-122.4023154
468	33690	ground floor tenant space most recently used as a General Retail Sales 	2018-008620CUA 	(M. CHANDLER: (415) 575-9048) 	693 14TH STREET 		Under Review	37.7675454	-122.4285424
472	33690	establish a new general grocery store second floor of the subject property, second floor would contain additional retail floor area, and accessory office space. horizontal extension of the existing parapet, new paint, and new store signage. utilize the existing below-grade parking garage with 70 vehicular parking spaces 	2016-000378CUA 	(N. FOSTER: (415) 575-9167) 	1600 JACKSON STREET 		Under Review	37.7943514	-122.4218618
474	33690	regarding the shadow study that concluded, with the recommendation of the general manager of the Recreation demolish the existing buildings on the site, and construct a six-story, 65-foot tall, approximately 25,756 square-foot (sf) mixed-use building 	2016-008438SHD 	(K. DURANDET: (415) 575-6816) 	1075-1089 FOLSOM STREET 		Under Review	37.7769710	-122.4071498
477	33690	rear yard requirement vertical addition to an existing single-family home. 	2015-004717VAR 	(M. CHRISTENSEN: (415) 575-8742) 	11 GLADYS STREET 		Under Review	37.7399924	-122.4223122
479	33691	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground San Francisco Planning Commission 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
481	33691	construction of; 1) a 10’ front addition at the bottom floor of the dwelling; 2) a 19’-6” front addition at the first floor; 3) an 11’ rear and 4’ side addition to the existing detached garage; 4) an 8’ wide passage way that connects both structures at the first floor; 5) a new second floor new second floor 	2017-012929DRP 	(D. WINSLOW: (415) 575-9159) 	830 OLMSTEAD STREET 		Under Review	37.7207577	-122.4101145
487	33691		2018-008367PCA 	(M. CHRISTENSEN: (415) 	575-8742) CANNABIS GRANDFATHERING 		Under Review	37.7749295	-122.4194155
488	33691	construct two residential buildings: a 16-story, 160-foot tall building The buildings would contain a total of 465 dwelling units, a 2,175-square -foot community meeting facility, approximately 52,000 square feet of common open space private open space, 582 on-site vehicle parking spaces and 288 bicycle parking spaces. 	2004.1031CRV 	(E. SAMONSKY: (415) 575-9112) 	601 CRESCENT WAY 		Under Review	37.7117360	-122.3889949
489	33691	conversion of the existing 131,650-gross-square-foot, 13-story, 187-foot-tall Hearst Building from office use to a mixed-use hotel with ground- level retail, new event space and rooftop bar and patio. mixed-use building would result office space, and 11,393 square feet of retail space, including 422 square feet of general retail No off-street parking would be provided. 	2016-007303ENV 	(J. POLLAK: (415) 575-8766) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
492	33692	a one-story vertical addition and a three-story rear horizontal addition, including alterations to the front façade 	2017-010630DRP 	(D. WINSLOW: (415) 575-9159) 	1621 DIAMOND STREET 		Under Review	37.7444508	-122.4353885
494	33692	single-family residence, remodel an existing two-unit residence, and construct eight new units. 	2015-004297ENV 	(A. CALLAGY: (415) 575-8734) 271 UPPER TERRACE, 301-303 	4500 17TH STREET 		Under Review	37.7620710	-122.4454250
496	33692	rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses. 	2017-001270VAR 	(D. VU: (415) 575-9120) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
499	33692	establish a new general grocery store second floor of the subject property, second floor would contain additional retail floor area, and accessory office space. horizontal extension of the existing parapet, new paint, and new store signage. utilize the existing below-grade parking garage with 70 vehicular parking spaces 	2016-000378CUA 	(N. FOSTER: (415) 575-9167) 	1600 JACKSON STREET 		Under Review	37.7943514	-122.4218618
502	33692		2018-007888PCA 	(D. WINSLOW: (415) 	575-9159) POLK PACIFIC 		Under Review	37.7925153	-122.4382307
664	33703	Residential Density of three units allow construction of a four-story two-family dwelling currently occupied by a two-story, single-family residential San Francisco Planning Commission 	2018-007204CUA 	(L. AJELLO: (415) 575-9142) 	754 35TH AVENUE 		Under Review	37.7747845	-122.4947000
506	33692	demolish one existing single family residence, an addition/remodel to an existing two-dwelling unit construct four new two-family buildings, up to 40-feet tall. result in the removal of one or more residential units shall require a Conditional Use Authorization for the removal and replacement of the units. residential development on a vacant parcel that will result in total gross floor area exceeding residential development on a developed parcel that will result in total gross floor area development on the parcel and does not increase the number of legal dwelling units on the parcel. 	2015-004297CUA 	(C. TOWNES: (415) 575-9195) 271, 	273 UPPER TERRACE; 		Under Review	37.7622879	-122.4455250
509	33692	allow up to one dwelling unit area for the construction of four two-family, two- to three-story dwellings covered parking one two-family, three-story dwelling 	2013.0655CUA 	(D. VU: (415) 575-9120) 	1513A-F YORK STREET 		Under Review	37.7474652	-122.4073113
514	33693	demolition of a single-family home 	2017-016050CUA 	(J. HORN: (415) 575-6925) 	49 HOPKINS AVENUE 		Under Review	37.7529521	-122.4445453
516	33693	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
518	33693	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
522	33693		2015-018150CUA 	MAY: (415) 575-9087) 	137 CLAYTON STREET 		Under Review	37.7739054	-122.4496653
525	33693	allow a change in use from a General Grocery use (currently vacant, formerly 	2018-005694CUA 	(C. MAY: (415) 575-9087) 	3060 FILLMORE STREET 		Under Review	37.7979025	-122.4353553
527	33693	rear horizontal expansion of an existing terrace above a solarium 	2018-006613DRP 	(D. WINSLOW: (415) 575-9159) 	610 EL CAMINO DEL MAR 		Under Review	37.7868677	-122.4901014
529	33694	demolition of a single-family home 	2017-016050CUA 	(J. HORN: (415) 575-6925) 	49 HOPKINS AVENUE 		Under Review	37.7529521	-122.4445453
531	33694	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
533	33694	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
537	33694		2015-018150CUA 	MAY: (415) 575-9087) 	137 CLAYTON STREET 		Under Review	37.7739054	-122.4496653
540	33694	allow a change in use from a General Grocery use (currently vacant, formerly 	2018-005694CUA 	(C. MAY: (415) 575-9087) 	3060 FILLMORE STREET 		Under Review	37.7979025	-122.4353553
542	33694	rear horizontal expansion of an existing terrace above a solarium 	2018-006613DRP 	(D. WINSLOW: (415) 575-9159) 	610 EL CAMINO DEL MAR 		Under Review	37.7868677	-122.4901014
544	33695	demolition of a single-family home 	2017-016050CUA 	(J. HORN: (415) 575-6925) 	49 HOPKINS AVENUE 		Under Review	37.7529521	-122.4445453
546	33695	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
548	33695	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
552	33695		2015-018150CUA 	MAY: (415) 575-9087) 	137 CLAYTON STREET 		Under Review	37.7739054	-122.4496653
555	33695	allow a change in use from a General Grocery use (currently vacant, formerly 	2018-005694CUA 	(C. MAY: (415) 575-9087) 	3060 FILLMORE STREET 		Under Review	37.7979025	-122.4353553
557	33695	rear horizontal expansion of an existing terrace above a solarium 	2018-006613DRP 	(D. WINSLOW: (415) 575-9159) 	610 EL CAMINO DEL MAR 		Under Review	37.7868677	-122.4901014
559	33696	demolition of a single-family home 	2017-016050CUA 	(J. HORN: (415) 575-6925) 	49 HOPKINS AVENUE 		Under Review	37.7529521	-122.4445453
561	33696	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
631	33700	allow the demolition of an existing 	2017-005279CUA 	(J. HORN: (415) 575-6925) 	448 VALLEY STREET 		Under Review	37.7443326	-122.4324134
567	33696		2015-018150CUA 	MAY: (415) 575-9087) 	137 CLAYTON STREET 		Under Review	37.7739054	-122.4496653
570	33696	allow a change in use from a General Grocery use (currently vacant, formerly 	2018-005694CUA 	(C. MAY: (415) 575-9087) 	3060 FILLMORE STREET 		Under Review	37.7979025	-122.4353553
572	33696	rear horizontal expansion of an existing terrace above a solarium 	2018-006613DRP 	(D. WINSLOW: (415) 575-9159) 	610 EL CAMINO DEL MAR 		Under Review	37.7868677	-122.4901014
574	33697	demolition of a single-family home 	2017-016050CUA 	(J. HORN: (415) 575-6925) 	49 HOPKINS AVENUE 		Under Review	37.7529521	-122.4445453
576	33697	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
578	33697	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
582	33697		2015-018150CUA 	MAY: (415) 575-9087) 	137 CLAYTON STREET 		Under Review	37.7739054	-122.4496653
585	33697	allow a change in use from a General Grocery use (currently vacant, formerly 	2018-005694CUA 	(C. MAY: (415) 575-9087) 	3060 FILLMORE STREET 		Under Review	37.7979025	-122.4353553
587	33697	rear horizontal expansion of an existing terrace above a solarium 	2018-006613DRP 	(D. WINSLOW: (415) 575-9159) 	610 EL CAMINO DEL MAR 		Under Review	37.7868677	-122.4901014
589	33698	demolition of a single-family home 	2017-016050CUA 	(J. HORN: (415) 575-6925) 	49 HOPKINS AVENUE 		Under Review	37.7529521	-122.4445453
591	33698	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
672	33704	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(S. ADINA: (415) 575-8722) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
597	33698		2015-018150CUA 	MAY: (415) 575-9087) 	137 CLAYTON STREET 		Under Review	37.7739054	-122.4496653
600	33698	allow a change in use from a General Grocery use (currently vacant, formerly 	2018-005694CUA 	(C. MAY: (415) 575-9087) 	3060 FILLMORE STREET 		Under Review	37.7979025	-122.4353553
602	33698	rear horizontal expansion of an existing terrace above a solarium 	2018-006613DRP 	(D. WINSLOW: (415) 575-9159) 	610 EL CAMINO DEL MAR 		Under Review	37.7868677	-122.4901014
609	33699		2018-002409DRP 	(D. WINSLOW: (415) 575-9159) 	1973 BROADWAY 		Under Review	37.7946960	-122.4294760
620	33700	conversion of existing ground floor Retail upper-story uses of pre-existing structures new Restaurant with Nighttime Entertainment Use including interior renovations, installation of new storefront systems, and the construction of a rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses for a new Outdoor Activity Area. 	2017-001270CUA 	(R. SUCRE: (415) 575-9108) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
622	33700	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
623	33700		2017-005279VAR 	(J. HORN: (415) 575-6925) 	448 VALLEY STREET 		Under Review	37.7443326	-122.4324134
629	33700	conversion of the existing 131,650-gross-square-foot, 13-story, 189-foot-tall Hearst Building from office use to a mixed-use hotel with ground- level retail, new event space and rooftop bar and patio. mixed-use building would result office space, and 11,393 square feet of retail space, including 422 square feet of general retail 	2016-007303ENV 	(J. POLLAK: (415) 575-8766) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
634	33700	rear yard setback requirement construct a new third floor level and a roof deck to the existing two-story building, containing commercial space and three dwelling units. existing building already encroaches into the required rear yard 	2016-005555VAR 	(M. WOODS: (415) 558-6315) 1794-1798 FILBERT 	STREET/2902 OCTAVIA STREET 		Under Review	37.7990547	-122.4290320
639	33701	conversion of existing ground floor Retail upper-story uses of pre-existing structures new Restaurant with Nighttime Entertainment Use including interior renovations, installation of new storefront systems, and the construction of a rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses for a new Outdoor Activity Area. 	2017-001270CUA 	(R. SUCRE: (415) 575-9108) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
641	33701	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
642	33701		2017-005279VAR 	(J. HORN: (415) 575-6925) 	448 VALLEY STREET 		Under Review	37.7443326	-122.4324134
648	33701	conversion of the existing 131,650-gross-square-foot, 13-story, 189-foot-tall Hearst Building from office use to a mixed-use hotel with ground- level retail, new event space and rooftop bar and patio. mixed-use building would result office space, and 11,393 square feet of retail space, including 422 square feet of general retail 	2016-007303ENV 	(J. POLLAK: (415) 575-8766) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
650	33701	allow the demolition of an existing 	2017-005279CUA 	(J. HORN: (415) 575-6925) 	448 VALLEY STREET 		Under Review	37.7443326	-122.4324134
653	33701	rear yard setback requirement construct a new third floor level and a roof deck to the existing two-story building, containing commercial space and three dwelling units. existing building already encroaches into the required rear yard 	2016-005555VAR 	(M. WOODS: (415) 558-6315) 1794-1798 FILBERT 	STREET/2902 OCTAVIA STREET 		Under Review	37.7990547	-122.4290320
656	33702	Residential Density of three units allow construction of a four-story two-family dwelling currently occupied by a two-story, single-family residential San Francisco Planning Commission 	2018-007204CUA 	(L. AJELLO: (415) 575-9142) 	754 35TH AVENUE 		Under Review	37.7747845	-122.4947000
681	33704	convert a former church to community facility and instructional services 	2018-003593CUA 	(N. TRAN: (415) 575-9174) 	906 BROADWAY 		Under Review	37.7974364	-122.4123181
683	33704	rear yard setback and dwelling unit 	2018-007204VAR 	(L. AJELLO: (415) 575-9142) 	754 35TH AVENUE 		Under Review	37.7747845	-122.4947000
694	33705	change the zoning district change the zoning district 	2019-003571MAP 	(V. FLORES: (415) 575-9173) 	915 CAYUGA AVENUE 		Under Review	37.7232384	-122.4385182
697	33705	allow demolition of the existing commercial building new construction of a five-story-over-two-basement building (measuring approximately 115,4985 square feet) with 116 residential units, 50% of which are affordable below market rate units. 	2016-013850CUA 	(V. FLORES: (415) 575-9173) 	915 CAYUGA AVENUE 		Under Review	37.7232384	-122.4385182
699	33705		2013.4117CWP 	(L. FISHER: (415) 	575-8715) SAN FRANCISCO BIODIVERSITY 		Under Review	37.7749295	-122.4194155
702	33705	rezone the entire project site and establish land use controls for the project site demolition of the existing commercial building new construction of a five-story-over-two-basement building (measuring approximately 115,4985 square feet) with 116 residential units, 50% of which are affordable below market rate units. 18 one-bedrooms, 70 two-bedrooms, and 12 three-bedroom units. 	2016-013850ENV 	(J. MOORE: (415) 575-8733) 	915 CAYUGA AVENUE 915 Cayuga Avenue 		Under Review	37.7232384	-122.4385182
707	33705	construction of an accessory dwelling unit at the ground floor garage area of a 4-story apartment building 	2018-007006DRP 	(D. WINSLOW: (415) 575-9159) 	2000 GROVE STREET 		Under Review	37.7745471	-122.4497867
709	33706	establish a legitimization program for certain Non-Residential Uses 	2019-002217PCA 	(A. BUTKUS: (415) 575-9129) LEGITIMIZATION PROGRAM 	3150 18TH STREET 		Under Review	37.7625486	-122.4141391
711	33706	vertical addition to a two-story one-family house 	2017-013841DRP 	(D. WINSLOW: (415) 575-9159) 	295 COSO AVENUE 		Under Review	37.7452058	-122.4156454
714	33706	allow a change of use from an existing grocery store to a restaurant includes the removal of the white signage band obscuring the second-story windows, and the removal of all paint and other features obscuring the transparency of the second-story windows. 	2018-006127CUA 	(D. WEISSGLASS: (415) 575-9177) 	201 19TH AVENUE 		Under Review	37.7839856	-122.4789101
716	33706	existing warehouse space 	2018-012416CUA 	(M. CHRISTENSEN: (415) 575-8742) 	1345 UNDERWOOD AVENUE 		Under Review	37.7268410	-122.3872133
720	33707	demolish an existing surface parking lot 	2016-010589ENX 	(L. HOAGLAND: (415) 575-6823) 	2300 HARRISON STREET 		Under Review	37.7604190	-122.4132499
722	33707	establish a new Restaurant existing, ground-floor commercial tenant space The Project involves interior and exterior tenant improvements, including a 4’-4” horizontal expansion of the tenant space into a recessed opening fronting 	2018-007366CUA 	(N. FOSTER: (415) 575-9167) 	838 GRANT AVENUE 		Under Review	37.7948544	-122.4060656
723	33707	horizontal addition, excavation for garage, and reconfiguration of exterior front stairs of a two-story one-family house 	2016-000240DRP 	(D. WINSLOW: (415) 575-9159) 	1322 WAWONA STREET 		Under Review	37.7373936	-122.4811979
726	33707	mixed-use development, and activate a new waterfront open space. existing height limits of 40 and 65 feet to various heights ranging from 65 to 300 feet. 	2015-010192CWP 	(J. FRANCIS: (415) 	575-9147) POTRERO POWER STATION 		Under Review	37.7569490	-122.3858615
727	33707	allow for rooftop infill along the primary building frontage 	2016-007303PCA 	(S. ADINA: (415) 575-8722) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
733	33707	Kennel use within the two-story building, currently under construction 	2018-010426CUA 	(C. MAY: (415) 575-9087) 	2675 GEARY BOULEVARD 		Under Review	37.7821682	-122.4464584
736	33708	demolition of an existing one-story commercial building new construction of a four-story three-family house 	2018-008362DRP 	(D. WINSLOW: (415) 575-9159) 	237 CORTLAND AVENUE 		Under Review	37.7395578	-122.4188753
741	33708	establish a new Restaurant existing, ground-floor commercial tenant space The Project involves interior and exterior tenant improvements, including a 4’-4” horizontal expansion of the tenant space into a recessed opening fronting 	2018-007366CUA 	(N. FOSTER: (415) 575-9167) 	838 GRANT AVENUE 		Under Review	37.7948544	-122.4060656
753	33709	establish a legitimization program for certain Non-Residential Uses 	2019-002217PCA 	(A. BUTKUS: (415) 575-9129) LEGITIMIZATION PROGRAM 	3150 18TH STREET 		Under Review	37.7625486	-122.4141391
755	33709	existing one-story Industrial building to allow the cultivation of cannabis. 	2018-013230CUA 	(M. CHRISTENSEN: (415) 575-8742) 	2215 QUESADA AVENUE 		Under Review	37.7389016	-122.4016184
763	33709	demolition of the existing four buildings on the project site and new construction of three new mixed-use/office buildings with a total of 922,737 square feet of office use, 11,890 square feet of PDR/retail use, 5,546 square feet of child care 	2011.1356 	SMALL: (415) 	575-9160) CENTRAL SOMA OPEN 		Under Review	37.7785189	-122.4056395
768	33710	allow a Planned Unit Development demolish an automotive service San 	2015-007816CUA 	(M. WOODS: (415) 558-6315) 	400-444 DIVISADERO STREET 1048-1064 OAK STREET 		Under Review	37.7734065	-122.4365936
773	33711	demolish an existing dwelling unit & laundromat and construct a four-story two-family dwelling with ground floor commercial 	2017-013801CUA 	(C. CAMPBELL: (415) 575-8732) 	250 RANDOLPH STREET 		Under Review	37.7144426	-122.4651343
776	33711	existing building rear yard and denied the request for the other two 	2017-008431DRP 	(K. PHUNG: (415) 558-6373) 	2220 TURK BOULEVARD 		Under Review	37.7790604	-122.4457949
778	33711	increase the enrollment cap for an existing school, Schools of the Sacred Heart (Broadway campus), with a student enrollment increase from 850 to 1050 students increase in the number of faculty and staff from 200 to 205 	2016-004403CUA 	(S. YOUNG: (415) 558-6346) 	2222 BROADWAY 		Under Review	37.7948351	-122.4338688
781	33711	establish a legitimization program for certain Non-Residential Uses 	2019-002217PCA 	(A. BUTKUS: (415) 575-9129) LEGITIMIZATION PROGRAM 	3150 18TH STREET 		Under Review	37.7625486	-122.4141391
783	33711	demolition of the existing 288,570 square foot Bay Club tennis building and construction of three new additional on-site open space, including privately-owned public opens space 	2015-012490ENXOFA 	(L. HOAGLAND: (415) 575-6823) 	88 BLUXOME STREET 		Under Review	37.7763422	-122.3979876
785	33711	allow the tantamount to demolition of an existing two-story two-family dwelling and the construction of vertical and horizontal additions to create a four-story three-family dwelling with an accessory dwelling unit 	2019-000189CUA 	(J. HORN: (415) 575-6925) 	1860 9TH AVENUE 		Under Review	37.7536243	-122.4653664
788	33711	construction of a 3 -story residential building 	2016-009503DRP 	(D. WINSLOW: (415) 575-9159) 	149 MANGELS AVENUE 	2016.0712.2060 	Under Review	37.7328710	-122.4407590
790	33712	demolish an existing dwelling unit & laundromat and construct a four-story two-family dwelling with ground floor commercial 	2017-013801CUA 	(C. CAMPBELL: (415) 575-8732) 	250 RANDOLPH STREET 		Under Review	37.7144426	-122.4651343
793	33712	existing building rear yard and denied the request for the other two 	2017-008431DRP 	(K. PHUNG: (415) 558-6373) 	2220 TURK BOULEVARD 		Under Review	37.7790604	-122.4457949
795	33712	increase the enrollment cap for an existing school, Schools of the Sacred Heart (Broadway campus), with a student enrollment increase from 850 to 1050 students increase in the number of faculty and staff from 200 to 205 	2016-004403CUA 	(S. YOUNG: (415) 558-6346) 	2222 BROADWAY 		Under Review	37.7948351	-122.4338688
798	33712	establish a legitimization program for certain Non-Residential Uses 	2019-002217PCA 	(A. BUTKUS: (415) 575-9129) LEGITIMIZATION PROGRAM 	3150 18TH STREET 		Under Review	37.7625486	-122.4141391
800	33712	demolition of the existing 288,570 square foot Bay Club tennis building and construction of three new additional on-site open space, including privately-owned public opens space 	2015-012490ENXOFA 	(L. HOAGLAND: (415) 575-6823) 	88 BLUXOME STREET 		Under Review	37.7763422	-122.3979876
802	33712	allow the tantamount to demolition of an existing two-story two-family dwelling and the construction of vertical and horizontal additions to create a four-story three-family dwelling with an accessory dwelling unit 	2019-000189CUA 	(J. HORN: (415) 575-6925) 	1860 9TH AVENUE 		Under Review	37.7536243	-122.4653664
805	33712	construction of a 3 -story residential building 	2016-009503DRP 	(D. WINSLOW: (415) 575-9159) 	149 MANGELS AVENUE 	2016.0712.2060 	Under Review	37.7328710	-122.4407590
471	33690	mixed-use development, including residential, commercial, parking, community facilities and open space land uses. existing height limits of 40 and 65 feet to various heights ranging from 65 to 300 feet. construct up to approximately 5.3 million gross square feet of mixed uses and approximately 6.2 acres of open space. include demolition of up to 20 existing structures, including up to five historic structures that are contributors to the historic 	2017-011878ENV 	(R. SCHUETT: (415) 	575-9030) POTRERO POWER 		Under Review	37.7569490	-122.3858615
581	33697	demolition of the existing two-story, 30- to 45-foot-tall, 91,088 gross-square-foot (gsf) building, which most recently operated as the San Francisco Honda auto dealership and is a historic resource built in 1927, and construction of up to 984 residential units, in a mixed-use residential building with either two 41-story, 420-foot-tall towers over podiums, or one 55- story, 590-foot-tall tower over a single podium. bicycle parking spaces would be provided 	2015-004568ENV 	(R. SCHUETT: (415) 575-9030) 	10 SOUTH VAN NESS AVENUE 		Under Review	37.7755945	-122.4192604
486	33691	establish Office use on the basement and first floor of the subject property 	2018-012623CUA 	(S. ADINA: (415) 575-8722) 	1 JONES STREET 		Approved	37.7812593	-122.4121923
490	33691	remove an unauthorized dwelling unit from the ground floor basement/garage level of an existing two-family, three-story residential building. No exterior alterations are 	2017-015110CUA 	(K. DURANDET: (415) 575-6816) 	1043 ALABAMA STREET 		Approved	37.7552242	-122.4109789
613	33699	construct a two-story detached garage structure and accessory space located on the “rear” property line of a through lot, resulting in a rear yard that is less than 45% of entire lot. 	2018-007259CUA 	(J. HORN: (415) 575-6925) 	88 MUSEUM WAY 		Approved	37.7645309	-122.4402448
660	33702	allow for dwelling establish a Community Facility vertical and horizontal addition to an existing two-story building. result in a four-story mixed-use building with six dwelling units ground floor Community Facility, and six off-street parking spaces 	2018-003324CUA 	(E. JARDINES: (415) 575-9144) 	2779 FOLSOM STREET 		Approved	37.7529650	-122.4137130
685	33704	establish office use and the basement and ground floor of the subject buildings, ground floor fronting Minna Street and the basement. 	2018-012687CUA 	(S. ADINA: (415) 575-8722) 	657 - 667 MISSION STREET 		Approved	37.7867076	-122.4008440
698	33705	increase required rear yards in single family zoning districts by five percent, amend the rear yard requirements for through lots and corner lots in certain districts to permit second buildings where specified conditions are met, and allow building height increases to existing stories in existing nonconforming buildings 	2019-001604PCA 	(D. SANCHEZ: (415) 	575-9082) BUILDING STANDARDS 		Approved	37.7749295	-122.4194155
730	33707	demolish the existing building on the site, and construct a seven-story, 68- foot tall, approximately 58,553 gross-square-foot (gsf) mixed-use building which would consist of 50 dwellings. The ground floor provides a residential lobby, community/fitness room, bicycle storage room for 30 Class 1 bicycle parking spaces, 2,104 sf of commercial space, and a trash room. provides 22 auto parking spaces including 1 car share, 60 Class 1 bicycle parking spaces, building services and storage. rear yard and 4,078 gsf on a roof deck of common open space private open space private balconies) on floors three to seven and is seeking exceptions to Planning Code Sections 134 for a rear yard modification and 140 for dwelling 	2015-015789ENX 	(K. DURANDET: (415) 575-6816) 	828 BRANNAN STREET 		Approved	37.7727193	-122.4042071
616	33699		2016-010079VAR 	(L. AJELLO: (415) 575-9142) 	3620 BUCHANAN STREET 		Under Review	37.8036044	-122.4332097
661	33702	vertical and horizontal addition, which would result in a four-story mixed-use building with six dwelling units ground floor Community Facility, and six off-street parking spaces 	2018-003324VAR 	(E. JARDINES: (415) 575-9144) 	2779 FOLSOM STREET 		Under Review	37.7529650	-122.4137130
495	33692	conversion of existing ground floor Retail upper-story uses of pre-existing structures new Restaurant with Nighttime Entertainment Use including interior renovations, installation of new storefront systems, and the construction of a rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses for a new Outdoor Activity Area. 	2017-001270CUA 	(D. VU: (415) 575-9120) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
564	33696	recommend the item. 	2018-002409DRP 	(D. WINSLOW: (415) 575-9159) 	1973 BROADWAY STREET 		Under Review	37.7946960	-122.4294760
577	33697	establish a hotel use; and a Planning Code Text allow terrace infill on an existing nonconforming structure rehabilitation of the existing 13- story, 161,108 sf building for use as a 170-room hotel with retail on the ground floor and basement level, offices on floors two and three, and rooftop terraces at the 4th and 13th floors. 	2016-007303DNXCUA 	(E. TUFFY: (415) 575-9191) 	5 THIRD STREET 		Under Review	37.7874792	-122.4032481
658	33702	Limited Restaurant use as an Accessory Use; amending the Police Code to eliminate certain duplicative inspections and signoffs in connection with Place of Entertainment permits, and amending the definition of Limited Live Performance Locale to remove the requirement for food and beverage service; affirming the Planning Department's determination under the California Environmental Quality Act; and making findings of consistency with the General Plan, and the eight priority policies 	2019-000048PCA 	(A. BUTKUS: (415) 	575-9129) SMALL BUSINESS PERMIT 		Under Review	37.7749295	-122.4194155
703	33705	subdivision of an existing lot currently containing a single- family dwelling unit into four new lots, two which will be substandard lots, single-family dwelling unit, for a total of three single-family dwelling units, and alter the existing single- family dwelling unit. 	2018-015554CUA 	(G. PANTOJA: (415) 575-8741) 	95 NORDHOFF STREET 		Under Review	37.7343360	-122.4413051
810	33713	demolition of the existing Flower Mart buildings and parking lot and construction of three new retail privately owned public open space retail child care facility privately owned public open space 632 off-street parking spaces, 9 loading spaces, and 608 bicycle spaces (518 Class I, 92 Class II). 	2017-000663PRJ 	(E. SAMONSKY: (415) 575-9112) 	610-698 BRANNAN STREET 		Under Review	37.7765942	-122.3994721
813	33713		2018-009861CUA 	(S. YOUNG: (415) 558-6346) 	1633 FILLMORE STREET 		Under Review	37.7846469	-122.4333867
731	33707	construct a vertical and horizontal addition to an existing 1,110 gross square foot, two-story single-family home An unoccupied, illegal dwelling unit is located two floors will be added on top of the rear portion of the existing structure and a 4-story horizontal rear addition will be constructed. provide two residential units and a new garage. 	2018-000547CUA 	(J. HORN: (415) 575-6925) 	42 ORD COURT 		Under Review	37.7641023	-122.4410950
758	33709	demolish an existing surface parking lot and construct a six-story over basement garage, 75-foot tall, 78,096 square foot vertical addition to an existing 3-story, 42-foot tall, 68,538 square foot office building. mixed-use building with 24 dwelling units, 27,152 square feet of additional office space, 3,242 square feet of ground floor retail, 1,158 square feet of ground floor arts activities/retail space, 31 additional Class 1 bicycle parking spaces, 8 Class 2 bicycle parking spaces and a total of 41 off-street parking spaces. dwelling-unit mix includes 14 one-bedroom and 10 two-bedroom units. open space through a combination of private and common open space. 	2016-010589ENX 	(L. HOAGLAND: (415) 575-6823) 	2300 HARRISON STREET 		Under Review	37.7604190	-122.4132499
633	33700	proposing to construct a new third floor level and a roof deck to the existing two-story building, containing commercial space and three dwelling existing building already encroaches into the required rear yard setback, a portion of the new third floor would require a Variance from the rear yard 	2016-005555DRP-02 	(M. WOODS: (415) 558-6315) 1794-1798 FILBERT 	STREET/2902 OCTAVIA STREET 	2016.09.27.8915S 	Under Review	37.7990547	-122.4290320
498	33692	install a permanent rooftop AT&T Mobility Macro Wireless Telecommunications Facility which will replace an existing temporary rooftop wireless facility. panel antennas screened behind a new radio-frequency (RF) transparent screen wall; installation of (6) new RRHs; reusing (6) existing panel antennas and ancillary equipment screened behind existing RF transparent screen walls; and installation of ancillary equipment. 	2018-002007CUA 	(A. LINDSAY: (415) 575-9178) 	318 MAIN STREET 		Under Review	37.7891933	-122.3917702
511	33692	construct a new third floor level and a roof deck to the existing two-story building, containing commercial space and three dwelling units. existing building already encroaches into the required rear yard setback, a portion of the new third floor would require a Variance from the rear http://commissions.sfplanning.org/cpcpackets/2013.0655CUAVAR.pdf 	2016-005555DRP-02 	(M. WOODS: (415) 558-6315) 1794-1798 FILBERT 	STREET/2902 OCTAVIA STREET 	2016.09.27.8915S 	Under Review	37.7990547	-122.4290320
563	33696	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
593	33698	the Project proposing a lot merger and new construction of a 78-foot tall, 7-story-over-basement residential building (measuring approximately 78,738 gross square feet (gsf)) with ground floor retail construct a total of 56 dwelling units, 5,633 square feet of ground floor commercial, and 46 below- grade off-street parking spaces. 	2014.0948ENX 	(E. JARDINES: (415) 575-9144) 344 14TH 	STREET/1463 STEVENSON STREET 		Under Review	37.7687821	-122.4212831
674	33704	allow a change of use from an existing grocery store to a restaurant includes the removal of the white signage band obscuring the second-story windows, and the removal of all paint and other features obscuring the transparency of the second-story windows. 	2018-006127CUA 	(D. WEISSGLASS: (415) 575-9177) 	201 19TH AVENUE 		Under Review	37.7839856	-122.4789101
739	33708	conversion of existing ground floor Retail upper-story uses of pre-existing structures new Restaurant with Nighttime Entertainment Use including interior renovations, installation of new storefront systems, and the construction of a rooftop deck, exit stairs, two restrooms, storage room, and two elevator penthouses for a new Outdoor Activity Area. 	2017-001270CUA 	(R. SUCRE: (415) 575-9108) 	3140-3150 16TH STREET 		Under Review	37.7651062	-122.4228911
809	33713	allow a Planned Unit Development demolish an automotive service station, a car wash, and 3 dwelling units and construct a 3- to 6-story building with 184 dwelling units, approximately 8,100 square feet of commercial/retail use, 57 parking spaces, and 184 bicycle spaces, totaling approximately 150,000 square feet. bay window projections over streets dwelling unit density increase conversion of a service station demolition of residential units 	2015-007816CUA 	(M. WOODS: (415) 558-6315) 	400-444 DIVISADERO STREET 1048-1064 OAK STREET 		Under Review	37.7734065	-122.4365936
\.


--
-- Data for Name: training; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.training (id, job_id, url, file, labels, updated_at) FROM stdin;
313	242	http://commissions.sfplanning.org/cpcpackets/20190425_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190425-cal-min-pdf	165	2019-07-07 19:09:52
331	242	http://commissions.sfplanning.org/cpcpackets/20181115_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20181115-cal-min-pdf	112	2019-07-07 17:43:23
344	242	file://dates-txt	/var/www/sites/nima/nerd/data/242/training/dates-txt	0	\N
345	242	file://outcomes-txt	/var/www/sites/nima/nerd/data/242/training/outcomes-txt	0	\N
327	242	http://commissions.sfplanning.org/cpcpackets/20190307_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190307-cal-min-pdf	132	2019-07-07 16:36:19
330	242	http://commissions.sfplanning.org/cpcpackets/20190214_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190214-cal-min-pdf	140	2019-07-07 17:44:08
329	242	http://commissions.sfplanning.org/cpcpackets/20190221_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190221-cal-min-pdf	108	2019-07-07 17:44:20
328	242	http://commissions.sfplanning.org/cpcpackets/20190228_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190228-cal-min-pdf	90	2019-07-07 17:46:34
339	242	http://commissions.sfplanning.org/cpcpackets/20180412_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20180412-cal-min-pdf	174	2019-07-07 17:41:59
326	242	http://commissions.sfplanning.org/cpcpackets/20190314_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190314-cal-min-pdf	150	2019-07-07 17:47:01
325	242	http://commissions.sfplanning.org/cpcpackets/20190613_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190613-cal-min-pdf	94	2019-07-07 17:47:12
338	242	http://commissions.sfplanning.org/cpcpackets/20190418_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190418-cal-min-pdf	159	2019-07-07 17:42:19
337	242	http://commissions.sfplanning.org/cpcpackets/20190523_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190523-cal-min-pdf	179	2019-07-07 17:42:29
336	242	http://commissions.sfplanning.org/cpcpackets/20190606_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190606-cal-min-pdf	136	2019-07-07 17:42:42
335	242	http://commissions.sfplanning.org/cpcpackets/20181213_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20181213-cal-min-pdf	129	2019-07-07 17:42:54
334	242	http://commissions.sfplanning.org/cpcpackets/20190110_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190110-cal-min-pdf	301	2019-07-07 17:43:01
333	242	http://commissions.sfplanning.org/cpcpackets/20190117_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190117-cal-min-pdf	97	2019-07-07 17:43:09
320	242	http://commissions.sfplanning.org/cpcpackets/20190516_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190516-cal-min-pdf	68	2019-07-07 17:47:26
332	242	http://commissions.sfplanning.org/cpcpackets/20181220_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20181220-cal-min-pdf	194	2019-07-07 17:43:15
319	242	http://commissions.sfplanning.org/cpcpackets/20190502_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190502-cal-min-pdf	180	2019-07-07 17:47:42
316	242	http://commissions.sfplanning.org/cpcpackets/20190418_cal_min.pdf	/var/www/sites/nima/nerd/data/242/training/http-commissions-sfplanning-org-cpcpackets-20190418-cal-min-pdf	147	2019-07-07 17:47:53
358	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62661	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62661	29	2019-07-12 15:44:06
360	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62480	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62480	35	2019-07-12 15:20:59
359	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62627	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62627	29	2019-07-12 15:32:01
357	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62765	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62765	3	2019-07-11 15:50:18
356	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62905	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62905	3	2019-07-11 15:50:11
355	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63117	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63117	3	2019-07-11 15:50:04
354	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63118	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63118	3	2019-07-11 15:49:53
352	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63458	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63458	3	2019-07-11 15:49:38
351	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63456	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63456	3	2019-07-11 15:49:31
349	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63603	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63603	4	2019-07-11 15:49:10
350	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63457	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63457	3	2019-07-11 15:49:21
348	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63834	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63834	3	2019-07-11 15:48:56
347	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63948	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63948	3	2019-07-11 15:48:49
346	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=64203	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-64203	3	2019-07-11 15:48:40
368	244	file://dates-txt	/var/www/sites/nima/nerd/data/244/training/dates-txt	0	\N
369	244	file://permits-txt	/var/www/sites/nima/nerd/data/244/training/permits-txt	0	\N
353	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=63455	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-63455	3	2019-07-11 15:49:46
363	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=61848	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-61848	21	2019-07-12 14:49:54
364	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62085	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62085	42	2019-07-12 14:54:29
366	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=61411	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-61411	40	2019-07-11 16:41:25
362	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62086	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62086	48	2019-07-12 15:07:03
361	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=62087	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-62087	10	2019-07-12 15:13:39
365	244	https://planning.lacity.org/InternetCalendar/pdf.aspx?Id=61541	/var/www/sites/nima/nerd/data/244/training/https-planning-lacity-org-internetcalendar-pdf-aspx-id-61541	17	2019-07-11 16:49:29
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, username, email, password, last_name, first_name, permissions, last_login, created_at, updated_at) FROM stdin;
106	test1	testing@here.com	$2y$10$oHfffdy3in4GC4vTbLWt8uZfaGoNew.yF7VGWrG4nE/FErWStBAGW			{"user.delete":1}	2019-07-17 11:48:20	2019-05-01 11:24:05	2019-07-17 11:48:20
\.


--
-- Name: activations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activations_id_seq', 6, true);


--
-- Name: commands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commands_id_seq', 66, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 33713, true);


--
-- Name: documents_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_meta_id_seq', 11377, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 244, true);


--
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.links_id_seq', 369, true);


--
-- Name: persistences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persistences_id_seq', 184, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: targets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.targets_id_seq', 117, true);


--
-- Name: throttle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.throttle_id_seq', 111, true);


--
-- Name: tmp_242_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tmp_242_item_id_seq', 815, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 106, true);


--
-- Name: activations activations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT activations_pkey PRIMARY KEY (id);


--
-- Name: commands commands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commands
    ADD CONSTRAINT commands_pkey PRIMARY KEY (id);


--
-- Name: documents_meta documents_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents_meta
    ADD CONSTRAINT documents_meta_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: training links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.training
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: persistences persistences_code_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persistences
    ADD CONSTRAINT persistences_code_unique UNIQUE (code);


--
-- Name: persistences persistences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persistences
    ADD CONSTRAINT persistences_pkey PRIMARY KEY (id);


--
-- Name: role_users role_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_users
    ADD CONSTRAINT role_users_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles roles_slug_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_slug_unique UNIQUE (slug);


--
-- Name: annotations targets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.annotations
    ADD CONSTRAINT targets_pkey PRIMARY KEY (id);


--
-- Name: throttle throttle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.throttle
    ADD CONSTRAINT throttle_pkey PRIMARY KEY (id);


--
-- Name: tmp_242 tmp_242_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tmp_242
    ADD CONSTRAINT tmp_242_pkey PRIMARY KEY (item_id);


--
-- Name: user user_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_unique UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_unique UNIQUE (username);


--
-- Name: activations activations_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT activations_user_id_foreign FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: commands commands_job_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commands
    ADD CONSTRAINT commands_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: documents documents_job_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: documents_meta documents_meta_document_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents_meta
    ADD CONSTRAINT documents_meta_document_id_foreign FOREIGN KEY (document_id) REFERENCES public.documents(id) ON DELETE CASCADE;


--
-- Name: training links_job_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.training
    ADD CONSTRAINT links_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE CASCADE;


--
-- Name: persistences persistences_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persistences
    ADD CONSTRAINT persistences_user_id_foreign FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: role_users role_users_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_users
    ADD CONSTRAINT role_users_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: role_users role_users_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_users
    ADD CONSTRAINT role_users_user_id_foreign FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: throttle throttle_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.throttle
    ADD CONSTRAINT throttle_user_id_foreign FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

