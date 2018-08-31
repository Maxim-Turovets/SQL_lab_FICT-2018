/*
1.	Додати себе як співробітника компанії на позицію Intern.
2.	Змінити свою посаду на Director. 
3.	Скопіювати таблицю Orders в таблицю OrdersArchive.
4.	Очистити таблицю OrdersArchive.
5.	Не видаляючи таблицю OrdersArchive, наповнити її інформацією повторно.
6.	З таблиці OrdersArchive видалити усі замовлення, що були зроблені замовниками із Берліну.
7.	Внести в базу два продукти з власним іменем та іменем групи.
8.	Помітити продукти, що не фігурують в замовленнях, як такі, що більше не виробляються.
9.	Видалити таблицю OrdersArchive.
10.	Видатили базу Northwind.
*/

/* Завдання №1*/
  INSERT INTO employees (LastName, FirstName, Title, Notes)
	  VALUES ('Turovets', 'Maxim', 'Intern','Maxim is a student');
	  
	  
/* Завдання №2*/

  SELECT * FROM employees
   WHERE  FirstName = 'Maxim' AND  LastName = 'Turovets';

  UPDATE employees
   SET Title = 'Director' 
  WHERE   FirstName = 'Maxim' AND LastName = 'Turovets';	 
  
    SELECT * FROM employees
   WHERE  FirstName = 'Maxim' AND  LastName = 'Turovets'; 
   
   
/* Завдання №3*/

  SELECT * INTO OrdersArchive FROM Orders

/* Завдання №4*/
  TRUNCATE TABLE OrdersArchive;


/* Завдання 5 */
  INSERT INTO OrdersArchive 
  SELECT OrderID 
      ,CustomerID
      ,EmployeeID
      ,OrderDate
      ,RequiredDate
      ,ShippedDate
      ,ShipVia
      ,Freight
      ,ShipName
      ,ShipAddress
      ,ShipCity
      ,ShipRegion
      ,ShipPostalCode
      ,ShipCountry FROM Orders;
      
      SELECT * FROM OrdersArchive;     
 
 /* Завдання 6 */
 
 DELETE FROM OrdersArchive
WHERE CustomerID IN (
                        SELECT CustomerID
                        FROM Customers
                        WHERE City LIKE 'Berlin'
                       )
	
	
/* Завдання 7 */
  INSERT INTO Products (ProductName)  
	 VALUES ('Maxim'),('IP-61');	
	 SELECT * FROM Products;
	

/* Завдання 8 */
	UPDATE Products
    SET Discontinued = 1
   WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM `Order Details`)
   
   
       
/* Завдання 9 */
   DROP TABLE OrdersArchive;

/* Завдання 10 */
   DROP DATABASE Northwind;
      
      
