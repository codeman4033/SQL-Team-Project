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
