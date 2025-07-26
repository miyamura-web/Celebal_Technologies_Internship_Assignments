
CREATE TABLE DateDimension (
    SKDate INT PRIMARY KEY,            -- Surrogate Key
    KeyDate DATE,
    DateValue DATE,
    CalendarDay INT,
    CalendarMonth INT,
    CalendarQuarter INT,
    CalendarYear INT,
    DayNameFull VARCHAR(20),
    DayNameShort VARCHAR(10),
    DayOfWeek INT,
    DayOfYear INT,
    DaySuffix VARCHAR(10),
    FiscalWeek INT,
    FiscalPeriod INT,
    FiscalQuarter INT,
    FiscalYear INT,
    FiscalYearPeriod VARCHAR(10)
);


go
CREATE PROCEDURE usp_PopulateDateDimension
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);

    ;WITH DateCTE AS (
        SELECT @StartDate AS DateValue
        UNION ALL
        SELECT DATEADD(DAY, 1, DateValue)
        FROM DateCTE
        WHERE DateValue < @EndDate
    )
    INSERT INTO DateDimension (
        SKDate,
        KeyDate,
        DateValue,
        CalendarDay,
        CalendarMonth,
        CalendarQuarter,
        CalendarYear,
        DayNameFull,
        DayNameShort,
        DayOfWeek,
        DayOfYear,
        DaySuffix,
        FiscalWeek,
        FiscalPeriod,
        FiscalQuarter,
        FiscalYear,
        FiscalYearPeriod
    )
    SELECT
        CAST(FORMAT(DateValue, 'yyyyMMdd') AS INT) AS SKDate,
        DateValue AS KeyDate,
        DateValue,
        DAY(DateValue) AS CalendarDay,
        MONTH(DateValue) AS CalendarMonth,
        DATEPART(QUARTER, DateValue) AS CalendarQuarter,
        YEAR(DateValue) AS CalendarYear,
        DATENAME(WEEKDAY, DateValue) AS DayNameFull,
        LEFT(DATENAME(WEEKDAY, DateValue), 3) AS DayNameShort,
        DATEPART(WEEKDAY, DateValue) AS DayOfWeek,
        DATEPART(DAYOFYEAR, DateValue) AS DayOfYear,
        CAST(DAY(DateValue) AS VARCHAR) + 
            CASE 
                WHEN DAY(DateValue) IN (11,12,13) THEN 'th'
                WHEN RIGHT(CAST(DAY(DateValue) AS VARCHAR),1) = '1' THEN 'st'
                WHEN RIGHT(CAST(DAY(DateValue) AS VARCHAR),1) = '2' THEN 'nd'
                WHEN RIGHT(CAST(DAY(DateValue) AS VARCHAR),1) = '3' THEN 'rd'
                ELSE 'th'
            END AS DaySuffix,
        DATEPART(WEEK, DateValue) AS FiscalWeek,
        MONTH(DateValue) AS FiscalPeriod,
        DATEPART(QUARTER, DateValue) AS FiscalQuarter,
        YEAR(DateValue) AS FiscalYear,
        CAST(YEAR(DateValue) AS VARCHAR) + RIGHT('0' + CAST(MONTH(DateValue) AS VARCHAR), 2) AS FiscalYearPeriod
    FROM DateCTE
    OPTION (MAXRECURSION 366);
END;



EXEC usp_PopulateDateDimension '2020-07-14';

