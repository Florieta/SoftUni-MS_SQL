CREATE DATABASE [Service]

Use [Service]

CREATE TABLE [Users](
             [Id] INT PRIMARY KEY IDENTITY NOT NULL,
			 [Username] NVARCHAR(30) NOT NULL UNIQUE,
			 [Password] NVARCHAR(50) NOT NULL,
			 [Name] NVARCHAR(50),
			 [Birthdate] DATETIME2,
			 [Age] INT,
			 [Email] NVARCHAR(50) NOT NULL,
			 CHECK ([Age] >= 14 AND [Age] <= 110)
)

CREATE TABLE [Departments](
             [Id] INT PRIMARY KEY IDENTITY NOT NULL,
			 [Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Employees](
             [Id] INT PRIMARY KEY IDENTITY NOT NULL,
			 [FirstName] NVARCHAR(25),
			 [LastName] NVARCHAR(25),
			 [Birthdate] DATETIME2,
			 [Age] INT,
			 [DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]),
			 CHECK ([Age] >= 18 AND [Age] <= 110)
)

CREATE TABLE [Categories](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Name] NVARCHAR(50) NOT NULL,
			 [DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL
)

CREATE TABLE [Status](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Label] NVARCHAR(30) NOT NULL
)

CREATE TABLE [Reports](
             [Id] INT PRIMARY KEY IDENTITY NOT NULL,
			 [CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
			 [StatusId] INT FOREIGN KEY REFERENCES [Status]([Id]) NOT NULL,
			 [OpenDate] DATETIME2 NOT NULL,
			 [CloseDate] DATETIME2,
			 [Description] NVARCHAR(200) NOT NULL,
			 [UserId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL,
			 [EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id])
)

--Task 2

INSERT INTO [Employees]([FirstName], [LastName], [Birthdate], [DepartmentId])
VALUES 
('Marlo', 'O''Malley', '1958-9-21', 1),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO [Reports]([CategoryId],	[StatusId],	[OpenDate],	[CloseDate], [Description],	[UserId], [EmployeeId])
VALUES
(1,	1,'2017-04-13',	NULL, 'Stuck Road on Str.133', 6, 2),
(6,	3, '2015-09-05', '2015-12-06', 'Charity trail running',	3, 5),
(14, 2, '2015-09-07', NULL,	'Falling bricks on Str.58',	5, 2),
(4,	3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11',	1, 1)

--Task 3

UPDATE [Reports]
SET [CloseDate] = GETDATE()
WHERE [CloseDate] IS NULL

--Task 4

DELETE FROM [Reports]
WHERE [StatusId] = 4

--Task 5

SELECT [Description],
       FORMAT([OpenDate], 'dd-MM-yyyy')
FROM [Reports]
WHERE [EmployeeId] IS NULL
ORDER BY [OpenDate], [Description]

--Task 6
SELECT r.[Description], c.[Name] AS [CategoryName]
FROM [Reports] AS r
LEFT JOIN [Categories] AS c
ON r.[CategoryId] = c.[Id]
WHERE r.[CategoryId] IS NOT NULL
ORDER BY [Description], [CategoryName]

--Task 7
SELECT TOP(5) c.[Name],
COUNT(*) AS [ReportsNumber]
FROM [Reports] AS r
LEFT JOIN [Categories] AS c
ON r.[CategoryId] = c.[Id]
GROUP BY r.[CategoryId], c.[Name]
ORDER BY [ReportsNumber] DESC, c.[Name]

--Task 8 

SELECT [Username], 
c.[Name] AS [CategoryName] 
FROM [Reports] AS r
JOIN [Users] AS u
ON u.[Id] = r.[UserId]
JOIN [Categories] AS c
ON c.[Id] = r.[CategoryId]
WHERE 
DATEPART(MONTH, r.[OpenDate]) = 
DATEPART(MONTH, u.[Birthdate])
AND
DATEPART(DAY, r.[OpenDate]) = 
DATEPART(DAY, u.[Birthdate])
ORDER BY [Username], c.[Name]

--Task 9

SELECT CONCAT(e.FirstName,' ', e.LastName) AS [Full Name], 
COUNT(r.UserId) AS [UserCount] FROM Employees AS e
LEFT JOIN Reports AS r
ON e.Id = r.EmployeeId
GROUP BY FirstName, LastName
ORDER BY [UserCount] DESC, [Full Name] ASC

--Task 10
SELECT 
ISNULL(e.[FirstName] + ' ' + e.[LastName], 'None') AS [Employee],
ISNULL(d.[Name], 'None') AS [Department],
ISNULL(c.[Name], 'None') AS [Category],
r.[Description],
FORMAT(r.[OpenDate], 'dd.MM.yyyy') AS [OpenDate],
s.[Label] AS [Status],
ISNULL(u.[Name], 'None') AS [User]
FROM [Reports] AS r
lEFT JOIN [Employees] AS e
ON e.[Id] = r.[EmployeeId]
LEFT JOIN [Categories] AS c
ON c.[Id] = r.[CategoryId]
LEFT JOIN [Departments] AS d
ON d.[Id] = e.[DepartmentId]
LEFT JOIN [Status] AS s
ON s.[Id] = r.[StatusId]
LEFT JOIN [Users] AS u
ON u.[Id] = r.[UserId]
ORDER BY 
[FirstName] DESC, [LastName] DESC, d.[Name], c.[Name], 
r.[Description], r.[OpenDate], s.[Label], u.[Name] 

--11.	Hours to Complete
GO

CREATE FUNCTION udf_HoursToComplete
(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS 
BEGIN
IF (@StartDate IS NULL)
RETURN 0;
IF (@EndDate IS NULL)
RETURN 0;
RETURN DATEDIFF(HOUR, @StartDate, @EndDate)
END

--Task 12
CREATE PROCEDURE usp_AssignEmployeeToReport
(@EmployeeId INT, @ReportId INT)
AS
BEGIN

DECLARE @EmployeeDepId INT =
(SELECT [DepartmentId] 
FROM [Employees]
WHERE [Id] = @EmployeeId);

DECLARE @ReportDepId INT = 
(SELECT c.[DepartmentId]  
FROM [Reports] AS r
JOIN [Categories] AS c
ON c.[Id] = r.[CategoryId]
WHERE r.[Id] = @ReportId
);

IF (@EmployeeDepId <> @ReportDepId)
THROW 50000, 'Employee doesn''t belong to the appropriate department!',1

UPDATE [Reports] 
SET [EmployeeId] = @EmployeeId
WHERE [Id] = @ReportId
END