-- All About Views

/*
-- view: database object that is of a stored query, virtual table
-- helps encapulates quries and logic into reusable obj., to speedup workflow
-- similar to regular table: query, join, update or insert data.
-- regular view: doesn't store data, materialized view: stores data
-- avoid duplicates, reduce complexity, limit access to certain columns of table,grant permissions 
*/

-- Creating a view

-- CREATE OR REPLACE VIEW view_name AS query
CREATE OR REPLACE VIEW v_movie_quick AS
SELECT
	movie_name,
	movie_length,
	movie_lang,
	release_date
FROM movies;

-- no duplicate columns allowed
CREATE OR REPLACE VIEW v_movies_directors_all AS
SELECT 
	* 
FROM movies
INNER JOIN directors USING(director_id);

SELECT * FROM v_movie_quick;

SELECT * FROM v_movies_directors_all;

-- Rename a view  -- Priviledges needed to alter the view
ALTER VIEW v_movie_quick RENAME TO v_movie_quick2;

-- Delete view
DROP VIEW v_movie_quick2;

-- Using filters with views
CREATE OR REPLACE VIEW v_movies_after_1997 AS
SELECT * FROM movies
WHERE release_date >= '1997-12-31'
ORDER BY release_date DESC;


SELECT * FROM v_movies_after_1997
WHERE movie_lang = 'English';


SELECT 
	* 
FROM v_movies_directors_all
WHERE nationality in ('American', 'Japanese');

--  A view with UNION of multiple tables
CREATE VIEW v_all_actors_directors AS
SELECT
	first_name,
	last_name,
	'actors' AS people_type
FROM actors
UNION ALL
SELECT 
	first_name,
	last_name,
	'directors' AS people_type
FROM directors;

SELECT * FROM v_all_actors_directors
WHERE first_name LIKE 'J%'
ORDER BY people_type, first_name;

-- Connecting multiple tables with a single view
CREATE OR REPLACE VIEW v_movies_directors_revenues AS
SELECT 
	* 
FROM movies
INNER JOIN directors USING(director_id)
INNER JOIN movies_revenues USING(movie_id);

SELECT * FROM v_movies_directors_revenues
WHERE age_certificate = '12';

-- Re-arrange columns in a view
-- delete the existing view and create another
CREATE VIEW v_directors AS
SELECT 
	first_name,
	last_name
FROM directors;

-- rename original view and create new
CREATE VIEW v_directors AS
SELECT 
	last_name,
	first_name
FROM directors;

-- Delete a column in a view
-- delete last_name

SELECT * FROM v_directors
-- rename v_directors to v_directors1 (pgAdmin)

CREATE VIEW v_directors AS
SELECT 
	first_name
FROM directors

SELECT * FROM v_directors

-- Add a column in a view 
-- add nationality
CREATE OR REPLACE VIEW v_directors AS
SELECT 
	first_name,
	last_name,
	nationality
FROM directors;

-- cannot change name of view column "last_name" to "nationality"
-- HINT:  Use ALTER VIEW ... RENAME COLUMN ... to change name of view column instead.

CREATE OR REPLACE VIEW v_directors AS
SELECT 
	first_name,
	nationality,
	last_name
FROM directors;

-- Regular views are dynamic

SELECT * FROM v_directors;

INSERT INTO directors(first_name) VALUES ('Meet'), ('Jay')

SELECT * FROM v_directors;

SELECT * FROM directors
DELETE FROM directors WHERE director_id = 40;

SELECT * FROM v_directors;

/*
	What is an updatable view?
	-- allows to update data on underlying data
	Rules: 
		1) query must have one FROM entry which can be either a table or updatable view
		2) query cannot contain this at top level: 
			DISTINCT, GROUP BY, WITH    
			LIMIT, OFFSET   
			UNION, INTERSECT, EXCEPT  
			HAVING
		3) you cannot use folloeing in selection list;
			any window function,
			any set-returning function,
			aggregate functions: SUM, COUNT, MAX, MIN, AVG
		4) operationas to update: INSERT, UPDATE, DELETE  along with say a WHERE clause	
		5) User must have privilege in the view, not on table (security)
*/

-- An updatable view with CRUD operations
-- create updatable view for director 

CREATE OR REPLACE VIEW vu_directors AS
SELECT
	first_name,
	last_name
FROM directors;

--Add records via view
INSERT INTO vu_directors(first_name) VALUES ('Abc'), ('Xyz');

-- Read
SELECT * FROM vu_directors
SELECT * FROM directors;

-- Delete
DELETE FROM vu_directors
WHERE first_name = 'Abc';

-- Read
SELECT * FROM vu_directors
SELECT * FROM directors;


-- Updatable views using WITH CHECK OPTION
-- ensures changes to base table through views satisfies view-defining conditions
-- good for security measures

CREATE TABLE countries(
	country_id SERIAL PRIMARY KEY,
	country_code VARCHAR(4),
	city_name VARCHAR(100)
);

INSERT INTO countries(country_code, city_name) VALUES
('US', 'New York'),
('IND', 'Ahmedabad'),
('IND', 'Anjar')
SELECT * FROM countries;

CREATE OR REPLACE VIEW vu_country_ind AS
SELECT * FROM countries
WHERE country_code = 'IND'

SELECT * FROM vu_country_ind

-- both data addedd successfully
INSERT INTO vu_country_ind(country_code, city_name) VALUES
('US', 'New York')
INSERT INTO vu_country_ind(country_code, city_name) VALUES
('IND', 'Banglore')

CREATE OR REPLACE VIEW vu_country_ind AS
SELECT * FROM countries
WHERE country_code = 'IND'
WITH CHECK OPTION

--error as only 'IND' is allowed
INSERT INTO vu_country_ind(country_code, city_name) VALUES
('US', 'California')

INSERT INTO vu_country_ind(country_code, city_name) VALUES
('IND', 'Pune')

SELECT * FROM countries
SELECT * FROM vu_country_ind;

--update
UPDATE vu_country_ind
SET country_code = 'US'
WHERE city_name = 'Pune';


--Updatable views using WITH LOCAL and CASCADED CHECK OPTION
/*
	CASCADED CHECK OPTION (default behavior)
		Enforces the CHECK OPTION on all levels of views involved.
		When you perform an INSERT or UPDATE on the view, the modified data must satisfy the conditions of:
			The current view, and
			Any other views on which the current view is based.
	LOCAL CHECK OPTION
		Enforces the CHECK OPTION only on the current view.
		When you perform an INSERT or UPDATE, the modified data only needs to satisfy the conditions of the immediate view (not the underlying views).

*/

CREATE OR REPLACE VIEW vu_cities_c AS
SELECT
	*
FROM countries
WHERE city_name LIKE 'C%'

INSERT INTO vu_cities_c(country_code, city_name) VALUES
('US', 'California')
INSERT INTO vu_cities_c(country_code, city_name) VALUES
('IND', 'Calcutta')

SELECT * FROM vu_cities_c

-- local
CREATE OR REPLACE VIEW vu_cities_c_ind AS
SELECT
	*
FROM vu_cities_c
WHERE country_code = 'IND'
WITH LOCAL CHECK OPTION

INSERT INTO vu_cities_c_ind(country_code, city_name) VALUES
('US', 'California')    -- error only ind allow
INSERT INTO vu_cities_c_ind(country_code, city_name) VALUES
('IND', 'Delhi')    -- inserted

SELECT * FROM countries
SELECT * FROM vu_cities_c_ind

-- cascade
CREATE OR REPLACE VIEW vu_cities_c_ind AS
SELECT
	*
FROM vu_cities_c
WHERE country_code = 'IND'
WITH CASCADED CHECK OPTION

INSERT INTO vu_cities_c_ind(country_code, city_name) VALUES
('US', 'California');

INSERT INTO vu_cities_c_ind(country_code, city_name) VALUES
('IND', 'Delhi');

INSERT INTO vu_cities_c_ind(country_code, city_name) VALUES
('IND', 'Chattisgarh')  -- inserted

SELECT * FROM countries
SELECT * FROM vu_cities_c_ind

-- What is a Materialized View

/*
    A Materialized View is a database object that stores the result of a query physically on disk, unlike a regular view, which is essentially a stored query that is computed dynamically when accessed. 
    Materialized views improve performance for complex queries by precomputing and storing the query results, which can then be queried like a regular table.
    Precomputed Results:
        The query results are stored, so when you query the materialized view, the data retrieval is fast.
        Suitable for queries involving large joins, aggregations, or computations.
    Refreshable:
        The data in a materialized view can become outdated as the underlying tables change. To address this, materialized views can be refreshed:
        Manually (ON DEMAND).
        Automatically (ON COMMIT).
    Storage:
        Materialized views consume physical storage because the query results are saved on disk.
    Indexing:
        You can create indexes on materialized views to further improve query performance.
    Use Cases:
        Data warehouses and OLAP systems, where complex queries run frequently, benefit significantly from materialized views.

    CREATE MATERIALIZED VIEW IF NOT EXISTS view_name AS query
    WITH [NO] DATA

    CREATE MATERIALIZED VIEW view_name
    [BUILD IMMEDIATE | BUILD DEFERRED]
    [REFRESH [FAST | COMPLETE | FORCE] ON [COMMIT | DEMAND]]
    AS
    SELECT column1, column2, ...
    FROM table_name
    WHERE conditions;

        BUILD IMMEDIATE (default): Builds the materialized view immediately when created.
        BUILD DEFERRED: Delays building the materialized view until it is explicitly refreshed.
        REFRESH Options:
        FAST: Applies only the changes (deltas) to the materialized view since the last refresh.
        COMPLETE: Fully rebuilds the materialized view.
        FORCE: Chooses FAST if possible; otherwise, uses COMPLETE.
        ON COMMIT: Automatically refreshes the materialized view when a transaction affecting its base table is committed.
        ON DEMAND (default): Requires a manual refresh.

    -- Refresh manually when data in the base table changes
    REFRESH MATERIALIZED VIEW view_name;
*/

-- Create
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors AS
SELECT
	first_name,
	last_name
FROM directors
WITH DATA

SELECT * FROM mv_directors

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors_nodata AS
SELECT
	first_name,
	last_name
FROM directors
WITH NO DATA

SELECT * FROM mv_directors_nodata; -- ERROR 

REFRESH MATERIALIZED VIEW mv_directors_nodata   -- load data
SELECT * FROM mv_directors_nodata

--Drop
DROP MATERIALIZED VIEW mv_directors_nodata

-- Changing
-- INSERT, UPDATE, DELETE can be done on table, can't be performed at materialized view
SELECT * FROM mv_directors

INSERT INTO mv_directors (first_name) VALUES ('AA'), ('BB');   -- ERROR: cannot change
INSERT INTO directors (first_name) VALUES ('AA'), ('BB');

REFRESH MATERIALIZED VIEW mv_directors;

SELECT * FROM mv_directors;

-- How to check if a materialized view is populated or not?
-- SELECT relispopulated FROM pg_class WHERE relname = 'mat_view_name'

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors2 AS
SELECT
	first_name
FROM directors
WITH NO DATA;

SELECT * FROM mv_directors2; -- ERROR

SELECT relispopulated FROM pg_class WHERE relname = 'mv_directors2';

-- Refreshing data in materialize views
-- when refreshing for materialized view, postgre locks the table, therefore you cannot query it

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors_us AS
SELECT
	*
FROM directors
WHERE nationality = 'American'
WITH NO DATA	

SELECT * FROM mv_directors_us

REFRESH MATERIALIZED VIEW mv_directors_us
SELECT * FROM mv_directors_us

-- how to query data, while it is refreshing data
-- REFRESH MATERIALIZED VIEW CONCURRENTLY view_name;
-- allows to update view without locking it.
-- materialize view must have unique index

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_directors_us; -- ERROR

CREATE UNIQUE INDEX idx_u_mv_directors_us_direcvtor_id ON mv_directors_us (director_id);

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_directors_us;
SELECT * FROM mv_directors_us


-- Why not use a table instead of materialized view?
-- Ability to easily refresh it without locking everyone else out of it

-- Tables: lots of steps
create table temp like data
insert into temp values( .... )
drop table data
alter table temp rename to data;

--materialized view:
create materialized view my_data as query
with data
REFRESH MATERIALIZED VIEW CONCURRENTLY my_data;


-- The downsides of using materialized views
-- depends on base table and creates dependences on the tables they reference
-- tables are suitable for database with lots of tables and mulitple applications & team

-- Using materialized view for websites page analysis
CREATE TABLE page_clicks(
	rec_id SERIAL PRIMARY KEY,
	page VARCHAR(200),
	click_time TIMESTAMP,
	user_id BIGINT	
)

INSERT INTO page_clicks(page, click_time, user_id) 
SELECT
(
	CASE(random()*2)::INT
		WHEN 0 THEN 'klickanalytics.com'
		WHEN 1 THEN 'clickapis.com'
		WHEN 2 THEN 'google.com'
	END
) AS page,
NOW() AS click_time,
(FLOOR(random() * (111111111 - 100000000 + 1) + 100000000))::INT AS user_id
FROM GENERATE_SERIES(1,10000) seq;

SELECT * FROM page_clicks;

--no. of clicks per page
CREATE MATERIALIZED VIEW mv_page_clicks AS
SELECT
	date_trunc('day', click_time) as day,
	page,
	count(*) as total_clicks
FROM page_clicks
GROUP BY day, page;

REFRESH MATERIALIZED VIEW mv_page_clicks
SELECT * FROM mv_page_clicks;

-- data grows bigger day by day, split the materialized view
CREATE MATERIALIZED VIEW mv_page_clicks_daily AS
SELECT
	click_time as day,
	page,
	count(*) as cnt
FROM page_clicks
WHERE 
	click_time >= date_trunc('day', NOW()) AND 
	click_time < TIMESTAMP 'tomorrow'
GROUP BY day, page;

REFRESH MATERIALIZED VIEW mv_page_clicks_daily
SELECT * FROM mv_page_clicks_daily;

CREATE UNIQUE INDEX idx_u_mv_page_clicks_daily_day_page ON mv_page_clicks_daily (day, page)
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_page_clicks_daily
SELECT * FROM mv_page_clicks_daily;


-- List all materialized views by a SELECT statement
SELECT oid::regclass::text
FROM pg_class
WHERE relkind = 'm'
ORDER BY 1;
 