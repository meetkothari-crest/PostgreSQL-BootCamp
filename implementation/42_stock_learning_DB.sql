-- How to select first and last 10 records in a table

SELECT
	*
FROM stocks_prices
WHERE 
	symbol_id = 1
ORDER BY 
	price_date ASC
LIMIT 10;


SELECT
	*
FROM stocks_prices
WHERE 
	symbol_id = 1
ORDER BY 
	price_date DESC
LIMIT 10;

-- get first and last record per each group

SELECT
	symbol_id,
	MIN(price_date)
FROM
	stocks_prices
GROUP BY 
	symbol_id
ORDER BY symbol_id;


SELECT
	symbol_id,
	MAX(price_date)
FROM
	stocks_prices
GROUP BY 
	symbol_id
ORDER BY symbol_id;

-- cube root in postgreSQL
-- CBRT() - cube root
SELECT CBRT(27);

