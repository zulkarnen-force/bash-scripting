--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2 (Debian 16.2-1.pgdg120+2)

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
-- Name: acara_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acara_sessions (
    id uuid NOT NULL,
    nama character varying(255) NOT NULL,
    tanggal date NOT NULL,
    waktu_mulai time(0) without time zone NOT NULL,
    waktu_selesai time(0) without time zone NOT NULL,
    acara_id uuid NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.acara_sessions OWNER TO postgres;

--
-- Name: acaras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acaras (
    id uuid NOT NULL,
    nama_acara character varying(255) NOT NULL,
    jenis_pengkaderan_id uuid NOT NULL,
    ruang_lingkup_id uuid NOT NULL,
    institution_id uuid NOT NULL,
    approver_id uuid NOT NULL,
    lokasi character varying(255) NOT NULL,
    lokasi_map_link character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'Menunggu Persetujuan'::character varying NOT NULL,
    batch integer NOT NULL,
    is_lms boolean DEFAULT false NOT NULL,
    is_rtl boolean DEFAULT false NOT NULL,
    is_syahadah boolean DEFAULT false NOT NULL,
    ketua_instruktur_id uuid NOT NULL,
    tanggal_mulai date NOT NULL,
    tanggal_selesai date NOT NULL,
    rtl_due_date date NOT NULL,
    rtl_due_time time(0) without time zone NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT acaras_status_check CHECK (((status)::text = ANY ((ARRAY['Menunggu Persetujuan'::character varying, 'Disetujui'::character varying, 'Tidak Disetujui'::character varying])::text[])))
);


ALTER TABLE public.acaras OWNER TO postgres;

--
-- Name: additional_user_datas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.additional_user_datas (
    id uuid NOT NULL,
    sso_id character varying(255) NOT NULL,
    jabatan_di_institusi character varying(255) NOT NULL,
    jabatan_di_muhammadiyah character varying(255) NOT NULL,
    jenis_kelamin_id uuid NOT NULL,
    umur character varying(255) NOT NULL,
    tempat_lahir character varying(255) NOT NULL,
    tanggal_lahir date NOT NULL,
    status_perkawinan_id uuid NOT NULL,
    pekerjaan_id uuid NOT NULL,
    alamat character varying(255) NOT NULL,
    no_hp character varying(255) NOT NULL,
    keahlian character varying(255) NOT NULL,
    kemampuan_alquran_id uuid NOT NULL,
    hafalanquran_id uuid NOT NULL,
    info_mu_id uuid NOT NULL,
    berlangganan_sm character varying(255) NOT NULL,
    aktif_mu character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.additional_user_datas OWNER TO postgres;

--
-- Name: approver_acaras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approver_acaras (
    id uuid NOT NULL,
    role_id uuid NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.approver_acaras OWNER TO postgres;

--
-- Name: category_institutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_institutions (
    id uuid NOT NULL,
    category character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.category_institutions OWNER TO postgres;

--
-- Name: category_soals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_soals (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.category_soals OWNER TO postgres;

--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: institutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.institutions (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    alias character varying(255) NOT NULL,
    level_id character varying(255) NOT NULL,
    category_id character varying(255) NOT NULL,
    type_id character varying(255),
    picture character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.institutions OWNER TO postgres;

--
-- Name: instruktur_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instruktur_sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    sesi_id uuid NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.instruktur_sessions OWNER TO postgres;

--
-- Name: jenis_kelamins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jenis_kelamins (
    id uuid NOT NULL,
    jenis_kelamin character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.jenis_kelamins OWNER TO postgres;

--
-- Name: jenis_pengkaderans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jenis_pengkaderans (
    id uuid NOT NULL,
    nama character varying(255) NOT NULL,
    alias character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.jenis_pengkaderans OWNER TO postgres;

--
-- Name: jumlah_hafalan_alqurans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jumlah_hafalan_alqurans (
    id uuid NOT NULL,
    hafalan_quran character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.jumlah_hafalan_alqurans OWNER TO postgres;

--
-- Name: kemampuan_membaca_alqurans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kemampuan_membaca_alqurans (
    id uuid NOT NULL,
    kemampuan_alquran character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.kemampuan_membaca_alqurans OWNER TO postgres;

--
-- Name: levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.levels (
    id uuid NOT NULL,
    level character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.levels OWNER TO postgres;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: pekerjaans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pekerjaans (
    id uuid NOT NULL,
    pekerjaan character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.pekerjaans OWNER TO postgres;

--
-- Name: pendidikan_bahasa_asings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pendidikan_bahasa_asings (
    id uuid NOT NULL,
    bahasa_asing character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.pendidikan_bahasa_asings OWNER TO postgres;

--
-- Name: pendidikan_terakhirs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pendidikan_terakhirs (
    id uuid NOT NULL,
    pendidikan_terakhir character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.pendidikan_terakhirs OWNER TO postgres;

--
-- Name: permission_lists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permission_lists (
    id uuid NOT NULL,
    permission_category character varying(255) NOT NULL,
    permission_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.permission_lists OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id uuid NOT NULL,
    role_id uuid NOT NULL,
    permission character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    parent integer,
    name character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_id_seq OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: ruang_lingkup_acaras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruang_lingkup_acaras (
    id uuid NOT NULL,
    nama character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.ruang_lingkup_acaras OWNER TO postgres;

--
-- Name: status_kawins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_kawins (
    id uuid NOT NULL,
    status_kawin character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.status_kawins OWNER TO postgres;

--
-- Name: sumber_info_tentang_muhammadiyahs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sumber_info_tentang_muhammadiyahs (
    id uuid NOT NULL,
    info_mu character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.sumber_info_tentang_muhammadiyahs OWNER TO postgres;

--
-- Name: type_institutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_institutions (
    id uuid NOT NULL,
    type character varying(255) NOT NULL,
    category_id uuid NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.type_institutions OWNER TO postgres;

--
-- Name: user_acaras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_acaras (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    acara_id uuid NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.user_acaras OWNER TO postgres;

--
-- Name: user_bahasas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_bahasas (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    bahasa_id uuid NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.user_bahasas OWNER TO postgres;

--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_groups (
    id uuid NOT NULL,
    sso_id character varying(255) NOT NULL,
    institution_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.user_groups OWNER TO postgres;

--
-- Name: user_institutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_institutions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    is_ortom character varying(255) NOT NULL,
    type_id character varying(255) NOT NULL,
    level_id character varying(255) NOT NULL,
    jabatan character varying(255),
    status character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.user_institutions OWNER TO postgres;

--
-- Name: user_pendidikans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_pendidikans (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    pendidikan_terakhir_id uuid NOT NULL,
    nama_sekolah character varying(255) NOT NULL,
    tahun_masuk character varying(255) NOT NULL,
    tahun_lulus character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.user_pendidikans OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid NOT NULL,
    role_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    sso boolean NOT NULL,
    sso_id character varying(255) NOT NULL,
    role uuid NOT NULL,
    institution uuid,
    name character varying(255) NOT NULL,
    nuk character varying(255),
    nbm character varying(255),
    profile_picture character varying(255),
    email character varying(255),
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Data for Name: acara_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acara_sessions (id, nama, tanggal, waktu_mulai, waktu_selesai, acara_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: acaras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acaras (id, nama_acara, jenis_pengkaderan_id, ruang_lingkup_id, institution_id, approver_id, lokasi, lokasi_map_link, status, batch, is_lms, is_rtl, is_syahadah, ketua_instruktur_id, tanggal_mulai, tanggal_selesai, rtl_due_date, rtl_due_time, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: additional_user_datas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.additional_user_datas (id, sso_id, jabatan_di_institusi, jabatan_di_muhammadiyah, jenis_kelamin_id, umur, tempat_lahir, tanggal_lahir, status_perkawinan_id, pekerjaan_id, alamat, no_hp, keahlian, kemampuan_alquran_id, hafalanquran_id, info_mu_id, berlangganan_sm, aktif_mu, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: approver_acaras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.approver_acaras (id, role_id, created_at, updated_at) FROM stdin;
65e7af93-5bc1-45f8-a861-cd16a8985c1d	df38eff3-1781-4569-8c20-d55d6ef4830c	2024-02-16 04:31:20	2024-02-16 04:31:20
e8987b9f-240e-4a95-9c6d-59543092a12d	1fe03117-8802-46b0-ad99-02ae32d11ddb	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: category_institutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_institutions (id, category, created_at, updated_at) FROM stdin;
90da4831-bede-4927-abef-81de2e9b6755	Pimpinan Persyarikatan	2024-02-16 04:31:20	2024-02-16 04:31:20
507de6de-c7cc-4ecb-aa61-f02af1640a18	Ortom	2024-02-16 04:31:20	2024-02-16 04:31:20
39bb0204-f722-45ba-8a4b-b6127081ce4d	AUM	2024-02-16 04:31:20	2024-02-16 04:31:20
ccf14d5f-e4bc-4b07-994a-cdb65ead3fa8	BUMM	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: category_soals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_soals (id, name, created_at, updated_at) FROM stdin;
53daf658-5423-4591-9656-433f827b14ee	Kemuhammadiyahan	2024-02-16 04:31:20	2024-02-16 04:31:20
d93b214a-35c9-4af7-bbcf-48a90b3b3016	Keorganisasian	2024-02-16 04:31:20	2024-02-16 04:31:20
03eb4a40-4cb2-4eb1-980c-9413a2771296	Pengkaderan	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: institutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.institutions (id, name, alias, level_id, category_id, type_id, picture, created_at, updated_at) FROM stdin;
997d978f-b0ac-4584-b869-fae0ae31059f	Ikatan Mahasiswa Muhammadiyah Universitas Ahmad Dahlan	IMM UAD	8582bd07-aad3-4c28-8888-91c2441120be	507de6de-c7cc-4ecb-aa61-f02af1640a18	2f1e929b-18d5-4714-844d-a344baaba8c2	\N	2024-02-16 04:31:20	2024-02-16 04:31:20
27a0ba12-b552-46e7-8111-2c94cd9e537e	Ikatan Mahasiswa Muhammadiyah Universitas Muhammadiyah Yogyakarta	IMM UMY	b944abf9-5b32-40f7-81d5-efd8e1a5d0b1	507de6de-c7cc-4ecb-aa61-f02af1640a18	2f1e929b-18d5-4714-844d-a344baaba8c2	\N	2024-02-16 04:31:20	2024-02-16 04:31:20
c457ec8e-371a-4723-a881-cd374ed49221	Ikatan Mahasiswa Muhammadiyah Universitas Muhammadiyah Surakarta	IMM UMS	971f962f-10ac-491c-9a58-d061e682cc26	507de6de-c7cc-4ecb-aa61-f02af1640a18	2f1e929b-18d5-4714-844d-a344baaba8c2	\N	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: instruktur_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instruktur_sessions (id, user_id, sesi_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: jenis_kelamins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jenis_kelamins (id, jenis_kelamin, created_at, updated_at) FROM stdin;
a02ff078-f9f0-4c6c-8a9b-973c00839d7a	Laki-laki	2024-02-16 04:31:20	2024-02-16 04:31:20
16530776-1cff-4404-9c13-06fcecef44b5	Perempuan	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: jenis_pengkaderans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jenis_pengkaderans (id, nama, alias, created_at, updated_at) FROM stdin;
f00458cb-5b9b-4c59-b1ba-7c8b18259296	Baitul Arqam Utama	BA	2024-02-16 04:31:20	2024-02-16 04:31:20
d391d049-ec85-4032-8a02-4c9dfb77bd95	Baitul Arqam Fungsional	BA	2024-02-16 04:31:20	2024-02-16 04:31:20
2a71586f-774d-4bb8-84aa-4b752694972a	Darul Arqam Utama	DA	2024-02-16 04:31:20	2024-02-16 04:31:20
12600eb1-a190-4219-b4c7-9b11d7fb3ddd	Darul Arqam Fungsional	DA	2024-02-16 04:31:20	2024-02-16 04:31:20
ca234084-1189-4c20-9ff3-0fff52b3d726	Pelatihan Instruktur	PI	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: jumlah_hafalan_alqurans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jumlah_hafalan_alqurans (id, hafalan_quran, created_at, updated_at) FROM stdin;
b8016d0e-08cc-4eab-a8e7-07f8e3f8f252	Kurang dari 18 surat dalam juz’amma	2024-02-16 04:31:20	2024-02-16 04:31:20
9095aa6e-5519-496a-8739-25c40d2a9c7f	Hafal lebih dari 18 surat dalam juz’amma	2024-02-16 04:31:20	2024-02-16 04:31:20
c2024810-b5d2-4683-a014-ac8333f144f5	Hafal semua surat dalam juz’amma, hafidh Al-Qur’an	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: kemampuan_membaca_alqurans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kemampuan_membaca_alqurans (id, kemampuan_alquran, created_at, updated_at) FROM stdin;
ae3e0d76-ea43-42a1-8baf-9eb5dcd48bef	Lancar	2024-02-16 04:31:20	2024-02-16 04:31:20
f6c40e1d-0081-4ee0-bbcf-f4e08d2fc2f2	Terbata-bata	2024-02-16 04:31:20	2024-02-16 04:31:20
4020d720-3209-4401-bd52-983841bfb488	Belum bisa	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.levels (id, level, created_at, updated_at) FROM stdin;
8582bd07-aad3-4c28-8888-91c2441120be	Pusat	2024-02-16 04:31:20	2024-02-16 04:31:20
b944abf9-5b32-40f7-81d5-efd8e1a5d0b1	Wilayah	2024-02-16 04:31:20	2024-02-16 04:31:20
971f962f-10ac-491c-9a58-d061e682cc26	Daerah	2024-02-16 04:31:20	2024-02-16 04:31:20
fbddb896-b6a9-407c-8252-c576660c884d	Cabang	2024-02-16 04:31:20	2024-02-16 04:31:20
eeeb338c-b610-4e3f-8652-a79d6836abfc	Ranting	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	2014_10_12_000000_create_users_table	1
2	2014_10_12_100000_create_password_reset_tokens_table	1
3	2019_08_19_000000_create_failed_jobs_table	1
4	2019_12_14_000001_create_personal_access_tokens_table	1
5	2023_12_05_023409_create_user_groups_table	1
6	2024_01_10_013827_create_user_roles_table	1
7	2024_01_10_020409_create_permissions_table	1
8	2024_01_10_072420_create_permission_lists_table	1
9	2024_01_15_024542_create_pekerjaans_table	1
10	2024_01_15_024605_create_status_kawins_table	1
11	2024_01_15_024624_create_jenis_kelamins_table	1
12	2024_01_15_024656_create_pendidikan_terakhirs_table	1
13	2024_01_15_024712_create_pendidikan_bahasa_asings_table	1
14	2024_01_15_024817_create_kemampuan_membaca_alqurans_table	1
15	2024_01_15_024842_create_jumlah_hafalan_alqurans_table	1
16	2024_01_15_024900_create_sumber_info_tentang_muhammadiyahs_table	1
17	2024_01_15_024922_create_institutions_table	1
18	2024_01_15_031206_create_user_institutions_table	1
19	2024_01_15_031214_create_user_bahasas_table	1
20	2024_01_16_042044_create_regions_table	1
21	2024_01_16_055828_create_levels_table	1
22	2024_01_16_055846_create_category_institutions_table	1
23	2024_01_16_055857_create_type_institutions_table	1
24	2024_01_16_084327_additional_user_data	1
25	2024_01_18_024623_create_jenis_pengkaderans_table	1
26	2024_01_18_024627_create_ruang_lingkup_acaras_table	1
27	2024_01_19_023304_create_user_pendidikans_table	1
28	2024_01_22_014106_create_approver_acaras_table	1
29	2024_01_22_015528_create_acaras_table	1
30	2024_01_22_044044_create_acara_sessions_table	1
31	2024_01_22_044052_create_user_acaras_table	1
32	2024_01_22_065551_create_instruktur_sessions_table	1
33	2024_01_23_045404_create_category_soals_table	1
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: pekerjaans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pekerjaans (id, pekerjaan, created_at, updated_at) FROM stdin;
396fad89-f503-4b8c-ac1b-f1c2c54e0ffd	Guru	2024-02-16 04:31:20	2024-02-16 04:31:20
d71b535f-f81a-475e-a253-b8ed1758664c	Dosen	2024-02-16 04:31:20	2024-02-16 04:31:20
a5b8a143-a87f-4181-ab9c-fd5cd668ac0f	Karyawan Swasta	2024-02-16 04:31:20	2024-02-16 04:31:20
42c3e144-5262-435b-9781-5c9ae7f16313	Wirausaha	2024-02-16 04:31:20	2024-02-16 04:31:20
2e491706-b06c-402d-945e-e7285ab26df7	Petani	2024-02-16 04:31:20	2024-02-16 04:31:20
90e04d3b-4479-4664-815f-70d44ad7a446	Pedagang	2024-02-16 04:31:20	2024-02-16 04:31:20
143f05f9-d35f-4b44-bee4-7a2bb5140cae	ASN	2024-02-16 04:31:20	2024-02-16 04:31:20
8c5c524c-8bd3-4a9d-93b5-cc63e6353529	Pensiunan	2024-02-16 04:31:20	2024-02-16 04:31:20
884f1832-1a84-450c-a0f9-47565c6314dc	Lainya	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: pendidikan_bahasa_asings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pendidikan_bahasa_asings (id, bahasa_asing, created_at, updated_at) FROM stdin;
b3c930a2-2b58-41fa-be90-6ef3427d8796	Inggris	2024-02-16 04:31:20	2024-02-16 04:31:20
bb1b17aa-1052-4435-98ec-3d25463e8e27	Arab	2024-02-16 04:31:20	2024-02-16 04:31:20
a504cde9-8afa-44f8-a37f-6aba28e3a329	China	2024-02-16 04:31:20	2024-02-16 04:31:20
47dffd10-1245-4b2b-b1de-37f632090415	Jepang	2024-02-16 04:31:20	2024-02-16 04:31:20
4ee9843a-1d18-448d-844e-9e4da2b207a2	Jerman	2024-02-16 04:31:20	2024-02-16 04:31:20
3fbb2d94-d6cb-4cb8-a101-91e6b3205902	Prancis	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: pendidikan_terakhirs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pendidikan_terakhirs (id, pendidikan_terakhir, key, created_at, updated_at) FROM stdin;
cddf44d2-6e7a-4cd9-bdf2-ad08cfb5ff3d	SD	1	2024-02-16 04:31:20	2024-02-16 04:31:20
eeef152f-6e3b-425c-a08c-47fe638e0cf9	SMP	2	2024-02-16 04:31:20	2024-02-16 04:31:20
7a2ee903-5cde-4af1-85e3-b15f1505bb4a	SMA	3	2024-02-16 04:31:20	2024-02-16 04:31:20
7e2526de-c44c-414a-a415-e32e1ef9193e	Diploma	4	2024-02-16 04:31:20	2024-02-16 04:31:20
d0608cc2-409a-4f10-9355-3ad06a050bdf	S1	5	2024-02-16 04:31:20	2024-02-16 04:31:20
d8ba3777-8881-4a38-953c-60b0b9cedcc0	S2	6	2024-02-16 04:31:20	2024-02-16 04:31:20
deaa4259-2408-45dc-90ad-ee09dbc602b6	S3	7	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: permission_lists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permission_lists (id, permission_category, permission_name, created_at, updated_at) FROM stdin;
8b537479-11d6-435a-8602-6d8d1ef45e89	setting	read	2024-02-16 04:31:20	2024-02-16 04:31:20
f7a0e996-e450-40cb-8e0b-ecec0a8a97a2	setting	write	2024-02-16 04:31:20	2024-02-16 04:31:20
12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	user	read	2024-02-16 04:31:20	2024-02-16 04:31:20
248fb29d-1341-4f48-8391-92b4c4a4eaf1	user	write	2024-02-16 04:31:20	2024-02-16 04:31:20
1369b8b1-bddb-4bf8-bac4-0a038b8050a8	soal	read	2024-02-16 04:31:20	2024-02-16 04:31:20
2395cc1d-a1b9-4d7e-bc59-e42d496a7881	soal	write	2024-02-16 04:31:20	2024-02-16 04:31:20
86521da1-8dc8-428b-b63f-3587fccc2d7e	acara	read	2024-02-16 04:31:20	2024-02-16 04:31:20
456be136-bc95-4630-ba83-9742fc0d7903	acara	write	2024-02-16 04:31:20	2024-02-16 04:31:20
f61cacfd-e2c7-4ec0-be72-9068212a261c	approver	read	2024-02-16 04:31:20	2024-02-16 04:31:20
57acd441-d18e-4440-9578-a2b08bd6039f	approver	write	2024-02-16 04:31:20	2024-02-16 04:31:20
754a0c64-1a0c-4643-a1a8-76393b243a66	list_user	read	2024-02-16 04:31:20	2024-02-16 04:31:20
22fde108-597e-422e-a303-2ddf08ca0088	list_kader	read	2024-02-16 04:31:20	2024-02-16 04:31:20
25a3c2f5-1f86-4ec6-9bc2-e3d06dcf8e7e	list_instruktur	read	2024-02-16 04:31:20	2024-02-16 04:31:20
9401ae02-4fb7-495e-99e4-a9ced8601698	detail_user	read	2024-02-16 04:31:20	2024-02-16 04:31:20
9d501f84-6994-47ac-a8ad-c043729ee4a6	detail_user	write	2024-02-16 04:31:20	2024-02-16 04:31:20
434fce82-b2f9-4519-8576-9754657ca5ff	master_institution_level	read	2024-02-16 04:31:20	2024-02-16 04:31:20
d81b546c-eef1-4a8a-ab67-ad91e68a2b80	master_institution_level	write	2024-02-16 04:31:20	2024-02-16 04:31:20
63189e76-76ec-4497-a5f1-1821c35ad9a7	master_institution_category	read	2024-02-16 04:31:20	2024-02-16 04:31:20
b0676333-6741-4a86-aeba-4d0b17c7ed5e	master_institution_category	write	2024-02-16 04:31:20	2024-02-16 04:31:20
8e555d28-5961-4cdf-8bf7-7ea2b76d2cc6	master_institution_type	read	2024-02-16 04:31:20	2024-02-16 04:31:20
02b72465-7f76-4d04-a125-b0820cea9c01	master_institution_type	write	2024-02-16 04:31:20	2024-02-16 04:31:20
8f9654f7-13e8-4142-9870-9388c240f9e3	master_institution	read	2024-02-16 04:31:20	2024-02-16 04:31:20
06134583-f9d3-4b32-8d12-91d1ed5b8ff0	master_institution	write	2024-02-16 04:31:20	2024-02-16 04:31:20
4f9e75ed-424e-4e6d-ba1f-70933b542e2e	master_jenis_pengkaderan	read	2024-02-16 04:31:20	2024-02-16 04:31:20
31f27525-bc9e-43f7-a399-9ddce652a900	master_jenis_pengkaderan	write	2024-02-16 04:31:20	2024-02-16 04:31:20
b4da9b0d-4098-41f7-9a67-3b6d8d916bd6	master_ruang_lingkup_acara	read	2024-02-16 04:31:20	2024-02-16 04:31:20
9ff8fba1-2170-4d49-8d67-f92514962f1b	master_ruang_lingkup_acara	write	2024-02-16 04:31:20	2024-02-16 04:31:20
877ea6c0-f077-4a13-80b8-401311fcf3f9	master_jenis_kelamin	read	2024-02-16 04:31:20	2024-02-16 04:31:20
a0b5c78a-da8d-474f-b353-8a1f2a3ae019	master_jenis_kelamin	write	2024-02-16 04:31:20	2024-02-16 04:31:20
2f992e6a-f7b4-4084-8710-3466879bf38b	master_jumlah_hafalan_alquran	read	2024-02-16 04:31:20	2024-02-16 04:31:20
18a9fd96-5f12-4e47-8e3b-f0919027f27e	master_jumlah_hafalan_alquran	write	2024-02-16 04:31:20	2024-02-16 04:31:20
3ed51c2d-8358-4ae0-92fd-1da2aa79956d	master_kemampuan_baca_alquran	read	2024-02-16 04:31:20	2024-02-16 04:31:20
a39ce889-a8fa-4f57-a81c-518a1e3a517c	master_kemampuan_baca_alquran	write	2024-02-16 04:31:20	2024-02-16 04:31:20
cdcedf8f-77a8-4e11-ac66-843396533c20	master_pekerjaan	read	2024-02-16 04:31:20	2024-02-16 04:31:20
c5847edd-2af7-45d9-961c-b6646d714af0	master_pekerjaan	write	2024-02-16 04:31:20	2024-02-16 04:31:20
6dae5032-9169-4f22-860d-a024d230f1f0	master_pendidikan_bahasa_asing	read	2024-02-16 04:31:20	2024-02-16 04:31:20
4d37c350-aa5d-4228-b75f-680991eadff2	master_pendidikan_bahasa_asing	write	2024-02-16 04:31:20	2024-02-16 04:31:20
a506e02a-cf4c-479b-8c6c-1c2328b10526	master_status_kawin	read	2024-02-16 04:31:20	2024-02-16 04:31:20
0d2bc18c-6ddf-41ca-afa6-bf623d579ab8	master_status_kawin	write	2024-02-16 04:31:20	2024-02-16 04:31:20
a6c848ce-5a85-4291-945d-eedcb7b44f7b	master_sumber_info_tentang_muhammadiyah	read	2024-02-16 04:31:20	2024-02-16 04:31:20
b6e0e100-89fe-4e83-841b-c22dc4a6ed84	master_sumber_info_tentang_muhammadiyah	write	2024-02-16 04:31:20	2024-02-16 04:31:20
3414a5d8-13f0-44d4-a735-1a8e8013bb73	master_pendidikan_terakhir	read	2024-02-16 04:31:20	2024-02-16 04:31:20
4f7676b8-b72c-4981-bc0c-71ddf078a2e2	master_pendidikan_terakhir	write	2024-02-16 04:31:20	2024-02-16 04:31:20
9879858f-9cb5-4930-87e9-518cb4a321ff	master_kategori_soal	read	2024-02-16 04:31:20	2024-02-16 04:31:20
03507578-05fa-4c26-a24e-283df4ac955a	master_kategori_soal	write	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, role_id, permission, created_at, updated_at) FROM stdin;
234aea23-5afe-45a0-ae57-1123b95dab1d	ce859749-942f-450f-926c-ee944c3f04c0	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
7703ce73-b9e0-4eb2-802e-50e89954db41	e87e69c4-356b-4379-936a-dbdab0f19964	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
883ca75b-6dbe-4bee-bbc4-cab5bc973aa6	baa07792-307b-45c3-a9a6-1e6638233bec	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
f395c5d8-c762-4e78-91e0-7fd66ac15b6e	db7745d5-3bf2-4ab5-8761-f76e582f380b	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
a142a0ce-698b-43b4-85e5-40522823a29e	6ad3260c-498e-4ae1-a577-988ad701ffa1	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
3857b1a1-e6ae-415b-9446-94f58ea92d8f	df38eff3-1781-4569-8c20-d55d6ef4830c	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
01d75d66-d104-4758-91e7-19667e8b3763	1fe03117-8802-46b0-ad99-02ae32d11ddb	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
8c399b53-fdd9-49b4-9701-009b1446f82d	ce859749-942f-450f-926c-ee944c3f04c0	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
65ed8d08-f466-4916-b13b-a9f34a764820	e87e69c4-356b-4379-936a-dbdab0f19964	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
c53b9f85-88c7-4b08-b159-f2c2efea43a7	baa07792-307b-45c3-a9a6-1e6638233bec	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
e6605b30-f051-4bd8-99e7-38ea909d52fc	db7745d5-3bf2-4ab5-8761-f76e582f380b	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
6b6f525c-2348-4200-b5e3-a8fbec143e5d	6ad3260c-498e-4ae1-a577-988ad701ffa1	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
022bc568-9916-429f-a4d4-7ed7d9f30581	df38eff3-1781-4569-8c20-d55d6ef4830c	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
0aeee3ac-a1a7-40e5-a7d6-ba81e0674f07	1fe03117-8802-46b0-ad99-02ae32d11ddb	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
325d5f2b-9053-4007-bde2-41a082be1416	ce859749-942f-450f-926c-ee944c3f04c0	8b537479-11d6-435a-8602-6d8d1ef45e89	2024-02-16 04:31:20	2024-02-16 04:31:20
9f3fe2be-f218-4a8e-8344-adc9b1e8ca8c	ce859749-942f-450f-926c-ee944c3f04c0	f7a0e996-e450-40cb-8e0b-ecec0a8a97a2	2024-02-16 04:31:20	2024-02-16 04:31:20
aab37ddf-194d-4581-ac95-9fa9181a2ae6	ce859749-942f-450f-926c-ee944c3f04c0	12afa8ee-0a63-4ca7-9eae-20f77e9e2da1	2024-02-16 04:31:20	2024-02-16 04:31:20
55b5ab43-617b-4932-8a92-4a6e0c25bcbb	ce859749-942f-450f-926c-ee944c3f04c0	248fb29d-1341-4f48-8391-92b4c4a4eaf1	2024-02-16 04:31:20	2024-02-16 04:31:20
17a8aebf-7ce6-42ee-a09f-a513729692fd	ce859749-942f-450f-926c-ee944c3f04c0	1369b8b1-bddb-4bf8-bac4-0a038b8050a8	2024-02-16 04:31:20	2024-02-16 04:31:20
82dc3792-a6ea-4242-9182-715947a6a2ac	ce859749-942f-450f-926c-ee944c3f04c0	2395cc1d-a1b9-4d7e-bc59-e42d496a7881	2024-02-16 04:31:20	2024-02-16 04:31:20
d568918b-2ae9-4e83-9735-f96054ff9950	ce859749-942f-450f-926c-ee944c3f04c0	86521da1-8dc8-428b-b63f-3587fccc2d7e	2024-02-16 04:31:20	2024-02-16 04:31:20
a041e1a6-1773-41e9-bb86-94fa3dad1c77	ce859749-942f-450f-926c-ee944c3f04c0	456be136-bc95-4630-ba83-9742fc0d7903	2024-02-16 04:31:20	2024-02-16 04:31:20
c292e014-430d-4893-90d9-727c4a86715e	ce859749-942f-450f-926c-ee944c3f04c0	f61cacfd-e2c7-4ec0-be72-9068212a261c	2024-02-16 04:31:20	2024-02-16 04:31:20
2eb05a65-3f5a-40ae-b3b1-ce2c62160c59	ce859749-942f-450f-926c-ee944c3f04c0	57acd441-d18e-4440-9578-a2b08bd6039f	2024-02-16 04:31:20	2024-02-16 04:31:20
f25bd05d-4ca6-4f5b-a9a0-e1bf513d6a3c	ce859749-942f-450f-926c-ee944c3f04c0	754a0c64-1a0c-4643-a1a8-76393b243a66	2024-02-16 04:31:20	2024-02-16 04:31:20
26944f6c-e1a7-4e15-ab82-2cab2d71402d	ce859749-942f-450f-926c-ee944c3f04c0	22fde108-597e-422e-a303-2ddf08ca0088	2024-02-16 04:31:20	2024-02-16 04:31:20
1602c12c-f61d-43ba-ad77-bcb5f46eb30f	ce859749-942f-450f-926c-ee944c3f04c0	25a3c2f5-1f86-4ec6-9bc2-e3d06dcf8e7e	2024-02-16 04:31:20	2024-02-16 04:31:20
a03bbe4f-3e8a-4748-9cef-58a67b2be3e7	ce859749-942f-450f-926c-ee944c3f04c0	9401ae02-4fb7-495e-99e4-a9ced8601698	2024-02-16 04:31:20	2024-02-16 04:31:20
cc22f1ae-4fe8-4eb5-9739-890176c5e1e8	ce859749-942f-450f-926c-ee944c3f04c0	9d501f84-6994-47ac-a8ad-c043729ee4a6	2024-02-16 04:31:20	2024-02-16 04:31:20
b65c06e8-c142-44a6-b803-5cd9fecc8d2b	ce859749-942f-450f-926c-ee944c3f04c0	434fce82-b2f9-4519-8576-9754657ca5ff	2024-02-16 04:31:20	2024-02-16 04:31:20
8939ee60-bb9c-4baf-b486-83552c29aa5c	ce859749-942f-450f-926c-ee944c3f04c0	d81b546c-eef1-4a8a-ab67-ad91e68a2b80	2024-02-16 04:31:20	2024-02-16 04:31:20
a4f61144-63d3-4b6e-9c74-bb9e36738922	ce859749-942f-450f-926c-ee944c3f04c0	63189e76-76ec-4497-a5f1-1821c35ad9a7	2024-02-16 04:31:20	2024-02-16 04:31:20
9d1dfbd9-57ce-4164-8f1a-63cc5a6b9a37	ce859749-942f-450f-926c-ee944c3f04c0	b0676333-6741-4a86-aeba-4d0b17c7ed5e	2024-02-16 04:31:20	2024-02-16 04:31:20
9034f531-7e2f-4fd8-9a38-124dbe5d80a6	ce859749-942f-450f-926c-ee944c3f04c0	8e555d28-5961-4cdf-8bf7-7ea2b76d2cc6	2024-02-16 04:31:20	2024-02-16 04:31:20
603838e8-f536-4507-80e5-55dfaf46294f	ce859749-942f-450f-926c-ee944c3f04c0	02b72465-7f76-4d04-a125-b0820cea9c01	2024-02-16 04:31:20	2024-02-16 04:31:20
479ece2d-4bd2-42bc-a70b-481d283597e6	ce859749-942f-450f-926c-ee944c3f04c0	8f9654f7-13e8-4142-9870-9388c240f9e3	2024-02-16 04:31:20	2024-02-16 04:31:20
2784e3d6-b6db-4ba5-85ba-c3d293a05dd5	ce859749-942f-450f-926c-ee944c3f04c0	06134583-f9d3-4b32-8d12-91d1ed5b8ff0	2024-02-16 04:31:20	2024-02-16 04:31:20
3cea8f73-d2f9-4da4-9f51-eeaf71696942	ce859749-942f-450f-926c-ee944c3f04c0	4f9e75ed-424e-4e6d-ba1f-70933b542e2e	2024-02-16 04:31:20	2024-02-16 04:31:20
d1fdff21-efe6-4a2f-bd81-d88b201edeeb	ce859749-942f-450f-926c-ee944c3f04c0	31f27525-bc9e-43f7-a399-9ddce652a900	2024-02-16 04:31:20	2024-02-16 04:31:20
d4e9c441-844e-4a58-b20f-b03326e6a42c	ce859749-942f-450f-926c-ee944c3f04c0	b4da9b0d-4098-41f7-9a67-3b6d8d916bd6	2024-02-16 04:31:20	2024-02-16 04:31:20
a02bbd98-7573-454a-a681-87782b701082	ce859749-942f-450f-926c-ee944c3f04c0	9ff8fba1-2170-4d49-8d67-f92514962f1b	2024-02-16 04:31:20	2024-02-16 04:31:20
8f1fb4a8-722e-4a2a-a11e-342d5b8ecfc0	ce859749-942f-450f-926c-ee944c3f04c0	877ea6c0-f077-4a13-80b8-401311fcf3f9	2024-02-16 04:31:20	2024-02-16 04:31:20
a9ea49b5-8132-41b9-9892-7d90c6d63f7c	ce859749-942f-450f-926c-ee944c3f04c0	a0b5c78a-da8d-474f-b353-8a1f2a3ae019	2024-02-16 04:31:20	2024-02-16 04:31:20
a15f6ae2-5d72-4e6f-90e4-d9fce2161da6	ce859749-942f-450f-926c-ee944c3f04c0	2f992e6a-f7b4-4084-8710-3466879bf38b	2024-02-16 04:31:20	2024-02-16 04:31:20
4430bc9c-1a76-4cf0-9145-02d4d1b8f1b0	ce859749-942f-450f-926c-ee944c3f04c0	18a9fd96-5f12-4e47-8e3b-f0919027f27e	2024-02-16 04:31:20	2024-02-16 04:31:20
20427e16-ebdd-45b5-ae49-7ba1fb68aecd	ce859749-942f-450f-926c-ee944c3f04c0	3ed51c2d-8358-4ae0-92fd-1da2aa79956d	2024-02-16 04:31:20	2024-02-16 04:31:20
1cfa78f3-77db-4bb2-aede-6b2809110144	ce859749-942f-450f-926c-ee944c3f04c0	a39ce889-a8fa-4f57-a81c-518a1e3a517c	2024-02-16 04:31:20	2024-02-16 04:31:20
df097549-d9f3-4767-a967-bcf887648946	ce859749-942f-450f-926c-ee944c3f04c0	cdcedf8f-77a8-4e11-ac66-843396533c20	2024-02-16 04:31:20	2024-02-16 04:31:20
354ce37c-48a1-422f-9602-984bb7d0e9f6	ce859749-942f-450f-926c-ee944c3f04c0	c5847edd-2af7-45d9-961c-b6646d714af0	2024-02-16 04:31:20	2024-02-16 04:31:20
0c05c795-9382-4b7a-8efc-f1e79f55fab9	ce859749-942f-450f-926c-ee944c3f04c0	6dae5032-9169-4f22-860d-a024d230f1f0	2024-02-16 04:31:20	2024-02-16 04:31:20
1183e8c1-24b7-4817-93db-ea678a5d068d	ce859749-942f-450f-926c-ee944c3f04c0	4d37c350-aa5d-4228-b75f-680991eadff2	2024-02-16 04:31:20	2024-02-16 04:31:20
bdf95f24-b809-41fe-a60d-3f06e780db10	ce859749-942f-450f-926c-ee944c3f04c0	a506e02a-cf4c-479b-8c6c-1c2328b10526	2024-02-16 04:31:20	2024-02-16 04:31:20
51ba9b57-4af0-4e7e-8530-e830bce86591	ce859749-942f-450f-926c-ee944c3f04c0	0d2bc18c-6ddf-41ca-afa6-bf623d579ab8	2024-02-16 04:31:20	2024-02-16 04:31:20
9c651555-fa34-48e4-984e-e537127056b0	ce859749-942f-450f-926c-ee944c3f04c0	a6c848ce-5a85-4291-945d-eedcb7b44f7b	2024-02-16 04:31:20	2024-02-16 04:31:20
8b1c32cc-2e99-45e3-9ca1-a145e5c6d64f	ce859749-942f-450f-926c-ee944c3f04c0	b6e0e100-89fe-4e83-841b-c22dc4a6ed84	2024-02-16 04:31:20	2024-02-16 04:31:20
882a639f-89d9-42a1-a4f5-caefde1f04c4	ce859749-942f-450f-926c-ee944c3f04c0	3414a5d8-13f0-44d4-a735-1a8e8013bb73	2024-02-16 04:31:20	2024-02-16 04:31:20
a391e48d-c8a5-47a4-b4e8-2189d45d3432	ce859749-942f-450f-926c-ee944c3f04c0	4f7676b8-b72c-4981-bc0c-71ddf078a2e2	2024-02-16 04:31:20	2024-02-16 04:31:20
ce5ceb42-3a00-4979-a73a-9cb5604e8c43	ce859749-942f-450f-926c-ee944c3f04c0	9879858f-9cb5-4930-87e9-518cb4a321ff	2024-02-16 04:31:20	2024-02-16 04:31:20
67cde625-e123-49f7-99e6-2434bdf2d138	ce859749-942f-450f-926c-ee944c3f04c0	03507578-05fa-4c26-a24e-283df4ac955a	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (id, parent, name, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ruang_lingkup_acaras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ruang_lingkup_acaras (id, nama, created_at, updated_at) FROM stdin;
08c01f3c-c47c-48b2-b078-fc4ed8872765	Dosen	2024-02-16 04:31:20	2024-02-16 04:31:20
ce1b83d1-2991-4491-abc6-a0dba0a9a84d	Karyawan	2024-02-16 04:31:20	2024-02-16 04:31:20
fbacb057-2859-405f-b0a3-d1aff5ef7388	Tendik	2024-02-16 04:31:20	2024-02-16 04:31:20
2ad36692-a224-4413-8cd7-41a768eb0348	Middle Manager	2024-02-16 04:31:20	2024-02-16 04:31:20
d9e31496-4d06-4c13-a9a9-0c45fa9f428b	Top Manager	2024-02-16 04:31:20	2024-02-16 04:31:20
5752d48e-bdf2-497b-ab4b-49c270ffa41f	Direksi	2024-02-16 04:31:20	2024-02-16 04:31:20
5a4bc6d7-6dcc-410a-ac4f-5c0d02f1b8a2	BPH	2024-02-16 04:31:20	2024-02-16 04:31:20
0dd2a53a-c0b3-4826-832d-1677a9352294	Guru	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: status_kawins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_kawins (id, status_kawin, created_at, updated_at) FROM stdin;
10cdc2ba-d3f8-4a70-a02f-ee11be6b77bf	Belum Menikah	2024-02-16 04:31:20	2024-02-16 04:31:20
2708c324-fbae-4604-aab7-c20ac3824c39	Menikah	2024-02-16 04:31:20	2024-02-16 04:31:20
60b3ef59-cfeb-40ef-870d-3c75047604e4	Cerai	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: sumber_info_tentang_muhammadiyahs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sumber_info_tentang_muhammadiyahs (id, info_mu, created_at, updated_at) FROM stdin;
e061c83f-3c36-47bd-bc08-c197b85c40a8	Majalah SM	2024-02-16 04:31:20	2024-02-16 04:31:20
ee4c4155-17c5-4407-b8c1-0b408b47cb78	Buku Terbitan Muhammadiyah	2024-02-16 04:31:20	2024-02-16 04:31:20
ccaf85d1-dcb4-47a2-8e25-0593c41008d4	Ceramah Tokoh Muhammadiyah	2024-02-16 04:31:20	2024-02-16 04:31:20
53a7c21f-e932-42ae-9033-9e0881af494b	Media Massa Nasional	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: type_institutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_institutions (id, type, category_id, created_at, updated_at) FROM stdin;
c88dd01d-d055-46cd-84c3-b58b5dc57a33	Aisyah	507de6de-c7cc-4ecb-aa61-f02af1640a18	2024-02-16 04:31:20	2024-02-16 04:31:20
10fea31c-c95b-4c6c-8ced-522f35f39ac9	Pemuda Muhammadiyah	507de6de-c7cc-4ecb-aa61-f02af1640a18	2024-02-16 04:31:20	2024-02-16 04:31:20
cdc47be3-dd56-4126-9bd2-c60f93505d1d	Nasyiyatul Aisyiyah	507de6de-c7cc-4ecb-aa61-f02af1640a18	2024-02-16 04:31:20	2024-02-16 04:31:20
7053f5b3-80b3-4f75-a8d8-00cd92e35ba0	Ikatan Pelajar Muhammadiyah	507de6de-c7cc-4ecb-aa61-f02af1640a18	2024-02-16 04:31:20	2024-02-16 04:31:20
2f1e929b-18d5-4714-844d-a344baaba8c2	Ikatan Mahasiswa Muhammadiyah	507de6de-c7cc-4ecb-aa61-f02af1640a18	2024-02-16 04:31:20	2024-02-16 04:31:20
6d2a0897-cc15-4122-84ab-5c82507ed818	Tapak Suci Putra Muhammadiyah	507de6de-c7cc-4ecb-aa61-f02af1640a18	2024-02-16 04:31:20	2024-02-16 04:31:20
0eeadf2a-0793-4cc0-8e90-4d39e11f1f20	Hizbul Wathan	507de6de-c7cc-4ecb-aa61-f02af1640a18	2024-02-16 04:31:20	2024-02-16 04:31:20
444d37e5-b043-4270-be4b-6cdf8d49d2d7	PTMA	39bb0204-f722-45ba-8a4b-b6127081ce4d	2024-02-16 04:31:20	2024-02-16 04:31:20
bdc4a555-cbe3-4ac9-a589-3d3eacb772c2	Kesehatan	39bb0204-f722-45ba-8a4b-b6127081ce4d	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: user_acaras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_acaras (id, user_id, acara_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_bahasas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_bahasas (id, user_id, bahasa_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_groups (id, sso_id, institution_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_institutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_institutions (id, user_id, is_ortom, type_id, level_id, jabatan, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_pendidikans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_pendidikans (id, user_id, pendidikan_terakhir_id, nama_sekolah, tahun_masuk, tahun_lulus, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, role_name, created_at, updated_at) FROM stdin;
ce859749-942f-450f-926c-ee944c3f04c0	admin	2024-02-16 04:31:20	2024-02-16 04:31:20
e87e69c4-356b-4379-936a-dbdab0f19964	user	2024-02-16 04:31:20	2024-02-16 04:31:20
baa07792-307b-45c3-a9a6-1e6638233bec	kader	2024-02-16 04:31:20	2024-02-16 04:31:20
db7745d5-3bf2-4ab5-8761-f76e582f380b	instruktur	2024-02-16 04:31:20	2024-02-16 04:31:20
6ad3260c-498e-4ae1-a577-988ad701ffa1	organizer	2024-02-16 04:31:20	2024-02-16 04:31:20
df38eff3-1781-4569-8c20-d55d6ef4830c	operator	2024-02-16 04:31:20	2024-02-16 04:31:20
1fe03117-8802-46b0-ad99-02ae32d11ddb	operator_wilayah	2024-02-16 04:31:20	2024-02-16 04:31:20
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, sso, sso_id, role, institution, name, nuk, nbm, profile_picture, email, remember_token, created_at, updated_at) FROM stdin;
\.


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 33, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_id_seq', 1, false);


--
-- Name: acara_sessions acara_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acara_sessions
    ADD CONSTRAINT acara_sessions_pkey PRIMARY KEY (id);


--
-- Name: acaras acaras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acaras
    ADD CONSTRAINT acaras_pkey PRIMARY KEY (id);


--
-- Name: additional_user_datas additional_user_datas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additional_user_datas
    ADD CONSTRAINT additional_user_datas_pkey PRIMARY KEY (id);


--
-- Name: additional_user_datas additional_user_datas_sso_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additional_user_datas
    ADD CONSTRAINT additional_user_datas_sso_id_unique UNIQUE (sso_id);


--
-- Name: approver_acaras approver_acaras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approver_acaras
    ADD CONSTRAINT approver_acaras_pkey PRIMARY KEY (id);


--
-- Name: category_institutions category_institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_institutions
    ADD CONSTRAINT category_institutions_pkey PRIMARY KEY (id);


--
-- Name: category_soals category_soals_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_soals
    ADD CONSTRAINT category_soals_name_unique UNIQUE (name);


--
-- Name: category_soals category_soals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_soals
    ADD CONSTRAINT category_soals_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: institutions institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_pkey PRIMARY KEY (id);


--
-- Name: instruktur_sessions instruktur_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instruktur_sessions
    ADD CONSTRAINT instruktur_sessions_pkey PRIMARY KEY (id);


--
-- Name: jenis_kelamins jenis_kelamins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jenis_kelamins
    ADD CONSTRAINT jenis_kelamins_pkey PRIMARY KEY (id);


--
-- Name: jenis_pengkaderans jenis_pengkaderans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jenis_pengkaderans
    ADD CONSTRAINT jenis_pengkaderans_pkey PRIMARY KEY (id);


--
-- Name: jumlah_hafalan_alqurans jumlah_hafalan_alqurans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jumlah_hafalan_alqurans
    ADD CONSTRAINT jumlah_hafalan_alqurans_pkey PRIMARY KEY (id);


--
-- Name: kemampuan_membaca_alqurans kemampuan_membaca_alqurans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kemampuan_membaca_alqurans
    ADD CONSTRAINT kemampuan_membaca_alqurans_pkey PRIMARY KEY (id);


--
-- Name: levels levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: pekerjaans pekerjaans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pekerjaans
    ADD CONSTRAINT pekerjaans_pkey PRIMARY KEY (id);


--
-- Name: pendidikan_bahasa_asings pendidikan_bahasa_asings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendidikan_bahasa_asings
    ADD CONSTRAINT pendidikan_bahasa_asings_pkey PRIMARY KEY (id);


--
-- Name: pendidikan_terakhirs pendidikan_terakhirs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendidikan_terakhirs
    ADD CONSTRAINT pendidikan_terakhirs_pkey PRIMARY KEY (id);


--
-- Name: permission_lists permission_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission_lists
    ADD CONSTRAINT permission_lists_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: ruang_lingkup_acaras ruang_lingkup_acaras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruang_lingkup_acaras
    ADD CONSTRAINT ruang_lingkup_acaras_pkey PRIMARY KEY (id);


--
-- Name: status_kawins status_kawins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_kawins
    ADD CONSTRAINT status_kawins_pkey PRIMARY KEY (id);


--
-- Name: sumber_info_tentang_muhammadiyahs sumber_info_tentang_muhammadiyahs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sumber_info_tentang_muhammadiyahs
    ADD CONSTRAINT sumber_info_tentang_muhammadiyahs_pkey PRIMARY KEY (id);


--
-- Name: type_institutions type_institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_institutions
    ADD CONSTRAINT type_institutions_pkey PRIMARY KEY (id);


--
-- Name: user_acaras user_acaras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_acaras
    ADD CONSTRAINT user_acaras_pkey PRIMARY KEY (id);


--
-- Name: user_bahasas user_bahasas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_bahasas
    ADD CONSTRAINT user_bahasas_pkey PRIMARY KEY (id);


--
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: user_groups user_groups_sso_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_sso_id_unique UNIQUE (sso_id);


--
-- Name: user_institutions user_institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_institutions
    ADD CONSTRAINT user_institutions_pkey PRIMARY KEY (id);


--
-- Name: user_pendidikans user_pendidikans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_pendidikans
    ADD CONSTRAINT user_pendidikans_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_role_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_name_unique UNIQUE (role_name);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_sso_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_sso_id_unique UNIQUE (sso_id);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- PostgreSQL database dump complete
--

