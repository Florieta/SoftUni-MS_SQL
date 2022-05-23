CREATE DATABASE [Airport]

USE [Airport]
--Task 1

CREATE TABLE [Passengers](
             [Id] INT PRIMARY KEY IDENTITY,
			 [FullName] VARCHAR(100) NOT NULL UNIQUE,
			 [Email] VARCHAR(50) NOT NULL,
)

CREATE TABLE [Pilots](
             [Id] INT PRIMARY KEY IDENTITY,
			 [FirstName] VARCHAR(30) NOT NULL UNIQUE,
			 [LastName] VARCHAR(30) NOT NULL UNIQUE,
			 [Age] TINYINT NOT NULL,
			 [Rating] FLOAT,
			 CHECK ([Age] >= 21 AND [Age] <= 62),
			 CHECK ([Rating] >= 0.0 AND [Rating] <= 10.0)
)

CREATE TABLE [AircraftTypes](
             [Id] INT PRIMARY KEY IDENTITY,
			 [TypeName] VARCHAR(30) NOT NULL UNIQUE
)

CREATE TABLE [Aircraft](
             [Id] INT PRIMARY KEY IDENTITY,
			 [Manufacturer] VARCHAR(25) NOT NULL,
			 [Model] VARCHAR(30) NOT NULL,
			 [Year] INT NOT NULL,
			 [FlightHours] INT,
			 [Condition] NCHAR(1) NOT NULL,
			 [TypeId] INT FOREIGN KEY REFERENCES [AircraftTypes]([Id]) NOT NULL
			 
)

CREATE TABLE [PilotsAircraft](
             [AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]) NOT NULL,
			 [PilotId] INT FOREIGN KEY REFERENCES [Pilots]([Id]) NOT NULL,
			 PRIMARY KEY([AircraftId], [PilotId])
)

CREATE TABLE [Airports](
             [Id] INT PRIMARY KEY IDENTITY,
			 [AirportName] VARCHAR(70) NOT NULL UNIQUE,
			 [Country] VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE [FlightDestinations](
             [Id] INT PRIMARY KEY IDENTITY,
			 [AirportId] INT FOREIGN KEY REFERENCES [Airports]([Id]) NOT NULL,
			 [Start] DATETIME2 NOT NULL,
			 [AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]) NOT NULL,
			 [PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL,
			 [TicketPrice] DECIMAL(18,2) NOT NULL DEFAULT(15)
			 
)

--Task 2
INSERT INTO Passengers([FullName], [Email])
SELECT CONCAT([FirstName], ' ', [LastName]) AS [FullName],
CONCAT([FirstName], [LastName], '@', 'gmail.com') AS [Email]
FROM Pilots
WHERE [Id] >= 5 AND [Id] <= 15

--Task 3

UPDATE [Aircraft]
SET [Condition] = 'A'
WHERE ([Condition] = 'B' OR [Condition] = 'C') AND ([FlightHours] IS NULL OR [FlightHours] BETWEEN 0 AND 100) AND ([YEAR] >= 2013) 

--Task 4

DELETE FROM [Passengers]
WHERE (LEN([FullName]) <= 10)

--Task 5

SELECT [Manufacturer], [Model], [FlightHours], [Condition] FROM [Aircraft]
ORDER BY [FlightHours] DESC

--Task 6
SELECT [FirstName], [LastName], a.[Manufacturer], a.[Model], a.[FlightHours] FROM [Aircraft] AS a
JOIN [PilotsAircraft] AS pa
ON a.[Id] = pa.[AircraftId]
JOIN [Pilots] AS p
ON p.[Id] = pa.[PilotId]
WHERE a.[FlightHours] IS NOT NULL AND (a.[FlightHours] BETWEEN 0 AND 304)
ORDER BY a.[FlightHours] DESC, p.[FirstName]

--Task 7

SELECT TOP(20) fd.[Id] AS [DestinationId], fd.[Start], p.[FullName], a.[AirportName], fd.[TicketPrice] FROM [FlightDestinations] as fd
LEFT JOIN [Passengers] as p
ON fd.[PassengerId] = p.[Id]
LEFT JOIN [Airports] AS a
ON fd.[AirportId] = a.[Id]
WHERE DAY([Start]) % 2 = 0
ORDER BY [TicketPrice] DESC, [AirportName]


