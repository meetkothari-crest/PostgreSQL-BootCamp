-- GROUP BY

-- get total counts of all movies group by movie language

SELECT
	movie_lang,
	COUNT(movie_lang)
FROM movies
GROUP BY movie_lang;

-- get average movie length by movie language

SELECT
	movie_lang,
	AVG(movie_length)
FROM movies
GROUP BY movie_lang;

-- get the sum total movie length per age certificate

SELECT 
	age_certificate,
	SUM(movie_length)
FROM movies
GROUP BY age_certificate;

-- list minimum and maximum movie length group by movie language

SELECT 
	MIN(movie_length),
	MAX(movie_length),
	movie_lang
FROM movies
GROUP BY movie_lang;

-- can use group by without agg. fn ? --> YES

SELECT 
	movie_length
FROM movies
GROUP BY 
	movie_length;

-- can we use column1, aggregate function column without specifying GROUP BY ? --> NO

SELECT 
	MIN(movie_length),
	MAX(movie_length),
	movie_lang 
FROM movies; -- ERROR

-- get average movie length group by movie language and age certificate 

SELECT
	movie_lang,
	age_certificate,
	AVG(movie_length)
FROM movies
GROUP BY movie_lang, age_certificate;

-- get average movie length group by movie lang and age certificate 
-- where movie length greater than 100

SELECT 
	movie_lang,
	age_certificate,
	AVG(movie_length)
FROM movies
WHERE movie_length > 100
GROUP BY movie_lang, age_certificate
ORDER BY 3;

-- get average movie length group by age certi. where age certi = 18

SELECT
	age_certificate,
	AVG(movie_length)
FROM movies
WHERE age_certificate = '18'
GROUP BY age_certificate;

-- how many directors are there per each nationality

SELECT
	nationality,
	COUNT(*)
FROM directors
GROUP BY nationality
ORDER BY 2 DESC;

-- get total sum movie length for each age certi. and movie lang. combination

SELECT
	age_certificate,
	movie_lang,
	SUM(movie_length)
FROM movies
GROUP BY age_certificate, movie_lang
ORDER BY 3 DESC;

-- Order of Execution --
-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT
-- DISTINCT
-- ORDER BY
-- LIMIT


--
-- HAVING Clause
--

-- list movie lang. where sum total length of the movie is greater than 200

SELECT
	movie_lang,
	SUM(movie_length)
FROM movies
GROUP BY movie_lang
HAVING SUM(movie_length) > 200
ORDER BY 2;

-- list directors where their total movie length is greater than 200

SELECT
	director_id,
	SUM(movie_length)
FROM movies
GROUP BY director_id
HAVING SUM(movie_length) > 200
ORDER BY 1;

-- HAVING Vs WHERE 
-- HAVING works on result group
-- WHERE works on SELECT columns and not on result group

-- get the movie lang. where their sum total is greater than 200

SELECT 
	movie_lang,
	SUM(movie_length)
FROM movies
GROUP BY movie_lang
HAVING SUM(movie_length) > 200
ORDER BY 2 DESC;

-- Handling NULL values with GROUP BY

CREATE TABLE emp_test(
	emp_id SERIAL PRIMARY KEY,
	emp_name VARCHAR(100),
	department VARCHAR(100),
	salary INT
);

INSERT INTO emp_test (emp_name, department, salary) VALUES
('John', 'Finance', 2500),
('Mary', NULL, 3000),
('Adam', NULL, 4000),
('Bruce', 'Finance', 4000),
('Linda', 'IT', 5000),
('Megan', 'IT', 4000);

SELECT * FROM emp_test;

-- let's display all department

SELECT department 
FROM emp_test;

-- how many employees are there for each group

SELECT
	department,
	COUNT(*)
FROM emp_test
GROUP BY department;
