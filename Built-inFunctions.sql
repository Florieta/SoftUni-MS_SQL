USE [SoftUni]

--Task 1

SELECT [FirstName], [LastName] FROM [Employees]
WHERE LEFT([FirstName], 2) = 'Sa'
--SECOND SOLUTION
SELECT [FirstName], [LastName] FROM [Employees]
WHERE SUBSTRING([FirstName], 1, 2) = 'Sa'
--WildCards solution
SELECT [FirstName], [LastName] FROM [Employees]
WHERE [FirstName] LIKE 'Sa%'


--Task 2
SELECT [FirstName], [LastName] FROM [Employees]
WHERE CHARINDEX('ei', [LastName]) <> 0

--WildCards solution
SELECT [FirstName], [LastName] FROM [Employees]
WHERE [LastName] LIKE '%ei%'

--Task 3

SELECT [FirstName] FROM [Employees]
WHERE [DepartmentID] IN (3, 10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005


--Task 4

 SELECT FirstName, LastName FROM Employees
 WHERE JobTitle NOT LIKE '%engineer%';

--Task 5

SELECT [Name] FROM [Towns]
WHERE LEN([Name]) IN (5,6)
ORDER BY [Name]

--6 Task

--WildCard

SELECT * FROM [Towns]
WHERE [Name] LIKE '[mkbe]%'
ORDER BY [Name]

--Task 7 
 SELECT [TownID],
   	      [Name]
	 FROM [Towns]
	WHERE [Name] NOT LIKE '[RBD]%'
 ORDER BY [Name]

 --Task 8 
 CREATE VIEW [V_EmployeesHiredAfter2000] AS
SELECT [FirstName], [LastName] FROM [Employees]
WHERE YEAR([HireDate]) > 2000

--Task 9

SELECT FirstName, LastName FROM Employees 
WHERE LEN(LastName) = 5

--Task 10

SELECT [EmployeeID], [FirstName], [LastName], [Salary], 
DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
FROM [Employees]
WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY [Salary] DESC

--Task 11
SELECT * FROM 
(
SELECT [EmployeeID], [FirstName], [LastName], [Salary], 
DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
FROM [Employees]
WHERE [Salary] BETWEEN 10000 AND 50000
)
AS [RankingTable]
WHERE [Rank] = 2
ORDER BY [Salary] DESC

-- Task 12

USE [Geography]

SELECT [CountryName] AS [Country Name],
       [IsoCode] AS [ISO Code]
	   FROM [Countries]
WHERE [CountryName] LIKE '%a%a%a%'
ORDER BY [ISO Code]


--Task 13

SELECT p.[PeakName], r.[RiverName],
LOWER(CONCAT(LEFT(p.[PeakName], LEN(p.[PeakName])-1),r.[RiverName])) AS [Mix]
FROM [Peaks] AS p,
[Rivers] AS r
WHERE LOWER(RIGHT(p.[PeakName], 1)) = LOWER(LEFT(r.[RiverName], 1))
ORDER BY [Mix]

--Task 14 

USE [Diablo]

SELECT TOP (50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE (DATEPART(YEAR, [Start]) BETWEEN 2011 AND 2012)
ORDER BY [Start], [Name]


--Task 15

SELECT [Username], 
SUBSTRING([Email],
	CHARINDEX('@', [Email]) + 1, 
	DATALENGTH([Email]) - CHARINDEX('@', [Email])) AS [Email Provider]
FROM [Users]
ORDER BY [Email Provider], [Username]

--Task 16 

SELECT [Username], [IpAddress]
FROM [Users]
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]

--Task 17

USE [Diablo]

SELECT [Name]
    AS [Game],
	   CASE
	        WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
			ELSE 'Evening'
		END
	AS [Part of the Day],
	CASE
	        WHEN [Duration] <= 3 THEN 'Extra Short'
			WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
			WHEN [Duration] > 6 THEN 'Long'
			ELSE 'Extra Long'
		END
	AS [Duration]
  FROM [Games] AS g
  ORDER BY [Game], [Duration], [Part of the Day]

  --Task 18 
  SELECT [ProductName], 
	   [OrderDate],
	   DATEADD(DAY, 3, [OrderDate]) AS [Pay Due],
	   DATEADD(MONTH, 1, [OrderDate]) AS [Deliver Due]
FROM [Orders]

  --Task 19

  CREATE TABLE People(
	 [Id] INT IDENTITY PRIMARY KEY,
	 [Name] NVARCHAR(MAX) NOT NULL,
	 [Birthdate] DATETIME2 NOT NULL
)

INSERT INTO [People]([Name], [Birthdate]) VALUES
	('Victor', '2000-12-07 00:00:00.000'),
	('Steven', '1992-09-10 00:00:00.000'),
	('Stephen', '1910-09-19 00:00:00.000'),
	('John', '2010-01-06 00:00:00.000')

SELECT [Name],
	   DATEDIFF(YEAR, [Birthdate], GETDATE()) AS [Age in Years],
	   DATEDIFF(MONTH, [Birthdate], GETDATE()) AS [Age in Months],
	   DATEDIFF(DAY, [Birthdate], GETDATE()) AS [Age in Days],
	   DATEDIFF(MINUTE, [Birthdate], GETDATE()) AS [Age in Minutes]
FROM [People]
