# Celebal_Technologies_Internship_Assignments

## WEEK 1 Assignment :-

### Summary :
This SQL assignment, given during my internship, involved querying a transactional database modeled on a retail or e-commerce setup. It aimed to extract and analyze structured data across customers, orders, products, employees, and sales. The 42 queries tested core SQL skills filtering, sorting, grouping, joins, and subqueries through real world business scenarios like identifying top customers, tracking product performance, and calculating revenue. Overall, it provided hands on experience in business data analysis aligned with data-driven decision making.

### Data Source :
Adventure work 2022 dataset from SSMS.

### Problem Statements :
#### Q1 : List of all customers
#### Q2 : List of all customers where company name ending in N
#### Q3 : List of all customers who live in Berlin or London
#### Q4 : List of all customers who live in UK or USA
#### Q5 : List of all products sorted by product name
#### Q6 : List of all products where product name starts with an A
![Screenshot 2025-06-08 190740](https://github.com/user-attachments/assets/af1ec4f4-b8e4-4595-a2c0-ce3f5d33b4ed)
#### Q7 : List of customers who ever placed an order
#### Q8 : List of customers who live in London and have bought chai
#### Q9 : List of customers who never place an order
#### Q10 : List of customers who ordered Tofu
#### Q11 : Details of first order of the system
#### Q12 : Find the details of most expensive order date
#### Q13 : For each order get the OrderID and Average quantity of items in that order
#### Q14 : For each order get the orderID, minimum quantity and maximum quantity for that order
#### Q15 : Get a list of all managers and total number of employees who report to them
![Screenshot 2025-06-08 191157](https://github.com/user-attachments/assets/2fe687a7-403a-4bca-be05-ad1dc2408236)
#### Q16 : Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
#### Q17 : List of all orders placed on or after 1996/12/31
#### Q18 : List of all orders shipped to Canada
#### Q19 : List of all orders with order total > 200
#### Q20 : List of countries and sales made in each country
![Screenshot 2025-06-08 191325](https://github.com/user-attachments/assets/f5ce078b-49e8-41aa-a6de-37c0fae3a6f5)
#### Q21 : List of Customer ContactName and number of orders they placed
#### Q22 : List of customer contactnames who have placed more than 3 orders
#### Q23 : List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
#### Q24 : List of employee Firstname, Lastname, supervisor Firstname, Lastname
#### Q25 : List of Employees id and total sale conducted by employee
#### Q26 : List of employees whose FirstName contains character a
![Screenshot 2025-06-08 191503](https://github.com/user-attachments/assets/9cdefda8-3494-457c-bcfc-977441263a96)
#### Q27 : List of managers who have more than four people reporting to them
#### Q28 : List of Orders and ProductNames
#### Q29 : List of orders place by the best customer
#### Q30 : List of orders placed by customers who do not have a Fax number
#### Q31 : List of Postal codes where the product Tofu was shipped
#### Q32 : List of product names that were shipped to France
#### Q33 : List of discontinued product categories for the supplier 'Specialty Biscuits, Ltd.'
![Screenshot 2025-06-08 191648](https://github.com/user-attachments/assets/4dd361c6-9001-40a6-9f39-8e8f99d634d3)
#### Q34 : List of customers who ordered
#### Q35 : List of products where units in stock is less than 10 and units on order are 0.
#### Q36 : List of top 10 countries by sales
#### Q37 : Number of orders each employee has taken for customers with CustomerIDs between A and AO
#### Q38 : Order date of most expensive order
![Screenshot 2025-06-08 191752](https://github.com/user-attachments/assets/83f0b774-4ec9-413a-9790-9ece9992604e)
#### Q39 : Product name and total revenue from that product
#### Q40 : Supplier ID and number of products offered
#### Q41 : Top ten customers based on their business
#### Q42 : What is the total revenue of the company.
![Screenshot 2025-06-08 191843](https://github.com/user-attachments/assets/76100e0c-0e32-4ad1-876a-3b36d714a5ef)



## WEEK 2 Assignment :-

### Summary : 
This project showcases SQL Server Stored Procedures, Functions, Views, and Triggers for managing order processing in a Northwind-style database. It includes inventory-checked order insertion, flexible updates, secure deletions, date formatting functions, dynamic order views, and triggers for maintaining data integrity and stock validation, with sample data used for testing.

### Data Source :
 AdventureWorks 2022 (with additional test data).

### Problem Statements :
#### 1. Stored Procedures -
➤ Create a procedure InsertOrderDetails that takes OrderID, ProductID, UnitPrice, Quantity, Discount as input parameters and inserts that order information in the Order Details table. After each order inserted, check the @@rowcount value to make sure that order was inserted properly. If for any reason the order was not inserted, print the message: Failed to place the order. Please try again. Also your procedure should have these functionalities 
• Make the UnitPrice and Discount parameters optional.
• If no UnitPrice is given, then use the UnitPrice value from the product table.
• If no Discount is given, then use a discount of 0.
• Adjust the quantity in stock (UnitsInStock) for the product by subtracting the quantity sold from inventory.
• However, if there is not enough of a product in stock, then abort the stored procedure without making any changes to the database.
• Print a message if the quantity in stock of a product drops below its Reorder Level as a result of the update.

➤ Create a procedure UpdateOrderDetails that takes OrderID, ProductID, UnitPrice, Quantity, and discount, and updates these values for that ProductID in that Order. All the parameters except the OrderID and ProductID should be optional so that if the user wants to only update Quantity s/he should be able to do so without providing the rest of the values. You need also to make sure that if any of the values are being passed in as NULL, then you want to retain the original value instead of overwriting it with NULL. To accomplish this, look for the ISNULL() function in google or sql server books online. Adjust the UnitsInStock value in products table accordingly.

➤ Create a procedure GetOrderDetails that takes OrderID as input parameter and returns all the records for that OrderID. If no records are found in Order Details table, then it should print the line: "The OrderID XXXX does not exist", where XXX should be the OrderID entered by user and the procedure should RETURN the value 1.

➤ Create a procedure DeleteOrderDetails that takes OrderID and ProductID and deletes that from Order Details table. Your procedure should validate parameters. It should return an error code (-1) and print a message if the parameters are invalid. Parameters are valid if the given order ID appears in the table and if the given product ID appears in that order.


#### 2. Functions -
Review SQL Server date formats on this website and then create following functions
http://www.sql-server-helper.com/tips/date-formats.aspx

➤ Create a function that takes an input parameter type datetime and returns the date in the format MM/DD/YYYY. For example if I pass in '2006-11-21 23:34:05.920', the output of the functions should be 11/21/2006.


➤ Create a function that takes an input parameter type datetime and returns the date in the format YYYYMMDD.

#### 3. Views -
➤ Create a view vwCustomerOrders which returns CompanyName,OrderID,OrderDate, ProductID,ProductName,Quantity,UnitPrice,Quantity * od.UnitPrice.


➤ Create a copy of the above view and modify it so that it only returns the above information for orders that were placed yesterday.


➤ Use a CREATE VIEW statement to create a view called MyProducts. Your view should contain the ProductID, ProductName, QuantityPerUnit and UnitPrice columns from the Products table. It should also contain the CompanyName column from the Suppliers table and the CategoryName column from the Categories table. Your view should only contain products that are not discontinued.

##### 4. Triggers -
➤ If someone cancels an order in northwind database, then you want to delete that order from the Orders table. But you will not be able to delete that Order before deleting the records from Order Details table for that particular order due to referential integrity constraints. Create an Instead of Delete trigger on Orders table so that if some one tries to delete an Order that trigger gets fired and that trigger should first delete everything in order details table and then delete that order from the Orders table.


➤ When an order is placed for X units of product Y, we must first check the Products table to ensure that there is sufficient stock to fill the order. This trigger will operate on the Order Details table. If sufficient stock exists, then fill the order and decrement X units from the UnitsInStock column in Products. If insufficient stock exists, then refuse the order (i.e. do not insert it) and notify the user that the order could not be filled because of insufficient stock.

• Note: Based on the understanding candidate has to create a sample data to perform these queries.











