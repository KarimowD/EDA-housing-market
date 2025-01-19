


/* WINDOW FUNCTIONS */



-- 3. ANALYTIC NUMBERING FUNCTIONS --

	
--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()




----------------/////////////////////////---------------------


--Write a query that returns how many days are between the third and fourth order dates of each staff.

WITH T1 AS
(
SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date, 
		LAG(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_date, order_id) previous_order_date,
		ROW_NUMBER() OVER (PARTITION BY B.staff_id ORDER BY order_id) ord_number
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
) 
SELECT *, DATEDIFF ( DAY, previous_order_date, order_date ) day_diff
FROM	T1
WHERE ord_number = 4












--Assign an ordinal number to the product prices for each category in ascending order


SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num
FROM	product.product
;


---/////


-- Lets try previous query again using RANK() function.






SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num,
		RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_num
FROM	product.product
;


----//////



-- Lets try previous query again using DENSE_RANK() function.


SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num,
		RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_num,
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) Dence_rank_num
FROM	product.product
;





----------------/////////////////////////---------------------


--Write a query that returns how many days are between the third and fourth order dates of each staff.

WITH T1 AS
(
SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date, 
		LAG(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_date, order_id) previous_order_date,
		ROW_NUMBER() OVER (PARTITION BY B.staff_id ORDER BY order_id) ord_number
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
) 
SELECT *, DATEDIFF ( DAY, previous_order_date, order_date ) day_diff
FROM	T1
WHERE ord_number = 4




--/////


-- Write a query that returns the cumulative distribution of the list price in product table by brand.




SELECT	brand_id, list_price, 
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST
FROM	product.product

;



---//////////////////


--Write a query that returns the relative standing of the list price in product table by brand.

SELECT	brand_id, list_price, 
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS percent_rank
FROM	product.product

;



----//////////



-----------///////////////


--Write a query that returns both of the followings:
--Average product price.
--The average product price of orders.


SELECT	DISTINCT 
		order_id, 
		AVG(list_price) OVER () Avg_price,
		AVG(list_price) OVER (PARTITION BY order_id) Avg_price_by_orders		
FROM	SALE.order_item



----///////////////


--Which orders' average product price is lower than the overall average price?

WITH T1 AS
(
SELECT	DISTINCT 
		order_id, 
		AVG(list_price) OVER () Avg_price,
		AVG(list_price) OVER (PARTITION BY order_id) Avg_price_by_orders		
FROM	SALE.order_item

) 
SELECT * 
FROM	T1
WHERE	Avg_price > Avg_price_by_orders
ORDER BY 3 Desc



--------///////

--Calculate the stores' weekly cumulative count of orders for 2018



SELECT	DISTINCT B.store_id, B.store_name, Datepart(WK, A.order_date) week_of_year, 
		COUNT(*) OVER (PARTITION BY A.store_id, Datepart(WK, A.order_date)) weeks_order,
		COUNT(*) OVER (PARTITION BY A.store_id ORDER BY Datepart(WK, A.order_date)) cume_total_order
FROM	sale.orders A, sale.store B
WHERE	A.store_id = B.store_id
AND		YEAR(A.order_date)  = 2018
ORDER BY b.store_id, WEEK_OF_YEAR


-----/////


--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.


create table calendar
(
CalendarDate date
);

declare @tar1 date
declare @tar2 date

set @tar1 = '2016-01-01'
set @tar2 = '2022-01-01'

while @tar1 <= @tar2
begin
		INSERT calendar VALUES (@tar1)
		set @tar1 = DATEADD(day, 1, @tar1)
end



WITH T1 AS 
(
SELECT	DISTINCT c.calendardate AS Order_date, ISNULL(SUM(quantity) OVER (PARTITION BY order_date), 0) sum_quantity
FROM	sale.order_item A
		RIGHT JOIN 
		sale.orders B
ON		A.order_id = B.order_id
		RIGHT JOIN
		Calendar c
ON		B.order_date = c.CalendarDate
WHERE		C.calendardate BETWEEN '2018-03-12' AND '2018-04-12'
)
SELECT	order_date,  sum_quantity,
		AVG(sum_quantity) OVER (ORDER BY order_date ROWS BETWEEN 3 PRECEDING AND 3 Following) sales_moving_average_7
FROM	T1 


--Write a query that returns the highest daily turnover amount for each week on a yearly basis.



WITH T1 AS
(
SELECT distinct order_date, SUM(quantity*list_price) over (partition by order_date)as turnover, 
year (order_date) ord_year, datepart(ISOWW , order_date) ord_week
from sale.orders a, sale.order_item b
where a.order_id=b.order_id

) 
SELECT DISTINCT  ord_year, ord_week,
FIRST_VALUE(turnover) OVER (PARTITION BY ord_year, ord_week ORDER BY turnover DESC) highest_turnover
FROM T1









--List customers whose have at least 2 consecutive orders are not shipped.


WITH T1 AS 
(
SELECT customer_id, order_id, 
CASE WHEN DATEDIFF(DAY, order_date, shipped_date) IS NULL THEN 'notdelivered' ELSE 'delivered' END isdelivered
FROM sale.orders
), T2 AS
(
SELECT customer_id, order_id, isdelivered,
LEAD(isdelivered) OVER (PARTITION BY customer_id ORDER BY order_id) next_order_delivery
FROM T1
)
SELECT customer_id
FROM T2 
WHERE isdelivered = 'notdelivered' and next_order_delivery = 'notdelivered'








