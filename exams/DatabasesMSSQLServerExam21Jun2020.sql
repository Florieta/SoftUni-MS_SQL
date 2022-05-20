CREATE DATABASE [TripService]

USE [TripService]
--Task 1
CREATE TABLE [Cities](
             [Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			 [Name] NVARCHAR(20) NOT NULL,
			 [CountryCode] CHAR(2) NOT NULL,
)

CREATE TABLE [Hotels](
             [Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			 [Name] NVARCHAR(30) NOT NULL,
			 [CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL,
			 [EmployeeCount] INT NOT NULL,
			 [BaseRate] DECIMAL(18, 2)

)

CREATE TABLE [Rooms](
             [Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			 [Price] DECIMAL(18, 2) NOT NULL,
			 [Type] NVARCHAR(20) NOT NULL,
			 [Beds] INT NOT NULL,
			 [HotelId] INT FOREIGN KEY REFERENCES [Hotels]([Id]) NOT NULL
)

CREATE TABLE [Trips](
             [Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			 [RoomId] INT FOREIGN KEY REFERENCES [Rooms]([Id]) NOT NULL,
			 [BookDate] DATE NOT NULL,
			 [ArrivalDate] DATE NOT NULL,
			 [ReturnDate] DATE NOT NULL,
			 [CancelDate] DATE,
			 CHECK ([BookDate] < [ArrivalDate]),
			 CHECK ([ArrivalDate] < [ReturnDate])
)

CREATE TABLE [Accounts](
             [Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			 [FirstName] NVARCHAR(50) NOT NULL,
			 [MiddleName] NVARCHAR(20),
			 [LastName] NVARCHAR(50) NOT NULL,
			 [CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL,
			 [BirthDate] DATE NOT NULL,
			 [Email] VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE [AccountsTrips](
             [AccountId] INT FOREIGN KEY REFERENCES [Accounts]([Id]) NOT NULL,
			 [TripId] INT FOREIGN KEY REFERENCES [Trips]([Id]) NOT NULL,
			 [Luggage] INT NOT NULL,
			 PRIMARY KEY([AccountId], [TripId]),
			 CHECK ([Luggage] >= 0) 
)

--Task 2

INSERT INTO [Accounts]([FirstName], [MiddleName], [LastName], [CityId], [BirthDate], [Email])
VALUES 
('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')


INSERT INTO [Trips]([RoomId], [BookDate], [ArrivalDate], [ReturnDate], [CancelDate])
VALUES 
(101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
(102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
(103, '2013-07-17', '2013-07-23', '2013-07-24',	NULL),
(104, '2012-03-17',	'2012-03-31', '2012-04-01',	'2012-01-10'),
(109, '2017-08-07',	'2017-08-28', '2017-08-29',	NULL)

--Task 3

UPDATE [Rooms]
SET [Price] += ([Price] * 0.14)
WHERE [HotelId] IN (5,7,9)

--Task 4

DELETE FROM [AccountsTrips]
WHERE [AccountId] = 47

--Task 5

SELECT [FirstName], [LastName], FORMAT([BirthDate], 'MM-dd-yyyy'), [Name] AS [Hometown], [Email] FROM [Accounts] AS a
JOIN [Cities] AS c
ON a.[CityId] = c.[Id]
WHERE [Email] LIKE 'e%'
ORDER BY c.[Name]

--Task 6

SELECT c.[Name] AS [City],
       COUNT(h.[Name]) AS [Hotels]
FROM [Cities] AS c
JOIN [Hotels] AS h
ON c.[Id] = h.[CityId]
GROUP BY h.[CityId], c.[Name]
ORDER BY [Hotels] DESC, [City]

--Task 7 
SELECT [AccountId],
[FullName],
MAX([Days]) AS [LongestTrip],
MIN([Days]) AS [ShortestTrip]
       FROM(
SELECT a.[Id] AS [AccountId],
       CONCAT(a.[FirstName], ' ', a.[LastName]) AS [FullName],
       DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate]) AS [Days]
FROM [Accounts] AS a
JOIN [AccountsTrips] AS ats
ON a.[Id] = ats.[AccountId]
JOIN [Trips] as t
ON ats.TripId = t.Id
WHERE a.[MiddleName] IS NULL AND t.[CancelDate] IS NULL) AS [DaysSubQuery]
GROUP BY [FullName], [AccountId]
ORDER BY [LongestTrip] DESC, [ShortestTrip] ASC

--Task 8
SELECT TOP (10) c.[Id],
c.[Name] AS [City],
c.[CountryCode] AS [Country],
COUNT(a.[CityId]) AS [Accounts]
FROM [Cities] AS c
JOIN [Accounts] AS a
ON c.[Id] = a.[CityId]
GROUP BY c.[Name],
           c.[Id],
           c.[CountryCode]
ORDER BY [Accounts] DESC

--Task 9 
SELECT a.[Id],
           a.[Email],
           c.[Name] AS [Town],
           COUNT(c.[Name]) AS [Trips]
      FROM [Accounts] a
INNER JOIN [Cities] c
        ON c.[Id] = a.[CityId]
INNER JOIN [AccountsTrips] ats
        ON ats.[AccountId] = a.[Id]
INNER JOIN [Trips] t
        ON t.[Id] = ats.[TripId]
INNER JOIN [Rooms] r
        ON r.[Id] = t.[RoomId]
INNER JOIN [Hotels] h
        ON h.[Id] = r.HotelId
     WHERE a.[CityId] = h.[CityId]
  GROUP BY a.[Id],
           a.[Email],
           c.[Name]
  ORDER BY [Trips] DESC,
           a.[Id]

--Task 10

WITH cte_AccountsToCity 
AS
(
        SELECT ht.Id AS [HotelTownId],
               c.Name AS [HotelTown]
          FROM Cities c
    INNER JOIN Hotels ht
            ON ht.CityId = c.Id
)

    SELECT T.Id,
           a.FirstName + ' ' + ISNULL(a.MiddleName + ' ', '') + a.LastName AS [FullName],
           c.Name AS [From],
           cte.HotelTown AS [To],
           CASE
               WHEN t.CancelDate IS NULL THEN CAST(DATEDIFF(DAY, T.ArrivalDate, T.ReturnDate) AS NVARCHAR) + ' days'
               ELSE 'Canceled'
           END AS [Duration]
      FROM Trips t
INNER JOIN AccountsTrips ats
        ON ats.TripId = T.Id
 LEFT JOIN Accounts a
        ON a.Id = ats.AccountId
 LEFT JOIN Cities c
        ON c.Id = a.CityId
 LEFT JOIN Rooms r
        ON r.Id = T.RoomId
 LEFT JOIN cte_AccountsToCity cte
        ON cte.HotelTownId = r.HotelId
  ORDER BY [FullName],
           ats.TripId
GO

--Task 11

CREATE FUNCTION udf_GetAvailableRoom (@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @AllRooms TABLE (Id INT)
    INSERT INTO @AllRooms 
    SELECT DISTINCT r.[Id]
               FROM [Rooms] AS r
          LEFT JOIN [Trips] AS t
                 ON t.[RoomId] = r.[Id]
              WHERE r.[HotelId] = @HotelId
                AND @Date BETWEEN t.[ArrivalDate] AND t.[ReturnDate]
                AND t.[CancelDate] IS NULL

    DECLARE @Room TABLE (Id INT, Price DECIMAL(15, 2), Type NVARCHAR(20), Beds INT, TotalPrice DECIMAL(15, 2))
    INSERT INTO @Room
    SELECT TOP 1
               r.[Id],
               r.[Price],
               r.[Type],
               r.[Beds],
               (h.[BaseRate] + r.[Price]) * @People AS [TotalPrice]
          FROM [Rooms] AS r
     LEFT JOIN [Hotels] AS h
            ON h.[Id] = r.[HotelId]
         WHERE r.[HotelId] = @HotelId
           AND r.[Beds] >= @People
           AND r.[Id] NOT IN (SELECT [Id] FROM @AllRooms)
      ORDER BY [TotalPrice] DESC

    IF ((SELECT COUNT(*) FROM @Room) < 1)
    BEGIN
        RETURN 'No rooms available'
    END

    DECLARE @Result NVARCHAR(MAX)
    SET @Result = (SELECT CONCAT('Room ', r.[Id], ': ', r.[Type], ' (', r.[Beds], ' beds) - $', r.[TotalPrice]) FROM @Room r)

    RETURN @Result
END
GO

--Task 12

CREATE PROC usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
BEGIN
    DECLARE @OldHotelId INT
    SET @OldHotelId = (    SELECT h.Id
                             FROM Hotels h
                       INNER JOIN Rooms r
                               ON r.HotelId = h.Id
                       INNER JOIN Trips t
                               ON t.RoomId = r.Id
                            WHERE t.id = @TripId)

    DECLARE @NewHotelId INT
    SET @NewHotelId = (    SELECT h.Id
                             FROM Hotels h
                       INNER JOIN Rooms r
                               ON r.HotelId = h.Id
                            WHERE r.Id = @TargetRoomId)

    IF (@OldHotelId <> @NewHotelId)
    BEGIN
        RAISERROR('Target room is in another hotel!', 16, 1)
        RETURN
    END

    DECLARE @TripAccounts INT
    SET @TripAccounts = (SELECT COUNT(ats.TripId) 
                           FROM AccountsTrips ats 
                          WHERE ats.TripId = @TripId)

    DECLARE @RoomBeds INT
    SET @RoomBeds = (SELECT r.Beds 
                       FROM Rooms r 
                      WHERE r.Id = @TargetRoomId)

    IF (@TripAccounts > @RoomBeds)
    BEGIN
        RAISERROR('Not enough beds in target room!', 16, 1)
        RETURN
    END

    BEGIN TRANSACTION
        UPDATE Trips
           SET RoomId = @TargetRoomId
         WHERE Id = @TripId
    COMMIT
END