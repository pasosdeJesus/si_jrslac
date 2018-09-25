class DatosSivel2Sjr < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL

INSERT INTO sivel2_gen_tviolencia (id, nombre, nomcorto, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES ('R', 'DERECHO INTERNACIONAL REFUGIO', 'REF', '2014-06-19', NULL, '2014-06-19 13:20:35.26809', '2014-06-19 13:20:35.26809');
INSERT INTO sivel2_gen_tviolencia (id, nombre, nomcorto, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES ('S', 'SJR', 'SJR', '2013-06-25', NULL, NULL, NULL);

INSERT INTO sivel2_gen_supracategoria (codigo, id, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at) VALUES (100,100, 'SJR', '2013-06-25', NULL, 'S', NULL, NULL);
INSERT INTO sivel2_gen_supracategoria (codigo, id, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at) VALUES (200, 200, 'CONVENCIÓN 1951', '2014-06-19', NULL, 'R', '2014-06-19 13:21:34.529277', '2014-06-19 13:21:34.529277');
INSERT INTO sivel2_gen_supracategoria (codigo, id, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at) VALUES (201, 201, 'DECLARACIÓN DE CARTAGENA', '2014-06-19', NULL, 'R', '2014-06-19 13:22:02.263703', '2014-06-19 13:22:02.263703');
INSERT INTO sivel2_gen_supracategoria (codigo, id, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at) VALUES (202, 202, 'PACTO DE SAN JOSÉ', '2014-06-19', NULL, 'R', '2014-06-19 13:22:21.815264', '2014-06-19 13:22:21.815264');
INSERT INTO sivel2_gen_supracategoria (codigo, id, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at) VALUES (203, 203, 'ACNUR', '2014-06-19', NULL, 'R', '2014-06-19 13:22:39.94622', '2014-06-19 13:22:39.94622');

INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10002, 'AMENAZAS INDIRECTAS', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10003, 'AMETRALLAMIENTOS/BOMBARDEO', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10006, 'CAMPOS MINADOS/MUNICIONES SIN DETONAR', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10007, 'CONFRONTACIONES POR ACTORES ARMADOS', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10011, 'ERRADICACIÓN Y FUMIGACIONES', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10013, 'PRESENCIA GUERRILLERA', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10014, 'PARAMILITARIZACIÓN', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10015, 'MILITARIZACIÓN', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10017, 'MEGAPROYECTO DE MINERÍA', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10018, 'MEGAPROYECTO DE PALMA', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10019, 'MEGAPROYECTO DE PUERTOS', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10020, 'ORIENTACIÓN SEXUAL', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10021, 'RECLUTAMIENTO Y VINCULACIÓN DE NNAJ', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10022, 'POR PERTENECER A UN GRUPO SOCIAL', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10025, 'CONFINAMIENTO', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (10026, 'TEMOR FUNDADO', '2013-06-25', NULL, 100, NULL, NULL, 'I', NULL, NULL);

INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2000, 'RAZA', '2014-06-19', NULL, 200, NULL, NULL, 'I', '2014-06-19 13:24:33.302509', '2014-06-19 13:24:33.302509');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2001, 'RELIGIÓN', '2014-06-19', NULL, 200, NULL, NULL, 'I', '2014-06-19 13:25:07.240997', '2014-06-19 13:25:07.240997');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2002, 'NACIONALIDAD', '2014-06-19', NULL, 200, NULL, NULL, 'I', '2014-06-19 13:25:45.892889', '2014-06-19 13:25:45.892889');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2003, 'PERTENENCIA A GRUPO SOCIAL', '2014-06-19', NULL, 200, NULL, NULL, 'I', '2014-06-19 13:27:12.030191', '2014-06-19 13:27:12.030191');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2004, 'OPINIÓN POLÍTICA', '2014-06-19', NULL, 200, NULL, NULL, 'I', '2014-06-19 13:27:36.467502', '2014-06-19 13:27:36.467502');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2010, 'VIOLENCIA GENERALIZADA', '2014-06-19', NULL, 201, NULL, NULL, 'I', '2014-06-19 13:28:32.228075', '2014-06-19 13:28:32.228075');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2011, 'DESASTRES NATURALES', '2014-06-19', NULL, 201, NULL, NULL, 'I', '2014-06-19 13:29:04.757464', '2014-06-19 13:29:04.757464');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2012, 'AGRESIÓN EXTRANJERA', '2014-06-19', NULL, 201, NULL, NULL, 'I', '2014-06-19 13:29:43.926042', '2014-06-19 13:29:43.926042');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2013, 'CONFLICTOS INTERNOS', '2014-06-19', NULL, 201, NULL, NULL, 'I', '2014-06-19 13:30:15.105941', '2014-06-19 13:30:15.105941');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2014, 'VIOLACIÓN MASIVA DE DERECHOS HUMANOS', '2014-06-19', NULL, 201, NULL, NULL, 'I', '2014-06-19 13:30:42.503981', '2014-06-19 13:30:42.503981');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2015, 'CIRCUNSTANCIAS QUE HAYAN PERTURBADO GRAVEMENTE EL ORDEN PÚBLICO', '2014-06-19', NULL, 201, NULL, NULL, 'I', '2014-06-19 13:31:13.421844', '2014-06-19 13:31:13.421844');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2020, 'GENERO', '2014-06-19', NULL, 202, NULL, NULL, 'I', '2014-06-19 13:32:21.608943', '2014-06-19 13:33:36.90906');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2021, 'CAUSAS ECONÓMICAS', '2014-06-19', NULL, 202, NULL, NULL, 'I', '2014-06-19 13:32:52.432009', '2014-06-19 13:33:27.82717');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2022, 'GRUPOS ÉTNICOS', '2014-06-19', NULL, 202, NULL, NULL, 'I', '2014-06-19 13:33:15.710791', '2014-06-19 13:33:15.710791');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2030, 'PERSECUCIÓN', '2014-06-19', NULL, 203, NULL, NULL, 'I', '2014-06-19 13:34:24.889437', '2014-06-19 13:34:24.889437');
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, supracategoria_id, id_pconsolidado, contadaen, tipocat, created_at, updated_at) VALUES (2031, 'ORIENTACIÓN SEXUAL', '2014-06-19', NULL, 203, NULL, NULL, 'I', '2014-06-19 13:34:58.178604', '2014-06-19 13:34:58.178604');

INSERT INTO sip_etiqueta (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (11, 'COMPARTIR CON SJR COLOMBIA', '', '2001-01-01', NULL, NULL, NULL);
INSERT INTO sip_etiqueta (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (12, 'COMPARTIR CON SJR LATINOAMÉRICA', '', '2001-01-01', NULL, NULL, NULL);
INSERT INTO sip_etiqueta (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (13, 'COMPARTIR CON BANCO DE DATOS CINEP COLOMBIA', '', '2001-01-01', NULL, NULL, NULL);


--
-- Data for Name: sivel2_sjr_acreditacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_acreditacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_acreditacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'CARTA', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_acreditacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'DESPRENDIBLE', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_acreditacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'CÓDIGO', '2013-05-24', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_clasifdesp; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_clasifdesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_clasifdesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'INTER-MUNICIPAL', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_clasifdesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'INTRA-URBANO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_clasifdesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'INTER-VEREDAL', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_clasifdesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'URBANO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_clasifdesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'TRANSFRONTERIZO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_clasifdesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'INTERDEPARTAMENTAL', '2013-05-24', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_declaroante; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_declaroante (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_declaroante (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'PERSONERIA MUNICIPAL', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_declaroante (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'DEFENSORIA REGIONAL', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_declaroante (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'ROCURADURIA REGIONAL', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_declaroante (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'PROCURADURIA PROVINCIAL ', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_declaroante (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'OTRO', '2013-05-24', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_inclusion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_inclusion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_inclusion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'SIN RESPUESTA', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_inclusion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'INCLUIDO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_inclusion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'NO INCLUIDO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_inclusion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'EN VALORACIÓN', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_inclusion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'EXCLUIDO', '2013-05-24', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_modalidadtierra; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'TENEDOR', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'COLONO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'NO DEJÓ', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'POSEEDOR', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'PROPIETARIO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'RESGUARDO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_modalidadtierra (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'CONSEJO COMUNITARIO', '2013-05-24', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_tipodesp; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_tipodesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_tipodesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'GOTA A GOTA', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_tipodesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'MASIVO', '2013-05-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_tipodesp (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'FAMILIAR', '2013-05-24', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_personadesea; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_personadesea (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_personadesea (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'PERMANECER', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_personadesea (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'REUBICARSE', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_personadesea (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'RETORNAR', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_personadesea (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'SALIR DEL  PAÍS', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_personadesea (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'REGRESAR AL PAÌS', '2013-06-17', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_ayudaestado; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'ALIMENTACIÓN', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'ALOJAMIENTO', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'APOYO A PROYECTO PRODUCTIVO', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'ATENCIÓN PSICOLÓGICA O PSICOSOCIAL', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'DOCUMENTACIÓN', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'AYUDAS ECONÓMICAS', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'KIT HÁBITAT', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'SALUD', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudaestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'VESTUARIO', '2013-06-16', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_derecho; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'DERECHO A LA INTEGRIDAD PERSONAL', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'DERECHO A LA VERDAD, A A LA JUSTCIA Y A LA REPARACIÓN  ', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'DERECHO A LA ALIMENTACIÓN', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'DERECHO A LA IDENTIDAD', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'DERECHO AL TRABAJO', '2013-06-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'DERECHO A LA IGUALDAD Y A LA NO DISCRIMINACIÓN', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'DERECHO A LA LIBERTAD', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'DERECHO A LA LIBRE CIRCULACIÓN Y RESIDENCIA', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'DERECHO A LA LIBRE OPINIÓN Y A LA EXPRESIÓN', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'DERECHO A LA SALUD', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'DERECHO A LA EDUCACIÓN', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'DERECHO A LA VIVIENDA', '2013-06-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_derecho (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'N/A  ', '2013-06-12', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_progestado; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_progestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_progestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'EN ACCIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_progestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'RED JUNTOS', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_progestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'VIVIENDA', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_progestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'TERCERA EDAD', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_progestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'OTROS ¿CUÁL?', '2013-06-17', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_motivosjr; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'ASESORÍA PARA EL INGRESO EN PROGRAMAS DE EDUCACIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'ASESORÍA PARA EL INGRESO EN PROGRAMAS DE VIVIENDA', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'ASESORÍA PARA EL INGRESO AL SISTEMA DE LEY DE VÍCTIMAS', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'INFORMACIÓN SOBRE LEY DE VÍCTIMAS', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'ASESORÍA SOSBRE PROGRAMA DE GENERACIÓN DE INGRESOS', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'SOLICITUD DE PROTECCIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'ACOMPAÑAMIENTO PSICOSOCIAL / APOYO PSICOLÓGICO', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (18, 'APOYO Y/ O SOLICITUD DE INFORMACIÓN PARA REFUGIO', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'TRÁMITE DE DOCUMENTACIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (20, 'VERIFICACIÓN', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_motivosjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (21, 'ASESORÍA JURÍDICA', '2013-06-17', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_aslegal; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2014-02-14', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'RENUNCIA AL PROCEDIMIENTO DE SOLICITUD DE REFUGIO: TIPO Y MOTIVOS', '2014-02-14', NULL, NULL, '2014-08-04 14:29:09.190492', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'ASESORÍA SOBRE TRÁMITES DE NATURALIZACIÓN', '2014-02-14', NULL, NULL, '2014-08-04 14:27:04.064535', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'APERTURA EXPEDIENTE SOLICITUD DE REFUGIO', '2014-02-14', NULL, NULL, '2014-08-04 14:26:02.056113', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'INFORMACIÓN DERECHOS, DEBERES Y CONDICIÓN PROCEDIMIENTO DE REFUGIO', '2014-02-14', NULL, NULL, '2014-08-04 14:28:13.313206', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'GESTIONES PARA TRÁMITES DE DOCUMENTACIÓN ANTE CNR Y SAIME', '2014-02-14', NULL, NULL, '2014-08-04 14:27:31.736931', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'PERMISO DE TRABAJO', '2014-02-14', NULL, NULL, '2014-08-04 14:28:40.275613', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'ACCIONES DE EXIGIBILIDAD DE DERECHOS ANTE CUALQUIER ORGANISMO', '2014-02-14', NULL, NULL, '2014-08-04 14:25:38.610317', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'TRATA Y TRÁFICO', '2014-02-14', NULL, NULL, '2014-08-04 14:29:54.891343', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'ASESORÍA DECISIÓN REFUGIO NEGATIVA', '2014-02-14', NULL, NULL, '2014-08-04 14:26:26.746522', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'CAMBIO DE DOMICILIO PERMANENTE', '2014-02-14', NULL, NULL, '2014-08-04 14:27:19.07573', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'NOTIFICACIONES DE TRASLADO TEMPORAL', '2014-02-14', NULL, NULL, '2014-08-04 14:28:24.132981', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'REMISIÓN DE CASOS', '2014-02-14', NULL, NULL, '2014-08-04 14:29:41.030037', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'ASESORÍA DECISIÓN REFUGIO POSITIVA', '2014-02-14', NULL, NULL, '2014-08-04 14:26:47.864887', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'REDACCIÓN RECURSO DE RECONSIDERACIÓN', '2014-02-14', NULL, NULL, '2014-08-04 14:29:27.012877', NULL);
INSERT INTO sivel2_sjr_aslegal (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'GESTIÓN DE OTROS TRÁMITES LEGALES VARIOS', '2014-02-14', NULL, NULL, '2014-08-04 14:28:00.09363', NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_ayudasjr; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-06-17', NULL, NULL, '2014-08-04 14:21:44.383232', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'PAGO DE HOSPEDAJE', '2013-06-17', NULL, NULL, '2014-08-04 14:21:44.383232', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'OTROS ¿CUÁL(ES)?', '2013-06-17', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (102, 'ENTREGA DE ÚTILES ESCOLARES', '2014-07-01', NULL, '2014-07-01 15:27:43.631626', '2014-08-04 14:19:42.62921', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (103, 'ENTREGA DE UNIFORMES ESCOLARES', '2014-07-01', NULL, '2014-07-01 15:27:59.911423', '2014-08-04 14:19:07.049705', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (104, 'PAGO INSCRIPCIÓN EN PLANTEL EDUCATIVO', '2014-07-01', NULL, '2014-07-01 15:28:42.197196', '2014-08-04 14:21:04.024083', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (105, 'PAGO APOSTILLADO DE NOTAS', '2014-07-01', NULL, '2014-07-01 15:28:55.999941', '2014-08-04 14:20:45.72678', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (106, 'ENTREGA DE MEDICINAS', '2014-07-01', NULL, '2014-07-01 15:29:08.956856', '2014-08-04 14:19:18.988686', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (107, 'EXÁMENES MÉDICOS', '2014-07-01', NULL, '2014-07-01 15:29:40.038096', '2014-08-04 14:20:03.712523', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (108, 'PAGO DE CONSULTAS MÉDICAS', '2014-07-01', NULL, '2014-07-01 15:29:51.357703', '2014-08-04 14:21:29.28461', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (109, 'PAGO DE CIRUGÍAS', '2014-07-01', NULL, '2014-07-01 15:30:07.515231', '2014-08-04 14:21:16.523225', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (110, 'TRASLADO POR SALUD', '2014-07-01', NULL, '2014-07-01 15:31:12.113929', '2014-08-04 14:23:42.559446', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (111, 'TRASLADO A LA CNR NACIONAL', '2014-07-01', NULL, '2014-07-01 15:33:37.101959', '2014-08-04 14:22:25.983894', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (112, 'TRASLADO POR CONDICIONES DE SEGURIDAD', '2014-07-01', NULL, '2014-07-01 15:35:01.239923', '2014-08-04 14:23:07.502688', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (113, 'TRASLADO POR REUBICACIÓN', '2014-07-01', NULL, '2014-07-01 15:35:24.569466', '2014-08-04 14:23:19.752371', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'TRASLADO A OTRA INSTANCIA PÚBLICA', '2013-06-17', NULL, NULL, '2014-08-04 14:22:53.842404', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'KIT DE HIGIENE', '2013-06-17', NULL, NULL, '2014-08-04 14:20:14.474407', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'KIT DE INSTALACIÓN DE HOGAR', '2013-06-17', NULL, NULL, '2014-08-04 14:20:30.727496', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'KIT DE ALIMENTACIÓN', '2013-06-17', NULL, NULL, '2014-08-04 14:23:58.632278', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'PAGO DE DOCUMENTOS (PASAPORTE Y OTROS)', '2013-06-17', NULL, NULL, '2014-08-04 14:22:01.510619', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'SERVICIO DE COMIDAS', '2013-06-17', NULL, NULL, '2014-08-04 14:22:12.664614', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'ENTREGA DE DINERO', '2013-06-17', NULL, NULL, '2014-08-04 14:19:29.612823', NULL);
INSERT INTO sivel2_sjr_ayudasjr (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'TRASLADO A LA CNR LOCAL', '2013-06-17', NULL, NULL, '2014-08-04 14:22:41.281503', NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_comosupo; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'SIN INFORMACIÓN', NULL, '2014-08-04', NULL, '2014-08-04 19:53:39.287255', '2014-08-04 19:53:39.287255');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (10, 'REDES COMUNITARIAS O VECINALES', NULL, '2014-08-04', NULL, '2014-08-04 19:58:00.813473', '2014-08-04 19:58:00.813473');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (11, 'RADIO', NULL, '2014-08-04', NULL, '2014-08-04 19:58:18.1238', '2014-08-04 19:58:18.1238');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (12, 'INSTITUCIONES EDUCATIVAS', NULL, '2014-08-04', NULL, '2014-08-04 19:58:46.06298', '2014-08-04 19:58:46.06298');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (13, 'REMISIÓN DE LA CNR', NULL, '2014-08-04', NULL, '2014-08-04 19:59:03.341518', '2014-08-04 19:59:03.341518');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (14, 'CONTACTO DIRECTO.', NULL, '2014-08-04', NULL, '2014-08-04 19:59:23.737069', '2014-08-04 19:59:23.737069');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'ONG', NULL, '2014-08-04', NULL, '2014-08-04 19:53:54.781026', '2014-08-04 19:54:13.259093');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (3, 'PAGINA DE INTERNET DEL SJR U OTRAS REDES SOCIALES', NULL, '2014-08-04', NULL, '2014-08-04 19:55:21.719879', '2014-08-04 19:55:21.719879');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (4, 'OTRAS AGENCIAS HUMANITARIAS', NULL, '2014-08-04', NULL, '2014-08-04 19:55:41.977827', '2014-08-04 19:55:41.977827');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (5, 'IGLESIA – AGENTE PARROQUIAL', NULL, '2014-08-04', NULL, '2014-08-04 19:56:02.298318', '2014-08-04 19:56:02.298318');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (6, 'OTROS SOLICITANTES O DESPLAZADOS', NULL, '2014-08-04', NULL, '2014-08-04 19:56:34.93592', '2014-08-04 19:56:34.93592');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (7, 'COMUNIDAD DE ACOGIDA', NULL, '2014-08-04', NULL, '2014-08-04 19:56:52.496091', '2014-08-04 19:56:52.496091');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (8, 'CONSEJO COMUNAL', NULL, '2014-08-04', NULL, '2014-08-04 19:57:11.1354', '2014-08-04 19:57:11.1354');
INSERT INTO sivel2_sjr_comosupo (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (9, 'FAMILIARES O AMIGOS', NULL, '2014-08-04', NULL, '2014-08-04 19:57:33.115672', '2014-08-04 19:57:33.115672');


--
-- Name: sivel2_sjr_comosupo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sivel2_sjr_comosupo_id_seq', 100, true);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_idioma; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'ESPAÑOL', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'OTRO', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'INGLÉS', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'FRANCÉS', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'ARABE', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'ALEMÁN', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'PORTUGUES', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'JAPONES', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'CHINO', '2014-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'AFRIKAN', '2014-02-18', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_proteccion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'SOLICITANTE DE REFUGIO', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'PROTECCIÓN TEMPORAL HUMANITARIA', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'TRATA Y TRÁFICO', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'NO RECONOCIDOS', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'NO ESPECÍFICA', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'PERSONA CON NECESIDAD DE PROTECCIÓN TEMPORAL', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'OTRO', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'PERSONA EN SITUACIÓN DE REFUGIO', '2014-03-10', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_rolfamilia; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-06-20', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'PADRE - MADRE', '2013-06-20', NULL, NULL, '2014-08-04 14:06:23.593142', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (101, 'PADRASTRO - MADRASTRA', '2014-07-01', NULL, '2014-07-01 16:17:33.798486', '2014-07-01 16:17:33.798486', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (102, 'YERNO - NUERA', '2014-07-26', NULL, '2014-07-27 00:50:19.492556', '2014-08-04 14:06:38.788713', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (103, 'CUÑADO(A)', '2014-07-26', NULL, '2014-07-27 00:50:31.271452', '2014-08-04 14:07:05.805427', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'HIJO(A)', '2013-06-20', NULL, NULL, '2014-08-04 14:07:14.804963', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'OTRO', '2013-06-20', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'ABUELO(A)', '2013-07-05', NULL, NULL, '2014-08-04 14:06:54.968667', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'TIO(A)', '2013-07-05', NULL, NULL, '2014-08-04 14:07:44.084696', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'SOBRINO(A)', '2014-03-07', NULL, NULL, '2014-08-04 14:07:34.806731', NULL);
INSERT INTO sivel2_sjr_rolfamilia (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'PRIMO(A)', '2014-03-07', NULL, NULL, '2014-08-04 14:07:26.504936', NULL);


--
-- PostgreSQL database dump complete
--

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
-- Data for Name: sivel2_sjr_statusmigratorio; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'MIGRANTE', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'REFUGIADO', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'APÁTRIDA', '2014-02-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'NACIONAL POR NACIMIENTO', '2014-03-10', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'NACIONAL POR NATURALIZACIÓN', '2014-03-10', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

    SQL
  end
end
