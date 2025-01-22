create table customers (
	customer_id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(150),
	age int
);


select * from customers;


insert into customers (first_name, last_name, email, age)
values 
('abc', 'xyz', 'abc@gmail.com', 30),
('cba', 'zyx', 'cba@gmail.com', '20');


insert into customers (first_name)
values 
('Let''s add_data');


insert into customers (first_name, age)
values
('test', 21)
returning *;

update customers
set email = 'test@gmail.com'
where customer_id = 6;

-- RETURNING

update customers
set
email = 'a@gmail.com'
where
customer_id = 5
returning *;


update customers 
set 
is_enable = 'Y';

select * from customers;


create table t_tags(
	id serial primary key,
	tag text unique,
	update_date timestamp default now()
);

insert into t_tags (tag)
values 
('one'),
('two');

-- UPSERT 

insert into t_tags (tag)
values 
('one'),
('Three')
on conflict (tag)
do nothing;


insert into t_tags (tag)
values 
('one')
on conflict (tag)
do 
	update set 
	tag = excluded.tag || '1',
	update_date = now();


select * from t_tags;

-- 

select * from movies;

SELECT first_name, last_name FROM actors;

SELECT first_name AS fname FROM actors;

SELECT first_name AS "fName" FROM actors;


SELECT 
	movie_name AS "Movie Name", 
	movie_lang AS "Language" 
FROM movies;

-- AS is optional

SELECT 
	movie_name "Movie Name", 
	movie_lang "Language" 
FROM movies;



SELECT 
	first_name || ' ' || last_name AS "Full Name"
FROM actors;


SELECT 1;

SELECT 2 * 5;


-- ORDER BY

SELECT 
	*
FROM movies
ORDER BY
	release_date DESC;


SELECT 
	 *
FROM movies
ORDER BY
	movie_name DESC,
	release_date ASC;


SELECT 
	first_name "First Name",
	last_name "Last Name"
FROM actors
ORDER BY
	"Last Name" DESC
;


SELECT 
	first_name,
	LENGTH(first_name)
FROM actors
;


SELECT 
	first_name,
	LENGTH(first_name) AS len
FROM actors
ORDER BY
	len DESC
;


SELECT 
	*
FROM actors
ORDER BY
	first_name ASC,
	date_of_birth DESC
;


SELECT
	first_name,
	last_name,
	date_of_birth
FROM actors
ORDER BY
	1 ASC,
	3 DESC
;


CREATE TABLE demo(
	num INT
);

INSERT INTO demo (num)
VALUES 
(1),
(2),
(3),
(4),
(NULL)
;

SELECT * FROM demo;

SELECT *
FROM demo
ORDER BY 
	num ASC
;

SELECT *
FROM demo
ORDER BY 
	num ASC NULLS FIRST
;

SELECT *
FROM demo
ORDER BY 
	num DESC
;

SELECT *
FROM demo
ORDER BY 
	num DESC NULLS LAST
;

DROP TABLE demo;

-- DISTINCT

SELECT 
	movie_lang
FROM movies
;

SELECT 
	DISTINCT movie_lang
FROM movies
;

SELECT 
	DISTINCT movie_lang
FROM movies
ORDER BY 
	movie_lang
;

SELECT 
	DISTINCT director_id
FROM movies
ORDER BY
	1
;


SELECT 
	DISTINCT movie_lang, director_id
FROM movies
ORDER BY
	1
;

SELECT 
	DISTINCT *
FROM movies
ORDER BY
	movie_id
;


SELECT * 
FROM movies
WHERE movie_lang = 'English'
;

SELECT * 
FROM movies
WHERE 
	movie_lang = 'English'
	AND age_certificate = '18'
;

SELECT * 
FROM movies
WHERE 
	movie_lang = 'English'
	OR movie_lang = 'Chinese'
;


SELECT *
FROM movies
WHERE 
	movie_lang = 'English'
	AND director_id = '8'
;

SELECT * 
FROM movies
WHERE 
	(movie_lang = 'English'
	OR movie_lang = 'Chinese')
	AND age_certificate = '12'
;

-- order of query : FROM before WHERE
-- order of query : WHERE before ORDER BY

-- without (), AND is processed first and the OR is processed second.

-- order of execution : FROM, WHERE, SELECT, ORDER BY

SELECT 
	first_name AS "First Name",
	last_name AS surname
FROM actors
WHERE 
	first_name = 'Tim'
;


SELECT *
FROM movies
WHERE 
	movie_length >= 100
ORDER BY
	movie_length
;

SELECT *
FROM movies
WHERE 
	movie_length <= 100
ORDER BY
	movie_length
;


SELECT *
FROM movies
WHERE 
	release_date > '1999-12-31'
ORDER BY 
	release_date
;

SELECT *
FROM movies
WHERE 
	movie_lang > 'English'
ORDER BY
	movie_lang
;


SELECT * 
FROM movies
WHERE 
	movie_lang != 'English'
ORDER BY
	movie_lang
;

-- LIMIT and OFFSET

SELECT * 
FROM movies
ORDER BY
	movie_length DESC
LIMIT 5
;


SELECT * 
FROM directors
WHERE 
	 nationality = 'American'
ORDER BY
	date_of_birth
LIMIT 5
;

SELECT * 
FROM actors
WHERE 
	gender = 'F'
ORDER BY
	date_of_birth DESC
LIMIT 10
;


SELECT *
FROM movies_revenues
ORDER BY
	revenues_domestic DESC NULLS LAST
LIMIT 10
;


SELECT *
FROM movies_revenues
ORDER BY
	revenues_domestic
LIMIT 10
;


-- OFFSET fromnumber

SELECT * 
FROM movies
ORDER BY movie_id
LIMIT 5
OFFSET 4
;

SELECT *
FROM movies_revenues
ORDER BY revenues_domestic DESC NULLS LAST
LIMIT 5
OFFSET 5 ROWS
;

-- FETCH clause
/*
OFFSET start {ROW | ROWS}
FETCH {FIRST | NEXT} [row_count] {ROW | ROWS} ONLY
*/

SELECT *
FROM movies
FETCH FIRST 2 ROW ONLY
;

SELECT *
FROM movies
ORDER BY movie_length DESC
FETCH FIRST 5 ROWS ONLY
;

SELECT *
FROM directors
ORDER BY date_of_birth
FETCH FIRST 5 ROW ONLY
;

SELECT *
FROM actors
WHERE gender = 'F'
ORDER BY date_of_birth DESC
FETCH FIRST 5 ROW ONLY
;

SELECT *
FROM movies
ORDER BY movie_length DESC
FETCH FIRST 5 ROW ONLY
OFFSET 4
;

-- IN , NOT IN

SELECT *
FROM movies
WHERE movie_lang IN ('English', 'Chinese', 'German')
ORDER BY movie_lang
;

SELECT *
FROM movies
WHERE movie_lang NOT IN ('English', 'Chinese', 'German')
ORDER BY movie_lang
;


SELECT * 
FROM movies
WHERE age_certificate IN ('13', 'PG')
ORDER BY age_certificate
;

SELECT * 
FROM movies
WHERE director_id NOT IN ('13', '10')
ORDER BY director_id
;


SELECT *
FROM actors
WHERE actor_id NOT IN (1,2,3,4)
ORDER BY actor_id
;

-- BETWEEN and NOT BETWEEN

SELECT *
FROM actors
WHERE date_of_birth BETWEEN '1990-01-01' AND '1995-12-31'
ORDER BY date_of_birth
;

SELECT *
FROM movies
WHERE release_date BETWEEN '1998-01-01' AND '2002-12-31'
ORDER BY release_date
;

SELECT *
FROM movies_revenues
WHERE revenues_domestic BETWEEN 100 AND 300
ORDER BY revenues_domestic
;


SELECT * 
FROM movies
WHERE 
	movie_lang = 'English'
	AND movie_length NOT BETWEEN 100 AND 200
ORDER BY movie_length
;

-- LIKE, ILIKE

SELECT 'hello' LIKE 'hello'

SELECT *
FROM actors
WHERE first_name LIKE 'A%'
ORDER BY first_name
;

SELECT *
FROM actors
WHERE last_name LIKE '%a'
ORDER BY last_name
;


SELECT * 
FROM actors
WHERE first_name LIKE '_____'
ORDER BY first_name
;


SELECT *
FROM actors
WHERE first_name LIKE '_l%'
ORDER BY first_name
;

SELECT *
FROM actors
WHERE first_name LIKE '%Tim%'

SELECT *
FROM actors
WHERE first_name ILIKE '%tiM%'

-- IS NULL, IS NOT NULL

SELECT * 
FROM actors
WHERE date_of_birth IS NULL
;


SELECT *
FROM actors
WHERE 
	date_of_birth IS NULL 
	OR first_name IS NULL
;


SELECT *
FROM movies_revenues
WHERE revenues_domestic IS NULL
ORDER BY revenue_id
;

SELECT * 
FROM movies_revenues
WHERE 
	revenues_domestic IS NULL 
	OR revenues_international IS NULL
;

SELECT * 
FROM movies_revenues
WHERE 
	revenues_domestic IS NULL 
	AND revenues_international IS NULL
;

SELECT *
FROM movies_revenues
WHERE revenues_domestic IS NOT NULL
;

-- concatenate

-- string concatenate operator ||

-- combining columns together : SELECT CONCAT(col1, col2) AS new_string

-- SELECT CONCAT_WS('|', col1, col2) AS new_string

SELECT 'Hello' || 'World' AS new_string;

SELECT 
	first_name || ' ' || last_name AS "Full Name"
FROM actors
;

SELECT 
	CONCAT(first_name, ' ', last_name) AS "Full Name"
FROM actors
ORDER BY first_name
;

SELECT 
	CONCAT_WS(', ', first_name, last_name, date_of_birth)
FROM actors
;
