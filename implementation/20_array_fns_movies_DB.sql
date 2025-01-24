-- Using array functions

-- constructing arrays and ranges

-- constructing ranges

/*

range_type (lower bound, upper bound)
	range_type: INT4RANGE, INT8RANGE, NUMRANGE, TSRANGE, TSTZRANGE, DATERANGE

	range_type (lower bound, upper bound, open_close)
		open_close: '[]'
				    '[)'
				    '(]'
				    '()'
		[ indicates the range is close
		() indicates the range is open
*/

SELECT 
	INT4RANGE(1,6), 					-- default [) - closed - opened
	NUMRANGE(1.4213, 6.2986, '[]'), 	-- colsed - closed
	DATERANGE('20200101', '20201220', '()'), -- opened - opened
	TSRANGE(LOCALTIMESTAMP, LOCALTIMESTAMP + INTERVAL '8 days', '(]'); -- opened - closed

-- constructing arrays

-- Array [val1, val2...]

SELECT
	ARRAY[1,2,3] AS "INT",
	ARRAY[2.1225::float] AS "floating numbers",
	ARRAY[CURRENT_DATE, CURRENT_DATE + 5];

-- Using operators

-- comparison operator

SELECT 
	ARRAY[1,2,3,4] = ARRAY[1,2,3,4] AS "=",
	ARRAY[1,2,3,4] = ARRAY[2,3,4] AS "=",
	ARRAY[1,2,3,4] <> ARRAY[2,3,4,5] AS "<>",
	ARRAY[1,2,3,4] < ARRAY[2,3,4,5] AS "<",
	ARRAY[1,2,3,4] > ARRAY[2,3,4,5] AS ">",
	ARRAY[1,2,3,4] <= ARRAY[2,3,4,5] AS "<=",
	ARRAY[1,2,3,4] >= ARRAY[2,3,4,5] AS ">=";

SELECT 
	INT4RANGE(1,4) @> INT4RANGE(2,3) AS "Contains",
	DATERANGE(CURRENT_DATE, CURRENT_DATE + 30) @> CURRENT_DATE + 15 AS "Contains",
	NUMRANGE(1.6, 5.2) && NUMRANGE(0, 4);

-- Inclusion operators : @>, <@, &&

SELECT 
	ARRAY[1,2,3,4] @> ARRAY[2,3,4] AS "contains",
	ARRAY['a', 'b'] <@ ARRAY['a', 'b'] AS "contained by",
	ARRAY[1,2,3,4] && ARRAY[2,3,4] AS "Is overlap";


-- Array construction

-- with || concatenation
SELECT
	ARRAY[1,2,3] || ARRAY[4,5,6] AS "Arr";

SELECT
	ARRAY_CAT(ARRAY[1,2,3], ARRAY[4,5,6]) AS "combine arrays via ARRAY_CAT";

-- Add an item to an array
SELECT 
	4 || ARRAY[1,2,3] AS "Adding to an array";

SELECT 
	ARRAY_PREPEND(4,ARRAY[1,2,3]) AS "Adding to an array";

SELECT
	ARRAY[1,2,3] || 4 AS "Adding";	

SELECT 
	ARRAY_APPEND(ARRAY[1,2,3], 4);

-- Array metadata functions

-- ARRAY_NDIM(array) : return type INT

SELECT 
	ARRAY_NDIMS(ARRAY[[1],[2]]);

SELECT 
	ARRAY_NDIMS(ARRAY[[1,2,3],[4,5,6]]);

-- ARRAY_DIM(array) : return type TEXT

SELECT 
	ARRAY_DIMS(ARRAY[[1,2,3],[4,5,6]]);

-- ARRAY_LENGTH(array, int)

SELECT 
	ARRAY_LENGTH(ARRAY[1,2,3,4], 1);

-- ARRAY_LOWER(array, int)

SELECT 
	ARRAY_LOWER(ARRAY[5,4,3,2], 1);

SELECT 
	ARRAY_LOWER(ARRAY[0, 1, 4], 1);

-- ARRAY_UPPER(array, int)

SELECT
	ARRAY_UPPER(ARRAY[3,2,4,1], 1);

-- Cardinality(array) : returns cardinality of an arr or total element

SELECT
	CARDINALITY(ARRAY[[1], [2], [3], [4]]),
	CARDINALITY(ARRAY[[1], [2], [3], [4], [5]]);

-- Array search functions

-- ARRAY_POSITION(array, anyelement)
-- ARRAY_POSITION(array, anyelement, start_location)

SELECT
	ARRAY_POSITION(ARRAY['Jan', 'Feb', 'March', 'April'], 'Feb');

SELECT
	ARRAY_POSITION(ARRAY[1, 2, 3, 4, 3, 4], 3);
	
SELECT
	ARRAY_POSITION(ARRAY[1, 2, 3, 4, 3, 4], 3, 4);

-- ARRAY_POSITIONS(array, element)

SELECT
	ARRAY_POSITIONS(ARRAY[1,2,3,4,2,5], 2);

-- Array modifications functions

-- ARRAY_CAT(anyarray, anyarray) : Used to concatenate two arrays

SELECT
	ARRAY_CAT(ARRAY['Jan', 'Feb'], ARRAY['1', '2']);

-- ARRAY_REMOVE(anyarray, anyelement)

SELECT
	ARRAY_REMOVE(ARRAY[1,2,3,4 ,4,4], 4);

-- ARRAY_REPLACE(anyarray, from_element, to_element)

SELECT
	ARRAY_REPLACE(ARRAY[1, 2, 3, 2, 4], 2, 10);

-- Array comparison with IN, ALL, ANY and SOME

-- IN operator

SELECT 
	20 IN (10, 20, 30);

SELECT 
	1 IN (10, 20, 30);

-- NOT IN operator

SELECT 
	20 NOT IN (10, 20, 30);

SELECT 
	20 NOT IN (10, 20, 30);

-- ALL operator

SELECT
	20 = ALL(ARRAY[10,20,30]);

SELECT
	20 = ALL(ARRAY[20,20,20]);

-- ANY operator

SELECT
	20 = ANY(ARRAY[10,20,30]);

SELECT
	25 = ANY(ARRAY[10, 20, 25, NULL]);

SELECT
	25 <> ANY(ARRAY[10, 20, 25, NULL]);

-- SOME operator

SELECT
	25 = SOME(ARRAY[10, 20, 30]);

-- Formatting and Converting arrays

-- STRING TO ARRAY

SELECT
	STRING_TO_ARRAY('1,2,3,4', ',');

-- setting a value to NULL (non-empty value)
SELECT
	STRING_TO_ARRAY('1,2,3,4,ABC', ',', 'ABC');

-- Setting an empty value to NULL
SELECT 
	STRING_TO_ARRAY('1,2,3,4,,5', ',', '');

-- ARRAY_TO_STRING

SELECT
	ARRAY_TO_STRING(ARRAY[1,2,3,4], '-');

SELECT
	ARRAY_TO_STRING(ARRAY[1,2,NULL,4], '-');

SELECT
	ARRAY_TO_STRING(ARRAY[1,2,NULL,4, NULL], '-', '=');

-- Using Arrays in Tables
/*

-- PostgreSQL alows you to define a column to be an array of any valid data type including
	- built-in type,
	- user-defined type or
	- enumerated type

-- Every data type has its own companion array type e.g.,
	- integer has an integer[] array type, 
	- character has character[] array type etc.

	- Basically we add brackets [] to the base data type to make it an array
	e.g. name VARCHAR(100) []
	
*/

-- create a table with array data

CREATE TABLE teachers (
	t_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT []
);

-- can also use ARRAY as keywords to create a array data type

CREATE TABLE teachers1 (
	t_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT ARRAY
);

-- please note, the phones column is a ONE-DIMENSIONAL array.

-- Insert data into arrays :
/*

1. We use ' ' to wrap the array or use ARRAY function
2. For non-text data, we can use {}

	'{val1, val2}'
	ARRAY[val1, val2]

3. For text-data, we use " "

	'{"val1", "val2"}'
	ARRAY['val1', 'val2'] -- ' ' when using ARRAY fn

*/

INSERT INTO teachers (name, phones) VALUES
('ABC', ARRAY['1112223333', '5556667777']),
('XYZ', '{"1234567890", "9876543210"}')
;

-- Query Array data

SELECT 
	name,
	phones
FROM
	teachers;

-- How to access array element
	-- we access array elements using subscript within square bracket []
	-- the first array ele. starts with number 1

SELECT
	name, 
	phones [2]
FROM
	teachers;

-- can we use filter cond.?

SELECT 
	name,
	phones
FROM 
	teachers
WHERE 
	phones [2] = '5556667777';


SELECT 
	name
FROM 
	teachers
WHERE 
	'5556667777' = ANY(phones);

-- modify array contents

SELECT *
FROM teachers;

UPDATE teachers
SET phones [1] = '1111111111'
WHERE t_id = 2;

-- Dimensions are ignored by postgreSQL

CREATE TABLE teachers2 (
	t_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT ARRAY[1]
);

-- can we add two phones records eventhough we define ARRAY[1] ?

INSERT INTO teachers2 (name, phones) VALUES
('AA', ARRAY['1212121212', '2323232323'])
;

SELECT * FROM teachers2;

-- Display all array elements
-- unnest (anyarray) : function is used to an array to a set of rows

SELECT
	t_id,
	name,
	unnest(phones)
FROM
	teachers
ORDER BY 3;

-- Using Multi-Dimensional array

CREATE TABLE students(
	s_id SERIAL PRIMARY KEY,
	s_name VARCHAR(100),
	s_grade INTEGER[][]
);

INSERT INTO students (s_name, s_grade) VALUES
('S1', '{90, 2020}')
;

INSERT INTO students (s_name, s_grade) VALUES
('S2', '{80, 2020}'),
('S3', '{70, 2019}'),
('S4', '{60, 2019}')
;

SELECT * FROM students;

-- How to get specific array dimension data

SELECT 
	s_grade[1]
FROM students;

SELECT 
	s_grade[2]
FROM students;

-- Searching in multi-dimension array

-- Search all students with grade year 2020

SELECT *
FROM students
WHERE s_grade[2] = 2020;

SELECT *
FROM students
WHERE s_grade @> '{2020}';

SELECT *
FROM students
WHERE 2020 = ANY(s_grade);

-- Search all students with grade > 70

SELECT *
FROM students
WHERE s_grade[1] > 70;

-- ARRAY Vs JSON

/*
	ARRAY

	Advantages : 
	1. It's Preety easy to set up
	2. Requires less storage in comparison to jsonb
	3. It has multi dimension support 
	4. indexing with GIN, which greatly speeds up query performance
	5. the postgreSQL planner is likely to make better decisions with the postgreSQL
	   array, as it collects statistics on its contents, but doesn't on JSONB

	Disadvantages :
	1. Its main disadvantage is that it supports only single datatype
	2. Have to follow strict order of the array data input

	JSONB

	Advantages : 
	1. very similar to use json data type
	2. It provides additional opeator for querying 
	3. Support for indexing for query performance
	4. Syntactically, the JSONB array may be easier to use as you don't have to wrap 
		your query value in a dummy arrays constructor:

		where jsonb_column ? 'abc';
		vs 
		where textarraycolumn @> ARRAY['abc']

	Disadvantages :
	1. It is worth nothing that since jsonb has to parse the JSON data into binary format.
	2. It tends to be slower than the json data type when writing but faster when reading 
		the data.
	3. Note that JSONB doesn't necessarily keep the order in the objects the same so it
		might not work all the time because the order of items might change on the output.
	
*/


