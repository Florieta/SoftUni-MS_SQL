USE [Gringotts]
--Task 1
SELECT COUNT([Id]) AS [Count]
FROM [WizzardDeposits]

--Task 2
SELECT TOP(1) [MagicWandSize] AS [LongestMagicWand]
FROM [WizzardDeposits]
ORDER BY [MagicWandSize] DESC

--Task 3

SELECT [DepositGroup],
       MAX([MagicWandSize]) AS [LongestMagicWand]
  FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--Task 4 

SELECT TOP(2) [DepositGroup]
  FROM [WizzardDeposits]
GROUP BY [DepositGroup]
ORDER BY AVG([MagicWandSize]) 

--Task 5
SELECT [DepositGroup],
SUM([DepositAmount]) AS [TotalSum]
  FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--Task 6
SELECT [DepositGroup],
       SUM([DepositAmount]) AS [TotalSum]
  FROM [WizzardDeposits]
 WHERE [MagicWandCreator] = 'Ollivander Family'
GROUP BY [DepositGroup]

--Task 7
SELECT [DepositGroup],
       SUM([DepositAmount]) AS [TotalSum]
  FROM [WizzardDeposits]
 WHERE [MagicWandCreator] = 'Ollivander Family'
GROUP BY [DepositGroup]
HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

--Task 8
SELECT [DepositGroup],
       [MagicWandCreator],
       MIN([DepositCharge]) AS [MinDepositCharge]
  FROM [WizzardDeposits]
GROUP BY [DepositGroup], [MagicWandCreator]
ORDER BY [MagicWandCreator], [DepositGroup]


--Task 9
SELECT [AgeGroup],
       COUNT([Id]) AS [WizzardCount]
FROM(SELECT *,
        CASE
		    WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
			ELSE '[61+]'
		END AS [AgeGroup]
	FROM [WizzardDeposits]) AS [AgeGroupingQuery]
GROUP BY [AgeGroup]

--Task 10
SELECT DISTINCT LEFT([FirstName],1) AS [FirstLetter]
FROM [WizzardDeposits]
WHERE [DepositGroup] = 'Troll Chest'
GROUP BY [FirstName]



--Task 11

  SELECT [DepositGroup], [IsDepositExpired], 
         AVG([DepositInterest]) AS [AverageInterest]
    FROM [WizzardDeposits]
   WHERE [DepositStartDate] > '1985-01-01'
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] DESC, [IsDepositExpired]

--Task 12
SELECT SUM([Difference]) AS [SumDifference]
FROM (SELECT [FirstName] AS [Host Wizzard],
       [DepositAmount] AS [Host Wizzard Deposit],
	   LEAD([FirstName]) OVER(ORDER BY [Id]) AS [Guest Wizzard],
	   LEAD([DepositAmount]) OVER(ORDER BY [Id]) AS [Guest Wizzard Deposit],
	   [DepositAmount] - LEAD([DepositAmount]) OVER(ORDER BY [Id]) AS [Difference]
    FROM [WizzardDeposits]) AS [DifferenceSubQuery]

	USE [SoftUni]

--Task 13
SELECT [DepartmentID],
       SUM([Salary]) AS [TotalSalary]
FROM [Employees]
GROUP BY [DepartmentID]

--Task 14
SELECT [DepartmentID],
       MIN([Salary]) AS [MinimumSalary]
FROM [Employees]
WHERE [DepartmentID] IN (2,5,7) AND [HireDate] > '01/01/2000'
GROUP BY [DepartmentID]

--Task 15

SELECT *
INTO [EmployeesWithSalaryHigherThan30000]
FROM [Employees]
WHERE [Salary] > 30000

DELETE FROM [EmployeesWithSalaryHigherThan30000]
WHERE [ManagerID] = 42

UPDATE [EmployeesWithSalaryHigherThan30000]
SET [Salary] += 5000
WHERE [DepartmentID] = 1

SELECT [DepartmentID],
       AVG([Salary]) AS [AverageSalary]
FROM [EmployeesWithSalaryHigherThan30000]
GROUP BY [DepartmentID]

--Task 16 
SELECT [DepartmentID],
       MAX([Salary]) AS [MaxSalary]
FROM [Employees]
GROUP BY [DepartmentID]
HAVING MAX([Salary]) < 30000 OR MAX([Salary]) > 70000

--Task 17 
SELECT COUNT([Salary]) AS [Count]
FROM [Employees]
WHERE [ManagerID] IS NULL

--Task 18
SELECT DISTINCT [DepartmentID],
                [Salary] AS [ThirdHighestSalary]
FROM (
		SELECT e.[DepartmentID],
		       e.[Salary],
		DENSE_RANK() OVER(PARTITION BY e.[DepartmentID] ORDER BY e.[Salary] DESC) AS [SalaryRank]
		FROM [Employees] AS e
		)AS [SalaryRankSubQuery]
WHERE [SalaryRank] = 3

--Task 19

SELECT TOP (10) 
       e.[FirstName],
       e.[LastName],
	   e.[DepartmentID]
FROM [Employees] AS e
WHERE [Salary] > (
					  SELECT AVG(esub.[Salary]) AS [DepartmentAverageSalary]
						FROM [Employees] AS esub
					   WHERE esub.[DepartmentID] = e.[DepartmentID]
					GROUP BY esub.[DepartmentID]
                 )
ORDER BY E.[DepartmentID]

