/*
1.	������� �� ����� ����� ��� ������� � ��� ����� �� ������� ����� � ���.
2.	������ ����� �� ������� ���� ����� Northwind ��� ������������ ���� ����. ��� ������� ��������� � ����������� �� ���� �������� ������������.
3.	�� ��������� ������� ���������� ������������ TestUser ������ �� ��� ������� ������� ���� �����, ����� ������ ����������� �� ������� �prod_�.
4.	�������� ������ �� ������� Customers, �� ��� ������� ������ ����������� ������ ���� �������� �� ������� ��� �����.
5.	�������� ������� Contacts (ContactId, LastName, FirstName, PersonalPhone, WorkPhone, Email, PreferableNumber). �������� ������, �� ��� ������� ����� � ������� Contacts �������� � ����� PreferableNumber WorkPhone ���� �� ��������, ��� PersonalPhone, ���� ������� ����� �������� �� �������.
6.	�������� ������� OrdersArchive �� ������ �������� Orders �� �� �������� �������� DeletionDateTime �� DeletedBy. �������� ������, �� ��� �������� ����� � ������� Orders ���� �������� �� � ������� OrdersArchive �� ����������� ������� �������.
7.	�������� ��� �������: TriggerTable1, TriggerTable2 �� TriggerTable3. ����� � ������� �� �������� ���������: TriggerId(int) � ��������� ���� � ��������������, TriggerDate(Date). �������� ��� �������. ������ ������ ������� ��� ����-����� ����� � ������� TriggerTable1 ������ ���� ������ � ������� TriggerTable2. ������ ������ ������� ��� ����-����� ����� � ������� TriggerTable2 ������ ���� ������ � ������� TriggerTable3. ����� ������ ������ ��������� �� ��������� TriggerTable3 �� TriggerTable1. ������� ���� ����� � ������� TriggerTable1. ��������, �� �������� � �������� �� ����. ���� �� �������?

*/
/* �������� 1*/
  SELECT sys.tables.name, sys.sysindexes.rows
    FROM sys.tables
  INNER JOIN sys.sysindexes ON
	sys.tables.object_id = sys.sysindexes.id
	AND sys.sysindexes.indid < 2;  /* ������� ������� */



/* �������� 2*/
DECLARE @name NVARCHAR(155);
DECLARE @query NVARCHAR(155);

DECLARE User CURSOR FOR
    SELECT name
    FROM SYS.SYSUSERS
    WHERE sid IS NOT NULL AND issqluser = 1;

OPEN User
    FETCH NEXT
    FROM Users
    INTO @name WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @query = 'GRANT SELECT ON DATABASE::Northwind TO ' + @name + ';';
        EXEC (@query);

        FETCH NEXT
        FROM User
        INTO @name;
    END;

CLOSE User;
DEALLOCATE User;




/* �������� 3*/
DECLARE @IN VARCHAR (100)
DECLARE @CURSOR CURSOR

SET @CURSOR  = CURSOR SCROLL
FOR
SELECT TABLE_NAME  
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_NAME LIKE 'prod[_]%';

OPEN @CURSOR

FETCH NEXT FROM @CURSOR INTO @IN

WHILE @@FETCH_STATUS = 0
BEGIN
DENY ALL ON @IN TO TestUser;
FETCH NEXT FROM @CURSOR INTO @IN
END

CLOSE @CURSOR;



/* �������� 4*/
CREATE TRIGGER  Number ON Customers
FOR INSERT
	AS
	BEGIN
	    DECLARE @person_id NCHAR(10);
		DECLARE @number VARCHAR(30);
		

		SELECT  
		@number = inserted.Phone,
		@person_id = inserted.CustomerID
			FROM inserted;


		DECLARE @counter INT;
		SET @counter = PATINDEX('%[^0-9]%', @number);

		WHILE @counter != 0
		BEGIN
			SET @number = STUFF(@number, @counter, 1, '');
			SET @counter = PATINDEX('%[^0-9]%', @number);
		END;

		UPDATE Customers 
		SET Customers.Phone = @number
			WHERE Customers.CustomerID = @person_id;
	END;


/* �������� 5*/

CREATE TABLE Contacts
	(
		ContactId INT            NOT NULL       PRIMARY KEY IDENTITY(1, 1),
		LastName CHAR(50)        NOT NULL,
		FirstName CHAR(50)       NOT NULL,
		PersonalPhone CHAR(15)   NOT NULL,
		WorkPhone CHAR(15)       NOT NULL,
		Email CHAR(50)           NOT NULL,
		PreferableNumber CHAR(30)NOT NULL
	);



CREATE TRIGGER ContactsPreferableNumber ON Contacts 
FOR INSERT
	AS
	BEGIN
	    DECLARE @personal_phone CHAR(15);
		DECLARE @contact_id INT;
		DECLARE @work_phone CHAR(15);

		SELECT 
		        @personal_phone = inserted.PersonalPhone,
		        @contact_id = inserted.ContactId,
		    	@work_phone = inserted.WorkPhone
				FROM inserted;

		UPDATE Contacts
		 SET PreferableNumber = 
			CASE
				WHEN @work_phone IS NOT NULL THEN @work_phone
				ELSE @personal_phone
			END
			WHERE Contacts.ContactID = @contact_id;
	END;
	


/* �������� 6*/	 
SELECT * INTO OrdersArchive FROM Orders 
WHERE 0 = 1; --������� �������

ALTER TABLE OrdersArchive
	DROP COLUMN OrderID;

ALTER TABLE OrdersArchive ADD   -- + ��������
	OrderID           INT NOT NULL,
	DeletionDateTime  DATETIME,
	DeteledBy         NVARCHAR(132);

CREATE TRIGGER delete_row  ON  Orders
FOR DELETE
	AS
	BEGIN
		INSERT INTO OrdersArchive
			SELECT
				CustomerID,
				EmployeeID,
				OrderDate,
				RequiredDate,
				ShippedDate,
				ShipVia,
				Freight,
				ShipName,
				ShipAddress,
				ShipCity,
				ShipRegion,
				ShipPostalCode,
				ShipCountry,
				OrderID,
				GETDATE(),
				SUSER_NAME()
				FROM deleted;
	END;


/* �������� 7*/
CREATE TABLE TriggerTable1
	(
		TriggerID   INT NOT NULL    PRIMARY KEY IDENTITY(1, 1),
		TriggerDate DATE NOT NULL
	);

CREATE TABLE TriggerTable2
	(
		TriggerID   INT NOT NULL    PRIMARY KEY IDENTITY(1, 1),
		TriggerDate DATE NOT NULL
	);

CREATE TABLE TriggerTable3
	(
		TriggerID   INT NOT NULL    PRIMARY KEY IDENTITY(1, 1),
		TriggerDate DATE NOT NULL
	);
GO


CREATE TRIGGER FirstTrigger ON TriggerTable1
FOR INSERT
	AS
	BEGIN
		INSERT INTO TriggerTable2 (TriggerTable2.TriggerDate)VALUES  -- �������
			(CAST(GETDATE() AS DATE));
	END;
GO

CREATE TRIGGER SecondTrigger ON TriggerTable2
FOR INSERT
	AS
	BEGIN
		INSERT INTO TriggerTable3 (TriggerTable3.TriggerDate)VALUES
			(CAST(GETDATE() AS DATE));
	END;
GO

CREATE TRIGGER ThirdTrigger ON TriggerTable3
FOR INSERT
	AS
	BEGIN
		INSERT INTO TriggerTable1 (TriggerTable1.TriggerDate)VALUES
			(CAST(GETDATE() AS DATE));
	END;
GO

INSERT INTO TriggerTable1 (TriggerTable1.TriggerDate)VALUES
			(CAST(GETDATE() AS DATE));     --  �������� ��������

/*
�������� ������������ ������� ����������� ���������  �������� (����������� 32).
������� ������ ������� ��������  , ��� ���������� ������������ ���������� �����
���������� ������������

�� ������� ���� , �� ��� ������� ������ �� ����� � ���������� ���� ������
*/
	