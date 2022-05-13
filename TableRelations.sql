CREATE DATABASE [EntityRelationsDemo2021]

USE [EntityRelationsDemo2021]
--Task 1
CREATE TABLE [Passports](
[PassportID] INT PRIMARY KEY NOT NULL,
[PassportNumber] CHAR(8) NOT NULL
)

CREATE TABLE [Persons](
[PersonID] INT PRIMARY KEY IDENTITY NOT NULL,
[FirstName] VARCHAR(50) NOT NULL,
[Salary] DECIMAL(9, 2) NOT NULL,
[PassportID] INT FOREIGN KEY REFERENCES [Passports]([PassportID]) UNIQUE NOT NULL
)

INSERT INTO [Passports] ([PassportID], [PassportNumber])
 VALUES
 (101, 'N34FG21B'),
 (102, 'K65LO4R7'),
 (103, 'ZE657QP2')


 INSERT INTO [Persons] ([FirstName], [Salary], [PassportID])
 VALUES
 ('Roberto', 43300.00, 102),
 ('Tom', 56100.00, 103),
 ('Yana', 60200.00, 101)

 --Task 2
 CREATE TABLE [Manufactures](
[ManufacturerID] INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
[EstablishedOn] DATE NOT NULL
)

CREATE TABLE [Models](
[ModelID] INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
[Name] VARCHAR(50) NOT NULL,
[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufactures] ([ManufacturerID]) NOT NULL
)

INSERT INTO [Manufactures] ([Name], [EstablishedOn])
 VALUES
 ('BMW', '07/03/1916'),
 ('TESLA', '01/01/2003'),
 ('LADA', '01/05/1966')


 INSERT INTO [Models] ([Name], [ManufacturerID])
 VALUES
 ('X1', 1),
 ('i6', 1),
 ('Model S', 2),
 ('Model X', 2),
 ('Model 3', 2),
 ('Nova', 3)


 --TASK 3
CREATE TABLE [Students](
[StudentID] INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE [Exams](
[ExamID] INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
[Name] NVARCHAR(75) NOT NULL,
)

CREATE TABLE [StudentsExams](
[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL,
[ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID]) NOT NULL,
PRIMARY KEY([StudentID], [ExamID])
)

INSERT INTO [Students] ([Name])
 VALUES
 ('Mila'),
 ('Toni'),
 ('Ron')

 INSERT INTO [Exams] ([Name])
 VALUES
 ('SpringMVC'),
 ('Neo4'),
 ('Oracle 11g')

 INSERT INTO [StudentsExams] ([StudentID], [ExamID])
 VALUES
 (1, 101),
 (1, 102),
 (2, 101),
 (3, 103),
 (2, 102),
 (2, 103)

 --TASK 4
 CREATE TABLE [Teachers](
[TeacherID] INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
[Name] VARCHAR(50) NOT NULL,
[ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID])
)

 INSERT INTO [Teachers] ([Name], [ManagerID])
 VALUES
 ('John', NULL),
 ('Maya', 106),
 ('Silvia', 106),
 ('Ted', 105),
 ('Mark', 101),
 ('Greta', 101)

 --Task 5

CREATE DATABASE [OnlineStore]

CREATE TABLE [Cities]
(
	[CityID] INT IDENTITY(1,1) PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Customers]
(
	[CustomerID] INT IDENTITY(1,1) PRIMARY KEY,
	[Name] NVARCHAR(30) NOT NULL,
	[Birthday] DATE,
	[CityID] INT FOREIGN KEY REFERENCES [Cities]([CityID])
)

CREATE TABLE [ItemTypes]
(
	[ItemTypeID] INT IDENTITY(1,1) PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Items]
(
	[ItemID] INT IDENTITY(1,1) PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes]([ItemTypeID])
)

CREATE TABLE [Orders]
(
	[OrderID] INT IDENTITY(1,1) PRIMARY KEY,
	[CustomerID] INT FOREIGN KEY REFERENCES [Customers]([CustomerID])
)

CREATE TABLE [OrderItems]
(
	[OrderID] INT FOREIGN KEY REFERENCES [Orders]([OrderID]),
	[ItemID] INT FOREIGN KEY REFERENCES [Items]([ItemID]),
	PRIMARY KEY([OrderID], [ItemID])
)

--Task 6

CREATE DATABASE [University]

CREATE TABLE [Majors]
(
	[MajorID] INT IDENTITY(1,1) PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Students]
(
	[StudentID] INT IDENTITY(1,1) PRIMARY KEY,
	[StudentNumber] INT NOT NULL,
	[StudentName] NVARCHAR(50) NOT NULL,
	[MajorID] INT FOREIGN KEY REFERENCES [Majors]([MajorID])
)

CREATE TABLE [Payments]
(
	[PaymentID] INT IDENTITY(1,1) PRIMARY KEY,
	[PaymentDate] DATE,
	[PaymentAmmount] DECIMAL(6,2),
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID])
)

CREATE TABLE [Subjects]
(
	[SubjectID] INT IDENTITY(1,1) PRIMARY KEY,
	[SubjectName] NVARCHAR(50) NOT NULL,
)

CREATE TABLE [Agenda]
(
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
	[SubjectID] INT FOREIGN KEY REFERENCES [Subjects]([SubjectID])
	PRIMARY KEY([StudentID], [SubjectID])
)

--Task 9
SELECT [Mountains].[MountainRange], [Peaks].[PeakName], [Peaks].[Elevation] FROM [Mountains]
JOIN [Peaks] ON [Peaks].[MountainId] = [Mountains].[Id]
WHERE [MountainRange] = 'Rila'
ORDER BY [Elevation] DESC
