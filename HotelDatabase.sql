--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2025-03-01 10:03:15

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
-- TOC entry 220 (class 1255 OID 25729)
-- Name: insert_menu(character varying, integer, character varying, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_menu(IN pname character varying, IN cid integer, IN description character varying DEFAULT 'No description'::character varying, IN avl boolean DEFAULT true)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF cid = 1 THEN
        description := 'Veg: ' || description;
    ELSIF cid = 2 THEN
        description := 'Non-Veg: ' || description;
    ELSE
        RAISE EXCEPTION 'Invalid category ID. Must be 1 (Veg) or 2 (Non-Veg)';
    END IF;

    INSERT INTO menu (pname, cid, description, avl)
    VALUES (pname, cid, description, avl);
END;
$$;


ALTER PROCEDURE public.insert_menu(IN pname character varying, IN cid integer, IN description character varying, IN avl boolean) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 25782)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    cid integer NOT NULL,
    cname character varying(10),
    CONSTRAINT category_cname_check CHECK (((cname)::text = ANY ((ARRAY['Veg'::character varying, 'Non_veg'::character varying])::text[])))
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25789)
-- Name: menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu (
    mid integer NOT NULL,
    pname character varying(50) NOT NULL,
    cid integer,
    description character varying(100),
    avl boolean DEFAULT true,
    img character varying(100)
);


ALTER TABLE public.menu OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25788)
-- Name: menu_pid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menu_pid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_pid_seq OWNER TO postgres;

--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 216
-- Name: menu_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menu_pid_seq OWNED BY public.menu.mid;


--
-- TOC entry 219 (class 1259 OID 25817)
-- Name: size_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.size_price (
    sid integer NOT NULL,
    mid integer,
    size character varying(5) NOT NULL,
    price numeric(10,2) NOT NULL,
    quantity character varying(100) NOT NULL,
    CONSTRAINT size_price_size_check CHECK (((size)::text = ANY ((ARRAY['Full'::character varying, 'Half'::character varying])::text[])))
);


ALTER TABLE public.size_price OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25816)
-- Name: size_price_sid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.size_price_sid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.size_price_sid_seq OWNER TO postgres;

--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 218
-- Name: size_price_sid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.size_price_sid_seq OWNED BY public.size_price.sid;


--
-- TOC entry 4698 (class 2604 OID 25792)
-- Name: menu mid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu ALTER COLUMN mid SET DEFAULT nextval('public.menu_pid_seq'::regclass);


--
-- TOC entry 4700 (class 2604 OID 25820)
-- Name: size_price sid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_price ALTER COLUMN sid SET DEFAULT nextval('public.size_price_sid_seq'::regclass);


--
-- TOC entry 4704 (class 2606 OID 25787)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (cid);


--
-- TOC entry 4706 (class 2606 OID 25795)
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (mid);


--
-- TOC entry 4708 (class 2606 OID 25797)
-- Name: menu menu_pname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_pname_key UNIQUE (pname);


--
-- TOC entry 4710 (class 2606 OID 25823)
-- Name: size_price size_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_price
    ADD CONSTRAINT size_price_pkey PRIMARY KEY (sid);


--
-- TOC entry 4711 (class 2606 OID 25798)
-- Name: menu menu_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_cid_fkey FOREIGN KEY (cid) REFERENCES public.category(cid);


--
-- TOC entry 4712 (class 2606 OID 25824)
-- Name: size_price size_price_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_price
    ADD CONSTRAINT size_price_pid_fkey FOREIGN KEY (mid) REFERENCES public.menu(mid);


-- Completed on 2025-03-01 10:03:15

--
-- PostgreSQL database dump complete
--

