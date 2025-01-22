-- Database: mydata

-- DROP DATABASE IF EXISTS mydata;

-- CREATE DATABASE mydata
--     WITH
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'English_India.1252'
--     LC_CTYPE = 'English_India.1252'
--     LOCALE_PROVIDER = 'libc'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1
--     IS_TEMPLATE = False;

CREATE TABLE persons(
	p_id SERIAL PRIMARY KEY,
	f_name VARCHAR(20) NOT NULL,
	l_name VARCHAR(20) NOT NULL
);

-- ADD COLUMN

ALTER TABLE persons
ADD COLUMN age INT NOT NULL;

ALTER TABLE persons 
ADD COLUMN email VARCHAR(50) UNIQUE;

SELECT * FROM persons;

-- RENAME TABLE

ALTER TABLE persons
RENAME TO users;

SELECT * FROM users;

ALTER TABLE users
RENAME TO persons;

SELECT * FROM persons;

-- RENAME COLUMN

ALTER TABLE persons
RENAME COLUMN age TO p_age;

SELECT * FROM persons;

-- DROP a COLUMN

ALTER TABLE persons
DROP COLUMN p_age;

SELECT * FROM persons;

ALTER TABLE persons
ADD COLUMN age INT;

-- Change the data types of a column

ALTER TABLE persons
ALTER COLUMN email TYPE VARCHAR(100);

ALTER TABLE persons
ALTER COLUMN age TYPE VARCHAR(10);

ALTER TABLE persons
ALTER COLUMN age TYPE INT
USING age::INTEGER;

SELECT * FROM persons;

ALTER TABLE persons
ADD COLUMN is_en VARCHAR(1);

ALTER TABLE persons
ALTER COLUMN is_en SET DEFAULT 'Y';


-- 

CREATE TABLE web_links(
	link_id SERIAL PRIMARY KEY,
	link_url VARCHAR(255) NOT NULL,
	link_target VARCHAR(20)
);

INSERT INTO web_links (link_url, link_target) VALUES
('https://www.google.com', '_blank');

ALTER TABLE web_links
ADD CONSTRAINT unique_web_url UNIQUE (link_url);


INSERT INTO web_links (link_url, link_target) VALUES
('https://www.amazon.com', '_blank');

-- To set a column to accpet only defined allowed data 

ALTER TABLE web_links
ADD COLUMN is_enable VARCHAR(2);

INSERT INTO web_links (link_url, link_target, is_enable) VALUES
('https://www.abc.com', '_blank', 'Y');

ALTER TABLE web_links
ADD CHECK (is_enable IN ('Y', 'N'));

INSERT INTO web_links (link_url, link_target, is_enable) VALUES
('https://www.xyz.com', '_empty', 'A'); -- Error

UPDATE web_links
SET is_enable = 'Y'
WHERE link_id = 1;

UPDATE web_links
SET is_enable = 'N'
WHERE link_id = 3;

SELECT * FROM web_links;

