--
-- UPPER, LOWER and INITCAP functions
--

SELECT UPPER('PostgreSQL');

SELECT LOWER('PostgreSQL');

SELECT INITCAP('hello, you are in movies database');


SELECT
	UPPER(first_name) AS first_name,
	UPPER(last_name) AS last_name
FROM directors;

SELECT 
	INITCAP(
		CONCAT(first_name, ' ', last_name)
	) AS full_name
FROM directors
ORDER BY first_name;

--
-- LEFT and RIGHT 
--

-- LEFT(string,n) - Returns first n characters in the string

SELECT LEFT('ABCDFGH',2); -- Returns first 2 char

SELECT LEFT('ABCDFGH',-2); -- Returns all except last 2 char

-- Get initial for all directors name

SELECT 
	LEFT(first_name, 1) AS initial,
	COUNT(*) AS total_initials
FROM directors
GROUP BY 1
ORDER BY 1;

-- get the first 6 chars from all the movies

SELECT
	LEFT(movie_name, 6) AS first_6
FROM movies;

-- RIGHT(string, n)

SELECT RIGHT('ABCDEFGH', 2);

SELECT RIGHT('ABCDEFGH', -2);

-- get all directos where they last name ends with 'on'

SELECT last_name, RIGHT(last_name, 2)
FROM directors
WHERE RIGHT(last_name, 2) = 'on';

--
-- REVERSE()
--

SELECT REVERSE('ABCD');

SELECT REVERSE('A1B2C3D4');


--
-- SPLIT_PART(string, delimiter, position) function
-- 

SELECT SPLIT_PART('1 23', ' ', 1);

SELECT SPLIT_PART('1,2,3', ',', 3);

-- Get the release year of all the movies

SELECT 
	movie_name,
	release_date,
	SPLIT_PART(release_date::TEXT, '-', 1) AS release_year
FROM movies;

/*
TRIM - removes the longest string that contains a specific char from a string 
LTRIM - removes all chars, spaces by default, from the beginning of a string
RTRIM - removes all chars, spaces by default, from the end of a string
BTRIM - combination of LTRIM() and RTRIM()
*/

-- TRIM([LEADING| TRAILING| BOTH] [characters] FROM string);

-- TRIM (LEADING FROM string);
-- TRIM (TRAILING FROM string);
-- TRIM (BOTH FROM string);

-- LTRIM(string, [character]);
-- RTRIM(string, [character]);
-- BTRIM(string, [character]);

SELECT 
	TRIM (
		LEADING
		FROM '     abcd efgh'
	),
	TRIM (
		TRAILING
		FROM 'abcd efgh     '
	),
	TRIM ('     abcd efgh     ');

-- removing leading zero (0) from a number

SELECT 
	TRIM(
		LEADING '0'
		FROM 00012345::TEXT
	);

SELECT 
	LTRIM('yummy', 'y');

	
SELECT 
	RTRIM('yummy', 'y');

	
SELECT 
	BTRIM('yummy', 'y');

/*
LPAD - LPAD(string, length [, fill])
RPAD - RPAD(string, length [, fill])
*/

SELECT LPAD('abcd', 10, '*');

SELECT LPAD('abcd', 10);

SELECT RPAD('abcd', 10, '*');

SELECT RPAD('abcd', 10);

--
-- LENGTH
--

SELECT LENGTH('PostgreSQL');

SELECT char_length('PostgreSQL');

SELECT char_length(' ');

SELECT char_length('');

SELECT char_length(NULL);

-- Get the total length of all directors

SELECT 
	first_name || ' ' || last_name AS full_name,
	LENGTH(first_name || ' ' || last_name) AS full_name_length
FROM directors
ORDER BY
	full_name_length DESC;


-- POSITION(substring IN string)

SELECT POSITION('Amazing' IN 'Amazing PostgreSQL');


-- STRPOS(string, substring)
SELECT STRPOS('Amazing PostgreSQL', 'Amazing');

SELECT 
	first_name,
	last_name
FROM directors
WHERE STRPOS(last_name, 'on') > 0;

-- SUBSTRING - SUBSTRING(string [from start_position] [for length])
-- SUNSTRING (string, start_position, length)

SELECT SUBSTRING('What a wonderful world' FROM 1 FOR 4);

SELECT SUBSTRING('What a wonderful world' FOR 4);

SELECT substring('What a wonderful world' from 8 for 9);

SELECT substring('What a wonderful world', 8, 9);


-- REPEAT()

SELECT REPEAT('A', 10);

SELECT REPEAT(' ', 5); -- "     "

-- REPLACE()

SELECT REPLACE('What a wonderful world', 'a wonderful', 'an amazing');

SELECT REPLACE('ABACADAE', 'A', ' ');

SELECT REPLACE('11122333', '2', '4');

