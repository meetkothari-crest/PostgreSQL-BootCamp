-- Create a table called 'songs'

CREATE TABLE test_schema.public.songs (
	song_id SERIAL PRIMARY KEY,
	song_title VARCHAR(100)
);

INSERT INTO test_schema.public.songs (song_title) VALUES
('Counting Star'),
('Rolling On');

SELECT * FROM songs;

-- now, duplicate public schema with all data
-- the first step is to make dump of our postgreSQL database 'public' schema using pg_dump
-- pg_dump -d database_name -h localhost -U postgres -n public > dump.sql
 
pg_dump -d test_schema -h localhost -U postgres -n public > dump.sql;

-- Import back the dump'ed file
-- psql -h localhost -U postgres -d db_name -f dump.sql
psql -h localhost -U postgres -d test_schema -f dump.sql;
