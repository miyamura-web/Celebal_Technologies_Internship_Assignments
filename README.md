# Celebal_Technologies_Internship_Assignments

## WEEK 1 Assignment :-

### Summary :
This SQL assignment, given during my internship, involved querying a transactional database modeled on a retail or e-commerce setup. It aimed to extract and analyze structured data across customers, orders, products, employees, and sales. The 42 queries tested core SQL skills filtering, sorting, grouping, joins, and subqueries through real world business scenarios like identifying top customers, tracking product performance, and calculating revenue. Overall, it provided hands on experience in business data analysis aligned with data-driven decision making.

### Data Source :
Adventure work 2022 dataset from SSMS.

### Problem Statements :
See the attach file "Problem Statements - Level A Task ( Week 1 )"



## WEEK 2 Assignment :-

### Summary : 
This project showcases SQL Server Stored Procedures, Functions, Views, and Triggers for managing order processing in a Northwind-style database. It includes inventory-checked order insertion, flexible updates, secure deletions, date formatting functions, dynamic order views, and triggers for maintaining data integrity and stock validation, with sample data used for testing.

### Data Source :
 AdventureWorks 2022 database and Northwind database (with additional test data).

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


##### 4. Triggers -
➤ If someone cancels an order in northwind database, then you want to delete that order from the Orders table. But you will not be able to delete that Order before deleting the records from Order Details table for that particular order due to referential integrity constraints. Create an Instead of Delete trigger on Orders table so that if some one tries to delete an Order that trigger gets fired and that trigger should first delete everything in order details table and then delete that order from the Orders table.


➤ When an order is placed for X units of product Y, we must first check the Products table to ensure that there is sufficient stock to fill the order. This trigger will operate on the Order Details table. If sufficient stock exists, then fill the order and decrement X units from the UnitsInStock column in Products. If insufficient stock exists, then refuse the order (i.e. do not insert it) and notify the user that the order could not be filled because of insufficient stock.

• Note: Based on the understanding candidate has to create a sample data to perform these queries.











