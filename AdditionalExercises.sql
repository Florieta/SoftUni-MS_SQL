USE [Diablo]
--Task 1
SELECT r.[Email Provider],COUNT(*)
 FROM (SELECT SUBSTRING(Email,CHARINDEX('@',Email) + 1, LEN(Email) - (CHARINDEX('@',Email) - 1 )) AS [Email Provider]
	FROM Users) AS r
GROUP BY r.[Email Provider]
ORDER BY COUNT(r.[Email Provider]) DESC,r.[Email Provider]

--Task 2

SELECT g.[Name] AS Game,gp.[Name] AS [Game Type],u.Username,ug.[Level],ug.Cash,cr.[Name] AS [Character]
	FROM UsersGames AS ug
	JOIN Games AS g ON g.Id = ug.GameId
	JOIN GameTypes AS gp ON gp.Id = g.GameTypeId
	JOIN Users AS u ON u.Id = ug.UserId
	JOIN Characters AS cr ON cr.Id = ug.CharacterId
ORDER BY ug.[Level] DESC,u.Username,g.[Name]

--Task 3

SELECT u.Username,g.[Name] AS Game,COUNT(it.Name) AS [Item Count],SUM(it.Price) AS [Items Price]
	FROM Users AS u
	JOIN UsersGames AS ug ON ug.UserId = u.Id
	JOIN Games AS g ON g.Id = ug.GameId
	JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
	JOIN Items AS it ON it.Id = ugi.ItemId
GROUP BY u.Username,g.[Name]
HAVING COUNT(it.Name) >= 10
ORDER BY [Item Count] DESC, [Items Price] DESC

--Task 4
SELECT U.Username,g.[Name] AS Game,MAX(chr.Name) AS [Character],
	   (SUM(itemStats.Strength) + MAX(gameStats.Strength) + MAX(charStats.Strength)) AS Strength,
	   (SUM(itemStats.Defence) + MAX(gameStats.Defence) + MAX(charStats.Defence)) AS Defence,
	   (SUM(itemStats.Speed) + MAX(gameStats.Speed) + MAX(charStats.Speed)) AS Speed,
	   (SUM(itemStats.Mind) + MAX(gameStats.Mind) + MAX(charStats.Mind)) AS Mind,
	   (SUM(itemStats.Luck) + MAX(gameStats.Luck) + MAX(charStats.Luck)) AS Luck
	FROM Users AS u
	JOIN UsersGames AS ug ON ug.UserId = u.Id
	JOIN Characters AS chr ON chr.Id = ug.CharacterId
	JOIN [Statistics] AS charStats ON charStats.Id = chr.StatisticId
	JOIN Games AS g ON g.Id = ug.GameId
	JOIN GameTypes AS gt ON gt.Id = g.GameTypeId
	JOIN [Statistics] AS gameStats ON gameStats.Id = gt.BonusStatsId
	JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
	JOIN Items AS it ON it.Id = ugi.ItemId
	JOIN [Statistics] AS itemStats ON itemStats.Id = it.StatisticId
GROUP BY u.Username,g.[Name]
ORDER BY Strength DESC,Defence DESC, Speed DESC, Mind DESC, Luck DESC

--Task 5

DECLARE @AvgLuck FLOAT = (SELECT AVG(Luck) FROM [Statistics])
DECLARE @AvgSpeed FLOAT = (SELECT AVG(Speed) FROM [Statistics])
DECLARE @AvgMind FLOAT = (SELECT AVG(Mind) FROM [Statistics])

SELECT i.[Name],i.Price,i.MinLevel,s.Strength,s.Defence,s.Speed,s.Luck,s.Mind
	FROM Items AS i
	JOIN [Statistics] AS s ON s.Id = i.StatisticId
	WHERE  s.Luck > @AvgLuck
		  AND s.Speed > @AvgSpeed
		  AND s.Mind > @AvgMind
ORDER BY i.Name

--Task 6

SELECT i.[Name] AS Item,i.Price,i.MinLevel,gt.[Name] AS [Forbidden Game Type]
	FROM Items AS i
	LEFT JOIN GameTypeForbiddenItems AS gtf ON gtf.ItemId = i.Id
	LEFT JOIN GameTypes AS gt ON gt.Id = gtf.GameTypeId
ORDER BY gt.[Name] DESC,i.[Name]

--Task 7

DECLARE @AlexId INT = (SELECT Id FROM Users WHERE Username = 'Alex')
DECLARE @GameId INT = (SELECT Id FROM Games WHERE Name = 'Edinburgh')

DECLARE @AlexGameId INT  = 
(
	SELECT Id
		FROM UsersGames
		WHERE UserId = @AlexId AND 
			  GameId = @GameId
)

DECLARE @TotalPriceOfItems DECIMAL(15,2) =
(
	SELECT SUM(It.Price) AS [Total Price]
		FROM Items AS it
		WHERE it.[Name] IN ('Blackguard','Bottomless Potion of Amplification','Eye of Etlich (Diablo III)','Gem of Efficacious Toxin','Golden Gorget of Leoric','Hellfire Amulet')
)

INSERT INTO UserGameItems(ItemId,UserGameId)
SELECT it.Id,@AlexGameId FROM Items AS it
		WHERE it.[Name] IN ('Blackguard','Bottomless Potion of Amplification','Eye of Etlich (Diablo III)','Gem of Efficacious Toxin','Golden Gorget of Leoric','Hellfire Amulet')

UPDATE UsersGames
	SET CAsh -= @TotalPriceOfItems
	WHERE id = @AlexGameId

SELECT us.Username,g.[Name],ug.Cash,it.[Name] AS [Item Name]	
	FROM UsersGames AS ug
	JOIN Games AS g ON g.Id = ug.GameId
	JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
	JOIN Items AS it ON it.Id = ugi.ItemId
	JOIN Users AS us ON us.Id = ug.UserId
WHERE ug.GameId = @GameId
ORDER BY it.[Name]

USE [Geography]
--Task 8

SELECT p.PeakName,m.MountainRange,p.Elevation
	FROM Mountains AS m
	JOIN Peaks AS p ON p.MountainId = m.Id
ORDER BY p.Elevation DESC,p.[PeakName]

--Task 9 
SELECT p.PeakName,m.MountainRange,cr.CountryName,cn.ContinentName
	FROM Peaks AS p
	JOIN Mountains AS m ON m.Id = p.MountainId
	JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
	JOIN Countries AS cr ON cr.CountryCode = mc.CountryCode
	JOIN Continents AS cn ON cn.ContinentCode = cr.ContinentCode
ORDER BY p.PeakName,cr.CountryName

--Task 10

SELECT c.CountryName,ct.ContinentName,ISNULL(COUNT(r.RiverName),0) AS [RiversCount],ISNULL(SUM(r.Length),0) AS [TotalLength]
	FROM Countries AS c
	JOIN Continents AS ct ON ct.ContinentCode = c.ContinentCode
	LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
	LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName,ct.ContinentName
ORDER BY RiversCount DESC,TotalLength DESC,c.CountryName

--Task 11

SELECT cr.CurrencyCode,cr.[Description] AS [Currency],COUNT(ct.CountryName) AS NumberOfCountries
	FROM Currencies AS cr
	LEFT JOIN Countries AS ct ON ct.CurrencyCode = cr.CurrencyCode
GROUP BY cr.CurrencyCode,cr.[Description]
ORDER BY NumberOfCountries DESC, [Currency]

--Task 12

SELECT c.ContinentName,
	   SUM(cr.AreaInSqKm) AS CountriesArea, 
	   SUM(CAST(cr.[Population] AS BIGINT)) AS CountriesPopulation
	FROM Continents AS c
	JOIN Countries AS cr ON cr.ContinentCode = c.ContinentCode
GROUP BY c.ContinentName
ORDER BY CountriesPopulation DESC

--Task 13

CREATE TABLE Monasteries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	CountryCode CHAR(2) FOREIGN KEY REFERENCES Countries(CountryCode)
)

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('S?mela Monastery', 'TR')


UPDATE Countries
	SET IsDeleted = 1
	WHERE CountryCode IN 
	(
		SELECT cr.CountryCode FROM CountriesRivers AS cr
			GROUP BY cr.CountryCode
			HAVING COUNT(cr.RiverId) > 3
	)

SELECT m.[Name] AS Monastery,cr.CountryName AS Country
	FROM Monasteries AS m
	JOIN Countries AS cr ON cr.CountryCode = m.CountryCode
	WHERE cr.IsDeleted = 0
 ORDER BY m.[Name]


 --Task 14
 UPDATE Countries
	SET CountryName = 'Burma'
	WHERE CountryName = 'Myanmar'

INSERT INTO Monasteries VALUES
('Hanga Abbey',(SELECT CountryCode FROM Countries WHERE CountryName = 'Tanzania')),
('Myin-Tin-Daik',(SELECT CountryCode FROM Countries WHERE CountryName = 'Myanmar'))

SELECT cn.ContinentName,cr.CountryName,COUNT(m.Id) AS MonasteriesCount
	FROM Continents AS cn
	JOIN Countries AS cr ON cr.ContinentCode = cn.ContinentCode
	LEFT JOIN Monasteries AS m ON m.CountryCode = cr.CountryCode
	WHERE cr.IsDeleted = 0
 GROUP BY cn.ContinentName,cr.CountryName
 ORDER BY MonasteriesCount DESC,cr.CountryName