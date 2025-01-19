



/* ORGANIZED COMPLEX QUERIES */


----- SUBQUERIES ----


------ SINGLE ROW SUBQUERIES ------



----///////


--Write a query that shows all employees in the store where Davis Thomas works.


SELECT	*
FROM	sale.staff
WHERE	store_id = (
					SELECT	store_id
					FROM	sale.staff
					WHERE	first_name = 'Davis' AND
							last_name = 'Thomas'
					)
;



-- /////////

-- Write a query that shows the employees for whom Charles Cussona is a first-degree manager. 
--(To which employees are Charles Cussona a first-degree manager?)


SELECT	*
FROM	sale.staff
WHERE	manager_id = (
					SELECT	staff_id
					FROM	sale.staff
					WHERE	first_name = 'Charles' AND
							last_name = 'Cussona'
					)
;



-- ///////////////


-- Write a query that returns the customers located where ‘The BFLO Store' is located.


SELECT	first_name, last_name, city
FROM	sale.customer
WHERE	city = (
				SELECT	city
				FROM	sale.store
				WHERE	store_name = 'The BFLO Store'
				)
;



--//////

--Write a query that returns the list of products that are more expensive than the product named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'


SELECT	A.product_id, A.product_name, A.model_year, A.list_price
FROM	product.product A
WHERE	
		A.list_price >	(
						SELECT	list_price
						FROM	product.product
						WHERE	product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
						)
ORDER BY A.list_price DESC
;





-- ///////////

-- Write a query that returns the customer names, last names, and order dates. 
-- The customers who are order before order date of Hassan Pope.


SELECT	A.first_name, A.last_name, B.order_date
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id AND
		B.order_date < (SELECT	B.order_date
						FROM	sale.customer A, sale.orders B
						WHERE	A.first_name = 'Hassan' AND
								A.last_name = 'Pope' AND
								A.customer_id = B.customer_id
						)
;

select * from sale.customer

						
------ MULTIPLE ROW SUBQUERIES ------


--/////////////////


-- Write a query that returns customer first names, last names and order dates. 
-- The customers who are order on the same dates as Laurel Goldammer.


SELECT	A.first_name, A.last_name, B.order_date
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id AND
		B.order_date IN (SELECT	B.order_date
						FROM	sale.customer A, sale.orders B
						WHERE	A.first_name = 'Laurel' AND
								A.last_name = 'Goldammer' AND
								A.customer_id = B.customer_id
						)
ORDER BY B.order_date
;


-----/////////////



--List the products that ordered in the last 10 orders in Buffalo city.


SELECT	distinct b.product_name
FROM	sale.order_item A, product.product B
WHERE	A.product_id = B.product_id
AND		a.order_id IN (SELECT	TOP 10 B.order_id 
						FROM	sale.customer A, sale.orders B
						WHERE	city = 'Buffalo'
						AND		A.customer_id = B.customer_id
						ORDER BY B.order_id DESC
						)
;






-- //////

--Write a query that returns the product_names and list price that were made in 2021. 
--(Exclude the categories that match Game, gps, or Home Theater )


SELECT	product_name, list_price
FROM	product.product
WHERE	category_id NOT IN (SELECT	category_id
							FROM	product.category
							WHERE	category_name IN ('Game', 'gps', 'Home Theater')
							) AND
		model_year = 2021
;




---//////

--Write a query that returns the list of product names that were made in 2020 
--and whose prices are higher than maximum product list price of Receivers Amplifiers category.


SELECT	product_name, model_year, list_price
FROM	product.product
WHERE	list_price > ALL (SELECT	A.list_price
							FROM	product.product A, product.category B
							WHERE	A.category_id = B.category_id AND
								B.category_name = 'Receivers Amplifiers')
AND		model_year = 2020
ORDER BY list_price DESC
;



SELECT	product_name, list_price 
FROM	product.product
WHERE	model_year = 2020
AND		list_price > (
						SELECT	MAX(list_price)
						FROM	product.product A, product.category B
						WHERE	A.category_id = B.category_id
						AND		B.category_name = 'Receivers Amplifiers'
						)



--///////

-- Write a query that returns the list of product names that were made in 2020 
-- and whose prices are higher than minimum product list price of Receivers Amplifiers category.

SELECT	product_name, model_year, list_price
FROM	product.product
WHERE	list_price > ANY (SELECT	A.list_price
						FROM	product.product A, product.category B
						WHERE	A.category_id = B.category_id AND
								B.category_name = 'Receivers Amplifiers')
AND		model_year = 2020
ORDER BY list_price Asc
;



----------------------------//////////////////////


---------CORRELATED SUBQUERIES


---EXISTS


SELECT *
FROM	sale.customer
WHERE	EXISTS (SELECT 1)


SELECT *
FROM	sale.customer A
WHERE	EXISTS (
					SELECT	1
					FROM	sale.orders B
					WHERE	order_date > '2020-01-01'
					AND		A.customer_id = B.customer_id
					)

---------------

SELECT *
FROM	sale.customer A
WHERE	A.customer_id IN (
								SELECT	customer_id
								FROM	sale.orders B
								WHERE	order_date > '2020-01-01'
								)




----------////////////////////

-- NOT EXISTS


SELECT *
FROM	SALE.customer A
WHERE	NOT EXISTS (
					SELECT	1
					FROM	sale.orders B
					WHERE	order_date > '2020-01-01'
					AND		A.customer_id = B.customer_id
					)

-----------

SELECT *
FROM	SALE.customer A
WHERE	customer_id NOT IN (
							SELECT	customer_id
							FROM	sale.orders B
							WHERE	order_date > '2020-01-01'
							AND		A.customer_id = B.customer_id
							)




------------/////////////////



--Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White' product is not ordered

SELECT distinct state
FROM
sale.customer X
WHERE NOT EXISTS
(
SELECT	1
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
AND		D.STATE = X.STATE
) 



------

SELECT DISTINCT state
FROM sale.customer
EXCEPT
SELECT DISTINCT A.state
FROM sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE A.customer_id = B.customer_id AND B.order_id = C.order_id 
AND C.product_id = D.product_id AND D.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
ORDER BY 1






----///////////////////////////


--Write a query that returns stock information of the products in Davi techno Retail store. 
--The BFLO Store hasn't  got any stock of that products.



SELECT	A.store_name, b.*
FROM	sale.store A, product.stock B
WHERE	A.store_id = B.store_id
AND		A.store_name = 'Davi techno Retail'
AND not EXISTS (
			SELECT * 
			FROM	sale.store C, product.stock D
			WHERE	C.store_id = D.store_id
			AND		D.quantity > 0
			AND		C.store_name = 'The BFLO Store'
			AND		B.product_id = D.product_id
			)





--Subquery in SELECT Statement

--Write a query that creates a new column named "total_price" calculating the total prices of the products on each order.


Select	DISTINCT order_id,
		(SELECT SUM(list_price) FROM sale.order_item A WHERE A.order_id = B.order_id) total_price
FROM	SALE.order_item B






----------////////////////////------------

------ CTE's ------

--ORDINARY CTE's

-- Query Time


--List customers who have an order prior to the last order date of a customer named Jerald Berray and are residents of the city of Austin. 



WITH t1 AS
	(
	SELECT	MAX(B.order_date) last_order_date
	FROM	sale.customer A, sale.orders B
	WHERE	A.first_name = 'Jerald' AND
			A.last_name = 'Berray' AND
			A.customer_id = B.customer_id
	)
SELECT	B.customer_id, B.first_name, B.last_name, B.city, C.order_date
FROM	t1 A, sale.customer B, sale.orders C
WHERE	B.customer_id = C.customer_id 
AND		C.order_date < A.last_order_date
AND		B.city = 'Austin'
;






---///////////


-- List all customers their orders are on the same dates with Laurel Goldammer.


WITH T1 AS 
(
SELECT	B.order_date
FROM	sale.customer A, sale.orders B
WHERE	A.first_name = 'Laurel' AND
		A.last_name = 'Goldammer' AND
		A.customer_id = B.customer_id
)
SELECT	A.first_name, A.last_name, B.order_date
FROM	sale.customer A, sale.orders B, T1 C
WHERE	A.customer_id = B.customer_id AND
		B.order_date = C.order_date
ORDER BY B.order_date
;


-- //////

--List products their model year are 2021 and their categories other than Game, gps, or Home Theater.


WITH T1 AS 
(
SELECT	category_id
FROM	product.category
WHERE	category_name NOT IN ('Game', 'gps', 'Home Theater')
)
SELECT	product_name, list_price
FROM	product.product A, T1 B
WHERE	A.category_id = B.category_id AND
		A.model_year = 2021
;


-----////////////////////-------


--RECURSIVE CTE's 


-- Create a table with a number in each row in ascending order from 0 to 9.

WITH t1 AS (
					SELECT	0 rakam
						UNION ALL
					SELECT	rakam+1
					FROM	t1
					WHERE	rakam < 9)
SELECT * FROM t1
;



----------///////////////


--Write a query that returns all staff with their manager_ids. (Use Recursive CTE)

WITH T1 AS (
    SELECT staff_id, first_name, manager_id
    FROM   sale.staff
    WHERE  staff_id=1
    UNION ALL
    SELECT B.staff_id, B.first_name, B.manager_id
    FROM   T1 A, sale.staff B 
	WHERE  A.staff_id = B.manager_id
)
SELECT * FROM T1;

------//////////////////


--List the stores whose turnovers are under the average store turnovers in 2018.


WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
), T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;



-----------/////////////


-- Write a query that returns the net amount of their first order for customers who placed their first order after 2019-10-01.


WITH T1 AS
(
	SELECT	customer_id, MIN(order_date) first_order_date, MIN(order_id) first_order
	FROM	sale.orders
	GROUP BY
			customer_id
	HAVING
			MIN(order_date) > '2019-10-01'
) 
SELECT	T1.customer_id, B.first_name, B.last_name, A.order_id, SUM(quantity*list_price*(1-discount)) net_amount
FROM	T1, sale.order_item A, sale.customer B
WHERE	T1.first_order = A.order_id
AND		T1.customer_id = B.customer_id
GROUP BY
		T1.customer_id, B.first_name, B.last_name, A.order_id
ORDER BY 
		1



