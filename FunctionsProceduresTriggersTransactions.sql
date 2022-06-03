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


--Task 7
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(50))
RETURNS BIT
AS
BEGIN

	DECLARE @i TINYINT = 1;

	WHILE LEN(@word) >= @i
	BEGIN
		DECLARE @currentLetter NVARCHAR(1) = SUBSTRING(@word, @i, 1);

		IF(@setOfLetters NOT LIKE '%' + @currentLetter + '%') -- IF(CHARINDEX(@currentLetter, @setOfLetters) = 0)
		  RETURN 0

		SET @i += 1;
	END

  RETURN 1

END

--Task 8
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
     DELETE FROM [EmployeesProjects]
	 WHERE [EmployeeID] IN (
	                         SELECT [EmployeeID]
							 FROM [Employees]
							 WHERE [DepartmentID] = @departmentId
							 )

	UPDATE [Employees]
	SET [ManagerID] = NULL
	WHERE [ManagerID] IN (
							SELECT [EmployeeID]
							 FROM [Employees]
							 WHERE [DepartmentID] = @departmentId
	)

	ALTER TABLE [Departments]
	ALTER COLUMN [ManagerID] INT

	UPDATE [Departments]
	SET [ManagerID] = NULL
	WHERE [ManagerID] IN (
							SELECT [EmployeeID]
							 FROM [Employees]
							 WHERE [DepartmentID] = @departmentId
	)

	DELETE FROM [Employees]
	WHERE [DepartmentID] = @departmentId

	DELETE FROM [Departments]
	WHERE [DepartmentID] = @departmentId

	SELECT COUNT(*)
	FROM [Employees]
	WHERE [DepartmentID] = @departmentId
END

--Task 9 

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS
BEGIN
DELETE FROM [EmployeesProjects]
	  WHERE [EmployeeID] IN (
							SELECT [EmployeeID]
							  FROM [Employees]
							 WHERE [DepartmentID] = @departmentId
							 )
	UPDATE [Employees]
	   SET [ManagerID] = NULL
	 WHERE [ManagerID] IN (
					      SELECT [EmployeeID]
							FROM [Employees]
						   WHERE [DepartmentID] = @departmentId
						  )
 ALTER TABLE [Departments]
ALTER COLUMN [ManagerID] INT --NULL

UPDATE [Departments]
   SET [ManagerID] = NULL
   WHERE [ManagerID] IN (
					      SELECT [EmployeeID]
							FROM [Employees]
						   WHERE [DepartmentID] = @departmentId
						  )
DELETE FROM [Employees]
      WHERE [DepartmentID] = @departmentId

DELETE FROM [Departments]
      WHERE [DepartmentID] = @departmentId

	  SELECT COUNT(*)
	    FROM [Employees]
	   WHERE [DepartmentID] = @departmentId


END

--Task 10

CREATE PROC usp_GetHoldersWithBalanceHigherThan(@inputSalary MONEY)
AS
BEGIN
SELECT 
	ah.FirstName,
	ah.LastName
	FROM Accounts a
	JOIN AccountHolders ah ON ah.Id = a.AccountHolderId
	GROUP BY a.AccountHolderId, ah.FirstName, ah.LastName
	HAVING SUM(a.Balance) > @inputSalary
	ORDER BY ah.FirstName, ah.LastName
END


--Task 11
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numberOfyears INT)
RETURNS DECIMAL(18, 4)
AS
BEGIN

	DECLARE @x FLOAT = 1 + @yearlyInterestRate;
	
	DECLARE @calculate DECIMAL(18,4) = @sum * (POWER(@x, @numberOfyears));
	
	RETURN @calculate 

END

--Task 12
CREATE PROC usp_CalculateFutureValueForAccount (@accountID INT ,@interestRate FLOAT)
AS
BEGIN

	SELECT
		a.Id AS [Account Id],
		ah.FirstName AS [First Name],
		ah.LastName AS [Last Name],
		a.Balance AS [Current Balance],
		dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5) AS [Balance in 5 years]
		FROM Accounts a
		JOIN AccountHolders ah ON ah.Id = a.AccountHolderId
		WHERE a.Id = @accountID

END

--Task 13
CREATE FUNCTION ufn_CashInUsersGames (@gameName NVARCHAR(50))
RETURNS TABLE
AS 
RETURN SELECT (
			SELECT 
				  SUM([Cash]) AS [SumCash]
			FROM(
				  SELECT g.[Name],
						  ug.[Cash],
					ROW_NUMBER() OVER(PARTITION BY g.[Name] ORDER BY ug.[Cash] DESC) AS [RowNumber]
					FROM [UsersGames] AS ug
					JOIN [Games] AS g
					ON ug.[GameId] = g.[Id]
					WHERE g.[Name] = @gameName
				) AS [RowNumberSubQuery]
			WHERE [RowNumber] % 2 <> 0
) AS [SumCash]


--Task 14

CREATE TRIGGER tr_AddToLogsOnAccountUpdate ON Accounts FOR UPDATE
AS
BEGIN
	INSERT INTO Logs (AccountId, OldSum, NewSum)
			SELECT i.Id, d.Balance, i.Balance
			FROM inserted i
			JOIN deleted d ON d.Id = i.Id
			WHERE i.Balance != d.Balance;
END

--Task 15

CREATE TRIGGER tr_NotificationEmail ON Logs FOR INSERT
AS
BEGIN

	INSERT INTO 
		NotificationEmails 
		(Recipient, [Subject], [Body])
		SELECT 
		i.LogId,
		'Balance change for account: ' + CAST(i.AccountId AS NVARCHAR(20)),
		'On ' + CAST(GETDATE() AS NVARCHAR(50)) + 
		' your balance was changed from ' + 
		CAST(i.OldSum AS NVARCHAR(20)) + 
		' to ' + 
		CAST(i.NewSum AS NVARCHAR(20)) + 
		'.'
		FROM inserted i

END

--Task 16 


--Task 17

--Task 18

CREATE PROC usp_TransferMoney @SenderId INT,@ReceiverId INT,@MoneyAmount DECIMAL(18,4)
AS
BEGIN TRANSACTION
	EXEC usp_WithdrawMoney @SenderId,@MoneyAmount
	EXEC usp_DepositMoney @ReceiverId,@MoneyAmount
COMMIT


--Task 20

DECLARE @UserGameId INT = 
(
	SELECT Id
		FROM UsersGames
		WHERE UserId = (SELECT Id FROM Users WHERE Username = 'Stamat')
			  AND GameId = (SELECT Id FROM Games WHERE [Name] = 'Safflower')
)

DECLARE @StamatCash DECIMAL(18,2) = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
DECLARE @ItemsPrice DECIMAL(18,2) = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 11 AND 12)

IF(@StamatCash >= @ItemsPrice)
BEGIN 
	BEGIN TRANSACTION
		INSERT INTO UserGameItems
		SELECT Id,@UserGameId FROM Items  WHERE MinLevel BETWEEN 11 AND 12

		UPDATE UsersGames
			SET Cash = Cash - @ItemsPrice
			WHERE Id = @UserGameId
	COMMIT
END

SET @StamatCash  = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
SET @ItemsPrice  = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21)

IF(@StamatCash >= @ItemsPrice)
BEGIN 
	BEGIN TRANSACTION
		INSERT INTO UserGameItems
		SELECT Id,@UserGameId FROM Items  WHERE MinLevel BETWEEN 19 AND 21

		UPDATE UsersGames
			SET Cash = Cash - @ItemsPrice
			WHERE Id = @UserGameId
	COMMIT
END

SELECT it.[Name] AS [Item Name]
	FROM UsersGames AS ug
	JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
	JOIN Items AS it ON it.Id = ugi.ItemId
	WHERE ug.Id = @UserGameId
 ORDER BY [Item Name]

--Task 21 

CREATE PROC usp_AssignProject @emloyeeId INT , @projectID INT
AS
BEGIN TRANSACTION

 	DECLARE @EmployeeProjectsCount INT = (SELECT COUNT(*)
												FROM  EmployeesProjects
											WHERE EmployeeID = @emloyeeId)
	IF (@EmployeeProjectsCount >= 3)
	BEGIN
		ROLLBACK
		RAISERROR('The employee has too many projects!',16,1)
	END
	INSERT INTO EmployeesProjects(EmployeeID,ProjectID) VALUES
	(@emloyeeId,@projectID)
COMMIT

--Task 22

CREATE TRIGGER tr_AddToDeletedEmployees ON Employees FOR DELETE
AS
BEGIN

  INSERT INTO 
	Deleted_Employees 
	(FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT 
	d.FirstName, d.LastName, d.MiddleName, d.JobTitle, d.DepartmentID, d.Salary
	FROM deleted d

END