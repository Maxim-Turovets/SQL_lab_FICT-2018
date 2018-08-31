SELECT "Туровець Максим Юрійович";              /*Завдання №1*/    

SELECT * FROM products;                         /*Завдання №2*/

SELECT * FROM products              
WHERE discontinued=1;                           /*Завдання №3*/ /*я так розумію 1 - це припинено*/

SELECT DISTINCT City FROM Customers;            /*Завдання №4*/

SELECT * FROM Customers
ORDER BY CompanyName DESC;                      /*Завдання №5*/



SELECT                 /*Завдання №6 2 дня знаходив інфу , що імя треба брати в апострофи а не лапки якщо є пробіл */
      OrderID AS '1',
      ProductID AS '2',
      UnitPrice AS '3',
      Quantity AS '4',
      Discount AS '5'
FROM `order details`;


SELECT * FROM Customers
WHERE ContactName LIKE 't%';             /*Завдання №7* імя*/

SELECT * FROM Customers
WHERE ContactName LIKE 'm%';             /*Завдання №7 прізвище*/

SELECT * FROM Customers
WHERE ContactName LIKE 'y%';             /*Завдання №7 імя побатькові*/


SELECT * FROM Orders
WHERE ShipAddress LIKE '% %';            /*Завдання №8 */

SELECT * FROM Products 
WHERE ProductName  REGEXP '[%_].*[Mm]$'   /*Завдання №9 */




