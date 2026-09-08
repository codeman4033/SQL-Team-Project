-- WEEK 3 ITEM 1 --

USE Restaurant

-- Nathan
/* 
a. Chef – show me the salary of each chef listed in the table. Ensure this salary is displayed
correctly as the Irish pound. Do NOT hardcode the euro dollar sign.
*/

GO

CREATE OR ALTER FUNCTION fnChefSalaries()
RETURNS TABLE
AS
RETURN
(
SELECT format(Salary, 'C', 'en-IE') AS Salary
FROM Employee
WHERE JobTitle = 'Chef'
)

GO

-- test a.

SELECT *
FROM dbo.fnChefSalaries()

GO

/*
b. Show me the kitchen details by kitchen.
*/

GO

CREATE OR ALTER FUNCTION fnKitchenDetails()
RETURNS TABLE
AS
RETURN
(
SELECT *
FROM Kitchen
)

GO

-- test b.

SELECT * 
FROM fnKitchenDetails()

GO

/*
c. Menu price – show me the unique menu items along with the price of those dishes.
*/

GO

CREATE OR ALTER FUNCTION fnMenuItemPrice()
RETURNS TABLE
AS
RETURN
(
SELECT DISTINCT ItemName, Price
FROM MenuItem
)

GO

-- test c.

SELECT * 
FROM fnMenuItemPrice()

GO

/*
d. Show me the distribution of how orders are placed (in-person, online, phone). Show
this as a sum of each, with an overall sum for all options.
*/
-- Cody

-- Makes the new field required.
IF COL_LENGTH('CustomerOrder', 'OrderPlacementMethod') IS NULL
BEGIN
    ALTER TABLE CustomerOrder
    ADD OrderPlacementMethod VARCHAR(20) NULL
END
GO

-- Populates the existing orders with sample placement methods.
UPDATE CustomerOrder
SET OrderPlacementMethod =
    CASE
        WHEN CustomerOrderID % 3 = 1 THEN 'In-Person'
        WHEN CustomerOrderID % 3 = 2 THEN 'Online'
        ELSE 'Phone'
    END;
GO

-- Prevents invalid order placement methods.
IF NOT EXISTS
(
    SELECT *
    FROM sys.check_constraints
    WHERE name = 'CK_CustomerOrder_OrderPlacementMethod'
)
BEGIN
    ALTER TABLE CustomerOrder
    ADD CONSTRAINT CK_CustomerOrder_OrderPlacementMethod
    CHECK (OrderPlacementMethod IN ('In-Person', 'Online', 'Phone'));
END
GO

CREATE OR ALTER FUNCTION dbo.fn_OrderPlacementDistribution()
RETURNS TABLE
AS
RETURN
(
    SELECT
        PlacementMethod,
        COUNT(co.CustomerOrderID) AS OrderCount
    FROM
    (
        SELECT 'In-Person' AS PlacementMethod
        UNION ALL
        SELECT 'Online'
        UNION ALL
        SELECT 'Phone'
    ) AS PlacementMethods
    LEFT JOIN CustomerOrder AS co
        ON co.OrderPlacementMethod = PlacementMethods.PlacementMethod
    GROUP BY PlacementMethod

    UNION ALL

    SELECT
        'Overall Total' AS PlacementMethod,
        COUNT(*) AS OrderCount
    FROM CustomerOrder
);
GO

-- Test D
SELECT *
FROM dbo.fn_OrderPlacementDistribution();
GO

/*
e. Show me the reservations and how many patrons receive their favorite table and those
that don’t.
*/
-- Cody
CREATE OR ALTER FUNCTION dbo.fn_ReservationFavoriteTable()
RETURNS TABLE
AS
RETURN
(
    SELECT
        CASE
            WHEN r.AssignedTableID = c.PreferredTableID
                THEN 'Received Favorite Table'
            ELSE 'Did Not Receive Favorite Table'
        END AS TableResult,
        COUNT(*) AS ReservationCount
    FROM Reservation AS r
    INNER JOIN Customer AS c
        ON r.CustomerID = c.CustomerID
    GROUP BY
        CASE
            WHEN r.AssignedTableID = c.PreferredTableID
                THEN 'Received Favorite Table'
            ELSE 'Did Not Receive Favorite Table'
        END

    UNION ALL

    SELECT
        'Overall Total' AS TableResult,
        COUNT(*) AS ReservationCount
    FROM Reservation
);
GO
-- Test E
SELECT *
FROM dbo.fn_ReservationFavoriteTable();
