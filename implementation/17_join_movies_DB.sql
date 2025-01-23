-- INNER JOIN

-- combine movies and directors tables

SELECT 
	m.movie_id,
	m.movie_name,
	m.movie_lang,

	d.director_id,
	d.first_name
FROM movies m
INNER JOIN 
	directors d
	ON m.director_id = d.director_id;


SELECT 
	m.movie_id,
	m.movie_name,
	m.movie_lang,
	m.director_id
FROM movies m
INNER JOIN 
	directors d
	ON m.director_id = d.director_id
WHERE 
	m.movie_lang = 'English'
	AND d.director_id = 3;

-- INNER JOIN with USING - when tables have the same column names

SELECT 
	*
FROM movies
INNER JOIN directors 
	USING (director_id);


SELECT 
	revenue_id, movie_id, movie_name, director_id 
FROM movies
INNER JOIN movies_revenues
	USING (movie_id);

-- join movies, movies_revenues, directors

SELECT
	*
FROM movies
INNER JOIN directors USING (director_id)
INNER JOIN movies_revenues USING (movie_id);

-- select movie name, director name, domestic revenues for all japanese movies

SELECT 
	m.movie_name,
	d.first_name || ' ' || d.last_name AS director_name,
	r.revenues_domestic
FROM movies m
INNER JOIN directors d
	ON m.director_id = d.director_id
INNER JOIN movies_revenues r
	ON m.movie_id = r.movie_id
WHERE 
	m.movie_lang = 'Japanese';


SELECT 
	movie_name,
	first_name,
	revenues_domestic
FROM movies
INNER JOIN directors 
	USING (director_id)
INNER JOIN movies_revenues
	USING (movie_id)
WHERE movie_lang = 'Japanese';

-- select movie name, director name for all english, chinese, japanese movies where domestic
-- where domestic revenue is greater than 100

SELECT 
	movie_name,
	first_name || ' ' || last_name AS director_name
FROM movies
INNER JOIN directors 
	USING (director_id)
INNER JOIN movies_revenues
	USING (movie_id)
WHERE 
	movie_lang IN ('Japanese', 'English', 'Chinese')
	AND revenues_domestic > 100;
	
-- select movie name, director name, movie language, total revenues for all top 5 movies

SELECT
	movie_name,
	first_name || ' ' || last_name AS director_name,
	movie_lang,,
	revenues_domestic + revenues_international AS total_rev
FROM movies
INNER JOIN directors
	USING (director_id)
INNER JOIN movies_revenues
	USING (movie_id)
ORDER BY
	4 DESC NULLS LAST
LIMIT 5;

-- what were the top 10 most profitable movies between year 2005 and 2008.

SELECT 
	movie_name,
	first_name || ' ' || last_name AS director_name,
	movie_lang,
	release_date,
	revenues_domestic + revenues_international AS revenues_total
FROM movies
INNER JOIN directors
	USING (director_id)
INNER JOIN movies_revenues
	USING (movie_id)
WHERE
	release_date BETWEEN '2005-01-01' AND '2007-12-31'
ORDER BY 4 DESC NULLS LAST
LIMIT 10;


-- can we INNER joins tables with diffrent columns data types ?
-- -> NO, have to do Explicit casting

CREATE table t1 (test INT);

CREATE table t2 (test VARCHAR(10));

SELECT 
	*
FROM t1 
INNER JOIN t2
	ON t1.test = t2.test; -- ERROR


SELECT 
	*
FROM t1 
INNER JOIN t2
	ON t1.test = t2.test::INT;

INSERT INTO t1 (test) VALUES (1), (2), (3);
INSERT INTO t2 (test) VALUES (1), (2), ('3'), ('ab'), ('cd');


SELECT
	*
FROM t1
INNER JOIN t2
	ON t1.test::TEXT = t2.test;

--
-- LEFT JOIN
--

CREATE TABLE table_left(
	p_id SERIAL PRIMARY KEY,
	p_name VARCHAR(100)
);

CREATE TABLE table_right(
	p_id SERIAL PRIMARY KEY,
	p_name VARCHAR(100)
);

INSERT INTO table_left (p_id, p_name) VALUES 
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(5, 'Mics');

INSERT INTO table_right (p_id, p_name) VALUES 
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(4, 'Pen'),
(7, 'Papers');


SELECT * FROM table_left;

SELECT * FROM table_right;

-- joins the tables with LEFT JOIN

SELECT
	*
FROM table_left l
LEFT JOIN table_right r
	ON l.p_id = r.p_id;

-- list all the movies with directors first and last names, and movie name

SELECT
	first_name,
	last_name,
	movie_name
FROM directors 
LEFT JOIN movies
	USING (director_id);

SELECT
	first_name,
	last_name,
	movie_name
FROM movies 
LEFT JOIN directors
	USING (director_id);

-- where condition

SELECT
	first_name, 
	last_name,
	movie_name,
	movie_lang
FROM movies
LEFT JOIN directors
	USING (director_id)
WHERE movie_lang IN ('English', 'Chinese')
ORDER BY 4;

-- Counts all movies for each directors

SELECT
	first_name || ' ' || last_name AS "full_name",
	COUNT(movie_name)
FROM directors
LEFT JOIN movies
	USING (director_id)
GROUP BY full_name
ORDER BY 2 DESC;

-- get all the movies with age certification for all directors where nationalities are 
-- 'American', 'Chinese' , 'Japanese'

SELECT
	director_id,
	movie_name,
	age_certificate
FROM directors
LEFT JOIN movies
	USING (director_id)
WHERE 
	nationality IN ('American', 'Chinese', 'Japanese')
ORDER BY director_id;

-- get all the total revenues done by each films for each directors

SELECT
	first_name, 
	last_name,
	SUM(revenues_domestic + revenues_international) AS revenues_total
FROM directors
LEFT JOIN movies
	USING (director_id)
LEFT JOIN movies_revenues
	USING (movie_id)
GROUP BY first_name, last_name;


SELECT
	first_name, 
	last_name,
	SUM(revenues_domestic + revenues_international) AS revenues_total,
	COUNT(movie_name)
FROM directors
LEFT JOIN movies
	USING (director_id)
LEFT JOIN movies_revenues
	USING (movie_id)
GROUP BY first_name, last_name
ORDER BY 3 DESC NULLS LAST;


--
-- RIGHT JOIN
--

SELECT *
FROM table_left l
RIGHT JOIN table_right r
	ON l.p_id = r.p_id;

-- list all the movies with directors first and last name, and movie name

SELECT 
	movie_name,
	first_name,
	last_name
FROM directors
RIGHT JOIN movies
	USING (director_id);

-- where condition,

SELECT 
	first_name,
	last_name,
	movie_name,
	movie_lang
FROM movies
RIGHT JOIN directors
	USING (director_id)
WHERE 
	movie_lang = 'English';


-- counts all movies for each directors
SELECT
	first_name || ' ' || last_name AS "full_name",
	COUNT(*) AS "total movies"
FROM directors
RIGHT JOIN movies
	USING (director_id)
GROUP BY full_name
ORDER BY 2 DESC;

-- FULL JOIN - returns every rows from all the join tables

SELECT *
FROM table_right
FULL JOIN table_left
	ON table_left.p_id = table_right.p_id;

-- joins multiple tables via JOIN

SELECT *
FROM movies
JOIN directors
	USING (director_id)
JOIN movies_revenues
	USING (movie_id);

SELECT *
FROM actors
JOIN movies_actors
	USING (actor_id)
JOIN movies_revenues
	USING (movie_id)
JOIN movies
	USING (movie_id)
JOIN directors
	USING (director_id);


-- JOIN == INNER JOIN

-- SELF join

SELECT *
FROM table_left l1
JOIN table_left l2
	ON l1.p_id = l2.p_id;

SELECT *
FROM table_left
JOIN table_left
	USING (p_id); -- ERROR

-- self join directors table

SELECT *
FROM directors d1
INNER JOIN directors d2
	ON d1.director_id = d2.director_id;

-- finds all pair of movies that have the same movie length

SELECT 
	m1.movie_name,
	m2.movie_name,
	m1.movie_length
FROM movies m1
INNER JOIN movies m2
	ON m1.movie_length = m2.movie_length
AND m1.movie_name != m2.movie_name;

--
-- CROSS JOIN
--

SELECT * 
FROM table_left
CROSS JOIN table_right;

SELECT *
FROM table_left, table_right;

SELECT *
FROM table_right
INNER JOIN table_left
	ON true;

--
-- NATURAL [INNER, LEFT, RIGHT] JOIN, by default INNER JOIN
--

SELECT *
FROM table_left
NATURAL JOIN table_right;

SELECT *
FROM movies
NATURAL JOIN directors;

-- append tables with different columns

CREATE TABLE table1(
	add_date DATE,
	col1 INT,
	col2 INT,
	col3 INT
);

CREATE TABLE table2(
	add_date DATE,
	col1 INT,
	col2 INT,
	col3 INT,
	col4 INT,
	col5 INT
);

INSERT INTO table1 (add_date, col1, col2, col3) VALUES
('2020-01-01', 1, 2, 3),
('2020-01-02', 4, 5, 6);

INSERT INTO table2 (add_date, col1, col2, col3, col4, col5) VALUES
('2020-01-01', NULL, 7, 8, 9, 10),
('2020-01-02', 11, 12, 13, 14, 15),
('2020-01-03', 16, 17, 18, 19, 20);

SELECT * FROM table1;
SELECT * FROM table2;

SELECT COALESCE(10,1);
SELECT COALESCE(NULL, 1);

SELECT 
	COALESCE(t1.add_date, t2.add_date) as add_date,
	COALESCE(t1.col1, t2.col1) as col1,
	COALESCE(t1.col2, t2.col2) as col2,
	COALESCE(t1.col3, t2.col3) as col3,
	t2.col4, 
	t2.col5
FROM table1 t1
FULL OUTER JOIN table2 t2
	ON t1.add_date = t2.add_date;


SELECT 
	COALESCE(t1.add_date, t2.add_date) as add_date,
	COALESCE(t1.col1, t2.col1) as col1,
	COALESCE(t1.col2, t2.col2) as col2,
	COALESCE(t1.col3, t2.col3) as col3
FROM table2 t1
FULL OUTER JOIN table1 t2
	ON t1.add_date = t2.add_date;

