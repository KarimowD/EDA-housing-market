

--DAwSQL Session - Recap 

--E-Commerce Project Solution


Alter table orders_dimen alter column order_date date

Alter table shipping_dimen alter column Ship_date date

--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

SELECT *
INTO
combined_table
FROM
(
SELECT 
mf.Ord_ID, cd.Cust_ID, mf.Prod_ID, sd.Ship_ID, od.Order_Date, sd.Ship_Date, cd.Customer_Name, cd.Province, cd.Region, cd.Customer_Segment, 
mf.Sales, mf.Discount, mf.Order_Quantity, mf.Product_Base_Margin, od.Order_Priority,
pd.Product_Category, pd.Product_Sub_Category, sd.Ship_Mode
FROM market_fact mf
INNER JOIN cust_dimen cd ON mf.Cust_ID = cd.Cust_ID
INNER JOIN orders_dimen od ON od.Ord_ID = mf.Ord_ID
INNER JOIN prod_dimen pd ON pd.Prod_ID = mf.Prod_ID
INNER JOIN shipping_dimen sd ON sd.Ship_ID = mf.Ship_ID
) A;


select * from combined_table



--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.

SELECT	TOP(3)Cust_ID, COUNT (Ord_ID) count_of_orders
FROM	combined_table
GROUP BY Cust_ID
ORDER BY count_of_orders desc



--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForShipping that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

ALTER TABLE combined_table ADD DaysTakenForShipping INT

UPDATE combined_table 
SET DaysTakenForShipping = DATEDIFF(DAY, Order_date, Ship_date)


select * from combined_table


--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get shipping.
--Use "MAX" or "TOP"
SELECT	Cust_ID, Customer_Name, Order_Date, Ship_Date, DaysTakenForShipping
FROM	combined_table
WHERE	DaysTakenForShipping =(
								SELECT	MAX(DaysTakenForShipping)
								FROM combined_table
								)



SELECT top 1 Customer_Name,Cust_ID,DaysTakenForShipping
FROM combined_table
order by DaysTakenForShipping desc



--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries


SELECT MONTH(order_date) [MONTH], COUNT(DISTINCT Cust_ID) MONTHLY_NUM_OF_CUST
FROM	Combined_table A
WHERE
EXISTS
(
SELECT  Cust_ID
FROM	combined_table B
WHERE	YEAR(Order_Date) = 2011
AND		MONTH (Order_Date) = 1
AND		A.Cust_ID = B.Cust_ID
)
AND	YEAR (Order_Date) = 2011
GROUP BY
MONTH(order_date)

--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions



SELECT DISTINCT 
		Cust_ID,
		order_date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, order_date) DAYS_ELAPSED
FROM	
		(
		SELECT	Cust_ID, Ord_ID, order_DATE,
				MIN (Order_Date) OVER (PARTITION BY Cust_ID) FIRST_ORDER_DATE,
				DENSE_RANK () OVER (PARTITION BY Cust_ID ORDER BY Order_date, Ord_ID) dense_number
		FROM	combined_table
		) A
WHERE	dense_number = 3

--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions

SELECT *
FROM combined_table

WITH T1 AS
(
SELECT	Cust_ID,
		SUM (CASE WHEN Prod_ID = 'Prod_11' THEN Order_Quantity ELSE 0 END) P11,
		SUM (CASE WHEN Prod_ID = 'Prod_14' THEN Order_Quantity ELSE 0 END) P14,
		SUM (Order_Quantity) TOTAL_PROD
FROM	combined_table
GROUP BY Cust_ID
HAVING
		SUM (CASE WHEN Prod_ID = 'Prod_11' THEN Order_Quantity ELSE 0 END) >= 1 AND
		SUM (CASE WHEN Prod_ID = 'Prod_14' THEN Order_Quantity ELSE 0 END) >= 1
)
SELECT	Cust_ID, P11, P14, TOTAL_PROD,
		CAST (1.0*P11/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P11,
		CAST (1.0*P14/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P14
FROM T1



--/////////////////



--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_ID, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.


SELECT Cust_ID, YEAR(Order_Date) ORD_YEAR, MONTH(Order_Date) ORD_MONTH
FROM	combined_table

ORDER BY 1,2,3


--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.



CREATE or alter VIEW CNT_CUSTOMER_LOGS AS
SELECT DISTINCT Cust_ID, YEAR(Order_Date) ORD_YEAR, MONTH(Order_Date) ord_month, 
COUNT (*) OVER (PARTITION BY Cust_ID, YEAR(Order_Date) , MONTH(Order_Date)) cnt_log
FROM	combined_table




--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.




SELECT * FROM CNT_CUSTOMER_LOGS


--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.


;
CREATE or alter VIEW VISITS AS 
SELECT *, LAG(current_month, 1) OVER (PARTITION BY Cust_ID ORDER BY CURRENT_MONTH) prev_visit_month
FROM
(
SELECT *, DENSE_RANK() OVER (ORDER BY ord_year, ord_month) current_month
FROM	CNT_CUSTOMER_LOGS 
) A
;



SELECT * FROM VISITS


CREATE VIEW TIME_GAPS AS
SELECT *, current_month - prev_visit_month as time_gaps
FROM VISITS



--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.


WITH T1 AS
(
SELECT Cust_ID, AVG(time_gaps) avg_time_gap
FROM TIME_GAPS
GROUP BY Cust_ID
) 
SELECT Cust_ID,
		CASE WHEN avg_time_gap IS NULL THEN 'CHURN'
				WHEN avg_time_gap = 1 THEN 'REGULAR'
				WHEN avg_time_gap > 1 THEN 'IRREGULAR'
				ELSE 'UNKNOWN'
		END AS cust_segment
FROM	T1




--/////////////////////////////////////


--MONTH-WISE RETENTION RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps



WITH T1 AS 
(
SELECT current_month, count (DISTINCT Cust_ID) total_cust
FROM TIME_GAPS
GROUP BY current_month
), T2 AS
(
SELECT current_month, count (DISTINCT Cust_ID) retained_cust
FROM TIME_GAPS
WHERE time_gaps = 1
GROUP BY current_month
) 
SELECT t1.current_month, CAST(1.0*retained_cust/total_cust AS NUMERIC(3,2)) Retention_Rate, FORMAT(((1.0*retained_cust)/total_cust), 'P', 'en-us')
FROM T1, T2
WHERE T1.current_month = T2.current_month







--CREATE VIEW CNT_RETAINED_CUST AS
--SELECT *, COUNT(Cust_ID) OVER (PARTITION BY current_month) CNT_RETAINED_CUST
--FROM TIME_GAPS
--WHERE time_gaps = 1


--SELECT * FROM CNT_RETAINED_CUST



--

--CREATE VIEW CNT_TOTAL_CUST AS
--SELECT *, COUNT (Cust_ID) OVER (PARTITION BY current_month) CNT_TOTAL_CUST
--FROM TIME_GAPS
--WHERE current_month > 1





--SELECT * FROM CNT_TOTAL_CUST WHERE time_gaps = 1



----//////////////////////


----2. Calculate the month-wise retention rate.

----Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

----It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
----You can also use CTE or Subquery if you want.

----You should pay attention to the join type and join columns between your views or tables.




--SELECT	 DISTINCT A.current_month, A.CNT_RETAINED_CUST, B.CNT_TOTAL_CUST
--FROM	CNT_RETAINED_CUST A, CNT_TOTAL_CUST B
--WHERE	B.current_month = A. current_month
--ORDER BY 1


--WITH T1 AS
--(
--SELECT	 A.CURRENT_MONTH, A.CNT_RETAINED_CUST, B.CNT_TOTAL_CUST
--FROM	CNT_RETAINED_CUST A, CNT_TOTAL_CUST B
--WHERE	B.CURRENT_MONTH = A. CURRENT_MONTH
--) 
--SELECT DISTINCT CURRENT_MONTH, CAST (1.0* CNT_RETAINED_CUST/CNT_TOTAL_CUST AS NUMERIC (3,2)) AS  MONTH_WISE_RETENTION_RATE
--FROM T1
--ORDER BY 1


---///////////////////////////////////
--Good luck!