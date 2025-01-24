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
SET search_path TO '$user', test, public

-- Schema Ownerships
-- ALTER SCHEMA schema_name OWNER TO new_owner

ALTER SCHEMA test OWNER TO meet;

-- Duplicate a schema with all data

-- create a test database
CREATE DATABASE test_schema;

-- =====
-- Continue to 19_schemas_test_schema_db
-- =====

-- The system Catalog Schema

/*
-- In addition to public and user_created schemas, each database contains a 
	'pg_catalog' schema.

-- 	PostgreSQL stores the metadata info about the database and cluster in the schema 
	'pg_catalog'.

-- 'pg_catalog' schema contains system tables and all the built-in data types,
	fns and operators.

-- 'pg_catalog' is always effectively part of the search path. Although if it is not named 
	explicitly in the path then it is implicitly searching the path's schemas

-- In pg_catalog, all system table names begin with 'pg_', so it is best to avoid such
	names to ensure that you won't suffer a conflict.
*/

-- How to view pg_catalog or infact all schemas including system 
SELECT * FROM information_schema.schemata;

-- The information_schema is a system schema. the information schema consists of a set of views
-- that contain information about the objects defined in the current database.

-- pg_catalog has a preety solid rule, Look, Don't TOUCH or ALTER.


-- =====
-- Schemas and privileges

-- Users can only access objects in the schemas that they own.

-- Two schema access levels rights
-- USAGE : To access schema
-- CREATE : To cretae objects like tables etc in a schema

-- USAGE :
--	To allow users to access the objects in the schema that they do not own,
--	we must grant the USAGE privileges of the schema

-- GRANT USAGE ON SCHEMA schema_name TO role_name;

-- 1. Create a schema called 'private' on 'hr' db and give rights o postgres user

-- 2. Lets try to access the schema via user 'meet' -- access denied for private schema
GRANT USAGE ON SCHEMA private TO meet; -- permission denied for table t1	

GRANT SELECT ON ALL TABLES IN SCHEMA private TO meet;

-- can create an object such as table in 'private' schema? : NO
GRANT CREATE ON SCHEMA private TO meet; -- Now he can create table

-- By default, every user has the CREATE and USAGE on the 'public' schema