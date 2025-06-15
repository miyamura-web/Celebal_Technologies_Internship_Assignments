-- Stored Functions 
-- Q1 :-

Create procedure InsertOrderDetails @OrderID int, @ProductID int, @UnitPrice money = null, @Quantity int, @Discount float = 0, @SpecialOfferID INT = 1     -- Here unit price and discount are optional
as 
begin 
set nocount on;     -- It will suppress the row count messages (optional)

declare @AvailableQty int;              -- It will check if enough stock is available before inserting
declare @SafetyStockLevel Int;          -- It is the minimum stock level, inventory should not go below this 
declare @ReorderPoint int;              -- When stock drops below this level, the system should signal a need to reorder means the warning message
declare @ActualUnitPrice money;         -- It determines what price will be used for the order means @unitprice or from the product table if not given
declare @LocationID int;                -- To avail dynamic location id not a fixed one

select top 1 @AvailableQty = Quantity, @LocationID = LocationID  from Production.ProductInventory    -- Here getting the stock qty
where ProductID = @ProductID and Quantity >= @Quantity;

select @SafetyStockLevel = SafetyStockLevel, @ReorderPoint = ReorderPoint, @ActualUnitPrice = isnull(@UnitPrice,ListPrice)    -- Here getting the product info
from Production.Product
where ProductID = @ProductID;

if @AvailableQty is null or @ActualUnitPrice is null        -- Here checking if the product exist or not
begin 
print 'Invalid ProductID or stock information unavailable';
return;
end

if @Quantity > @AvailableQty                -- Here checking for stock qty, is sufficient or not
begin
print 'Insufficient stock. Order not placed';
return;
end

Insert into Sales.SalesOrderDetail ( SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount, SpecialOfferID )   -- Inserting that order information into the order table
values ( @OrderID, @ProductID, @Quantity, @ActualUnitPrice, @Discount, @SpecialOfferID );   -- Here special offer id is 1 cause it is a default offer and it consisit only 1 in its all rows

if @@rowcount = 0     -- Checking if order is inserted properly
begin
print 'Failed to place the order. Please try again';
return;
end

update Production.ProductInventory    -- Updating the inventory
set Quantity = Quantity - @Quantity
where ProductID = @ProductID and LocationID = @LocationID;

if exists (                                              -- It will give warning if stock drop below reorderpoint
select 1 from Production.ProductInventory as pi
join Production.Product as p on p.ProductID = pi.ProductID
where pi.ProductID = @ProductID and pi.LocationID = @LocationID and pi.Quantity < p.ReorderPoint )
begin 
print 'Warning: Product stock has dropped below the reorder point';
return;
end

print 'Order placed successfully';
end;



--  Execute InsertOrderDetails     -- To check it
--    @OrderID = 43659, 
--    @ProductID = 776, 
--    @Quantity = 2,
--    @SpecialOfferID = 1;  

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2 :-

Create procedure UpdateOrderDetails @OrderID int, @ProductID int, @UnitPrice money = null, @Quantity int = null, @Discount float = null
as 
begin
set nocount on;    -- same reason as above

declare @OldQty int;   -- To track before and after update
declare @NewQty int;

select @OldQty = OrderQty from Sales.SalesOrderDetail         -- To know how many units originally ordered or current order qty
where SalesOrderID = @OrderID and ProductID = @ProductID;

if @OldQty is null      -- Exit if no matching order found with msg
begin
print 'Order detail not found';
return;
end

update Sales.SalesOrderDetail     -- Updating only non null parameters
set OrderQty = isnull(@Quantity, OrderQty),
UnitPrice = isnull(@UnitPrice, UnitPrice),
UnitPriceDiscount = isnull(@Discount, UnitPriceDiscount)
where SalesOrderID = @OrderID and ProductID = @ProductID;

select @NewQty = OrderQty from Sales.SalesOrderDetail      -- When we will update the qty to get the updated qty
where SalesOrderID = @OrderID and ProductID = @ProductID;

declare @QtyDiff int = @NewQty - @OldQty;   -- Calculate qty difference

update Production.ProductInventory     --  To update inventory accordingly
set Quantity = Quantity - @QtyDiff 
where ProductID = @ProductID and locationID = 1;

print 'Order detail updated successfully';
end;



-- Execute UpdateOrderDetails 
--     @OrderID = 43659,
--     @ProductID = 776,
--     @Quantity = 10;  -- Only quantity will be updated

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3 :-

Create procedure GetOrderDetails @OrderID int    -- This is the parameter we will input
as
begin 
if exists ( select 1 from Sales.SalesOrderDetail      -- select 1 cause we only need that particular id, not all id...to check if it exist or not
where SalesOrderID = @OrderID)

begin select * from Sales.SalesOrderDetail        -- It will give all the details about the input ID
where SalesOrderID = @OrderID;
end

else 
begin                                                                       -- If does not exist then will give this msg
print 'The Order ID' + cast(@OrderID as varchar(10)) + 'does not exist';    -- Cast cuz trying to concate int and str, so converting the int to str, means order id which is an int converting to a str
return 1;
end
end;

Execute GetOrderDetails @OrderID = 43659;   -- To see if it is working

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q4 :-

Create procedure DeleteOrderDetails @OrderID int, @ProductID int   -- This is the parameter we will input
as
begin 
if exists ( select 1 from Sales.SalesOrderDetail  
where SalesOrderID = @OrderID and ProductID = @ProductID)

begin
delete from Sales.SalesOrderDetail       
where SalesOrderID = @OrderID and ProductID = @ProductID;
print 'Order detail deleted successfully';
end

else 
begin
print 'Error: No matching record found for Order ID' + cast(@OrderID as varchar(10)) + 'and Product ID' + cast(@ProductID as varchar(10));
return -1;
end
end;


-- Execute DeleteOrderDetails @OrderID = 43659, @ProductID = 776;    -- To see is it working or not

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Functions 
-- Q1 :-

Create Function mmddyy (@inputdate datetime)       -- Here 'mmddyy' is the function name, '@inputdate' is the parameter and 'Datetime' is the data type
returns varchar (10)                               -- Here varchar is set to 10 bcz want only first 10 words, i.e., mm/dd/yyyy and don't want time 
as 
begin
return convert (varchar (10),@inputdate,101)       -- Here '101' is the style for mm/dd/yyyy from SQL server date formats
end


select dbo.mmddyy('2006-11-21 23:34:05.920') as Date;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2 :-

Create Function yymmdd (@inputdate datetime)      
returns varchar (10)                              
as 
begin
return convert (varchar (10),@inputdate,111)       -- Here '111' is the style for yyyy/mm/dd from SQL server date formats
end

select dbo.yymmdd ('2006-11-21 23:34:05.920') as Date;

-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views 
-- Q1 :-
select * from Sales.SalesOrderDetail     -- It have order id, product id, qty, price and total sales 
select * from Production.Product         -- It have product names
select * from Sales.SalesOrderHeader     -- It have order date
select * from Sales.Store                -- It have company names
select * from Sales.Customer             -- For avoiding null joins and errors

Create view vwCustomerOrders             -- It is the view name 
as
select s.Name as CompanyName, sod.SalesOrderID as OrderID, soh.OrderDate, sod.ProductID, p.Name as ProductName, sod.OrderQty as Quantity, sod.UnitPrice, (sod.OrderQty * sod.UnitPrice) as TotalPrice
from Sales.SalesOrderDetail as sod
join Production.Product as p on p.ProductID =	sod.ProductID
join Sales.SalesOrderHeader as soh on soh.SalesOrderID = sod.SalesOrderID
join Sales.Customer as c on c.CustomerID = soh.CustomerID
join Sales.Store as s on s.BusinessEntityID = c.StoreID
where c.StoreID is not null;          -- It indicatte stores 

select * from vwCustomerOrders;  -- Running to check

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2 :-

select * from vwCustomerOrders
where cast(OrderDate as date) = cast(dateadd(day,-1,getdate()) as date);   -- This will give the yesterddays order date

-- OR ( as the question said to make a copy which return yesterdays order date as a another view table )

Create view vwCustomerOrdersOfYesterdays
as
select s.Name as CompanyName, sod.SalesOrderID as OrderID, soh.OrderDate, sod.ProductID, p.Name as ProductName, sod.OrderQty as Quantity, sod.UnitPrice, (sod.OrderQty * sod.UnitPrice) as TotalPrice
from Sales.SalesOrderDetail as sod
join Production.Product as p on p.ProductID =	sod.ProductID
join Sales.SalesOrderHeader as soh on soh.SalesOrderID = sod.SalesOrderID
join Sales.Customer as c on c.CustomerID = soh.CustomerID
join Sales.Store as s on s.BusinessEntityID = c.StoreID
where c.StoreID is not null
and cast(OrderDate as date) = cast(dateadd(day,-1,getdate()) as date);  

select * from vwCustomerOrdersOfYesterdays;     -- It returned nothing cause datset is of 2011s order dates

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3 :-
select * from Production.Product             -- It ahve Product Names
select * from Sales.SalesOrderDetail         -- It have product id,
select * from Sales.Store                    -- It have Company Names
select * from Sales.Customer                 -- Same purpose as above
select * from Production.ProductCategory     -- It have Categories
select * from Production.ProductSubcategory  -- For joining purpose


Create view MyProducts
as
select sod.ProductID, s.Name as CompanyName, p.Name as ProductName, pc.Name as CategoryName, p.Size as QuantityPerUnit, sod.UnitPrice from Production.Product as p
join Sales.SalesOrderDetail as sod on sod.ProductID = p.ProductID
join Sales.SalesOrderHeader as soh on soh.SalesOrderID = sod.SalesOrderID
join Sales.Customer as c on c.CustomerID = soh.CustomerID
join Sales.Store as s on s.BusinessEntityID = c.StoreID
join Production.ProductSubcategory AS psc ON psc.ProductSubcategoryID = p.ProductSubcategoryID
join Production.ProductCategory as pc on pc.ProductCategoryID = psc.ProductCategoryID
where c.StoreID is not null
and p.SellEndDate is null;       -- Here I used Sell end date instead of discontinued date cause it has all null values and sell end date can be use for the same purpose

select * from MyProducts;        -- To checking the table

-- OR ( If use Northwind data base as in question the mentioned tables are from northwind data base )

Create view MyProducts 
as
select p.ProductID, s.CompanyName, c.CategoryName, p.ProductName, p.QuantityPerUnit, p.UnitPrice from Products as p
join Suppliers as s on s.SupplierID = p.SupplierID
join Categories as c on c.CategoryID = c.CategoryID
where p.Discontinued = 0;

select * from MyProducts    -- Again created with Northwind database, as per the question asked.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Triggers
-- Q1 :- 

select * from Sales.SalesOrderDetail    -- It is th main order tyable
select * from Sales.SalesOrderHeader    -- It is the line items table

Create trigger InsteadOfDelete on Sales.SalesOrderHeader instead of delete
as 
begin
set nocount on;
delete from Sales.SalesOrderDetail  -- Deleting associated order details first
where SalesOrderID in (select SalesOrderID from deleted);
                                    -- Sales order id is the foreign key btw them and that's why we can't delete an order unless we delete the related records also
delete from Sales.SalesOrderHeader  -- Then delete the order itself
where SalesOrderID in (select SalesOrderID from deleted);
end;

-- Now to delete an order 
delete from Sales.SalesOrderHeader
where SalesOrderID = -- put the id want to delete

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2:-

Create trigger trg_CheckStockBeforeInsert on Sales.SalesOrderDetail instead of insert
as
begin

-- Checking if any inserted row exceeds available inventory
if exists ( select 1 from inserted as i cross apply (                        -- inserted is a special table holding incoming rows
select sum(Quantity) as TotalQty from Production.ProductInventory as pi
where pi.ProductID = i.ProductID )
as stock
where i.OrderQty > isnull(stock.TotalQty,0))                                -- If not sufficient then it will block the trigger
begin
raiserror ('Order could not be placed: insufficient stock for one or more products.', 16, 1);         -- It will exit trigger with out rollback
rollback transaction;
return;
end

begin transaction;                       -- It wil start a transaction so i can rollback if something fails

-- Deducting inventory by location, here will start with highest stock
declare @ProductID int, @OrderQty int, @RemainingQty int;
declare stock_cursor cursor for               -- It will sets up a cursor to process each new order row.
select ProductID, OrderQty from inserted;

open stock_cursor;             -- It starts reading the cursor into your declared variables
fetch next from stock_cursor into @ProductID, @OrderQty;

while @@FETCH_STATUS = 0       -- While the cursor has data, set remaining quantity to track how much to deduct
begin 
set @RemainingQty = @OrderQty;

declare @LocationID int, @QtyAvailable int;    -- To find inventory locations with positive stock, ordered by quantity descending
declare location_cursor cursor for
select LocationID, Quantity from Production.ProductInventory
where ProductID = @ProductID and Quantity > 0
order by Quantity desc;

open location_cursor;                     -- It start reading from location-level inventory
fetch next from location_cursor into @LocationID, @QtyAvailable;

while @@FETCH_STATUS = 0 and @RemainingQty > 0       -- It will decide how much to deduct, either all remaining units or whatever stock is available at that location
begin 
declare @QtyDeduct int = case
when @QtyAvailable >= @RemainingQty then @RemainingQty
else @QtyAvailable
end;

update Production.ProductInventory              -- It will deduct stock and update how many units are still to be deducted
set Quantity = Quantity - @QtyDeduct
where ProductID = @ProductID and LocationID = @LocationID;
set @RemainingQty = @RemainingQty - @QtyDeduct;

fetch next from location_cursor into @LocationID, @QtyAvailable;     -- Go to the next location, and repeat
end

close location_cursor;             -- It will close the location loop, then go to the next inserted order
deallocate location_cursor;
fetch next from stock_cursor into @ProductID, @OrderQty;
end

close stock_cursor;            -- It cleanup the outer cursor
deallocate stock_cursor;

-- Insert into SalesOrderDetail
insert into Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate)           -- Inserting the orders if every thimg is passed
select SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate from inserted;  

commit transaction;        -- For deduction + insert means to persist changes
end;
    
------------ OR if use Northwind database 

Create trigger trg_CheckStockBeforeInsert on [Order Details] instead of insert
as
begin

if exists ( select 1 from inserted as i       -- Checking if any inserted row exceeds available inventory
join Products p on p.ProductID = i.ProductID
where i.Quantity > isnull(p.UnitsInStock,0))
begin 
raiserror ('Order could not be placed: insufficient stock for one or more products.', 16, 1);        
return;
end

update p        -- Update UnitsInStock in Products
set p.UnitsInStock = p.UnitsInStock - i.Quantity from Products as p
join inserted i on i.ProductID = p.ProductID;


insert into OrderDetailsl ( OrderID, ProductID, Quantity, UnitPrice, Discount )     -- Insert into OrderDetails     
select OrderID, ProductID, Quantity, UnitPrice, Discount from inserted;  
  
end;


-- insert into [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)    -- Checking it is working or not
-- values (10248, 1, 18.00, 2, 0);


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






















    
   
   
   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------