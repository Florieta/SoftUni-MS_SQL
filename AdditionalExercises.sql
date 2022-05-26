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
