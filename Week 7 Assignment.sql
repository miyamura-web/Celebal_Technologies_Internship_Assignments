
Create database Week_7;

create table product_stg ( 
            product_id int,
            product_name varchar(20), 
            price decimal(9,2)
            );

insert into product_stg values (1, 'iphone13', 40000), (2, 'iphone14', 70000);

delete from product_stg;      -- every time we will have a new table that's why it's deleted(means this table will come back later with new values, which we have to add in the dim table)

select * from product_stg;    -- It is the staging table

------------------------------------------------------------------------------------------------------------------------------------------------------

-- SCD Type 0 [ Only insert new records, never update ]

create table product_dim0 (
             product_id int primary key, 
             product_name varchar(20), 
             price decimal(9,2), 
             insert_date date
             );

-- Set the date
declare @today date = '2025-07-15'

-- Inserting only new data 
insert into product_dim0 
select product_id, product_name, price, @today
from product_stg
where not exists ( 
     select 1 from product_dim0
     where product_dim0.product_id = product_stg.product_id
     );

-- To see if it works 
select * from product_dim0;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- SCD Type 1 [ Update the record directly when a change is detected ]

create table product_dim1 ( 
             product_id int primary key, 
             product_name varchar(20), 
             price decimal(9,2), 
             last_update date
             );

insert into product_stg values (1, 'iphone13', 30000), (3, 'iphone15', 90000);  -- It is the next table with new data( now it will be add in dim table) after deleting it came new a new table again

insert into product_stg values (1, 'iphone13', 25000), (3, 'iphone15', 80000);  -- It is the next table with new data( now it will be add in dim table) after deleting it came new a new table again

-- Set the date
declare @today date = '2025-07-20'

-- Update the existing products
update product_dim1       -- This query will update ( always fisrt update and then insert)
set price = product_stg.price, last_update = @today
from product_stg 
where product_stg.product_id = product_dim1.product_id

-- Insert new products details 
insert into product_dim1    
select product_id, product_name, price,@today
from product_stg
where not exists ( 
     select 1 from product_dim1
     where product_dim1.product_id = product_stg.product_id
     );

-- To see if it works 
select * from product_dim1;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- SCD Type 2 [ Insert new row for changes and expire old row with end date ] 

create table product_dim2 ( 
             product_key int identity(1,1), -- surrogate key
             product_id int, 
             product_name varchar(20), 
             price decimal(9,2), 
             start_date date,
             end_date date
             );

insert into product_stg values (1, 'iphone13', 40000), (2, 'iphone14', 70000);  -- It is the first table (after add in dim it's deleted)



-- Set the date
declare @today date = '2025-07-15'

-- Expire existing records by setting end_date to one day before today
update product_dim2       -- This query will update ( always fisrt update and then insert)
set end_date = dateadd(day,-1,@today)
from product_stg 
where product_stg.product_id = product_dim2.product_id
and end_date = '9999-12-31';

-- Insert new record as a new version with new start date
insert into product_dim2     -- Now with this query we will able to add new products but update the old products
select product_id, product_name, price, @today, '9999-12-31' -- This is the end
from product_stg;

-- To see if it works 
select * from product_dim2;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- SCD Type 3 [ Store current and one previous value in same row ]  

create table product_dim3 (
             product_id int,
             product_name varchar(20),
             current_price decimal,
             previous_price decimal,
             last_update date
             );



-- Set the date
declare @today date = '2025-07-15'

-- Update existing products by shifting current price to previous price
update product_dim3
set 
    previous_price = product_dim3.current_price,
    current_price = product_stg.price,
    last_update = @today
from product_dim3
join product_stg on product_dim3.product_id = product_stg.product_id;

-- Insert new products
insert into product_dim3
select product_stg.product_id, product_stg.product_name, product_stg.price, null,  @today   -- No previous_price for new records (suppose)         
from product_stg 
where not exists ( 
     select 1 from product_dim3
     where product_dim3.product_id = product_stg.product_id
     );

-- To see if it works 
select * from product_dim3;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- SCD Type 4 [ Keep current in dimension table and full history in a separate history table ] 

create table product_dim4 (
             product_id int,
             product_name varchar(20),
             price decimal,
             last_update date
             );

create table product_history (
             product_id int,
             product_name varchar(20),
             price decimal,
             change_date date
             );


insert into product_history values (1, 'iphone13', 40000, '2025-07-15' ), (2, 'iphone14', 70000, '2025-07-15');

-- Set the date
declare @today date = '2025-07-20'

-- Insert OLD (about-to-change) records into the history table
insert into product_history 
select 
    dim.product_id, 
    dim.product_name, 
    dim.price, 
    @today
from product_dim4 as dim
join product_stg as stg
    on dim.product_id = stg.product_id
where 
    dim.price <> stg.price                   -- <> means not equals to
    or dim.product_name <> stg.product_name;

-- Update the current dimension table with the latest values
update dim
set 
    dim.product_name = stg.product_name,
    dim.price = stg.price,
    dim.last_update = @today
from product_dim4 as dim
join product_stg as stg
    on dim.product_id = stg.product_id
where 
    dim.price <> stg.price
    or dim.product_name <> stg.product_name;

-- Insert new products into the dimension table (not in current table)
insert into product_dim4 
select 
    stg.product_id, 
    stg.product_name, 
    stg.price, 
    @today
from product_stg as stg
where not exists (
    select 1 
    from product_dim4 as dim 
    where dim.product_id = stg.product_id
    );


-- To see if it works 
select * from product_dim4;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- SCD Type 6 [ Store full history (Type 2), overwrite current (Type 1), and retain previous (Type 3) in one table ]  

create table product_dim6 (
             product_key int primary key identity(1,1),     -- Surrogate key
             product_id int,                           -- Business key
             product_name varchar(20),
             previous_product_name varchar(20),       -- Type 3 attribute
             price decimal,
             previous_price decimal,                   -- Type 3 attribute
             start_date date,
             end_date date,
             is_current bit
             );



-- Set the date
declare @today date = '2025-07-20'

-- Expire current records where changes are detected
update dim
set
    end_date = dateadd(day, -1, @today),
    is_current = 0
from product_dim6 as dim
join product_stg as stg on dim.product_id = stg.product_id
where 
    dim.is_current = 1 and 
    (dim.price <> stg.price or dim.product_name <> stg.product_name);

-- Insert new version with updated info and shifted previous values
insert into product_dim6
select
    stg.product_id,
    stg.product_name,
    dim.product_name,           -- Save current as previous
    stg.price,
    dim.price,                  -- Save current price as previous
    @today,
    '9999-12-31',
    1
from product_stg as stg
join product_dim6 as dim on dim.product_id = stg.product_id
where dim.is_current = 1 
      and (dim.price <> stg.price or dim.product_name <> stg.product_name);

-- Insert new products not found in dim table
insert into product_dim6
select 
    stg.product_id,
    stg.product_name,
    null,
    stg.price,
    null,
    @today,
    '9999-12-31',
    1
from product_stg as stg
where not exists (
    select 1 from product_dim6 as dim 
    where dim.product_id = stg.product_id
);



-- To see if it works 
select * from product_dim6;

------------------------------------------------------------------------------------------------------------------------------------------------------
