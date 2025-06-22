Create database Celebal_Tech;

Create table CountTotalWorkinHours ( Start_Date date, End_Date date, No_Of_Hours int );

Create procedure GetTotalWorkingHours  ( @Start_Date date,  @End_Date date )    -- Input parameters in bracket
as
begin   -- Begin the procedure body
declare @CurrentDate date = @Start_Date;     -- Declares a variable @CurrentDate to iterate through each date between start and end

declare @Hours int = 0;    -- To store the total number of working hours

while @CurrentDate < @End_Date     -- A while loop that runs from @Start_Date to @End_Date, day by day  and only the start date is counted in hrs
begin
declare @IsSunday bit = case when datepart(weekday, @CurrentDate) = 1 then 1 else 0 end;        -- If sunday then weekday = 1
declare @IsSaturday bit = case when datepart(weekday, @CurrentDate) = 7 then 1 else 0 end;      -- If saturday then weekday = 7
declare @IsFirstOrSecondSaturday bit = 0;      -- Check if saturday is the 1st or 2nd Saturday of the month

if @IsSaturday = 1    -- Only if the current day is Saturday then...
begin
declare @WeekNum int = datepart(week, @CurrentDate) - datepart(week, dateadd(day, 1 - day(@CurrentDate), @CurrentDate)) + 1 ;     -- Calculates the first day of the month of the current date
if @WeekNum in (1, 2)
set @IsFirstOrSecondSaturday = 1;   -- If this Saturday is the 1st or 2nd Saturday of the month then 1
end

if (@IsSunday = 0 and @IsFirstOrSecondSaturday = 0)    -- Will decides if the current date counts as a working day
or ((@CurrentDate = @Start_Date or @CurrentDate = @End_Date) and (@IsSunday = 1 or @IsFirstOrSecondSaturday = 1))     -- If it's a boundary date (start or end) even if it's Sunday or 1st or 2nd Saturday, still count it
begin
set @Hours += 24;    -- If the condition is true then add 24hrs 
end

set @CurrentDate = dateadd(day, 1, @CurrentDate);    -- Move to the next day in the loop
end

insert into counttotalworkinhours (Start_Date, End_Date, No_Of_Hours)
values (@Start_Date, @End_Date, @Hours);
end;


-- Test data
exec GetTotalWorkingHours '2023-07-12', '2023-07-13';
exec GetTotalWorkingHours '2023-07-01', '2023-07-17';

select * from CountTotalWorkinHours 
order by Start_Date asc;     -- Matching with the expected output