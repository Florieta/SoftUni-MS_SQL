--Task 1
CREATE DATABASE [Minions]

USE [Minions]
--Task 2
CREATE TABLE [Minions](
[Id] INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
[Age] INT,
[TownId] INT
)

ALTER TABLE [Minions]
ADD CONSTRAINT PK_MinionsId PRIMARY Key (Id)


CREATE TABLE [Towns](
[Id] INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NUll
)
--Task 3
ALTER TABLE [Minions]
ADD [TownId] INT

ALTER TABLE [Minions]
ADD CONSTRAINT [FK_MinionsTownId] FOREIGN KEY (TownId) REFERENCES [Towns] ([Id])
--Task 4
INSERT INTO [Towns]([Id], [Name]) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO [Minions]([Id], [Name], [Age], [TownId]) VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)
--Task 5
TRUNCATE TABLE [Minions]
--Task 6
DROP TABLE [Minions]
DROP TABLE [Towns]

--Task 7 
CREATE TABLE [People](
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(200) NOT NULL,
[Picture] VARBINARY(MAX),
CHECK (DATALENGTH(Picture) <= 2000000),
[Height] DECIMAl(3,2),
[Weight] DECIMAL(5,2),
[Gender] NCHAR(1) NOT NULL,
[Birthdate] DATETIME2 NOT NULL,
[Biography] NVARCHAR(MAX)
)
INSERT INTO [People] VALUES
('Pesho', NULL, 1.80, 81, 'm', '1990-03-13', 'very good teacher'),
('Mitko', NULL, 1.90, 87, 'm', '1986-11-20', NULL),
('Vanko', NULL, 1.86, 97, 'm', '1987-03-07', 'a good friend'),
('Toshko', NULL, 1.85, 77, 'm', '1988-03-15', NULL),
('Stamo', NULL, 1.84, 101, 'm', '1989-02-14', 'something')

--Task 8 
CREATE TABLE [Users](
[Id] BIGINT PRIMARY KEY IDENTITY,
[Username] VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(26) NOT NULL,
[ProfilePicture] VARBINARY(MAX),
CHECK (DATALENGTH(ProfilePicture) <= 900000),
[LastLoginTime] DATETIME2,
[IsDeleted] BIT NOT NULL
)
INSERT INTO [Users] VALUES
('Pesho', '123456', NULL,  '2020-03-13', 'true'),
('Mitko', '1234', NULL,  '2021-11-20', 'true'),
('Vanko', '654321', NULL, '2022-03-07', 'true'),
('Toshko', '908765', NULL,  '2022-03-15', 'true'),
('Stamo', '654378', NULL,  '2022-02-14', 'true')

--Task 9 
ALTER TABLE [Users]
DROP CONSTRAINT [PK_UsersId]
ALTER TABLE [Users]
ADD CONSTRAINT [PK_Id_Username] PRIMARY KEY(Id, Username)

--Task 10 

ALTER TABLE [Users]
ADD CHECK(LEN(Password) >= 5)

--Task 11
ALTER TABLE [Users]
ADD CONSTRAINT DF_LastLoginTime 
DEFAULT CURRENT_TIMESTAMP FOR [LastLoginTime]

--Task 12
ALTER TABLE [Users]
DROP CONSTRAINT [PK_Id_Username]
ALTER TABLE [Users]
ADD CONSTRAINT [PK_Id] PRIMARY KEY([Id])
ALTER TABLE [Users]
ADD CHECK(LEN([Username]) >= 3)

--Task 13
CREATE DATABASE [Movies]

CREATE TABLE Directors
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	DirectorName NVARCHAR(MAX) NOT NULL,
	Notes NVARCHAR(MAX)
)
CREATE TABLE Genres
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	GenreName NVARCHAR(MAX) NOT NULL,
	Notes NVARCHAR(MAX)
)
CREATE TABLE Categories
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	CategoryName NVARCHAR(MAX) NOT NULL,
	Notes NVARCHAR(MAX)
)
CREATE TABLE Movies
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Title NVARCHAR(MAX) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear INT NOT NULL,
	Length TIME,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating DECIMAL(4,2),
	Notes NVARCHAR(MAX)
)
INSERT INTO [Directors] VALUES
('Krasi', NULL),
('Mitko', NULL),
('Ivan', NULL),
('Gosho', NULL),
('Stamo', NULL)
INSERT INTO [Genres] VALUES
('Comedy', NULL),
('Action', NULL),
('Fantacy', NULL),
('Sci-fi', NULL),
('Drama', NULL)
INSERT INTO [Categories] VALUES
('Series', NULL),
('Anime', NULL),
('Movies', NULL),
('Shows', NULL),
('Documentary', NULL)
INSERT INTO [Movies] VALUES
('Hary Potter', 1, 2001, NULL, 1, 3, 10.00, NULL),
('Lucifer', 2, 2019, NULL, 4, 3, 9.50, NULL),
('The Witcher', 3, 2019, NULL, 1, 1, 9.50, NULL),
('Sex and the city', 4, 2001, NULL, 2, 1, 10.00, NULL),
('Lord of the rings', 5, 2003, NULL, 3, 3, 9.00, NULL)

--Task 14

CREATE DATABASE [CarRental]

CREATE TABLE Categories
(
	[Id] INT IDENTITY(1,1) PRIMARY KEY,
	[CategoryName] NVARCHAR(25) NOT NULL,
	[DailyRate] DECIMAL(4,2),
	[WeeklyRate] DECIMAL(4,2),
	[MonthlyRate] DECIMAL(4,2),
	[WeekendRate] DECIMAL(4,2)
)
CREATE TABLE Cars
(
	[Id] INT IDENTITY(1,1) PRIMARY KEY,
	[PlateNumber] NVARCHAR(8) NOT NULL,
	[Manufacturer] NVARCHAR(20) NOT NULL,
	[Model] NVARCHAR(20) NOT NULL,
	[CarYear] INT NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES Categories(Id),
	[Doors] INT,
	[Picture] VARBINARY(MAX),
	[Condition] NVARCHAR(10),
	[Available] BIT NOT NULL
)
CREATE TABLE Employees
(
	[Id] INT IDENTITY(1,1) PRIMARY KEY,
	[FirstName] NVARCHAR(15) NOT NULL,
	[LastName] NVARCHAR(15) NOT NULL,
	[Title] NVARCHAR(20),
	[Notes] NVARCHAR(MAX)
)
CREATE TABLE Customers
(
	[Id] INT IDENTITY PRIMARY KEY,
	[DriverLicenceNumber] NVARCHAR(8) NOT NULL,
	[FullName] NVARCHAR(50) NOT NULL,
	[Address] NVARCHAR(100),
	[City] NVARCHAR(30),
	[ZIPCode] NVARCHAR(15),
	[Notes] NVARCHAR(MAX)
)
CREATE TABLE RentalOrders
(
	[Id] INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId] INT FOREIGN KEY REFERENCES Employees(Id),
	[CustomerId] INT FOREIGN KEY REFERENCES Customers(Id),
	[CarId] INT FOREIGN KEY REFERENCES Cars(Id),
	[TankLevel] INT,
	[KilometrageStart] INT,
	[KilometrageEnd] INT,
	[TotalKilometrage] INT,
	[StartDate] DATETIME2 ,
	[EndDate] DATETIME2,
	[TotalDays] INT,
	[RateApplied] DECIMAL(4,2),
	[TaxRate] DECIMAL(4,2),
	[OrderStatus] NVARCHAR(30) NOT NULL,
	[Notes] NVARCHAR(MAX)
)
INSERT INTO Categories VALUES
('Hatchback', NULL, NULL, NULL, NULL),
('Sedan', NULL, NULL, NULL, NULL),
('Cabrio', NULL, NULL, NULL, NULL)
INSERT INTO Cars VALUES
('??1136??', 'Audi', 'Q8', 2018, 3, 4, NULL, 'Perfect', 1),
('?A2427BA', 'Mitsubishi', 'Lancer', 2017, 2, 2, NULL, 'Perfect', 1),
('??1822EO', 'Honda', 'Civic', 2019, 1, 4, NULL, 'Good', 1)
INSERT INTO Employees VALUES
('Pesho', 'Peshev', NULL, NULL),
('Ivo', 'Ivanov', NULL, NULL),
('Gosho', 'Goshev', NULL, NULL)
INSERT INTO Customers VALUES
('??0062TT', 'Ivan Petrov', NULL, 'Sofia', NULL, NULL),
('CA4567CA', 'Ilian Ivanov', NULL, 'Plovdiv', NULL, NULL),
('C?0396HP', 'Krasi Radkov', NULL, 'Varna', NULL, NULL)
INSERT INTO RentalOrders VALUES
(1, 2, 3, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pending', NULL),
(3, 2, 1 , 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', NULL),
(3, 1, 2 , 110, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Stolen', NULL)

--Task 15
CREATE DATABASE [Hotel]

CREATE TABLE Employees
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(15) NOT NULL,
	LastName NVARCHAR(15) NOT NULL,
	Title NVARCHAR(20),
	Notes NVARCHAR(MAX)
)
CREATE TABLE Customers
(
	AccountNumber INT PRIMARY KEY,
	FirstName NVARCHAR(15) NOT NULL,
	LastName NVARCHAR(15) NOT NULL,
	PhoneNumber INT NOT NULL,
	EmergencyName NVARCHAR(15),
	EmergencyNumber INT,
	Notes NVARCHAR(MAX)
)
CREATE TABLE RoomStatus
(
	RoomStatus NVARCHAR(20) PRIMARY KEY,
	Notes NVARCHAR(MAX),
)
CREATE TABLE RoomTypes
(
	RoomType NVARCHAR(20) PRIMARY KEY,
	Notes NVARCHAR(MAX),
)
CREATE TABLE BedTypes
(
	BedType NVARCHAR(20) PRIMARY KEY,
	Notes NVARCHAR(MAX),
)
CREATE TABLE Rooms
(
	RoomNumber INT PRIMARY KEY,
	RoomType NVARCHAR(20) FOREIGN KEY REFERENCES RoomTypes(RoomType),
	BedType NVARCHAR(20) FOREIGN KEY REFERENCES BedTypes(BedType),
	Rate DECIMAL(4,2),
	RoomStatus NVARCHAR(20) FOREIGN KEY REFERENCES RoomStatus(RoomStatus),
	Notes NVARCHAR(MAX)
)
CREATE TABLE Payments
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	PaymentDate DATE,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	FirstDateOccupied DATE,
	LastDateOccupied DATE,
	TotalDays INT,
	AmountCharged DECIMAL(8,2),
	TaxRate DECIMAL(4,2),
	TaxAmount DECIMAL(4,2),
	PaymentTotal DECIMAL(10,2) NOT NULL,
	Notes NVARCHAR(MAX)
)
CREATE TABLE Occupancies
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	DateOccupied DATE,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber),
	RateApplied DECIMAL(4,2),
	PhoneCharge BIT,
	Notes NVARCHAR(MAX)
)

INSERT INTO [Employees] VALUES
('Pesho', 'Peshov', NULL, NULL),
('Gosho', 'Goshov', NULL, NULL),
('Tosho', 'Toshov', NULL, NULL)
INSERT INTO [Customers] VALUES
(11, 'Krasi', 'Radkov', '071598', NULL, NULL, NULL),
(12, 'Dimitar', 'Rachkov', '0887468426', NULL, NULL, NULL),
(13, 'Ulian', 'Vergov', '3332098', NULL, NULL, NULL)
INSERT INTO [RoomStatus] VALUES
('FREE', NULL),
('OCCUPIED', NULL),
('Do not disturb', NULL)
INSERT INTO [RoomTypes] VALUES
('Single', NULL),
('Double', NULL),
('King', NULL)
INSERT INTO [BedTypes] VALUES
('Kingsize', NULL),
('Queen', NULL),
('Retro', NULL)
INSERT INTO [Rooms] VALUES
(23, 'King', 'Kingsize', NULL, 'Do not disturb', NULL),
(34, 'Single', 'Retro', NULL, 'OCCUPIED', NULL),
(89, 'Double', 'Queen', NULL, 'FREE', NULL)
INSERT INTO [Payments] (EmployeeId,PaymentDate,AccountNumber,TotalDays,AmountCharged,PaymentTotal) VALUES
(2, '2021-02-05', 11, 7, 2334.82, 2784.55),
(3, '2020-11-27', 12, 8, 6754.85, 7135.56),
(1, '2019-03-08', 13, 9, 12378.67, 12982.43)
INSERT INTO [Occupancies] (EmployeeId,AccountNumber,RoomNumber) VALUES
(2, 11, 23),
(3, 12, 34),
(1, 13, 89)


--Task 16

--CREATE DATABASE SoftUni

CREATE TABLE Towns
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(30) NOT NULL
)
CREATE TABLE Addresses
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	AddressText NVARCHAR(60) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id)
)
CREATE TABLE Departments
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(30)
)
CREATE TABLE Employees
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(15) NOT NULL,
	LastName NVARCHAR(15) NOT NULL,
	JobTitle NVARCHAR(20) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
	HireDate DATE,
	Salary DECIMAL(8,2) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

--Task 17

BackUp – on the database, right button, tasks -> back up
named 'softuni-backup.bak'        database – restore database

--Task 18

INSERT INTO Towns VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')
INSERT INTO Departments VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')
INSERT INTO Employees (FirstName, LastName, JobTitle, DepartmentId, HireDate, Salary) VALUES
('Ivan', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

--Task 19

SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--Task 20
SELECT * FROM Towns
ORDER BY Name ASC
SELECT * FROM Departments
ORDER BY Name ASC
SELECT * FROM Employees
ORDER BY Salary DESC

--Task 21
SELECT Name FROM Towns
ORDER BY Name
SELECT Name FROM Departments
ORDER BY Name
SELECT FirstName, LastName, JobTitle, Salary FROM Employees
ORDER BY Salary DESC

--Task 22

UPDATE Employees
SET Salary = Salary * 1.10
SELECT Salary FROM Employees

--Task 23

UPDATE Payments
SET TaxRate = TaxRate * 0.97
SELECT Payments.TaxRate FROM Payments

--Task 24

TRUNCATE TABLE Occupancies
