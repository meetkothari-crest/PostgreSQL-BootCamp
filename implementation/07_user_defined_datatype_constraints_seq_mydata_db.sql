-- CREATE DOMAIN data types

-- CREATE DOMAIN statement creates a user-defined data type with a range, optional DEFAULT, 
-- 		NOT NULL and CHECK constraint
-- Can not be re-use outside of scope where they are defined
-- Can be re-use multiple columns
-- NULL is default
-- composite type : Only Single Value return

-- CREATE DOMAIN name AS data_type constraint

-- create 'addr' domain with varchar(100)
CREATE DOMAIN addr VARCHAR(100) NOT NULL;

CREATE TABLE locations(
	address addr
);

INSERT INTO locations (address) VALUES
(('123 Surat'));

SELECT * FROM locations;

-- create 'positive_num' domain with positive NUMERIC i.e. > 0

CREATE DOMAIN positive_num INT NOT NULL CHECK (VALUE > 0);

CREATE TABLE sample(
	s_id SERIAL PRIMARY KEY,
	value_num positive_num
);

INSERT INTO sample (value_num) VALUES
(10),
(20);

INSERT INTO sample (value_num) VALUES
(-10);

SELECT * FROM sample;

-- create 'us_postal_code' domain to check for valid us postal code format

CREATE DOMAIN us_postal_code AS TEXT
CHECK(
	VALUE ~ '^\d{5}$' 
	OR VALUE ~ '^\D{5}-\d{4}$'
);

CREATE TABLE addresses(
	id SERIAL PRIMARY KEY,
	postal_code us_postal_code
);

INSERT INTO addresses (postal_code) VALUES(10000);

SELECT * FROM addresses;

-- 'proper_email' domain to check for a valid email address

CREATE DOMAIN proper_email VARCHAR(100)
CHECK (VALUE ~ '^[a-zA-Z0-9.%-_]+@[a-zA-Z0-9._-]+[.][a-zA-Z]+$');

CREATE TABLE clients_info(
	c_id SERIAL PRIMARY KEY,
	email proper_email
);

INSERT INTO clients_info (email) VALUES
('abc@gmail.com');

INSERT INTO clients_info (email) VALUES
('abcgmail.com'); -- ERROR

SELECT * FROM clients_info;

-- create an Enumeration Type (Enum or Set of values) domain

CREATE DOMAIN valid_color VARCHAR(10)
CHECK (VALUE IN ('red', 'green', 'blue'));

CREATE TABLE colors(
	color valid_color
);

INSERT INTO colors (color) VALUES 
('red'),
('blue');

INSERT INTO colors (color) VALUES 
('abc'); -- ERROR

SELECT * FROM colors;

CREATE DOMAIN user_status VARCHAR(10)
CHECK (VALUE IN ('enable', 'disable'));

CREATE TABLE users_check(
	status user_status
);

-- Get all domain in a schema

SELECT typname
FROM pg_catalog.pg_type
JOIN pg_catalog.pg_namespace
ON pg_namespace.oid = pg_type.typnamespace
WHERE 
typtype = 'd' and nspname = 'public'; -- typtype = 'd' = domain

-- DROP DOMAIN data type

DROP DOMAIN positive_num; -- ERROR:  cannot drop type positive_num because other objects depend on it

-- Use DROP ... CASCADE to drop the dependent objects too.

DROP DOMAIN positive_num CASCADE; -- Delete value_num from sample table


-- Composite data types
-- 1. List of field names with corresponding data types
-- 2. Used in a table as a 'column'
-- 3. Used in function or procedures
-- 4. can return multiple values

-- CREATE TYPE name AS (fields columns_properties)

-- create a address composite data type

CREATE TYPE address AS (
	city VARCHAR(50),
	country VARCHAR(20)
);

CREATE TABLE companies(
	comp_id SERIAL PRIMARY KEY,
	address address
);

INSERT INTO companies (address) VALUES
(ROW('SURAT', 'INDIA')),
(ROW('LONDON', 'UK'));

SELECT address FROM companies;

SELECT (address).country FROM companies;

SELECT (companies.address).city FROM companies;

-- create a composite 'inv_item' data type

CREATE TYPE inv_item AS
(
	p_name VARCHAR(100),
	supplier_id INT,
	price NUMERIC
);

CREATE TABLE inventory (
	inv_id SERIAL PRIMARY KEY,
	item inv_item
);

INSERT INTO inventory (item) VALUES
(ROW('Name1', '1', '99')),
(ROW('Name2', '2', '199'));

SELECT * FROM inventory;

SELECT (item).p_name 
FROM inventory
WHERE (item).price > 100;

-- Create a currency ENUM data type with currency data

CREATE TYPE curr AS ENUM ('INR', 'USD');

SELECT 'INR'::curr;

ALTER TYPE curr ADD VALUE 'EUR' AFTER 'INR';

CREATE TABLE stocks (
	stock_id SERIAL PRIMARY KEY,
	stock_curr curr
);

INSERT INTO stocks (stock_curr) VALUES
('INR'),
('USD');

SELECT * FROM stocks;

-- DROP TYPE name

CREATE TYPE sample_type AS ENUM ('ABC', '123');

DROP TYPE sample_type;

-- ALTER data types

CREATE TYPE myaddr AS (
	city VARCHAR(50),
	country VARCHAR(20)
);

-- Rename a data type : ALTER TYPE name RENAME TO new_name

ALTER TYPE myaddr RENAME TO myaddress;

-- Change thw Owner : ALTER TYPE name OWNER TO username

ALTER TYPE myaddress OWNER TO meet;
ALTER TYPE myaddress OWNER TO postgres;

-- Change the schema : ALTER TYPE name SET SCHEMA schemaname

ALTER TYPE myaddress SET SCHEMA test_schema;
ALTER TYPE test_schema.myaddress SET SCHEMA public;

-- To add new attribute : ALTER TYPE name ADD ATTRIBUTE attributes

ALTER TYPE myaddress ADD ATTRIBUTE street_add VARCHAR(150);

-- Alter an  ENUM data type

CREATE TYPE sample_enum AS ENUM ('red', 'green');

-- Updates a Value : ALTER TYPE name RENAME VALUE oldvalue TO newvalue

ALTER TYPE sample_enum RENAME VALUE 'red' TO 'black';

-- List all ENUM values

SELECT enum_range(NULL::sample_enum);

-- To add a Value : ALTER TYPE name ADD VALUE valuename [BEFORE|AFTER] value

ALTER TYPE sample_enum ADD VALUE 'red' BEFORE 'black';

SELECT enum_range(NULL::sample_enum);


-- Update an ENUM data types in production server

CREATE TYPE status_enum AS ENUM ('queued','active', 'done');

CREATE TABLE jobs(
	job_id SERIAL PRIMARY KEY,
	job_status status_enum
);

INSERT INTO jobs (job_status) VALUES
('active'),
('queued'),
('active'),
('queued'),
('done'),
('queued'),
('active');

SELECT * FROM jobs;

UPDATE jobs 
SET job_status = 'done' 
WHERE job_status = 'active';

ALTER TYPE status_enum RENAME TO status_enum_old;

CREATE TYPE status_enum AS ENUM ('queued','active', 'done');

ALTER TABLE jobs ALTER COLUMN job_status TYPE status_enum USING job_status::TEXT::status_enum;

DROP TYPE status_enum_old;


-- An ENUM with a DEFAULT value in a table

CREATE TYPE status AS ENUM('a', 'b', 'c');

CREATE TABLE cron_jobs (
	cron_id INT,
	status status DEFAULT 'a'
);

INSERT INTO cron_jobs (cron_id) VALUES 
(1),
(2);

INSERT INTO cron_jobs (cron_id, status) VALUES 
(3,'b'),
(4, 'c');

SELECT * FROM cron_jobs;


-- Create a TYPE if not exists using PL/pgSQL function

DO
$$
BEGIN
	IF NOT EXISTS (SELECT * 
					FROM pg_type typ
						INNER JOIN pg_namespace nsp
						ON nsp.oid = typ.typnamespace
					WHERE nsp.nspname = CURRENT_SCHEMA()
							AND typ.typname = 'ai'
					)
	THEN 
		CREATE TYPE ai AS (a TEXT, i INTEGER);
	END IF;
END;
$$
LANGUAGE plpgsql;

--
-- Introuction to Constraints
--

-- 1. constraints are like 'gate keepers'
-- 2. controls the kind of data goes into the database
-- 3. constraints are the rules enforced on data columns on table
-- 4. these are used to prevent invalid data from being entered into the database
-- 5. constraints can be added on : Table, Columns

-- Types of constraints
/*
	NOT NULL
	UNIQUE
	DEFAULT
	PRIMARY KEY
	FOREIGN KEY		Constraints data based on columns in other tables
	CHECK			Checks all values meet specific criterias
*/


--
-- NOT NULL constraint
--

-- 1. NULL 	represents unknown or info. missing.
-- 2. NULL is not same as empty string or 0.

CREATE TABLE table_nn (
	id SERIAL PRIMARY KEY,
	tag TEXT NOT NULL
);

INSERT INTO table_nn (tag) VALUES 
('ABC');

INSERT INTO table_nn (tag) VALUES 
(NULL);

SELECT * FROM table_nn;

-- Adding NOT NULL constraint to an existing table

CREATE TABLE table_nn2 (
	id SERIAL PRIMARY KEY,
	tag TEXT
);

ALTER TABLE table_nn2
ALTER COLUMN tag SET NOT NULL;

--
-- UNIQUE constraint
--

CREATE TABLE table_unique(
	id SERIAL PRIMARY KEY,
	email text UNIQUE
);

INSERT INTO table_unique (email) VALUES 
('abc@gmail.com');

SELECT * FROM table_unique;

-- UNIQUE on multiple column

CREATE TABLE table_unique2 (
	id SERIAL PRIMARY KEY,
	p_code VARCHAR(10),
	p_name TEXT
	-- UNIQUE(p_code, p_name)
);

ALTER TABLE table_unique2
ADD CONSTRAINT unique_p UNIQUE(p_code, p_name);

INSERT INTO table_unique2 (p_code, p_name) VALUES
('1', 'Name1'),
('1', 'Name2');

ALTER TABLE table_unique2 
DROP CONSTRAINT unique_p;

SELECT * FROM table_unique2;

--
-- DEFAULT constraint
--

CREATE TABLE table_default(
	e_id SERIAL PRIMARY KEY,
	f_name VARCHAR(50),
	l_name VARCHAR(50),
	is_on VARCHAR(2) DEFAULT 'Y'
);

INSERT INTO table_default (f_name, l_name) VALUES
('firstname', 'lastname');

SELECT * FROM table_default;

-- Set DEFAULT to an existing table

ALTER TABLE table_default
ALTER COLUMN is_on SET DEFAULT 'N';

INSERT INTO table_default (f_name, l_name) VALUES
('firstname1', 'lastname1');

SELECT * FROM table_default;

-- DROP DEFAULT constraint

ALTER TABLE table_default
ALTER COLUMN is_on DROP DEFAULT;

INSERT INTO table_default (f_name, l_name) VALUES
('firstname2', 'lastname2');

SELECT * FROM table_default;

--
-- PRIMARY KEY constraint
--

CREATE TABLE table_pk(
	item_id INTEGER PRIMARY KEY,
	item_name VARCHAR(100) NOT NULL
);

INSERT INTO table_pk (item_id, item_name) VALUES
(1, 'Pen'),
(2, 'Pen');

SELECT * FROM table_pk;

-- DROP PRIMARY KEY

ALTER TABLE table_pk
DROP CONSTRAINT table_pk_pkey;

-- Add PRIMARY KEY to an existing table

ALTER TABLE table_pk
ADD PRIMARY KEY (item_id, item_name);

--
-- PRIMARY KEY on multiple columns = COMPOSITE PRIMARY KEY 
--

CREATE TABLE table_composite(
	c_id VARCHAR(100) NOT NULL,
	s_id VARCHAR(100) NOT NULL,
	grade int NOT NULL,
	PRIMARY KEY(c_id, s_id)
);

INSERT INTO table_composite (c_id, s_id, grade) VALUES
('MATH', 'S1', 90),
('CHE', 'S1', 80),
('ENG', 'S2', 70),
('PHY', 'S1', 60);

SELECT * FROM table_composite;

-- DROP constraint

ALTER TABLE table_composite
DROP CONSTRAINT table_composite_pkey;

-- ADD constraint

ALTER TABLE table_composite 
ADD CONSTRAINT table_composite_c_id_s_id_pkey
	PRIMARY KEY(c_id, s_id);

--
-- FOREIGN KEY constraint
--

-- FOREIGN KEY (columnname) REFERENCES child_table_name (columname)

CREATE TABLE t_products(
	p_id INT PRIMARY KEY,
	p_name VARCHAR(100) NOT NULL,
	s_id INT NOT NULL,
	FOREIGN KEY (s_id) REFERENCES t_suppliers (s_id)
);


CREATE TABLE t_suppliers(
	s_id INT PRIMARY KEY,
	s_name VARCHAR(100) NOT NULL
);

INSERT INTO t_suppliers (s_id, s_name) VALUES
(1, 'SUP 1'),
(2, 'SUP 2')
;

SELECT * FROM t_suppliers;

INSERT INTO t_products (p_id, p_name, s_id) VALUES
(1, 'PAN', 1),
(2, 'PAPER', 2)
;

SELECT * FROM t_products;

INSERT INTO t_suppliers (s_id, s_name) VALUES
(100, 'SUP 100');

INSERT INTO t_products (p_id, p_name, s_id) VALUES
(3, 'BOOK', 100);

DELETE FROM t_products
WHERE s_id = 100;

DELETE FROM t_suppliers
WHERE s_id = 100;

UPDATE t_products 
SET s_id = 2
WHERE p_id = 1;

UPDATE t_suppliers 
SET s_id = 10
WHERE s_id = 1;


-- DROP a constraint

ALTER TABLE t_products
DROP CONSTRAINT t_products_s_id_fkey;


-- Update foreign key constraint on an existing table

ALTER TABLE t_products
ADD CONSTRAINT t_products_s_id_fkey FOREIGN KEY (s_id) REFERENCES t_suppliers (s_id);

--
-- CHECK constraint
--

CREATE TABLE table_check(
	staff_id SERIAL PRIMARY KEY,
	f_name VARCHAR(50),
	l_name VARCHAR(50),
	b_day DATE CHECK (b_day > '1990-01-01'),
	joined_date DATE CHECK (joined_date > b_day),
	salary NUMERIC CHECK (salary > 0)
);

INSERT INTO table_check (f_name, l_name, b_day, joined_date, salary) VALUES 
('ABC', 'XYZ', '2000-05-01', '2024-12-01', 1000);

SELECT * FROM table_check;

-- For existing table

CREATE TABLE table_check1(
	price_id SERIAL PRIMARY KEY,
	product_id INT NOT NULL,
	price NUMERIC NOT NULL,
	discount NUMERIC NOT NULL,
	valid_from DATE NOT NULL
);

ALTER TABLE table_check1
ADD CONSTRAINT table_check1_check
CHECK (
	price > 0
	AND discount >= 0
	AND price > discount
);

SELECT * FROM table_check1;

-- RENAME constraint

ALTER TABLE table_check1
RENAME CONSTRAINT table_check1_check TO check_table_check1;

-- DROP constraint

ALTER TABLE table_check1
DROP CONSTRAINT check_table_check1;

-- 
-- SEQUENCE
--

CREATE SEQUENCE IF NOT EXISTS test_seq;

-- Return next value
SELECT nextval('test_seq');

-- Return most current value
SELECT currval('test_seq');

-- Set a sequence
SELECT setval('test_seq', 100);

-- Set a sequence and do not skip over
SELECT setval('test_seq', '200', FALSE);

-- Control the sequence START value
CREATE SEQUENCE IF NOT EXISTS test_seq2 START WITH 100;

-- ALTER a sequence 

SELECT nextval('test_seq');

-- RESTART 
ALTER SEQUENCE test_seq RESTART WITH 100;
SELECT nextval('test_seq');

-- RENAME 
ALTER SEQUENCE test_seq RENAME TO test_seq_new;

--

CREATE SEQUENCE IF NOT EXISTS test_seq3
INCREMENT 10
MINVALUE 100
MAXVALUE 1000
START WITH 110;

SELECT nextval('test_seq3');

CREATE SEQUENCE IF NOT EXISTS test_seq4 AS SMALLINT;
CREATE SEQUENCE IF NOT EXISTS test_seq5 AS INT;

SELECT nextval('test_seq4');

-- Create a descending sequence

CREATE SEQUENCE test_seq6
INCREMENT -1
MINVALUE 1
MAXVALUE 3
START 3
CYCLE;

SELECT nextval('test_seq6');

CREATE SEQUENCE test_seq7
INCREMENT -1
MINVALUE 1
MAXVALUE 3
START 3
NO CYCLE;

SELECT nextval('test_seq7');

-- DROP sequence 
DROP SEQUENCE test_seq_new;


-- Attach a sequence to a table column

CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	user_name VARCHAR(50)
);

INSERT INTO users (user_name) VALUES
('A'),
('B');

ALTER SEQUENCE users_user_id_seq RESTART WITH 100;

INSERT INTO users (user_name) VALUES
('C'),
('D');

SELECT * FROM users;

-- 

CREATE TABLE users2(
	user2_id INT PRIMARY KEY,
	user2_name VARCHAR(50)
);


CREATE SEQUENCE users2_user2_id_seq 
START WITH 100 OWNED BY users2.user2_id;

ALTER TABLE users2
ALTER COLUMN user2_id SET DEFAULT nextval('users2_user2_id_seq');

INSERT INTO users2 (user2_name) VALUES
('Name'),
('Name1');

SELECT * FROM users2;

-- list all sequence

SELECT relname sequence_name
FROM pg_class
WHERE relkind = 'S';

-- Share a sequence among tables

CREATE SEQUENCE fruit_seq START WITH 100;

CREATE TABLE apples(
	fruit_id INT DEFAULT nextval('fruit_seq') NOT NULL,
	fruit_name VARCHAR(50)
);

CREATE TABLE mangoes(
	fruit_id INT DEFAULT nextval('fruit_seq') NOT NULL,
	fruit_name VARCHAR(50)
);

INSERT INTO apples (fruit_name) VALUES ('A1');

SELECT * FROM apples;

INSERT INTO mangoes (fruit_name) VALUES ('M1');

SELECT * FROM mangoes;

-- 

CREATE TABLE contacts (
	c_id SERIAL PRIMARY KEY,
	c_name VARCHAR(150)
);

INSERT INTO contacts (c_name) VALUES ('C1');

SELECT * FROM contacts;

DROP TABLE contacts;

--

CREATE SEQUENCE table_seq;

CREATE TABLE contacts(
	c_id TEXT NOT NULL DEFAULT ('ID' || nextval('table_seq')),
	c_name VARCHAR(50)
);

INSERT INTO contacts (c_name) VALUES ('C10'), ('C11');

SELECT * FROM contacts;

ALTER SEQUENCE table_seq OWNED BY contacts.c_id;

INSERT INTO contacts (c_name) VALUES ('C100'), ('C101');

SELECT * FROM contacts;

