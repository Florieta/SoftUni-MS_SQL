CREATE DATABASE [ColonialJourney]

USE [ColonialJourney]

CREATE TABLE [Planets](
			 [Id] INT PRIMARY KEY IDENTITY,
			 [Name] VARCHAR(30) NOT NULL
)

CREATE TABLE [Spaceports](
			 [Id] INT PRIMARY KEY IDENTITY,
			 [Name] VARCHAR(50) NOT NULL,
			 [PlanetId] INT FOREIGN KEY REFERENCES [Planets]([Id]) NOT NULL
)

CREATE TABLE [Spaceships](
			 [Id] INT PRIMARY KEY IDENTITY,
			 [Name] VARCHAR(50) NOT NULL,
			 [Manufacturer] VARCHAR(30) NOT NULL,
			 [LightSpeedRate] INT DEFAULT(0)
)

CREATE TABLE [Colonists](
			 [Id] INT PRIMARY KEY IDENTITY,
			 [FirstName] VARCHAR(20) NOT NULL,
			 [LastName] VARCHAR(20) NOT NULL,
			 [Ucn] VARCHAR(10) NOT NULL UNIQUE,
			 [Birthdate] DATE NOT NULL
)

CREATE TABLE [Journeys](
			 [Id] INT PRIMARY KEY IDENTITY,
			 [JourneyStart] DATETIME2 NOT NULL,
			 [JourneyEnd] DATETIME2 NOT NULL,
			 [Purpose] VARCHAR(11),
			 [DestinationSpaceportId] INT FOREIGN KEY REFERENCES [Spaceports]([Id]) NOT NULL,
			 [SpaceshipId] INT FOREIGN KEY REFERENCES [Spaceships]([Id]) NOT NULL,
			 CHECK ([Purpose] IN ('Medical', 'Technical', 'Educational', 'Military'))
)
CREATE TABLE [TravelCards](
			 [Id] INT PRIMARY KEY IDENTITY,
			 [CardNumber] VARCHAR(10) NOT NULL UNIQUE,
			 [JobDuringJourney] VARCHAR(8),
			 [ColonistId] INT FOREIGN KEY REFERENCES [Colonists]([Id]) NOT NULL,
			 [JourneyId] INT FOREIGN KEY REFERENCES [Journeys]([Id]) NOT NULL,
			 CHECK ([JobDuringJourney] IN ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'))
)

--Task 2

INSERT INTO [Planets]([Name])
VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

INSERT INTO [Spaceships]([Name], [Manufacturer], [LightSpeedRate])
VALUES
('Golf', 'VW', 3),
('WakaWaka', 'Wakanda', 4),
('Falcon9', 'SpaceX', 1),
('Bed', 'Vidolov', 6)

--Task 3
UPDATE [Spaceships]
SET [LightSpeedRate] +=1
WHERE [Id] BETWEEN 8 AND 12

--Task 4

DELETE 
FROM [TravelCards]
WHERE [JourneyId] IN (1, 2, 3)

DELETE 
FROM [Journeys]
WHERE [Id] IN (1, 2, 3)

--Task 5
SELECT [Id], FORMAT([JourneyStart], 'dd/MM/yyyy'), FORMAT([JourneyEnd], 'dd/MM/yyyy')  FROM [Journeys]
WHERE [Purpose] = 'Military'
ORDER BY [JourneyStart]

--Task 6

SELECT c.[Id] AS [id], CONCAT(c.[FirstName], ' ', c.[LastName]) AS [full_name] FROM [Colonists] AS c
LEFT JOIN [TravelCards] AS tc
ON c.[Id] = tc.[ColonistId]
WHERE [JobDuringJourney] = 'Pilot'
ORDER BY [id]

--Task 7

SELECT COUNT(*) AS [count] 
FROM [Colonists] AS c
LEFT JOIN [TravelCards] AS tc
ON c.[Id] = tc.[ColonistId]
LEFT JOIN [Journeys] AS j
ON tc.[JourneyId] = j.[Id]
WHERE [Purpose] = 'Technical'

--Task 8

SELECT s.[Name], s.[Manufacturer] FROM [Spaceships] AS s
JOIN [Journeys] AS j
ON s.[Id] = j.[SpaceshipId]
JOIN [TravelCards] tc
ON tc.[JourneyId] = j.[Id]
JOIN [Colonists] AS c
ON tc.[ColonistId] = c.[Id]
WHERE TC.[JobDuringJourney] = 'Pilot' AND DATEDIFF(YEAR,c.[BirthDate], '01/01/2019') < 30
ORDER BY [Name]

--Task 9 

SELECT p.[Name], COUNT(*) AS [JourneysCount] 
FROM [Planets] AS p
JOIN [Spaceports] AS sp
ON p.[Id] = sp.[PlanetId]
JOIN [Journeys] AS j
ON sp.[Id] = j.[DestinationSpaceportId]
GROUP BY p.[Name]
ORDER BY [JourneysCount] DESC, p.[Name]


--Task 10

SELECT 
	* FROM 
	(
	SELECT
	tc.[JobDuringJourney],
	c.[FirstName] + ' ' + c.[LastName] AS [FullName],
	DENSE_RANK() OVER(PARTITION BY [JobDuringJourney] ORDER BY c.[BirthDate]) AS [JobRank]
	FROM [Colonists] c JOIN [TravelCards] tc ON tc.[ColonistId] = c.[Id]
	) AS k
	WHERE k.[JobRank] = 2

--Task 11

GO

CREATE FUNCTION udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT
AS
BEGIN

	DECLARE 
		@Result INT = (SELECT 
						COUNT(*)
						FROM [Planets] p
						JOIN [Spaceports] sp ON sp.[PlanetId] = p.[Id]
						JOIN [Journeys] j ON j.[DestinationSpaceportId] = sp.[Id]
						JOIN [TravelCards] tc ON tc.[JourneyId] = j.[Id]
						JOIN [Colonists] c ON c.[Id] = tc.[ColonistId]
						WHERE p.[Name] = @PlanetName
					  );

	RETURN @Result;

END

GO

--Task 12

CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(11))
AS
BEGIN

	IF NOT EXISTS (SELECT * FROM [Journeys] WHERE [Id] = @JourneyId)
		THROW 50001, 'The journey does not exist!', 1
	
	IF ((SELECT [Purpose] FROM [Journeys] WHERE [Id] = @JourneyId) = @NewPurpose)
		THROW 50002, 'You cannot change the purpose!', 1
	
	UPDATE 
		[Journeys]
		SET [Purpose] = @NewPurpose
		WHERE [Id] = @JourneyId

END
