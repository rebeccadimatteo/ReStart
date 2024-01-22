CREATE DATABASE "ReStart"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
CREATE TABLE public.utente
(
    id serial NOT NULL,
    nome text NOT NULL,
    cognome text NOT NULL,
    cod_fiscale text NOT NULL,
    data_nascita date NOT NULL,
    luogo_nascita text NOT NULL,
    genere text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    lavoro_adatto text,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.utente
    OWNER to postgres;

CREATE TABLE public."CA"
(
    id serial NOT NULL,
    nome text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."CA"
    OWNER to postgres;

CREATE TABLE public."ADS"
(
    id serial NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."ADS"
    OWNER to postgres;

CREATE TABLE public."Evento"
(
    id serial NOT NULL,
    nome text NOT NULL,
    descrizione text NOT NULL,
    data date NOT NULL,
    approvato boolean NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."Evento"
    OWNER to postgres;

CREATE TABLE public."SupportoMedico"
(
    id serial NOT NULL,
    nome text NOT NULL,
    cognome text NOT NULL,
    descrizione text NOT NULL,
    tipo text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."SupportoMedico"
    OWNER to postgres;

CREATE TABLE public."AnnuncioDiLavoro"
(
    id serial NOT NULL,
    nome text NOT NULL,
    descrizione text NOT NULL,
    approvato boolean NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."AnnuncioDiLavoro"
    OWNER to postgres;

CREATE TABLE public."CorsoDiFormazione"
(
    id serial NOT NULL,
    nome_corso text NOT NULL,
    nome_responsabile text NOT NULL,
    cognome_responsabile text NOT NULL,
    descrizione text NOT NULL,
    url_corso text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."CorsoDiFormazione"
    OWNER to postgres;

CREATE TABLE public."AlloggioTemporaneo"
(
    id serial NOT NULL,
    nome text NOT NULL,
    descrizione text NOT NULL,
    tipo text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."AlloggioTemporaneo"
    OWNER to postgres;

CREATE TABLE public."Candidatura"
(
    id_utente serial NOT NULL,
    id_annuncio serial NOT NULL,
    PRIMARY KEY (id_utente, id_annuncio),
    CONSTRAINT "FK_Utente" FOREIGN KEY (id_utente)
        REFERENCES public.utente (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT id_annuncio FOREIGN KEY (id_annuncio)
        REFERENCES public."AnnuncioDiLavoro" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE
);

ALTER TABLE IF EXISTS public."Candidatura"
    OWNER to postgres;

CREATE TABLE public."Immagine"
(
    id serial NOT NULL,
    id_utente serial NOT NULL,
    id_evento serial NOT NULL,
    id_annuncio serial NOT NULL,
    id_supporto serial NOT NULL,
    id_alloggio serial NOT NULL,
    id_corso serial NOT NULL,
    immagine text NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT "FK_Utente" FOREIGN KEY (id_utente)
        REFERENCES public.utente (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_evento)
        REFERENCES public."Evento" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_annuncio)
        REFERENCES public."AnnuncioDiLavoro" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_supporto)
        REFERENCES public."SupportoMedico" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_alloggio)
        REFERENCES public."AlloggioTemporaneo" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_corso)
        REFERENCES public."CorsoDiFormazione" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE
);

ALTER TABLE IF EXISTS public."Immagine"
    OWNER to postgres;

CREATE TABLE public."Contatti"
(
    id serial NOT NULL,
    id_utente serial NOT NULL,
    id_ca serial NOT NULL,
    id_ads serial NOT NULL,
    id_evento serial NOT NULL,
    id_annuncio serial NOT NULL,
    id_supporto serial NOT NULL,
    id_alloggio serial NOT NULL,
    num_telefono text,
    email text NOT NULL,
    sito text,
    PRIMARY KEY (id),
    FOREIGN KEY (id_utente)
        REFERENCES public.utente (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_ca)
        REFERENCES public."CA" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_ca)
        REFERENCES public."CA" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_ads)
        REFERENCES public."ADS" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_evento)
        REFERENCES public."Evento" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_annuncio)
        REFERENCES public."AnnuncioDiLavoro" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_supporto)
        REFERENCES public."SupportoMedico" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (id_alloggio)
        REFERENCES public."AlloggioTemporaneo" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE
);

ALTER TABLE IF EXISTS public."Contatti"
    OWNER to postgres;

CREATE TABLE public."Indirizzo"
(
    id serial NOT NULL,
    id_utente serial NOT NULL,
    id_ca serial NOT NULL,
    id_ads serial NOT NULL,
    id_evento serial NOT NULL,
    id_annuncio serial NOT NULL,
    id_supporto serial NOT NULL,
    id_alloggio serial NOT NULL,
    citta text NOT NULL,
    provincia text NOT NULL,
    via text NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_utente FOREIGN KEY (id_utente)
        REFERENCES public.utente (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT fk_ca FOREIGN KEY (id_ca)
        REFERENCES public."CA" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT fk_ads FOREIGN KEY (id_ads)
        REFERENCES public."ADS" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT fk_evento FOREIGN KEY (id_evento)
        REFERENCES public."Evento" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT fk_annuncio FOREIGN KEY (id_annuncio)
        REFERENCES public."AnnuncioDiLavoro" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT fk_supporto FOREIGN KEY (id_supporto)
        REFERENCES public."SupportoMedico" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT fk_alloggio FOREIGN KEY (id_alloggio)
        REFERENCES public."AlloggioTemporaneo" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY IMMEDIATE
);

ALTER TABLE IF EXISTS public."Indirizzo"
    OWNER to postgres;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_utente DROP NOT NULL;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_ca DROP NOT NULL;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_ads DROP NOT NULL;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_evento DROP NOT NULL;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_annuncio DROP NOT NULL;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_supporto DROP NOT NULL;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_alloggio DROP NOT NULL;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_utente DROP NOT NULL;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_ca DROP NOT NULL;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_ads DROP NOT NULL;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_evento DROP NOT NULL;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_annuncio DROP NOT NULL;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_supporto DROP NOT NULL;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_alloggio DROP NOT NULL;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_utente DROP NOT NULL;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_evento DROP NOT NULL;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_annuncio DROP NOT NULL;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_supporto DROP NOT NULL;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_alloggio DROP NOT NULL;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_corso DROP NOT NULL;

ALTER TABLE IF EXISTS public.utente
    RENAME TO "Utente";

ALTER TABLE IF EXISTS public."Contatti"
    ADD UNIQUE (email);

ALTER TABLE IF EXISTS public."Contatti"
    ADD UNIQUE (num_telefono);

ALTER TABLE IF EXISTS public."Utente"
    ADD UNIQUE (cod_fiscale);

ALTER TABLE IF EXISTS public."Utente"
    ADD UNIQUE (username);

ALTER TABLE IF EXISTS public."ADS"
    ADD UNIQUE (username);

ALTER TABLE IF EXISTS public."CA"
    ADD UNIQUE (username);

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_utente DROP DEFAULT;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_ca DROP DEFAULT;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_ads DROP DEFAULT;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_evento DROP DEFAULT;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_annuncio DROP DEFAULT;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_supporto DROP DEFAULT;

ALTER TABLE IF EXISTS public."Indirizzo"
    ALTER COLUMN id_alloggio DROP DEFAULT;
ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_utente DROP DEFAULT;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_evento DROP DEFAULT;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_annuncio DROP DEFAULT;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_supporto DROP DEFAULT;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_alloggio DROP DEFAULT;

ALTER TABLE IF EXISTS public."Immagine"
    ALTER COLUMN id_corso DROP DEFAULT;
ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_utente DROP DEFAULT;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_ca DROP DEFAULT;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_ads DROP DEFAULT;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_evento DROP DEFAULT;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_annuncio DROP DEFAULT;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_supporto DROP DEFAULT;

ALTER TABLE IF EXISTS public."Contatti"
    ALTER COLUMN id_alloggio DROP DEFAULT;
ALTER TABLE IF EXISTS public."Evento"
    ADD COLUMN id_ca integer;
ALTER TABLE IF EXISTS public."Evento"
    ADD FOREIGN KEY (id_ca)
        REFERENCES public."CA" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID;
ALTER TABLE IF EXISTS public."AnnuncioDiLavoro"
    ADD COLUMN id_ca integer;
ALTER TABLE IF EXISTS public."AnnuncioDiLavoro"
    ADD FOREIGN KEY (id_ca)
        REFERENCES public."CA" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID;
ALTER TABLE public."Evento"
    ALTER COLUMN data TYPE timestamp without time zone ;

ALTER TABLE IF EXISTS public."Indirizzo"
    ADD COLUMN id_corso integer;
ALTER TABLE IF EXISTS public."Indirizzo"
    ADD CONSTRAINT fk_corso FOREIGN KEY (id_corso)
        REFERENCES public."CorsoDiFormazione" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID;