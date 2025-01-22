-- COUNT()

SELECT COUNT(*) FROM movies;

SELECT COUNT(movie_length) FROM movies;

-- count all distinct movies languages

SELECT 
	COUNT(DISTINCT movie_lang) 
FROM movies;

SELECT 
	COUNT(*)
FROM movies
WHERE movie_lang = 'English';

SELECT COUNT(1) FROM movies;


-- SUM()

SELECT * FROM movies_revenues;

SELECT SUM(revenues_domestic)
FROM movies_revenues;

SELECT SUM(revenues_domestic)
FROM movies_revenues
WHERE revenues_domestic > 200;

SELECT SUM(movie_length)
FROM movies
WHERE movie_lang = 'English';

SELECT SUM(DISTINCT revenues_domestic)
FROM movies_revenues;


-- MIN(), MAX()

SELECT MAX(movie_length) FROM movies;

SELECT MIN(movie_length) FROM movies;

SELECT MAX(movie_length)
FROM movies
WHERE movie_lang = 'English';

SELECT MAX(release_date) 
FROM movies
WHERE movie_lang = 'English';

SELECT MIN(release_date)
FROM movies
WHERE movie_lang = 'Chinese';

SELECT MIN(movie_name) 
FROM movies;

SELECT MAX(movie_name) 
FROM movies;


-- GREATEST(list), LEAST(list) 
-- The list should be of same datatype

SELECT GREATEST(10,20,30);

SELECT LEAST(10,20,30);

SELECT GREATEST('aa', 'ab', 'ac');

SELECT LEAST('aa', 'ab', 'ac');

SELECT 
	movie_id,
	revenues_domestic,
	revenues_international,
	GREATEST(revenues_domestic, revenues_international) AS "Greatest",
	LEAST(revenues_domestic, revenues_international) AS "Least"
FROM movies_revenues;


-- AVG()

SELECT 
	AVG(movie_length)
FROM movies;


SELECT 
	AVG(movie_length)
FROM movies
WHERE movie_lang = 'English';


SELECT
	AVG(DISTINCT movie_length)
FROM movies
WHERE movie_lang = 'English';


SELECT
	AVG(movie_length),
	SUM(movie_length)
FROM movies
WHERE movie_lang = 'English';


CREATE TABLE demo_avg(
	num INT
);

INSERT INTO demo_avg (num) VALUES
(1),
(2),
(3),
(NULL);

SELECT * FROM demo_avg;

SELECT 
	AVG(num)
FROM demo_avg;

-- combining columns using mathematical operators
-- +, -, /, *, %

SELECT 1+2 AS addition;
SELECT 1-2 AS subtraction;
SELECT 10/3 AS division;
SELECT 10/3::NUMERIC AS division;

-- Get total revenues for all movies

SELECT 
	movie_id,
	revenues_domestic,
	revenues_international,
	(revenues_domestic + revenues_international) AS revenues_total
FROM movies_revenues
ORDER BY revenues_total DESC NULLS LAST;

