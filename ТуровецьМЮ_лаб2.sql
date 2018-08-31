   
  SELECT "TUROVETS MAXIM IP-61";
/* Завдання №1.1

  MS SQL
SELECT COUNT_BIG(*) AS 'Counter' FROM Customers
   PostgreSQL 
 SELECT COUNT(*) FROM [Northwind].[dbo].[Customers] ;

/* Завдання № 1.2*/
   SELECT LENGTH("Turovets");

/* Завдання №1.3*/
   SELECT REPLACE('Turovets Maxim Yurievich', ' ', '_') AS Probel;

/* Завдання №1.4*/
   SELECT CONCAT ( SUBSTRING(LastName,1,2), SUBSTRING(FirstName,1,4), '@Turovets' ) AS Email FROM employees;

/* Завдання №1.5*/
   SELECT DAY('1999-08-04') AS Day_of_the_week;




/* Завдання №2.1*/
		  
		    SELECT * FROM products AS Prod
         LEFT JOIN  categories AS Cat 
            ON Prod.CategoryID = Cat.CategoryID
         LEFT JOIN suppliers AS Sup 
            ON Prod.SupplierID = Sup.SupplierID;
         
/* Завдання №2.2*/       
          
          SELECT * FROM orders
            WHERE (ShippedDate IS NULL) AND
          (OrderDate BETWEEN '1988-04-01' AND '1988-04-30 23:59:59');
      
		
/* Завдання №2.3*/
		      
          SELECT DISTINCT LastName,FirstName
           FROM employees AS EMP

          INNER JOIN employeeterritories AS EMPT 
             ON EMP.EmployeeID = EMPT.EmployeeID

          INNER JOIN territories AS TER 
             ON TER.TerritoryID = EMPT.TerritoryID
          
          INNER JOIN region AS REG 
             ON TER.RegionID = REG.RegionID
          WHERE REG.RegionDescription = 'Northern';


/* Завдання №2.4*/
	
          SELECT SUM(UnitPrice * (1 - Discount) * Quantity) AS Suma   
           FROM `order details`  AS ORDD
          INNER JOIN orders AS ORRD 
             ON ORRD.OrderID = ORDD.OrderID
          WHERE (DAY(ORRD.OrderDate) % 2 = 1);



/* Завдання №2.5*/
	 
          SELECT ShipAddress
           FROM orders
          LIMIT 1;
          WHERE OrderID IN
			  (SELECT OrderID
			  FROM `order details` 
          WHERE UnitPrice * Quantity * (1 - Discount) = (SELECT MAX(UnitPrice * Quantity * (1 - Discount)) 
			  FROM `order details`))
			  

