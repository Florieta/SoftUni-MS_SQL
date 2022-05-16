USE [SoftUni]

--Task 1

SELECT TOP(5) e.[EmployeeID],
              e.[JobTitle],
			  e.[AddressID],
			  a.[AddressText]
		FROM [Employees] AS e
   LEFT JOIN [Addresses] AS a
   ON e.[AddressID] = a.[AddressID]
ORDER BY e.[AddressID]

--Task 2
SELECT TOP(50) e.[FirstName],
              e.[LastName],
			  t.[Name] AS [Town],
			  a.[AddressText]
		FROM [Employees] AS e
   JOIN [Addresses] AS a
   ON e.[AddressID] = a.[AddressID]
   JOIN [Towns] AS t
   ON a.[TownID] = t.[TownID]
ORDER BY e.[FirstName], e.[LastName]


--Task 3
	   SELECT e.[EmployeeID],
	          e.[FirstName],
              e.[LastName],
			  d.[Name] AS [DepartmentName]
		FROM [Employees] AS e
   JOIN [Departments] AS d
   ON e.[DepartmentID] = d.[DepartmentID]
WHERE [Name] = 'Sales'
ORDER BY e.[EmployeeID]

--Task 4
SELECT TOP (5) e.[EmployeeID],
	          e.[FirstName],
              e.[Salary],
			  d.[Name] AS [DepartmentName]
		FROM [Employees] AS e
   JOIN [Departments] AS d
   ON e.[DepartmentID] = d.[DepartmentID]
WHERE [Salary] > 15000
ORDER BY d.[DepartmentID]

--Task 5

SELECT TOP(3) e.[EmployeeID],
              e.[FirstName]
		FROM [Employees] AS e
   LEFT JOIN [EmployeesProjects] AS ep
   ON e.[EmployeeID] = ep.[EmployeeID]
WHERE ep.[ProjectID] IS NULL
ORDER BY e.[EmployeeID]

--Task 6
       SELECT e.[FirstName],
              e.[LastName],
			  e.[HireDate],
			  d.[Name] AS [DeptName]
		FROM [Employees] AS e
   JOIN [Departments] AS d
   ON e.[DepartmentID] = d.[DepartmentID]
   WHERE [HireDate] > '01/01/1999' AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.[HireDate]

--Task 7
SELECT TOP(5) e.[EmployeeID],
              e.[FirstName],
			  p.[Name] AS [ProjectName]
FROM [Employees] AS e
INNER JOIN [EmployeesProjects] AS ep
ON e.[EmployeeID] = ep.[EmployeeID]
INNER JOIN [Projects] AS p
ON ep.[ProjectID] = p.[ProjectID]
WHERE p.[StartDate] > '08/13/2002' AND p.[EndDate] IS NULL
ORDER BY e.[EmployeeID]

--Task 8

SELECT e.[EmployeeID],
       e.[FirstName],
	   CASE
	       WHEN YEAR(p.[StartDate]) >= 2005 THEN NULL
		   ELSE p.[Name]
	   END AS [ProjectName]
FROM [Employees] AS e
INNER JOIN [EmployeesProjects] AS ep
ON e.[EmployeeID] = ep.[EmployeeID]
INNER JOIN [Projects] AS p
ON ep.[ProjectID] = p.[ProjectID]
WHERE e.[EmployeeID] = 24

--Task 9

SELECT e.[EmployeeID], e.[FirstName], e.[ManagerID], em.[FirstName] AS [ManagerName]
FROM [Employees] e
JOIN [Employees] em ON e.[ManagerID] = em.[EmployeeID]
WHERE e.[ManagerID] = 3 OR e.[ManagerID] = 7
ORDER BY e.[EmployeeID]

--Task 10
SELECT TOP(50) e.[EmployeeID], 
       CONCAT(e.[FirstName], ' ', e.[LastName]) AS [EmployeeName],
	   CONCAT(em.[FirstName], ' ', em.[LastName]) AS [ManagerName],
	   d.[Name] AS [DepartmentName]
FROM [Employees] e
JOIN [Employees] em ON e.[ManagerID] = em.[EmployeeID]
JOIN [Departments] d ON d.[DepartmentID] = e.[DepartmentID]
ORDER BY e.[EmployeeID]

--Task 11
SELECT TOP(1) AVG([Salary]) AS [MinAverageSalary]
FROM [Employees]
GROUP BY [DepartmentID]
ORDER BY [MinAverageSalary]

USE [Geography]

--Task 12
SELECT c.[CountryCode],
       m.[MountainRange],
	   p.[PeakName],
	   p.[Elevation]
FROM [Peaks] AS p
INNER JOIN [Mountains] AS m
ON p.[MountainId] = m.[Id]
INNER JOIN [MountainsCountries] AS mc
ON m.[Id] = mc.[MountainId]
LEFT JOIN [Countries] AS c
ON mc.[CountryCode] = c.[CountryCode]
WHERE c.[CountryCode] = 'BG' AND p.[Elevation] > 2835
ORDER BY P.[Elevation] DESC

--Task 13

SELECT c.[CountryCode], 
       COUNT(mc.[MountainId]) AS [MountainRanges]
FROM [Countries] AS c
LEFT JOIN [MountainsCountries] AS mc
ON c.[CountryCode] = mc.[CountryCode]
WHERE c.[CountryCode] IN ('BG', 'RU', 'US')
GROUP BY c.[CountryCode]

--Task 14

SELECT TOP (5) c.[CountryName],
               r.[RiverName]
FROM [Countries] as c
LEFT JOIN [CountriesRivers] AS cr
ON c.[CountryCode] = cr.[CountryCode]
LEFT JOIN [Rivers] as r
ON r.[Id] = cr.[RiverId]
LEFT JOIN [Continents] cn 
ON c.[ContinentCode] = cn.[ContinentCode]
WHERE cn.[ContinentName] = 'Africa'
ORDER BY c.[CountryName]

--Task 15
SELECT rc.[ContinentCode], rc.[CurrencyCode], rc.[CurrencyUsage]
FROM (
	SELECT c.[ContinentCode],
		   c.[CurrencyCode],
		   COUNT(c.[CurrencyCode]) AS [CurrencyUsage],
		   DENSE_RANK() OVER (PARTITION BY c.[ContinentCode] ORDER BY COUNT(c.[CurrencyCode]) DESC) AS [Rank] 
	FROM [Countries] c
	GROUP BY c.[ContinentCode], c.[CurrencyCode]) rc
WHERE rc.[Rank] = 1 AND rc.[CurrencyUsage] > 1

--Task 16

SELECT COUNT(c.[CountryCode]) AS [Count]
FROM [Countries] c
LEFT JOIN [MountainsCountries] mc ON c.[CountryCode] = mc.[CountryCode]
WHERE mc.[MountainId] IS NULL 

--Task 17
SELECT TOP (5) [CountryName] AS [Country],
       ISNULL([PeakName], '(no highest peak') AS [Highest Peak Name],
	   ISNULL([Elevation], 0) AS [Highest Peak Elevation],
	   ISNULL([MountainRange], '(no mountain)') AS [Mountain]
FROM
       (SELECT c.[CountryName],
       p.[PeakName],
	   p.[Elevation],
	   m.[MountainRange],
	   DENSE_RANK() OVER(PARTITION BY c.[CountryName] ORDER BY P.[Elevation] DESC) AS [PeakRank]
FROM [Countries] AS c
LEFT JOIN [MountainsCountries] AS mc
ON c.[CountryCode] = mc.[CountryCode]
LEFT JOIN [Mountains] AS m
ON mc.[MountainId] = m.[Id]
LEFT JOIN [Peaks] AS p
ON m.[Id] = p.[MountainId]) AS [PeakRankingSubQuery]
WHERE [PeakRank] = 1
ORDER BY [Country], [Highest Peak Name]

--Task 18

ELECT TOP(5)
    [CountryName] AS [Country],
	ISNULL([Result].[PeakName], '(no highest peak)') AS [Highest Peak Name],
	ISNULL([Result].[Elevation], 0) AS [Highest Peak Elevation],
	ISNULL([Result].[MountainRange],'(no mountain)') AS [Mountain]
FROM(SELECT 
		c.[CountryName],
		p.[PeakName],
		p.[Elevation],
		m.[MountainRange],
		DENSE_RANK() OVER (PARTITION BY c.[CountryName] ORDER BY p.[Elevation] DESC) AS [Rank]
     FROM [Countries] c
            LEFT JOIN [MountainsCountries] mc ON c.[CountryCode] = mc.[CountryCode]
            LEFT JOIN [Mountains] m ON mc.[MountainId] = m.[Id]
            LEFT JOIN [Peaks] p  ON m.[Id] = p.[MountainId]
          ) AS [Result]
 WHERE [Rank] = 1
 ORDER BY [Country], [Highest Peak Name]