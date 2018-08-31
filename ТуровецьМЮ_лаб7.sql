 
USE Northwind
/*
1.	�������� ��������� ���������, �� ��� ������� ���� ��������� ���� �������, ��� �� ��-�������.
2.	� ������� ���� Northwind �������� ��������� ���������, �� ������ ��������� �������� �������� �������. � ��� ������� ��������� � ���������� �F� �� ����� ���������� �� �����������-����, � ��� ������������ ��������� �M� � ������. � ������������ ������� ������� �� ����� ����������� ��� ��, �� �������� �� ���������.
3.	� ������� ���� Northwind �������� ��������� ���������, �� �������� �� ���������� �� ������� �����. � ���� ���, ���� ����� �� ������ � ������� ���������� �� �������� ����.
4.	� ������� ���� Northwind �������� ��������� ���������, �� � ��������� �� ���������� ��������� ������� �������� �������� �� ������ ��� �������� �� ���� ��������. ��������� ��������� ����������� �� ���� �� ���� ��������.
5.	� ������� ���� Northwind ������������ ��������� ��������� Ten Most Expensive Products ��� ������ �񳺿 ���������� � ������� ��������, � ����� ���� ������������� �� ����� ��������.
6.	� ������� ���� Northwind �������� �������, �� ������ ��� ��������� (TitleOfCourtesy, FirstName, LastName) �� �������� �� ������ �������. 
�������: �Dr.�, �Yevhen�, �Nedashkivskyi� �> �Dr. Yevhen Nedashkivskyi�
7.	� ������� ���� Northwind �������� �������, �� ������ ��� ��������� (UnitPrice, Quantity, Discount) �� �������� ������ ����.
8.	�������� �������, �� ������ �������� ���������� ���� � ��������� ���� �� Pascal Case. �������: ̳� ��������� ��� �> ̳�������������
9.	� ������� ���� Northwind �������� �������, �� � ��������� �� ������� �����, ������� �� ��� ��� ����������� � ������ �������.
10.	� ������� ���� Northwind �������� �������, �� � ��������� �� ���� ����������� ������ ������� ������ �볺���, ���� ���� ��������������.
*/

/* �������� 1*/
  GO
   CREATE PROCEDURE MyName AS
  BEGIN
  SELECT '�������� ������ �������'
 END

 GO
  DECLARE	@return_value char
  EXEC	@return_value = Northwind.dbo.MyName
  SELECT	'Return Value' = @return_value
 GO


/* �������� 2*/

  CREATE PROCEDURE Sex_person @sex_person char
 AS
	IF @sex_person='F'
	SELECT * FROM Employees
	WHERE TitleOfCourtesy ='Ms.' OR TitleOfCourtesy ='Mrs.'
	ELSE IF @sex_person='M'
	SELECT * FROM Employees
	WHERE TitleOfCourtesy ='Mr.' OR TitleOfCourtesy ='Dr.'
	ELSE SELECT 'Invalid Input'
 GO

 GO
  DECLARE	@return_value char
  EXEC	@return_value = Sex_person
		@sex_person =  Mr
  SELECT	'Return Value' = @return_value
 GO

/*�������� 3*/
CREATE PROCEDURE Orders_Pr
	@first DATE = NULL,
	@second DATE = NULL
	AS
	BEGIN
		IF @second IS NULL AND @first IS NOT NULL
		BEGIN
			SET @second = @first;
		END;
		IF @first IS NULL
		BEGIN
			SET @first = CAST(GETDATE() AS DATE)
			SET @second = CAST(GETDATE() AS DATE);
		END;
		SELECT * FROM Orders
		WHERE Orders.OrderDate 
		BETWEEN @first AND @second;
	END;
GO

DECLARE @date DATE;
SET @date = CAST('1999-12-31' AS DATE);
EXEC Orders_Pr @date;
GO


/*�������� 4*/

 GO

 CREATE PROCEDURE ProductForCategory 
   @num_1 INT=NULL,@num_2 INT=NULL,@num_3 INT=NULL,@num_4 INT=NULL,@num_5 INT=NULL

 AS

  SELECT CategoryName,[Description] FROM Categories
 WHERE CategoryID=@num_1
  SELECT * FROM Products
 WHERE CategoryID=@num_1

  SELECT CategoryName,[Description] FROM Categories
 WHERE CategoryID=@num_2
  SELECT * FROM Products
 WHERE CategoryID=@num_2

  SELECT CategoryName,[Description] FROM Categories
 WHERE CategoryID=@num_3
  SELECT * FROM Products
 WHERE CategoryID=@num_3
 
  SELECT CategoryName,[Description] FROM Categories
 WHERE CategoryID=@num_4
  SELECT * FROM Products
 WHERE CategoryID=@num_4
 
  SELECT CategoryName,[Description] FROM Categories
 WHERE CategoryID=@num_5
  SELECT  * FROM Products
 WHERE CategoryID=@num_5
 GO
 
 GO
 DECLARE	@return_value int
 EXEC	@return_value = ProductForCategory
		@num_1 = 1,
		@num_2 = 2,
		@num_3 = 3,
		@num_4 = 4,
		@num_5 = 5
 SELECT	'Return Value' = @return_value
 GO


/* �������� 5*/

ALTER PROCEDURE [Ten Most Expensive Products]
AS
  SELECT Products.*, Suppliers.CompanyName, Categories.CategoryName
    FROM Products
    LEFT JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID
    LEFT JOIN Categories ON Categories.CategoryID = Products.CategoryID
    ORDER BY Products.UnitPrice DESC;
GO


/* �������� 6*/

 GO
 CREATE FUNCTION MyFunc
 (
	@TitleOfCourtesy CHAR(15),
	@FirstName CHAR(15),
	@LastName  CHAR(15)
 )
 RETURNS CHAR(45)
 AS
 BEGIN
	RETURN (@TitleOfCourtesy + ' ' + @FirstName + ' ' + @LastName);
END
GO
 
SELECT dbo.MyFunc('Dr.', 'Yevhen', 'Nedashkivskyi'); 

/* �������� 7*/

 GO
 CREATE FUNCTION Price
 (
	@UnitPrice FLOAT,
	@Quantity INT,
	@Discount FLOAT
 )
 RETURNS FLOAT
 AS
 BEGIN
	RETURN @UnitPrice * @Quantity * (1 - @Discount)
 END
 GO
 SELECT dbo.Price(255,117,0.345) 
 GO

/*�������� 8*/

USE [Northwind]
CREATE FUNCTION convertToPaskal
(
	@InputString NVARCHAR(256)
)
RETURNS NVARCHAR(256)
AS
BEGIN
	DECLARE @index INT;
	SET @index = PATINDEX('%[ ]%', @InputString);
	WHILE @index != 0
	BEGIN
		SET @InputString = STUFF(@InputString, @index, 2, UPPER(SUBSTRING(@InputString, @index + 1, 1)));
		SET @index = PATINDEX('%[ ]%', @InputString);
	END;
	IF LEN(@InputString) != 0
		SET @InputString = STUFF(@InputString, 1, 1, UPPER(SUBSTRING(@InputString, 1, 1)));
	RETURN (@InputString);
END
GO


SELECT ToPascalCase('Hello World')
GO
/*�������� 9*/

 GO
 CREATE FUNCTION EmployData
 (
	@Country NVARCHAR(30)
 )
 RETURNS TABLE
 AS
	RETURN (SELECT * FROM dbo.Employees WHERE dbo.Employees.Country = @Country);
 GO


/* �������� 10*/

 USE Northwind;
 GO
 CREATE FUNCTION ListOfClients
 (
	@Name NVARCHAR(100)
 )
 RETURNS TABLE
 AS
	RETURN
		(
		SELECT DISTINCT
			Customers.CustomerID,
			Customers.CompanyName,
			Customers.ContactName,
			Customers.ContactTitle,
			Customers.Address,
			Customers.City,
			Customers.Region,
			Customers.PostalCode,
			Customers.Country,
			Customers.Phone,
			Customers.Fax
			FROM dbo.Customers
			INNER JOIN dbo.Orders ON dbo.Customers.CustomerID = dbo.Orders.CustomerID
			INNER JOIN dbo.Shippers ON dbo.Orders.ShipVia = dbo.Shippers.ShipperID
				WHERE dbo.Shippers.CompanyName = @Name
		);
GO