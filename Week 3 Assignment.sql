-- Task 1 :-
Create database Week3         -- Created a seperate database only for this assignment

Create table Projects (       -- First created the table
TaskID int,
StartDate Date,
EndDate Date);

Insert into Projects (TaskID, StartDate, EndDate)     -- Inserted data inside the table
values (1,  '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');

select * from Projects


with GroupedProjects as (
select TaskID, StartDate, EndDate, dateadd(day, -row_number() over (order by StartDate), StartDate) as grp_date    -- Creates a grouping key cause consecutive ranges will share the same gap difference between the start date and the row number
from Projects ),     -- 

ProjectGroups as (
select min(StartDate) as StartDate, max(EndDate) as EndDate, datediff(day, min(StartDate), max(EndDate)) as Duration     -- Gets the earliest start and latest end date in each group and give duration
from GroupedProjects
group by grp_date )

select StartDate, EndDate from ProjectGroups
order by Duration, StartDate;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 2 :-
 Create table Students ( ID int, Name varchar(20) );         -- Creating students table
 Insert into Students ( ID, Name ) 
 values (1, 'Ashley'),
 (2, 'Samantha'),
 (3, 'Julia'),
 (4, 'Scarlet');

 Create table Friends ( ID int, FriendID int );         -- Creating friends table
 Insert into Friends ( ID, FriendID ) 
 values (1, 2),
 (2, 3),
 (3, 4),
 (4, 1);

 Create table Packages ( ID int, Salary money );         -- Creating packages table
 Insert into Packages ( ID, Salary ) 
 values (1, 15.20),
 (2, 10.06),
 (3, 11.55),
 (4, 12.12);

 select * from Students
 select * from Friends
 select * from Packages

select s.name from Students as s
join Friends as f on f.ID = s.ID             -- To get best friends id
join Packages as p on p.ID = s.ID            -- To get student's salary 
join Packages as ps on ps.ID = f.FriendID    -- To get best friend's salary
where ps.Salary > p.Salary                   -- To get only those whose friend earns more
order by p.Salary asc;                       -- This will give ascending order of friend's salary

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 3 :-

Create table Functions ( X int, Y int);   -- Distinct for no duplicates
insert into Functions values ( 20, 20), (20,20), (20,21), (23,22), (22,23), (21,20);

select distinct f.X, f.Y from Functions as f
join Functions as fs on f.X = fs.Y and f.Y = fs.X    -- This will match the condition symmetric pairs
where f.X <= f.Y             -- For each pair only one time
order by f.X;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 4 :-
Create table Contests ( ContestID int, HackerID int, Name varchar(20));
Insert into Contests values
(66406, 17973, 'Rose'),
(66556, 79153, 'Angela'),
(94828, 80275, 'Frank');

Create table Colleges ( CollegeID int, ContestID int);
insert into Colleges values
(11219, 66406),
(32473, 66556),
(56685, 94828);

Create table Challenges ( ChallengeID int, CollegeID int);
Insert into Challenges values
(18765, 11219),
(47127, 11219),
(60292, 32473),
(72974, 56685);

Create table ViewStats ( ChallengeID int, TotalViews int, TotalUniqueView int);
insert into ViewStats values
(47127, 26, 19),
(47127, 15, 14),
(18765, 43, 10),
(18765, 72, 13),
(75516, 35, 17),
(60292, 11, 10),
(72974, 41, 15),
(75516, 75, 11);

Create table SubmissionStats ( ChallengeID int, TotalSubmissions int, TotalAcceptedSubmissions int);
insert into SubmissionStats values
(75516, 34, 12),
(47127, 27, 10),
(47127, 56, 18),
(75516, 74, 12),
(75516, 83, 8),
(72974, 68, 24),
(72974, 82, 14),
(47127, 28, 11);


select
    c.ContestID,
    c.HackerID,
    c.Name,
    sum(coalesce(s.TotalSubmissions, 0)) as TotalSubmissions,                      -- coalesce to prevent null and put 0 instead if null
    sum(coalesce(s.TotalAcceptedSubmissions, 0)) as TotalAcceptedSubmissions,
    sum(coalesce(v.TotalViews, 0)) as TotalViews,
    sum(coalesce(v.TotalUniqueView, 0)) as TotalUniqueViews
from Contests as c
join Colleges col on c.ContestID = col.ContestID
join Challenges ch on col.CollegeID = ch.CollegeID
left join (
select ChallengeID, 
sum(TotalSubmissions) as TotalSubmissions,                                  -- To make the joins 1 on 1 instead of many on many
sum(TotalAcceptedSubmissions) as TotalAcceptedSubmissions
from SubmissionStats
group by ChallengeID) as s on ch.ChallengeID = s.ChallengeID
left join (
select ChallengeID, sum(TotalViews) as TotalViews, sum(TotalUniqueView) as TotalUniqueView
from ViewStats
group by ChallengeID) as v on ch.ChallengeID = v.ChallengeID
group by c.ContestID, c.HackerID, c.Name
having 
sum(coalesce(s.TotalSubmissions, 0)) > 0 or             -- TO met the condition exclude contests 
sum(coalesce(s.TotalAcceptedSubmissions, 0)) > 0 or
sum(coalesce(v.TotalViews, 0)) > 0 or
sum(coalesce(v.TotalUniqueView, 0)) > 0
order by c.ContestID;                                  -- Ordered by contest as said to

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 5 :- 
Create table Hackers (HackerID int, Name varchar(20));
insert into Hackers values
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');

Create table Submissions (SubmissionDate date, SubmissionID int, HackerID int, Score int);
insert into Submissions values
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 45),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);

with DailyUniqueHackers as ( 
select SubmissionDate, count(distinct HackerID) as UniqueHackers from Submissions
where SubmissionDate between '2016-03-01' and '2016-03-15'
group by SubmissionDate ),    -- It count unique hackers per day

DailySubmissionCounts as (
select SubmissionDate, HackerID, count(*) as SubmissionCount from Submissions
where SubmissionDate between '2016-03-01' and '2016-03-15'
group by SubmissionDate, HackerID ),    -- It counts submissions per hackers per day

MaxSubmissionsPerDay as (
select SubmissionDate, max(SubmissionCount) as MaxSubmission from DailySubmissionCounts
group by SubmissionDate),             -- It gives max no. of submissions per day

TopHackers as (
select dsc.SubmissionDate, min(dsc.HackerID) as TopHackerID from DailySubmissionCounts as dsc
inner join MaxSubmissionsPerDay as mspd on mspd.SubmissionDate = dsc.SubmissionDate
and mspd.MaxSubmission = dsc.SubmissionCount
group by dsc.SubmissionDate)        -- To find hackers with max submissions per day

select duh.SubmissionDate, duh.UniqueHackers, th.TopHackerID, h.Name 
from DailyUniqueHackers as duh
inner join TopHackers as th on th.SubmissionDate = duh.SubmissionDate
inner join Hackers as h on h.HackerID = th.TopHackerID
order by duh.SubmissionDate;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 6 :-

Create table Station (ID int, City varchar(21), Statte varchar(21), LAT_N int, LONG_W int)

with Coordinates as (
select min(LAT_N) as MinLat, max(LAT_N) as MaxLat, min(LONG_W) as MinLong, max(LONG_W) as MaxLong
from Station )
select round(abs(MinLat - MaxLat) + abs(MinLong - MaxLong),2) as ManhattanDistance       -- 'round' for round it to a scle of decimal places, 'abs' for absolute values  
from Coordinates;      -- As no data is inserted it is giving null

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 7 :-
with numbers as (
select 2 as num union all            -- It will start from 2 as the first prime number and 'union all' combines the current number (2) with the next one recursively
select num + 1 from Numbers          -- It will keep adding 1
where num + 1 <= 1000 ),             -- Stop adding when reach 1000
 
Primes as (                         -- It will filter out only the prime no.
select num from Numbers as n 
where not exists  (                 -- It ensures only keep numbers with no divisors
select 1 from Numbers as p
where p.num < n.num and p.num > 1 and n.num % p.num = 0 ))    -- This is how it will choose no.

select string_agg (cast(num as varchar), '&') as PrimeList    -- 'string_agg' joins all the prime numbers into a single string
from Primes
option(maxrecursion 1000);      -- SQL Server limits recursion depth to 100 by default

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 8 :-
Create table Occupations (Name varchar(20), Occupation varchar(20)); 
insert into Occupations values 
('Samantha', 'Doctor'),
('Julia', 'Actor'),
('Maria', 'Actor'),
('Meera', 'Singer'),
('Ashely', 'Professor'),
('Ketty', 'Professor'),
('Christeen', 'Professor'),
('Jane', 'Actor'),
('Jenny', 'Doctor'),
('Priya', 'Singer');

with DiffOccupations as (
select Name, Occupation, row_number() over(partition by Occupation order by Name) as row_num      -- To rank names alphabetically within each occupation
from Occupations )

select max(case when Occupation = 'Doctor' then Name end) as Doctor,     -- Pivots tha data for each occupation
max(case when Occupation = 'Professor' then Name end) as Professor,
max(case when Occupation = 'Singer' then Name end) as Singer,
max(case when Occupation = 'Actor' then Name end) as Actor
from DiffOccupations
group by row_num
order by row_num;      -- To ensure proper row sequencing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 9 :-
Create table BST (N INT, P INT)
insert into BST values 
(1, 2),
(3, 2),
(6, 8),
(9, 8),
(2, 5),
(8, 5),
(5, null);

select N, case when P is null then 'Root'     -- For conditional logic
when N in (select distinct P from BST where P is not null) then 'Inner'   -- To find which nodes are parents
else 'Leaf'
end as NodeType from BST    
order by N;     -- To sort by node value

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 10 :-
Create table Company ( Company_Code varchar(20), Founder Varchar(20) );
insert into Company values
('C1', 'Monika'),
('C2', 'Samantha');

Create table Lead_Manager ( Lead_Manager_Code varchar(20), Company_Code varchar(20) ); 
insert into Lead_Manager values
('LM1', 'C1'),
('LM2', 'C2');

Create table Senior_Manaer ( Senior_Manaer_Code varchar(20), Lead_Manager_Code varchar(20), Company_Code varchar(20) );
insert into Senior_Manaer values
('SM1', 'LM1', 'C1'),
('SM2', 'LM1', 'C1'),
('SM3', 'LM2', 'C2');

Create table Manager ( Manager_Code varchar(20), Senior_Manaer_Code varchar(20), Lead_Manager_Code varchar(20), Company_Code varchar(20) );
insert into Manager values
('M1', 'SM1', 'LM1', 'C1'),
('M2', 'SM3', 'LM2', 'C2'),
('M3', 'SM3', 'LM2', 'C2');


Create table Employee ( Employee_Code varchar(20),  Manager_Code varchar(20), Senior_Manaer_Code varchar(20), Lead_Manager_Code varchar(20), Company_Code varchar(20) );
insert into Employee values
('E1', 'M1', 'SM1', 'LM1', 'C1'),
('E2', 'M1', 'SM1', 'LM1', 'C1'),
('E3', 'M2', 'SM3', 'LM2', 'C2'),
('E4', 'M3', 'SM3', 'LM2', 'C2');

select c.Company_Code, c.Founder, count(distinct lm.Lead_Manager_Code) as Total_no_of_lead_managers, count(distinct sm.Senior_Manaer_Code) as Total_no_of_senior_manager, 
count(distinct m.Manager_Code) as Total_no_of_managers, count(distinct e.Employee_Code) as Total_no_of_Employees    -- 'distinct' to prevent over counting
from Company as c
join Lead_Manager as lm on lm.Company_Code = c.Company_Code
join Senior_Manaer as sm on sm.Lead_Manager_Code = lm.Lead_Manager_Code
join Manager as m on m.Lead_Manager_Code = lm.Lead_Manager_Code
join Employee as e on e.Manager_Code = m.Manager_Code
group by c.Company_Code, c.Founder
order by c.Company_Code asc;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 11 :-  Repeated Question [ Same question as Task 2 ]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 12 :-
Create table SimulationData ( JobFamilyID int, JobFamily Varchar(50), Cost money, LocationName varchar(20), CountryName varchar(20) );
Insert into SimulationData values 
(1, 'Software Development', 50000, 'Bangalore', 'India' ),
(2, 'Product Manager',  30000, 'Mumbai', 'India'),
(3, 'Data Analytics', 20000, 'New York', 'USA'),
(4, 'Data Analytics', 8000, 'Hyderabad', 'India'),
(5, 'Software Development', 25000, 'London', 'UK'),
(6, 'UI/UX Design', 25000, 'Chennai', 'India'),
(7, 'Business Analyst', 10000, 'Toronto', 'Canada'),
(8, 'Product Manager', 15000, 'Berlin', 'Germany'),
(9, 'UI/UX Design', 10000, 'Sydney', 'Australia'),
(10, 'Business Analyst', 15000, 'Kolkata', 'India');


With TotalCostsOfCountry as (
select JobFamily, 
sum(case when CountryName = 'India' then Cost else 0 end) as IndiaCost,
sum(case when CountryName != 'India' then Cost else 0 end) as InternationalCost,       -- Not India (!=)
sum(Cost) as TotalCost
from SimulationData
group by JobFamily)
select JobFamily, 
round((IndiaCost * 100) / TotalCost, 2) as IndiaCostPct,                    -- Finding the percentages
round((InternationalCost * 100) / TotalCost, 2) as InternationalCostPct
from TotalCostsOfCountry;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 13 :-
Create table BussinessUnit (BuName varchar(20), Date date, Cost money, Revenue money );
Insert into BussinessUnit values
('Technology', '2024-01-01', 100000, 250000),
('Technology', '2024-02-01', 120000, 240000),
('Healthcare', '2024-01-01', 80000, 200000),
('Healthcare', '2024-02-01', 90000, 180000),
('Retail','2024-01-31', 250000, 200000),
('Retail', '2024-02-29', 270000, 210000 ),
('Finance', '2024-05-31', 470000, 350000),
('Finance','2024-06-30', 490000, 360000),
('Fintech', '2024-01-01', 80000, 200000),
('Fintech', '2024-02-01', 90000, 180000);

select BuName, format(Date, 'MM-yyyy') as Month, sum(Cost) as TotalCost, sum(Revenue) as TotalRevenues,
case when sum(Revenue) = 0 then null else round(sum(Cost) * 1 / sum(Revenue), 2) end as CostToRevRatio    -- Multiplied by 1 cuz want the result as a ratio
from BussinessUnit
group by BuName, format(Date, 'MM-yyyy')
order by CostToRevRatio desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 14 :-

Create table CompanyData ( EmployeeID int, Department varchar(20), Band varchar(20), SubBand varchar(20) );
Insert into CompanyData values
(101, 'Technology', 'Senior', 'S1'),
(102, 'Technology', 'Junior', 'J1'),
(103, 'Technology', 'Senior', 'S2'),
(104, 'Technology', 'Manager', 'M1'),
(105, 'Technology', 'Senior', 'S2'),
(106, 'Technology', 'Junior', 'J1'),
(107, 'HR',         'Manager', 'M1'),
(108, 'HR',         'Trainee', 'T1'),
(109, 'HR',         'Trainee', 'T1'),
(110, 'HR',         'Manager', 'M3'),
(111, 'Finance',    'Junior', 'J2'),
(112, 'Finance',    'Manager', 'M1'),
(113, 'Finance',    'Junior', 'J2'),
(114, 'Finance',    'Junior', 'J2'),
(115, 'Sales',      'Trainee', 'T1'),
(116, 'Sales',      'Trainee', 'T1'),
(117, 'Sales',      'Trainee', 'T1'),
(118, 'Sales',      'Junior', 'J2'),
(119, 'Sales',      'Trainee', 'T1'),
(120, 'Sales',      'Manager', 'M2');

select SubBand, count(*) as HeadCount,     -- 'counts(*)' counts the number of rows later gonna do group by
round(count(*) * 100 / sum(count(*)) over(), 2) as HeadCountPct    -- 'sum(count(*)) over()' do the total count across all groups, for the division
from CompanyData
group by SubBand
order by HeadCount desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 15 :-
Create table EmployeeData ( EmployeeID int, Department varchar(20), Salary money );
Insert into EmployeeData values
(101, 'IT', 85000),
(102, 'Marketiing', 90000),
(103, 'Sales', 92000),
(104, 'IT', 87000),
(105, 'HR', 95000),
(106, 'Sales', 88000),
(107, 'HR', 91000),
(108, 'Marketing', 96000);

select distinct ed.EmployeeID, ed.Department, ed.Salary from EmployeeData as ed
where 5 > (                 -- A correlated subquery to filter the top 5
select count(distinct ee.Salary) from EmployeeData as ee where ee.Salary > ed.Salary);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 16 :-

Create table SwapValue (CustID int, FirstOrder varchar(20), LastOrder varchar(20) );
Insert into SwapValue values
(13, 'Coca-Cola', 'Pepsi'),
(28, 'Rice', 'Maggi'),
(5, 'Chips', 'Kurkure');

Update SwapValue 
set FirstOrder = s.LastOrder, LastOrder = s.FirstOrder
from SwapValue as s;
select * from SwapValue

------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 17 :-
Create login CelebalTech with password = 'CB@123';   -- Creating the login
Use Week3;
go 
Create user Interns for login CelebalTech with default_schema = dbo;   -- Creating user in the database
alter role db_owner add member interns;     -- Giving permission to user

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 18 :-
Create table EmployeeWork ( EmployeeID int, BuName varchar(20), Date date, Cost money, FTE decimal);   -- 'FTE' is full time equivalent, here 1 = full time, 0.5 half time
insert into EmployeeWork values
(101, 'Finance', '2025-01-01', 60000, 1.0),
(102, 'Finance', '2025-01-01', 40000, 0.5),
(103, 'Finance', '2025-01-01', 45000, 1.0),
(201, 'HR', '2025-01-01', 30000, 1.0),
(202, 'HR', '2025-01-01', 25000, 0.8),
(101, 'Finance', '2025-02-01', 61000, 1.0),
(102, 'Finance', '2025-02-01', 40500, 0.5),
(201, 'HR', '2025-02-01', 31000, 1.0),
(202, 'HR', '2025-02-01', 25500, 0.8),
(301, 'IT', '2025-02-01', 70000, 1.0),
(302, 'IT', '2025-02-01', 50000, 0.9);

select BuName, format([Date], 'MM-yyyy') as Month, cast(round(sum(Cost * FTE) / nullif(sum(FTE),0), 2) as decimal(8,2)) as WeightedAvgCost   -- 'cast(... as decimal(8,2))' ensures it displays exactly 2 decimal places as working with the data type money
from EmployeeWork 
group by BuName,format([Date], 'MM-yyyy')    -- Like before in task 13
order by BuName;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 19 :-
Create table Employees ( EmployeeID int, Department varchar(20), Salary int );
insert into Employees values 
(1001, 'IT', 95000),
(1002, 'Sales', 87000),
(1003, 'IT', 102000),
(1004, 'HR', 78000),
(1005, 'Sales', 125000),
(1006, 'HR', 82000),
(1007, 'Operations', 91000),
(1008, 'Marketing', 98000),
(1009, 'IT', 75000),
(1010, 'Marketing', 115000),
(1011, 'Marketing', 88000),
(1012, 'Operations', 93000);

select avg(Salary * 1) - avg(cast(replace(Salary, '0', '') as int)) as AmountOfError   -- First calculated avg salaries then subtract that from miscalculated data, by remove all 0
from Employees  -- Last in above line converts the string back to a number by using cast

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Task 20 :-
Create table Unknown1 ( OrderID int, Product varchar(20) );
insert into Unknown1 values
(1236, 'Cockies'),
(6654, 'Pepsi'),
(7845, 'Chips');

Create table Unknown2 ( OrderID int, Product varchar(20) );
insert into Unknown1 values
(1245, 'Maggi'),
(9654, 'Pasta');

insert into Unknown1 
select * from Unknown2 
except select * from Unknown1;   -- So that if there is any duplicates that does not repeat again cause we don't know which is the new table

select * from Unknown1   -- This table contains all data now

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------