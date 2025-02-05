






--Procedure Syntax

CREATE PROC sp_sampleproc1
AS
BEGIN
	SELECT 'HELLO WORLD' 
END;




EXECUTE sp_sampleproc1

EXEC sp_sampleproc1

sp_sampleproc1


--

ALTER PROC sp_sampleproc1
AS
BEGIN
	PRINT 'QUERY COMPLETED' 
END;


sp_sampleproc1


-----------------------

---

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);



INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )


SELECT * FROM ORDER_TBL



CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE 
);




INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )


-------------



--

CREATE PROC sp_sum_order
AS
BEGIN
	
	SELECT COUNT (ORDER_ID) AS TOTAL_ORDER FROM ORDER_TBL

END;





----------------------------


CREATE PROC sp_wantedday_order
(
	@DAY DATE
)
AS
BEGIN

	SELECT COUNT (ORDER_ID) 
	FROM ORDER_TBL
	WHERE ORDER_DATE = @DAY

END;

--

EXEC sp_wantedday_order '2021-04-24'


----

CREATE OR ALTER PROC sp_sampleproc5 (@CUSTOMER VARCHAR(50), @DAY DATE = '01-01-2022')
AS
BEGIN
	SELECT COUNT (ORDER_ID) AS CNT_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
	AND		CUSTOMER_NAME = @CUSTOMER
END


EXEC sp_sampleproc5 'Adam', '2022-10-02'





-------------------

DECLARE @P1 INT, @P2 INT, @SUM INT

SET @P1 = 5

SELECT @P2 = 4

SELECT @SUM = @P1+@P2

SELECT @SUM




------------------

DECLARE @P1 INT , @P2 INT , @SUM INT


SELECT @P1 = 3 , @P2 = 7, @SUM = @P1+@P2

PRINT @SUM


-------------------


DECLARE @CUST_ID INT = 2

SELECT *
FROM
ORDER_TBL 
WHERE
CUSTOMER_ID = @CUST_ID


------------------------

--IF, ELSE IF, ELSE 


DECLARE @CUSTOMER_ID INT = 3

IF		@CUSTOMER_ID = 1
		PRINT 'CUSTOMER NAME IS ADAM'
ELSE IF	@CUSTOMER_ID = 2
		PRINT 'CUSTOMER NAME IS SMITH'
ELSE IF @CUSTOMER_ID = 3
		PRINT 'CUSTOMER NAME IS JOHN'


------------------


-- IF command with exists and not exists

DECLARE @CUSTOMER_ID INT 

SET @CUSTOMER_ID = 5


IF EXISTS (SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUSTOMER_ID)
	SELECT	COUNT (ORDER_ID)
	FROM	ORDER_TBL
	WHERE	CUSTOMER_ID = @CUSTOMER_ID



	----------------------


DECLARE @CUSTOMER_ID INT 

SET @CUSTOMER_ID = 5


IF NOT EXISTS (SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUSTOMER_ID)
	SELECT	COUNT (ORDER_ID)
	FROM	ORDER_TBL
	WHERE	CUSTOMER_ID = @CUSTOMER_ID

--

DECLARE @V1 INT , @V2 INT

SELECT @V1 = 6, @V2 = 6

IF @V1 > @V2

	SELECT @V1+@V2 AS TOPLAM

ELSE IF @V2 > @V1 

	SELECT @V2-@V1 AS FARK

ELSE SELECT @V1*@V2 AS CARPIM





---

CREATE PROC sp_ordersday_1 (@DATE DATE)
AS
BEGIN

DECLARE @ORDER_COUNT INT

SELECT	@ORDER_COUNT = COUNT(ORDER_ID)
FROM	ORDER_TBL
WHERE	ORDER_DATE = @DATE

IF @ORDER_COUNT < 2
	PRINT 'LOWER THAN 2'
ELSE IF @ORDER_COUNT > 5
	PRINT 'UPPER THAN 5'
ELSE
	PRINT @ORDER_COUNT

END; 


EXEC sp_ordersday_1 '2023-07-27'









--WHILE

DECLARE @NUM_OF_ITER INT = 50 , @COUNTER INT = 0

WHILE @NUM_OF_ITER > @COUNTER

	BEGIN

		SELECT @COUNTER
		SET @COUNTER += 1
	
	END

-------------


SELECT *
FROM	ORDER_TBL


DECLARE @ID INT = 10

WHILE @ID <21
BEGIN
	
	INSERT ORDER_TBL VALUES (@ID, @ID, NULL, NULL, NULL)
	SET @ID += 1
END

SELECT * FROM ORDER_TBL



------------------


--FUNCTIONS

---SCALAR VALUED FUNC



CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END



--

SELECT dbo.fnc_uppertext('whats up')

--------------------


--


CREATE OR ALTER FUNCTION fn_upper_first_char(@CHAR NVARCHAR (MAX)) 
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN UPPER (LEFT (@CHAR, 1)) + LOWER (RIGHT (@CHAR, len (@CHAR)-1))

END

SELECT dbo.fn_upper_first_char('UFUK')



--


SELECT *, dbo.fn_upper_first_char(CUSTOMER_NAME) AS NEW_NAME
FROM	ORDER_TBL




-------------



CREATE FUNCTION dbo.statusoforderdelivery
(
	@ORDER INT
)
RETURNS VARCHAR (10)
AS
BEGIN
	
	DECLARE @EST_DATE DATE
	DECLARE @DEL_DATE DATE
	DECLARE @STATUS VARCHAR (10)
	
	SELECT @EST_DATE = EST_DELIVERY_DATE 
	FROM ORDER_TBL 
	WHERE ORDER_ID = @ORDER 
	
	SET @DEL_DATE = (SELECT DELIVERY_DATE FROM ORDER_DELIVERY WHERE ORDER_ID= @ORDER)


	IF @EST_DATE < @DEL_DATE
		
		SET @STATUS = 'LATE'
	ELSE IF @EST_DATE > @DEL_DATE

		SET @STATUS = 'EARLY'

	ELSE
		SET @STATUS = 'ON TIME'
		
RETURN @STATUS

END;


SELECT dbo.statusoforderdelivery(3)


--------------

--Where statement

SELECT * FROM ORDER_TBL WHERE dbo.statusoforderdelivery(ORDER_ID) = 'ON TIME'


--------------


---------------////////////////////////////



--Table Valued Functions


CREATE FUNCTION fn_table_valued_1 ()
RETURNS TABLE 
AS

RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE < '2023-07-25'



SELECT *
FROM	dbo.fn_table_valued_1 ()

--------------



--

CREATE FUNCTION fn_table_valued_2 (@date DATE)
RETURNS TABLE 
AS

RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE < @date
;


SELECT *
FROM	dbo.fn_table_valued_2 ('2023-07-22')



-----


--

DECLARE @TABLE1 TABLE (ID INT , NAME VARCHAR (25))

INSERT @TABLE1 VALUES (1, 'Ahmet')

select *
from @TABLE1


 

 -------------------


ALTER FUNCTION fn_table_valued_3 (@ORDER INT)
RETURNS @TABLE TABLE (ID INT , NAME VARCHAR (25))
AS
BEGIN
	
	INSERT		@TABLE
	SELECT	 CUSTOMER_ID, CUSTOMER_NAME
	FROM	 ORDER_TBL
	WHERE	 dbo.fn_order_status(@ORDER) = 'ON TIME'
	AND		 ORDER_ID = @ORDER

RETURN
END;



SELECT *
FROM dbo.fn_table_valued_3 (1)
--



