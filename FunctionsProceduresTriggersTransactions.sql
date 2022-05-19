USE [SoftUni]

--Task 1
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
     SELECT [FirstName],
	        [LastName]
	   FROM [Employees]
	  WHERE [Salary] > 35000
END

--Task 2

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @minSalary DECIMAL(18, 4)
AS
BEGIN
     SELECT [FirstName],
	        [LastName]
	   FROM [Employees]
	  WHERE [Salary] >= @minSalary
END

--Task 3
CREATE PROCEDURE usp_GetTownsStartingWith @string VARCHAR(10) 
AS
BEGIN
     SELECT [Name]
	   FROM [Towns]
	  WHERE [Name] LIKE @string + '%'
END

GO 

EXEC usp_GetTownsStartingWith B 

GO 
--Task 4

CREATE PROCEDURE usp_GetEmployeesFromTown @townName VARCHAR(50)
AS
BEGIN
     SELECT e.[FirstName],
	        e.[LastName]
	   FROM [Employees] AS e
	  LEFT JOIN [Addresses] AS a
	  ON e.[AddressID] = a.[AddressID]
	  LEFT JOIN [Towns] AS t
	  ON a.[TownID] = t.[TownID]
	  WHERE t.[Name] = @townName
END

--Task 5 
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(7)
AS
BEGIN
     DECLARE @salaryLevel VARCHAR(7)
     IF @salary < 30000
	 BEGIN
	      SET @salaryLevel = 'Low'
	 END
	 ELSE IF @salary BETWEEN 30000 AND 50000
	 BEGIN
	      SET @salaryLevel = 'Average'
	 END
	 ELSE
	  BEGIN
	      SET @salaryLevel = 'High'
	 END

	 RETURN @salaryLevel
END

--Task 6 

CREATE PROCEDURE usp_EmployeesBySalaryLevel @salaryLevel VARCHAR(7)
AS
BEGIN
     SELECT [FirstName],
	        [LastName]
	   FROM [Employees] AS e
	  WHERE dbo.ufn_GetSalaryLevel([Salary]) = @salaryLevel
END

