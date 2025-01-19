




CREATE DATABASE LibDatabase;

Use LibDatabase;


--Create Two Schemas
CREATE SCHEMA Book;
---
CREATE SCHEMA Person;



--create Book.Book table
CREATE TABLE Book.Book
	(
	Book_ID int PRIMARY KEY NOT NULL,
	Book_Name nvarchar(50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL

	);


--create Book.Author table

CREATE TABLE Book.Author
	(
	Author_ID int,
	Author_FirstName nvarchar(50) Not NULL,
	Author_LastName nvarchar(50) Not NULL
	);



--create Publisher Table

CREATE TABLE Book.Publisher
	(
	Publisher_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Publisher_Name nvarchar(100) NULL
	);




--create Person.Person table

CREATE TABLE Person.Person
	(
	SSN bigint PRIMARY KEY NOT NULL,
	Person_FirstName nvarchar(50) NULL,
	Person_LastName nvarchar(50) NULL
	);


--create Person.Loan table

CREATE TABLE Person.Loan
	(
	SSN BIGINT NOT NULL,
	Book_ID INT NOT NULL,
	PRIMARY KEY (SSN, Book_ID)
	);




--cretae Person.Person_Phone table

CREATE TABLE Person.Person_Phone
	(
	Phone_Number bigint PRIMARY KEY NOT NULL,
	SSN bigint NOT NULL	
	);


--cretae Person.Person_Mail table

CREATE TABLE Person.Person_Mail
	(
	Mail_ID INT PRIMARY KEY IDENTITY (1,1),
	Mail NVARCHAR(MAX) NOT NULL,
	SSN BIGINT UNIQUE NOT NULL	
	);





----------INSERT



INSERT INTO Person.Person (SSN, Person_FirstName, Person_LastName) VALUES (75056659595,'Zehra', 'Tekin')

INSERT INTO Person.Person (SSN, Person_FirstName) VALUES (889623212466,'Kerem')



INSERT INTO Person.Person (SSN, Person_FirstName) VALUES (78962212466,'Kerem')


INSERT Person.Person VALUES (15078893526,'Mert','Yetiþ')


INSERT Person.Person VALUES (55556698752, 'Esra', Null)





INSERT Person.Person VALUES (35532888963,'Ali','Tekin');
INSERT Person.Person VALUES (88232556264,'Metin','Sakin')



INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)



SELECT @@IDENTITY--last process last identity number
SELECT @@ROWCOUNT--last process row count




select * into Person.Person_2 from Person.Person


INSERT Person.Person_2 (SSN, Person_FirstName, Person_LastName)
SELECT * FROM Person.Person where Person_FirstName like 'M%'




INSERT Book.Publisher
DEFAULT VALUES


--Update

UPDATE Person.Person_2 SET Person_FirstName = 'Default_Name'



UPDATE Person.Person_2 SET Person_FirstName = 'Can' WHERE SSN = 78962212466


select * from Person.Person_2



----delete





insert Book.Publisher values ('Ýþ Bankasý Kültür Yayýncýlýk'), ('Can Yayýncýlýk'), ('Ýletiþim Yayýncýlýk')




Delete from Book.Publisher 

select * from Book.Publisher 


insert Book.Publisher values ('ÝLETÝÞÝM')

select * from Book.Publisher




--//////////////////////////////



DROP TABLE Person.Person_2;

TRUNCATE TABLE Person.Person_Mail;
TRUNCATE TABLE Person.Person;
TRUNCATE TABLE Book.Publisher;





ALTER TABLE Book.Book ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)

ALTER TABLE Person.Book ADD CONSTRAINT FK_Publisher FOREIGN KEY (Publisher_ID) REFERENCES Book.Publisher (Publisher_ID)

---------Author





ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)


ALTER TABLE Book.Author ALTER COLUMN Author_ID INT NOT NULL





ALTER TABLE Person.Loan ADD CONSTRAINT FK_PERSON FOREIGN KEY (SSN) REFERENCES Person.Person (SSN)
ON UPDATE NO ACTION
ON DELETE NO ACTION


ALTER TABLE Person.Loan ADD CONSTRAINT FK_book FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID)
ON UPDATE NO ACTION
ON DELETE CASCADE








Alter table Person.Person add constraint FK_PersonID_check Check (SSN between 9999999999 and 99999999999)


Alter table Person.Person add constraint FK_PersonID_check2 Check (dbo.KIMLIKNO_KONTROL(SSN) = 1)



Alter table Person.Person_Phone add constraint FK_Person2 Foreign key (SSN) References Person.Person(SSN)


Alter table Person.Person_Phone add constraint FK_Phone_check Check (Phone_Number between 999999999 and 9999999999)

--

Alter table Person.Person_Mail add constraint FK_Person4 Foreign key (SSN) References Person.Person(SSN)













