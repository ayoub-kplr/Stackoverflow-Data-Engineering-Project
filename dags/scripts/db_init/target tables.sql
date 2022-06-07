drop table if exists dwh.user_dim cascade;

CREATE TABLE IF NOT EXISTS dwh.user_dim
(
    user_key serial primary key,
    user_id bigint,
    creation_date timestamp without time zone,
    last_modified_date timestamp without time zone,
    last_access_date timestamp without time zone,
    display_name character varying(50) COLLATE pg_catalog."default",
    user_type character varying(50) COLLATE pg_catalog."default",
    accept_rate double precision,
    badge_counts_bronze integer,
    badge_counts_silver integer,
    badge_counts_gold integer,
    reputation integer,
    reputation_change_in_year integer,
    reputation_change_in_quarter integer,
    reputation_change_month integer,
    reputation_change_week integer,
    reputation_change_day integer,
    location character varying(50) COLLATE pg_catalog."default",
    start_date date,
    end_date date
    
);



insert into dwh.user_dim(user_key,user_id) values (-1,-1);

drop table if exists dwh.answer_dim cascade;

CREATE TABLE IF NOT EXISTS dwh.answer_dim
(
    answer_key integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    answer_id bigint,
    answer_date date,
    question_id bigint,
    owner_user_id bigint,
    creation_date timestamp without time zone,
    last_activity_date timestamp without time zone,
    last_edit_date timestamp without time zone,
	unique(answer_id)
	
);


insert into dwh.answer_dim(answer_key,answer_id) values (-1,-1);

DROP TABLE IF EXISTS dwh.question_dim cascade;

CREATE TABLE IF NOT EXISTS dwh.question_dim
(
    --question_key integer NOT NULL DEFAULT nextval('staging.questions_staging_question_key_seq'::regclass),
	question_key integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    question_id bigint,
    dt date,
    creation_date timestamp without time zone,
    activity_date timestamp without time zone,
    last_edit_date timestamp without time zone,
    title text COLLATE pg_catalog."default",
    closed_date timestamp without time zone,
    closed_reason text COLLATE pg_catalog."default",
    locked_date timestamp without time zone,
	unique(question_id)
);


insert into dwh.question_dim(question_key,question_id) values (-1,-1);

DROP TABLE if exists dwh.tag_group_dim cascade;

CREATE TABLE IF NOT EXISTS dwh.tag_group_dim
(
tag_group_key bigint not null,
insert_date date,
CONSTRAINT tag_bridge_pk PRIMARY KEY (tag_group_key)
);

insert into dwh.tag_group_dim(tag_group_key) values (-1);

DROP TABLE if exists dwh.tag_group_bridge;

CREATE TABLE IF NOT EXISTS dwh.tag_group_bridge 
(
tag_group_key bigint NOT NULL,
tag_key bigint NOT NULL,
insert_date date,
CONSTRAINT fk_tag_bridge_group foreign key(tag_group_key) REFERENCES dwh.tag_group_dim(tag_group_key),	
CONSTRAINT fk_tag_bridge_key foreign key(tag_key) REFERENCES dwh.tag_dim(tag_key),
UNIQUE (tag_group_key, tag_key)
);

DROP TABLE if exists dwh.tag_dim cascade;

CREATE TABLE IF NOT EXISTS dwh.tag_dim
(
    tag_key bigint ,
    tag_desc text COLLATE pg_catalog."default",
	insert_date date,
	CONSTRAINT tag_dim_key PRIMARY KEY (tag_key)
);

DROP TABLE if exists dwh.question_answer_fact;

CREATE TABLE dwh.question_answer_fact 
(
	question_date date,
	question_key integer,
	answer_key integer,
	question_owner_key integer,
	answer_owner_key integer,
	tag_group_key integer,
	answer_count integer,
	question_score integer,
	question_view_count integer,
	is_answered integer,
	is_answer_accepted integer,
	accepted_answer_score integer,
	insert_date date,
	CONSTRAINT fk_question FOREIGN KEY(question_key) REFERENCES dwh.question_dim(question_key),
	CONSTRAINT fk_answer foreign key(answer_key) REFERENCES dwh.answer_dim(answer_key),
	CONSTRAINT fk_question_owner_key foreign key(question_owner_key) REFERENCES dwh.user_dim(user_key),
	CONSTRAINT fk_answer_owner_key foreign key(answer_owner_key) REFERENCES dwh.user_dim(user_key),
	CONSTRAINT fk_tag_group_key foreign key(tag_group_key) REFERENCES dwh.tag_group_dim(tag_group_key)
	
);

