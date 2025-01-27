-- Northwind database

-- 1. Orders shipping to USA or France

SELECT * 
FROM orders
WHERE ship_country IN ('France', 'USA');

-- 2. Count total numbers of orders shipping to USA or France

SELECT 
	ship_country,
	COUNT(*)
FROM orders
WHERE ship_country IN ('France', 'USA')
GROUP BY ship_country;

-- 3. Order shipping to any countries within latin america.

SELECT *
FROM orders
WHERE
	ship_country IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela')
ORDER BY ship_country;

-- 4. Show order total amount per each order line

SELECT
	order_id,
	(unit_price * quantity) - discount AS total_amount
FROM order_details
ORDER BY 2 DESC;

-- 5. Find the first and the latest order dates

SELECT 
	MIN(order_date),
	MAX(order_date)
FROM orders;

-- 6. total products in each categories
SELECT * FROM categories

SELECT
	category_id,
	category_name,
	COUNT(*)
FROM products
INNER JOIN categories
	USING (category_id)
GROUP BY category_id, category_name
ORDER BY 1;

-- 7. List products that needs re-ordering

SELECT 
	product_name,
	units_in_stock,
	reorder_level
FROM products
WHERE units_in_stock <= reorder_level
ORDER BY reorder_level;

-- 8. List top 5 highest freight charges

SELECT *
FROM orders
ORDER BY 1 DESC
LIMIT 5;

-- 9. List top 5 countries with highest freight charges

SELECT 
	ship_country,
	AVG(freight)
FROM orders
GROUP BY ship_country
ORDER BY 2 DESC
LIMIT 5;

-- 10. List top 5 highest freight charges in year 1997

SELECT 
	ship_country,
	AVG(freight)
FROM orders
WHERE order_date BETWEEN ('1997-01-01') AND ('1997-12-31')
GROUP BY ship_country
ORDER BY 2 DESC
LIMIT 5;

-- 11. List top 5 highest freight charges last year

SELECT
	freight
FROM orders
WHERE 
	EXTRACT('Y' FROM order_date) >= EXTRACT('Y' FROM (SELECT MAX(order_date) FROM orders))
ORDER BY freight DESC
LIMIT 5;

-- customers with no orders

select * from customers

select * from orders

SELECT
	customer_id,
	order_id
FROM customers
LEFT JOIN orders
	USING (customer_id)
WHERE order_id IS NULL;

-- Top Customers with their total order amount spend
select * from order_details

SELECT
	customer_id,
	SUM(unit_price * quantity - discount)
FROM orders
INNER JOIN customers
	USING (customer_id)
INNER JOIN order_details
	USING (order_id)
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Orders with many line of items

SELECT
	order_id,
	COUNT(*)
FROM order_details
GROUP BY order_id
ORDER BY 2 DESC;

-- SELECT 
-- 	customer_id,
-- 	COUNT(*)
-- FROM order_details
-- JOIN orders
-- 	USING (order_id)
-- JOIN products
-- 	USING (product_id)
-- GROUP BY customer_id
-- ORDER BY 2 DESC

-- orders with double entry line items

SELECT
	order_id,
	quantity
FROM order_details
WHERE 
	quantity > 60
GROUP BY
	order_id,
	quantity
HAVING 
	COUNT(*) > 1
ORDER BY 
	order_id;

-- lets get the details of the items too

WITH duplicate_entries AS
(
	-- logic
	SELECT
		order_id,
		quantity
	FROM order_details
	WHERE 
		quantity > 60
	GROUP BY
		order_id,
		quantity
	HAVING 
		COUNT(*) > 1
	ORDER BY 
		order_id
)
SELECT *
FROM order_details
WHERE 
	order_id IN (SELECT order_id FROM duplicate_entries);


-- List all late shipped orders

WITH late_orders AS
(
	SELECT
		employee_id,
		COUNT(*) AS late_order
	FROM orders
	WHERE shipped_date > required_date
	GROUP BY 
		employee_id
),
all_orders AS 
(
	SELECT
		employee_id,
		COUNT(*) AS total_order
	FROM orders
	GROUP BY
		employee_id
)
SELECT
	employees.employee_id,
	employees.first_name,
	all_orders.total_order,
	late_orders.late_order
FROM employees
JOIN all_orders ON all_orders.employee_id = employees.employee_id
JOIN late_orders ON late_orders.employee_id = employees.employee_id;


SELECT
	employee_id,
	first_name,
	last_name,
	COUNT(*)
FROM orders
JOIN employees
	USING (employee_id)
WHERE shipped_date > required_date
GROUP BY employee_id, first_name, last_name
ORDER BY 4 DESC;
	
-- Countries with customers or suppliers

SELECT
	country
FROM customers
UNION
SELECT
	country
FROM suppliers

-- countries with customers or suppliers v2
-- Using CTE

WITH c_sup AS
(
	SELECT DISTINCT country FROM suppliers
),
c_cus AS
(
	SELECT DISTINCT country FROM customers
)
SELECT 
	c_sup.country AS country_sup,
	c_cus.country AS country_cus
FROM c_sup
FULL JOIN c_cus
	ON c_sup.country = c_cus.country;

-- customers with multiple orders
-- say	 within 4 days period

WITH next_order_date AS
(
	SELECT 
		customer_id,
		order_date,
		LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY customer_id, order_date) AS next_order_date
	FROM orders
)
SELECT
	customer_id,
	order_date,
	next_order_date,
	(next_order_date - order_date) AS days_between
FROM next_order_date
WHERE (next_order_date - order_date) <= 4;

-- first order from each country

WITH orders_by_country AS 
(
	SELECT
		ship_country,
		order_id,
		order_date,
		ROW_NUMBER() OVER (PARTITION BY ship_country ORDER BY ship_country, order_date) country_row_number
	FROM orders
)
SELECT 
	ship_country,
	order_id,
	order_date
FROM orders_by_country
WHERE country_row_number = 1

	
	