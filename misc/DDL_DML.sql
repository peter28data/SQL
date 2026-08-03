--Data Definition Language (DDL)

CREATE TABLE Customers --Data Architecture
(
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

ALTER TABLE Customers --Adding a Column
ADD PhoneNumber VARCHAR(20);

DROP TABLE Customers; --Removing a Table

TRUNCATE TABLE Customers; --Emptying a Table while Keeping its Structure

-------------------------------------

--Data Manipulation Language (DML)

INSERT INTO Customers --Data Engineering Loading Data into Column
VALUES
(
1,
'Peter',
'Garay',
'peter@email.com'
);

UPDATE Customers -- Updating Data
SET Email='new@email.com'
WHERE CustomerID=1;

DELETE FROM Customers --Delete Data, not Structure
WHERE CustomerID=1;

----------------------------------
