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

-- 10. List top 5 highest freight charges last year

SELECT
	freight
FROM orders
WHERE 
	EXTRACT('Y' FROM order_date) >= EXTRACT('Y' FROM (SELECT MAX(order_date) FROM orders))
ORDER BY freight DESC
LIMIT 5;