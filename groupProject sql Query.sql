-- Test edit by Cody 
-- SQL Programming Advanced: Final Project --
-- By: Osman Abdirahman, Landon Heezen, Nathan Aird, Cody Ferguson --

-- WEEK 2 DELIVERABLES --

-- Creates the Restaurant database

CREATE DATABASE Restaurant

-- Uses the Restaurant database for storing and modifying information

USE Restaurant

-- Populates the Restaurant database with 17 tables

CREATE TABLE RestaurantLocation
(
  RestaurantLocationID INT IDENTITY(1,1) NOT NULL
    CONSTRAINT PK_RestaurantLocation PRIMARY KEY,
    LocationName VARCHAR(50) NOT NULL,
    AddressLine VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    County VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(15) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    EmailAddress VARCHAR(80) NULL,
    OpeningDate DATE NULL,
    IsActive BIT NOT NULL
        CONSTRAINT DF_RestaurantLocation_IsActive DEFAULT 1,

    DateTime DATETIME NOT NULL
        CONSTRAINT DF_RestaurantLocation_DateTime DEFAULT GETDATE()
);
CREATE TABLE Employee
(
    EmployeeID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Employee PRIMARY KEY,
    RestaurantLocationID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    JobTitle VARCHAR(50) NOT NULL,
    CookType VARCHAR(50) NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    EmailAddress VARCHAR(100) NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    IsActive BIT NOT NULL
        CONSTRAINT DF_Employee_IsActive DEFAULT 1,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Employee_DateTime DEFAULT GETDATE(),
    CONSTRAINT FK_Employee_RestaurantLocation
        FOREIGN KEY (RestaurantLocationID)
        REFERENCES RestaurantLocation(RestaurantLocationID),
    CONSTRAINT CK_Employee_Salary
        CHECK (Salary >= 0)
);
CREATE TABLE Kitchen
(
    KitchenID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Kitchen PRIMARY KEY,
    RestaurantLocationID INT NOT NULL,
    KitchenName VARCHAR(50) NOT NULL,
    NumberOfStoves INT NOT NULL,
    NumberOfOvens INT NOT NULL,
    NumberOfRefrigerators INT NOT NULL,
    KitchenCapacity INT NOT NULL,
    LastInspectionDate DATE NULL,
    IsActive BIT NOT NULL
        CONSTRAINT DF_Kitchen_IsActive DEFAULT 1,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Kitchen_DateTime DEFAULT GETDATE(),
    CONSTRAINT FK_Kitchen_RestaurantLocation
        FOREIGN KEY (RestaurantLocationID)
        REFERENCES RestaurantLocation(RestaurantLocationID),
    CONSTRAINT CK_Kitchen_NumberOfStoves
        CHECK (NumberOfStoves >= 0),
    CONSTRAINT CK_Kitchen_NumberOfOvens
        CHECK (NumberOfOvens >= 0),
    CONSTRAINT CK_Kitchen_NumberOfRefrigerators
        CHECK (NumberOfRefrigerators >= 0),
    CONSTRAINT CK_Kitchen_Capacity
        CHECK (KitchenCapacity > 0)
);
CREATE TABLE RestaurantTable
(
    RestaurantTableID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_RestaurantTable PRIMARY KEY,
    RestaurantLocationID INT NOT NULL,
    TableNumber INT NOT NULL,
    SeatingCapacity INT NOT NULL,
    TableArea VARCHAR(50) NULL,
    IsAvailable BIT NOT NULL
        CONSTRAINT DF_RestaurantTable_IsAvailable DEFAULT 1,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_RestaurantTable_DateTime DEFAULT GETDATE(),
    CONSTRAINT FK_RestaurantTable_RestaurantLocation
        FOREIGN KEY (RestaurantLocationID)
        REFERENCES RestaurantLocation(RestaurantLocationID),
    CONSTRAINT CK_RestaurantTable_Number
        CHECK (TableNumber > 0),
    CONSTRAINT CK_RestaurantTable_SeatingCapacity
        CHECK (SeatingCapacity > 0)
);
-- This bridge table connects servers from the Employee table to their assigned tables in the RestaurantTable.
CREATE TABLE ServerTableAssignment
(
    ServerTableAssignmentID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_ServerTableAssignment PRIMARY KEY,
    EmployeeID INT NOT NULL,
    RestaurantTableID INT NOT NULL,
    AssignmentDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_ServerTableAssignment_DateTime DEFAULT GETDATE(),
    CONSTRAINT FK_ServerTableAssignment_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_ServerTableAssignment_RestaurantTable
        FOREIGN KEY (RestaurantTableID)
        REFERENCES RestaurantTable(RestaurantTableID)
);
CREATE TABLE Recipe
(
    RecipeID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Recipe PRIMARY KEY,
    RecipeName VARCHAR(50) NOT NULL,
    Instructions VARCHAR(150) NOT NULL,
    PreparationMinutes INT NOT NULL,
    CookingMinutes INT NOT NULL,
    ServingSize INT NOT NULL,
    IsActive BIT NOT NULL
        CONSTRAINT DF_Recipe_IsActive DEFAULT 1,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Recipe_DateTime DEFAULT GETDATE()
);
CREATE TABLE MenuItem
(
    MenuItemID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_MenuItem PRIMARY KEY,
    RestaurantLocationID INT NOT NULL,
    RecipeID INT NOT NULL,
    ItemName VARCHAR(50) NOT NULL,
    ItemDescription VARCHAR(150) NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    IsAvailable BIT NOT NULL
        CONSTRAINT DF_MenuItem_IsAvailable DEFAULT 1,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_MenuItem_DateTime DEFAULT GETDATE(),
    CONSTRAINT FK_MenuItem_RestaurantLocation
        FOREIGN KEY (RestaurantLocationID)
        REFERENCES RestaurantLocation(RestaurantLocationID),
    CONSTRAINT FK_MenuItem_Recipe
        FOREIGN KEY (RecipeID)
        REFERENCES Recipe(RecipeID)
);
CREATE TABLE Customer
(
    CustomerID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Customer PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    EmailAddress VARCHAR(50) NULL,
    AgeRange VARCHAR(20) NULL,
    FavoriteMenuItemID INT NULL,
    FavoriteServerID INT NULL,
    PreferredTableID INT NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Customer_DateTime DEFAULT GETDATE(),
    CONSTRAINT FK_Customer_FavoriteMenuItem
        FOREIGN KEY (FavoriteMenuItemID)
        REFERENCES MenuItem(MenuItemID),
    CONSTRAINT FK_Customer_FavoriteServer
        FOREIGN KEY (FavoriteServerID)
        REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_Customer_PreferredTable
        FOREIGN KEY (PreferredTableID)
        REFERENCES RestaurantTable(RestaurantTableID)
);
CREATE TABLE Reservation
(  ReservationID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Reservation PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantLocationID INT NOT NULL,
    PreferredTableID INT NULL,
    AssignedTableID INT NULL,
    ReservationDateTime DATETIME NOT NULL,
    PartySize INT NOT NULL,
    ReservationStatus VARCHAR(30) NOT NULL,
    IsRecurring BIT NOT NULL
        CONSTRAINT DF_Reservation_IsRecurring DEFAULT 0,
    RecurrencePattern VARCHAR(50) NULL,
    RecurrenceEndDate DATE NULL,
    CancellationDateTime DATETIME NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Reservation_DateTime DEFAULT GETDATE(),
  -- Connects each reservation to the customer who made it.
  CONSTRAINT FK_Reservation_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
  -- Connects each reservation to the restaurant location where it was made.
    CONSTRAINT FK_Reservation_RestaurantLocation
        FOREIGN KEY (RestaurantLocationID)
        REFERENCES RestaurantLocation(RestaurantLocationID),
        -- Connects the reservation to the table requested by the customer.
    CONSTRAINT FK_Reservation_PreferredTable
        FOREIGN KEY (PreferredTableID)
        REFERENCES RestaurantTable(RestaurantTableID),
        -- Connects the reservation to the table the restaurant actually assigned.
    CONSTRAINT FK_Reservation_AssignedTable
        FOREIGN KEY (AssignedTableID)
        REFERENCES RestaurantTable(RestaurantTableID),
        -- Prevents a reservation from having zero or a negative number of customers.
    CONSTRAINT CK_Reservation_PartySize
        CHECK (PartySize > 0)
);
CREATE TABLE Ingredient
(
    IngredientID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Ingredient PRIMARY KEY,
    IngredientName VARCHAR(50) NOT NULL,
    IngredientCategory VARCHAR(50) NULL,
    UnitOfMeasure VARCHAR(20) NOT NULL,
    CurrentStockQuantity DECIMAL(10,2) NOT NULL,
    ReorderLevel DECIMAL(10,2) NULL,
    AllergenInformation VARCHAR(50) NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Ingredient_DateTime DEFAULT GETDATE(),
    -- Prevents the current stock quantity from being negative.
    CONSTRAINT CK_Ingredient_CurrentStock
        CHECK (CurrentStockQuantity >= 0),
    -- Prevents the reorder level from being negative.
    CONSTRAINT CK_Ingredient_ReorderLevel
        CHECK (ReorderLevel IS NULL OR ReorderLevel >= 0)
);
-- This bridge table connects recipes to their ingredients and records the quantity required.
CREATE TABLE RecipeIngredient
(
    RecipeIngredientID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_RecipeIngredient PRIMARY KEY,
    RecipeID INT NOT NULL,
    IngredientID INT NOT NULL,
    QuantityRequired DECIMAL(10,2) NOT NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_RecipeIngredient_DateTime DEFAULT GETDATE(),
    -- Connects to the Recipe table.
    CONSTRAINT FK_RecipeIngredient_Recipe
        FOREIGN KEY (RecipeID)
        REFERENCES Recipe(RecipeID),
    -- Connects to the Ingredient table.
    CONSTRAINT FK_RecipeIngredient_Ingredient
        FOREIGN KEY (IngredientID)
        REFERENCES Ingredient(IngredientID)
);
CREATE TABLE Supplier
(
    SupplierID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Supplier PRIMARY KEY,
    SupplierName VARCHAR(50) NOT NULL,
    ContactName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    EmailAddress VARCHAR(50) NULL,
    Address VARCHAR(50) NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Supplier_DateTime DEFAULT GETDATE()
);
-- This bridge table connects chefs from employees table to their preferred suppliers.

CREATE TABLE ChefSupplier
(
    ChefSupplierID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_ChefSupplier PRIMARY KEY,
    EmployeeID INT NOT NULL,
    SupplierID INT NOT NULL,
    --this is diffrent from preferredtable 
    IsPreferred BIT NOT NULL
        CONSTRAINT DF_ChefSupplier_IsPreferred DEFAULT 1,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_ChefSupplier_DateTime DEFAULT GETDATE(),
    -- Connects the chef to the Employee table.
    CONSTRAINT FK_ChefSupplier_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),
    -- Connects to the Supplier table.
    CONSTRAINT FK_ChefSupplier_Supplier
        FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID)
);
-- This table stores customer orders, billing, payment, employee, and chef information.
CREATE TABLE CustomerOrder
(
    CustomerOrderID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_CustomerOrder PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantLocationID INT NOT NULL,
    CollectedByEmployeeID INT NOT NULL,
    ResponsibleChefID INT NOT NULL,
    BillingNumber VARCHAR(30) NOT NULL,
    OrderDateTime DATETIME NOT NULL,
    OrderType VARCHAR(20) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    OrderTotal DECIMAL(10,2) NOT NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_CustomerOrder_DateTime DEFAULT GETDATE(),
        -- Connects the order to the customer.
    CONSTRAINT FK_CustomerOrder_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
         -- Connects the order to the restaurant location.
    CONSTRAINT FK_CustomerOrder_RestaurantLocation
        FOREIGN KEY (RestaurantLocationID)
        REFERENCES RestaurantLocation(RestaurantLocationID),
        -- Connects the order to the employee who collected it.
    CONSTRAINT FK_CustomerOrder_CollectedByEmployee
        FOREIGN KEY (CollectedByEmployeeID)
        REFERENCES Employee(EmployeeID),
          -- Connects the order to the chef responsible for cooking it.
    CONSTRAINT FK_CustomerOrder_ResponsibleChef
        FOREIGN KEY (ResponsibleChefID)
        REFERENCES Employee(EmployeeID),
        -- Prevents two orders from having the same billing number.
    CONSTRAINT UQ_CustomerOrder_BillingNumber
        UNIQUE (BillingNumber)
);
-- This bridge table stores the menu items included in each customer order.
CREATE TABLE OrderItem
(
    OrderItemID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_OrderItem PRIMARY KEY,
    CustomerOrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_OrderItem_DateTime DEFAULT GETDATE(),
    -- Connects the item to a customer order.
    CONSTRAINT FK_OrderItem_CustomerOrder
        FOREIGN KEY (CustomerOrderID)
        REFERENCES CustomerOrder(CustomerOrderID),
    -- Connects the item to a menu item.
    CONSTRAINT FK_OrderItem_MenuItem
        FOREIGN KEY (MenuItemID)
        REFERENCES MenuItem(MenuItemID)
);
CREATE TABLE Charity
(
    CharityID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Charity PRIMARY KEY,
    CharityName VARCHAR(50) NOT NULL,
    ContactName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    EmailAddress VARCHAR(50) NULL,
    Address VARCHAR(50) NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Charity_DateTime DEFAULT GETDATE()
);
-- This table records food donated by a restaurant location to a charity.
CREATE TABLE Donation
(
    DonationID INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Donation PRIMARY KEY,
    CharityID INT NOT NULL,
    RestaurantLocationID INT NOT NULL,
    MenuItemID INT NOT NULL,
    DonationDate DATETIME NOT NULL,
    Quantity INT NOT NULL,
    DateTime DATETIME NOT NULL
        CONSTRAINT DF_Donation_DateTime DEFAULT GETDATE(),
        -- Connects the donation to the charity receiving the food.
    CONSTRAINT FK_Donation_Charity
        FOREIGN KEY (CharityID)
        REFERENCES Charity(CharityID),
        -- Connects the donation to the restaurant location donating the food.
    CONSTRAINT FK_Donation_RestaurantLocation
        FOREIGN KEY (RestaurantLocationID)
        REFERENCES RestaurantLocation(RestaurantLocationID),
        -- Connects the donation to the menu item being donated.
    CONSTRAINT FK_Donation_MenuItem
        FOREIGN KEY (MenuItemID)
        REFERENCES MenuItem(MenuItemID)
);

-- Inserts records into the Restaurant database's 17 tables

-- 1. RestaurantLocation

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO RestaurantLocation
        (LocationName, AddressLine, City, County, Country, PostalCode, PhoneNumber, EmailAddress, OpeningDate, IsActive)
    VALUES
        (CONCAT('Restaurant Location ', @i),
         CONCAT(@i, ' Main Street'), 'Green Bay', 'Brown', 'USA',
         CONCAT('5432', RIGHT('000' + CAST(@i AS VARCHAR(3)), 3)),
         CONCAT('920-555-', RIGHT('0000' + CAST(@i AS VARCHAR(4)), 4)),
         CONCAT('location', @i, '@restaurant.com'),
         DATEADD(DAY, @i - 1, CAST('2020-01-01' AS DATE)), 1);
    SET @i += 1;
END;
GO

-- 2. Employee

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Employee
        (RestaurantLocationID, FirstName, LastName, JobTitle, CookType, PhoneNumber, EmailAddress, HireDate, Salary, IsActive)
    VALUES
        (((@i - 1) % 100) + 1,
         CONCAT('First', @i), CONCAT('Last', @i),
         CASE WHEN @i <= 20 THEN 'Server'
              WHEN @i <= 40 THEN 'Chef'
              WHEN @i <= 60 THEN 'Cook'
              WHEN @i <= 80 THEN 'Manager'
              ELSE 'Host' END,
         CASE WHEN @i BETWEEN 21 AND 40 THEN 'Executive Chef'
              WHEN @i BETWEEN 41 AND 60 THEN 'Line Cook'
              ELSE NULL END,
         CONCAT('920-555-', RIGHT('0000' + CAST(@i AS VARCHAR(4)), 4)),
         CONCAT('employee', @i, '@restaurant.com'),
         DATEADD(DAY, @i - 1, CAST('2021-01-01' AS DATE)),
         CAST(30000 + (@i * 500) AS DECIMAL(10,2)), 1);
    SET @i += 1;
END;
GO

-- 3. Kitchen

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Kitchen
        (RestaurantLocationID, KitchenName, NumberOfStoves, NumberOfOvens, NumberOfRefrigerators, KitchenCapacity, LastInspectionDate, IsActive)
    VALUES
        (@i, CONCAT('Kitchen ', @i), 4 + (@i % 5), 2 + (@i % 4), 2 + (@i % 3),
         20 + (@i % 31), DATEADD(DAY, @i - 1, CAST('2025-01-01' AS DATE)), 1);
    SET @i += 1;
END;
GO

-- 4. RestaurantTable

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO RestaurantTable
        (RestaurantLocationID, TableNumber, SeatingCapacity, TableArea, IsAvailable)
    VALUES
        (((@i - 1) % 100) + 1, @i, 2 + (@i % 7),
         CASE WHEN @i % 4 = 0 THEN 'Patio'
              WHEN @i % 4 = 1 THEN 'Main Dining'
              WHEN @i % 4 = 2 THEN 'Bar'
              ELSE 'Private Dining' END, 1);
    SET @i += 1;
END;
GO

-- 5. Recipe

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Recipe
        (RecipeName, Instructions, PreparationMinutes, CookingMinutes, ServingSize, IsActive)
    VALUES
        (CONCAT('Recipe ', @i), CONCAT('Prepare and cook recipe ', @i, ' according to kitchen standards.'),
         5 + (@i % 20), 10 + (@i % 30), 1 + (@i % 6), 1);
    SET @i += 1;
END;
GO

-- 6. MenuItem

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO MenuItem
        (RestaurantLocationID, RecipeID, ItemName, ItemDescription, Category, Price, IsAvailable)
    VALUES
        (((@i - 1) % 100) + 1, @i, CONCAT('Menu Item ', @i),
         CONCAT('Description for menu item ', @i),
         CASE WHEN @i % 4 = 0 THEN 'Dessert'
              WHEN @i % 4 = 1 THEN 'Entree'
              WHEN @i % 4 = 2 THEN 'Appetizer'
              ELSE 'Beverage' END,
         CAST(5.00 + ((@i % 30) * 1.25) AS DECIMAL(10,2)), 1);
    SET @i += 1;
END;
GO

-- 7. Customer
-- Customers 1-5 intentionally have preferred table IDs that do not match their
-- customer-number/table-number counterparts.

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Customer
        (FirstName, LastName, PhoneNumber, EmailAddress, AgeRange, FavoriteMenuItemID, FavoriteServerID, PreferredTableID)
    VALUES
        (CONCAT('CustomerFirst', @i), CONCAT('CustomerLast', @i),
         CONCAT('920-555-', RIGHT('0000' + CAST(1000 + @i AS VARCHAR(4)), 4)),
         CONCAT('customer', @i, '@example.com'),
         CASE WHEN @i % 4 = 0 THEN '18-25'
              WHEN @i % 4 = 1 THEN '26-35'
              WHEN @i % 4 = 2 THEN '36-50'
              ELSE '51+' END,
         ((@i - 1) % 100) + 1,
         ((@i - 1) % 20) + 1,
         CASE @i
             WHEN 1 THEN 2
             WHEN 2 THEN 4
             WHEN 3 THEN 6
             WHEN 4 THEN 8
             WHEN 5 THEN 10
             ELSE ((@i - 1) % 100) + 1
         END);
    SET @i += 1;
END;
GO

-- 8. Reservation

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Reservation
        (CustomerID, RestaurantLocationID, PreferredTableID, AssignedTableID, ReservationDateTime,
         PartySize, ReservationStatus, IsRecurring, RecurrencePattern, RecurrenceEndDate, CancellationDateTime)
    VALUES
        (@i, @i, CASE WHEN @i <= 5 THEN @i + 1 ELSE @i END,
         @i, DATEADD(DAY, @i - 1, CAST('2026-09-01T18:00:00' AS DATETIME)),
         1 + (@i % 8),
         CASE WHEN @i % 5 = 0 THEN 'Cancelled'
              WHEN @i % 3 = 0 THEN 'Completed'
              ELSE 'Confirmed' END,
         CASE WHEN @i % 10 = 0 THEN 1 ELSE 0 END,
         CASE WHEN @i % 10 = 0 THEN 'Weekly' ELSE NULL END,
         CASE WHEN @i % 10 = 0 THEN DATEADD(DAY, 70 + @i, CAST('2026-09-01' AS DATE)) ELSE NULL END,
         CASE WHEN @i % 5 = 0 THEN DATEADD(DAY, @i - 1, CAST('2026-08-20T12:00:00' AS DATETIME)) ELSE NULL END);
    SET @i += 1;
END;
GO

-- 9. Ingredient

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Ingredient
        (IngredientName, IngredientCategory, UnitOfMeasure, CurrentStockQuantity, ReorderLevel, AllergenInformation)
    VALUES
        (CONCAT('Ingredient ', @i),
         CASE WHEN @i % 4 = 0 THEN 'Produce'
              WHEN @i % 4 = 1 THEN 'Meat'
              WHEN @i % 4 = 2 THEN 'Dairy'
              ELSE 'Dry Goods' END,
         CASE WHEN @i % 3 = 0 THEN 'lb'
              WHEN @i % 3 = 1 THEN 'oz'
              ELSE 'each' END,
         CAST(10 + (@i % 90) AS DECIMAL(10,2)),
         CAST(5 + (@i % 20) AS DECIMAL(10,2)),
         CASE WHEN @i % 5 = 0 THEN 'Contains dairy' ELSE NULL END);
    SET @i += 1;
END;
GO

-- 10. RecipeIngredient

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO RecipeIngredient (RecipeID, IngredientID, QuantityRequired)
    VALUES (@i, @i, CAST(0.50 + ((@i % 10) * 0.25) AS DECIMAL(10,2)));
    SET @i += 1;
END;
GO

-- 11. Supplier

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Supplier
        (SupplierName, ContactName, PhoneNumber, EmailAddress, Address)
    VALUES
        (CONCAT('Supplier ', @i), CONCAT('Contact ', @i),
         CONCAT('920-555-', RIGHT('0000' + CAST(2000 + @i AS VARCHAR(4)), 4)),
         CONCAT('supplier', @i, '@example.com'),
         CONCAT(@i, ' Supplier Road'));
    SET @i += 1;
END;
GO

-- 12. ChefSupplier

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO ChefSupplier (EmployeeID, SupplierID, IsPreferred)
    VALUES (((@i - 1) % 40) + 21, @i, CASE WHEN @i % 2 = 0 THEN 1 ELSE 0 END);
    SET @i += 1;
END;
GO

-- 13. CustomerOrder

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO CustomerOrder
        (CustomerID, RestaurantLocationID, CollectedByEmployeeID, ResponsibleChefID,
         BillingNumber, OrderDateTime, OrderType, PaymentMethod, OrderTotal)
    VALUES
        (@i, @i, ((@i - 1) % 20) + 1, ((@i - 1) % 20) + 21,
         CONCAT('BILL-', RIGHT('0000' + CAST(@i AS VARCHAR(4)), 4)),
         DATEADD(DAY, @i - 1, CAST('2026-01-01T12:00:00' AS DATETIME)),
         CASE WHEN @i % 3 = 0 THEN 'Takeout'
              WHEN @i % 3 = 1 THEN 'Dine-In'
              ELSE 'Delivery' END,
         CASE WHEN @i % 3 = 0 THEN 'Cash'
              WHEN @i % 3 = 1 THEN 'Credit Card'
              ELSE 'Debit Card' END,
         CAST(10.00 + ((@i % 40) * 2.50) AS DECIMAL(10,2)));
    SET @i += 1;
END;
GO

-- 14. OrderItem

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO OrderItem (CustomerOrderID, MenuItemID, Quantity, UnitPrice)
    VALUES (@i, ((@i - 1) % 100) + 1, 1 + (@i % 4),
            CAST(5.00 + (((@i - 1) % 30) * 1.25) AS DECIMAL(10,2)));
    SET @i += 1;
END;
GO

-- 15. Charity

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Charity
        (CharityName, ContactName, PhoneNumber, EmailAddress, Address)
    VALUES
        (CONCAT('Charity ', @i), CONCAT('Charity Contact ', @i),
         CONCAT('920-555-', RIGHT('0000' + CAST(3000 + @i AS VARCHAR(4)), 4)),
         CONCAT('charity', @i, '@example.org'),
         CONCAT(@i, ' Charity Avenue'));
    SET @i += 1;
END;
GO

-- 16. Donation

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Donation
        (CharityID, RestaurantLocationID, MenuItemID, DonationDate, Quantity)
    VALUES
        (@i, @i, ((@i - 1) % 100) + 1,
         DATEADD(DAY, @i - 1, CAST('2026-03-01T10:00:00' AS DATETIME)),
         1 + (@i % 20));
    SET @i += 1;
END;
GO

-- 17. ServerTableAssignment
-- Employees 1-5 each receive more than one table assignment.

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO ServerTableAssignment
        (EmployeeID, RestaurantTableID, AssignmentDate, StartTime, EndTime)
    VALUES
        (CASE
            WHEN @i <= 10 THEN ((@i - 1) % 5) + 1
            ELSE ((@i - 11) % 15) + 6
         END,
         @i,
         DATEADD(DAY, @i - 1, CAST('2026-04-01' AS DATE)),
         CAST('11:00:00' AS TIME),
         CAST('19:00:00' AS TIME));
    SET @i += 1;
END;
GO

