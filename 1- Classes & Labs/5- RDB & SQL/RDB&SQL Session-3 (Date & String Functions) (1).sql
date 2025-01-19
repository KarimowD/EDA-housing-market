





--------------------////////////////////

--Date Functions


-- Data Types

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

	

SELECT *
FROM	t_date_time



select getdate()


INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())



INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )










----//////////////

---Functions for return date or time parts

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time



----//////////

--Functions for return date or time differences


SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Diff_day,
		DATEDIFF (MONTH, A_date, A_datetime) Diff_month,
		DATEDIFF (YEAR, A_date, A_datetime) Diff_month,
		DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour,
		DATEDIFF (MINUTE, A_smalldatetime, A_datetime) Diff_Hour
FROM	t_date_time



select	DATEDIFF (DAY, order_date, shipped_date), order_date, shipped_date, 
		DATEDIFF (DAY, shipped_date, order_date)
from	sale.orders
where	order_id = 1



--//////////////

-- Functions for Modify date and time

SELECT	DATEADD (YEAR, 5, order_date), 
		DATEADD (DAY, 5, order_date),
		DATEADD (DAY, -5, order_date),
		order_date
FROM	sale.orders
where	order_id = 1




SELECT	EOMONTH( order_date), EOMONTH( order_date, 2), order_date
FROM	sale.orders


-----/////////////


--Function for Validate date and time


SELECT	ISDATE( CAST (order_date AS nvarchar)), order_date
FROM	sale.orders


SELECT ISDATE ('1234568779')

SELECT ISDATE ('WHERE')

SELECT ISDATE ('2021-12-02')

SELECT ISDATE ('02/12/2022')



----//////////




----////////////////

--QUERY TIME




-------//////////////



--Write a query returns orders that are shipped more than two days after the order date. 


SELECT *, DATEDIFF(DAY, order_date, shipped_date) DATE_DIFF
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) >2



---////////////




-------------///////////////////--------------------------------///////////////////-------------------
-------------///////////////////--------------------------------///////////////////-------------------
-------------///////////////////--------------------------------///////////////////-------------------
-------------///////////////////--------------------------------///////////////////-------------------
-------------///////////////////--------------------------------///////////////////-------------------



--MS SQL SERVER STRING FUNCTIONS

---LEN

--NO QUOTES
SELECT LEN (1235465)


--NO QUOTES WITH STRING
SELECT LEN (WELCOME)

--WITH QUOTES
SELECT LEN ('WELCOME')

SELECT LEN (' WELCOME')



--If there is a quote in the string

SELECT 'Jack''s phone'


-----CHARINDEX

SELECT CHARINDEX('C', 'CHARACTER')


SELECT CHARINDEX('C', 'CHARACTER', 2)


SELECT CHARINDEX('CT', 'CHARACTER')



--PATINDEX()

SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('R%', 'CHARACTER')

SELECT PATINDEX('%R%', 'CHARACTER')


--LEFT

SELECT LEFT('CHARACTER', 3)

SELECT LEFT(' CHARACTER', 3)



--RIGHT

SELECT RIGHT('CHARACTER', 3)


SELECT RIGHT('CHARACTER ', 3)


--SUBSTRING

SELECT SUBSTRING('CHARACTER', 3, 5)

SELECT SUBSTRING(123456789, 3, 5)

SELECT SUBSTRING('CHARACTER', 0, 5)

SELECT SUBSTRING('CHARACTER', -1, 5)


--LOWER

SELECT LOWER ('CHARACTER')



--UPPER
SELECT UPPER ('character')


--How to grow the first character of the 'character' word.

SELECT UPPER(LEFT('character', 1)) + LOWER(RIGHT('character', 8))



SELECT UPPER(LEFT('character',1)) + LOWER (RIGHT('character', LEN ('character')-1))




--STRING_SPLIT


SELECT * FROM STRING_SPLIT ('John,Jeremy,Jack',',')

---



---TRIM, LTRIM, RTRIM

SELECT TRIM(' CHARACTER')

SELECT TRIM(' CHARACTER ')

SELECT TRIM( ' CHAR ACTER ')


SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString;


SELECT LTRIM ('     CHARACTER ')


SELECT RTRIM ('     CHARACTER ')




---REPLACE

SELECT REPLACE('CHARACTER STRING', ' ', '/')


SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')





--STR


SELECT STR (5454)

SELECT STR (2135454654)

SELECT STR (5454, 4)

SELECT STR (5454, 10, 5)


SELECT STR (133215.654645,7)

SELECT STR (133215.654645, 11, 3)






--CAST

SELECT CAST (12345 AS CHAR)

SELECT CAST (123.65 AS INT)



--CONVERT


SELECT CONVERT(int, 30.60)

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )




--------/////////////////////----------


--SQL Server Datetime Formatting

--Converting a Datetime to a Varchar

SELECT CONVERT(VARCHAR, GETDATE(), 7)

--Converting a Varchar to a Datetime

SELECT convert(DATE, '25 Oct 21', 6)
----

select convert(varchar, getdate(), 6)

https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/ 






--COALESCE



SELECT COALESCE(NULL, 'Hi', 'Hello', NULL) result;


SELECT COALESCE(NULL, NULL ,'Hi', 'Hello', NULL) result;


SELECT COALESCE(NULL, NULL) result;




--NULLIF


SELECT NULLIF (10,10)


SELECT NULLIF('Hello', 'Hi') result;



SELECT NULLIF(2,'2')



--ROUND


SELECT ROUND (432.368, 2, 0)

SELECT ROUND (432.368, 2)

SELECT ROUND (432.368, 1, 0)


SELECT ROUND (432.368, 1, 1)

SELECT ROUND (432.300, 1, 1)


SELECT ROUND (432.368, 3, 0)



------------//////////////////////////

-- How many customers have yahoo mail?


SELECT email, PATINDEX('%yahoo%', email) 
FROM sale.customer


SELECT	COUNT(*)
FROM	sale.customer
WHERE	PATINDEX('%yahoo%', email) >0

-- or 

SELECT count (*)
FROM sale.customer
WHERE
email like '%yahoo%'



---//////////


--Write a query that returns the characters before the '@' character in the email column.

SELECT email, LEFT (email, CHARINDEX('@', email)-1) Chars
FROM sale.customer




--//////////////////


--Add a new column to the customers table that contains the customers' contact information. 
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.


SELECT	customer_id, first_name, last_name, phone, email, COALESCE (phone, email) contact
FROM	sale.customer



---///////////////////

--Write a query that returns the name of the streets, where the third character of the streets is numeric.


SELECT street, SUBSTRING( street, 3, 1) third_char
FROM sale.customer
WHERE	SUBSTRING( street, 3, 1) LIKE '[0-9]'


SELECT street, SUBSTRING( street, 3, 1) third_char
FROM sale.customer
WHERE	SUBSTRING( street, 3, 1) LIKE '[0-9]'



SELECT street, SUBSTRING( street, 3, 1) third_char
FROM sale.customer
WHERE	SUBSTRING( street, 3, 1) NOT LIKE '[^0-9]'



SELECT street, SUBSTRING( street, 3, 1) third_char
FROM sale.customer 
WHERE	ISNUMERIC (SUBSTRING( street, 3, 1) ) = 1



------///////////

--Split the mail addresses into two parts from ‘@’, and place them in separate columns.


--ronna.butler@gmail.com	/ ronna.butler	/ gmail.com


SELECT email, LEFT (email, CHARINDEX('@', email)-1) Left_part, RIGHT (email, LEN(email) - (CHARINDEX('@', email))) Right_part
FROM sale.customer


--or with substring

SELECT	email, 
		SUBSTRING (email, 1, CHARINDEX('@', email)-1), 
		SUBSTRING(email, (CHARINDEX('@', email)+1), LEN(email))
FROM sale.customer



--------//////////////

--If you have extra time



--The street column has some string characters (5C, 43E, 234F, etc.) 
--that are mistakenly added to the end of the numeric characters in the first part of the street records. Remove these typos in this column. 


--1
SELECT	street,
		LEFT (street, CHARINDEX(' ', street)-1) AS target_chars
FROM	sale.customer
ORDER BY 2 DESC


--2
SELECT	street,
		LEFT (street, CHARINDEX(' ', street)-1) AS target_chars,
		
		RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1) AS string_chars,

		LEFT (street, CHARINDEX(' ', street)-2) AS numerical_chars

FROM	sale.customer




--3


SELECT	street,
		LEFT (street, CHARINDEX(' ', street)-1) AS target_chars,
		
		RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1) AS string_chars

FROM	sale.customer
WHERE	ISNUMERIC (RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1)) = 0



--4 Result

SELECT street, REPLACE (street, target_chars,numerical_chars)
FROM	(
			SELECT	street,
					LEFT (street, CHARINDEX(' ', street)-1) AS target_chars,
		
					RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1) AS string_chars,

					LEFT (street, CHARINDEX(' ', street)-2) AS numerical_chars

			FROM	sale.customer
			WHERE	ISNUMERIC (RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1)) = 0
		) A



