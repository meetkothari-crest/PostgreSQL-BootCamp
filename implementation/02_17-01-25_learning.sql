/*
Boolean datatypes : TRUE, FALSE, NULL
	- TRUE values: TRUE, 'true', 't', 'yes', 'y', '1'
	- False values: False, 'false', 'f', 'no', 'n', '0'
*/


CREATE TABLE table_bool(
	product_id SERIAL PRIMARY KEY,
	is_available BOOLEAN NOT NULL
);

INSERT INTO table_bool (is_available) 
VALUES 
('true'),
('false'),
('t'),
('f'),
('1'),
('0'),
('yes'),
('no'),
('y'),
('n')
;


SELECT * 
FROM table_bool
WHERE is_available = '1'
;


SELECT * 
FROM table_bool
WHERE is_available
;


SELECT * 
FROM table_bool
WHERE NOT is_available
;

ALTER TABLE table_bool
ALTER COLUMN is_available 
SET DEFAULT '0'
;


INSERT INTO table_bool (product_id)
VALUES (13);


SELECT * 
FROM table_bool;

/* 
Characters datatypes
	- CHARACTER(n), CHAR(n) : fixed length, blank padded
	- CHARACTER VARYING(n), VARCHAR(n) : variable-length with length limit
	- TEXT, VARCHAR : variable unlimited length
*/

SELECT CAST('abc' AS character(10)) as "Name";
-- "abc       "

SELECT 'abcd'::char(10) as "Name";
-- "abcd      "

SELECT 'abcd'::char as "Name";
-- "a"

SELECT 'abcd'::varchar(10);
-- "abcd"

SELECT 'abcdefghijklm'::varchar(10);
-- "abcdefghij"


CREATE TABLE table_char (
	col_char CHAR(10),
	col_varchar VARCHAR(10),
	col_text TEXT
);


INSERT INTO table_char (col_char, col_varchar, col_text)
VALUES 
('ABC', 'ABC', 'ABC'),
('abc', 'abc', 'abc');


SELECT * 
FROM table_char;


