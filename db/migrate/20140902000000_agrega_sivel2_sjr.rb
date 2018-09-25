# Migración para integrar sivel2_sjr 
class AgregaSivel2Sjr < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


SET default_tablespace = '';

SET default_with_oids = false;

--delete from public.schema_migrations where version < '20150413000000';


--
-- Name: anexo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.anexo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: sivel2_sjr_casosjr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_casosjr (
    id_caso integer NOT NULL,
    fecharec date NOT NULL,
    asesor integer NOT NULL,
    oficina_id integer DEFAULT 1,
    direccion character varying(1000),
    telefono character varying(1000),
    contacto integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    dependen integer,
    sustento character varying(1000),
    leerescribir boolean,
    trabaja boolean,
    ingresomensual integer,
    gastos integer,
    estrato character(1),
    id_statusmigratorio integer DEFAULT 0,
    id_proteccion integer DEFAULT 0,
    id_idioma integer DEFAULT 0,
    concentimientosjr boolean,
    concentimientobd boolean,
    fechasalida date,
    id_salida integer,
    fechallegada date,
    id_llegada integer,
    categoriaref integer,
    observacionesref character varying(5000),
    comosupo_id integer DEFAULT 1
);


--
-- Name: cben1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cben1 AS
 SELECT caso.id AS id_caso,
    victima.id_persona,
        CASE
            WHEN (casosjr.contacto = victima.id_persona) THEN 1
            ELSE 0
        END AS contacto,
        CASE
            WHEN (casosjr.contacto <> victima.id_persona) THEN 1
            ELSE 0
        END AS beneficiario,
    1 AS npersona,
    persona.anionac
   FROM public.sivel2_gen_caso caso,
    public.sivel2_sjr_casosjr casosjr,
    public.sivel2_gen_victima victima,
    public.sip_persona persona
  WHERE ((caso.id = victima.id_caso) AND (caso.id = casosjr.id_caso) AND (caso.id = victima.id_caso) AND (persona.id = victima.id_persona));


--
-- Name: desplazamiento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.desplazamiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: sivel2_sjr_desplazamiento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_desplazamiento (
    id_caso integer NOT NULL,
    fechaexpulsion date NOT NULL,
    id_expulsion integer NOT NULL,
    fechallegada date NOT NULL,
    id_llegada integer NOT NULL,
    id_clasifdesp integer DEFAULT 0 NOT NULL,
    id_tipodesp integer DEFAULT 0 NOT NULL,
    descripcion character varying(5000),
    otrosdatos character varying(1000),
    declaro character(1),
    hechosdeclarados character varying(5000),
    fechadeclaracion date,
    departamentodecl integer,
    municipiodecl integer,
    id_declaroante integer DEFAULT 0,
    id_inclusion integer DEFAULT 0,
    id_acreditacion integer DEFAULT 0,
    retornado boolean,
    reubicado boolean,
    connacionalretorno boolean,
    acompestado boolean,
    connacionaldeportado boolean,
    oficioantes character varying(5000),
    id_modalidadtierra integer DEFAULT 0,
    materialesperdidos character varying(5000),
    inmaterialesperdidos character varying(5000),
    protegiorupta boolean,
    documentostierra character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    paisdecl integer,
    id integer DEFAULT nextval('public.desplazamiento_seq'::regclass) NOT NULL,
    CONSTRAINT desplazamiento_declaro_check CHECK (((declaro = 'S'::bpchar) OR (declaro = 'N'::bpchar) OR (declaro = 'R'::bpchar)))
);


--
-- Name: ultimodesplazamiento; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.ultimodesplazamiento AS
 SELECT sivel2_sjr_desplazamiento.id,
    s.id_caso,
    s.fechaexpulsion,
    sivel2_sjr_desplazamiento.id_expulsion
   FROM public.sivel2_sjr_desplazamiento,
    ( SELECT sivel2_sjr_desplazamiento_1.id_caso,
            max(sivel2_sjr_desplazamiento_1.fechaexpulsion) AS fechaexpulsion
           FROM public.sivel2_sjr_desplazamiento sivel2_sjr_desplazamiento_1
          GROUP BY sivel2_sjr_desplazamiento_1.id_caso) s
  WHERE ((sivel2_sjr_desplazamiento.id_caso = s.id_caso) AND (sivel2_sjr_desplazamiento.fechaexpulsion = s.fechaexpulsion));


--
-- Name: cben2; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cben2 AS
 SELECT cben1.id_caso,
    cben1.id_persona,
    cben1.contacto,
    cben1.beneficiario,
    cben1.npersona,
    cben1.anionac,
    ubicacion.id_departamento,
    departamento.nombre AS departamento_nombre,
    ubicacion.id_municipio,
    municipio.nombre AS municipio_nombre,
    ubicacion.id_clase,
    clase.nombre AS clase_nombre,
    ultimodesplazamiento.fechaexpulsion
   FROM (((((public.cben1
     LEFT JOIN public.ultimodesplazamiento ON ((cben1.id_caso = ultimodesplazamiento.id_caso)))
     LEFT JOIN public.sip_ubicacion ubicacion ON ((ultimodesplazamiento.id_expulsion = ubicacion.id)))
     LEFT JOIN public.sip_departamento departamento ON ((ubicacion.id_departamento = departamento.id)))
     LEFT JOIN public.sip_municipio municipio ON ((ubicacion.id_municipio = municipio.id)))
     LEFT JOIN public.sip_clase clase ON ((ubicacion.id_clase = clase.id)));


ALTER SEQUENCE public.cor1440_gen_valorcampotind_id_seq OWNED BY public.cor1440_gen_valorcampotind.id;


--
-- Name: respuesta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.respuesta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_aslegal_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_aslegal_respuesta (
    id_respuesta integer NOT NULL,
    id_aslegal integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_respuesta (
    id_caso integer NOT NULL,
    fechaatencion date NOT NULL,
    prorrogas boolean,
    numprorrogas integer,
    montoprorrogas integer,
    fechaultima date,
    lugarultima character varying(500),
    entregada boolean,
    proxprorroga boolean,
    turno character varying(100),
    lugar character varying(500),
    descamp character varying(5000),
    compromisos character varying(5000),
    remision character varying(5000),
    orientaciones character varying(5000),
    gestionessjr character varying(5000),
    observaciones character varying(5000),
    id_personadesea integer DEFAULT 0,
    verifcsjr character varying(5000),
    verifcper character varying(5000),
    efectividad character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.respuesta_seq'::regclass) NOT NULL,
    detallear character varying(5000),
    montoar integer,
    cantidadayes character varying(50),
    institucionayes character varying(500),
    informacionder boolean,
    accionesder character varying(5000),
    detallemotivo character varying(5000),
    difobsprog character varying(5000),
    detalleal character varying(5000),
    montoal integer,
    detalleap character varying(5000),
    montoap integer,
    detalleem character varying(5000),
    montoem integer
);


--
-- Name: cres1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cres1 AS
 SELECT caso.id AS id_caso,
    respuesta.fechaatencion,
    casosjr.oficina_id,
    aslegal_respuesta.id_aslegal
   FROM public.sivel2_gen_caso caso,
    public.sivel2_sjr_casosjr casosjr,
    public.sivel2_sjr_respuesta respuesta,
    public.sivel2_sjr_aslegal_respuesta aslegal_respuesta
  WHERE ((caso.id = casosjr.id_caso) AND (caso.id = respuesta.id_caso) AND (respuesta.id = aslegal_respuesta.id_respuesta));


--
-- Name: mecanismoder_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mecanismoder_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motivoconsulta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motivoconsulta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resagresion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resagresion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: sivel2_sjr_statusmigratorio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_statusmigratorio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_statusmigratorio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_statusmigratorio (
    id integer DEFAULT nextval('public.sivel2_sjr_statusmigratorio_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT statusmigratorio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);



--
-- Name: sivel2_sjr_acreditacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_acreditacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_acreditacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_acreditacion (
    id integer DEFAULT nextval('public.sivel2_sjr_acreditacion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT acreditacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_actosjr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_actosjr (
    fecha date NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_acto integer NOT NULL,
    desplazamiento_id integer
);


--
-- Name: sivel2_sjr_actualizacionbase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_actualizacionbase (
    id character varying(10) NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(500) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_aslegal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_aslegal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_aslegal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_aslegal (
    id integer DEFAULT nextval('public.sivel2_sjr_aslegal_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT aslegal_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_ayudaestado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_ayudaestado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_ayudaestado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_ayudaestado (
    id integer DEFAULT nextval('public.sivel2_sjr_ayudaestado_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT ayudaestado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_ayudaestado_derecho; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_ayudaestado_derecho (
    ayudaestado_id integer NOT NULL,
    derecho_id integer NOT NULL
);


--
-- Name: sivel2_sjr_ayudaestado_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_ayudaestado_respuesta (
    id_respuesta integer NOT NULL,
    id_ayudaestado integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_ayudasjr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_ayudasjr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_ayudasjr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_ayudasjr (
    id integer DEFAULT nextval('public.sivel2_sjr_ayudasjr_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT ayudasjr_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_ayudasjr_derecho; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_ayudasjr_derecho (
    ayudasjr_id integer,
    derecho_id integer
);


--
-- Name: sivel2_sjr_ayudasjr_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_ayudasjr_respuesta (
    id_ayudasjr integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_respuesta integer NOT NULL
);


--
-- Name: sivel2_sjr_clasifdesp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_clasifdesp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_clasifdesp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_clasifdesp (
    id integer DEFAULT nextval('public.sivel2_sjr_clasifdesp_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT clasifdesp_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_comosupo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_comosupo (
    id integer NOT NULL,
    nombre character varying(500) NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_comosupo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_comosupo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_comosupo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sivel2_sjr_comosupo_id_seq OWNED BY public.sivel2_sjr_comosupo.id;


--
-- Name: sivel2_sjr_declaroante_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_declaroante_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_declaroante; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_declaroante (
    id integer DEFAULT nextval('public.sivel2_sjr_declaroante_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT declaroante_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_derecho_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_derecho_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_derecho; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_derecho (
    id integer DEFAULT nextval('public.sivel2_sjr_derecho_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT '2013-06-12'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT derecho_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_derecho_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_derecho_respuesta (
    id_respuesta integer NOT NULL,
    id_derecho integer DEFAULT 9 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_etiqueta_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_etiqueta_usuario (
    id integer NOT NULL,
    etiqueta_id integer,
    usuario_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_etiqueta_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_etiqueta_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_etiqueta_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sivel2_sjr_etiqueta_usuario_id_seq OWNED BY public.sivel2_sjr_etiqueta_usuario.id;


--
-- Name: sivel2_sjr_idioma_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_idioma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_idioma; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_idioma (
    id integer DEFAULT nextval('public.sivel2_sjr_idioma_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT '2014-02-14'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT idioma_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_inclusion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_inclusion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_inclusion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_inclusion (
    id integer DEFAULT nextval('public.sivel2_sjr_inclusion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT inclusion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_instanciader; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_instanciader (
    id integer DEFAULT nextval('public.instanciader_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-12'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT instanciader_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_mecanismoder; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_mecanismoder (
    id integer DEFAULT nextval('public.mecanismoder_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-12'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT mecanismoder_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_modalidadtierra_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_modalidadtierra_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_modalidadtierra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_modalidadtierra (
    id integer DEFAULT nextval('public.sivel2_sjr_modalidadtierra_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT modalidadtierra_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_motivoconsulta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_motivoconsulta (
    id integer DEFAULT nextval('public.motivoconsulta_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-05-13'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT motivoconsulta_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_motivosjr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_motivosjr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_motivosjr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_motivosjr (
    id integer DEFAULT nextval('public.sivel2_sjr_motivosjr_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT '2013-06-16'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT motivosjr_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_motivosjr_derecho; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_motivosjr_derecho (
    motivosjr_id integer,
    derecho_id integer
);


--
-- Name: sivel2_sjr_motivosjr_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_motivosjr_respuesta (
    id_respuesta integer NOT NULL,
    id_motivosjr integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_oficina_proyectofinanciero; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_oficina_proyectofinanciero (
    oficina_id bigint NOT NULL,
    proyectofinanciero_id bigint NOT NULL
);


--
-- Name: sivel2_sjr_personadesea_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_personadesea_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_personadesea; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_personadesea (
    id integer DEFAULT nextval('public.sivel2_sjr_personadesea_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-17'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT personadesea_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_progestado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_progestado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_progestado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_progestado (
    id integer DEFAULT nextval('public.sivel2_sjr_progestado_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-17'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT progestado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_progestado_derecho; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_progestado_derecho (
    progestado_id integer,
    derecho_id integer
);


--
-- Name: sivel2_sjr_progestado_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_progestado_respuesta (
    id_respuesta integer NOT NULL,
    id_progestado integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_proteccion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_proteccion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_proteccion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_proteccion (
    id integer DEFAULT nextval('public.sivel2_sjr_proteccion_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT proteccion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_refugio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_refugio (
    id integer NOT NULL,
    id_caso integer,
    fechasalida date,
    id_salida integer,
    fechallegada date,
    id_llegada integer,
    id_causaref integer,
    observaciones character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_refugio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_refugio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_refugio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sivel2_sjr_refugio_id_seq OWNED BY public.sivel2_sjr_refugio.id;



--
-- Name: sivel2_sjr_resagresion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_resagresion (
    id integer DEFAULT nextval('public.resagresion_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT resagresion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_rolfamilia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_rolfamilia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_rolfamilia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_rolfamilia (
    id integer DEFAULT nextval('public.sivel2_sjr_rolfamilia_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT rolfamilia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_tipodesp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_sjr_tipodesp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_tipodesp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_tipodesp (
    id integer DEFAULT nextval('public.sivel2_sjr_tipodesp_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT tipodesp_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_victimasjr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_victimasjr (
    sindocumento boolean,
    id_estadocivil integer DEFAULT 0,
    id_rolfamilia integer DEFAULT 0 NOT NULL,
    cabezafamilia boolean,
    id_maternidad integer DEFAULT 0,
    discapacitado boolean,
    id_actividadoficio integer DEFAULT 0,
    id_escolaridad integer DEFAULT 0,
    asisteescuela boolean,
    tienesisben boolean,
    id_departamento integer,
    id_municipio integer,
    nivelsisben integer,
    id_regimensalud integer DEFAULT 0,
    eps character varying(1000),
    libretamilitar boolean,
    distrito integer,
    progadultomayor boolean,
    fechadesagregacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_victima integer NOT NULL,
    id_pais integer,
    enfermedad character varying(5000),
    ndiscapacidad character varying(100)
);


--
-- Name: sivel2_sjr_comosupo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_comosupo ALTER COLUMN id SET DEFAULT nextval('public.sivel2_sjr_comosupo_id_seq'::regclass);


--
-- Name: sivel2_sjr_etiqueta_usuario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_etiqueta_usuario ALTER COLUMN id SET DEFAULT nextval('public.sivel2_sjr_etiqueta_usuario_id_seq'::regclass);


--
-- Name: sivel2_sjr_refugio id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_refugio ALTER COLUMN id SET DEFAULT nextval('public.sivel2_sjr_refugio_id_seq'::regclass);




--
-- Name: sivel2_sjr_actosjr actosjr_id_acto_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_id_acto_key UNIQUE (id_acto);


--
-- Name: sivel2_sjr_actosjr actosjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_pkey PRIMARY KEY (id_acto);


--
-- Name: sivel2_sjr_actualizacionbase actualizacionbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_actualizacionbase
    ADD CONSTRAINT actualizacionbase_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_aslegal aslegal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_aslegal
    ADD CONSTRAINT aslegal_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_aslegal_respuesta aslegal_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_aslegal_respuesta
    ADD CONSTRAINT aslegal_respuesta_pkey PRIMARY KEY (id_respuesta, id_aslegal);


--
-- Name: sivel2_sjr_ayudaestado ayudaestado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudaestado
    ADD CONSTRAINT ayudaestado_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_ayudaestado_respuesta ayudaestado_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudaestado_respuesta
    ADD CONSTRAINT ayudaestado_respuesta_pkey PRIMARY KEY (id_respuesta, id_ayudaestado);


--
-- Name: sivel2_sjr_ayudasjr ayudasjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudasjr
    ADD CONSTRAINT ayudasjr_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_ayudasjr_respuesta ayudasjr_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudasjr_respuesta
    ADD CONSTRAINT ayudasjr_respuesta_pkey PRIMARY KEY (id_respuesta, id_ayudasjr);



--
-- Name: sivel2_sjr_casosjr casosjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_pkey PRIMARY KEY (id_caso);


--
-- Name: sivel2_sjr_clasifdesp clasifdesp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_clasifdesp
    ADD CONSTRAINT clasifdesp_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_comosupo comosupo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_comosupo
    ADD CONSTRAINT comosupo_pkey PRIMARY KEY (id);



--
-- Name: sivel2_sjr_declaroante declaroante_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_declaroante
    ADD CONSTRAINT declaroante_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_derecho derecho_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_derecho
    ADD CONSTRAINT derecho_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_derecho_respuesta derecho_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_derecho_respuesta
    ADD CONSTRAINT derecho_respuesta_pkey PRIMARY KEY (id_respuesta, id_derecho);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_id_caso_fechaexpulsion_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_caso_fechaexpulsion_key UNIQUE (id_caso, fechaexpulsion);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_key UNIQUE (id);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_pkey PRIMARY KEY (id);



--
-- Name: sivel2_sjr_etiqueta_usuario etiqueta_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_etiqueta_usuario
    ADD CONSTRAINT etiqueta_usuario_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_idioma idioma_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_idioma
    ADD CONSTRAINT idioma_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_inclusion inclusion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_inclusion
    ADD CONSTRAINT inclusion_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_instanciader instanciader_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_instanciader
    ADD CONSTRAINT instanciader_pkey PRIMARY KEY (id);

--
-- Name: sivel2_sjr_mecanismoder mecanismoder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_mecanismoder
    ADD CONSTRAINT mecanismoder_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_modalidadtierra modalidadtierra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_modalidadtierra
    ADD CONSTRAINT modalidadtierra_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_motivoconsulta motivoconsulta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivoconsulta
    ADD CONSTRAINT motivoconsulta_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_motivosjr motivosjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr
    ADD CONSTRAINT motivosjr_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_motivosjr_respuesta motivosjr_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr_respuesta
    ADD CONSTRAINT motivosjr_respuesta_pkey PRIMARY KEY (id_respuesta, id_motivosjr);



--
-- Name: sivel2_sjr_personadesea personadesea_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_personadesea
    ADD CONSTRAINT personadesea_pkey PRIMARY KEY (id);
--
-- Name: sivel2_sjr_progestado progestado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_progestado
    ADD CONSTRAINT progestado_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_progestado_respuesta progestado_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_progestado_respuesta
    ADD CONSTRAINT progestado_respuesta_pkey PRIMARY KEY (id_respuesta, id_progestado);


--
-- Name: sivel2_sjr_proteccion proteccion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_proteccion
    ADD CONSTRAINT proteccion_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_refugio refugio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_refugio
    ADD CONSTRAINT refugio_pkey PRIMARY KEY (id);



--
-- Name: sivel2_sjr_resagresion resagresion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_resagresion
    ADD CONSTRAINT resagresion_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_respuesta respuesta_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_id_key UNIQUE (id);


--
-- Name: sivel2_sjr_respuesta respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_rolfamilia rolfamilia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_rolfamilia
    ADD CONSTRAINT rolfamilia_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_acreditacion sivel2_sjr_acreditacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_acreditacion
    ADD CONSTRAINT sivel2_sjr_acreditacion_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_statusmigratorio statusmigratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_statusmigratorio
    ADD CONSTRAINT statusmigratorio_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_tipodesp tipodesp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_tipodesp
    ADD CONSTRAINT tipodesp_pkey PRIMARY KEY (id);



--
-- Name: index_sivel2_sjr_casosjr_on_comosupo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sivel2_sjr_casosjr_on_comosupo_id ON public.sivel2_sjr_casosjr USING btree (comosupo_id);


--
-- Name: sivel2_sjr_actosjr actosjr_desplazamiento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_desplazamiento_id_fkey FOREIGN KEY (desplazamiento_id) REFERENCES public.sivel2_sjr_desplazamiento(id);


--
-- Name: sivel2_sjr_actosjr actosjr_id_acto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_id_acto_fkey FOREIGN KEY (id_acto) REFERENCES public.sivel2_gen_acto(id);


--
-- Name: sivel2_sjr_aslegal_respuesta aslegal_respuesta_id_aslegal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_aslegal_respuesta
    ADD CONSTRAINT aslegal_respuesta_id_aslegal_fkey FOREIGN KEY (id_aslegal) REFERENCES public.sivel2_sjr_aslegal(id);


--
-- Name: sivel2_sjr_aslegal_respuesta aslegal_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_aslegal_respuesta
    ADD CONSTRAINT aslegal_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES public.sivel2_sjr_respuesta(id);


--
-- Name: sivel2_sjr_ayudaestado_respuesta ayudaestado_respuesta_id_ayudaestado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudaestado_respuesta
    ADD CONSTRAINT ayudaestado_respuesta_id_ayudaestado_fkey FOREIGN KEY (id_ayudaestado) REFERENCES public.sivel2_sjr_ayudaestado(id);


--
-- Name: sivel2_sjr_ayudaestado_respuesta ayudaestado_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudaestado_respuesta
    ADD CONSTRAINT ayudaestado_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES public.sivel2_sjr_respuesta(id);


--
-- Name: sivel2_sjr_ayudasjr_respuesta ayudasjr_respuesta_id_ayudasjr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudasjr_respuesta
    ADD CONSTRAINT ayudasjr_respuesta_id_ayudasjr_fkey FOREIGN KEY (id_ayudasjr) REFERENCES public.sivel2_sjr_ayudasjr(id);


--
-- Name: sivel2_sjr_ayudasjr_respuesta ayudasjr_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudasjr_respuesta
    ADD CONSTRAINT ayudasjr_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES public.sivel2_sjr_respuesta(id);


--
-- Name: sivel2_sjr_casosjr casosjr_asesor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_asesor_fkey FOREIGN KEY (asesor) REFERENCES public.usuario(id);


--
-- Name: sivel2_sjr_casosjr casosjr_categoriaref_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_categoriaref_fkey FOREIGN KEY (categoriaref) REFERENCES public.sivel2_gen_categoria(id);


--
-- Name: sivel2_sjr_casosjr casosjr_comosupo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_comosupo_id_fkey FOREIGN KEY (comosupo_id) REFERENCES public.sivel2_sjr_comosupo(id);


--
-- Name: sivel2_sjr_casosjr casosjr_contacto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_contacto_fkey FOREIGN KEY (contacto) REFERENCES public.sip_persona(id);


--
-- Name: sivel2_sjr_casosjr casosjr_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_sjr_casosjr casosjr_id_idioma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_idioma_fkey FOREIGN KEY (id_idioma) REFERENCES public.sivel2_sjr_idioma(id);


--
-- Name: sivel2_sjr_casosjr casosjr_id_llegada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_llegada_fkey FOREIGN KEY (id_llegada) REFERENCES public.sip_ubicacion(id);


--
-- Name: sivel2_sjr_casosjr casosjr_id_proteccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_proteccion_fkey FOREIGN KEY (id_proteccion) REFERENCES public.sivel2_sjr_proteccion(id);


--
-- Name: sivel2_sjr_casosjr casosjr_id_regionsjr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_regionsjr_fkey FOREIGN KEY (oficina_id) REFERENCES public.sip_oficina(id);


--
-- Name: sivel2_sjr_casosjr casosjr_id_salida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_salida_fkey FOREIGN KEY (id_salida) REFERENCES public.sip_ubicacion(id);


--
-- Name: sivel2_sjr_casosjr casosjr_id_statusmigratorio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_statusmigratorio_fkey FOREIGN KEY (id_statusmigratorio) REFERENCES public.sivel2_sjr_statusmigratorio(id);


--
-- Name: sivel2_sjr_derecho_respuesta derecho_respuesta_id_derecho_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_derecho_respuesta
    ADD CONSTRAINT derecho_respuesta_id_derecho_fkey FOREIGN KEY (id_derecho) REFERENCES public.sivel2_sjr_derecho(id);


--
-- Name: sivel2_sjr_derecho_respuesta derecho_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_derecho_respuesta
    ADD CONSTRAINT derecho_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES public.sivel2_sjr_respuesta(id);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_expulsion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_expulsion_fkey FOREIGN KEY (id_expulsion) REFERENCES public.sip_ubicacion(id);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_id_expulsion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_expulsion_fkey FOREIGN KEY (id_expulsion) REFERENCES public.sip_ubicacion(id);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_id_llegada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_llegada_fkey FOREIGN KEY (id_llegada) REFERENCES public.sip_ubicacion(id);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_id_tipodesp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_tipodesp_fkey FOREIGN KEY (id_tipodesp) REFERENCES public.sivel2_sjr_tipodesp(id);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_llegada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_llegada_fkey FOREIGN KEY (id_llegada) REFERENCES public.sip_ubicacion(id);


--
-- Name: sivel2_sjr_desplazamiento desplazamiento_paisdecl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_paisdecl_fkey FOREIGN KEY (paisdecl) REFERENCES public.sip_pais(id);



--
-- Name: sivel2_sjr_motivosjr_derecho fk_rails_02f5fb9150; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr_derecho
    ADD CONSTRAINT fk_rails_02f5fb9150 FOREIGN KEY (derecho_id) REFERENCES public.sivel2_sjr_derecho(id);


--
-- Name: sivel2_sjr_oficina_proyectofinanciero fk_rails_3479b42b5c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_oficina_proyectofinanciero
    ADD CONSTRAINT fk_rails_3479b42b5c FOREIGN KEY (oficina_id) REFERENCES public.sip_oficina(id);


--
-- Name: sivel2_sjr_oficina_proyectofinanciero fk_rails_669494cbb1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_oficina_proyectofinanciero
    ADD CONSTRAINT fk_rails_669494cbb1 FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);

--
-- Name: sivel2_sjr_motivosjr_derecho fk_rails_74442b8f19; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr_derecho
    ADD CONSTRAINT fk_rails_74442b8f19 FOREIGN KEY (motivosjr_id) REFERENCES public.sivel2_sjr_motivosjr(id);


--
-- Name: sivel2_sjr_ayudasjr_derecho fk_rails_93fdde2014; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudasjr_derecho
    ADD CONSTRAINT fk_rails_93fdde2014 FOREIGN KEY (derecho_id) REFERENCES public.sivel2_sjr_derecho(id);


--
-- Name: sivel2_sjr_progestado_derecho fk_rails_cff2ad554d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_progestado_derecho
    ADD CONSTRAINT fk_rails_cff2ad554d FOREIGN KEY (derecho_id) REFERENCES public.sivel2_sjr_derecho(id);


--
-- Name: sivel2_sjr_ayudasjr_derecho fk_rails_e645a3e73c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudasjr_derecho
    ADD CONSTRAINT fk_rails_e645a3e73c FOREIGN KEY (ayudasjr_id) REFERENCES public.sivel2_sjr_ayudasjr(id);


--
-- Name: sivel2_sjr_progestado_derecho fk_rails_e8743fd8f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_progestado_derecho
    ADD CONSTRAINT fk_rails_e8743fd8f6 FOREIGN KEY (progestado_id) REFERENCES public.sivel2_sjr_progestado(id);

--
-- Name: sivel2_sjr_motivosjr_respuesta motivosjr_respuesta_id_motivosjr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr_respuesta
    ADD CONSTRAINT motivosjr_respuesta_id_motivosjr_fkey FOREIGN KEY (id_motivosjr) REFERENCES public.sivel2_sjr_motivosjr(id);


--
-- Name: sivel2_sjr_motivosjr_respuesta motivosjr_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr_respuesta
    ADD CONSTRAINT motivosjr_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES public.sivel2_sjr_respuesta(id);


--
-- Name: sivel2_sjr_progestado_respuesta progestado_respuesta_id_progestado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_progestado_respuesta
    ADD CONSTRAINT progestado_respuesta_id_progestado_fkey FOREIGN KEY (id_progestado) REFERENCES public.sivel2_sjr_progestado(id);


--
-- Name: sivel2_sjr_progestado_respuesta progestado_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_progestado_respuesta
    ADD CONSTRAINT progestado_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES public.sivel2_sjr_respuesta(id);


--
-- Name: sivel2_sjr_respuesta respuesta_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_sjr_casosjr(id_caso);


--
-- Name: sivel2_sjr_respuesta respuesta_id_personadesea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_id_personadesea_fkey FOREIGN KEY (id_personadesea) REFERENCES public.sivel2_sjr_personadesea(id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_id_actividadoficio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_actividadoficio_fkey FOREIGN KEY (id_actividadoficio) REFERENCES public.sivel2_gen_actividadoficio(id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_id_escolaridad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_escolaridad_fkey FOREIGN KEY (id_escolaridad) REFERENCES public.sivel2_gen_escolaridad(id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_id_estadocivil_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_estadocivil_fkey FOREIGN KEY (id_estadocivil) REFERENCES public.sivel2_gen_estadocivil(id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_id_maternidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_maternidad_fkey FOREIGN KEY (id_maternidad) REFERENCES public.sivel2_gen_maternidad(id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES public.sip_pais(id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_id_rolfamilia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_rolfamilia_fkey FOREIGN KEY (id_rolfamilia) REFERENCES public.sivel2_sjr_rolfamilia(id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_id_victima_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_victima_fkey FOREIGN KEY (id_victima) REFERENCES public.sivel2_gen_victima(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20131205233111'),
('20140217100541'),
('20140317121823'),
('20140611111020'),
('20140613200951'),
('20140620112004'),
('20140805030341'),
('20140814184537'),
('20140902101425'),
('20140904033941'),
('20140904211823'),
('20140904213327'),
('20140905121420'),
('20140909141336'),
('20141112111129'),
('20141222174237'),
('20141222174247'),
('20141222174257'),
('20141222174267'),
('20141225174739'),
('20150213114933'),
('20150225140336'),
('20150317084149'),
('20150317090631'),
('20150609094815'),
('20150612160810'),
('20150612203808'),
('20150615024318'),
('20150717161539'),
('20150724024110'),
('20150929112313'),
('20151006105402'),
('20151020203420'),
('20151030094611'),
('20160725125929'),
('20170712205819'),
('20180307125759')
;


    SQL
  end
end
