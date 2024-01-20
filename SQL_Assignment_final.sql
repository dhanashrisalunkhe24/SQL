use classicmodels;
-- DAY3 Assignment
-- 3(1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.

  -- ●	State should not contain null values
--   ●   credit limit should be between 50000 and 100000
 
select customerName,state, creditLimit from customers where state is not null and creditLimit between 50000 and 100000 order by creditlimit desc;



-- 3(2)	Show the unique productline values containing the word cars at the end from products table.
select distinct productline from productlines where productline like '%car%';
select * from orders;



-- DAY4 Assignment 

-- 4(1)	Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.
select orderNumber,status, ifnull(comments, '--') as comments from  orders;


-- 4(2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
--  If job title is one among the below conditions, then job title abbreviation column should show below forms.
-- ●	President then “P”
-- ●	Sales Manager / Sale Manager then “SM”
-- ●	Sales Rep then “SR”
-- ●	Containing VP word then “VP”

select employeeNumber,firstName,jobTitle, 
(
case
WHEN jobTitle = 'President' THEN 'P'
WHEN jobTitle LIKE '%Manager%'  THEN 'SM'
WHEN jobTitle =  'Sales Rep' THEN 'SR'
 ELSE 'VP'
END) AS JobTitle_abbr
from employees;

 select * from employees;




--  DAY5 Assignments 
-- 5(1)	For every year, find the minimum amount value from payments table.
select year(paymentDate) as years,min(amount) as minamount from payments group by years order by years asc;


-- 5(2)	For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1, Q2 etc.

select 
	year(orderDate) as years,
concat('Q',quarter(orderDate)) as quarters,
count(distinct customerNumber) as  Unique_Customer,
count(customerNumber) as Total_Orders from orders group by years,quarters order by years,quarters; 


-- 5(3) Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]
select date_format(paymentDate,'%b') as Month,
	concat(round(sum(amount)/ 1000),'k') as formatted_amount
from payments
group by Month
HAVING 
	sum(amount) >= 500000 and sum(amount)<=1000000
order by 
	sum(amount) desc;



-- DAY 6 Assignments
 -- 6(1) Create a journey table with following fields and constraints.

-- ●	Bus_ID (No null values)
-- ●	Bus_Name (No null values)
-- ●	Source_Station (No null values)
-- ●	Destination (No null values)
-- ●	Email (must not contain any duplicates)

 Create database Assignments;
 use Assignments;
 create table  journey (
	BUS_ID INT NOT NULL,
    Bus_Name varchar(10) not null, 
    Source_Station varchar(20) not null,
    Destination varchar(20),
    Email varchar(255) unique not null)
    ;
    select * from journey;
  
  
  -- 6(2) Create vendor table with following fields and constraints.

-- ●	Vendor_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Email (must not contain any duplicates)
-- ●	Country (If no data is available then it should be shown as “N/A”)

  create table Vendor (
	Vendor_ID int unique not null,
    `Name` varchar(20) not null,
    Email varchar(255) unique not null,
    Country varchar (30) not null );
    
 -- 6(3) 	Create movies table with following fields and constraints.

-- ●	Movie_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Release_Year (If no data is available then it should be shown as “-”)
-- ●	Cast (No null values)
-- ●	Gender (Either Male/Female)
-- ●	No_of_shows (Must be a positive number)

 create table movies (
 Movie_ID INT NOT NULL,
 Name varchar(30) not null,
 Release_Year int not null,
 cast varchar(35) not null,
 Gender Enum('male','female'),
 No_of_shows int check (No_of_shows > 0));
 
/*  -- 6(4)4)	Create the following tables. Use auto increment wherever applicable

 a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table

b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location

c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock
*/

  create table product (
  product_id int auto_increment primary key,
  product_name varchar(35) not null unique ,
  description Text(255) ,
  supplier_id int,
  foreign key (supplier_id) references supplier(supplier_id)
);
  create table supplier (
  supplier_id int auto_increment primary key,
  supplier_name varchar(34),
  location varchar(34) );
  
  create table Stock (
  id int auto_increment primary key,
  product_id int , 
  balance_stock varchar(34),
  foreign key (product_id) REFERENCES product(product_id)
  );
  

-- DAY 7 Assignments

 /* -- 7 (1)1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number and sort the data by highest to lowest unique customers.
Tables: Employees, Customers
*/
  use classicmodels;
  select 
  e.employeeNumber,
  concat(e.firstName,' ',lastName) as Sales_Person,
  count(distinct(customerNumber))as Unique_customers
  from customers c 
  left join employees e on c.salesRepEmployeeNumber = e.employeeNumber
  where employeeNumber is not null
  group by employeeNumber
  order by Unique_customers desc;
  
/* 7(2)Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.

Tables: Customers, Orders, Orderdetails, Products
*/

 select c.customerNumber,
 c.customerName,
 c.postalCode,
 p.productName,
 od.quantityOrdered as Ordered_QTY,
 (od.quantityOrdered + p.quantityInStock) as Total_inventory,
 p.quantityInStock as Left_QTY
 FROM customers c
 inner join orders o on c.customerNumber = o.customerNumber
 inner join orderdetails od on o.orderNumber = od.orderNumber
 inner join products p on p.productCode = od.productCode
 order by c.customerNumber;
 
 /*
-- 7(3)	Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.
*/

create table Laptop (Laptop_Name varchar(40));
insert into Laptop values ('DELL');
insert into Laptop  values ('HP');
create TABLE Colours (Colours_Name varchar (40));
insert into Colours values ('White');
insert into Colours values ('Silver');
insert into Colours values ('Black');
select Laptop_Name, Colours_name from Colours
cross join Laptop;

/*-- 7(4)	Create table project with below fields.

●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);	
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
Find out the names of employees and their related managers.

*/
use assignments;
create table project (
	EmployeeID int,
	FullName varchar(30),
	Gender varchar(30),
	ManagerID int
    );
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select * from project;

 SELECT
      M.FullName AS "Manager_Name",
    E.FullName AS "Emp_Name"
FROM Project E
left JOIN Project M ON E.ManagerID = M.EmployeeID
WHERE M.FullName is not null;



	
-- Day8 assignment
/*Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.
*/

use assignments;
create table facility (
	Facility_ID int auto_increment,
	Name varchar(100),
	State varchar(100),
	Country varchar(100),
    primary key (Facility_ID)
    );
    alter table facility 
		add column city varchar(100) not null;

  -- DAY 9 
 /* Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "     Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc.
*/
  use Assignments;
  CREATE table University (
	ID int,
    Name varchar (100));
    INSERT INTO University
     VALUES (1, "     Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
select ID ,replace(replace(replace(Name, ' ','<>'),'><',''),'<>',' ') as Name from University;


-- DAY 10
/*Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.
  */
  
  use Classicmodels;
    create view products_status
    AS
    select 
    year(o.orderDate) as 'YEAR',
    concat(count(d.quantityordered),'(',round((count(d.quantityordered)/
    (select count(quantityordered)from orderdetails))*100),'%',')') as `value`
     from orders o
    join orderdetails d on o.orderNumber = d.orderNumber
    where o.orderNumber = d.orderNumber
    group by YEAR
    order by count(d.quantityordered) desc;
    SELECT * FROM products_status;

    -- Day 11
    
    /*-- 11(1)Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.

Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000
*/

    DELIMITER //
     create procedure GetCustomerLevel(in customer_Number int)
     begin
     SELECT 
     customer_Number,
     (CASE
		when  creditLimit > 100000 then 'Platinum'
        when creditLimit >=25000 then 'gold'
        else 'silver'
        END) as CustomerLevel
	from customers where customerNumber = customer_number;
	end //
	DELIMITER ;
call GetCustomerLevel(496);

/*-- 11(2)Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments
*/

DELIMITER //
CREATE PROCEDURE GET_COUNTRY_PAYMENTS(IN YEAR1 INT,IN COUNTRY1 VARCHAR(20))
BEGIN
select 
year(p.paymentdate) as Year,
c.country as Country,
concat(ROUND(sum(p.amount)/1000),'K') as Total_Amount
from customers C
join payments P
on C.customerNumber = P.customerNumber
where year(p.paymentdate) = YEAR1 and Country = COUNTRY1 
group by year, Country ;
END//
DELIMITER ;

CALL GET_COUNTRY_PAYMENTS (2003,'FRANCE');

 -- Day 12 
/* (1)Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
Table: Orders

 */
 




 use classicmodels;
    SELECT
	YEAR(orderDate) AS Year,
    MONTHNAME(orderDate) AS Month,
    COUNT(orderNumber) AS 'Total Orders',
    CONCAT(ROUND(((COUNT(orderNumber) - LAG(COUNT(orderNumber)) OVER (ORDER BY YEAR(orderDate)))/(LAG(COUNT(orderNumber)) OVER (ORDER BY YEAR(orderDate))))*100,0),'%') AS '%YOY Change'
FROM orders
GROUP BY YEAR(orderDate), MONTHNAME(orderDate);
 
/*-- Day 12 
(2)Create the table emp_udf with below fields.

●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by accepting DOB column as a parameter.

*/

CREATE TABLE emp_udf (
    Emp_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    DOB DATE
);
INSERT INTO emp_udf (Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select * from emp_udf;
use assignments;
DELIMITER //

CREATE FUNCTION calculate_age(dob DATE)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);
    
    SET years = DATEDIFF(CURRENT_DATE(), dob) DIV 365;
    SET months = (DATEDIFF(CURRENT_DATE(), dob) MOD 365) DIV 30;
    
    SET age = CONCAT(years, " years ", months, " months");
    
    RETURN age;
END //

DELIMITER ; 
select 
	Emp_ID,
    Name,
    DOB,
    calculate_age(DOB) as Age from emp_udf;
 
 
 
 -- DAY 13
 /* 
 (1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery

Table: Customers, Orders
*/
 
 SELECT CustomerNumber, CustomerName
FROM customers
WHERE CustomerNumber NOT IN (SELECT CustomerNumber FROM orders);
 
 -- DAY 13
 /*
 (2)Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
Table: Customers, Orders
*/


 use classicmodels;
 SELECT c.CustomerNumber, c.CustomerName, COUNT(o.OrderNumber) AS OrderCount
FROM customers c
LEFT JOIN orders o ON c.CustomerNumber = o.CustomerNumber
GROUP BY c.CustomerNumber, c.CustomerName

UNION

SELECT c.CustomerNumber, c.CustomerName, COUNT(o.OrderNumber) AS OrderCount
FROM customers c
RIGHT JOIN orders o ON c.CustomerNumber = o.CustomerNumber
GROUP BY c.CustomerNumber, c.CustomerName;

-- DAY 13
/*
(3) Show the second highest quantity ordered value for each order number.
Table: Orderdetails
*/

use classicmodels;
select 
orderNumber,
max(quantityOrdered) AS SecondHighestQuantity
from (select OrderNumber, Quantityordered, DENSE_RANK() OVER (PARTITION BY OrderNumber ORDER BY quantityordered DESC) AS Rnk FROM Orderdetails) as RankedData
WHERE Rnk = 2
 group by orderNumber;


-- DAY 13
/*
(4)For each order number count the number of products and then find the min and max of the values among count of orders.
Table: Orderdetails
*/

with OrderProductCounts AS (SELECT OrderNumber, COUNT(*) AS ProductCounts FROM Orderdetails GROUP BY OrderNumber)
SELECT MAX(ProductCounts) AS MaxProductCounts,MIN(ProductCounts) AS MinProductCounts
FROM OrderProductCounts;

  
  
  
  
  -- DAY 13(5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.

  
  SELECT ProductLine, COUNT(*) AS Total FROM Products
WHERE BuyPrice > (SELECT AVG(BuyPrice) FROM Products)
GROUP BY ProductLine order by total desc;


-- DAY 14
/*
Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong
*/
use assignments;
CREATE TABLE Emp_EH (
    EmpID INT AUTO_INCREMENT PRIMARY KEY,
    EmpName VARCHAR(255),
    EmailAddress VARCHAR(255)
);
delimiter //
CREATE PROCEDURE InsertEmp_EH(
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error occurred' AS Message;
    END;

    START TRANSACTION;

    INSERT INTO Emp_EH (EmpName, EmailAddress)
    VALUES (p_EmpName, p_EmailAddress);

    COMMIT;
    SELECT 'Record inserted successfully' AS Message;
END //

DELIMITER ;

CALL InsertEmp_EH('vwefv' , 'amitgaikwad47785@gmail.com');
 
  select * from Emp_EH;
  
  
  
  /*-- DAY 15 
  Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.

*/  
  use assignments;
  
  Create table Emp_BIT (Name varchar(255),Occupation varchar (255),Working_date date,Working_hours int (5));
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
  
DELIMITER //

CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END //
  delimiter ;
  INSERT INTO Emp_BIT VALUES ('Amit', 'Fresher', '2022-01-25', -12);
  
select * from Emp_BIT;
  
  
  
  
  
  
    