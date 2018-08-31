/*
Задача №1:
Виконати наступні завдання:
1.	Використовуючи SELECT двічі, виведіть на екран своє ім’я, прізвище та по-батькові одним результуючим набором.
2.	Порівнявши власний порядковий номер в групі з набором із всіх номерів в групі, вивести на екран ;-) якщо він менший за усі з них, або :-D в протилежному випадку.
3.	Не використовуючи таблиці, вивести на екран прізвище та ім’я усіх дівчат своєї групи за вийнятком тих, хто має спільне ім’я з студентками іншої групи.
4.	Вивести усі рядки з таблиці Numbers (Number INT). Замінити цифру від 0 до 9 на її назву літерами. Якщо цифра більше, або менша за названі, залишити її без змін.
5.	Навести приклад синтаксису декартового об’єднання для вашої СУБД.
Задача №2:
Виконати наступні завдання в контексті бази Northwind:
1.	Вивисти усі замовлення та їх службу доставки. В залежності від ідентифікатора служби доставки, переіменувати її на таку, що відповідає вашому імені, прізвищу, або по-батькові.
2.	Вивести в алфавітному порядку усі країни, що фігурують в адресах клієнтів, працівників, та місцях доставки замовлень.
3.	Вивести прізвище та ім’я працівника, а також кількість замовлень, що він обробив за перший квартал 1998 року.
4.	Використовуючи СTE знайти усі замовлення, в які входять продукти, яких на складі більше 100 одиниць, проте по яким немає максимальних знижок.
5.	Знайти назви усіх продуктів, що не продаються в південному регіоні.
*/
/* Завдання №1.1*/

 /*   SELECT 'Turovets'
     UNION
    SELECT 'Maxim Yurievich';*/

/* Завдання №1.2*/
/* 
Оскільки данної таблиці немає , то вважаємо , що вона вже створена 
Таблиця студентів --StudentsTable
Порядковий номер -- StudentNumber 
IF (SELECT StudentNumber 
     FROM StudentsTable 
	 WHERE Name = 'Maxim' AND Surname = 'Turovets') <  ALL(SELECT StudentNumber FROM StudentsTable)
    PRINT ';-)'
ELSE
    PRINT ':-D'
*/

/* Завдання №1.3*/

WITH `ip-61` (`FirstName`, `LastName`) AS
(
	SELECT 'Veronika' AS "FirstName", 'Bridnya' AS "LastName"
	UNION 
	SELECT 'Lilya' AS "FirstName", 'Khukarec' AS "LastName"
        UNION 
	SELECT 'Vlada' AS "FirstName", 'Lypskaya' AS "LastName"
	UNION 
	SELECT 'Anya' AS "FirstName", 'Tsytsyluik' AS "LastName"
),  `ip-63` (`FirstName`, `LastName`) AS
(
	SELECT 'Vera' AS "FirstName", 'Nikolsky' AS "LastName"
	UNION 
	SELECT 'Lyuda' AS "FirstName", 'Koroleva' AS "LastName"
	UNION 
	SELECT 'Viktoria' AS "FirstName", 'Percova' AS "LastName"
)

SELECT * FROM `ip-61`
WHERE `FirstName` NOT IN (SELECT `FirstName` FROM `ip-63`);
      
/* Завдання №1.4*/ 
/*
SELECT CASE Number
            WHEN 0 THEN 'NULL'
            WHEN 1 THEN 'ONE'
            WHEN 2 THEN 'TWO'
            WHEN 3 THEN 'THREE'
            WHEN 4 THEN 'FOUR'
            WHEN 5 THEN 'FIVE'
            WHEN 6 THEN 'SIX'
            WHEN 7 THEN 'SEVEN'
            WHEN 8 THEN 'EIGHT'
            WHEN 9 THEN 'NINE'
            ELSE CAST(Number AS CHAR(40))
       END AS Number_Big_Size
FROM NumbersTable;   */  

/* Завдання №1.5*/
  SELECT Company.CompanyName  , City.ShipCity
    FROM customers AS Company
  CROSS JOIN
         orders AS City;
         
/* Завдання №2.1*/

  SELECT OrderID ,CustomerID ,EmployeeID ,OrderDate ,RequiredDate ,ShippedDate
        ,ShipVia = CASE ShipVia 
                        WHEN 1 THEN 'Maxim'
                        WHEN 2 THEN 'Turovets'
                        WHEN 3 THEN 'Yurievich'
                        END
		  ,Freight ,ShipName ,ShipAddress ,ShipCity ,ShipRegion ,ShipPostalCode ,ShipCountry
  FROM orders;         

/* Завдання №2.2*/
    SELECT Country FROM customers
     UNION
    SELECT Country FROM employees
     UNION 
    SELECT ShipCountry FROM orders
    ORDER BY Country;          

/* Завдання №2.3*/

   SELECT employees.FirstName, employees.LastName,
    COUNT(orders.OrderID) AS Counter
	FROM employees
	 INNER JOIN orders ON orders.EmployeeID = employees.EmployeeID
		WHERE orders.OrderDate >= '1998:01:01' AND orders.OrderDate < '1998:04:01' -- 3 місяці
	GROUP BY employees.EmployeeID, employees.FirstName, employees.LastName; 


/* Завдання №2.4*/

   ;WITH CTE (OrderID) AS (
                           SELECT DISTINCT OrderID
                            FROM `Order Details` AS Order_Details
                            INNER JOIN  products AS Product                          
			     ON Product.ProductID = Order_Details.ProductID
                            WHERE UnitsInStock > 100
                                 AND Discount < (SELECT MAX(Discount) 
                            FROM `Order Details`)
                          )
   SELECT * FROM orders 
   WHERE OrderID
	 IN (SELECT OrderID FROM CTE)

/* Завдання №2.5*/
-- створюємо нову таблицю
;WITH South_Region (ProductName) AS (    
     SELECT DISTINCT Product.ProductName
    FROM `order details` AS Order_Details
    INNER JOIN orders AS Orders_
      ON Orders_.OrderID = Order_Details.OrderID
    INNER JOIN employees AS Employees_
      ON Employees_.EmployeeID = Orders_.EmployeeID
    INNER JOIN employeeTerritories AS Emp_T 
      ON Employees_.EmployeeID = Emp_T.EmployeeID
    INNER JOIN territories AS Territory 
      ON Territory.TerritoryID = Emp_T.TerritoryID
    INNER JOIN region AS Region_ 
      ON Territory.RegionID = Region_.RegionID
    INNER JOIN products AS Product
      ON Product.ProductID = Order_Details.ProductID
    WHERE Region_.RegionDescription = 'Southern'
	 
)
    SELECT ProductName FROM products
     WHERE ProductName 
	  NOT IN  (SELECT * FROM South_Region);