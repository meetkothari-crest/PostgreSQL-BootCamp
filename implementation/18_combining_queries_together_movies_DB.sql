-- combining queries together with UNION

SELECT 
	p_id, p_name
FROM table_left
UNION
SELECT
	p_id, p_name
FROM table_right;

INSERT INTO table_right (p_id, p_name) VALUES (10, 'Pen');
INSERT INTO table_left (p_id, p_name) VALUES (10, 'Pen');

SELECT 
	p_id, p_name
FROM table_left
UNION
SELECT
	p_id, p_name
FROM table_right;


SELECT 
	p_id, p_name
FROM table_left
UNION ALL
SELECT
	p_id, p_name
FROM table_right;

-- lets combine directors and actors table

SELECT
	first_name,
	last_name
FROM directors
UNION
SELECT
	first_name,
	last_name
FROM actors
ORDER BY first_name ASC;

-- Lets combine all directors where nationality are American, Chinese, 
-- Japanese with all female actors.

SELECT 
	first_name,
	last_name,
	'directors' as tablename
FROM directors
WHERE 
	nationality IN ('American', 'Chinese', 'Japanese')
UNION
SELECT
	first_name,
	last_name,
	'actors' as tablename
FROM actors
WHERE 
	gender = 'F';

-- select the first name and last name of all directors and actors which are born after 1990

SELECT 
	first_name,
	last_name
FROM directors
WHERE date_of_birth > '1970-12-31'
UNION
SELECT
	first_name,
	last_name
FROM actors
WHERE date_of_birth > '1970-12-31';

-- select the first name and last name of all directors and actors
-- where their first names starts with 'A'

SELECT
	first_name,
	last_name,
	'd' as tablename
FROM directors
WHERE 
	first_name LIKE 'A%'
UNION
SELECT
	last_name,
	first_name,
	'a' AS tablename
FROM actors
WHERE
	first_name LIKE 'A%';

-- combine tables with different number of columns

CREATE TABLE tab1(
	col1 INT,
	col2 INT
);

CREATE TABLE tab2(
	col3 INT
);

SELECT
	col1, col2
FROM tab1
UNION
SELECT
	NULL as col1, col3
FROM tab2


SELECT
	col1, col2, NULL as col3
FROM tab1
UNION
SELECT
	NULL as col1, NULL as col2, col3
FROM tab2

DROP TABLE tab1;
DROP TABLE tab2;

-- combining queries together with INTERSECT
-- returns any rows that are available in BOTH result sets

SELECT 
	p_id,
	p_name
FROM table_left
INTERSECT
SELECT
	p_id,
	p_name
FROM table_right;

-- lets intersect first name, last name of directors and actors tables

SELECT
	first_name,
	last_name
FROM directors
INTERSECT
SELECT
	first_name,
	last_name
FROM actors;


-- combining queries together with EXCEPT
-- return the rows in the first query that do not appear in the output of the second query

SELECT
	p_id,
	p_name
FROM table_left
EXCEPT
SELECT
	p_id,
	p_name
FROM table_right;

-- lets EXCEPT first name, last name of directors and actors tables

SELECT
	first_name,
	last_name
FROM directors
EXCEPT
SELECT
	first_name,
	last_name
FROM actors;

-- list all the directors first name, last name unless they have the same first name in
-- female actors

SELECT
	first_name,
	last_name
FROM directors
EXCEPT 
SELECT
	first_name,
	last_name
FROM actors
WHERE 
	gender = 'F';
	

