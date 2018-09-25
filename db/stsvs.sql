SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: es_co_utf_8; Type: COLLATION; Schema: public; Owner: -
--

CREATE COLLATION public.es_co_utf_8 (provider = libc, locale = 'es_CO.UTF-8');


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: soundexesp(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.soundexesp(input text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT COST 500
    AS $$
DECLARE
	soundex text='';	
	-- para determinar la primera letra
	pri_letra text;
	resto text;
	sustituida text ='';
	-- para quitar adyacentes
	anterior text;
	actual text;
	corregido text;
BEGIN
       -- devolver null si recibi un string en blanco o con espacios en blanco
	IF length(trim(input))= 0 then
		RETURN NULL;
	end IF;
 
 
	-- 1: LIMPIEZA:
		-- pasar a mayuscula, eliminar la letra "H" inicial, los acentos y la enie
		-- 'holá coñó' => 'OLA CONO'
		input=translate(ltrim(trim(upper(input)),'H'),'ÑÁÉÍÓÚÀÈÌÒÙÜ','NAEIOUAEIOUU');
 
		-- eliminar caracteres no alfabéticos (números, símbolos como &,%,",*,!,+, etc.
		input=regexp_replace(input, '[^a-zA-Z]', '', 'g');
 
	-- 2: PRIMERA LETRA ES IMPORTANTE, DEBO ASOCIAR LAS SIMILARES
	--  'vaca' se convierte en 'baca'  y 'zapote' se convierte en 'sapote'
	-- un fenomeno importante es GE y GI se vuelven JE y JI; CA se vuelve KA, etc
	pri_letra =substr(input,1,1);
	resto =substr(input,2);
	CASE 
		when pri_letra IN ('V') then
			sustituida='B';
		when pri_letra IN ('Z','X') then
			sustituida='S';
		when pri_letra IN ('G') AND substr(input,2,1) IN ('E','I') then
			sustituida='J';
		when pri_letra IN('C') AND substr(input,2,1) NOT IN ('H','E','I') then
			sustituida='K';
		else
			sustituida=pri_letra;
 
	end case;
	--corregir el parametro con las consonantes sustituidas:
	input=sustituida || resto;		
 
	-- 3: corregir "letras compuestas" y volverlas una sola
	input=REPLACE(input,'CH','V');
	input=REPLACE(input,'QU','K');
	input=REPLACE(input,'LL','J');
	input=REPLACE(input,'CE','S');
	input=REPLACE(input,'CI','S');
	input=REPLACE(input,'YA','J');
	input=REPLACE(input,'YE','J');
	input=REPLACE(input,'YI','J');
	input=REPLACE(input,'YO','J');
	input=REPLACE(input,'YU','J');
	input=REPLACE(input,'GE','J');
	input=REPLACE(input,'GI','J');
	input=REPLACE(input,'NY','N');
	-- para debug:    --return input;
 
	-- EMPIEZA EL CALCULO DEL SOUNDEX
	-- 4: OBTENER PRIMERA letra
	pri_letra=substr(input,1,1);
 
	-- 5: retener el resto del string
	resto=substr(input,2);
 
	--6: en el resto del string, quitar vocales y vocales fonéticas
	resto=translate(resto,'@AEIOUHWY','@');
 
	--7: convertir las letras foneticamente equivalentes a numeros  (esto hace que B sea equivalente a V, C con S y Z, etc.)
	resto=translate(resto, 'BPFVCGKSXZDTLMNRQJ', '111122222233455677');
	-- así va quedando la cosa
	soundex=pri_letra || resto;
 
	--8: eliminar números iguales adyacentes (A11233 se vuelve A123)
	anterior=substr(soundex,1,1);
	corregido=anterior;
 
	FOR i IN 2 .. length(soundex) LOOP
		actual = substr(soundex, i, 1);
		IF actual <> anterior THEN
			corregido=corregido || actual;
			anterior=actual;			
		END IF;
	END LOOP;
	-- así va la cosa
	soundex=corregido;
 
	-- 9: siempre retornar un string de 4 posiciones
	soundex=rpad(soundex,4,'0');
	soundex=substr(soundex,1,4);		
 
	-- YA ESTUVO
	RETURN soundex;	
END;	
$$;


--
-- Name: acto_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.acto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anexo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.anexo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: caso_etiqueta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caso_etiqueta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caso_presponsable_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caso_presponsable_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_persona_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_persona; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_persona (
    id integer DEFAULT nextval('public.sip_persona_id_seq'::regclass) NOT NULL,
    nombres character varying(100) COLLATE public.es_co_utf_8 NOT NULL,
    apellidos character varying(100) COLLATE public.es_co_utf_8 NOT NULL,
    anionac integer,
    mesnac integer,
    dianac integer,
    sexo character(1) NOT NULL,
    numerodocumento character varying(100),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_pais integer,
    nacionalde integer,
    tdocumento_id integer,
    id_departamento integer,
    id_municipio integer,
    id_clase integer,
    CONSTRAINT persona_check CHECK (((dianac IS NULL) OR (((dianac >= 1) AND (((mesnac = 1) OR (mesnac = 3) OR (mesnac = 5) OR (mesnac = 7) OR (mesnac = 8) OR (mesnac = 10) OR (mesnac = 12)) AND (dianac <= 31))) OR (((mesnac = 4) OR (mesnac = 6) OR (mesnac = 9) OR (mesnac = 11)) AND (dianac <= 30)) OR ((mesnac = 2) AND (dianac <= 29))))),
    CONSTRAINT persona_mesnac_check CHECK (((mesnac IS NULL) OR ((mesnac >= 1) AND (mesnac <= 12)))),
    CONSTRAINT persona_sexo_check CHECK (((sexo = 'S'::bpchar) OR (sexo = 'F'::bpchar) OR (sexo = 'M'::bpchar)))
);


--
-- Name: sivel2_gen_caso_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_caso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_caso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso (
    id integer DEFAULT nextval('public.sivel2_gen_caso_id_seq'::regclass) NOT NULL,
    titulo character varying(50),
    fecha date NOT NULL,
    hora character varying(10),
    duracion character varying(10),
    memo text NOT NULL,
    grconfiabilidad character varying(5),
    gresclarecimiento character varying(5),
    grimpunidad character varying(8),
    grinformacion character varying(8),
    bienes text,
    id_intervalo integer DEFAULT 5,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: victima_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.victima_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_victima; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_victima (
    id_persona integer NOT NULL,
    id_caso integer NOT NULL,
    hijos integer,
    id_profesion integer DEFAULT 22 NOT NULL,
    id_rangoedad integer DEFAULT 6 NOT NULL,
    id_filiacion integer DEFAULT 10 NOT NULL,
    id_sectorsocial integer DEFAULT 15 NOT NULL,
    id_organizacion integer DEFAULT 16 NOT NULL,
    id_vinculoestado integer DEFAULT 38 NOT NULL,
    organizacionarmada integer DEFAULT 35 NOT NULL,
    anotaciones character varying(1000),
    id_etnia integer DEFAULT 1,
    id_iglesia integer DEFAULT 1,
    orientacionsexual character(1) DEFAULT 'S'::bpchar NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.victima_seq'::regclass) NOT NULL,
    CONSTRAINT victima_hijos_check CHECK (((hijos IS NULL) OR ((hijos >= 0) AND (hijos <= 100)))),
    CONSTRAINT victima_orientacionsexual_check CHECK (((orientacionsexual = 'L'::bpchar) OR (orientacionsexual = 'G'::bpchar) OR (orientacionsexual = 'B'::bpchar) OR (orientacionsexual = 'T'::bpchar) OR (orientacionsexual = 'H'::bpchar) OR (orientacionsexual = 'S'::bpchar)))
);


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
-- Name: sip_clase_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_clase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_clase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_clase (
    id_clalocal integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    id_tclase character varying(10) DEFAULT 'CP'::character varying NOT NULL,
    latitud double precision,
    longitud double precision,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_municipio integer,
    id integer DEFAULT nextval('public.sip_clase_id_seq'::regclass) NOT NULL,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT clase_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_departamento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_departamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_departamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_departamento (
    id_deplocal integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    latitud double precision,
    longitud double precision,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_pais integer DEFAULT 0 NOT NULL,
    id integer DEFAULT nextval('public.sip_departamento_id_seq'::regclass) NOT NULL,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT departamento_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_municipio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_municipio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_municipio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_municipio (
    id_munlocal integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    latitud double precision,
    longitud double precision,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_departamento integer,
    id integer DEFAULT nextval('public.sip_municipio_id_seq'::regclass) NOT NULL,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT municipio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_ubicacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_ubicacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_ubicacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_ubicacion (
    id integer DEFAULT nextval('public.sip_ubicacion_id_seq'::regclass) NOT NULL,
    lugar character varying(500) COLLATE public.es_co_utf_8,
    sitio character varying(500) COLLATE public.es_co_utf_8,
    id_tsitio integer DEFAULT 1 NOT NULL,
    id_caso integer NOT NULL,
    latitud double precision,
    longitud double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_pais integer DEFAULT 0,
    id_departamento integer,
    id_municipio integer,
    id_clase integer
);


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


--
-- Name: cor1440_gen_actividad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad (
    id integer NOT NULL,
    minutos integer,
    nombre character varying(500),
    objetivo character varying(5000),
    resultado character varying(5000),
    fecha date,
    observaciones character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    oficina_id integer NOT NULL,
    rangoedadac_id integer,
    usuario_id integer,
    lugar character varying(500)
);


--
-- Name: cor1440_gen_actividad_actividadpf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_actividadpf (
    actividad_id bigint NOT NULL,
    actividadpf_id bigint NOT NULL
);


--
-- Name: cor1440_gen_actividad_actividadtipo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_actividadtipo (
    actividad_id integer,
    actividadtipo_id integer
);


--
-- Name: cor1440_gen_actividad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividad_id_seq OWNED BY public.cor1440_gen_actividad.id;


--
-- Name: cor1440_gen_actividad_proyecto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_proyecto (
    id integer NOT NULL,
    actividad_id integer,
    proyecto_id integer
);


--
-- Name: cor1440_gen_actividad_proyecto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividad_proyecto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_proyecto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividad_proyecto_id_seq OWNED BY public.cor1440_gen_actividad_proyecto.id;


--
-- Name: cor1440_gen_actividad_proyectofinanciero; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_proyectofinanciero (
    actividad_id integer NOT NULL,
    proyectofinanciero_id integer NOT NULL
);


--
-- Name: cor1440_gen_actividad_rangoedadac; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_rangoedadac (
    id integer NOT NULL,
    actividad_id integer,
    rangoedadac_id integer,
    ml integer,
    mr integer,
    fl integer,
    fr integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_actividad_rangoedadac_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividad_rangoedadac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_rangoedadac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividad_rangoedadac_id_seq OWNED BY public.cor1440_gen_actividad_rangoedadac.id;


--
-- Name: cor1440_gen_actividad_sip_anexo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividad_sip_anexo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_sip_anexo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_sip_anexo (
    actividad_id integer NOT NULL,
    anexo_id integer NOT NULL,
    id integer DEFAULT nextval('public.cor1440_gen_actividad_sip_anexo_id_seq'::regclass) NOT NULL
);


--
-- Name: cor1440_gen_actividad_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_usuario (
    actividad_id integer NOT NULL,
    usuario_id integer NOT NULL
);


--
-- Name: cor1440_gen_actividad_valorcampotind; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividad_valorcampotind (
    id bigint NOT NULL,
    actividad_id integer,
    valorcampotind_id integer
);


--
-- Name: cor1440_gen_actividad_valorcampotind_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividad_valorcampotind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_valorcampotind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividad_valorcampotind_id_seq OWNED BY public.cor1440_gen_actividad_valorcampotind.id;


--
-- Name: cor1440_gen_actividadarea; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividadarea (
    id integer NOT NULL,
    nombre character varying(500),
    observaciones character varying(5000),
    fechacreacion date DEFAULT ('now'::text)::date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_actividadarea_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividadarea_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividadarea_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividadarea_id_seq OWNED BY public.cor1440_gen_actividadarea.id;


--
-- Name: cor1440_gen_actividadareas_actividad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividadareas_actividad (
    id integer NOT NULL,
    actividad_id integer,
    actividadarea_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_actividadareas_actividad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividadareas_actividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividadareas_actividad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividadareas_actividad_id_seq OWNED BY public.cor1440_gen_actividadareas_actividad.id;


--
-- Name: cor1440_gen_actividadpf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividadpf (
    id integer NOT NULL,
    proyectofinanciero_id integer,
    nombrecorto character varying(15),
    titulo character varying(255),
    descripcion character varying(5000),
    resultadopf_id integer,
    actividadtipo_id integer
);


--
-- Name: cor1440_gen_actividadpf_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividadpf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividadpf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividadpf_id_seq OWNED BY public.cor1440_gen_actividadpf.id;


--
-- Name: cor1440_gen_actividadtipo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_actividadtipo (
    id integer NOT NULL,
    nombre character varying(500) NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    listadoasistencia boolean
);


--
-- Name: cor1440_gen_actividadtipo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_actividadtipo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividadtipo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_actividadtipo_id_seq OWNED BY public.cor1440_gen_actividadtipo.id;


--
-- Name: cor1440_gen_asistencia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_asistencia (
    id bigint NOT NULL,
    actividad_id integer NOT NULL,
    persona_id integer NOT NULL,
    rangoedadac_id integer,
    externo boolean,
    actorsocial_id integer,
    perfilactorsocial_id integer
);


--
-- Name: cor1440_gen_asistencia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_asistencia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_asistencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_asistencia_id_seq OWNED BY public.cor1440_gen_asistencia.id;


--
-- Name: cor1440_gen_campoact; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_campoact (
    id bigint NOT NULL,
    actividadtipo_id integer,
    nombrecampo character varying(128),
    ayudauso character varying(1024),
    tipo integer DEFAULT 1
);


--
-- Name: cor1440_gen_campoact_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_campoact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_campoact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_campoact_id_seq OWNED BY public.cor1440_gen_campoact.id;


--
-- Name: cor1440_gen_campotind; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_campotind (
    id bigint NOT NULL,
    tipoindicador_id integer NOT NULL,
    nombrecampo character varying(128) NOT NULL,
    ayudauso character varying(1024),
    tipo integer DEFAULT 1
);


--
-- Name: cor1440_gen_campotind_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_campotind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_campotind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_campotind_id_seq OWNED BY public.cor1440_gen_campotind.id;


--
-- Name: cor1440_gen_financiador; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_financiador (
    id integer NOT NULL,
    nombre character varying(1000),
    observaciones character varying(5000),
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_financiador_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_financiador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_financiador_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_financiador_id_seq OWNED BY public.cor1440_gen_financiador.id;


--
-- Name: cor1440_gen_financiador_proyectofinanciero; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_financiador_proyectofinanciero (
    financiador_id integer NOT NULL,
    proyectofinanciero_id integer NOT NULL
);


--
-- Name: cor1440_gen_indicadorpf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_indicadorpf (
    id bigint NOT NULL,
    proyectofinanciero_id integer,
    resultadopf_id integer,
    numero character varying(15) NOT NULL,
    indicador character varying(5000) NOT NULL,
    tipoindicador_id integer,
    objetivopf_id integer
);


--
-- Name: cor1440_gen_indicadorpf_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_indicadorpf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_indicadorpf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_indicadorpf_id_seq OWNED BY public.cor1440_gen_indicadorpf.id;


--
-- Name: cor1440_gen_informe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_informe (
    id integer NOT NULL,
    titulo character varying(500) NOT NULL,
    filtrofechaini date NOT NULL,
    filtrofechafin date NOT NULL,
    filtroproyecto integer,
    filtroactividadarea integer,
    columnanombre boolean,
    columnatipo boolean,
    columnaobjetivo boolean,
    columnaproyecto boolean,
    columnapoblacion boolean,
    recomendaciones character varying(5000),
    avances character varying(5000),
    logros character varying(5000),
    dificultades character varying(5000),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filtroproyectofinanciero integer,
    filtroresponsable integer,
    filtrooficina integer,
    columnafecha boolean,
    columnaresponsable boolean
);


--
-- Name: cor1440_gen_informe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_informe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_informe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_informe_id_seq OWNED BY public.cor1440_gen_informe.id;


--
-- Name: cor1440_gen_objetivopf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_objetivopf (
    id bigint NOT NULL,
    proyectofinanciero_id integer,
    numero character varying(15) NOT NULL,
    objetivo character varying(5000) NOT NULL
);


--
-- Name: cor1440_gen_objetivopf_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_objetivopf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_objetivopf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_objetivopf_id_seq OWNED BY public.cor1440_gen_objetivopf.id;


--
-- Name: cor1440_gen_proyecto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_proyecto (
    id integer NOT NULL,
    nombre character varying(1000),
    observaciones character varying(5000),
    fechainicio date,
    fechacierre date,
    resultados character varying(5000),
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_proyecto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_proyecto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_proyecto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_proyecto_id_seq OWNED BY public.cor1440_gen_proyecto.id;


--
-- Name: cor1440_gen_proyecto_proyectofinanciero; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_proyecto_proyectofinanciero (
    proyecto_id integer NOT NULL,
    proyectofinanciero_id integer NOT NULL
);


--
-- Name: cor1440_gen_proyectofinanciero; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_proyectofinanciero (
    id integer NOT NULL,
    nombre character varying(1000),
    observaciones character varying(5000),
    fechainicio date,
    fechacierre date,
    responsable_id integer,
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    compromisos character varying(5000),
    monto integer
);


--
-- Name: cor1440_gen_proyectofinanciero_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_proyectofinanciero_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_proyectofinanciero_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_proyectofinanciero_id_seq OWNED BY public.cor1440_gen_proyectofinanciero.id;


--
-- Name: cor1440_gen_rangoedadac; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_rangoedadac (
    id integer NOT NULL,
    nombre character varying(255),
    limiteinferior integer,
    limitesuperior integer,
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000)
);


--
-- Name: cor1440_gen_rangoedadac_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_rangoedadac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_rangoedadac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_rangoedadac_id_seq OWNED BY public.cor1440_gen_rangoedadac.id;


--
-- Name: cor1440_gen_resultadopf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_resultadopf (
    id bigint NOT NULL,
    proyectofinanciero_id integer,
    objetivopf_id integer,
    numero character varying(15) NOT NULL,
    resultado character varying(5000) NOT NULL
);


--
-- Name: cor1440_gen_resultadopf_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_resultadopf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_resultadopf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_resultadopf_id_seq OWNED BY public.cor1440_gen_resultadopf.id;


--
-- Name: cor1440_gen_tipoindicador; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_tipoindicador (
    id bigint NOT NULL,
    nombre character varying(32),
    medircon integer,
    espcampos character varying(1000),
    espvaloresomision character varying(1000),
    espvalidaciones character varying(1000),
    esptipometa character varying(32),
    espfuncionmedir character varying(1000)
);


--
-- Name: cor1440_gen_tipoindicador_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_tipoindicador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_tipoindicador_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_tipoindicador_id_seq OWNED BY public.cor1440_gen_tipoindicador.id;


--
-- Name: cor1440_gen_valorcampoact; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_valorcampoact (
    id bigint NOT NULL,
    actividad_id integer,
    campoact_id integer,
    valor character varying(5000)
);


--
-- Name: cor1440_gen_valorcampoact_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_valorcampoact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_valorcampoact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cor1440_gen_valorcampoact_id_seq OWNED BY public.cor1440_gen_valorcampoact.id;


--
-- Name: cor1440_gen_valorcampotind; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cor1440_gen_valorcampotind (
    id bigint NOT NULL,
    campotind_id integer,
    valor character varying(5000)
);


--
-- Name: cor1440_gen_valorcampotind_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cor1440_gen_valorcampotind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_valorcampotind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

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
-- Name: fotra_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fotra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_campohc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heb412_gen_campohc (
    id integer NOT NULL,
    doc_id integer NOT NULL,
    nombrecampo character varying(127) NOT NULL,
    columna character varying(5) NOT NULL,
    fila integer
);


--
-- Name: heb412_gen_campohc_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heb412_gen_campohc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_campohc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heb412_gen_campohc_id_seq OWNED BY public.heb412_gen_campohc.id;


--
-- Name: heb412_gen_campoplantillahcm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heb412_gen_campoplantillahcm (
    id integer NOT NULL,
    plantillahcm_id integer,
    nombrecampo character varying(127),
    columna character varying(5)
);


--
-- Name: heb412_gen_campoplantillahcm_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heb412_gen_campoplantillahcm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_campoplantillahcm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heb412_gen_campoplantillahcm_id_seq OWNED BY public.heb412_gen_campoplantillahcm.id;


--
-- Name: heb412_gen_campoplantillahcr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heb412_gen_campoplantillahcr (
    id bigint NOT NULL,
    plantillahcr_id integer,
    nombrecampo character varying(127),
    columna character varying(5),
    fila integer
);


--
-- Name: heb412_gen_campoplantillahcr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heb412_gen_campoplantillahcr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_campoplantillahcr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heb412_gen_campoplantillahcr_id_seq OWNED BY public.heb412_gen_campoplantillahcr.id;


--
-- Name: heb412_gen_doc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heb412_gen_doc (
    id integer NOT NULL,
    nombre character varying(512),
    tipodoc character varying(1),
    dirpapa integer,
    url character varying(1024),
    fuente character varying(1024),
    descripcion character varying(5000),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    adjunto_file_name character varying,
    adjunto_content_type character varying,
    adjunto_file_size integer,
    adjunto_updated_at timestamp without time zone,
    nombremenu character varying(127),
    vista character varying(255),
    filainicial integer,
    ruta character varying(2047),
    licencia character varying(255),
    tdoc_id integer,
    tdoc_type character varying
);


--
-- Name: heb412_gen_doc_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heb412_gen_doc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_doc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heb412_gen_doc_id_seq OWNED BY public.heb412_gen_doc.id;


--
-- Name: heb412_gen_plantilladoc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heb412_gen_plantilladoc (
    id bigint NOT NULL,
    ruta character varying(2047),
    fuente character varying(1023),
    licencia character varying(1023),
    vista character varying(127),
    nombremenu character varying(127)
);


--
-- Name: heb412_gen_plantilladoc_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heb412_gen_plantilladoc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_plantilladoc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heb412_gen_plantilladoc_id_seq OWNED BY public.heb412_gen_plantilladoc.id;


--
-- Name: heb412_gen_plantillahcm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heb412_gen_plantillahcm (
    id integer NOT NULL,
    ruta character varying(2047) NOT NULL,
    fuente character varying(1023),
    licencia character varying(1023),
    vista character varying(127) NOT NULL,
    nombremenu character varying(127) NOT NULL,
    filainicial integer NOT NULL
);


--
-- Name: heb412_gen_plantillahcm_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heb412_gen_plantillahcm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_plantillahcm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heb412_gen_plantillahcm_id_seq OWNED BY public.heb412_gen_plantillahcm.id;


--
-- Name: heb412_gen_plantillahcr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heb412_gen_plantillahcr (
    id bigint NOT NULL,
    ruta character varying(2047),
    fuente character varying(1023),
    licencia character varying(1023),
    vista character varying(127),
    nombremenu character varying(127)
);


--
-- Name: heb412_gen_plantillahcr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heb412_gen_plantillahcr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heb412_gen_plantillahcr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heb412_gen_plantillahcr_id_seq OWNED BY public.heb412_gen_plantillahcr.id;


--
-- Name: instanciader_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.instanciader_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


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
-- Name: regimensalud_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regimensalud_seq
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sip_actorsocial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_actorsocial (
    id bigint NOT NULL,
    grupoper_id integer NOT NULL,
    telefono character varying(500),
    fax character varying(500),
    direccion character varying(500),
    pais_id integer,
    web character varying(500),
    observaciones character varying(5000),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sip_actorsocial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_actorsocial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_actorsocial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_actorsocial_id_seq OWNED BY public.sip_actorsocial.id;


--
-- Name: sip_actorsocial_persona; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_actorsocial_persona (
    id bigint NOT NULL,
    persona_id integer NOT NULL,
    actorsocial_id integer,
    perfilactorsocial_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sip_actorsocial_persona_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_actorsocial_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_actorsocial_persona_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_actorsocial_persona_id_seq OWNED BY public.sip_actorsocial_persona.id;


--
-- Name: sip_actorsocial_sectoractor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_actorsocial_sectoractor (
    actorsocial_id integer,
    sectoractor_id integer
);


--
-- Name: sip_anexo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_anexo (
    id integer NOT NULL,
    descripcion character varying(1500) COLLATE public.es_co_utf_8,
    adjunto_file_name character varying(255),
    adjunto_content_type character varying(255),
    adjunto_file_size integer,
    adjunto_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sip_anexo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_anexo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_anexo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_anexo_id_seq OWNED BY public.sip_anexo.id;


--
-- Name: sip_etiqueta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_etiqueta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_etiqueta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_etiqueta (
    id integer DEFAULT nextval('public.sip_etiqueta_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT etiqueta_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_fuenteprensa_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_fuenteprensa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_fuenteprensa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_fuenteprensa (
    id integer DEFAULT nextval('public.sip_fuenteprensa_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    tfuente character varying(25),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT sip_fuenteprensa_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_grupo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_grupo (
    id integer NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sip_grupo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_grupo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_grupo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_grupo_id_seq OWNED BY public.sip_grupo.id;


--
-- Name: sip_grupo_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_grupo_usuario (
    usuario_id integer NOT NULL,
    sip_grupo_id integer NOT NULL
);


--
-- Name: sip_grupoper_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_grupoper_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_grupoper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_grupoper (
    id integer DEFAULT nextval('public.sip_grupoper_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    anotaciones character varying(1000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sip_mundep_sinorden; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.sip_mundep_sinorden AS
 SELECT ((sip_departamento.id_deplocal * 1000) + sip_municipio.id_munlocal) AS idlocal,
    (((sip_municipio.nombre)::text || ' / '::text) || (sip_departamento.nombre)::text) AS nombre
   FROM (public.sip_municipio
     JOIN public.sip_departamento ON ((sip_municipio.id_departamento = sip_departamento.id)))
  WHERE ((sip_departamento.id_pais = 170) AND (sip_municipio.fechadeshabilitacion IS NULL) AND (sip_departamento.fechadeshabilitacion IS NULL))
UNION
 SELECT sip_departamento.id_deplocal AS idlocal,
    sip_departamento.nombre
   FROM public.sip_departamento
  WHERE ((sip_departamento.id_pais = 170) AND (sip_departamento.fechadeshabilitacion IS NULL));


--
-- Name: sip_mundep; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.sip_mundep AS
 SELECT sip_mundep_sinorden.idlocal,
    sip_mundep_sinorden.nombre,
    to_tsvector('spanish'::regconfig, public.unaccent(sip_mundep_sinorden.nombre)) AS mundep
   FROM public.sip_mundep_sinorden
  ORDER BY (sip_mundep_sinorden.nombre COLLATE public.es_co_utf_8)
  WITH NO DATA;


--
-- Name: sip_oficina_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_oficina_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_oficina; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_oficina (
    id integer DEFAULT nextval('public.sip_oficina_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT regionsjr_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_pais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_pais (
    id integer NOT NULL,
    nombre character varying(200) COLLATE public.es_co_utf_8 NOT NULL,
    nombreiso character varying(200) NOT NULL,
    latitud double precision,
    longitud double precision,
    alfa2 character varying(2),
    alfa3 character varying(3),
    codiso integer,
    div1 character varying(100),
    div2 character varying(100),
    div3 character varying(100),
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT pais_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_pais_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_pais_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_pais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_pais_id_seq OWNED BY public.sip_pais.id;


--
-- Name: sip_perfilactorsocial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_perfilactorsocial (
    id bigint NOT NULL,
    nombre character varying(500) NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sip_perfilactorsocial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_perfilactorsocial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_perfilactorsocial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_perfilactorsocial_id_seq OWNED BY public.sip_perfilactorsocial.id;


--
-- Name: sip_persona_trelacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_persona_trelacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_persona_trelacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_persona_trelacion (
    persona1 integer NOT NULL,
    persona2 integer NOT NULL,
    id_trelacion character(2) DEFAULT 'SI'::bpchar NOT NULL,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.sip_persona_trelacion_id_seq'::regclass) NOT NULL
);


--
-- Name: sip_sectoractor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_sectoractor (
    id bigint NOT NULL,
    nombre character varying(500) NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sip_sectoractor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_sectoractor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_sectoractor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_sectoractor_id_seq OWNED BY public.sip_sectoractor.id;


--
-- Name: sip_tclase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_tclase (
    id character varying(10) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT tclase_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_tdocumento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_tdocumento (
    id integer NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    sigla character varying(100),
    formatoregex character varying(500),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000) COLLATE public.es_co_utf_8
);


--
-- Name: sip_tdocumento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_tdocumento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_tdocumento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sip_tdocumento_id_seq OWNED BY public.sip_tdocumento.id;


--
-- Name: sip_trelacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_trelacion (
    id character(2) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    inverso character varying(2),
    CONSTRAINT trelacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_tsitio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sip_tsitio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_tsitio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sip_tsitio (
    id integer DEFAULT nextval('public.sip_tsitio_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000) COLLATE public.es_co_utf_8,
    CONSTRAINT tsitio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_actividadoficio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_actividadoficio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_actividadoficio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_actividadoficio (
    id integer DEFAULT nextval('public.sivel2_gen_actividadoficio_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT actividadoficio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_acto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_acto (
    id_presponsable integer NOT NULL,
    id_categoria integer NOT NULL,
    id_persona integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.acto_seq'::regclass) NOT NULL
);


--
-- Name: sivel2_gen_actocolectivo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_actocolectivo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_actocolectivo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_actocolectivo (
    id_presponsable integer NOT NULL,
    id_categoria integer NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.sivel2_gen_actocolectivo_id_seq'::regclass) NOT NULL
);


--
-- Name: sivel2_gen_anexo_caso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_anexo_caso (
    id integer DEFAULT nextval('public.anexo_seq'::regclass) NOT NULL,
    id_caso integer NOT NULL,
    fecha date NOT NULL,
    fuenteprensa_id integer,
    fechaffrecuente date,
    id_fotra integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_anexo integer NOT NULL
);


--
-- Name: sivel2_gen_antecedente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_antecedente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_antecedente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_antecedente (
    id integer DEFAULT nextval('public.sivel2_gen_antecedente_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT antecedente_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_antecedente_caso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_antecedente_caso (
    id_antecedente integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_antecedente_combatiente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_antecedente_combatiente (
    id_antecedente integer,
    id_combatiente integer
);


--
-- Name: sivel2_gen_antecedente_victima; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_antecedente_victima (
    id_antecedente integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_victima integer
);


--
-- Name: sivel2_gen_antecedente_victimacolectiva; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_antecedente_victimacolectiva (
    id_antecedente integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    victimacolectiva_id integer
);


--
-- Name: sivel2_gen_caso_categoria_presponsable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_caso_categoria_presponsable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_caso_categoria_presponsable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_categoria_presponsable (
    id_categoria integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_caso_presponsable integer NOT NULL,
    id integer DEFAULT nextval('public.sivel2_gen_caso_categoria_presponsable_id_seq'::regclass) NOT NULL
);


--
-- Name: sivel2_gen_caso_contexto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_contexto (
    id_caso integer NOT NULL,
    id_contexto integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_etiqueta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_etiqueta (
    id_caso integer NOT NULL,
    id_etiqueta integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha date NOT NULL,
    observaciones character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.caso_etiqueta_seq'::regclass) NOT NULL
);


--
-- Name: sivel2_gen_caso_fotra_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_caso_fotra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_caso_fotra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_fotra (
    id_caso integer NOT NULL,
    id_fotra integer,
    anotacion character varying(200),
    fecha date NOT NULL,
    ubicacionfisica character varying(100),
    tfuente character varying(25),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    id integer DEFAULT nextval('public.sivel2_gen_caso_fotra_seq'::regclass) NOT NULL,
    anexo_caso_id integer
);


--
-- Name: sivel2_gen_caso_frontera; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_frontera (
    id_frontera integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_fuenteprensa_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_caso_fuenteprensa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_caso_fuenteprensa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_fuenteprensa (
    fecha date NOT NULL,
    ubicacion character varying(100),
    clasificacion character varying(100),
    ubicacionfisica character varying(100),
    fuenteprensa_id integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.sivel2_gen_caso_fuenteprensa_seq'::regclass) NOT NULL,
    anexo_caso_id integer
);


--
-- Name: sivel2_gen_caso_presponsable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_presponsable (
    id_caso integer NOT NULL,
    id_presponsable integer NOT NULL,
    tipo integer DEFAULT 0 NOT NULL,
    bloque character varying(50),
    frente character varying(50),
    brigada character varying(50),
    batallon character varying(50),
    division character varying(50),
    otro character varying(500),
    id integer DEFAULT nextval('public.caso_presponsable_seq'::regclass) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_region (
    id_region integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_caso_usuario (
    id_usuario integer NOT NULL,
    id_caso integer NOT NULL,
    fechainicio date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_categoria (
    id integer NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    id_pconsolidado integer,
    contadaen integer,
    tipocat character(1) DEFAULT 'I'::bpchar,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    supracategoria_id integer,
    CONSTRAINT categoria_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion))),
    CONSTRAINT categoria_tipocat_check CHECK (((tipocat = 'I'::bpchar) OR (tipocat = 'C'::bpchar) OR (tipocat = 'O'::bpchar)))
);


--
-- Name: sivel2_gen_combatiente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_combatiente (
    id integer NOT NULL,
    nombre character varying(500) NOT NULL,
    alias character varying(500),
    edad integer,
    sexo character varying(1) DEFAULT 'S'::character varying NOT NULL,
    id_resagresion integer DEFAULT 1 NOT NULL,
    id_profesion integer DEFAULT 22,
    id_rangoedad integer DEFAULT 6,
    id_filiacion integer DEFAULT 10,
    id_sectorsocial integer DEFAULT 15,
    id_organizacion integer DEFAULT 16,
    id_vinculoestado integer DEFAULT 38,
    id_caso integer,
    organizacionarmada integer DEFAULT 35,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sivel2_gen_combatiente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_combatiente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_combatiente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sivel2_gen_combatiente_id_seq OWNED BY public.sivel2_gen_combatiente.id;


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
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id integer DEFAULT nextval('public.usuario_id_seq'::regclass) NOT NULL,
    nusuario character varying(15) NOT NULL,
    password character varying(64) DEFAULT ''::character varying NOT NULL,
    nombre character varying(50) COLLATE public.es_co_utf_8,
    descripcion character varying(50),
    rol integer DEFAULT 4,
    idioma character varying(6) DEFAULT 'es_CO'::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    sign_in_count integer DEFAULT 0 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    oficina_id integer,
    failed_attempts integer DEFAULT 0,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    CONSTRAINT usuario_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion))),
    CONSTRAINT usuario_rol_check CHECK ((rol >= 1))
);


--
-- Name: sivel2_gen_conscaso1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.sivel2_gen_conscaso1 AS
 SELECT casosjr.id_caso AS caso_id,
    array_to_string(ARRAY( SELECT (((persona.nombres)::text || ' '::text) || (persona.apellidos)::text)
           FROM public.sip_persona persona
          WHERE (persona.id = casosjr.contacto)), ', '::text) AS contacto,
    casosjr.fecharec,
    oficina.nombre AS oficina,
    usuario.nusuario,
    caso.fecha,
    statusmigratorio.nombre AS statusmigratorio,
    array_to_string(ARRAY( SELECT respuesta.fechaatencion
           FROM public.sivel2_sjr_respuesta respuesta
          WHERE (respuesta.id_caso = casosjr.id_caso)
          ORDER BY respuesta.fechaatencion DESC
         LIMIT 1), ', '::text) AS ultimaatencion_fecha,
    caso.memo,
    array_to_string(ARRAY( SELECT (((persona.nombres)::text || ' '::text) || (persona.apellidos)::text)
           FROM public.sip_persona persona,
            public.sivel2_gen_victima victima
          WHERE ((persona.id = victima.id_persona) AND (victima.id_caso = caso.id))), ', '::text) AS victimas
   FROM public.sivel2_sjr_casosjr casosjr,
    public.sivel2_gen_caso caso,
    public.sip_oficina oficina,
    public.usuario,
    public.sivel2_sjr_statusmigratorio statusmigratorio
  WHERE ((casosjr.id_caso = caso.id) AND (oficina.id = casosjr.oficina_id) AND (usuario.id = casosjr.asesor) AND (statusmigratorio.id = casosjr.id_statusmigratorio));


--
-- Name: sivel2_gen_conscaso; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.sivel2_gen_conscaso AS
 SELECT sivel2_gen_conscaso1.caso_id,
    sivel2_gen_conscaso1.contacto,
    sivel2_gen_conscaso1.fecharec,
    sivel2_gen_conscaso1.oficina,
    sivel2_gen_conscaso1.nusuario,
    sivel2_gen_conscaso1.fecha,
    sivel2_gen_conscaso1.statusmigratorio,
    sivel2_gen_conscaso1.ultimaatencion_fecha,
    sivel2_gen_conscaso1.memo,
    sivel2_gen_conscaso1.victimas,
    to_tsvector('spanish'::regconfig, public.unaccent(((((((((((((((((((sivel2_gen_conscaso1.caso_id || ' '::text) || sivel2_gen_conscaso1.contacto) || ' '::text) || replace(((sivel2_gen_conscaso1.fecharec)::character varying)::text, '-'::text, ' '::text)) || ' '::text) || (sivel2_gen_conscaso1.oficina)::text) || ' '::text) || (sivel2_gen_conscaso1.nusuario)::text) || ' '::text) || replace(((sivel2_gen_conscaso1.fecha)::character varying)::text, '-'::text, ' '::text)) || ' '::text) || (sivel2_gen_conscaso1.statusmigratorio)::text) || ' '::text) || replace(((sivel2_gen_conscaso1.ultimaatencion_fecha)::character varying)::text, '-'::text, ' '::text)) || ' '::text) || sivel2_gen_conscaso1.memo) || ' '::text) || sivel2_gen_conscaso1.victimas))) AS q
   FROM public.sivel2_gen_conscaso1
  WITH NO DATA;


--
-- Name: sivel2_gen_consexpcaso; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.sivel2_gen_consexpcaso AS
 SELECT conscaso.caso_id,
    conscaso.contacto,
    conscaso.fecharec,
    conscaso.oficina,
    conscaso.nusuario,
    conscaso.fecha,
    conscaso.statusmigratorio,
    conscaso.ultimaatencion_fecha,
    conscaso.memo,
    conscaso.victimas,
    conscaso.q,
    caso.titulo,
    caso.hora,
    caso.duracion,
    caso.grconfiabilidad,
    caso.gresclarecimiento,
    caso.grimpunidad,
    caso.grinformacion,
    caso.bienes,
    caso.id_intervalo,
    caso.created_at,
    caso.updated_at
   FROM (public.sivel2_gen_conscaso conscaso
     JOIN public.sivel2_gen_caso caso ON ((caso.id = conscaso.caso_id)))
  WHERE (true = false)
  WITH NO DATA;


--
-- Name: sivel2_gen_contexto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_contexto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_contexto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_contexto (
    id integer DEFAULT nextval('public.sivel2_gen_contexto_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT contexto_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_escolaridad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_escolaridad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_escolaridad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_escolaridad (
    id integer DEFAULT nextval('public.sivel2_gen_escolaridad_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT escolaridad_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_estadocivil_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_estadocivil_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_estadocivil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_estadocivil (
    id integer DEFAULT nextval('public.sivel2_gen_estadocivil_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT estadocivil_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_etnia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_etnia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_etnia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_etnia (
    id integer DEFAULT nextval('public.sivel2_gen_etnia_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    descripcion character varying(1000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT etnia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_filiacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_filiacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_filiacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_filiacion (
    id integer DEFAULT nextval('public.sivel2_gen_filiacion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT filiacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_filiacion_victimacolectiva; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_filiacion_victimacolectiva (
    id_filiacion integer DEFAULT 10 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    victimacolectiva_id integer
);


--
-- Name: sivel2_gen_fotra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_fotra (
    id integer DEFAULT nextval('public.fotra_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_frontera_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_frontera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_frontera; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_frontera (
    id integer DEFAULT nextval('public.sivel2_gen_frontera_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT frontera_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_iglesia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_iglesia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_iglesia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_iglesia (
    id integer DEFAULT nextval('public.sivel2_gen_iglesia_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    descripcion character varying(1000),
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT iglesia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_intervalo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_intervalo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_intervalo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_intervalo (
    id integer DEFAULT nextval('public.sivel2_gen_intervalo_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    rango character varying(25) NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT intervalo_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_maternidad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_maternidad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_maternidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_maternidad (
    id integer DEFAULT nextval('public.sivel2_gen_maternidad_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT maternidad_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_organizacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_organizacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_organizacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_organizacion (
    id integer DEFAULT nextval('public.sivel2_gen_organizacion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT organizacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_organizacion_victimacolectiva; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_organizacion_victimacolectiva (
    id_organizacion integer DEFAULT 16 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    victimacolectiva_id integer
);


--
-- Name: sivel2_gen_pconsolidado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_pconsolidado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_pconsolidado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_pconsolidado (
    id integer DEFAULT nextval('public.sivel2_gen_pconsolidado_id_seq'::regclass) NOT NULL,
    rotulo character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    tipoviolencia character varying(25) NOT NULL,
    clasificacion character varying(25) NOT NULL,
    peso integer DEFAULT 0,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT pconsolidado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_presponsable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_presponsable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_presponsable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_presponsable (
    id integer DEFAULT nextval('public.sivel2_gen_presponsable_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    papa integer,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT presponsable_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_profesion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_profesion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_profesion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_profesion (
    id integer DEFAULT nextval('public.sivel2_gen_profesion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT profesion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_profesion_victimacolectiva; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_profesion_victimacolectiva (
    id_profesion integer DEFAULT 22 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    victimacolectiva_id integer
);


--
-- Name: sivel2_gen_rangoedad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_rangoedad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_rangoedad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_rangoedad (
    id integer DEFAULT nextval('public.sivel2_gen_rangoedad_id_seq'::regclass) NOT NULL,
    nombre character varying(20) COLLATE public.es_co_utf_8 NOT NULL,
    rango character varying(20),
    limiteinferior integer DEFAULT 0 NOT NULL,
    limitesuperior integer DEFAULT 0 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT rangoedad_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_rangoedad_victimacolectiva; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_rangoedad_victimacolectiva (
    id_rangoedad integer DEFAULT 6 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    victimacolectiva_id integer
);


--
-- Name: sivel2_gen_region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_region (
    id integer DEFAULT nextval('public.sivel2_gen_region_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT region_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_resagresion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_resagresion (
    id integer NOT NULL,
    nombre character varying(500) NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sivel2_gen_resagresion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_resagresion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_resagresion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sivel2_gen_resagresion_id_seq OWNED BY public.sivel2_gen_resagresion.id;


--
-- Name: sivel2_gen_sectorsocial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_sectorsocial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_sectorsocial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_sectorsocial (
    id integer DEFAULT nextval('public.sivel2_gen_sectorsocial_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT sectorsocial_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_sectorsocial_victimacolectiva; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_sectorsocial_victimacolectiva (
    id_sectorsocial integer DEFAULT 15 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    victimacolectiva_id integer
);


--
-- Name: sivel2_gen_supracategoria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_supracategoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_supracategoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_supracategoria (
    codigo integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    id_tviolencia character varying(1) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    id integer DEFAULT nextval('public.sivel2_gen_supracategoria_id_seq'::regclass) NOT NULL,
    CONSTRAINT supracategoria_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_tviolencia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_tviolencia (
    id character(1) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    nomcorto character varying(10) NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT tviolencia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_victimacolectiva_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_victimacolectiva_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_victimacolectiva; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_victimacolectiva (
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    personasaprox integer,
    organizacionarmada integer DEFAULT 35,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('public.sivel2_gen_victimacolectiva_id_seq'::regclass) NOT NULL
);


--
-- Name: sivel2_gen_victimacolectiva_vinculoestado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_victimacolectiva_vinculoestado (
    id_vinculoestado integer DEFAULT 38 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    victimacolectiva_id integer
);


--
-- Name: sivel2_gen_vinculoestado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sivel2_gen_vinculoestado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_vinculoestado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_gen_vinculoestado (
    id integer DEFAULT nextval('public.sivel2_gen_vinculoestado_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT vinculoestado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
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
-- Name: sivel2_sjr_regimensalud; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sivel2_sjr_regimensalud (
    id integer DEFAULT nextval('public.regimensalud_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-05-13'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT regimensalud_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


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
-- Name: vvictimasoundexesp; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.vvictimasoundexesp AS
 SELECT sivel2_gen_victima.id_caso,
    sip_persona.id AS id_persona,
    (((sip_persona.nombres)::text || ' '::text) || (sip_persona.apellidos)::text) AS nomap,
    ( SELECT array_to_string(array_agg(public.soundexesp(n.s)), ' '::text) AS array_to_string
           FROM ( SELECT unnest(string_to_array(regexp_replace((((sip_persona.nombres)::text || ' '::text) || (sip_persona.apellidos)::text), '  *'::text, ' '::text), ' '::text)) AS s
                  ORDER BY (unnest(string_to_array(regexp_replace((((sip_persona.nombres)::text || ' '::text) || (sip_persona.apellidos)::text), '  *'::text, ' '::text), ' '::text)))) n) AS nomsoundexesp
   FROM public.sip_persona,
    public.sivel2_gen_victima
  WHERE (sip_persona.id = sivel2_gen_victima.id_persona)
  WITH NO DATA;


--
-- Name: cor1440_gen_actividad id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividad_id_seq'::regclass);


--
-- Name: cor1440_gen_actividad_proyecto id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_proyecto ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividad_proyecto_id_seq'::regclass);


--
-- Name: cor1440_gen_actividad_rangoedadac id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_rangoedadac ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividad_rangoedadac_id_seq'::regclass);


--
-- Name: cor1440_gen_actividad_valorcampotind id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_valorcampotind ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividad_valorcampotind_id_seq'::regclass);


--
-- Name: cor1440_gen_actividadarea id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadarea ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividadarea_id_seq'::regclass);


--
-- Name: cor1440_gen_actividadareas_actividad id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadareas_actividad ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividadareas_actividad_id_seq'::regclass);


--
-- Name: cor1440_gen_actividadpf id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadpf ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividadpf_id_seq'::regclass);


--
-- Name: cor1440_gen_actividadtipo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadtipo ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_actividadtipo_id_seq'::regclass);


--
-- Name: cor1440_gen_asistencia id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_asistencia ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_asistencia_id_seq'::regclass);


--
-- Name: cor1440_gen_campoact id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_campoact ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_campoact_id_seq'::regclass);


--
-- Name: cor1440_gen_campotind id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_campotind ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_campotind_id_seq'::regclass);


--
-- Name: cor1440_gen_financiador id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_financiador ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_financiador_id_seq'::regclass);


--
-- Name: cor1440_gen_indicadorpf id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_indicadorpf ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_indicadorpf_id_seq'::regclass);


--
-- Name: cor1440_gen_informe id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_informe ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_informe_id_seq'::regclass);


--
-- Name: cor1440_gen_objetivopf id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_objetivopf ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_objetivopf_id_seq'::regclass);


--
-- Name: cor1440_gen_proyecto id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_proyecto ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_proyecto_id_seq'::regclass);


--
-- Name: cor1440_gen_proyectofinanciero id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_proyectofinanciero ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_proyectofinanciero_id_seq'::regclass);


--
-- Name: cor1440_gen_rangoedadac id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_rangoedadac ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_rangoedadac_id_seq'::regclass);


--
-- Name: cor1440_gen_resultadopf id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_resultadopf ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_resultadopf_id_seq'::regclass);


--
-- Name: cor1440_gen_tipoindicador id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_tipoindicador ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_tipoindicador_id_seq'::regclass);


--
-- Name: cor1440_gen_valorcampoact id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_valorcampoact ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_valorcampoact_id_seq'::regclass);


--
-- Name: cor1440_gen_valorcampotind id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_valorcampotind ALTER COLUMN id SET DEFAULT nextval('public.cor1440_gen_valorcampotind_id_seq'::regclass);


--
-- Name: heb412_gen_campohc id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campohc ALTER COLUMN id SET DEFAULT nextval('public.heb412_gen_campohc_id_seq'::regclass);


--
-- Name: heb412_gen_campoplantillahcm id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campoplantillahcm ALTER COLUMN id SET DEFAULT nextval('public.heb412_gen_campoplantillahcm_id_seq'::regclass);


--
-- Name: heb412_gen_campoplantillahcr id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campoplantillahcr ALTER COLUMN id SET DEFAULT nextval('public.heb412_gen_campoplantillahcr_id_seq'::regclass);


--
-- Name: heb412_gen_doc id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_doc ALTER COLUMN id SET DEFAULT nextval('public.heb412_gen_doc_id_seq'::regclass);


--
-- Name: heb412_gen_plantilladoc id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_plantilladoc ALTER COLUMN id SET DEFAULT nextval('public.heb412_gen_plantilladoc_id_seq'::regclass);


--
-- Name: heb412_gen_plantillahcm id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_plantillahcm ALTER COLUMN id SET DEFAULT nextval('public.heb412_gen_plantillahcm_id_seq'::regclass);


--
-- Name: heb412_gen_plantillahcr id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_plantillahcr ALTER COLUMN id SET DEFAULT nextval('public.heb412_gen_plantillahcr_id_seq'::regclass);


--
-- Name: sip_actorsocial id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial ALTER COLUMN id SET DEFAULT nextval('public.sip_actorsocial_id_seq'::regclass);


--
-- Name: sip_actorsocial_persona id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial_persona ALTER COLUMN id SET DEFAULT nextval('public.sip_actorsocial_persona_id_seq'::regclass);


--
-- Name: sip_anexo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_anexo ALTER COLUMN id SET DEFAULT nextval('public.sip_anexo_id_seq'::regclass);


--
-- Name: sip_grupo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_grupo ALTER COLUMN id SET DEFAULT nextval('public.sip_grupo_id_seq'::regclass);


--
-- Name: sip_pais id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_pais ALTER COLUMN id SET DEFAULT nextval('public.sip_pais_id_seq'::regclass);


--
-- Name: sip_perfilactorsocial id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_perfilactorsocial ALTER COLUMN id SET DEFAULT nextval('public.sip_perfilactorsocial_id_seq'::regclass);


--
-- Name: sip_sectoractor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_sectoractor ALTER COLUMN id SET DEFAULT nextval('public.sip_sectoractor_id_seq'::regclass);


--
-- Name: sip_tdocumento id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_tdocumento ALTER COLUMN id SET DEFAULT nextval('public.sip_tdocumento_id_seq'::regclass);


--
-- Name: sivel2_gen_combatiente id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente ALTER COLUMN id SET DEFAULT nextval('public.sivel2_gen_combatiente_id_seq'::regclass);


--
-- Name: sivel2_gen_resagresion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_resagresion ALTER COLUMN id SET DEFAULT nextval('public.sivel2_gen_resagresion_id_seq'::regclass);


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
-- Name: cor1440_gen_actividad actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad
    ADD CONSTRAINT actividad_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividad_rangoedadac actividad_rangoedadac_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_rangoedadac
    ADD CONSTRAINT actividad_rangoedadac_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividadarea actividadarea_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadarea
    ADD CONSTRAINT actividadarea_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividadareas_actividad actividadareas_actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadareas_actividad
    ADD CONSTRAINT actividadareas_actividad_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_actividadoficio actividadoficio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actividadoficio
    ADD CONSTRAINT actividadoficio_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_acto acto_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_acto
    ADD CONSTRAINT acto_id_key UNIQUE (id);


--
-- Name: sivel2_gen_acto acto_id_presponsable_id_categoria_id_persona_id_caso_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_acto
    ADD CONSTRAINT acto_id_presponsable_id_categoria_id_persona_id_caso_key UNIQUE (id_presponsable, id_categoria, id_persona, id_caso);


--
-- Name: sivel2_gen_acto acto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_acto
    ADD CONSTRAINT acto_pkey PRIMARY KEY (id);


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
-- Name: sivel2_gen_anexo_caso anexo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_pkey PRIMARY KEY (id);


--
-- Name: sip_anexo anexoactividad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_anexo
    ADD CONSTRAINT anexoactividad_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_antecedente antecedente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente
    ADD CONSTRAINT antecedente_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


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
-- Name: sivel2_gen_caso_etiqueta caso_etiqueta_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_key UNIQUE (id);


--
-- Name: sivel2_gen_caso_etiqueta caso_etiqueta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_caso caso_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso
    ADD CONSTRAINT caso_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_caso_presponsable caso_presponsable_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_id_key UNIQUE (id);


--
-- Name: sivel2_gen_caso_presponsable caso_presponsable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_caso_usuario caso_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_usuario_pkey PRIMARY KEY (id_usuario, id_caso);


--
-- Name: sivel2_sjr_casosjr casosjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_pkey PRIMARY KEY (id_caso);


--
-- Name: sivel2_gen_categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


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
-- Name: sivel2_gen_contexto contexto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_contexto
    ADD CONSTRAINT contexto_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividad_proyecto cor1440_gen_actividad_proyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_proyecto
    ADD CONSTRAINT cor1440_gen_actividad_proyecto_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividad_sip_anexo cor1440_gen_actividad_sip_anexo_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT cor1440_gen_actividad_sip_anexo_id_key UNIQUE (id);


--
-- Name: cor1440_gen_actividad_sip_anexo cor1440_gen_actividad_sip_anexo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT cor1440_gen_actividad_sip_anexo_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividad_valorcampotind cor1440_gen_actividad_valorcampotind_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_valorcampotind
    ADD CONSTRAINT cor1440_gen_actividad_valorcampotind_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividadpf cor1440_gen_actividadpf_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadpf
    ADD CONSTRAINT cor1440_gen_actividadpf_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividadtipo cor1440_gen_actividadtipo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadtipo
    ADD CONSTRAINT cor1440_gen_actividadtipo_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_asistencia cor1440_gen_asistencia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_asistencia
    ADD CONSTRAINT cor1440_gen_asistencia_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_campoact cor1440_gen_campoact_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_campoact
    ADD CONSTRAINT cor1440_gen_campoact_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_campotind cor1440_gen_campotind_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_campotind
    ADD CONSTRAINT cor1440_gen_campotind_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_financiador cor1440_gen_financiador_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_financiador
    ADD CONSTRAINT cor1440_gen_financiador_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_indicadorpf cor1440_gen_indicadorpf_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_indicadorpf
    ADD CONSTRAINT cor1440_gen_indicadorpf_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_informe cor1440_gen_informe_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_informe
    ADD CONSTRAINT cor1440_gen_informe_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_objetivopf cor1440_gen_objetivopf_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_objetivopf
    ADD CONSTRAINT cor1440_gen_objetivopf_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_proyecto cor1440_gen_proyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_proyecto
    ADD CONSTRAINT cor1440_gen_proyecto_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_proyectofinanciero cor1440_gen_proyectofinanciero_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_proyectofinanciero
    ADD CONSTRAINT cor1440_gen_proyectofinanciero_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_resultadopf cor1440_gen_resultadopf_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_resultadopf
    ADD CONSTRAINT cor1440_gen_resultadopf_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_tipoindicador cor1440_gen_tipoindicador_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_tipoindicador
    ADD CONSTRAINT cor1440_gen_tipoindicador_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_valorcampoact cor1440_gen_valorcampoact_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_valorcampoact
    ADD CONSTRAINT cor1440_gen_valorcampoact_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_valorcampotind cor1440_gen_valorcampotind_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_valorcampotind
    ADD CONSTRAINT cor1440_gen_valorcampotind_pkey PRIMARY KEY (id);


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
-- Name: sivel2_gen_escolaridad escolaridad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_escolaridad
    ADD CONSTRAINT escolaridad_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_estadocivil estadocivil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_estadocivil
    ADD CONSTRAINT estadocivil_pkey PRIMARY KEY (id);


--
-- Name: sip_etiqueta etiqueta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_etiqueta
    ADD CONSTRAINT etiqueta_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_etiqueta_usuario etiqueta_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_etiqueta_usuario
    ADD CONSTRAINT etiqueta_usuario_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_etnia etnia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_etnia
    ADD CONSTRAINT etnia_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_filiacion filiacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_filiacion
    ADD CONSTRAINT filiacion_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_fotra fotra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_fotra
    ADD CONSTRAINT fotra_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_frontera frontera_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_frontera
    ADD CONSTRAINT frontera_pkey PRIMARY KEY (id);


--
-- Name: heb412_gen_campohc heb412_gen_campohc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campohc
    ADD CONSTRAINT heb412_gen_campohc_pkey PRIMARY KEY (id);


--
-- Name: heb412_gen_campoplantillahcm heb412_gen_campoplantillahcm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campoplantillahcm
    ADD CONSTRAINT heb412_gen_campoplantillahcm_pkey PRIMARY KEY (id);


--
-- Name: heb412_gen_campoplantillahcr heb412_gen_campoplantillahcr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campoplantillahcr
    ADD CONSTRAINT heb412_gen_campoplantillahcr_pkey PRIMARY KEY (id);


--
-- Name: heb412_gen_doc heb412_gen_doc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_doc
    ADD CONSTRAINT heb412_gen_doc_pkey PRIMARY KEY (id);


--
-- Name: heb412_gen_plantilladoc heb412_gen_plantilladoc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_plantilladoc
    ADD CONSTRAINT heb412_gen_plantilladoc_pkey PRIMARY KEY (id);


--
-- Name: heb412_gen_plantillahcm heb412_gen_plantillahcm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_plantillahcm
    ADD CONSTRAINT heb412_gen_plantillahcm_pkey PRIMARY KEY (id);


--
-- Name: heb412_gen_plantillahcr heb412_gen_plantillahcr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_plantillahcr
    ADD CONSTRAINT heb412_gen_plantillahcr_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_idioma idioma_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_idioma
    ADD CONSTRAINT idioma_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_iglesia iglesia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_iglesia
    ADD CONSTRAINT iglesia_pkey PRIMARY KEY (id);


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
-- Name: sivel2_gen_intervalo intervalo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_intervalo
    ADD CONSTRAINT intervalo_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_maternidad maternidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_maternidad
    ADD CONSTRAINT maternidad_pkey PRIMARY KEY (id);


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
-- Name: sivel2_gen_organizacion organizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_organizacion
    ADD CONSTRAINT organizacion_pkey PRIMARY KEY (id);


--
-- Name: sip_pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_pconsolidado pconsolidado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_pconsolidado
    ADD CONSTRAINT pconsolidado_pkey PRIMARY KEY (id);


--
-- Name: sip_persona persona_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_personadesea personadesea_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_personadesea
    ADD CONSTRAINT personadesea_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_presponsable presponsable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_presponsable
    ADD CONSTRAINT presponsable_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_profesion profesion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_profesion
    ADD CONSTRAINT profesion_pkey PRIMARY KEY (id);


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
-- Name: sivel2_gen_rangoedad rangoedad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_rangoedad
    ADD CONSTRAINT rangoedad_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_rangoedadac rangoedadac_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_rangoedadac
    ADD CONSTRAINT rangoedadac_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_refugio refugio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_refugio
    ADD CONSTRAINT refugio_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_regimensalud regimensalud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_regimensalud
    ADD CONSTRAINT regimensalud_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_region region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: sip_oficina regionsjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_oficina
    ADD CONSTRAINT regionsjr_pkey PRIMARY KEY (id);


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
-- Name: sivel2_gen_sectorsocial sectorsocial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_sectorsocial
    ADD CONSTRAINT sectorsocial_pkey PRIMARY KEY (id);


--
-- Name: sip_actorsocial_persona sip_actorsocial_persona_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial_persona
    ADD CONSTRAINT sip_actorsocial_persona_pkey PRIMARY KEY (id);


--
-- Name: sip_actorsocial sip_actorsocial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial
    ADD CONSTRAINT sip_actorsocial_pkey PRIMARY KEY (id);


--
-- Name: sip_clase sip_clase_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_clase
    ADD CONSTRAINT sip_clase_id_key UNIQUE (id);


--
-- Name: sip_clase sip_clase_id_municipio_id_clalocal_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_clase
    ADD CONSTRAINT sip_clase_id_municipio_id_clalocal_key UNIQUE (id_municipio, id_clalocal);


--
-- Name: sip_clase sip_clase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_clase
    ADD CONSTRAINT sip_clase_pkey PRIMARY KEY (id);


--
-- Name: sip_departamento sip_departamento_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_departamento
    ADD CONSTRAINT sip_departamento_id_key UNIQUE (id);


--
-- Name: sip_departamento sip_departamento_id_pais_id_deplocal_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_departamento
    ADD CONSTRAINT sip_departamento_id_pais_id_deplocal_key UNIQUE (id_pais, id_deplocal);


--
-- Name: sip_departamento sip_departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_departamento
    ADD CONSTRAINT sip_departamento_pkey PRIMARY KEY (id);


--
-- Name: sip_fuenteprensa sip_fuenteprensa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_fuenteprensa
    ADD CONSTRAINT sip_fuenteprensa_pkey PRIMARY KEY (id);


--
-- Name: sip_grupo sip_grupo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_grupo
    ADD CONSTRAINT sip_grupo_pkey PRIMARY KEY (id);


--
-- Name: sip_grupoper sip_grupoper_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_grupoper
    ADD CONSTRAINT sip_grupoper_pkey PRIMARY KEY (id);


--
-- Name: sip_municipio sip_municipio_id_departamento_id_munlocal_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_municipio
    ADD CONSTRAINT sip_municipio_id_departamento_id_munlocal_key UNIQUE (id_departamento, id_munlocal);


--
-- Name: sip_municipio sip_municipio_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_municipio
    ADD CONSTRAINT sip_municipio_id_key UNIQUE (id);


--
-- Name: sip_municipio sip_municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_municipio
    ADD CONSTRAINT sip_municipio_pkey PRIMARY KEY (id);


--
-- Name: sip_perfilactorsocial sip_perfilactorsocial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_perfilactorsocial
    ADD CONSTRAINT sip_perfilactorsocial_pkey PRIMARY KEY (id);


--
-- Name: sip_persona_trelacion sip_persona_trelacion_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona_trelacion
    ADD CONSTRAINT sip_persona_trelacion_id_key UNIQUE (id);


--
-- Name: sip_persona_trelacion sip_persona_trelacion_persona1_persona2_id_trelacion_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona_trelacion
    ADD CONSTRAINT sip_persona_trelacion_persona1_persona2_id_trelacion_key UNIQUE (persona1, persona2, id_trelacion);


--
-- Name: sip_persona_trelacion sip_persona_trelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona_trelacion
    ADD CONSTRAINT sip_persona_trelacion_pkey PRIMARY KEY (id);


--
-- Name: sip_sectoractor sip_sectoractor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_sectoractor
    ADD CONSTRAINT sip_sectoractor_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_actocolectivo sivel2_gen_actocolectivo_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actocolectivo
    ADD CONSTRAINT sivel2_gen_actocolectivo_id_key UNIQUE (id);


--
-- Name: sivel2_gen_actocolectivo sivel2_gen_actocolectivo_id_presponsable_id_categoria_id_gr_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actocolectivo
    ADD CONSTRAINT sivel2_gen_actocolectivo_id_presponsable_id_categoria_id_gr_key UNIQUE (id_presponsable, id_categoria, id_grupoper, id_caso);


--
-- Name: sivel2_gen_actocolectivo sivel2_gen_actocolectivo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actocolectivo
    ADD CONSTRAINT sivel2_gen_actocolectivo_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_caso_categoria_presponsable sivel2_gen_caso_categoria_pre_id_caso_presponsable_id_categ_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT sivel2_gen_caso_categoria_pre_id_caso_presponsable_id_categ_key UNIQUE (id_caso_presponsable, id_categoria);


--
-- Name: sivel2_gen_caso_categoria_presponsable sivel2_gen_caso_categoria_presponsable_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT sivel2_gen_caso_categoria_presponsable_id_key UNIQUE (id);


--
-- Name: sivel2_gen_caso_categoria_presponsable sivel2_gen_caso_categoria_presponsable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT sivel2_gen_caso_categoria_presponsable_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_caso_fotra sivel2_gen_caso_fotra_id_caso_nombre_fecha_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fotra
    ADD CONSTRAINT sivel2_gen_caso_fotra_id_caso_nombre_fecha_key UNIQUE (id_caso, nombre, fecha);


--
-- Name: sivel2_gen_caso_fotra sivel2_gen_caso_fotra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fotra
    ADD CONSTRAINT sivel2_gen_caso_fotra_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_caso_fuenteprensa sivel2_gen_caso_fuenteprensa_id_caso_fecha_fuenteprensa_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_id_caso_fecha_fuenteprensa_id_key UNIQUE (id_caso, fecha, fuenteprensa_id);


--
-- Name: sivel2_gen_caso_fuenteprensa sivel2_gen_caso_fuenteprensa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_combatiente sivel2_gen_combatiente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT sivel2_gen_combatiente_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_resagresion sivel2_gen_resagresion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_resagresion
    ADD CONSTRAINT sivel2_gen_resagresion_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_supracategoria sivel2_gen_supracategoria_id_tviolencia_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_supracategoria
    ADD CONSTRAINT sivel2_gen_supracategoria_id_tviolencia_codigo_key UNIQUE (id_tviolencia, codigo);


--
-- Name: sivel2_gen_supracategoria sivel2_gen_supracategoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_supracategoria
    ADD CONSTRAINT sivel2_gen_supracategoria_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_victimacolectiva sivel2_gen_victimacolectiva_id_caso_id_grupoper_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva
    ADD CONSTRAINT sivel2_gen_victimacolectiva_id_caso_id_grupoper_key UNIQUE (id_caso, id_grupoper);


--
-- Name: sivel2_gen_victimacolectiva sivel2_gen_victimacolectiva_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva
    ADD CONSTRAINT sivel2_gen_victimacolectiva_id_key UNIQUE (id);


--
-- Name: sivel2_gen_victimacolectiva sivel2_gen_victimacolectiva_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva
    ADD CONSTRAINT sivel2_gen_victimacolectiva_pkey PRIMARY KEY (id);


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
-- Name: sip_tclase tclase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_tclase
    ADD CONSTRAINT tclase_pkey PRIMARY KEY (id);


--
-- Name: sip_tdocumento tdocumento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_tdocumento
    ADD CONSTRAINT tdocumento_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_tipodesp tipodesp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_tipodesp
    ADD CONSTRAINT tipodesp_pkey PRIMARY KEY (id);


--
-- Name: sip_trelacion trelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_trelacion
    ADD CONSTRAINT trelacion_pkey PRIMARY KEY (id);


--
-- Name: sip_tsitio tsitio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_tsitio
    ADD CONSTRAINT tsitio_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_tviolencia tviolencia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_tviolencia
    ADD CONSTRAINT tviolencia_pkey PRIMARY KEY (id);


--
-- Name: sip_ubicacion ubicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_ubicacion
    ADD CONSTRAINT ubicacion_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_nusuario_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_nusuario_key UNIQUE (nusuario);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_victima victima_id_caso_id_persona_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key UNIQUE (id_caso, id_persona);


--
-- Name: sivel2_gen_victima victima_id_caso_id_persona_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key1 UNIQUE (id_caso, id_persona);


--
-- Name: sivel2_gen_victima victima_id_caso_id_persona_key2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key2 UNIQUE (id_caso, id_persona);


--
-- Name: sivel2_gen_victima victima_id_caso_id_persona_key3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key3 UNIQUE (id_caso, id_persona);


--
-- Name: sivel2_gen_victima victima_id_caso_id_persona_key4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key4 UNIQUE (id_caso, id_persona);


--
-- Name: sivel2_gen_victima victima_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_key UNIQUE (id);


--
-- Name: sivel2_gen_victima victima_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_pkey PRIMARY KEY (id);


--
-- Name: sivel2_sjr_victimasjr victimasjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_pkey PRIMARY KEY (id_victima);


--
-- Name: sivel2_gen_vinculoestado vinculoestado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_vinculoestado
    ADD CONSTRAINT vinculoestado_pkey PRIMARY KEY (id);


--
-- Name: busca_conscaso; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX busca_conscaso ON public.sivel2_gen_conscaso USING gin (q);


--
-- Name: index_cor1440_gen_actividad_on_usuario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cor1440_gen_actividad_on_usuario_id ON public.cor1440_gen_actividad USING btree (usuario_id);


--
-- Name: index_cor1440_gen_actividad_sip_anexo_on_anexo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cor1440_gen_actividad_sip_anexo_on_anexo_id ON public.cor1440_gen_actividad_sip_anexo USING btree (anexo_id);


--
-- Name: index_heb412_gen_doc_on_tdoc_type_and_tdoc_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_heb412_gen_doc_on_tdoc_type_and_tdoc_id ON public.heb412_gen_doc USING btree (tdoc_type, tdoc_id);


--
-- Name: index_sip_actorsocial_on_grupoper_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sip_actorsocial_on_grupoper_id ON public.sip_actorsocial USING btree (grupoper_id);


--
-- Name: index_sip_actorsocial_on_pais_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sip_actorsocial_on_pais_id ON public.sip_actorsocial USING btree (pais_id);


--
-- Name: index_sivel2_gen_actividad_on_rangoedadac_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sivel2_gen_actividad_on_rangoedadac_id ON public.cor1440_gen_actividad USING btree (rangoedadac_id);


--
-- Name: index_sivel2_gen_actividad_rangoedadac_on_actividad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sivel2_gen_actividad_rangoedadac_on_actividad_id ON public.cor1440_gen_actividad_rangoedadac USING btree (actividad_id);


--
-- Name: index_sivel2_gen_actividad_rangoedadac_on_rangoedadac_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sivel2_gen_actividad_rangoedadac_on_rangoedadac_id ON public.cor1440_gen_actividad_rangoedadac USING btree (rangoedadac_id);


--
-- Name: index_sivel2_gen_antecedente_combatiente_on_id_antecedente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sivel2_gen_antecedente_combatiente_on_id_antecedente ON public.sivel2_gen_antecedente_combatiente USING btree (id_antecedente);


--
-- Name: index_sivel2_gen_antecedente_combatiente_on_id_combatiente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sivel2_gen_antecedente_combatiente_on_id_combatiente ON public.sivel2_gen_antecedente_combatiente USING btree (id_combatiente);


--
-- Name: index_sivel2_sjr_casosjr_on_comosupo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sivel2_sjr_casosjr_on_comosupo_id ON public.sivel2_sjr_casosjr USING btree (comosupo_id);


--
-- Name: index_usuario_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_usuario_on_email ON public.usuario USING btree (email);


--
-- Name: index_usuario_on_regionsjr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_usuario_on_regionsjr_id ON public.usuario USING btree (oficina_id);


--
-- Name: index_usuario_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_usuario_on_reset_password_token ON public.usuario USING btree (reset_password_token);


--
-- Name: sip_busca_mundep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sip_busca_mundep ON public.sip_mundep USING gin (mundep);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: usuario_nusuario; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX usuario_nusuario ON public.usuario USING btree (nusuario);


--
-- Name: cor1440_gen_actividad actividad_regionsjr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad
    ADD CONSTRAINT actividad_regionsjr_id_fkey FOREIGN KEY (oficina_id) REFERENCES public.sip_oficina(id);


--
-- Name: sivel2_gen_acto acto_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_acto
    ADD CONSTRAINT acto_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_acto acto_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_acto
    ADD CONSTRAINT acto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.sivel2_gen_categoria(id);


--
-- Name: sivel2_gen_acto acto_id_persona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_acto
    ADD CONSTRAINT acto_id_persona_fkey FOREIGN KEY (id_persona) REFERENCES public.sip_persona(id);


--
-- Name: sivel2_gen_acto acto_id_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_acto
    ADD CONSTRAINT acto_id_presponsable_fkey FOREIGN KEY (id_presponsable) REFERENCES public.sivel2_gen_presponsable(id);


--
-- Name: sivel2_gen_actocolectivo actocolectivo_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_actocolectivo actocolectivo_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.sivel2_gen_categoria(id);


--
-- Name: sivel2_gen_actocolectivo actocolectivo_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES public.sip_grupoper(id);


--
-- Name: sivel2_gen_actocolectivo actocolectivo_id_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_presponsable_fkey FOREIGN KEY (id_presponsable) REFERENCES public.sivel2_gen_presponsable(id);


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
-- Name: sivel2_gen_anexo_caso anexo_fuenteprensa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_fuenteprensa_id_fkey FOREIGN KEY (fuenteprensa_id) REFERENCES public.sip_fuenteprensa(id);


--
-- Name: sivel2_gen_anexo_caso anexo_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_anexo_caso anexo_id_fotra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_id_fotra_fkey FOREIGN KEY (id_fotra) REFERENCES public.sivel2_gen_fotra(id);


--
-- Name: sivel2_gen_antecedente_caso antecedente_caso_id_antecedente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_caso
    ADD CONSTRAINT antecedente_caso_id_antecedente_fkey FOREIGN KEY (id_antecedente) REFERENCES public.sivel2_gen_antecedente(id);


--
-- Name: sivel2_gen_antecedente_caso antecedente_caso_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_caso
    ADD CONSTRAINT antecedente_caso_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_antecedente_victimacolectiva antecedente_comunidad_id_antecedente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_victimacolectiva
    ADD CONSTRAINT antecedente_comunidad_id_antecedente_fkey FOREIGN KEY (id_antecedente) REFERENCES public.sivel2_gen_antecedente(id);


--
-- Name: sivel2_gen_antecedente_victima antecedente_victima_id_antecedente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_victima
    ADD CONSTRAINT antecedente_victima_id_antecedente_fkey FOREIGN KEY (id_antecedente) REFERENCES public.sivel2_gen_antecedente(id);


--
-- Name: sivel2_gen_antecedente_victima antecedente_victima_id_victima_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_victima
    ADD CONSTRAINT antecedente_victima_id_victima_fkey FOREIGN KEY (id_victima) REFERENCES public.sivel2_gen_victima(id);


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
-- Name: sivel2_gen_caso_categoria_presponsable caso_categoria_presponsable_id_caso_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_id_caso_presponsable_fkey FOREIGN KEY (id_caso_presponsable) REFERENCES public.sivel2_gen_caso_presponsable(id);


--
-- Name: sivel2_gen_caso_categoria_presponsable caso_categoria_presponsable_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.sivel2_gen_categoria(id);


--
-- Name: sivel2_gen_caso_contexto caso_contexto_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_contexto
    ADD CONSTRAINT caso_contexto_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_contexto caso_contexto_id_contexto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_contexto
    ADD CONSTRAINT caso_contexto_id_contexto_fkey FOREIGN KEY (id_contexto) REFERENCES public.sivel2_gen_contexto(id);


--
-- Name: sivel2_gen_caso_etiqueta caso_etiqueta_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_etiqueta caso_etiqueta_id_etiqueta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_etiqueta_fkey FOREIGN KEY (id_etiqueta) REFERENCES public.sip_etiqueta(id);


--
-- Name: sivel2_gen_caso_etiqueta caso_etiqueta_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id);


--
-- Name: sivel2_gen_caso_fotra caso_fotra_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fotra
    ADD CONSTRAINT caso_fotra_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_fotra caso_fotra_id_fotra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fotra
    ADD CONSTRAINT caso_fotra_id_fotra_fkey FOREIGN KEY (id_fotra) REFERENCES public.sivel2_gen_fotra(id);


--
-- Name: sivel2_gen_caso_frontera caso_frontera_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_frontera
    ADD CONSTRAINT caso_frontera_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_frontera caso_frontera_id_frontera_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_frontera
    ADD CONSTRAINT caso_frontera_id_frontera_fkey FOREIGN KEY (id_frontera) REFERENCES public.sivel2_gen_frontera(id);


--
-- Name: sivel2_gen_caso_usuario caso_funcionario_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_funcionario_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_presponsable caso_presponsable_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_presponsable caso_presponsable_id_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_id_presponsable_fkey FOREIGN KEY (id_presponsable) REFERENCES public.sivel2_gen_presponsable(id);


--
-- Name: sivel2_gen_caso_region caso_region_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_region
    ADD CONSTRAINT caso_region_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_region caso_region_id_region_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_region
    ADD CONSTRAINT caso_region_id_region_fkey FOREIGN KEY (id_region) REFERENCES public.sivel2_gen_region(id);


--
-- Name: sivel2_gen_caso_usuario caso_usuario_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_usuario_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_caso_usuario caso_usuario_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_usuario_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id);


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
-- Name: sivel2_gen_categoria categoria_contadaen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_categoria
    ADD CONSTRAINT categoria_contadaen_fkey FOREIGN KEY (contadaen) REFERENCES public.sivel2_gen_categoria(id);


--
-- Name: sip_clase clase_id_tclase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_clase
    ADD CONSTRAINT clase_id_tclase_fkey FOREIGN KEY (id_tclase) REFERENCES public.sip_tclase(id);


--
-- Name: sivel2_gen_filiacion_victimacolectiva comunidad_filiacion_id_filiacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_filiacion_victimacolectiva
    ADD CONSTRAINT comunidad_filiacion_id_filiacion_fkey FOREIGN KEY (id_filiacion) REFERENCES public.sivel2_gen_filiacion(id);


--
-- Name: sivel2_gen_organizacion_victimacolectiva comunidad_organizacion_id_organizacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_organizacion_victimacolectiva
    ADD CONSTRAINT comunidad_organizacion_id_organizacion_fkey FOREIGN KEY (id_organizacion) REFERENCES public.sivel2_gen_organizacion(id);


--
-- Name: sivel2_gen_profesion_victimacolectiva comunidad_profesion_id_profesion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_profesion_victimacolectiva
    ADD CONSTRAINT comunidad_profesion_id_profesion_fkey FOREIGN KEY (id_profesion) REFERENCES public.sivel2_gen_profesion(id);


--
-- Name: sivel2_gen_rangoedad_victimacolectiva comunidad_rangoedad_id_rangoedad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_rangoedad_victimacolectiva
    ADD CONSTRAINT comunidad_rangoedad_id_rangoedad_fkey FOREIGN KEY (id_rangoedad) REFERENCES public.sivel2_gen_rangoedad(id);


--
-- Name: sivel2_gen_sectorsocial_victimacolectiva comunidad_sectorsocial_id_sector_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_sectorsocial_victimacolectiva
    ADD CONSTRAINT comunidad_sectorsocial_id_sector_fkey FOREIGN KEY (id_sectorsocial) REFERENCES public.sivel2_gen_sectorsocial(id);


--
-- Name: sivel2_gen_sectorsocial_victimacolectiva comunidad_sectorsocial_id_sectorsocial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_sectorsocial_victimacolectiva
    ADD CONSTRAINT comunidad_sectorsocial_id_sectorsocial_fkey FOREIGN KEY (id_sectorsocial) REFERENCES public.sivel2_gen_sectorsocial(id);


--
-- Name: sivel2_gen_victimacolectiva_vinculoestado comunidad_vinculoestado_id_vinculoestado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva_vinculoestado
    ADD CONSTRAINT comunidad_vinculoestado_id_vinculoestado_fkey FOREIGN KEY (id_vinculoestado) REFERENCES public.sivel2_gen_vinculoestado(id);


--
-- Name: cor1440_gen_actividad_actividadtipo cor1440_gen_actividad_actividadtipo_actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_actividadtipo
    ADD CONSTRAINT cor1440_gen_actividad_actividadtipo_actividad_id_fkey FOREIGN KEY (actividad_id) REFERENCES public.cor1440_gen_actividad(id);


--
-- Name: cor1440_gen_actividad_actividadtipo cor1440_gen_actividad_actividadtipo_actividadtipo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_actividadtipo
    ADD CONSTRAINT cor1440_gen_actividad_actividadtipo_actividadtipo_id_fkey FOREIGN KEY (actividadtipo_id) REFERENCES public.cor1440_gen_actividadtipo(id);


--
-- Name: sip_departamento departamento_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_departamento
    ADD CONSTRAINT departamento_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES public.sip_pais(id);


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
-- Name: cor1440_gen_actividad_valorcampotind fk_rails_0104bf757c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_valorcampotind
    ADD CONSTRAINT fk_rails_0104bf757c FOREIGN KEY (valorcampotind_id) REFERENCES public.cor1440_gen_valorcampotind(id);


--
-- Name: sivel2_sjr_motivosjr_derecho fk_rails_02f5fb9150; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr_derecho
    ADD CONSTRAINT fk_rails_02f5fb9150 FOREIGN KEY (derecho_id) REFERENCES public.sivel2_sjr_derecho(id);


--
-- Name: cor1440_gen_resultadopf fk_rails_06ba24bd54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_resultadopf
    ADD CONSTRAINT fk_rails_06ba24bd54 FOREIGN KEY (objetivopf_id) REFERENCES public.cor1440_gen_objetivopf(id);


--
-- Name: cor1440_gen_actividad_actividadpf fk_rails_08b9aa072b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_actividadpf
    ADD CONSTRAINT fk_rails_08b9aa072b FOREIGN KEY (actividadpf_id) REFERENCES public.cor1440_gen_actividadpf(id);


--
-- Name: cor1440_gen_actividadpf fk_rails_0b10834ba7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadpf
    ADD CONSTRAINT fk_rails_0b10834ba7 FOREIGN KEY (resultadopf_id) REFERENCES public.cor1440_gen_resultadopf(id);


--
-- Name: cor1440_gen_financiador_proyectofinanciero fk_rails_0cd09d688c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_financiador_proyectofinanciero
    ADD CONSTRAINT fk_rails_0cd09d688c FOREIGN KEY (financiador_id) REFERENCES public.cor1440_gen_financiador(id);


--
-- Name: heb412_gen_campohc fk_rails_1e5f26c999; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campohc
    ADD CONSTRAINT fk_rails_1e5f26c999 FOREIGN KEY (doc_id) REFERENCES public.heb412_gen_doc(id);


--
-- Name: cor1440_gen_campotind fk_rails_2770ce966d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_campotind
    ADD CONSTRAINT fk_rails_2770ce966d FOREIGN KEY (tipoindicador_id) REFERENCES public.cor1440_gen_tipoindicador(id);


--
-- Name: cor1440_gen_informe fk_rails_294895347e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_informe
    ADD CONSTRAINT fk_rails_294895347e FOREIGN KEY (filtroproyecto) REFERENCES public.cor1440_gen_proyecto(id);


--
-- Name: cor1440_gen_informe fk_rails_2bd685d2b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_informe
    ADD CONSTRAINT fk_rails_2bd685d2b3 FOREIGN KEY (filtroresponsable) REFERENCES public.usuario(id);


--
-- Name: heb412_gen_doc fk_rails_2dd6d3dac3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_doc
    ADD CONSTRAINT fk_rails_2dd6d3dac3 FOREIGN KEY (dirpapa) REFERENCES public.heb412_gen_doc(id);


--
-- Name: cor1440_gen_valorcampoact fk_rails_3060a94455; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_valorcampoact
    ADD CONSTRAINT fk_rails_3060a94455 FOREIGN KEY (campoact_id) REFERENCES public.cor1440_gen_campoact(id);


--
-- Name: sivel2_sjr_oficina_proyectofinanciero fk_rails_3479b42b5c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_oficina_proyectofinanciero
    ADD CONSTRAINT fk_rails_3479b42b5c FOREIGN KEY (oficina_id) REFERENCES public.sip_oficina(id);


--
-- Name: cor1440_gen_actividad_proyecto fk_rails_395faa0882; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_proyecto
    ADD CONSTRAINT fk_rails_395faa0882 FOREIGN KEY (actividad_id) REFERENCES public.cor1440_gen_actividad(id);


--
-- Name: cor1440_gen_informe fk_rails_40cb623d50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_informe
    ADD CONSTRAINT fk_rails_40cb623d50 FOREIGN KEY (filtroproyectofinanciero) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: cor1440_gen_actividad fk_rails_4426fc905e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad
    ADD CONSTRAINT fk_rails_4426fc905e FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: sip_actorsocial_persona fk_rails_4672f6cbcd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial_persona
    ADD CONSTRAINT fk_rails_4672f6cbcd FOREIGN KEY (persona_id) REFERENCES public.sip_persona(id);


--
-- Name: cor1440_gen_actividad_sip_anexo fk_rails_49ec1ae361; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT fk_rails_49ec1ae361 FOREIGN KEY (anexo_id) REFERENCES public.sip_anexo(id);


--
-- Name: cor1440_gen_indicadorpf fk_rails_4a0bd96143; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_indicadorpf
    ADD CONSTRAINT fk_rails_4a0bd96143 FOREIGN KEY (objetivopf_id) REFERENCES public.cor1440_gen_objetivopf(id);


--
-- Name: cor1440_gen_valorcampotind fk_rails_4f2fc96457; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_valorcampotind
    ADD CONSTRAINT fk_rails_4f2fc96457 FOREIGN KEY (campotind_id) REFERENCES public.cor1440_gen_campotind(id);


--
-- Name: cor1440_gen_actividad_proyectofinanciero fk_rails_524486e06b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_proyectofinanciero
    ADD CONSTRAINT fk_rails_524486e06b FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: cor1440_gen_objetivopf fk_rails_57b4fd8780; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_objetivopf
    ADD CONSTRAINT fk_rails_57b4fd8780 FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: sip_actorsocial fk_rails_5b21e3a2af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial
    ADD CONSTRAINT fk_rails_5b21e3a2af FOREIGN KEY (grupoper_id) REFERENCES public.sip_grupoper(id);


--
-- Name: sivel2_gen_combatiente fk_rails_6485d06d37; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_6485d06d37 FOREIGN KEY (id_vinculoestado) REFERENCES public.sivel2_gen_vinculoestado(id);


--
-- Name: sivel2_sjr_oficina_proyectofinanciero fk_rails_669494cbb1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_oficina_proyectofinanciero
    ADD CONSTRAINT fk_rails_669494cbb1 FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: sip_grupo_usuario fk_rails_734ee21e62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_grupo_usuario
    ADD CONSTRAINT fk_rails_734ee21e62 FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: sivel2_sjr_motivosjr_derecho fk_rails_74442b8f19; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_motivosjr_derecho
    ADD CONSTRAINT fk_rails_74442b8f19 FOREIGN KEY (motivosjr_id) REFERENCES public.sivel2_sjr_motivosjr(id);


--
-- Name: sip_actorsocial fk_rails_7bc2a60574; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial
    ADD CONSTRAINT fk_rails_7bc2a60574 FOREIGN KEY (pais_id) REFERENCES public.sip_pais(id);


--
-- Name: sip_actorsocial_persona fk_rails_7c335482f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial_persona
    ADD CONSTRAINT fk_rails_7c335482f6 FOREIGN KEY (actorsocial_id) REFERENCES public.sip_actorsocial(id);


--
-- Name: sip_grupo_usuario fk_rails_8d24f7c1c0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_grupo_usuario
    ADD CONSTRAINT fk_rails_8d24f7c1c0 FOREIGN KEY (sip_grupo_id) REFERENCES public.sip_grupo(id);


--
-- Name: sivel2_sjr_ayudasjr_derecho fk_rails_93fdde2014; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_ayudasjr_derecho
    ADD CONSTRAINT fk_rails_93fdde2014 FOREIGN KEY (derecho_id) REFERENCES public.sivel2_sjr_derecho(id);


--
-- Name: cor1440_gen_resultadopf fk_rails_95485cfc7a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_resultadopf
    ADD CONSTRAINT fk_rails_95485cfc7a FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: sivel2_gen_combatiente fk_rails_95f4a0b8f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_95f4a0b8f6 FOREIGN KEY (id_profesion) REFERENCES public.sivel2_gen_profesion(id);


--
-- Name: sip_actorsocial_sectoractor fk_rails_9f61a364e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial_sectoractor
    ADD CONSTRAINT fk_rails_9f61a364e0 FOREIGN KEY (sectoractor_id) REFERENCES public.sip_sectoractor(id);


--
-- Name: cor1440_gen_actividad_proyectofinanciero fk_rails_a8489e0d62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_proyectofinanciero
    ADD CONSTRAINT fk_rails_a8489e0d62 FOREIGN KEY (actividad_id) REFERENCES public.cor1440_gen_actividad(id);


--
-- Name: sivel2_gen_combatiente fk_rails_af43e915a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_af43e915a6 FOREIGN KEY (id_filiacion) REFERENCES public.sivel2_gen_filiacion(id);


--
-- Name: cor1440_gen_indicadorpf fk_rails_b5b70fb7f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_indicadorpf
    ADD CONSTRAINT fk_rails_b5b70fb7f7 FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: cor1440_gen_actividad_actividadpf fk_rails_baad271930; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_actividadpf
    ADD CONSTRAINT fk_rails_baad271930 FOREIGN KEY (actividad_id) REFERENCES public.cor1440_gen_actividad(id);


--
-- Name: sivel2_gen_combatiente fk_rails_bfb49597e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_bfb49597e1 FOREIGN KEY (organizacionarmada) REFERENCES public.sivel2_gen_presponsable(id);


--
-- Name: cor1440_gen_informe fk_rails_c02831dd89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_informe
    ADD CONSTRAINT fk_rails_c02831dd89 FOREIGN KEY (filtroactividadarea) REFERENCES public.cor1440_gen_actividadarea(id);


--
-- Name: cor1440_gen_actividadpf fk_rails_c68e2278b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadpf
    ADD CONSTRAINT fk_rails_c68e2278b2 FOREIGN KEY (actividadtipo_id) REFERENCES public.cor1440_gen_actividadtipo(id);


--
-- Name: cor1440_gen_financiador_proyectofinanciero fk_rails_ca93eb04dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_financiador_proyectofinanciero
    ADD CONSTRAINT fk_rails_ca93eb04dc FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: cor1440_gen_actividad_sip_anexo fk_rails_cc9d44f9de; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT fk_rails_cc9d44f9de FOREIGN KEY (actividad_id) REFERENCES public.cor1440_gen_actividad(id);


--
-- Name: cor1440_gen_campoact fk_rails_ceb6f1a7f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_campoact
    ADD CONSTRAINT fk_rails_ceb6f1a7f0 FOREIGN KEY (actividadtipo_id) REFERENCES public.cor1440_gen_actividadtipo(id);


--
-- Name: cor1440_gen_actividad_proyecto fk_rails_cf5d592625; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_proyecto
    ADD CONSTRAINT fk_rails_cf5d592625 FOREIGN KEY (proyecto_id) REFERENCES public.cor1440_gen_proyecto(id);


--
-- Name: cor1440_gen_indicadorpf fk_rails_cf888d1b56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_indicadorpf
    ADD CONSTRAINT fk_rails_cf888d1b56 FOREIGN KEY (tipoindicador_id) REFERENCES public.cor1440_gen_tipoindicador(id);


--
-- Name: sivel2_sjr_progestado_derecho fk_rails_cff2ad554d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_sjr_progestado_derecho
    ADD CONSTRAINT fk_rails_cff2ad554d FOREIGN KEY (derecho_id) REFERENCES public.sivel2_sjr_derecho(id);


--
-- Name: cor1440_gen_indicadorpf fk_rails_d264d408b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_indicadorpf
    ADD CONSTRAINT fk_rails_d264d408b0 FOREIGN KEY (resultadopf_id) REFERENCES public.cor1440_gen_resultadopf(id);


--
-- Name: cor1440_gen_informe fk_rails_daf0af8605; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_informe
    ADD CONSTRAINT fk_rails_daf0af8605 FOREIGN KEY (filtrooficina) REFERENCES public.sip_oficina(id);


--
-- Name: heb412_gen_campoplantillahcm fk_rails_e0e38e0782; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heb412_gen_campoplantillahcm
    ADD CONSTRAINT fk_rails_e0e38e0782 FOREIGN KEY (plantillahcm_id) REFERENCES public.heb412_gen_plantillahcm(id);


--
-- Name: sivel2_gen_combatiente fk_rails_e2d01a5a99; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_e2d01a5a99 FOREIGN KEY (id_sectorsocial) REFERENCES public.sivel2_gen_sectorsocial(id);


--
-- Name: cor1440_gen_valorcampoact fk_rails_e36cf046d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_valorcampoact
    ADD CONSTRAINT fk_rails_e36cf046d1 FOREIGN KEY (actividad_id) REFERENCES public.cor1440_gen_actividad(id);


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
-- Name: cor1440_gen_actividad_valorcampotind fk_rails_e8cd697f5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividad_valorcampotind
    ADD CONSTRAINT fk_rails_e8cd697f5d FOREIGN KEY (actividad_id) REFERENCES public.cor1440_gen_actividad(id);


--
-- Name: sip_actorsocial_sectoractor fk_rails_f032bb21a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_actorsocial_sectoractor
    ADD CONSTRAINT fk_rails_f032bb21a6 FOREIGN KEY (actorsocial_id) REFERENCES public.sip_actorsocial(id);


--
-- Name: sivel2_gen_combatiente fk_rails_f0cf2a7bec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_f0cf2a7bec FOREIGN KEY (id_resagresion) REFERENCES public.sivel2_gen_resagresion(id);


--
-- Name: sivel2_gen_antecedente_combatiente fk_rails_f305297325; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_combatiente
    ADD CONSTRAINT fk_rails_f305297325 FOREIGN KEY (id_combatiente) REFERENCES public.sivel2_gen_combatiente(id);


--
-- Name: sivel2_gen_combatiente fk_rails_f77dda7a40; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_f77dda7a40 FOREIGN KEY (id_organizacion) REFERENCES public.sivel2_gen_organizacion(id);


--
-- Name: cor1440_gen_actividadpf fk_rails_f941b0c512; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_actividadpf
    ADD CONSTRAINT fk_rails_f941b0c512 FOREIGN KEY (proyectofinanciero_id) REFERENCES public.cor1440_gen_proyectofinanciero(id);


--
-- Name: sivel2_gen_combatiente fk_rails_fb02819ec4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_combatiente
    ADD CONSTRAINT fk_rails_fb02819ec4 FOREIGN KEY (id_rangoedad) REFERENCES public.sivel2_gen_rangoedad(id);


--
-- Name: sivel2_gen_antecedente_combatiente fk_rails_fc1811169b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_combatiente
    ADD CONSTRAINT fk_rails_fc1811169b FOREIGN KEY (id_antecedente) REFERENCES public.sivel2_gen_antecedente(id);


--
-- Name: cor1440_gen_proyectofinanciero lf_proyectofinanciero_responsable; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cor1440_gen_proyectofinanciero
    ADD CONSTRAINT lf_proyectofinanciero_responsable FOREIGN KEY (responsable_id) REFERENCES public.usuario(id);


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
-- Name: sip_persona persona_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona
    ADD CONSTRAINT persona_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES public.sip_pais(id);


--
-- Name: sip_persona persona_nacionalde_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona
    ADD CONSTRAINT persona_nacionalde_fkey FOREIGN KEY (nacionalde) REFERENCES public.sip_pais(id);


--
-- Name: sip_persona persona_tdocumento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona
    ADD CONSTRAINT persona_tdocumento_id_fkey FOREIGN KEY (tdocumento_id) REFERENCES public.sip_tdocumento(id);


--
-- Name: sip_persona_trelacion persona_trelacion_id_trelacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona_trelacion
    ADD CONSTRAINT persona_trelacion_id_trelacion_fkey FOREIGN KEY (id_trelacion) REFERENCES public.sip_trelacion(id);


--
-- Name: sip_persona_trelacion persona_trelacion_persona1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona_trelacion
    ADD CONSTRAINT persona_trelacion_persona1_fkey FOREIGN KEY (persona1) REFERENCES public.sip_persona(id);


--
-- Name: sip_persona_trelacion persona_trelacion_persona2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona_trelacion
    ADD CONSTRAINT persona_trelacion_persona2_fkey FOREIGN KEY (persona2) REFERENCES public.sip_persona(id);


--
-- Name: sivel2_gen_presponsable presponsable_papa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_presponsable
    ADD CONSTRAINT presponsable_papa_fkey FOREIGN KEY (papa) REFERENCES public.sivel2_gen_presponsable(id);


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
-- Name: sip_clase sip_clase_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_clase
    ADD CONSTRAINT sip_clase_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES public.sip_municipio(id);


--
-- Name: sip_municipio sip_municipio_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_municipio
    ADD CONSTRAINT sip_municipio_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES public.sip_departamento(id);


--
-- Name: sip_persona sip_persona_id_clase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona
    ADD CONSTRAINT sip_persona_id_clase_fkey FOREIGN KEY (id_clase) REFERENCES public.sip_clase(id);


--
-- Name: sip_persona sip_persona_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona
    ADD CONSTRAINT sip_persona_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES public.sip_departamento(id);


--
-- Name: sip_persona sip_persona_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_persona
    ADD CONSTRAINT sip_persona_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES public.sip_municipio(id);


--
-- Name: sip_ubicacion sip_ubicacion_id_clase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_ubicacion
    ADD CONSTRAINT sip_ubicacion_id_clase_fkey FOREIGN KEY (id_clase) REFERENCES public.sip_clase(id);


--
-- Name: sip_ubicacion sip_ubicacion_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_ubicacion
    ADD CONSTRAINT sip_ubicacion_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES public.sip_departamento(id);


--
-- Name: sip_ubicacion sip_ubicacion_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_ubicacion
    ADD CONSTRAINT sip_ubicacion_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES public.sip_municipio(id);


--
-- Name: sivel2_gen_antecedente_victimacolectiva sivel2_gen_antecedente_victimacolectiv_victimacolectiva_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_antecedente_victimacolectiva
    ADD CONSTRAINT sivel2_gen_antecedente_victimacolectiv_victimacolectiva_id_fkey FOREIGN KEY (victimacolectiva_id) REFERENCES public.sivel2_gen_victimacolectiva(id);


--
-- Name: sivel2_gen_caso_fotra sivel2_gen_caso_fotra_anexo_caso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fotra
    ADD CONSTRAINT sivel2_gen_caso_fotra_anexo_caso_id_fkey FOREIGN KEY (anexo_caso_id) REFERENCES public.sivel2_gen_anexo_caso(id);


--
-- Name: sivel2_gen_caso_fuenteprensa sivel2_gen_caso_fuenteprensa_anexo_caso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_anexo_caso_id_fkey FOREIGN KEY (anexo_caso_id) REFERENCES public.sivel2_gen_anexo_caso(id);


--
-- Name: sivel2_gen_caso_fuenteprensa sivel2_gen_caso_fuenteprensa_fuenteprensa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_fuenteprensa_id_fkey FOREIGN KEY (fuenteprensa_id) REFERENCES public.sip_fuenteprensa(id);


--
-- Name: sivel2_gen_caso_fuenteprensa sivel2_gen_caso_fuenteprensa_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_categoria sivel2_gen_categoria_supracategoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_categoria
    ADD CONSTRAINT sivel2_gen_categoria_supracategoria_id_fkey FOREIGN KEY (supracategoria_id) REFERENCES public.sivel2_gen_supracategoria(id);


--
-- Name: sivel2_gen_filiacion_victimacolectiva sivel2_gen_filiacion_victimacolectiva_victimacolectiva_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_filiacion_victimacolectiva
    ADD CONSTRAINT sivel2_gen_filiacion_victimacolectiva_victimacolectiva_id_fkey FOREIGN KEY (victimacolectiva_id) REFERENCES public.sivel2_gen_victimacolectiva(id);


--
-- Name: sivel2_gen_organizacion_victimacolectiva sivel2_gen_organizacion_victimacolecti_victimacolectiva_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_organizacion_victimacolectiva
    ADD CONSTRAINT sivel2_gen_organizacion_victimacolecti_victimacolectiva_id_fkey FOREIGN KEY (victimacolectiva_id) REFERENCES public.sivel2_gen_victimacolectiva(id);


--
-- Name: sivel2_gen_profesion_victimacolectiva sivel2_gen_profesion_victimacolectiva_victimacolectiva_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_profesion_victimacolectiva
    ADD CONSTRAINT sivel2_gen_profesion_victimacolectiva_victimacolectiva_id_fkey FOREIGN KEY (victimacolectiva_id) REFERENCES public.sivel2_gen_victimacolectiva(id);


--
-- Name: sivel2_gen_rangoedad_victimacolectiva sivel2_gen_rangoedad_victimacolectiva_victimacolectiva_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_rangoedad_victimacolectiva
    ADD CONSTRAINT sivel2_gen_rangoedad_victimacolectiva_victimacolectiva_id_fkey FOREIGN KEY (victimacolectiva_id) REFERENCES public.sivel2_gen_victimacolectiva(id);


--
-- Name: sivel2_gen_sectorsocial_victimacolectiva sivel2_gen_sectorsocial_victimacolecti_victimacolectiva_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_sectorsocial_victimacolectiva
    ADD CONSTRAINT sivel2_gen_sectorsocial_victimacolecti_victimacolectiva_id_fkey FOREIGN KEY (victimacolectiva_id) REFERENCES public.sivel2_gen_victimacolectiva(id);


--
-- Name: sivel2_gen_victimacolectiva_vinculoestado sivel2_gen_victimacolectiva_vinculoest_victimacolectiva_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva_vinculoestado
    ADD CONSTRAINT sivel2_gen_victimacolectiva_vinculoest_victimacolectiva_id_fkey FOREIGN KEY (victimacolectiva_id) REFERENCES public.sivel2_gen_victimacolectiva(id);


--
-- Name: sivel2_gen_supracategoria supracategoria_id_tviolencia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_supracategoria
    ADD CONSTRAINT supracategoria_id_tviolencia_fkey FOREIGN KEY (id_tviolencia) REFERENCES public.sivel2_gen_tviolencia(id);


--
-- Name: sip_trelacion trelacion_inverso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_trelacion
    ADD CONSTRAINT trelacion_inverso_fkey FOREIGN KEY (inverso) REFERENCES public.sip_trelacion(id);


--
-- Name: sip_ubicacion ubicacion_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_ubicacion
    ADD CONSTRAINT ubicacion_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sip_ubicacion ubicacion_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_ubicacion
    ADD CONSTRAINT ubicacion_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES public.sip_pais(id);


--
-- Name: sip_ubicacion ubicacion_id_tsitio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sip_ubicacion
    ADD CONSTRAINT ubicacion_id_tsitio_fkey FOREIGN KEY (id_tsitio) REFERENCES public.sip_tsitio(id);


--
-- Name: sivel2_gen_victima victima_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_victima victima_id_etnia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_etnia_fkey FOREIGN KEY (id_etnia) REFERENCES public.sivel2_gen_etnia(id);


--
-- Name: sivel2_gen_victima victima_id_iglesia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_iglesia_fkey FOREIGN KEY (id_iglesia) REFERENCES public.sivel2_gen_iglesia(id);


--
-- Name: sivel2_gen_victima victima_id_persona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_persona_fkey FOREIGN KEY (id_persona) REFERENCES public.sip_persona(id);


--
-- Name: sivel2_gen_victima victima_id_profesion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_profesion_fkey FOREIGN KEY (id_profesion) REFERENCES public.sivel2_gen_profesion(id);


--
-- Name: sivel2_gen_victima victima_id_rangoedad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_rangoedad_fkey FOREIGN KEY (id_rangoedad) REFERENCES public.sivel2_gen_rangoedad(id);


--
-- Name: sivel2_gen_victima victima_id_sectorsocial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_id_sectorsocial_fkey FOREIGN KEY (id_sectorsocial) REFERENCES public.sivel2_gen_sectorsocial(id);


--
-- Name: sivel2_gen_victima victima_organizacionarmada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victima
    ADD CONSTRAINT victima_organizacionarmada_fkey FOREIGN KEY (organizacionarmada) REFERENCES public.sivel2_gen_presponsable(id);


--
-- Name: sivel2_gen_victimacolectiva victimacolectiva_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva
    ADD CONSTRAINT victimacolectiva_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES public.sivel2_gen_caso(id);


--
-- Name: sivel2_gen_victimacolectiva victimacolectiva_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva
    ADD CONSTRAINT victimacolectiva_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES public.sip_grupoper(id);


--
-- Name: sivel2_gen_victimacolectiva victimacolectiva_organizacionarmada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sivel2_gen_victimacolectiva
    ADD CONSTRAINT victimacolectiva_organizacionarmada_fkey FOREIGN KEY (organizacionarmada) REFERENCES public.sivel2_gen_presponsable(id);


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
('20140902101425'),
('20140904033941'),
('20140904211823'),
('20140909141336'),
('20141112111129'),
('20141222174237'),
('20141222174247'),
('20141222174257'),
('20141222174267'),
('20150213114933'),
('20150225140336'),
('20150313153722'),
('20150317084149'),
('20150317084737'),
('20150317090631'),
('20150602094513'),
('20150602095241'),
('20150602104342'),
('20150609094809'),
('20150609094815'),
('20150609094820'),
('20150612160810'),
('20150612203808'),
('20150615024318'),
('20150616095023'),
('20150616100351'),
('20150616100551'),
('20150716171420'),
('20150716192356'),
('20150717161539'),
('20150724024110'),
('20150826000000'),
('20150929112313'),
('20151006105402'),
('20151020203420'),
('20151030094611'),
('20151124110943'),
('20151127102425'),
('20151130101417'),
('20160316093659'),
('20160316094627'),
('20160316100620'),
('20160316100621'),
('20160316100622'),
('20160316100623'),
('20160316100624'),
('20160316100625'),
('20160316100626'),
('20160719195853'),
('20160719214520'),
('20160724160049'),
('20160724164110'),
('20160725123242'),
('20160725125929'),
('20160725131347'),
('20170406213334'),
('20170503145808'),
('20170526100040'),
('20170526124219'),
('20170526131129'),
('20170529020218'),
('20170529154413'),
('20170609131212'),
('20170712205819'),
('20180126035129'),
('20180126055129'),
('20180212223621'),
('20180225152848'),
('20180307125759'),
('20180519102415'),
('20180611222635'),
('20180612024009'),
('20180612030340'),
('20180626123640'),
('20180627031905'),
('20180717134314'),
('20180718094829'),
('20180719015902'),
('20180726213123'),
('20180726234755'),
('20180801105304'),
('20180810220807'),
('20180812220011'),
('20180813110808'),
('20180905031342'),
('20180905031617'),
('20180910132139'),
('20180912114413'),
('20180914153010'),
('20180914170936'),
('20180917072914'),
('20180918195008'),
('20180918195821'),
('20180920031351'),
('20180921120954');


INSERT INTO sip_fuenteprensa(id, nombre, tfuente, fechacreacion, created_at) VALUES (22,'FD - FUENTE DIRECTA', 'Directa', '2001-01-01', '2015-06-02');
INSERT INTO sip_fuenteprensa(id, nombre, fechacreacion, created_at) VALUES (0,'SIN INFORMACIÓN', '2001-01-01', '2015-06-02');


-- Volcado de tablas basicas

-- Antes deshabilitamos integridad en unos casos
ALTER TABLE ONLY sivel2_gen_categoria
  DROP CONSTRAINT IF EXISTS categoria_contadaen_fkey; 
ALTER TABLE ONLY sivel2_gen_presponsable
  DROP CONSTRAINT IF EXISTS presponsable_papa_fkey;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_pconsolidado; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'MUERTOS', 'DH', 'VIDA', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (10, 'HERIDOS', 'DIH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (11, 'AMENAZAS', 'DIH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (12, 'VIOLENCIA SEXUAL', 'DIH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (13, 'TORTURA', 'VP', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (14, 'HERIDOS', 'VP', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (15, 'ATENTADOS', 'VP', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (16, 'AMENAZAS', 'VP', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (17, 'DESAPARICIÓN', 'DH', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (18, 'DETENCION ARBITRARIA', 'DH', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (19, 'DEPORTACIÓN', 'DH', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'MUERTOS', 'DIH', 'VIDA', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (20, 'RECLUTAMIENTO DE MENORES', 'DIH', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (21, 'TOMA DE REHENES', 'DIH', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (22, 'ESCUDO', 'DIH', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (23, 'RAPTO', 'VP', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (24, 'SECUESTRO', 'VP', 'LIBERTAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (25, 'COLECTIVO CONFINADO', 'DIH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (3, 'MUERTOS', 'VP', 'VIDA', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (4, 'TORTURA', 'DH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (5, 'HERIDOS', 'DH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (6, 'ATENTADOS', 'DH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (7, 'AMENAZAS', 'DH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (8, 'VIOLENCIA SEXUAL', 'DH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);
INSERT INTO sivel2_gen_pconsolidado (id, rotulo, tipoviolencia, clasificacion, peso, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (9, 'TORTURA', 'DIH', 'INTEGRIDAD', 0, '2001-01-01', NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_tviolencia; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_tviolencia (id, nombre, nomcorto, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES ('A', 'VIOLACIONES A LOS DERECHOS HUMANOS', 'DH', '2000-07-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_tviolencia (id, nombre, nomcorto, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES ('B', 'VIOLENCIA POLÍTICO SOCIAL', 'VPS', '2000-07-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_tviolencia (id, nombre, nomcorto, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES ('C', 'ACCIONES BÉLICAS', 'BELICAS', '2000-07-24', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_tviolencia (id, nombre, nomcorto, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES ('D', 'INFRACCIONES AL DIH', 'DIH', '2000-07-24', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_supracategoria; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (1, 'BÉLICAS', '2000-07-26', NULL, 'C', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (1, 'PERSECUCIÓN POLÍTICA', '2000-07-26', NULL, 'A', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (1, 'PERSECUCIÓN POLÍTICA', '2000-07-26', NULL, 'B', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (1, 'PERSONAS', '2000-07-26', NULL, 'D', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (2, 'ABUSO DE AUTORIDAD', '2000-07-26', NULL, 'A', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (2, 'INTOLERANCIA SOCIAL', '2000-07-26', NULL, 'B', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (2, 'OBJETIVOS, MÉTODOS Y MÉDIOS ILÍCITOS', '2000-07-26', NULL, 'D', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (3, 'INTOLERANCIA SOCIAL', '2000-07-26', NULL, 'A', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_supracategoria (codigo, nombre, fechacreacion, fechadeshabilitacion, id_tviolencia, created_at, updated_at, observaciones, id) VALUES (3, 'MÉTODOS', '2000-07-26', '2017-05-03', 'D', NULL, NULL, NULL, 9);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_intervalo; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_intervalo (id, nombre, rango, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'MADRUGADA', '00:00 A 05:59', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_intervalo (id, nombre, rango, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'MAÑANA', '06:00 A 12:59', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_intervalo (id, nombre, rango, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'TARDE', '13:00 A 18:59', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_intervalo (id, nombre, rango, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'NOCHE', '19:00 A 24:59', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_intervalo (id, nombre, rango, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'SIN INFORMACIÓN', 'SIN INFORMACIÓN', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_filiacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'LIBERAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'SIN INFORMACIÓN', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'UNIÓN PATRÍOTICA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'COMUNISTA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'POLO DEMOCRÁTICO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'FRENTE SOCIAL Y POLÍTICO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'MOVIMIENTO POLÍTICO Y SOCIAL MARCHA PATRIÓTICA', '2014-02-14', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'CONSERVADOR', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'ALIANZAS TRADICIONALES', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'IZQUIERDA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'ALIANZAS IZQUIERDA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'DERECHA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'DESMOVILIZADOS', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'CIVICO POLITICO ELECTORAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_filiacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'OTRO', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_organizacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'CAMPESINA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'HUMANITARIA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'DERECHOS HUMANOS', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'GREMIAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'JUVENIL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'AMBIENTALISTA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'OTRA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'SIN INFORMACIÓN', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'VÍCTIMAS', '2013-07-05', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'INDIGENA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'SINDICAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'CIVICA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'ESTUDIANTIL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'PROFESIONAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'NEGRITUDES', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'FEMENINA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_organizacion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'RELIGIOSA', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_sectorsocial; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'CAMPESINO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'HACENDADO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'MARGINADO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'TRABAJADOR (A) SEXUAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'DESEMPLEADO (A)', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'OTRO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'SIN INFORMACIÓN', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'TRANSPORTADOR', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'INDIGENA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'OBRERO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'COMERCIANTE', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'EMPLEADO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'TRABAJADOR INDEPENDIENTE', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'PROFESIONAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'EMPRESARIO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_sectorsocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'INDUSTRIAL', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_vinculoestado; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'CONGRESO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'FISCALIA GRAL DE LA NAC.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'CONSEJO NACIONAL ELECTOR.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'REGIS. NAL DEL EST. CIVIL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'PROCURADURIA GENERAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'CONTRALORIA GENERAL DE R.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'DEFENSORIA DEL PUEBLO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'ASAMBLEA DEPARTAMENTAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'GOBERNACION', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (18, 'SECRETARIAS (DTO.)', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'EMPRESAS PUBLICAS DTALES.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'PRESIDENCIA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (20, 'TRIBUNALES DTALES.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (21, 'REGISTRADURIA DTAL.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (22, 'CONTRALORIA DTAL.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (23, 'PROCURADURIA DTAL.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (24, 'DEFENSORIA DTAL.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (25, 'CONCEJO MUNICIPAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (26, 'ALCALDIA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (27, 'SECRETARIAS MPALES.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (28, 'EMPRESAS PUBLICAS MPALES.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (29, 'JUZGADOS (MPALES.)', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'MINISTERIOS', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (30, 'PROCURADURIA DELEGADA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (31, 'DEFENSORIA (MPAL.)', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (32, 'PERSONERIA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (33, 'CONTRALORIA (MPAL.)', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (34, 'JUNTAS ADMINIST. LOCALES', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (35, 'ALCALDIA MENOR', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (36, 'SECRETARIAS LOCALES', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (37, 'CASAS DE JUSTICIA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (38, 'SIN INFORMACIÓN', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (39, 'TRIBUNALES', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'DEPTOS. ADMINISTRATIVOS', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (40, 'VICEPRESIDENCIA', '2013-07-05', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'EMP. IND. Y COM. DEL EST.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'SUPERINTENDENCIAS', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'CONS. SUP. DE LA JUDICAT.', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'CORT. SUPREMA DE JUSTICIA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_vinculoestado (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'CORTE CONSTITUCIONAL', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_actividadoficio; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'AGRICULTOR/A', '2013-05-16', NULL, NULL, '2017-05-29 16:47:34.922925', '');
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'MINERO', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (102, 'COCINERO/A', '2014-07-28', NULL, '2014-07-28 15:17:02.95474', '2014-07-28 15:17:39.312986', NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'LIDER COMUNITARIO', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'PANADERO/A', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'TRABAJADOR INFORMAL', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'TRABAJADOR/GESTOR COMUNITARIO', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'PESCADOR', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'TRABAJADOR DOMÉSTICO', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'PIANGÜERO', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (18, 'OTRO', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'CORTE Y COSTURA', '2014-03-10', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'ALBAÑIL', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (20, 'PELUQUERÍA Y MANICURISTA', '2014-03-10', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'AMA DE CASA', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'CAMPESINO/A', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'COMERCIANTE', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'DESEMPLEADO/A', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'ELECTRICISTA', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'INDEPENDIENTE', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_actividadoficio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'OFICIOS VARIOS', '2013-05-16', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_antecedente; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'AMENAZA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'SEGUIMIENTO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'SEÑALAMIENTO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'TORTURA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'OTRO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'SIN INFORMACIÓN', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'PILLAJE', '2006-08-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'MASACRE', '2006-08-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'ATENTADO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'DETENCION', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'AMNISTIA - INDULTO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'EXILIO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'ALLANAMIENTO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'DESAPARICION', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'SECUESTRO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_antecedente (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'DESPLAZAMIENTO', '2001-01-29', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_categoria; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (10, 'EJECUCIÓN EXTRAJUDICIAL', '2001-07-26', NULL, 1, 701, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (101, 'DEPORTACIÓN', '2001-05-23', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (102, 'DESPLAZAMIENTO FORZADO', '2001-07-11', NULL, NULL, 903, 'C', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (104, 'CONFINAMIENTO COLECTIVO', '2008-10-17', NULL, 25, 906, 'C', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (11, 'DESAPARICIÓN FORZADA', '2001-07-26', NULL, 17, NULL, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (12, 'TORTURA', '2001-07-26', NULL, 4, 72, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (13, 'LESIÓN FÍSICA', '2000-08-09', NULL, 5, 702, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (14, 'DETENCIÓN ARBITRARIA', '2001-08-09', NULL, 18, NULL, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (141, 'JUDICIALIZACIÓN ARBITRARIA', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (15, 'AMENAZA', '2000-08-09', NULL, 7, 73, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (16, 'ATENTADO', '2000-08-09', NULL, 6, NULL, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (17, 'COLECTIVO LESIONADO', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (18, 'COLECTIVO AMENAZADO', '2000-08-09', NULL, NULL, 706, 'C', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (19, 'VIOLENCIA SEXUAL', '2000-08-09', NULL, 8, 77, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (191, 'VIOLACION', '2008-10-20', NULL, 8, 771, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (192, 'EMBARAZO FORZADO', '2008-10-20', NULL, 8, 772, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (193, 'PROSTITUCIÓN FORZADA', '2008-10-20', NULL, 8, 773, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (194, 'ESTERILIZACIÓN FORZADA', '2008-10-20', NULL, 8, 774, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (195, 'ESCLAVITUD SEXUAL', '2008-10-20', NULL, 8, 775, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (196, 'ABUSO SEXUAL', '2008-10-20', NULL, NULL, 776, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (197, 'ABORTO FORZADO', '2010-04-17', NULL, 12, 777, 'I', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (20, 'EJECUCIÓN EXTRAJUDICIAL', '2001-07-26', NULL, 1, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (21, 'DESAPARICIÓN FORZADA', '2001-08-09', NULL, 17, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (22, 'TORTURA', '2000-08-09', NULL, 4, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (23, 'LESIÓN FÍSICA', '2000-08-09', NULL, 5, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (231, 'COLECTIVO LESIONADO', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (24, 'DETENCIÓN ARBITRARIA', '2001-08-09', NULL, 18, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (241, 'JUDICIALIZACIÓN ARBITRARIA', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (25, 'AMENAZA', '2000-08-09', NULL, 7, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (26, 'ATENTADO', '2000-08-09', NULL, 6, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (27, 'DESPLAZAMIENTO FORZADO', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (28, 'COLECTIVO AMENAZADO', '2000-08-09', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (29, 'VIOLENCIA SEXUAL', '2000-08-09', NULL, 8, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (291, 'VIOLACION', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (292, 'EMBARAZO FORZADO', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (293, 'PROSTITUCIÓN FORZADA', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (294, 'ESTERILIZACIÓN FORZADA', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (295, 'ESCLAVITUD SEXUAL', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (296, 'ABUSO SEXUAL', '2008-10-20', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (297, 'ABORTO FORZADO', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 5);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (30, 'EJECUCIÓN EXTRAJUDICIAL', '2001-08-09', NULL, 1, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (301, 'DETENCIÓN ARBITRARIA', '2001-05-23', NULL, 18, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (302, 'DESAPARICIÓN FORZADA', '2001-05-23', NULL, 17, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (33, 'LESIÓN FÍSICA', '2000-08-09', NULL, 5, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (331, 'COLECTIVO LESIONADO', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (34, 'DESPLAZAMIENTO FORZADO', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (341, 'JUDICIALIZACIÓN ARBITRARIA', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (35, 'AMENAZA', '2000-08-09', NULL, 7, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (36, 'TORTURA', '2000-08-09', NULL, 4, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (37, 'ATENTADO', '2000-08-09', NULL, 6, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (38, 'COLECTIVO AMENAZADO', '2000-08-09', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (39, 'VIOLENCIA SEXUAL', '2000-08-09', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (391, 'VIOLACION', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (392, 'EMBARAZO FORZADO', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (393, 'PROSTITUCIÓN FORZADA', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (394, 'ESTERILIZACIÓN FORZADA', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (395, 'ESCLAVITUD SEXUAL', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (396, 'ABUSO SEXUAL', '2008-10-20', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (397, 'ABORTO FORZADO', '2010-04-17', NULL, 8, NULL, 'I', NULL, NULL, NULL, 8);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (40, 'ASESINATO', '2000-08-09', NULL, 3, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (401, 'COLECTIVO DESPLAZADO', '2001-05-23', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (402, 'COLECTIVO LESIONADO', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (41, 'SECUESTRO', '2000-08-09', NULL, 23, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (420, 'VIOLENCIA SEXUAL', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (421, 'VIOLACIÓN', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (422, 'EMBARAZO FORZADO', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (423, 'PROSTITUCIÓN FORZADA', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (424, 'ESTERILIZACIÓN FORZADA', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (425, 'ESCLAVITUD SEXUAL', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (426, 'ABUSO SEXUAL', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (427, 'ABORTO FORZADO', '2010-04-17', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (43, 'LESIÓN FÍSICA', '2000-07-26', NULL, 14, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (45, 'AMENAZA', '2000-08-09', NULL, 16, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (46, 'ATENTADO', '2000-08-09', NULL, 15, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (47, 'TORTURA', '2000-08-09', NULL, 13, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (48, 'RAPTO', '2001-08-09', NULL, 22, NULL, 'I', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (49, 'COLECTIVO AMENAZADO', '2000-08-09', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 2);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (50, 'ASESINATO', '2000-08-09', NULL, 3, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (501, 'COLECTIVO DESPLAZADO', '2001-05-23', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (502, 'COLECTIVO LESIONADO', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (520, 'VIOLENCIA SEXUAL', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (521, 'VIOLACIÓN', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (522, 'EMBARAZO FORZADO', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (523, 'PROSTITUCIÓN FORZADA', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (524, 'ESTERILIZACIÓN FORZADA', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (525, 'ESCLAVITUD SEXUAL', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (526, 'ABUSO SEXUAL', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (527, 'ABORTO FORZADO', '2011-07-07', NULL, 12, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (53, 'LESIÓN FÍSICA', '2000-08-09', NULL, 14, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (55, 'AMENAZA', '2000-08-09', NULL, 16, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (56, 'TORTURA', '2000-08-09', NULL, 13, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (57, 'ATENTADO', '2000-08-09', NULL, 15, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (58, 'RAPTO', '2001-08-09', NULL, 22, NULL, 'I', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (59, 'COLECTIVO AMENAZADO', '2000-08-09', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 6);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (62, 'COMBATE', '2000-07-26', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (63, 'EMBOSCADA', '2000-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (64, 'CAMPO MINADO', '2001-08-09', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (65, 'AMETRALLAMIENTO Y/O BOMBARDEO', '2001-08-09', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (66, 'BLOQUEO DE VÍAS', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (67, 'ATAQUE A OBJETIVO MILITAR', '2000-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (68, 'INCURSIÓN', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (69, 'SABOTAJE', '2000-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (701, 'HOMICIDIO INTENCIONAL DE PERSONA PROTEGIDA ', '2000-08-09', NULL, 2, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (702, 'LESIÓN A PERSONA PROTEGIDA', '2000-08-09', NULL, 10, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (703, 'CIVIL MUERTO EN ACCIÓN BÉLICA', '2000-08-09', NULL, 2, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (704, 'LESIÓN A CIVILES EN ACCIÓN BÉLICA', '2000-08-09', NULL, 10, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (705, 'COLECTIVO LESIONADO POR INFRACCIONES AL DIHC', '2017-05-04', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (706, 'COLECTIVO AMENAZADO', '2000-08-09', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (707, 'MISIÓN MÉDICA O SANITARIA', '2001-07-11', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (708, 'MISIÓN RELIGIOSA', '2001-07-11', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (709, 'MISIÓN HUMANITARIA', '2001-07-11', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (710, 'MISIONES DE PAZ', '2017-05-04', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (711, 'MISIÓN INFORMATIVA', '2017-05-04', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (712, 'ZONAS HUMANITARIAS', '2017-05-04', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (713, 'CONVERSACIONES DE PAZ', '2017-05-04', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (714, 'ESCLAVITUD Y TRABAJOS FORZADOS', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (715, 'JUDICIALIZACIÓN ARBITRARIA', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (716, 'NEGACIÓN DE DERECHOS A PRISIONERO DE GUERRA', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (717, 'NEGACIÓN DE ATENCIÓN A PERSONA VULNERABLE', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (718, 'PROFANACIÓN Y OCULTAMIENTO DE CADÁVERES', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (72, 'TORTURA', '2000-08-09', NULL, 9, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (73, 'AMENAZA', '2000-08-09', NULL, 11, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (74, 'TOMA DE REHENES', '2001-08-09', NULL, 21, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (75, 'RECLUTAMIENTO DE MENORES', '2000-08-09', NULL, 20, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (76, 'DESAPARICIÓN FORZADA', '2017-05-04', NULL, NULL, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (77, 'VIOLENCIA SEXUAL', '2000-08-09', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (771, 'VIOLACIÓN', '2008-10-20', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (772, 'EMBARAZO FORZADO', '2008-10-20', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (773, 'PROSTITUCIÓN FORZADA', '2008-10-20', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (774, 'ESTERILIZACIÓN FORZADA', '2008-10-20', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (775, 'ESCLAVITUD SEXUAL', '2008-10-20', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (776, 'ABUSO SEXUAL', '2008-10-20', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (777, 'ABORTO FORZADO', '2010-04-17', NULL, 12, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (78, 'ESCUDO INDIVIDUAL', '2000-08-09', NULL, 19, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (79, 'DESAPARICIÓN', '2002-07-23', '2002-07-23', NULL, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (80, 'BIENES CIVILES', '2000-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (801, 'ATAQUE A OBRAS E INST. QUE CONT. FUERZAS PELIGR.', '2001-07-26', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (84, 'MEDIO AMBIENTE', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (85, 'BIENES CULTURALES Y RELIGIOSOS', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (86, 'HAMBRE COMO MÉTODO DE GUERRA', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (87, 'MUERTO POR ATAQUE A BIENES CIVILES', '2001-08-09', NULL, 2, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (88, 'LESIÓN POR ATAQUE A BIENES CIVILES', '2001-08-09', NULL, 10, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (89, 'ESTRUCTURA VIAL', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (90, 'ATAQUE INDISCRIMINADO', '2000-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (902, 'DESPLAZAMIENTO FORZADO', '2001-07-11', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (903, 'DESPLAZAMIENTO FORZADO', '2001-07-11', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (904, 'COLECTIVO ESCUDO', '2001-07-11', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (905, 'GUERRA SIN CUARTEL', '2017-05-04', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (906, 'CONFINAMIENTO COLECTIVO', '2008-10-21', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (91, 'PERFIDIA', '2000-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (910, 'ENFRENTAMIENTO - INTERNO', '2006-07-12', '2017-05-03', NULL, NULL, 'I', NULL, NULL, NULL, 3);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (916, 'NEGACIÓN DE DERECHOS A PRISIONEROS DE GUERRA', '2018-02-24', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (917, 'NEGACIÓN DE ATENCIÓN A PERSONAS VULNERABLES', '2018-02-24', NULL, NULL, NULL, 'C', NULL, NULL, NULL, 1);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (92, 'ARMAS ABSOLUTAMENTE PROHIBIDAS', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (93, 'EMPLEO ILÍCITO DE ARMAS DE USO RESTRINGIDO', '2001-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (95, 'PILLAJE', '2000-08-09', NULL, NULL, NULL, 'O', NULL, NULL, NULL, 7);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (97, 'MUERTO POR OBJETIVOS, MÉTODOS Y MEDIOS ILÍCITOS', '2001-08-09', NULL, 2, NULL, 'I', NULL, NULL, NULL, 4);
INSERT INTO sivel2_gen_categoria (id, nombre, fechacreacion, fechadeshabilitacion, id_pconsolidado, contadaen, tipocat, created_at, updated_at, observaciones, supracategoria_id) VALUES (98, 'LESIÓN POR OBJETIVOS, MÉTODOS Y MEDIOS ILÍCITOS', '2001-08-09', NULL, 10, NULL, 'I', NULL, NULL, NULL, 4);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_contexto; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'MILITARIZACIÓN', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'PARO AGRARIO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'MARCHA CAMPESINA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'TOMA DE TIERRAS', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'ENCLAVES ECONÓMICOS', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'CULTIVOS DE USO ILÍCITO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'CONFLICTOS LABORALES', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'CONFLICTOS ESTUDIANTILES', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'PROBL. ÉTNICA (NEG.E IN.)', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (18, 'PROBLEMÁTICA FRONTERIZA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'PROBLEMÁTICA AMBIENTAL', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'PARAMILITARIZACIÓN', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (20, 'PROBLEMÁTICA CARCELARIA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (21, 'DESALOJOS', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (22, 'PROCESOS DE PAZ O DIÁLOGO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (23, 'PROCESOS ELECTORALES', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (24, 'CAMPAÑAS DE INTOLERANCIA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (25, 'PERSECUSIÓN A ORGANIZACION', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (26, 'OTROS', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (27, 'ZONAS DE REHAB. Y CONSOL', '2003-03-12', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (28, 'CONFLICTO ARMADO', '2004-02-18', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (29, 'FALSO POSITIVO', '2010-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'PRESENCIA GUERRILLERA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (30, 'INTOLERANCIA SOCIAL', '2011-04-26', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (31, 'SEGURIDAD INFORMÁTICA', '2011-04-28', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'PRESENCIA DE MILICIAS', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'ACCIONES BÉLICAS', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'PARO CÍVICO', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'MANIFESTACIONES', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'PROTESTA', '2001-01-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_contexto (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'OCUPACIONES', '2001-01-29', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_escolaridad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'PREESCOLAR', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'TÉCNICO INCOMPLETO', '2015-10-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'PROFESIONAL INCOMPLETO', '2015-10-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'PRIMARIA', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'SECUNDARIA', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'TÉCNICO', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'PROFESIONAL', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'NINGUNO', '2015-10-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'ANALFABETA', '2015-10-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'PRIMARIA INCOMPLETA', '2015-10-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_escolaridad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'SECUNDARIA INCOMPLETA', '2015-10-06', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_estadocivil; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_estadocivil (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'SIN INFORMACIÓN', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_estadocivil (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'CASADO/A', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_estadocivil (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'DIVORCIADO/A', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_estadocivil (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'SOLTERO/A', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_estadocivil (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'UNIÓN LIBRE', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_estadocivil (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'VIUDO/A', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_estadocivil (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'SEPARADO/A', '2013-06-16', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_etnia; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'SIN INFORMACIÓN', ' ', '2011-04-26', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'AWA', '5 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (100, 'YAUNA', '78 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (101, 'YUKO', '80 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (102, 'GARÚ', '89 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (103, 'GUAYUÚ', '32 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (104, 'HITNÚ', '33 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (105, 'MACÚ', '40 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (106, 'MIRAÑA', '44 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (107, 'TOTORÓ', '66 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (108, 'YURUTÍ', '82 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (109, 'YURÍ', '81 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'BARÁ', '6 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (110, 'ZENÚ', '83 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'BARASANA', '7 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'BARÍ', '8 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'CAMSA - KAMSA', '35 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'CARIJONA', '13 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'COCAMA', '16 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'COFÁN', '18 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (18, 'COREGUAJE - KOREGUAJE', '37 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'CUBEO', '20 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'MESTIZO', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (20, 'CUIBA', '21 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (21, 'CHIMILA', '14 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (22, 'DESANO', '23 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (23, 'EMBERA', '25 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (25, 'GUAMBIANO', '29 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (26, 'GUANANO - GUANACA', '30 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (27, 'GUAYABERO', '31 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (28, 'HUITOTO - WITOTO', '73 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (29, 'INGA', '34 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'BLANCO', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (30, 'JUPDA', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (31, 'KARAPANA - CARAPANA', '12 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (32, 'KOGUI', '36 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (33, 'CURRIPACO', '22 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (34, 'MACUNA', '41 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (35, 'MACAGUAJE', '39 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (36, 'MOCANÁ', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (37, 'MUISCA', '46 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (38, 'NASA - PAÉZ', '49 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (39, 'NUKAK', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'NEGRO', '200 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (40, 'PASTOS', '50 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (41, 'PIAPOCO', '51 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (42, 'PIJAO', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (43, 'PIRATAPUYO', '53 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (44, 'PUINAVE', '55 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (45, 'SÁLIBA', '56 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (46, 'SIKUANI', '57 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (47, 'SIONA', '58 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (48, 'TATUYO', '64 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (49, 'TINIGUA', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'INDÍGENA', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (50, 'TUCANO', '67 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (51, 'UMBRÁ', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (52, 'U´WA', '70 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (53, 'WAYUU', '72 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (54, 'WIWA - WIWUA', '74 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (55, 'WOUNAAN', '75 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (56, 'YAGUA', '76 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (57, 'YANACONA', '77 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (58, 'YUCUNA', '79 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (59, 'YUKPA', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'ACHAGUA', '1 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (60, 'ROM', '400 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2013-07-05', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (61, 'AMORUA', '2 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (62, 'BETOYE', '9 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (63, 'BORA', '10 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (64, 'CABIYARI', '11 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (65, 'CARAMANTA', '84 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (66, 'CHAMI', '86 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (68, 'CHIRICOA', '15 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (69, 'COCONUCO', '17 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'ANDAKÍ', ' ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (70, 'COROCORO', '87 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (71, 'COYAIMA-NATAGAIMA', '19 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (72, 'DATUANA', '88 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (73, 'DUJOS', '24 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (74, 'EMBERA CATIO', '26 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (75, 'EMBERA CHAMI', '27 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (76, 'EMBERA SIAPIDARA', '28 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (77, 'KATIO', '85 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (78, 'LETUAMA', '38 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (79, 'MASIGUARE', '42 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'ANDOQUE', '3 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (80, 'MATAPI', '43 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (81, 'MUINANE', '45 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (82, 'MURA', '90 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (83, 'NONUYA', '47 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (84, 'OCAINA', '48 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (85, 'PAYOARINI', '91 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (86, 'PIAROA', '52 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (87, 'PISAMIRA', '54 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (88, 'POLINDARA', '94 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (89, 'QUIYASINGAS', '93 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'ARHUACO', '4 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls ', '2011-04-29', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (90, 'SIRIANO', '59 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (91, 'SIRIPU', '60 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (92, 'TAIWANO', '61 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (93, 'TAMA', '92 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (94, 'TANIMUKA', '62 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (95, 'TARIANO', '63 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (96, 'TIKUNAS', '65 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (97, 'TULE', '68 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (98, 'TUYUCA', '69 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_etnia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (99, 'WANANO', '71 en http://www.mineducacion.gov.co/1621/articles-255690_archivo_xls_listado_etnias.xls', '2014-05-30', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_frontera; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_frontera (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'Ecuador', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_frontera (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'Brasil', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_frontera (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'Venezuela', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_frontera (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'Panamá', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_frontera (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'Perú', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_iglesia; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'SIN INFORMACIÓN', '', '2011-04-26', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'IGLESIA CRISTIANA NO IDENTIFICADA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'AIEC - ASOCIACIÓN DE IGLESIAS EVANGÉLICAS DEL CARIBE', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'IGLESIA INTERAMERICANA DE COLOMBIA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (21, 'IGLESIA ALIANZA CRISTIANA MISIONERA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (22, 'IGLESIA MENONITA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (23, 'IGLESIA HERMANDAD EN CRISTO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (24, 'IGLESIA CUADRANGULAR PENIEL', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (25, 'IGLESIA CUADRANGULAR', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (27, 'IGLESIA MOVIMIENTO MISIONERO MUNDIAL', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (29, 'IGLESIA PALABRA DE VIDA (AIEC)', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (30, 'COMUNIDAD CRISTIANA DE FE', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (31, 'IUMEC - IGLESIA UNIÓN MISIONERA EVANGÉLICA DE COLOMBIA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (32, 'IGLESIA BETHESDA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (33, 'IGLESIA CRISTO VIENE PRONTO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (34, 'IGLESIA CRISTO REINA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (35, 'IGLESIA PENTECOSTAL UNIDA DE COLOMBIA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (36, 'IGLESIA CRISTIANA UNIÓN', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (37, 'CENTRO DE FE Y ESPERANZA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (38, 'IGLESIA TIBERIA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (39, 'IGLESIA LUZ Y VIDA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (40, 'IGLESIA AMOR Y VIDA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (41, 'IGLESIA CRISTO EL REY', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (42, 'IGLESIA CASA DE ALABANZA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (43, 'IGLESIA DE DIOS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (44, 'IGLESIA CRUZADA CRISTIANA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (45, 'IGLESIA PRESBITERIANA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (46, 'IGLESIA REMANSO DE PAZ', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (47, 'IGLESIA CATÓLICA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (48, 'IGLESIA PENTECOSTAL', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (49, 'IGLESIA ASAMBLEAS DE DIOS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (50, 'IGLESIA MONTE HOREB', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (51, 'IGLESIA DIOS ES AMOR', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (52, 'IGLESIA ATENAS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (53, 'IGLESIA BAUTISTA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (54, 'IGLESIA PANAMERICANA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (55, 'IGLESIA HERMANOS MENONITAS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (56, 'IGLESIA APOSTÓLICA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (57, 'IGLESIA PALABRA DE VIDA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (58, 'IGLESIA CRISTO CENTRO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (59, 'IGLESIA LIBRE', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (60, 'MISIÓN INTERAMERICANA DE COLOMBIA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (61, 'IGLESIA EVANGÉLICA LAS PALOMAS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (62, 'MISIÓN CORNERSTONE', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (63, 'IGLESIA EVANGÉLICA TEMPLO DE BELÉN ', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (64, 'IGLESIA EL VERBO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (65, 'IGLESIA APOSENTO ALTO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (66, 'CASA DE ORACIÓN DE RIOACHA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (67, 'IGLESIA LUTERANA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (68, 'IGLESIA EVANGELIO VIVO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (69, 'IGLESIAS PUERTAS AL CIELO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (70, 'IGLESIA LUZ Y VERDAD', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (71, 'IGLESIA ADVENTISTA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (72, 'IGLESIA CASA DE DIOS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (73, 'INTEGRACIÓN CRISTIANA DE FE Y ORACIÓN (ICFO)', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (74, 'IGLESIA CENTRO CRISTIANO SILOÉ', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (75, 'IGLESIA MISIONERA MUNDIAL', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (76, 'IGLESIA NUEVA VIDA ', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (77, 'IGLESIA PÉRGAMO', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (78, 'IGLESIA LOS EFESIOS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (79, 'IGLESIA CRISTO MI ÚNICA ESPERANZA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (80, 'IGLESIA SARDI', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (81, 'IGLESIA ALIANZA COLOMBIANA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (82, 'IGLESIA PUERTAS ABIERTAS', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (83, 'IGLESIA CRISTO TE LLAMA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (84, 'IGLESIA CONFRATERNIDAD', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (85, 'IGLESIA UNIÓN MISIONERA', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (86, 'CENTRO DE AMOR Y FE', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (87, 'IGLESIA CARISMÁTICA VISIÓN A LAS NACIONES ', '', '2011-05-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_iglesia (id, nombre, descripcion, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (88, 'IGLESIA AGUA DE VIDA', '', '2011-05-06', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_maternidad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_maternidad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (0, 'NO APLICA', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_maternidad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'GESTANTE', '2013-05-16', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_maternidad (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'LACTANTE', '2013-05-16', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_presponsable; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'ESTADO COLOMBIANO', 39, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'DIJIN', 7, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (101, 'LOS RASTROJOS', 14, '2013-06-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (102, 'LOS URABEÑOS', 14, '2013-06-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (103, 'LOS PAISAS', 14, '2013-06-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (104, 'ÁGUILAS NEGRAS', 14, '2013-06-06', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'INPEC', 2, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'DAS', 2, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'CTI', 38, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'PARAMILITARES', 39, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'AUC', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'ACCU', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'AUTODEFENSAS DE PUERTO BOYACA', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (18, 'AUTODEFENSAS DE RAMON ISAZA', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'AUTODEFENSAS DE LOS LLANOS ORIENTALES', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'FUERZA PUBLICA', 1, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (20, 'AUTODEFENSAS DE SANTANDER Y SUR DEL CESAR', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (21, 'AUTODEFENSAS DE CASANARE', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (22, 'AUTODEFENSAS DE CUNDINAMARCA', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (23, 'AUTODEFENSAS CAMPESINAS DEL MAGDALENA MEDIO, ACMM', 14, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (24, 'AGENTE EXTRANJERO', 36, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (25, 'GUERRILLA', 40, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (26, 'MILICIAS', 25, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (27, 'FARC-EP', 25, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (28, 'ELN', 25, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (29, 'MOVIMIENTO JAIME BATEMAN CAYON', 25, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'FUERZAS MILITARES', 2, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (30, 'ERP', 25, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (31, 'EPL', 25, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (32, 'ERG', 25, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (33, 'GRUPOS DE INTOLERANCIA SOCIAL', 36, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (34, 'INFORMACION CONTRADICTORIA', NULL, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (35, 'SIN INFORMACIÓN', NULL, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (36, 'OTROS', NULL, '2001-06-13', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (37, 'COMBATIENTES', NULL, '2004-01-20', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (38, 'FISCALIA', 1, '2004-07-14', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (39, 'POLO ESTATAL', NULL, '2009-09-20', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'EJERCITO', 2, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (40, 'POLO INSURGENTE', NULL, '2009-09-20', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'ARMADA', 2, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'FUERZA AEREA', 2, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'POLICÍA', 2, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'GAULA', 3, '2001-01-30', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_presponsable (id, nombre, papa, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'SIJIN', 7, '2001-01-30', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_profesion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'ABOGADO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'RELIGIOSO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (101, 'AGRICULTOR/A', '2014-02-03', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'INVESTIGADOR/A SOCIAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (12, 'TÉCNICO/A - TECNÓLOGO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (13, 'ANTROPÓLOGO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (14, 'ARTISTA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (15, 'ECONOMISTA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (16, 'CONTADOR PÚBLICO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (17, 'ODONTÓLOGO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (18, 'SOCIÓLOGO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (19, 'TRABAJADOR/A SOCIAL', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'EDUCADOR/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (20, 'ADMINISTRADOR PUBLICO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (21, 'OTRO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (22, 'SIN INFORMACIÓN', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'MÉDICO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'ENFERMERO/A (A)', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'PERIODISTA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'ESTUDIANTE', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'DEFENSOR/A DE DDHH', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'INGENIERO/A', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_profesion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'SACERDOTE', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_rangoedad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_rangoedad (id, nombre, rango, limiteinferior, limitesuperior, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'R1', 'De 0 a 15 Años', 0, 15, '2001-03-23', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_rangoedad (id, nombre, rango, limiteinferior, limitesuperior, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (2, 'R2', 'De 16 a 25 Años', 16, 25, '2001-03-23', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_rangoedad (id, nombre, rango, limiteinferior, limitesuperior, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (3, 'R3', 'De 26 a 45 Años', 26, 45, '2001-03-23', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_rangoedad (id, nombre, rango, limiteinferior, limitesuperior, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (4, 'R4', 'De 46 a 60', 46, 60, '2001-03-23', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_rangoedad (id, nombre, rango, limiteinferior, limitesuperior, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'R5', 'De 61 en Adelante', 61, 130, '2001-03-23', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_rangoedad (id, nombre, rango, limiteinferior, limitesuperior, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'SN', 'SIN INFORMACIÓN', -1, -1, '2001-03-23', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_region; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_region (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (10, 'EJE CAFETERO Y TOLIMA GRANDE', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_region (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (11, 'EXTERIOR', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_region (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (5, 'COSTA ATLANTICA', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_region (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (6, 'ANTIOQUIA CHOCO SANT', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_region (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (7, 'LLANOS', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_region (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (8, 'CENTRO', '2001-01-01', NULL, NULL, NULL, NULL);
INSERT INTO sivel2_gen_region (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (9, 'SUR OCCIDENTE', '2001-01-01', NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;

SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: sivel2_gen_resagresion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sivel2_gen_resagresion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'MUERTO', NULL, '2001-01-01', NULL, '2016-07-19 00:00:00', '2016-07-19 00:00:00');
INSERT INTO sivel2_gen_resagresion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'HERIDO', NULL, '2001-01-01', NULL, '2016-07-19 00:00:00', '2016-07-19 00:00:00');
INSERT INTO sivel2_gen_resagresion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (3, 'PRIVADO DE LA LIBERTAD', NULL, '2001-01-01', NULL, '2016-07-19 00:00:00', '2016-07-19 00:00:00');


--
-- Name: sivel2_gen_resagresion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sivel2_gen_resagresion_id_seq', 101, true);


--
-- PostgreSQL database dump complete
--

-- Volvemos a habilitar integridad

ALTER TABLE ONLY sivel2_gen_categoria
  ADD CONSTRAINT categoria_contadaen_fkey FOREIGN KEY (contadaen) 
  REFERENCES sivel2_gen_categoria(id); 
ALTER TABLE ONLY sivel2_gen_presponsable
  ADD CONSTRAINT presponsable_papa_fkey FOREIGN KEY (papa) 
  REFERENCES sivel2_gen_presponsable(id);


--- sivel2_sjr


-- Novedades a tablas basicas de sivel2_gen

      
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET search_path = public, pg_catalog;


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


-- Volcado de tablas basicas

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

