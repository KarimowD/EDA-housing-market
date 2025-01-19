


create table website_visitor 
(
visitor_id int,
first_name varchar(50),
last_name varchar(50),
phone_number bigint,
city varchar(50)
);


--

DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;



--

SELECT top 10*
FROM
website_visitor



--
SET STATISTICS IO on
SET STATISTICS TIME on



--


SELECT *
FROM
website_visitor
where
visitor_id = 100

--

Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id);


--



SELECT visitor_id
FROM
website_visitor
where
visitor_id = 100


--

SELECT *
FROM
website_visitor
where
visitor_id = 100

------------------------------
--


SELECT first_name
FROM
website_visitor
where
first_name = 'visitor_name17'



--
CREATE NONCLUSTERED INDEX ix_NoN_CLS_1 ON website_visitor (first_name);


--

SELECT first_name
FROM
website_visitor
where
first_name = 'visitor_name17'


SELECT first_name, last_name
FROM
website_visitor
where
first_name = 'visitor_name17'



--
Create unique NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (first_name) include (last_name)


--
SELECT first_name, last_name
FROM
website_visitor
where
first_name = 'visitor_name17'

--


SELECT last_name
FROM
website_visitor
where
last_name = 'visitor_surname10'

