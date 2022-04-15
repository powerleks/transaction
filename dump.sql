--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)

-- Started on 2022-04-14 21:32:29 MSK

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

--DROP DATABASE transaction;
--
-- TOC entry 3005 (class 1262 OID 16384)
-- Name: transaction; Type: DATABASE; Schema: -; Owner: postgres
--

--CREATE DATABASE transaction WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


--ALTER DATABASE transaction OWNER TO postgres;

\connect transaction

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
-- TOC entry 8 (class 2615 OID 16385)
-- Name: main; Type: SCHEMA; Schema: -; Owner: postgres
--

--CREATE EXTENSION "uuid-ossp";

CREATE SCHEMA main;

CREATE EXTENSION "uuid-ossp"with schema main;

ALTER SCHEMA main OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 206 (class 1259 OID 16435)
-- Name: status; Type: TABLE; Schema: main; Owner: postgres
--

CREATE TABLE main.status (
    id smallint NOT NULL,
    value character varying(30) NOT NULL,
    description character varying(150)
);


ALTER TABLE main.status OWNER TO postgres;

--
-- TOC entry 3006 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE status; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON TABLE main.status IS 'Статусы транзакции';


--
-- TOC entry 3007 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN status.id; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.status.id IS 'Идентификатор';


--
-- TOC entry 3008 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN status.value; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.status.value IS 'Значение';


--
-- TOC entry 205 (class 1259 OID 16397)
-- Name: transaction; Type: TABLE; Schema: main; Owner: postgres
--

CREATE TABLE main.transaction (
    id uuid DEFAULT main.uuid_generate_v4() NOT NULL,
    amount double precision NOT NULL,
    create_time timestamp without time zone DEFAULT now() NOT NULL,
    source uuid NOT NULL,
    target uuid NOT NULL
);


ALTER TABLE main.transaction OWNER TO postgres;

--
-- TOC entry 3009 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE transaction; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON TABLE main.transaction IS 'Транзакции';


--
-- TOC entry 3010 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN transaction.id; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.transaction.id IS 'Идентификатор';


--
-- TOC entry 3011 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN transaction.amount; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.transaction.amount IS 'Сумма перевода';


--
-- TOC entry 3012 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN transaction.create_time; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.transaction.create_time IS 'Время создания';


--
-- TOC entry 3013 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN transaction.source; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.transaction.source IS 'Пользователь, который пересылает деньги';


--
-- TOC entry 3014 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN transaction.target; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.transaction.target IS 'Пользователь, которому пересылают деньги';


--
-- TOC entry 207 (class 1259 OID 16440)
-- Name: transaction_logs; Type: TABLE; Schema: main; Owner: postgres
--

CREATE TABLE main.transaction_logs (
    transaction_id uuid NOT NULL,
    status_id smallint NOT NULL,
    create_time timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE main.transaction_logs OWNER TO postgres;

--
-- TOC entry 3015 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE transaction_logs; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON TABLE main.transaction_logs IS 'Логи транзакций';


--
-- TOC entry 3016 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN transaction_logs.create_time; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.transaction_logs.create_time IS 'Время создания';


--
-- TOC entry 204 (class 1259 OID 16386)
-- Name: user_account; Type: TABLE; Schema: main; Owner: postgres
--

CREATE TABLE main.user_account (
    user_login character varying(100) NOT NULL,
    balance double precision NOT NULL,
    id uuid DEFAULT main.uuid_generate_v4() NOT NULL
);


ALTER TABLE main.user_account OWNER TO postgres;

--
-- TOC entry 3017 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE user_account; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON TABLE main.user_account IS 'Баланс пользователя';


--
-- TOC entry 3018 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN user_account.user_login; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.user_account.user_login IS 'Логин';


--
-- TOC entry 3019 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN user_account.balance; Type: COMMENT; Schema: main; Owner: postgres
--

COMMENT ON COLUMN main.user_account.balance IS 'Баланс';


--
-- TOC entry 2998 (class 0 OID 16435)
-- Dependencies: 206
-- Data for Name: status; Type: TABLE DATA; Schema: main; Owner: postgres
--

INSERT INTO main.status (id, value, description) VALUES (1, 'Pending', 'На рассмотрении');
INSERT INTO main.status (id, value, description) VALUES (2, 'Succes', 'Выполнена');
INSERT INTO main.status (id, value, description) VALUES (3, 'Declined', 'Отклонена');


INSERT INTO main.user_account (id, user_login, balance) VALUES ('c8370a18-e61b-4c3e-89b8-d9a85e09c101', 'test1', 10000);
INSERT INTO main.user_account (id, user_login, balance) VALUES ('09a52b59-cdb0-41df-b0a3-b75885214cbe', 'test2', 5000);
INSERT INTO main.user_account (id, user_login, balance) VALUES ('ce32e0e3-5cea-4427-b386-479394251ccb', 'test3', 2000);


--
-- TOC entry 2997 (class 0 OID 16397)
-- Dependencies: 205
-- Data for Name: transaction; Type: TABLE DATA; Schema: main; Owner: postgres
--



--
-- TOC entry 2999 (class 0 OID 16440)
-- Dependencies: 207
-- Data for Name: transaction_logs; Type: TABLE DATA; Schema: main; Owner: postgres
--



--
-- TOC entry 2996 (class 0 OID 16386)
-- Dependencies: 204
-- Data for Name: user_account; Type: TABLE DATA; Schema: main; Owner: postgres
--



--
-- TOC entry 2859 (class 2606 OID 16468)
-- Name: user_account id_pkey; Type: CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.user_account
    ADD CONSTRAINT id_pkey PRIMARY KEY (id);


--
-- TOC entry 2863 (class 2606 OID 16439)
-- Name: status status_pkey; Type: CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- TOC entry 2865 (class 2606 OID 16445)
-- Name: transaction_logs transaction_logs_pkey; Type: CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.transaction_logs
    ADD CONSTRAINT transaction_logs_pkey PRIMARY KEY (transaction_id, status_id);


--
-- TOC entry 2861 (class 2606 OID 16401)
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 2866 (class 2606 OID 16469)
-- Name: transaction source_fkey; Type: FK CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.transaction
    ADD CONSTRAINT source_fkey FOREIGN KEY (source) REFERENCES main.user_account(id) NOT VALID;


--
-- TOC entry 2869 (class 2606 OID 16451)
-- Name: transaction_logs status_fkey; Type: FK CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.transaction_logs
    ADD CONSTRAINT status_fkey FOREIGN KEY (status_id) REFERENCES main.status(id);


--
-- TOC entry 2867 (class 2606 OID 16474)
-- Name: transaction target_fkey; Type: FK CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.transaction
    ADD CONSTRAINT target_fkey FOREIGN KEY (target) REFERENCES main.user_account(id) NOT VALID;


--
-- TOC entry 2868 (class 2606 OID 16446)
-- Name: transaction_logs transaction_fkey; Type: FK CONSTRAINT; Schema: main; Owner: postgres
--

ALTER TABLE ONLY main.transaction_logs
    ADD CONSTRAINT transaction_fkey FOREIGN KEY (transaction_id) REFERENCES main.transaction(id);


-- Completed on 2022-04-14 21:32:29 MSK

--
-- PostgreSQL database dump complete
--

