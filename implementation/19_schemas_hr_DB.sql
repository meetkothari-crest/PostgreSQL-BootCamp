-- Schema Operations (Add/ Alter/ Delete)

-- Create a schema
-- CREATE SCHEMA schema_name

CREATE SCHEMA sales;

-- Rename a schema : 
-- ALTER SCHEMA schema_name RENAME TO new_schema_name

ALTER SCHEMA sales RENAME TO programming;

-- Drop a schema

DROP SCHEMA programming;

-- Schema Hierarchy

-- Physical : host> cluster> database> schema> object name
-- Object access : database.schema.object_name

-- Select a table from a 'public' schema

SELECT *
FROM hr.public.employees;

-- move a table to a new schema
-- ALTER TABLE table_name SET SCHEMA schema_name;

ALTER TABLE public.countries SET SCHEMA test;
ALTER TABLE test.countries SET SCHEMA public;


-- Schema search path

-- How to view the current schema
SELECT current_schema();

-- How to view current search path
SHOW search_path;

-- How to add new schema to search path
-- SET search_path TO schema_name, public;
-- SET search_path TO '$user', test, public

