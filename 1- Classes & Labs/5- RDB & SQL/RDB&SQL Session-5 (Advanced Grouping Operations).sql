

--GROUPING OPERATIONS



--HAVING


--Write a query that checks if any product id is duplicated in product table.




SELECT	product_id, COUNT (product_id) num_of_rows
FROM	product.product
GROUP BY
		product_id
HAVING COUNT (product_id) > 1


--///////

--Write a query that returns category ids with conditions max list price above 4000 or a min list price below 500.




SELECT     category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM       product.product
GROUP BY   category_id
HAVING     MAX(list_price) > 4000 OR MIN(list_price) < 500 ;




---/////

--Find the average product prices of the brands. Display brand name and average prices in descending order.



SELECT	B.brand_name, AVG(list_price) avg_list_price
FROM	product.product A, product.brand B
WHERE	A.brand_id=B.brand_id
GROUP BY
		B.brand_name
ORDER BY avg_list_price DESC



--////


--Write a query that returns the list of brands whose average product prices are more than 1000




SELECT     brand_name, AVG(list_price) avg_list_price
FROM       product.product A, product.brand B
WHERE	   A.brand_id = B.brand_id
GROUP BY   brand_name
HAVING     AVG(list_price) > 1000
ORDER BY   AVG(list_price) ASC;



--////////

--Write a query that returns the list of each order id and that order's total net price 
--(please take into consideration of discounts and quantities)





SELECT	order_id , quantity * list_price * (1-discount) net_price
FROM	sale.order_item

--solution/result

SELECT	order_id, SUM (quantity * list_price * (1-discount)) net_price
FROM	sale.order_item
GROUP BY
		order_id
ORDER BY
		order_id




------------------/////////////////


--Write a query that returns monthly order counts of the States.


SELECT	A.state , YEAR(B.order_date) YEARS, MONTH(B.order_date) months, COUNT (DISTINCT order_id) NUM_OF_ORDERS
FROM	sale.customer A, sale.orders B

WHERE	A.customer_id = B.customer_id
GROUP BY	A.state, YEAR(B.order_date), MONTH(B.order_date) 
ORDER BY	state, YEARS, months




--///////////////////////////

--Just now, we're gonna create a summary table for following topics 

--Summary Table



--we are going to use SELECT * INTO .... FROM ... instruction

--SYNTAX

SELECT * 
INTO	NEW_TABLE
FROM	SOURCE_TABLE
WHERE ...


--Anyway, we create summary table


SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year




SELECT *
FROM	sale.sales_summary
ORDER BY	1,2,3


-----///////////////////////------

--GRUPING SETS

--1. Calculate the total sales price.


SELECT SUM(total_sales_price) 
FROM	sale.sales_summary



--2. Calculate the total sales price of the brands



SELECT	Brand, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		brand



--3. Calculate the total sales price of the categories


SELECT	category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		category



--4. Calculate the total sales price by brands and categories.



SELECT	brand, category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		brand,category




--Perform the above four variations in a single query using 'Grouping Sets'.


--brand, Category, brand + category, total


SELECT	brand, category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
	GROUPING SETS (
					(brand, category),
					(brand),
					(category),
					()
					)
ORDER BY
	brand, category



---------////////////////////////----------




---------- ROLLUP ---------

--Generate different grouping variations that can be produced with the brand and category columns using 'ROLLUP'.
-- Calculate sum total_sales_price



SELECT	brand, category, model_year, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		ROLLUP (brand,category, model_year)
ORDER BY
	model_year, category



	-------////////////////////////----------

------------ CUBE ------------


--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
-- Calculate sum total_sales_price


SELECT	brand, category, model_year, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		CUBE (brand,category, model_year)
ORDER BY
	brand, category, 


---

-----/////////////--------


--------- PIVOT ----------

--Generate a query that you use its result as basic table for PIVOT.


-- that is what:

--Question: Write a query using summary table that returns the total turnover from each category by model year. (in pivot table format)



SELECT category, model_year, SUM(total_sales_price)
FROM sale.sales_summary
GROUP BY category, Model_Year


--Now, you create a pivot table using above query result.



SELECT *
FROM
(
SELECT	category, Model_Year, total_sales_price
FROM	SALE.sales_summary
) AS A
PIVOT 
(
SUM(total_sales_price)
FOR Model_Year
IN ([2018], [2019], [2020], [2021])
) AS PVT







	
--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.




SELECT *
FROM
			(
			SELECT order_id, DATENAME(DW, order_date) day_of_week
			FROM sale.orders
			WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
			) A
PIVOT
(
	COUNT(order_id)
	FOR day_of_week IN
	(
	[Monday], 
    [Tuesday], 
    [Wednesday], 
    [Thursday], 
    [Friday], 
    [Saturday], 
    [Sunday])
	) AS PIVOT_TABLE
	




