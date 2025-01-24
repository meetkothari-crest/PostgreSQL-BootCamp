-- JSON
	-- stands for Javascript Object Notation which is type of format used for web app.
	-- introduced as an alternative to XML format.
	-- it light-weight format
	-- is human readable.
	-- due to Douglas Crockford, JSON became popular.
	-- JSON is often used to serialize and transfer data over net. connec. between server and web application.
	-- Where, serialization means process of transforming data struct. and objects in format suitable to be stored in a file or memory buffer.	
	-- Today, JSON is one of the most widely used data-interchange format in web and supported by most of the web APIs.


-- JSON Syntax:

	-- Data is in key-value pairs which consists of a field name (in double quotes) followed by :, followed by value.
	-- Data is separated by a comma
	-- Curly braces {} hold JSON objects.
	-- Each object can have multiple name-value pairs.
	-- Square brackets [] contains arrays of JSON objects.
	
	/*
		{
			"Title": "The Lord of the Rings",
			"Author": "J.R.R",
			"Details":{
				"Publisher": "ABC Pub."
			},
			"Price":[
				{
					"type": "Paperback",
					"price": 25.59
				},
				{
					"type": "Kindle Edition",
					"price": 9.59
				}
			]
		}
	*/

-- JSON & JSONB

	-- App.n can send JOSN strings in postgresql DB as JSON Dtype and retrieve back in JSON format.
	-- pg supports native JSON dtype since version 9.2.
	-- Two ways to store JSON data in pgsql - JSON & JSONB
	/*
		JSON
		- stores only Valid JSON pretty much like TEXT dtype.
		- stores JSON as it is with white-spaces.
		- does not support full text search indexing.
		- wide range of JSON func. and op.
		- JSON is faster as it does not process data

		JSONB
		- stores JSON doc. in Binary format.
		- trims white spaces and stores in a format conducive for faster searches.
		- supports full text search indexing
		- support all JSON func. and op.
		-- It pre-process and parse input data and is faster on op. and func.
	*/	


-- Exploring JSON Objects

-- representing JSON object, explicit casting is required
SELECT '{
"title": "Lord of the rings"
}'::JSON -- captures and preserves all of the white space around it.


SELECT '{
"title": "Lord of the rings"
}'::JSONB -- trims white spaces


CREATE TABLE books(
	book_id SERIAL PRIMARY KEY,
	book_info JSONB
);

INSERT INTO books
(book_info)
VALUES
('
{
	"title": "Book title 1",
	"author": "author1"
}
'),
('
{
	"title": "Book title 2",
	"author": "author2"
}
'),
('
{
	"title": "Book title 3",
	"author": "author3"
}
'),
('
{
	"title": "Book title 4",
	"author": "author4"
}
')

SELECT * FROM books

-- Using Selectors
	-- '->' operator returns JSON object field as field in double quotes with dtype JSONB
	-- '->>' returns JSON object field as Text.

SELECT 
	book_info, 
	book_info->'title', 
	book_info->>'title'
FROM 
	books

-- selecting and filtering data

SELECT 
	book_info, 
	book_info->>'title' AS title, 
	book_info->>'author' AS author
FROM 
	books
WHERE
	book_info->>'author' = 'author1'

-- Updating JSON data

INSERT INTO books
(book_info)
VALUES
('
{
	"title": "Book title 10",
	"author": "author10"
}
')


-- we will use || ope. which will allow us to add field or replace missing field.
-- updating author10 with Jod.

UPDATE books
SET
	book_info = book_info || '{"title": "The Future", "author": "Jod"}'
WHERE
	-- book_info->>'author' = 'author10'
	book_info->>'author' = 'Jod'


	-- adding extra field
UPDATE books
SET
	book_info = book_info || '{"Best Seller": true}'
WHERE
	book_info->>'author' = 'Jod'
RETURNING *


	-- adding multiple pairs.
UPDATE books
SET
	book_info = book_info || '{"Best Seller": true, "Pages": 250}'
WHERE
	book_info->>'author' = 'Jod'
RETURNING *


	-- deleting field with '-' operator
UPDATE books
SET
	book_info = book_info - 'Best'
WHERE
	book_info->>'author' = 'Jod'
RETURNING *


	-- adding a nested array data in JSON
UPDATE books
SET
	book_info = book_info || '{"availability_locations":[
				"New York", 
				"New Jersey"
		]	
}'
WHERE
	book_info->>'author' = 'Jod'
RETURNING *

	-- delete from arrays via path '#-'
UPDATE books
SET
	book_info = book_info #- '{availability_locations,1}'
WHERE
	book_info->>'author' = 'Jod'
RETURNING *


-- Creating JSON with Tables

	-- output directors into JSON
SELECT
	row_to_json(directors)
FROM
	directors

	-- just taking necessary columns
SELECT
	row_to_json(t)
FROM
	(
	SELECT 
		director_id, 
		first_name, 
		last_name, 
		nationality
	FROM	
		directors
	) AS t


-- Aggregating data using JSON_AGG()

-- list movies for each director
SELECT
*,
(
	SELECT 
		JSON_AGG(x) AS "All Movies"
	FROM
		(
		SELECT
			movie_name
		FROM
			movies
		WHERE
			director_id = directors.director_id
		) AS x
)
FROM 
	directors


-- Select only director_id, name and all movies instead of all data

SELECT
	director_id,
	first_name || ' ' || last_name,
	(
	SELECT 
		JSON_AGG(x)::JSONB
	FROM
		(
			SELECT
				movie_name
			FROM
				movies
			WHERE
				director_id = directors.director_id
		) AS x
	)
FROM
	directors


-- Build a JSON array.
SELECT
	json_build_array(1,2,3,4,5),
-- we can also have numbers and strings together.
	json_build_array(1,2,3,4,5,6, 'Hi')


-- using JSON_BUILD_OBJECT for key-value pairs.	
	-- should have even number of ele., where first val will be key and second will be value.
SELECT
	JSON_BUILD_OBJECT(1,2,3,4,5,6),
	JSON_BUILD_OBJECT('name', 'jod', 'email', 'abc@gmail.com')


-- using JSON_OBJECT({keys}, {values})
SELECT 
	JSON_OBJECT('{name, email}', '{"Jod", "abc@gmail.com"}')


-- creating document from data
CREATE TABLE director_docs(
	id SERIAL PRIMARY KEY,
	body JSONB
)

-- get all movies by each director in JSON array format.

INSERT INTO director_docs
(body)
SELECT row_to_json(a)::JSONB
FROM
(SELECT
	director_id,
	first_name,
	last_name,
	date_of_birth,
	nationality,
	(
	SELECT 
		JSON_AGG(x) AS all_movies
	FROM
		(
			SELECT
				movie_name
			FROM
				movies
			WHERE
				director_id = directors.director_id
		) AS x
	)
FROM 
	directors) AS a 

SELECT 
	*
FROM
	director_docs


-- Dealing with NULL values in JSON Docu.

SELECT 
	jsonb_array_elements(body->'all_movies')
FROM
	director_docs
WHERE
	(body->'all_movies') IS NOT NULL -- would give error

-- so we rewrite whole query to have better data where we have [] instead of NULL
-- DELETE FROM director_docs
INSERT INTO director_docs
(body)
SELECT row_to_json(a)::JSONB
FROM
(SELECT
	director_id,
	first_name,
	last_name,
	date_of_birth,
	nationality,
	(
	SELECT 
		CASE COUNT(x) WHEN 0 THEN '[]' 
			ELSE
			JSON_AGG(x)
		END
		AS all_movies
	FROM
		(
			SELECT
				movie_name
			FROM
				movies
			WHERE
				director_id = directors.director_id
		) AS x
	)
FROM 
	directors) AS a 


SELECT 
	jsonb_array_elements(body->'all_movies')
FROM
	director_docs -- gives evey movie element as a new row


-- SQL NULL vs JSON NULL
	-- In SQL, NULL represents absence of definite value
	-- But
	-- In JSON, NULL is represented by "null"


-- Getting Info. from JSON docu.


-- count total movies for each direc. - jsonb_array_length
SELECT
	*,
	jsonb_array_length(body->'all_movies') as "Movie Count"
FROM
	director_docs

-- list all keys within each JSON row - json_object_keys
SELECT
	*,
	jsonb_object_keys(body) -- showing each key for each JSON row
FROM
	director_docs
	
-- selecting key-value
SELECT
	j.key,
	j.value
FROM
	director_docs, jsonb_each(director_docs.body) j

-- Turning JSON document to Table Format - jsonb_to_record (columns)

SELECT
	j.*
FROM 
	director_docs, jsonb_to_record(director_docs.body) j (
	director_id INT,
	first_name VARCHAR(255),
	nationality VARCHAR(255)
	) 

-- Existence Operator ? eg. body->'key' ? 'val'
	-- NOTE: ? expects TEXT value on both the side
SELECT
	*
FROM
	director_docs
WHERE
	body->'first_name' ? 'John'
	
--with director_id = 1
SELECT
	*
FROM
	director_docs
WHERE
	body->'director_id' ? '1' -- would give nothing

-- Containment Operator @>

SELECT
	*
FROM
	director_docs
WHERE
	body@>'{"first_name": "John"}'

-- with director_id = 1
SELECT
	*
FROM
	director_docs
WHERE
	body@>'{"director_id": 1}' -- now gives a row

-- for movie named 'Toy story', pipeline needed
SELECT
	*
FROM
	director_docs
WHERE
	body->'all_movies'@>'[{"movie_name": "Toy Story"}]' -- as data is array of json object

-- Mix and match JSON search

-- find records with first name starting with J
SELECT
	*
FROM
	director_docs
WHERE
	body->>'first_name' LIKE 'J%'

-- find all records wher dir_id >2.
SELECT
	*
FROM
	director_docs
WHERE
	(body->>'director_id')::INT > 2

SELECT
	*
FROM
	director_docs
WHERE
	(body->>'director_id')::INT IN (1,2,3,4,5,10)

-- We can get help from existing pg functions for our JSON document.
EXPLAIN
SELECT
	*
FROM
	director_docs
WHERE
	(body->>'director_id')::INT IN (1,2,3,4,5,10)

-- Indexing on JSONB
	-- to understand indexing, first of all we need large data

-- contacts_docs table [20,000 records]:

-- getting all records where first name is John
SELECT
	*
FROM
	contacts_docs
WHERE
	-- body->'first_name' ? 'John'
	body@>'{"first_name": "John"}'

-- time elapsed:
EXPLAIN ANALYZE
SELECT
	*
FROM
	contacts_docs
WHERE -- searches whole data
	-- body->'first_name' ? 'John' 
	body@>'{"first_name": "John"}'
-- => Exec. time = 6.33 ms

-- speeding up query exec. time via GIN (Generalized Inverted Index) Index
	-- speeds up FULL Text Searches
	-- when we are searching based on specific keys or elem. then it is the way to go.
	-- stores keys (or element or valu)e and postition lists (to store multiple occuring key postions if any)

CREATE INDEX idx_gin_contacts_docs_body ON contacts_docs USING GIN(body)	

EXPLAIN ANALYZE
SELECT
	*
FROM
	contacts_docs
WHERE -- searches whole data
	-- body->'first_name' ? 'John' 
	body@>'{"first_name": "John"}'
-- => Exec. time = 0.5 ms

-- checking index size - 3664 KB
SELECT pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body'::regclass)) as "Size"

-- Challenges with GIN Index
	-- depending upon data, maintaining index can be expensive.
	-- needs to search whole docu. and consumes time and resouces
	-- size of index

-- another index
CREATE INDEX idx_gin_contacts_docs_body_cool ON contacts_docs USING GIN(body jsonb_path_ops)

-- size: 2512 KB
SELECT pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body_cool'::regclass)) as "Size"

-- creating gin index on specific key.

CREATE INDEX idx_gin_contacts_docs_body_fname ON contacts_docs USING GIN((body->'first_name') jsonb_path_ops)

-- size = 288 KB
SELECT pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body_fname'::regclass)) as "Size"

