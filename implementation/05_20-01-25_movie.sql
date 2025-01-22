-- Type conversion 	
	-- Implicit - data conversion is done AUTOMATICALLY
	-- Explicit - data conversion is done via conversion functions e.g. CAST, ::

SELECT * FROM movies;

SELECT * 
FROM movies
WHERE movie_id = 1; -- same datatype, NO conversion

-- integer = string

SELECT *
FROM movies
WHERE movie_id = '1'; -- Automatically conversion 

SELECT * 
FROM movies
WHERE movie_id = integer '1';

-- Using CAST for data conversion

-- 1. String to Int
SELECT CAST('10' AS INTEGER);

SELECT CAST('10n' AS INTEGER); -- Error

-- 2. String to date 

SELECT 
	CAST('2025-01-01' AS DATE),
	CAST('01-FEB-2025' AS DATE);

-- 3. String to Boolean
 
SELECT
	CAST('true' AS BOOLEAN),
	CAST('false' AS BOOLEAN),
	CAST('t' AS BOOLEAN),
	CAST('F' AS BOOLEAN);

-- 4. Integer to Boolean

SELECT 
	CAST(0 AS BOOLEAN),
	CAST(1 AS BOOLEAN),
	CAST(-1 AS BOOLEAN),
	CAST(10 AS BOOLEAN);

 --5. String to DOUBLE PRECISION

SELECT
	CAST('14.12345' AS DOUBLE PRECISION);


-- Using ::

SELECT 
	'10'::INTEGER,
	'01-01-2025'::DATE,
	'01-JAN-2025'::DATE,
	'2025-01-01'::DATE,
	1::BOOLEAN,
	'T'::BOOLEAN;

-- String to TIMESTAMP

SELECT '2025-01-01 2:50:30.345'::TIMESTAMP;

SELECT '2025-01-01 2:50:30'::TIMESTAMPTZ;

-- String to INTERVAL

SELECT 
	'10 second'::INTERVAL,
	'10 minute'::INTERVAL,
	'10 hour'::INTERVAL,
	'10 day'::INTERVAL,
	'10 week'::INTERVAL,
	'10 month'::INTERVAL,
	'10 year'::INTERVAL;

-- Implicit to Explicit Conversions

SELECT factorial(5) AS result;

SELECT factorial(CAST(20 AS BIGINT)) AS "result";

SELECT ROUND(10,3) AS "result";

SELECT ROUND (CAST(10 AS NUMERIC), 4) AS "result";

-- CAST with text

SELECT 
	SUBSTR('123456', 2) AS "result";

SELECT 
	SUBSTR('123456',2) AS "Implicit",
	SUBSTR(CAST('123456' AS TEXT), 2) AS "Explicit";

-- 

CREATE TABLE ratings(
	rating_id SERIAL PRIMARY KEY,
	rating VARCHAR(1) NOT NULL
);

INSERT INTO ratings (rating) VALUES 
('A'),
('B'),
('C'),
('D');

INSERT INTO ratings (rating) VALUES 
(1),
(2),
(3),
(4);

SELECT * FROM ratings;

SELECT 
	rating_id,
	CASE 
		WHEN rating~E'^\\d+$' THEN
			CAST (rating AS INTEGER)
		ELSE 
			0
		END AS rating
FROM ratings;

-- to_char()
	--  TO_CHAR(expression, format)


SELECT 
	TO_CHAR(
		100870,
		'9,99,999'
	);

SELECT
	release_date,
	TO_CHAR(release_date, 'DD-MM-YYYY'),
	TO_CHAR(release_date, 'Dy,MM,YYYY')
FROM movies;


SELECT 
	TO_CHAR(
		TIMESTAMP '2025-01-01 16:15:30',
		'HH24:MI:SS'
	);


SELECT
	movie_id,
	revenues_domestic,
	TO_CHAR(revenues_domestic, '$99999D99')
FROM movies_revenues;

-- TO_NUMBER(string, format) : String to Number

SELECT 
	TO_NUMBER(
	'1420.89',
	'9999.99'
	);

SELECT 
	TO_NUMBER(
		'10,625.78-',
		'99G999D99S'
	);

SELECT 
	TO_NUMBER(
		'$1,420.64',
		'L9G999D99'
	);

SELECT 
	TO_NUMBER(
		'1,234,567.89',
		'9G999g999D99'
	);

SELECT 
	TO_NUMBER(
		'$1,978,299.78',
		'L9G999G999.99'
	);

-- TO_DATE(text, format) : String to DATE

SELECT 
	TO_DATE(
		'2025/01/10',
		'YYYY/MM/DD'
	);

SELECT 
	TO_DATE(
		'022125',
		'MMDDYY'
	);

SELECT 
	TO_DATE(
		'January 16, 2025',
		'Month DD, YYYY'
	);

SELECT 
	TO_DATE(
		'2025/01/16',
		'YYYY/MM/DD'
	);

-- TO_TIMESTAMP(timestamp, fomrat) : String to TIMESTAMP

SELECT 
	TO_TIMESTAMP(
		'2025-01-15 10:20:30',
		'YYYY-MM-DD HH:MI:SS'
	);

-- Skip Spaces

SELECT 
	TO_TIMESTAMP('2025     Jan', 'YYYY MON');

SELECT 
	TO_TIMESTAMP(
	'2025-01-01 23:00:00',
	'YYYY-MM-DD HH24:MI:SS'
	);


	