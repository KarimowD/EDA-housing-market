


------ INNER JOIN ------

-- Make a list of products showing the product ID, product name, category ID, and category name.

-


SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	product.product A
INNER JOIN	product.category B
	ON	A.category_id = B.category_id
;

-- or
SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	product.product A,
		product. category B
WHERE	A.category_id = B.category_id
;


--///////


--List employees of stores with their store information.

--Select first name, last name, store name


SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id
;





----/////////////////   Out of contents

--Write a query that returns count of orders of the states by months.


--SELECT	A.state , YEAR(B.order_date) YEARS, MONTH(B.order_date) months, COUNT (DISTINCT order_id) NUM_OF_ORDERS
--FROM	sale.customer A, sale.orders B

--WHERE	A.customer_id = B.customer_id
--GROUP BY	A.state, YEAR(B.order_date), MONTH(B.order_date) 
--ORDER BY	state, YEARS, months






------ LEFT JOIN ------

--Write a query that returns products that have never been ordered
--Select product ID, product name, orderID



SELECT	DISTINCT A.product_id, A.product_name, ISNULL(STR(B.product_id), 'NO ORDERED') AS IsOrdered
FROM	product.product AS A
		LEFT JOIN
		sale.order_item AS B
		ON	A.product_id = B.product_id
WHERE	B.product_id IS NULL



------////////

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: product_id, product_name, store_id, product_id, quantity



SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;



------ RIGHT JOIN ------

--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.

--Expected columns: product_id, product_name, store_id, quantity


SELECT	B.product_id, B.product_name, A.*
FROM	product.stock A
RIGHT JOIN product.product B ON	A.product_id = B.product_id
WHERE	B.product_id > 310
;


--//////

---Report the order information made by all staffs.

--Expected columns: staff_id, first_name, last_name, all the information about orders


--How many distinct staff in staff table?

select COUNT (DISTINCT staff_id)
FROM	sale.staff 


--staff number with inner join

SELECT	COUNT (DISTINCT A.staff_id)
FROM	sale.staff A
INNER JOIN sale.orders B ON	A.staff_id = B.staff_id



SELECT	A.staff_id, A.first_name, A.last_name, B.*
FROM	sale.staff A
INNER JOIN sale.orders B ON	A.staff_id = B.staff_id



--solution / result

SELECT	A.staff_id, A.first_name, A.last_name, B.*
FROM	sale.staff A
LEFT JOIN sale.orders B ON	A.staff_id = B.staff_id
ORDER BY B.Order_id
;

--staff number with left join


SELECT	COUNT (DISTINCT A.staff_id) , COUNT (DISTINCT B.staff_id)
FROM	sale.staff A
LEFT JOIN sale.orders B ON	A.staff_id = B.staff_id
;



------ FULL OUTER JOIN ------

--Write a query that returns stock and order information together for all products . Return only top 100 rows.

--Expected columns: Product_id, store_id, quantity, order_id, list_price

--It's important to fetch all the product_id's in both tables.


SELECT TOP 20 A.Product_id, A.store_id, A.quantity, B.product_id, B.order_id, B.list_price
FROM	product.stock A
FULL OUTER JOIN	sale.order_item B ON A.product_id = B.product_id
ORDER BY A.product_id, B.order_id
;



SELECT TOP 100 A.Product_id, B.store_id, B.quantity, C.order_id, C.list_price
FROM	
product.product A
FULL OUTER JOIN 
product.stock B  ON A.product_id = B.product_id
FULL OUTER JOIN	sale.order_item C ON A.product_id = C.product_id
ORDER BY B.store_id 
;


------ CROSS JOIN ------

/*
In the stocks table, there are not all products held on the product table and you want to insert these products into the stock table.

You have to insert all these products for every three stores with “0 (zero)” quantity.

Write a query to prepare this data.*/



SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id





------ SELF JOIN ------

--Write a query that returns the staff names with their manager names.
--Expected columns: staff first name, staff last name, manager name



SELECT	A.first_name AS staff_name, B.first_name AS manager_name
FROM	sale.staff A 
		LEFT JOIN
		sale.staff B
		ON
		A.manager_id = B.staff_id
;


--//////

--Write a query that returns both the names of staff and the names of their 1st and 2nd managers



SELECT	A.first_name staff_name,
		B.first_name manager1_name,
		C.first_name manager2_name
FROM	sale.staff A
LEFT JOIN	sale.staff B
	ON	A.manager_id = B.staff_id
LEFT JOIN	sale.staff C
	ON	B.manager_id = C.staff_id
ORDER BY C.first_name, B.first_name
;




---Views



CREATE or ALTER VIEW v_customers_and_products AS
SELECT	  DISTINCT A.customer_id, A.first_name, A.last_name, B.order_id, C.product_id, D.product_name
FROM	  sale.customer A
LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
LEFT JOIN sale.order_item C ON B.order_id = C.order_id
LEFT JOIN product.product D ON C.product_id = D.product_id





select *
from v_customers_and_products











