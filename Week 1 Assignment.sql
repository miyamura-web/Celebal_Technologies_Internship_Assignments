-- Q1:- 
select * from Sales.Customer as c;   -- It has both individual and store customers
select * from Person.Person as p;    -- Contains personal details of individual customers
select * from Sales.Store as s;      -- Contains store customer information

select c.CustomerID, c.TerritoryID, p.FirstName, p.LastName, s.Name as StoreName
from Sales.Customer as c  
left join Person.Person as p on c.PersonID = p.BusinessEntityID
left join Sales.Store as s on c.StoreID = s.BusinessEntityID
order by CustomerID asc;             -- To see from the first CUSTOMER ID

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2:-
select Name as CompanyName from sales.store where Name like '%N'   -- this gives only stores ends with 'n' not the customer who are linked with that store

select  c.CustomerID, s.Name AS CompanyName from Sales.Customer c
join Sales.Store s on c.StoreID = s.BusinessEntityID
where s.Name LIKE '%N'
order by CustomerID asc;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3:-
select * from Person.Address;                                -- it shows persons corresponding addresses
select * from Person.BusinessEntityAddress;                  -- it links customer or store to a address
select * from Person.person;                                 -- It has name and also commomon column i.e bussiness entity id
select * from Sales.Customer;                                -- Individual or store customers

select c.CustomerID, p.FirstName,  p.LastName,  a.City from Sales.Customer c
join person.person as p on p.BusinessEntityID = c.PersonID     -- To get individual customers details not stores as person id have only individula customers data
join Person.BusinessEntityAddress as ba on ba.BusinessEntityID = p.BusinessEntityID   -- This joins the person to their addresses
join Person.Address as a on a.AddressID = ba.AddressID         -- Joins actual address details
where a.city in ('Berlin','London')
order by CustomerID asc;

----------------------------------------------------------------------------------------------------------------------------------------------

-- Q4:-
select * from Person.StateProvince;                -- Have state name with code
select * from Person.CountryRegion;                -- Have country name with code

select c.CustomerID,
COALESCE(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName,       -- COALESCE returns the first non null value, If the person exists then returns their full name else returns the store name. In Customer name that will be saved
a.City,
sp.Name AS StateProvince,
cr.Name AS CountryRegion
from Sales.Customer as c
left join Person.Person as p on c.PersonID = p.BusinessEntityID
left join Sales.Store as s on c.StoreID = s.BusinessEntityID
join Person.BusinessEntityAddress as ba on c.CustomerID = ba.BusinessEntityID
join Person.Address as a on ba.AddressID = a.AddressID
join Person.StateProvince as sp on a.StateProvinceID = sp.StateProvinceID              -- To retrieve the name of the state or province as both had state ID
join Person.CountryRegion as cr on sp.CountryRegionCode = cr.CountryRegionCode         -- To get the country name where the address belongs
where cr.Name IN ('United Kingdom', 'United States')
order by CustomerID asc;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q5:-
select * from Production.Product    -- Have the all products details
order by Name;

select ProductID,ProductNumber, Name as ProductName from Production.Product         -- If want specifically just about the products

---------------------------------------------------------------------------------------------------------------------------------------------------
 -- Q6:-
 select ProductID, ProductNumber, Name as ProductName from Production.Product where Name like 'A%'
 order by ProductID;

 --------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q7:-
 select * from sales.customer;
 select * from person.person;
 select * from sales.store;
 select * from Sales.SalesOrderHeader;

select distinct  c.CustomerID,
COALESCE(p.FirstName + ' ' + p.LastName, s.Name) as CustomerName      -- COALESCE returns the first non null value, If the person exists then returns their full name else returns the store name. In Customer name that will be saved
from sales.customer as c
left join Person.Person as p on c.PersonID = p.BusinessEntityID       -- Joins Person and Store because a customer can be either a person or a store
left join Sales.Store as s on c.StoreID = s.BusinessEntityID
join Sales.SalesOrderHeader as soh on c.CustomerID = soh.CustomerID   -- ensures that only customers who placed at least one order are included
order by CustomerID;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8:-
select ProductID, Name from Production.Product where Name like '%Chai%'; -- 'chai' does not exist in the datset

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q9:-
select c.CustomerID,
COALESCE(p.FirstName + ' ' + p.LastName, s.Name) as CustomerName
from Sales.Customer c
left join Sales.SalesOrderHeader as soh on c.CustomerID = soh.CustomerID     -- It joins customers if they order atleast one time
left join Person.Person as p on c.PersonID = p.BusinessEntityID              -- Same as before
left join Sales.Store as s on c.StoreID = s.BusinessEntityID
where soh.SalesOrderID IS NULL       -- This will give customer who have not placed order, cause earlier joined them and the null will represent what we want
order by CustomerName;        -- This time listed by alphabetically

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q10:-
select ProductID, Name from Production.Product where Name like '%Tofu%';  -- 'Tofu' does not exist

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q11:-
select * from Sales.SalesOrderHeader;   -- It has the order date
select * from Sales.SalesOrderDetail;   -- It has product id, quantity, price
select * from Production.Product;       -- It have the product name

select soh.SalesOrderID,soh.OrderDate,soh.CustomerID,pp.Name as ProductName, sod.ProductID, sod.OrderQty, sod.UnitPrice from Sales.SalesOrderHeader as soh
join Sales.SalesOrderDetail as sod on sod.SalesOrderID = soh.SalesOrderID
join Production.Product as pp on pp.ProductID = sod.ProductID   -- It will give me the product name
order by soh.OrderDate asc;   -- It gives the first order date

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q12:- 
select OrderDate, sum(TotalDue) as TotalSale from Sales.SalesOrderHeader     -- As tottal due is combination of subtottal, tax and freight
group by OrderDate     -- It will group all similar date, and 'sum' will add those values and returns the total value of that specific data
order by TotalSale desc;    -- It show the highest to lowest sale aka the expensive date to less expensive date

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q13:-
select SalesOrderID as OrderID, avg(OrderQty) as AvgOrderQty from Sales.SalesOrderDetail
group by SalesOrderID         -- Same reason as above to group the same order id and do avg
order by SalesOrderID;

---------------------------------------------------------------------------------------------------------------------------------------------

-- Q14:-
select SalesOrderID as OrderID, min(OrderQty) as MinOrderQty, max(OrderQty) as MaxOrderQty from Sales.SalesOrderDetail
group by SalesOrderID         -- Same reason as above to group the same order id and do avg
order by SalesOrderID;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q15:-
select * from HumanResources.Employee;     -- It has the job title, to find out managers
select * from person.person;               -- It have the names

select m.BusinessEntityID as ManagerID, 
p.FirstName + ' ' + p.LastName as ManagerName,
count(e.BusinessEntityID) as TotalEmployees        -- Counting employess based on the id
from HumanResources.Employee as e
join HumanResources.Employee as m on m.OrganizationNode = e.OrganizationNode.GetAncestor(1)     -- It compare the same node from the same table and link direct to manager, because of 'get ancestor(1)' it finds one level up
join person.person as p on p.BusinessEntityID = m.BusinessEntityID     -- To get the names
group by m.BusinessEntityID, p.FirstName, P.LastName     -- Same reason as above to make gruop based on these factors
order by ManagerName;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q16:-
select * from Sales.SalesOrderDetail

select SalesOrderID AS OrderID, sum(OrderQty) as TotalQty from Sales.SalesOrderDetail        -- sum up all order qty and group by will seperate them by order id
group by SalesOrderID having sum(OrderQty) > 300    -- 'having' clause cause it filters group after aggregation
order by TotalQty desc;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q17:-
select * from Sales.SalesOrderHeader;      --It has the order date

select SalesOrderID as OrderID, OrderDate,CustomerID, SalesPersonID from Sales.SalesOrderHeader
where OrderDate >= '1996-12-31'
order by OrderDate;

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q18:-
select * from Sales.SalesOrderHeader;    -- It have order id, date
select * from Person.Address;            -- It have address line, city
select * from Person.StateProvince;      -- It have privincce name
select * from Person.CountryRegion;      -- It have country name which should be canada

select soh.SalesOrderID,soh.OrderDate,a.AddressLine1,a.City, sp.Name as StateProvince,cr.Name as Country
from Sales.SalesOrderHeader as soh
join Person.Address AS a on a.AddressID = soh.ShipToAddressID
join person.StateProvince as sp on sp.StateProvinceID = a.StateProvinceID
join person.CountryRegion as cr on cr.CountryRegionCode = sp.CountryRegionCode    -- Just connected them all by joining
where cr.Name = 'Canada'         -- Then filtered by canada
order by soh.SalesOrderID;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q19:-
select * from Sales.SalesOrderHeader

select SalesOrderID AS OrderID, OrderDate, CustomerID, TotalDue from Sales.SalesOrderHeader
where TotalDue > 200
order by OrderID desc;

---------------------------------------------------------------------------------------------------------------------------------------------------------------  
 
 -- Q20:-
 select * from Sales.SalesOrderHeader;        -- It contains order and total due info
 select * from Person.Address;                -- It contains address info
 select * from Person.StateProvince;          -- It contains state and country info
 select * from Person.CountryRegion;          -- It contains country names

 select cr.Name as Country, isnull(sum(soh.TotalDue),0) as TotalSales      -- ISNULL(.., 0) to show 0 for countries with no sales.
 from Person.CountryRegion as cr
 left join Person.StateProvince as sp on sp.CountryRegionCode = cr.CountryRegionCode
 left join Person.Address as a on a.StateProvinceID = sp.StateProvinceID
 left join Sales.SalesOrderHeader as soh on soh.BillToAddressID = a.AddressID
 group by cr.Name
 order by TotalSales desc;

 -----------------------------------------------------------------------------------------------------------------------------------------------

 -- Q21:-
 select * from person.person;                  -- It have the customer name
 select * from Sales.SalesOrderHeader;         -- It have customer id, order details
 select * from Sales.Store;                    -- It have Store customer info
 select * from Sales.Customer;                 -- It have customer info

select soh.customerID, 
COALESCE (p.FirstName+''+p.LastName, s.Name) as CustomerName,
count(soH.SalesOrderID) as NumberOfOrders      -- It gives no. of orders per customers
from Sales.SalesOrderHeader as soh
left join Sales.Customer as c on c.CustomerID = soh.CustomerID
left join person.person as p on p.BusinessEntityID = c.PersonID
left join Sales.Store as s on s.BusinessEntityID = c.StoreID        -- Left join cause want both customer and store customers
group by soh.customerID,
COALESCE (p.FirstName+''+p.LastName, s.Name)
order by NumberOfOrders desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- Q22:-
select soh.customerID, 
COALESCE (p.FirstName+''+p.LastName, s.Name) as CustomerName,
count(soH.SalesOrderID) as NumberOfOrders      -- It gives no. of orders per customers
from Sales.SalesOrderHeader as soh
left join Sales.Customer as c on c.CustomerID = soh.CustomerID
left join person.person as p on p.BusinessEntityID = c.PersonID
left join Sales.Store as s on s.BusinessEntityID = c.StoreID        -- Left join cause want both customer and store customers
group by soh.customerID,
COALESCE (p.FirstName+''+p.LastName, s.Name)
HAVING count(soH.SalesOrderID) > 3             -- It will give more than 3 orders, as aggregate so used having clause
order by NumberOfOrders desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- Q23:-
select * from Sales.SalesOrderHeader       -- It have order dates
select * from Production.Product           -- It have product info
select * from Sales.SalesOrderDetail       -- It have order details 

select distinct p.ProductID, p.Name as ProductName, p.DiscontinuedDate, soh.OrderDate       -- 'Distinct' cause want each product only once
from Production.Product as p
join Sales.SalesOrderDetail as sod on sod.ProductID = p.ProductID
join Sales.SalesOrderHeader as soh on soh.SalesOrderID = sod.SalesOrderID
where soh.OrderDate > '1997-01-01' and soh.OrderDate < '1998-01-01'
and p.DiscontinuedDate is not null            -- It filters only discontinued products which have values
order by p.Name;


select min(OrderDate), max(OrderDate) from Sales.SalesOrderHeader;   -- Don't have data from that range to show

-------------------------------------------------------------------------------------------------------------------------------

-- Q24:- 
select * from HumanResources.Employee;           -- It have employee info
select * from person.person;                     -- It have  names

select e.BusinessEntityID as EmployeeID,
pe.FirstName as EmployeeFirstName,
pe.LastName as EmployeeLastName,
ps.FirstName as SupervisorFirstName,
ps.LastName as SupervisorLastName
from HumanResources.Employee as e
join Person.Person as pe on pe.BusinessEntityID = e.BusinessEntityID       -- To get actual human names cause 'HumanResources.Employee' stores only id
left join HumanResources.Employee as hre on hre.OrganizationNode = e.OrganizationNode.GetAncestor(1)           -- It above employee node
left join person.person as ps on ps.BusinessEntityID = hre.BusinessEntityID       -- To get supervisors name
order by SupervisorFirstName, EmployeeFirstName;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q25:-
select SalesPersonID as EmployeeID, sum(TotalDue) as TotalSales from Sales.SalesOrderHeader
group by SalesPersonID
order by TotalSales desc;
-- Null can be reason of orders with no salesperson assigned

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q26:-
select * from HumanResources.Employee;           -- It have employee info
select * from person.person;                     -- It have  names

select p.BusinessEntityID as EmployeeID, p.FirstName from person.person as p
join HumanResources.Employee as e on e.BusinessEntityID = p.BusinessEntityID
where p.FirstName like '%a%'    -- It wiil give any name which contains leter a
order by EmployeeID asc;

-----------------------------------------------------------------------------------------------------

-- Q27:-  (Copied from Q15)

select m.BusinessEntityID as ManagerID, 
p.FirstName + ' ' + p.LastName as ManagerName,
count(e.BusinessEntityID) as TotalEmployees        -- Counting employess based on the id
from HumanResources.Employee as e
join HumanResources.Employee as m on m.OrganizationNode = e.OrganizationNode.GetAncestor(1)     -- It compare the same node from the same table and link direct to manager, because of 'get ancestor(1)' it finds one level up
join person.person as p on p.BusinessEntityID = m.BusinessEntityID     -- To get the names
group by m.BusinessEntityID, p.FirstName, P.LastName     -- Same reason as above to make gruop based on these factors
having count(e.BusinessEntityID) > 4 
order by ManagerName;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q28:-
select * from Production.Product       -- It have product names
select * from Sales.SalesOrderHeader
select * from Sales.SalesOrderDetail   -- For joining purpose

select soh.SalesOrderID as OrderID, p.Name as ProductName, soh.OrderDate from Sales.SalesOrderHeader as soh
join Sales.SalesOrderDetail as sod on sod.SalesOrderID = soh.SalesOrderID
join Production.Product as p on p.ProductID = sod.ProductID
order by soh.SalesOrderID;

-----------------------------------------------------------------------------------------------------------------------------------

-- Q29:- Here i suppose best customer is the customer wtih the most most purchased or bought products which is similar to total due
select * from Sales.SalesOrderHeader

select CustomerID, SalesOrderID, OrderDate,TotalDue as TotalPurchased from Sales.SalesOrderHeader
where CustomerID = (
select top 1 CustomerID from Sales.SalesOrderHeader          -- Inside the bracket gives top 1% most spending customer id
group by CustomerID 
order by sum(TotalDue) desc)
order by TotalPurchased desc;

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q30:- Sorry, I did not find any col with Fax number ;)...

--------------------------------------------------------------------------------------------------------------------------------------------------

-- Q31:- From Q10 ( There is no such product as tofu in the data set)

SELECT ProductID, Name FROM Production.Product WHERE Name LIKE '%Tofu%';  -- 'Tofu' does not exist

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q32:-
select * from Sales.SalesOrderHeader
select * from Person.Address                 -- It have shipping addres
select * from Sales.SalesOrderDetail         -- To get product id for each order
select * from Production.Product             -- It have product names
select * from person.StateProvince           -- To join purpose, to have country
select * from person.CountryRegion           -- To join purpose

select distinct p.Name as ProductName, cr.Name as CountryName from Production.Product as p      -- 'Distinct' to ensure no product repeat second time if shipped to france
join Sales.SalesOrderDetail as sod on sod.ProductID = p.ProductID
join Sales.SalesOrderHeader as soh on soh.SalesOrderID = sod.SalesOrderID
join Person.Address as a on a.AddressID = soh.ShipToAddressID
join person.StateProvince as sp on sp.StateProvinceID = a.StateProvinceID
join person.CountryRegion as cr on cr.CountryRegionCode = sp.CountryRegionCode           -- Have to do multiple joins to connect the country with product name
where cr.Name = 'France'
order by p.Name;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q33:-

select * from Purchasing.Vendor

select BusinessEntityID, Name from  Purchasing.Vendor
where name like 's%';     -- Ther is no supplier as ''Specialty Biscuits, Ltd.'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q34:- Full copied from  Q7 as both want same reult
select distinct
    c.CustomerID,
    COALESCE(p.FirstName + ' ' + p.LastName, s.Name) as CustomerName      -- COALESCE returns the first non null value, If the person exists then returns their full name else returns the store name. In Customer name that will be saved
from sales.customer as c
left join Person.Person as p on c.PersonID = p.BusinessEntityID       -- Joins Person and Store because a customer can be either a person or a store
left join Sales.Store as s on c.StoreID = s.BusinessEntityID
join Sales.SalesOrderHeader as soh on c.CustomerID = soh.CustomerID   -- ensures that only customers who placed at least one order are included
order by CustomerID;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q35:-
select * from Production.ProductInventory         -- Inventory have stock data
select * from Sales.SalesOrderDetail

select p.ProductID, p.Name AS ProductName,  pi.Quantity as StockQty, sod.OrderQty from Production.Product as p
join Production.ProductInventory as pi on pi.ProductID = p.ProductID
join Sales.SalesOrderDetail as sod on sod.ProductID = pi.ProductID
where pi.Quantity <10 
order by pi.Quantity desc;   
-- It will show how much stock (which are less than 10) we have about the product which have ordered

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q36:- Copied from Q20 ( as want same result)

select top 10 cr.Name as Country, isnull(sum(soh.TotalDue),0) as TotalSales      -- ISNULL(.., 0) to show 0 for countries with no sales.
from Person.CountryRegion as cr
left join Person.StateProvince as sp on sp.CountryRegionCode = cr.CountryRegionCode
left join Person.Address as a on a.StateProvinceID = sp.StateProvinceID
left join Sales.SalesOrderHeader as soh on soh.BillToAddressID = a.AddressID
group by cr.Name
order by TotalSales desc;

 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q37:- Well customer id is int value not a string, and A,AO are str so its not possible, please provide the exact question ;)...

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q38:-

select TOP 1  SalesOrderID, OrderDate, TotalDue as TotalSale from Sales.SalesOrderHeader                               
order by TotalDue desc;                 -- It gives highest individual product 

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q39:-
select * from Production.Product                 -- It have product name
select * from Sales. SalesOrderDetail            -- It have total revvenue in Line Total col, as it indicate revnue for that product line

select p.Name as ProductName, sum(Sod.LineTotal) as TotalRevenue from Production.Product as p
join Sales. SalesOrderDetail as sod on sod.ProductID = p.ProductID
group by p.Name                                  -- Grouped the same product and sum helps to find tottal revenue from that particular product
order by TotalRevenue desc;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q40:-
select * from Purchasing.ProductVendor             -- This table has Business entity id which represents supplier as the table name indicate(product vendor), that means in this table the business entity id are representing suppliers
select * from Purchasing.Vendor                    -- It has the supplier name

select v.name as SupplierName, v.BusinessEntityID as SupplierID, count(pv.ProductID) as NoOfProductsOffered  from Purchasing.Vendor as v
join Purchasing.ProductVendor  as Pv on Pv.BusinessEntityID = v.BusinessEntityID
group by v.BusinessEntityID, v.Name               -- count will say no of products and group by seperate them based on business entity id and name
order by  NoOfProductsOffered desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--  Q41:-
select * from sales.SalesOrderHeader              -- It have have total due, means they stores spends
select * from sales.Store                         -- It have their name
select * from Sales.Customer                      --  For joining purpose


select top 10 c.CustomerID, s.Name, sum(soh.TotalDue) as TotalPurchased from Sales.Customer as c
join sales.Store as s on s.BusinessEntityID = c.StoreID
join sales.SalesOrderHeader as soh on soh.CustomerID = c.CustomerID
group by c.customerID, s.Name                     -- same reason as above
order by TotalPurchased desc;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q42:-

select sum(TotalDue) as TotalRevenue from sales.SalesOrderHeader

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- I would appreciate your feedback on my work and any suggestions to improve it :)