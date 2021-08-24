CREATE TABLE public.movie_companies (
    id integer NOT NULL,
    movie_id integer NOT NULL REFERENCES title(id),
    company_id integer NOT NULL REFERENCES company_name(id),
    company_type_id integer NOT NULL REFERENCES company_type(id),
    note text
);

CREATE TABLE public.movie_info_idx (
    id integer NOT NULL PRIMARY KEY,
    movie_id integer NOT NULL REFERENCES title(id),
    info_type_id integer NOT NULL REFERENCES info_type(id),
    info text NOT NULL,
    note text
);

CREATE TABLE public.movie_info (
    id integer NOT NULL PRIMARY KEY,
    movie_id integer NOT NULL REFERENCES title(id),
    info_type_id integer NOT NULL REFERENCES info_type(id),
    info text NOT NULL,
    note text
);

CREATE TABLE public.person_info (
    id integer NOT NULL PRIMARY KEY,
    person_id integer NOT NULL REFERENCES name(id),
    info_type_id integer NOT NULL REFERENCES info_type(id),
    info text NOT NULL,
    note text
);

CREATE TABLE public.movie_keyword (
    id integer NOT NULL PRIMARY KEY,
    movie_id integer NOT NULL REFERENCES title(id),
    keyword_id integer NOT NULL REFERENCES keyword(id)
);

CREATE TABLE public.aka_title (
    id integer NOT NULL PRIMARY KEY,
    movie_id integer NOT NULL,
    title text NOT NULL,
    imdb_index text,
    kind_id integer NOT NULL REFERENCES kind_type(id),
    production_year integer,
    phonetic_code text,
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    note text,
    md5sum text
);


CREATE TABLE public.title (
    id integer NOT NULL PRIMARY KEY,
    title text NOT NULL,
    imdb_index text,
    kind_id integer NOT NULL REFERENCES kind_type(id),
    production_year integer,
    imdb_id integer,
    phonetic_code text,
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    series_years text,
    md5sum text
);


CREATE TABLE public.movie_link (
    id integer NOT NULL PRIMARY KEY,
    movie_id integer NOT NULL REFERENCES title(id),
    linked_movie_id integer NOT NULL REFERENCES title(id),
    link_type_id integer NOT NULL REFERENCES link_type(id)
);


CREATE TABLE public.cast_info (
    id integer NOT NULL PRIMARY KEY,
    person_id integer NOT NULL REFERENCES name(id),
    movie_id integer NOT NULL REFERENCES title(id),
    person_role_id integer REFERENCES char_name(id),
    note text,
    nr_order integer,
    role_id integer NOT NULL REFERENCES role_type(id)
);



CREATE TABLE public.complete_cast (
    id integer NOT NULL PRIMARY KEY,
    movie_id integer REFERENCES title(id),
    subject_id integer NOT NULL,
    status_id integer NOT NULL
);



CREATE TABLE public.aka_name (
    id integer NOT NULL PRIMARY KEY,
    person_id integer NOT NULL REFERENCES name(id),
    name text NOT NULL,
    imdb_index text,
    name_pcode_cf text,
    name_pcode_nf text,
    surname_pcode text,
    md5sum text
);



CREATE TABLE char_name (
    id integer NOT NULL PRIMARY KEY,
    name text NOT NULL,
    imdb_index varchar(2),
    imdb_id integer,
    name_pcode_nf varchar(5),
    surname_pcode varchar(5),
    md5sum varchar(32)
);

CREATE TABLE comp_cast_type (
    id integer NOT NULL PRIMARY KEY,
    kind varchar(32) NOT NULL
);

CREATE TABLE company_name (
    id integer NOT NULL PRIMARY KEY,
    name text NOT NULL,
    country_code varchar(6),
    imdb_id integer,
    name_pcode_nf varchar(5),
    name_pcode_sf varchar(5),
    md5sum varchar(32)
);

CREATE TABLE company_type (
    id integer NOT NULL PRIMARY KEY,
    kind varchar(32)
);


CREATE TABLE info_type (
    id integer NOT NULL PRIMARY KEY,
    info varchar(32) NOT NULL
);

CREATE TABLE keyword (
    id integer NOT NULL PRIMARY KEY,
    keyword text NOT NULL,
    phonetic_code varchar(5)
);

CREATE TABLE kind_type (
    id integer NOT NULL PRIMARY KEY,
    kind varchar(15)
);

CREATE TABLE link_type (
    id integer NOT NULL PRIMARY KEY,
    link varchar(32) NOT NULL
);




CREATE TABLE name (
    id integer NOT NULL PRIMARY KEY,
    name text NOT NULL,
    imdb_index varchar(9),
    imdb_id integer,
    gender varchar(1),
    name_pcode_cf varchar(5),
    name_pcode_nf varchar(5),
    surname_pcode varchar(5),
    md5sum varchar(32)
);

CREATE TABLE role_type (
    id integer NOT NULL PRIMARY KEY,
    role_name varchar(32) NOT NULL
);
