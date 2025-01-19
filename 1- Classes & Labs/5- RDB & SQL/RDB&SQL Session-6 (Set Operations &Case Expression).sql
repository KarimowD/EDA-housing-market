



/* SET OPERATIONS - CASE EXPRESSION */



---Advanced Grouping Op. Pop-up Quizzz



--Create a report shows monthwise turnovers of the BFLO Store.




SELECT *
FROM
		(
		SELECT	YEAR (order_date) ORD_YEAR, 
				DATENAME(MM, order_date) ORD_MONTH, 
				quantity*list_price total_turnover
		FROM	sale.store A, sale.orders B, sale.order_item C
		WHERE	A.store_name = 'The BFLO Store'
		AND		A.store_id = B.store_id
		AND		B.order_id = C.order_id
		) A
PIVOT
(
SUM(total_turnover)
FOR ORD_YEAR
IN	([2018], [2019],[2020])
) PIVOT_TABLE



-------Or


CREATE VIEW V2 AS
SELECT	YEAR (order_date) ORD_YEAR, 
		DATENAME(MM, order_date) ORD_MONTH, 
		quantity*list_price total_turnover
FROM	sale.store A, sale.orders B, sale.order_item C
WHERE	A.store_name = 'The BFLO Store'
AND		A.store_id = B.store_id
AND		B.order_id = C.order_id



SELECT *
FROM V2
PIVOT
(
SUM(total_turnover)
FOR ORD_YEAR
IN	([2018], [2019],[2020])
) PIVOT_TABLE




----//////////

--Create a report shows daywise turnovers of the BFLO Store.


SELECT * 
FROM
(
SELECT Datename(DW , order_date) order_day, datepart(WK, B.order_date) order_week, list_price
FROM sale.store A, sale.orders B, sale.order_item C
WHERE A.store_name = 'The BFLO Store'
AND A.store_id=B.store_id
AND	B.order_id = C.order_id
) A
PIVOT
(
SUM(list_price)
FOR order_day
IN ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
) as piv
order by order_week





------ SET OPERATIONS ------

-- UNION / UNION ALL

--List the products sold in the cities of Charlotte and Aurora


SELECT	D.product_name
FROM	sale.customer A, sale.order_item B, sale.orders C, product.product D
WHERE	A.customer_id = C.customer_id
AND		C.order_id = B.order_id
AND		B.product_id = D.product_id
AND		city = 'Charlotte'
UNION ALL
SELECT	D.product_name
FROM	sale.customer A, sale.order_item B, sale.orders C, product.product D
WHERE	A.customer_id = C.customer_id
AND		C.order_id = B.order_id
AND		B.product_id = D.product_id
AND	city = 'Aurora'
;




SELECT	D.product_name
FROM	sale.customer A, sale.order_item B, sale.orders C, product.product D
WHERE	A.customer_id = C.customer_id
AND		C.order_id = B.order_id
AND		B.product_id = D.product_id
AND		city = 'Charlotte'
UNION
SELECT	D.product_name
FROM	sale.customer A, sale.order_item B, sale.orders C, product.product D
WHERE	A.customer_id = C.customer_id
AND		C.order_id = B.order_id
AND		B.product_id = D.product_id
AND	city = 'Aurora'
;


-- UNION ALL / UNION vs. IN 

SELECT	D.product_name
FROM	sale.customer A, sale.order_item B, sale.orders C, product.product D
WHERE	A.customer_id = C.customer_id
AND		C.order_id = B.order_id
AND		B.product_id = D.product_id
AND	city IN ('Charlotte', 'Aurora')
;



--SOME IMPORTANT RULES OF UNION / UNION ALL

--Even if the contents of to be unified columns are different, the data type must be the same.




SELECT	*
FROM	product.brand
UNION
SELECT	*
FROM	product.category


----------

SELECT	city, 'STATE' AS STATE
FROM	sale.store

UNION ALL

SELECT	state, 1 as city
FROM	sale.store


--The number of columns to be unified must be the same in both queries.



SELECT	city, 'Clean' AS street
FROM	sale.store

UNION ALL

SELECT	city
FROM	sale.store;






-----////////////


--Write a query that returns all customers whose  first or last name is Thomas.  (don't use 'OR')



SELECT	first_name, last_name
FROM	sale.customer
WHERE	first_name = 'Thomas'
UNION ALL
SELECT	first_name, last_name
FROM	sale.customer
WHERE	last_name = 'Thomas'
;


select *
from
(
SELECT	first_name, last_name
FROM	sale.customer
) a,
(
SELECT	first_name, last_name
FROM	sale.customer
) b
where a.first_name=b.last_name


---------- INTERSECT

--Write a query that returns all brands with products for both 2018 and 2020 model year.



SELECT  A.brand_id, B.brand_name --,model_year
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		model_year = 2018

INTERSECT

SELECT  A.brand_id, B.brand_name --,model_year
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		model_year = 2020



---//////////////


-- Write a query that returns the first and the last names of the customers who placed orders in all of 2018, 2019, and 2020.

--622
SELECT	A.customer_id, first_name, last_name
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		YEAR (A.order_date) = 2018

INTERSECT
--679
SELECT	A.customer_id,  first_name, last_name
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		YEAR (A.order_date) = 2019

INTERSECT

--269
SELECT	A.customer_id,  first_name, last_name
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		YEAR (A.order_date) = 2020
ORDER BY
		2




------ EXCEPT


-- Write a query that returns the brands have  2018 model products but not 2019 model products.




SELECT	DISTINCT A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	model_year = 2018
AND		A.brand_id = B.brand_id

EXCEPT

SELECT	DISTINCT A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	model_year = 2019
AND		A.brand_id = B.brand_id




----////////////////


-- Write a query that contains only products ordered in 2019 (Result not include products ordered in other years)



SELECT  B.product_id, C.product_name
FROM sale.orders A, sale.order_item B, product.product C
WHERE A.order_id = B.order_id AND B.product_id = C.product_id AND YEAR(A.order_date)=2019

EXCEPT

SELECT  B.product_id, C.product_name
FROM sale.orders A, sale.order_item B, product.product C
WHERE A.order_id = B.order_id AND B.product_id = C.product_id AND YEAR(A.order_date) <> 2019



------ CASE EXPRESSION ------

------ Simple Case Expression -----

-- Create  a new column with the meaning of the  values in the Order_Status column. 



-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT	order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END order_status_desc
FROM	sale.orders
;



---//////////


--Create a new column with the names of the stores to be consistent with the values in the store_ids column



SELECT	first_name, last_name, store_id,
		CASE store_id
			WHEN 1 THEN 'Davi techno Retail'
			WHEN 2 THEN 'The BFLO Store'
			ELSE 'Burkes Outlet'
		END Store_name
FROM	sale.staff
;




select * from sale.store

------ Searched Case Expression -----



--Create  a new column with the meaning of the  values in the Order_Status column.  (use searched case ex.)
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed






SELECT	order_id, order_status, 
		CASE
			WHEN order_status = 1 THEN 'Pending'
			WHEN order_status = 2 THEN 'Processing'
			WHEN order_status = 3 THEN 'Rejected'
			WHEN order_status = 4 THEN 'Completed'
		END Order_Status_Text
FROM	sale.orders
;



-- ////////////

-- Create a new column that shows which email service provider ("Gmail", "Hotmail", "Yahoo" or "Other" ).



SELECT	first_name, last_name, email, CASE
				WHEN email LIKE '%@gmail.%' THEN 'Gmail' 
				WHEN email LIKE '%@hotmail.%' THEN 'Hotmail'
				WHEN email LIKE '%@yahoo.%' THEN 'Yahoo'
				WHEN email IS NOT NULL THEN 'Other'
			ELSE NULL END email_service_provider
FROM	sale.customer;




--------///////



-- If you have extra time you can ask following question.

-- Write a query that gives the first and last names of customers who have ordered products from the computer accessories, speakers, and mp4 player categories in the same order.




SELECT	 A.customer_id, A.first_name, A.last_name, C.order_id,
		SUM(CASE WHEN E.category_name = 'Computer Accessories' THEN 1 ELSE 0 END) AS Comp_Accessories,
		SUM(CASE WHEN E.category_name = 'Speakers' THEN 1 ELSE 0 END) AS Speakers,
		SUM(CASE WHEN E.category_name = 'mp4 player' THEN 1 ELSE 0 END) AS mp4
FROM	SALE.customer A, SALE.orders B, SALE.order_item C, product.product D, product.category E
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id =D.product_id
AND		D.category_id = E.category_id
GROUP BY A.customer_id, A.first_name, A.last_name, C.order_id
HAVING  SUM(CASE WHEN E.category_name = 'Computer Accessories' THEN 1 ELSE 0 END) <> 0
		AND 
		SUM(CASE WHEN E.category_name = 'Speakers' THEN 1 ELSE 0 END) <> 0 
		AND 
		SUM(CASE WHEN E.category_name = 'mp4 player' THEN 1 ELSE 0 END) <> 0
ORDER BY 4;







--SELECT	first_name, last_name
--FROM
--(
--SELECT	A.customer_id, A.first_name, A.last_name, C.order_id, 
--		SUM(CASE WHEN E.category_name = 'Computer Accessories' THEN 1 ELSE 0 END) AS  C1,
--		SUM(CASE WHEN E.category_name = 'Speakers' THEN 1 ELSE 0 END) AS C2,
--		SUM(CASE WHEN E.category_name = 'mp4 player' THEN 1 ELSE 0 END) AS C3

--FROM	SALE.customer A, SALE.orders B, SALE.order_item C, product.product D, product.category E
--WHERE	A.customer_id = B.customer_id
--AND		B.order_id = C.order_id
--AND		C.product_id =D.product_id
--AND		D.category_id = E.category_id
--GROUP BY A.customer_id, A.first_name, A.last_name, C.order_id
--) A
--WHERE C1 > 0 AND C2 > 0 AND C3 > 0





		-- control

SELECT	C.*, E.category_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D, product.category E
WHERE	A.customer_id = B.customer_id AND B.order_id =C.order_id AND  A.customer_id = 571 AND C.product_id =D.product_id AND D.category_id =E.category_id


--


SELECT	A.customer_id, A.first_name, A.last_name, B.order_id
FROM	sale.customer A, sale.orders B, SALE.order_item C, product.product D, product.category E
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		D.category_id = E.category_id
AND		E.category_name = 'mp4 player'

INTERSECT

SELECT	A.customer_id, A.first_name, A.last_name, B.order_id
FROM	sale.customer A, sale.orders B, SALE.order_item C, product.product D, product.category E
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		D.category_id = E.category_id
AND		E.category_name = 'Computer Accessories'

INTERSECT

SELECT	A.customer_id, A.first_name, A.last_name, B.order_id
FROM	sale.customer A, sale.orders B, SALE.order_item C, product.product D, product.category E
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		D.category_id = E.category_id
AND		E.category_name = 'Speakers'





/*
Question: By creating a new column, label the orders according to the instructions below:

Label the products as 'Not Shipped' if they were NOT shipped.
Label the products as 'Fast' if they were shipped on the day of order.
Label the products as 'Normal' if they were shipped within two days of the order date.
Label the products as 'Slow' if they were shipped later than two days after the order date.
*/


SELECT	*,
		CASE WHEN shipped_date IS NULL THEN 'Not Shipped'
			 WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF (DAY, ORDER_DATE, SHIPPED_DATE) = 0
			 WHEN DATEDIFF (DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			 ELSE 'Slow'
		END AS ORDER_LABEL,
		DATEDIFF (DAY, ORDER_DATE, shipped_date) datedif
FROM	sale.orders
order by datedif



--Write a query that returns the count of the orders day by day in a pivot table format that has been shipped two days later.




SELECT	SUM(CASE WHEN DATENAME (DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS Monday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS Tuesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS Thursday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS Saturday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS Sunday
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2




