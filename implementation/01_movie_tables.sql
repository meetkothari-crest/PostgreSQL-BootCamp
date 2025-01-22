-- create table movies_actors (
-- 	movie_id int references movies (movie_id),
-- 	actor_id int references actors (actor_id),
-- 	primary key (movie_id, actor_id)
-- );


-- create table movies_revenues (
-- 	revenue_id serial primary key,
-- 	movie_id int references movies (movie_id),
-- 	revenues_domestic numeric(10,2),
-- 	revenues_international numeric(10,2)
-- );


-- create table movies (
-- 	movie_id serial primary key,
-- 	movie_name varchar(100) not null,
-- 	movie_length int,
-- 	movie_lang varchar(20),
-- 	age_certificate varchar(10),
-- 	release_date DATE,
-- 	director_id INT references directors (director_id)
-- );


-- create table directors (
-- 	director_id serial primary key,
-- 	first_name varchar(150),
-- 	last_name varchar(150),
-- 	date_of_birth date,
-- 	nationality varchar(20),
-- 	add_date date,
-- 	update_date date
-- );


-- CREATE TABLE actors (
-- 	actor_id SERIAL PRIMARY KEY,
-- 	first_name VARCHAR(150),
-- 	last_name VARCHAR(150) NOT NULL,
-- 	gender CHAR(1),
-- 	date_of_birth DATE,
-- 	add_date DATE,
-- 	update_date DATE,
-- 	add_by VARCHAR(100)
-- );