


/* WINDOW FUNCTIONS -1 */


-- Window Functions (WF) vs. GROUP BY



-- Let's review following two query for differences between group by and wf




--Write a query that returns the total stock amount of each product in the stock table.


--Group by
SELECT	product_id, sum(quantity) total_stock
FROM	product.stock
GROUP BY product_id
ORDER BY product_id
;



--WF

SELECT	*, SUM(quantity) OVER(PARTITION BY product_id) total_stock
FROM	product.stock
ORDER BY product_id
;



-- Write a query that returns average product prices of brands. 


SELECT	brand_id, avg(list_price) avg_price
FROM	product.product
GROUP BY brand_id
ORDER BY brand_id
;

SELECT	brand_id, avg(list_price) over(partition by brand_id) avg_price
FROM	product.product
ORDER BY brand_id
;






---///////////////



-- 1. ANALYTIC AGGREGATE FUNCTIONS --


--MIN() - MAX() - AVG() - SUM() - COUNT()





-- Solutions





--///

-- What is the cheapest product price for each category?


SELECT	DISTINCT 
		category_id,
		MIN(list_price) OVER(PARTITION BY category_id) cheapest_by_cat
FROM	product.product
ORDER BY category_id
;

--///


-- How many different product in the product table?


SELECT	 DISTINCT
		COUNT(product_id) OVER() num_of_product
FROM	product.product


---////

-- How many different product in the order_item table?

--that is not the true result
SELECT	DISTINCT 
		COUNT(product_id) OVER() num_of_product
FROM	sale.order_item



SELECT	 
		COUNT(DISTINCT product_id)
FROM	sale.order_item

--or

SELECT	DISTINCT 
		COUNT(A.product_id) OVER() num_of_product
FROM
		(
		SELECT DISTINCT product_id
		FROM	sale.order_item
		) A
;





----/////
-- Write a query that returns how many products are in each order?




SELECT	distinct order_id, sum (quantity) OVER(PARTITION BY order_id) cnt_product
FROM	sale.order_item 




--////

-- How many different product are in each brand in each category?


SELECT	DISTINCT 
		category_id, brand_id,
		COUNT(product_id) OVER(PARTITION BY category_id, brand_id) num_of_prod
FROM	product.product
ORDER BY category_id, brand_id
;





SELECT	 
		category_id, brand_id,
		COUNT(product_id) OVER(PARTITION BY category_id, brand_id) num_of_prod
FROM	product.product
ORDER BY category_id, brand_id


--//

--Question:

--Can we calculate how many different brands are in each category in this query with WF?

--No.We cannot. We need to use subquery, CTE, etc.






SELECT DISTINCT category_id, count (brand_id) over (partition by category_id)
FROM
(
SELECT	DISTINCT category_id, brand_id
FROM	product.product
) A
ORDER BY category_id



--or

SELECT	category_id, count (DISTINCT brand_id)
FROM	product.product
GROUP BY category_id



--------------------/////////////////////////////-------------------




-- Window Frames


SELECT	*, SUM(list_price) over(partition by order_id)
FROM	sale.order_item



SELECT	*, SUM(list_price) over(partition by order_id order by item_id)
FROM	sale.order_item



SELECT	*, SUM(list_price) over(partition by order_id order by item_id rows between unbounded preceding and current row)
FROM	sale.order_item


SELECT	*, SUM(list_price) over(partition by order_id order by item_id rows between current row and unbounded following)
FROM	sale.order_item






------------------//////////////////////////////--------------------


-- 2. ANALYTIC NAVIGATION FUNCTIONS --


--FIRST_VALUE() - 

--Write a query that returns one of the most stocked product in each store.


--CAUTION! There are more than one product has same quantity in each store.

SELECT	DISTINCT store_id, FIRST_VALUE(product_id) OVER (PARTITION BY store_id order by quantity desc) most_stocked_prod
FROM	product.stock



-----////


--Write a query that returns customers and their most valuable order with total amount of it.

WITH T1 AS
(
SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
)
SELECT	DISTINCT customer_id, 
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY net_price DESC) mv_order,
		FIRST_VALUE(net_price) OVER (PARTITION BY customer_id ORDER BY net_price DESC) mvorder_net_price
FROM	T1






---Write a query that returns first order date by month



SELECT	DISTINCT YEAR(order_date) [Year], MONTH(order_date) [Month],
		FIRST_VALUE(order_date) OVER(PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date ASC) first_order_date
FROM	sale.orders




--LAST VALUE

--Write a query that returns most stocked product in each store. (Use Last_Value)

--CAUTION! There are more than one product has same quantity in each store.

SELECT	DISTINCT store_id, 
		LAST_VALUE(product_id) OVER (PARTITION BY store_id order by quantity ASC, product_id DESC range BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock





-----------------///////////////////-----------------





--LAG() - LEAD()


--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)



SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date, 
		LAG(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_id) previous_order_date
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
;




--Write a query that returns the order date of the one next sale of each staff (use the LEAD function)


SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date, 
		LEAD(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_id) next_order_date
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
;




------------///////////////

--Write a query that returns the difference order count between the current month and the next month for eachh year. 


WITH T1 AS 
(
SELECT	DISTINCT year(order_date) ord_year, month(order_date) ord_month, 
		COUNT (order_id) OVER (PARTITION BY year(order_date), month(order_date)) cnt_order
FROM	sale.orders
) 
SELECT	ord_year, ord_month, cnt_order,
		LEAD(ord_month) OVER (PARTITION BY ord_year ORDER BY ord_year, ord_month) next_month, 
		LEAD(cnt_order) OVER (PARTITION BY ord_year ORDER BY ord_year, ord_month) next_month_order_cnt,
		cnt_order-LEAD(cnt_order) OVER (PARTITION BY ord_year ORDER BY ord_year, ord_month) monthly_difference
FROM	T1









