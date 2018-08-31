/*
1.	Створити базу даних підприємства «LazyStudent», що займається допомогою студентам ВУЗів з пошуком репетиторів, проходженням практики та розмовними курсами за кордоном.
2.	Самостійно спроектувати структуру бази в залежності від наступних завдань.
3.	База даних повинна передбачати реєстрацію клієнтів через сайт компанії та збереження їх основної інформації. Збереженої інформації повинно бути достатньо для контактів та проведення поштових розсилок.
4.	Через сайт компанії може також зареєструватися репетитор, що надає освітні послуги через посередника «LazyStudent». Репетитор має профільні дисципліни (довільна кількість) та рейтинг, що визначається клієнтами, що з ним уже працювали. 
5.	Компанії, з якими співпрацює підприємство, також мають зберігатися в БД.
6.	Співробітники підприємства повинні мати можливість відстежувати замовлення клієнтів та їх поточний статус. Передбачити можливість побудови звітності (в тому числі і фінансової) в розрізі періоду, клієнту, репетитора/компанії.
7.	Передбачити ролі адміністратора, рядового працівника та керівника. Відповідним чином розподілити права доступу.
8.	Передбачити історію видалень інформації з БД. Відповідна інформація не повинна відображатися на боці сайту, але керівник та адміністратор мусять мати можливість переглянути хто, коли і яку інформацію видалив.
9.	Передбачити систему знижок в залежності від дати реєстрації клієнта. 1 рік – 5%, 2 роки – 8%, 3 роки – 11%, 4 роки – 15%. 
10.	Передбачити можливість проведення акцій зі знижками на послуги компаній-партнерів в залежності від компаніх та дати проведення акції.
*/
/*Завдання 1*/
 USE [master]
 CREATE DATABASE "LasyStudent"
 USE "LasyStudent"

/*Завдання 3*/


CREATE TABLE [Clients] (
    [ID]                INT IDENTITY(1,1) NOT NULL,  -- ID клієнта
    [Client_Name]       NVARCHAR(40) NOT NULL,       -- імя клієнта 
    [Client_Lastname]   NVARCHAR(20) NOT NULL,       -- його прізвище
    [Mail] NVARCHAR(144)             NOT NULL,       -- пошта
	[Client_BirthDay] DATE NOT NULL,                 -- дата народження
    CONSTRAINT PK PRIMARY KEY CLUSTERED (ID)
	)

	--пейджер клієнта
CREATE TABLE [ClientsPager] (
    [ID_Pages]          INT IDENTITY(1,1) NOT NULL,
    [Client_num]        INT NOT NULL FOREIGN KEY REFERENCES Clients(ID),
    [Pager]             NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_Pages       PRIMARY KEY CLUSTERED (ID_Pages))
GO

-- вставляємо декілька полів
 INSERT INTO [Clients](Client_Name, Client_Lastname, Mail,  Client_BirthDay) VALUES('Client_name1', 'Client_Lastname1', 'User1@gmail.com','24-04-2018')
 INSERT INTO [Clients](Client_Name, Client_Lastname, Mail,  Client_BirthDay) VALUES('Client_name2', 'Client_Lastname2', 'User2@gmail.com','24-04-2018')
 INSERT INTO [Clients](Client_Name, Client_Lastname, Mail,  Client_BirthDay) VALUES('Client_name3', 'Client_Lastname3', 'User3@gmail.com','24-04-2018')
 INSERT INTO [Clients](Client_Name, Client_Lastname, Mail,  Client_BirthDay) VALUES('Client_name4', 'Client_Lastname4', 'User4@gmail.com','24-04-2018')
 INSERT INTO [Clients](Client_Name, Client_Lastname, Mail,  Client_BirthDay) VALUES('Client_name5', 'Client_Lastname5', 'User5@gmail.com','24-04-2018')
 
/*Завдання 4*/

 CREATE TABLE [Tutor] (
    [ID_Tutor]                             INT UNIQUE NOT NULL FOREIGN KEY REFERENCES Clients(ID),
    [Ratings_Value]                        BIGINT CHECK ([Ratings_Value] >= 0 OR [Ratings_Value]<100 ),
    CONSTRAINT PK_Tutor                    PRIMARY KEY CLUSTERED (ID_Tutor))

CREATE TABLE [Disciplines] (
    [ID_Disc]  INT IDENTITY(1,1) NOT NULL,
    [ID_Tutor] INT NOT NULL FOREIGN KEY REFERENCES Clients(ID), 
    [Name]     NVARCHAR(255) NOT NULL,
    [Price]    INT NOT NULL CHECK ([Price] >= 0)
    CONSTRAINT PK_Disciplines PRIMARY KEY CLUSTERED (ID_Disc))
GO

INSERT INTO Tutor(ID_Tutor, Ratings_Value) VALUES (1, 20)
INSERT INTO Tutor(ID_Tutor, Ratings_Value) VALUES (2, 30)
SELECT * FROM Tutor 

INSERT INTO Disciplines( ID_Tutor, [Name],Price) VALUES ( 1, 'sql_1', 7000)
INSERT INTO Disciplines( ID_Tutor, [Name],Price) VALUES ( 2, 'sql_2', 9000)
SELECT * FROM Disciplines


/*Завдання 5*/


CREATE TABLE [Partners_Compani] (
    [Partners_ID] INT IDENTITY(1,1) NOT NULL,
	[Partners_Name] NVARCHAR(255) NOT NULL,
    [Address] NVARCHAR(255) NOT NULL,
    [Mail] NVARCHAR(255) UNIQUE NOT NULL,
    CONSTRAINT PK_Companies PRIMARY KEY CLUSTERED (Partners_ID)
	)

CREATE TABLE [Partners_job] (
    [Job_ID] INT IDENTITY(1,1) NOT NULL,
    [Partners_ID] INT NOT NULL FOREIGN KEY REFERENCES Partners_Compani(Partners_ID),
    [ServiceName] NVARCHAR(255) NOT NULL,
    [Price] INT NOT NULL CHECK([Price] >= 0)
    CONSTRAINT PK_Job PRIMARY KEY CLUSTERED (Job_ID))
GO

INSERT INTO Partners_Compani(Partners_Name, [Address], [Mail]) VALUES ('Nutella', 'New York', 'nutica@sql.com')
INSERT INTO Partners_Compani(Partners_Name, [Address], [Mail]) VALUES ('Nestle', 'Amsterdam', 'nestle@c++.com')
INSERT INTO Partners_Compani(Partners_Name, [Address], [Mail]) VALUES ('Coca Cola', 'London', 'cocacola@java.com')
SELECT * FROM Partners_Compani;

INSERT INTO Partners_job (Partners_ID, ServiceName, Price) VALUES (1, 'DBO', 4050)
INSERT INTO Partners_job (Partners_ID, ServiceName, Price) VALUES (2, 'DBO2', 1999)
INSERT INTO Partners_job (Partners_ID, ServiceName, Price) VALUES (3, 'DBO3', 845)
SELECT * FROM Partners_job;


/*Завдання 6*/
CREATE TABLE [Tutor_orders] (
    [Orders_ID]      INT IDENTITY(1,1) NOT NULL,
    [Client_ID]      INT NOT NULL FOREIGN KEY REFERENCES Clients(ID),
    [Discipline_ID]  INT NOT NULL FOREIGN KEY REFERENCES Disciplines(ID_Disc),
    [OrderDate]      Date NOT NULL DEFAULT GETDATE(),
    [Discount]       INT NOT NULL CHECK([Discount] >= 0 AND [Discount] <= 100),
    CONSTRAINT PK_Tut PRIMARY KEY CLUSTERED (Orders_ID))

 CREATE TABLE [Companie_orders] (
    [Companie_orders_ID] INT IDENTITY(1,1) NOT NULL,
    [Client_ID] INT NOT NULL FOREIGN KEY REFERENCES Clients(ID),
    [Partners_ID] INT NOT NULL FOREIGN KEY REFERENCES Partners_Compani(Partners_ID),
	[OrderDate] Date NOT NULL DEFAULT GETDATE(),
    [Discount] INT NOT NULL CHECK([Discount] >= 0 AND [Discount] <= 100),
    CONSTRAINT PK_Companie_Orders_ID PRIMARY KEY CLUSTERED (Companie_orders_ID)
	)
GO

INSERT INTO [Tutor_orders](Client_ID, Discipline_ID, OrderDate, Discount) VALUES (1, 1, '24-04-2018', 80)
INSERT INTO [Tutor_orders](Client_ID, Discipline_ID, OrderDate, Discount) VALUES (2, 2, '24-04-2018', 75)
SELECT * FROM Tutor_orders;


INSERT INTO [Companie_orders](Client_ID, Partners_ID, OrderDate, Discount) VALUES (1, 1, '24-04-2018', 80)
INSERT INTO [Companie_orders](Client_ID, Partners_ID, OrderDate, Discount) VALUES (2, 2, '24-04-2018', 75)
INSERT INTO [Companie_orders](Client_ID, Partners_ID, OrderDate, Discount) VALUES (3, 3, '24-04-2018', 50)
SELECT * FROM Companie_orders

CREATE PROCEDURE ForPeriod
@start_date date = null,
@end_date date = null,
@client  int = 0,
@tutor   int = -1,
@company int = 0,
@teacher int = 0,
@partner int = -1
AS
	IF @start_date is null
		SET @start_date = DATEADD(day,-7, GETDATE())
	IF @end_date is null
		SET @end_date = GETDATE()
	IF @partner = -1 AND @tutor = -1
		BEGIN
			SET @partner = 0
			SET @tutor = 0
		END

SELECT     cli.Mail         as 'Client', 
		   par.ServiceName  as 'Partner_Job', 
		   exe.Partners_Name as 'Executor',
		   par.Price, 
		   cor.Discount, 
		   cor.OrderDate,
		   'Partner' as 'OrderType'

	FROM Companie_orders       as cor
	JOIN Partners_job          as par  ON  cor.Partners_ID  = par.Job_ID
	JOIN Partners_Compani      as exe  ON  exe.Partners_ID  = par.Partners_ID
	JOIN Clients as cli        ON cli.ID = cor.Client_ID
	WHERE cor.OrderDate >= @start_date
	AND   cor.OrderDate <= @end_date
	AND   (cor.Client_ID= @client
	OR @client = 0)
	AND (par.Partners_ID = @company
	OR @company = 0)
	UNION 

	SELECT cli.Mail   as 'Client',
		   dis.[Name] as 'Service', 
		   tr.Mail    as 'Executor',
		   dis.Price, 
		   tut.Discount, 
		   tut.OrderDate,
		   'Teacher'  as 'OrderType'

	FROM Tutor_orders     as tut
	JOIN Disciplines      as dis ON tut.Discipline_ID = dis.ID_Disc
	JOIN Clients as cli   ON cli.ID = tut.Client_ID
	JOIN Clients as tr    ON tr.ID = dis.ID_Tutor
	WHERE OrderDate >= @start_date
	AND OrderDate <= @end_date
	AND (tut.Client_ID = @client
	OR @client = 0)
	AND (dis.ID_Tutor = @teacher
	OR @teacher = 0);

	-- Перевірка працездатності
    ForPeriod @client = 2

/*Завдання 7*/

CREATE ROLE Administrator
CREATE ROLE Chief
CREATE ROLE Employee

/*Завдання 8*/

CREATE FUNCTION GetColum(
@table NVARCHAR(256))
RETURNS NVARCHAR(1024)
AS
BEGIN
	RETURN SUBSTRING(
		(SELECT ', ' + QUOTENAME(COLUMN_NAME)
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = @table
			ORDER BY ORDINAL_POSITION
			FOR XML path('')),
		3,
		1024);
END;


GO
SELECT o.name INTO [Tables]
FROM sys.objects o WHERE o.[type] = 'U'

DELETE FROM [Tables]
WHERE name = 'Tables'

SELECT * FROM [Tables]

USE LasyStudent
GO
DECLARE
	curs CURSOR FOR SELECT name from [Tables]
DECLARE 
	@table VARCHAR(256)
OPEN curs
FETCH NEXT FROM curs INTO @table
WHILE @@FETCH_STATUS = 0
BEGIN 
	DECLARE 
		@archive NVARCHAR(256)
	SET @archive = 'Archive' + @table
	EXECUTE('SELECT * INTO ' +@archive + ' FROM ' + @table);
	EXECUTE('ALTER TABLE '   +@archive + ' ADD DeleteDate Date DEFAULT GETDATE()');
	EXECUTE('ALTER TABLE '   +@archive + ' ADD DeletePerson NVARCHAR(255)');
	EXECUTE('DELETE FROM '   +@archive);
	EXECUTE('DENY ALL ON '   +@archive + ' TO Employee')
	EXECUTE('DENY ALL ON '   +@table + ' TO Employee')
	EXECUTE('GRANT SELECT ON ' +@table + ' TO Employee')
	DECLARE 
		@string NVARCHAR(144),
		@pers   NVARCHAR(144)
	SET @string = [dbo].GetColum(@archive)
	SET @pers = CURRENT_USER
	EXECUTE('CREATE TRIGGER Trigger_' + @table + ' ON ' + @table + '
	FOR DELETE AS
	BEGIN
		IF OBJECTPROPERTY(OBJECT_ID(''' + @archive + '''), ''TableHasIdentity'') = 1
			SET IDENTITY_INSERT ' + @archive + ' ON
		INSERT INTO ' + @archive + ' (' + @string + ') SELECT *, GETDATE(), '''+ @pers +''' FROM DELETED;
		IF OBJECTPROPERTY(OBJECT_ID(''' + @archive + '''), ''TableHasIdentity'') = 1
			SET IDENTITY_INSERT ' + @archive + ' OFF
	END;')
	FETCH NEXT FROM curs INTO @table
END 
CLOSE curs
DEALLOCATE curs;

DROP TABLE [Tables]

/*Завдання 9*/

CREATE TRIGGER Disc ON Companie_orders
FOR INSERT
AS
BEGIN
	DECLARE
	    @ID INT,
        @DISCOUNT INT,
        @ORDER_DATE DATE,
        @REGISTRATION_DATE DATE,
        @SERVICE_ID INT,
        @ADD_DISCOUNT INT,
        @ORDER_ID INT
	SELECT @ID = [Client_ID], 
		   @DISCOUNT = Discount, 
		   @SERVICE_ID = Partners_ID, 
		   @ORDER_DATE =  OrderDate, 
		   @ORDER_ID = Companie_orders_ID 
	FROM inserted;
	SELECT @ADD_DISCOUNT = MAX(Discount)
	FROM Discounts
	WHERE CompanyServiceId = @SERVICE_ID 
	AND @ORDER_DATE >= [StartDate] 
	AND @ORDER_DATE <= DATEADD(day, [Duration], StartDate);
	IF @ADD_DISCOUNT is not null
		SET @DISCOUNT = @DISCOUNT + @ADD_DISCOUNT;
	IF @REGISTRATION_DATE < DATEADD(year, -4, GETDATE())
       SET @DISCOUNT = @DISCOUNT + 15
	ELSE 
	IF @REGISTRATION_DATE < DATEADD(year, -3, GETDATE())
          SET @DISCOUNT = @DISCOUNT + 11
	ELSE 
	IF @REGISTRATION_DATE < DATEADD(year, -2, GETDATE())
          SET @DISCOUNT = @DISCOUNT + 8
	ELSE 
	IF @REGISTRATION_DATE < DATEADD(year, -1, GETDATE())
		  SET @DISCOUNT = @DISCOUNT + 5
	IF @DISCOUNT > 100
		  SET @DISCOUNT = 100
	UPDATE CompaniesOrders
	SET Discount = @DISCOUNT
	WHERE CompanyOrderID = @ORDER_ID
END

CREATE TRIGGER Tut ON [Tutor_orders]
FOR INSERT
AS
BEGIN
	DECLARE
	    @ID INT,
        @DISCOUNT INT,
        @REGISTRATION_DATE DATE,
        @ORDER_ID INT
	SELECT @ID = [Client_ID], 
		   @DISCOUNT = Discount, 
		   @ORDER_ID = [Orders_ID] 
	FROM INSERTED;
	IF @REGISTRATION_DATE < DATEADD(year, -4, GETDATE())
       SET @DISCOUNT = @DISCOUNT + 15
	ELSE 
	IF @REGISTRATION_DATE < DATEADD(year, -3, GETDATE())
          SET @DISCOUNT = @DISCOUNT + 11
	ELSE 
	IF @REGISTRATION_DATE < DATEADD(year, -2, GETDATE())
          SET @DISCOUNT = @DISCOUNT + 8
	ELSE 
	IF @REGISTRATION_DATE < DATEADD(year, -1, GETDATE())
		  SET @DISCOUNT = @DISCOUNT + 5
	IF @DISCOUNT > 100
		  SET @DISCOUNT = 100
	UPDATE [Tutor_orders]
	SET Discount = @DISCOUNT
	WHERE [Orders_ID] = @ORDER_ID
END

/*Завдання 10*/

CREATE TABLE [Discounts] (
    [DiscountId] INT IDENTITY(1,1) NOT NULL,
    [CompanyServiceId] INT NOT NULL FOREIGN KEY REFERENCES Partners_job(Job_ID),
    [StartDate] Date NOT NULL,
    [Duration] INT NOT NULL CHECK([Duration] > 0),
    [Discount] INT NOT NULL CHECK([Discount] >= 0 AND [Discount] <= 100),
    CONSTRAINT PK_DiscountId PRIMARY KEY CLUSTERED (DiscountId))
 GO

 INSERT INTO [Discounts]([CompanyServiceId], [StartDate], [Duration], [Discount]) VALUES (1, GETDATE(), 10, 40)
 SELECT * FROM [Discounts]

