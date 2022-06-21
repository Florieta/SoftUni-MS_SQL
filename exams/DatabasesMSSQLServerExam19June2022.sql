CREATE DATABASE [Zoo]

USE [Zoo]

CREATE TABLE [Owners] (
             [Id] INT PRIMARY KEY IDENTITY,
			 [Name] VARCHAR(50) NOT NULL,
			 [PhoneNumber] VARCHAR(15) NOT NULL,
			 [Address] VARCHAR(50)
)

CREATE TABLE [AnimalTypes] (
             [Id] INT PRIMARY KEY IDENTITY,
			 [AnimalType] VARCHAR(30) NOT NULL		 
)

CREATE TABLE [Cages] (
             [Id] INT PRIMARY KEY IDENTITY,
			 [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL	 
)

CREATE TABLE [Animals] (
             [Id] INT PRIMARY KEY IDENTITY,
			 [Name] VARCHAR(30) NOT NULL,
			 [BirthDate] DATE NOT NULL,
			 [OwnerId] INT FOREIGN KEY REFERENCES [Owners]([Id]),
			 [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL	 
)

CREATE TABLE [AnimalsCages](
             [CageId] INT FOREIGN KEY REFERENCES [Cages]([Id]) NOT NULL,
			 [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]) NOT NULL,
			 PRIMARY KEY ([CageId], [AnimalId])
)

CREATE TABLE [VolunteersDepartments] (
             [Id] INT PRIMARY KEY IDENTITY NOT NULL,
			 [DepartmentName] VARCHAR(30) NOT NULL
		
)

CREATE TABLE [Volunteers] (
             [Id] INT PRIMARY KEY IDENTITY NOT NULL,
			 [Name] VARCHAR(50) NOT NULL,
		     [PhoneNumber] VARCHAR(15) NOT NULL,
			 [Address] VARCHAR(50),
			 [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]),
			 [DepartmentId] INT FOREIGN KEY REFERENCES [VolunteersDepartments]([Id]) NOT NULL
)


INSERT INTO [Volunteers]([Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId])
VALUES 
('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', NULL, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO [Animals]([Name], [BirthDate], [OwnerId], [AnimalTypeId])
VALUES 
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', NULL, 1),
('Tuatara', '2021-06-30', 2, 4)


--3

SELECT Id FROM Owners
WHERE Name = 'Kaloqn Stoqnov'

UPDATE Animals
SET OwnerId = 4
WHERE OwnerId IS NULL

--4

SELECT Id FROM VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'

DELETE FROM Volunteers
WHERE DepartmentId = 2

DELETE FROM VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'

--5
SELECT [Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId] FROM [Volunteers]
ORDER BY [Name], [DepartmentId]

--6
SELECT a.Name, at.AnimalType, FORMAT(a.Birthdate, 'dd.MM.yyyy') FROM [Animals] AS a
LEFT JOIN [AnimalTypes] AS at
ON a.AnimalTypeId = at.Id
ORDER BY a.Name

--7
SELECT TOP(5) o.Name, COUNT(a.Id) AS CountOfAnimals FROM Owners AS o
JOIN Animals AS a
ON o.Id = a.OwnerId
GROUP BY o.Name
ORDER BY CountOfAnimals DESC, o.Name

--8

SELECT CONCAT(o.Name, '-', a.Name) AS [OwnersAnimals], o.PhoneNumber, ac.CageId  FROM Owners AS o
JOIN [Animals] AS a
ON a.OwnerId = o.Id
JOIN [AnimalTypes] AS at
ON at.Id = a.AnimalTypeId
JOIN AnimalsCages AS ac
ON a.Id = ac.AnimalId
WHERE AnimalType = 'mammals'
ORDER BY o.Name, a.Name DESC

--9




SELECT k.Name, k.PhoneNumber, LTRIM(SUBSTRING(k.Address, 8, 50)) FROM (SELECT v.Name, v.PhoneNumber, LTRIM(v.Address) AS Address FROM VolunteersDepartments vd
JOIN Volunteers v
ON vd.Id = v.DepartmentId
WHERE DepartmentName = 'Education program assistant' AND CHARINDEX('Sofia', v.Address) <> 0
) AS k
ORDER BY k.Name


--10

SELECT a.Name, YEAR(a.BirthDate) AS BirthYear, at.AnimalType FROM Animals AS a
LEFT JOIN AnimalTypes AS at
ON at.Id = a.AnimalTypeId
WHERE a.OwnerId IS NULL AND DATEDIFF(YEAR, a.BirthDate, '2022-01-01') < 5 AND at.AnimalType <> 'Birds'
ORDER BY a.Name


--11
GO
CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS 
BEGIN
DECLARE @departmentId INT = (SELECT [Id] FROM VolunteersDepartments WHERE [DepartmentName] = @VolunteersDepartment)

DECLARE @result INT = (SELECT COUNT(Id) FROM Volunteers WHERE [DepartmentId] = @departmentId)

RETURN @result
END 

--12

GO
CREATE PROC usp_AnimalsWithOwnersOrNot @AnimalName VARCHAR(30)
AS
BEGIN 
SELECT a.Name, ISNULL(o.Name, 'For adoption') AS [OwnerName] FROM Animals AS a
LEFT JOIN Owners AS o
ON a.OwnerId = o.Id
WHERE a.Name = @AnimalName
END