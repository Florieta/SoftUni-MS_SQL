CREATE DATABASE [Bitbucket]

USE [Bitbucket]

CREATE TABLE [Users](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Username] VARCHAR(30) NOT NULL,
			 [Password] VARCHAR(30) NOT NULL,
			 [Email] VARCHAR(50) NOT NULL
)

CREATE TABLE [Repositories](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Name] VARCHAR(30) NOT NULL
			 )

CREATE TABLE [RepositoriesContributors](
             [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
			 [ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL,
			 PRIMARY KEY ([RepositoryId], [ContributorId])
)
CREATE TABLE [Issues](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Title] VARCHAR(255) NOT NULL,
			 [IssueStatus] VARCHAR(6) NOT NULL,
			 [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
			 [AssigneeId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Commits](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Message] VARCHAR(255) NOT NULL,
			 [IssueId] INT FOREIGN KEY REFERENCES [Issues]([Id]),
			 [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
			 [ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Files](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Name] VARCHAR(100) NOT NULL,
			 [Size] DECIMAL(2) NOT NULL,
			 [ParentId] INT FOREIGN KEY REFERENCES [Files]([Id]),
			 [CommitId] INT FOREIGN KEY REFERENCES [Commits]([Id]) NOT NULL
)

--Task 2

INSERT INTO [Files]([Name], [Size], [ParentId], [CommitId])
VALUES 
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)


INSERT INTO [Issues]([Title], [IssueStatus], [RepositoryId], [AssigneeId])
VALUES 
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)

--Task 3
UPDATE [Issues]
SET [IssueStatus] = 'closed'
WHERE [AssigneeId] = 6

--Task 4
--SELECT * FROM [Repositories]
--WHERE [Name] = 'Softuni-Teamwork'

DELETE FROM [RepositoriesContributors]
WHERE [RepositoryId] = 3

DELETE FROM [Issues]
WHERE [RepositoryId] = 3

--Task 5
SELECT [Id], [Message], [RepositoryId], [ContributorId] FROM [Commits]
ORDER BY [Id], [Message], [RepositoryId], [ContributorId]

--Task 6
SELECT [Id], [Name], [Size] 
FROM [Files]
WHERE [Size] > 1000 AND [Name] LIKE '%html'
ORDER BY [Size] DESC, [Id], [Name]


--Task 7

SELECT 
i.[Id],
CAST(CONCAT(u.[Username], ' : ', i.[Title]) AS VARCHAR(MAX)) AS [IssueAssignee]
FROM [Issues] AS i
JOIN [Users] AS u
ON u.[Id] = i.[AssigneeId] 
ORDER BY [Id] DESC, [IssueAssignee]

--Task 8 

SELECT 
f.[Id], 
f.[Name],
CONCAT(f.[Size], 'KB') AS [Size]
FROM [Files] AS f
LEFT JOIN [Files] AS fl
ON fl.[ParentId] = f.[Id]
WHERE fl.[ParentId] IS NULL
ORDER BY [Id], [Name], [Size] DESC

--Task 9 

SELECT TOP(5)
r.[Id],
r. [Name],
COUNT(*) AS [Commits]
FROM [RepositoriesContributors] AS rc
JOIN [Repositories] AS r
ON r.[Id] = rc.[RepositoryId]
JOIN [Commits] AS c
ON c.[RepositoryId] = r.[Id]
GROUP BY r.[Id], r.[Name]
ORDER BY [Commits] DESC, r.[Id], r.[Name]

--Task 10

SELECT 
u.[UserName],
AVG(f.[Size]) AS [Size]
FROM [Commits] AS c
JOIN [Users] AS u
ON u.[Id] = c.[ContributorId]
JOIN [Files] AS f
ON f.[CommitId] = c.[Id]
GROUP BY [Username]
ORDER BY [Size] DESC, [Username]

--Task 11
GO

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(MAX)) 
RETURNS INT
AS
BEGIN
	DECLARE @id INT = (SELECT [Id] FROM [Users] WHERE [Username] = @username)

	DECLARE @result INT = (SELECT COUNT([Id]) FROM [Commits] WHERE [ContributorId] = @id)

	RETURN @result
END

--Task 12

GO

CREATE PROCEDURE usp_SearchForFiles(@fileExtension VARCHAR(MAX))
AS
BEGIN
	 SELECT
	       [Id],
		   [Name],
		   CONCAT([Size], 'KB') AS [Size]
	  FROM [Files]
	 WHERE [Name] LIKE '%' + @fileExtension + '%'
END