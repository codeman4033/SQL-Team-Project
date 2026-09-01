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
