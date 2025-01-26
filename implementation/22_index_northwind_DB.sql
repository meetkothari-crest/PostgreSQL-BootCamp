-- Create an index

/*
	1. You put them on table column or columns
	2. Too many indexes will result in slow insert/update/delete operations
	3. PostgreSQL supports indexes with up to 32 columns
	4. Two main basic index types
		INDEX - create an index on only values of a column or columns
		UNIQUE INDEX - create an index on only UNIQUE values of a column or columns
*/

CREATE INDEX index_name 
ON table_name (col1, col2, .....);

CREATE UNIQUE INDEX index_name
ON table_name (col1, col2, .....);

CREATE INDEX index_name 
ON table_name [USING method]
(
	column_name [ASC | DESC] [NULLS {FIRST | LAST}],
	.....
);

-- Try to keep the naming convention unique and globally accessable.
INDEX			CREATE INDEX idx_table_name_column1_name_col2_name....
UNIQUE INDEX	CREATE INDEX idx_u_table_name_column_name

-- 1. Lets create an index on order_date on orders table

CREATE INDEX idx_orders_order_date ON orders (order_date);

CREATE INDEX idx_orders_ship_city ON orders (ship_city);

-- create an index on multiple fields say orders -> customer_id, order_id

CREATE INDEX idx_orders_customer_id_order_id ON orders (customer_id, order_id);


/*

Important : when creating multi-column indexes, Always place the most selective columns
			first. 

*/

-- Create unique index

-- Primary key and indexes
/*
	1. Normally the primary key of a table are kept with a UNIQUE INDEX.
	2. if you define a UNIQUE index for two or more columns, the combined values in these 
	columns can't be duplicated in multiple rows.
*/

-- Lets create a UNIQUE index on products table on product_id

CREATE UNIQUE INDEX idx_u_products_product_id ON products (product_id);


CREATE UNIQUE INDEX idx_u_employees_employee_id ON employees (employee_id);

-- create on multiple columns

CREATE UNIQUE INDEX idx_u_orders_order_id_customer_id ON orders (order_id, customer_id);

-- List all indexes

SELECT * FROM pg_indexes

SELECT * FROM pg_indexes WHERE schemaname = 'public';

SELECT * FROM pg_indexes WHERE tablename = 'orders';

-- size of the table index

SELECT pg_size_pretty(pg_indexes_size('orders'));

-- Lets create an index on supplier -> region

SELECT pg_size_pretty(pg_indexes_size('suppliers'));

CREATE INDEX idx_suppliers_region ON suppliers (region);

SELECT pg_size_pretty(pg_indexes_size('suppliers'));

-- List counts for all indexes
-- pg_stat_all_indexes

-- all stats
SELECT * FROM pg_stat_all_indexes;

SELECT *
FROM pg_stat_all_indexes
WHERE schemaname = 'public';

SELECT *
FROM pg_stat_all_indexes
WHERE relname = 'orders';

-- DROP an Index

DROP INDEX [CONCURRENTLY]
[IF EXISTS] index_name
[CASCADE | RESTRICT];

-- CASCADE : If the index has dependent objects, you use the CASCADE option to 
--			 automatically drop these objects and all objects that depends on those. 

-- RESTRICT : the RESTRICT option instructs PostgreSQL to refuse to drop the index if any 
-- 			  objects depend on it. The DROP INDEX uses RESTRICT by default.

-- CONCURRENTLY : When execute the DROP INDEX, PostgreSQL acquires an exclusive lock
--				  on the table and block other accesses until the index removal completes.


DROP INDEX idx_suppliers_region;

-- SQL statement execution stages

/*

	parser : handles the textual form of the statement (the SQL text) and verifies 
			 whether it is correct or not

			 disassemble info into tables, columns, clauses etc..

	rewriter : applying the syntactic rules to rewrite the original SQL statement

	optimizer : finding the very fastest path to the data that the statement needs

	executor : responsible for effectively going to the storage and retrieving (or inserting)
			   the data gets physical access to the data

*/

-- the optimizer 
/* 

	a. what to use to access data
	b. as quickly as possible

	1. the cost is everything
	2. thread
	3. nodes

	e.g. select * from orders order by order_id
		a. all data		node#1
		b. order by		node#2
	
	4. nodes types

*/

-- optimizer nodes types
/*

	1. Nodes are available for;
		- every operations and 
		- every access methods

	2. nodes are stackable
		parent node
			child node 1
				child node 2
					.....
		- the output of a node can be used as the input to another node

	3. Types of Nodes 
		- Sequential scan
		- index scan, index only scan and bitmap index scan
		- nested loop, hash join and merge join
		- the gather and merge parallel nodes

		select * from pg_am;
*/

-- Sequential scan
/*

	1. Default when no other valuable alternative.
	2. Read from the begining of the dataset
	3. Filtering clause is not very limited

	EXPLAIN SELECT * FROM orders;
	EXPLAIN SELECT * FROM orders WHERE order_id IS NOT NULL;
*/


/*

-- Index nodes
	1. An index is used to access the dataset
	2. Data file and index files are separated but they arr nearby

	3. Index node scan type

	Index Scan - 		index -> seeking the tuples -> then read the again the data
	Index Only Scan - 	requested index columns only -> directly get data from index file
	Bitmap Index Scan	builds a memory bitmap of where tuples that satisfy the statement clauses

*/
show work_mem

EXPLAIN SELECT * FROM orders 
NATURAL JOIN customers;


-- Index Types

/*

	B-Tree INdex

	1. Default Index
	2. Self-balancing tree
		- SELECT, INSERT, DELETE and sequential access in logarithmic time
	3. Can be used for most operators and column type
	4. supports the UNIQUE condition and 
	5. Normally used to build the primary key indexes
	6. uses when columns involves following operators

*/

-- Hash Index 
/*

	1. for equality operators (Only simple equality comparison = )
	2. not for range nor disequality operators
	3. larger than b-tree indexes

*/

CREATE INDEX index_name 
ON table_name
	USING hash (column_name);

CREATE INDEX idx_orders_order_date_on 
ON orders
USING hash (order_date);

SELECT * FROM orders 
ORDER BY order_date;

-- BRIN Index
/*

	1. block range indexes
	2. data block -> min to max value
	3. smaller index
	4. Less costly to maintain than btree index
	5. can be used on a large table vs btree index
	6. used linear sort order 

*/

-- GIN Index
/*

	1. generalized inverted index
	2. Point to multiple tuples
	3. Used with array type data
	4. used in full text-search
	5. Useful when we have multiple values stored in a single column

*/
 
-- the EXPLAIN statement
/*

	1. It will show query execution plan
	2. Shows the lowest COST among evaluted plans
	3. Will not execute the statement you enter, just show query only
	4. show you the execution nodes that the executor will use to provide you with the dataset

*/

EXPLAIN SELECT * FROM suppliers
WHERE supplier_id = 1;


EXPLAIN SELECT * FROM orders WHERE order_id = 1;

EXPLAIN (FORMAT JSON) SELECT * FROM orders WHERE order_id = 1;

EXPLAIN ANALYZE SELECT * FROM orders WHERE order_id = 1;

-- Understanding query cost model

CREATE TABLE t_big (id SERIAL, name TEXT);

INSERT INTO t_big (name)
SELECT 'Meet' FROM generate_series(1, 2000000);

EXPLAIN SELECT * FROM t_big WHERE id = 12345;

SHOW max_parallel_workers_per_gather;

SET max_parallel_workers_per_gather = 0;

EXPLAIN SELECT * FROM t_big WHERE id = 12345;

SELECT pg_relation_size('t_big') / 8192;

SHOW seq_page_cost  --1

SHOW cpu_tuple_cost --0.01

SHOW cpu_operator_cost  --"0.0025"

-- cost formula
-- (pg_relation_size*seq_page_cost) + (total_number_of_table_records*cpu_tuple_cost) 
-- + (total_number_of_table_records*cpu_operator_cost)

SELECT (10811 * 1) + (4000000 * 0.01) + (4000000 * 0.0025);

EXPLAIN SELECT * FROM t_big WHERE id = 12345;

CREATE INDEX idx_t_big_id ON t_big(id)

EXPLAIN SELECT * FROM t_big WHERE id = 12345

SELECT pg_size_pretty(pg_total_relation_size('t_big'));

SELECT pg_size_pretty(pg_indexes_size('t_big'));

-- paraller index creation -> btree index
show max_parallel_maintenance_workers;

-- Indexes for sorted output: it returns in sort order ASC, less cost
EXPLAIN SELECT * FROM t_big 
ORDER BY id 
LIMIT 10

-- without index
EXPLAIN SELECT * FROM t_big 
ORDER BY name 
LIMIT 10

-- Using multiple indexes on a single query
EXPLAIN SELECT * FROM t_big
WHERE id = 20 OR id =40

-- Execution plans depends on input values
CREATE INDEX idx_t_big_name ON t_big (name)

EXPLAIN SELECT * FROM t_big WHERE name = 'Meet'
LIMIT 10    -- seq scan

EXPLAIN SELECT * FROM t_big WHERE name = 'Meet' OR name = 'Jay'
LIMIT 10     -- seq scan

EXPLAIN SELECT * FROM t_big WHERE name = 'Meet'
LIMIT 10     

EXPLAIN SELECT * FROM t_big WHERE name = 'Meet' OR name = 'Jay'
LIMIT 10 


-- Using organized vs random data
SELECT * FROM t_big ORDER BY id
LIMIT 10   

EXPLAIN (ANALYZE true, buffers true, timing true)
SELECT * FROM t_big WHERE id < 10000


-- shuffle data
CREATE TABLE t_big_random AS 
SELECT * FROM t_big ORDER BY random()

CREATE INDEX idx_t_big_random_id ON t_big_random(id)

SELECT * FROM t_big_random limit 10

-- statistics about table
VACUUM ANALYZE t_big_random
EXPLAIN (ANALYZE true, buffers true, timing true)
SELECT * FROM t_big_random WHERE id < 10000


SELECT 
	tablename,
	attname,
	correlation	
FROM pg_stats
WHERE tablename IN ('t_big_random', 't_big')
ORDER BY 1, 2

-- Try to use index only scan
EXPLAIN ANALYZE SELECT * FROM t_big WHERE id = 54321


EXPLAIN ANALYZE SELECT id FROM t_big WHERE id = 54321


-- Partial indexes: improve performance of query while reducing index size

SELECT pg_size_pretty(pg_indexes_size('t_big')) 

DROP INDEX idx_t_big_name
SELECT pg_size_pretty(pg_indexes_size('t_big'))  

CREATE INDEX idx_p_t_big_name ON t_big(name)
WHERE name NOT IN ('Meet', ('Jay'))
SELECT pg_size_pretty(pg_indexes_size('t_big'));

-- Expression Index
/*
	Index based on an expression
		UPPER(columnname)
		COS(columnname),.....	
	postgre will consider to use that index when that defines the index appear in 
		WHERE clause
		ORDER BY clause 
	very expensive indexes
*/

CREATE TABLE t_dates AS
SELECT d, repeat(md5(d::TEXT), 10) AS padding
FROM generate_series (TIMESTAMP '1880-01-01', TIMESTAMP '2100-01-01', INTERVAL '1 day') s (d)

VACUUM ANALYZE t_dates

SELECT * FROM t_dates

EXPLAIN ANALYZE SELECT * FROM t_dates WHERE d BETWEEN '2001-01-01' AND '2001-01-31'

	
CREATE INDEX idx_t_dates_d ON t_dates (d);
EXPLAIN ANALYZE SELECT * FROM t_dates WHERE d BETWEEN '2001-01-01' AND '2001-01-31'


EXPLAIN ANALYZE SELECT * FROM t_dates WHERE EXTRACT (day FROM d) = 1


ANALYZE t_dates
CREATE INDEX idx_exp_t_dates ON t_dates (EXTRACT (day FROM d))
EXPLAIN ANALYZE SELECT * FROM t_dates WHERE EXTRACT (day FROM d) = 1

-- Adding data while indexing
-- CREATE INDEX CONCURRENTLY: doesnt block the access while creating index

CREATE INDEX CONCURRENTLY idx_t_big_name2 ON t_big(name)

-- index is valid or not
SELECT oid, relname, relpages, reltuples,
	i.indisunique, i.indisclustered, i.indisvalid,
	pg_catalog.pg_get_indexdef(i.indexrelid, 0, true)
FROM  pg_class c JOIN pg_index i ON c.oid = i.indrelid
WHERE c.relname = 't_big'

-- Invalidating an index
-- postgre doesnt use the index

SELECT oid, relname, relpages, reltuples,
	i.indisunique, i.indisclustered, i.indisvalid,
	pg_catalog.pg_get_indexdef(i.indexrelid, 0, true)
FROM  pg_class c JOIN pg_index i ON c.oid = i.indrelid
WHERE c.relname = 'orders'

select * from orders
Explain select * from orders where ship_country = 'USA';

CREATE INDEX idx_orders_ship_country ON orders(ship_country)
Explain select * from orders where ship_country = 'USA';

-- lets disallow ou query optimizer to use our index
UPDATE pg_index
SET indisvalid = false	
WHERE indexrelid = (
	SELECT oid FROM pg_class
	WHERE relkind = 'i'
	AND relname = 'idx_orders_ship_country'
)
Explain select * from orders where ship_country = 'USA';

-- Rebuilding an index
REINDEX [(VERBOSE)] { INDEX | TABLE | SCHEMA | DATABASE | SYSTEM} [CONCURRENTLY] name
--VERBOSE provides info of reindex

REINDEX (VERBOSE) INDEX idx_orders_customer_id_order_id

REINDEX (VERBOSE) TABLE orders

BEGIN
	REINDEX INDEX
	REINDEX TABLE
END

