-- SQL Programming Advanced: Final Project --
-- By: Osman Abdirahman, Landon Heezen, Nathan Aird, Cody Ferguson --

-- WEEK 4 DELIVERABLES --

USE Restaurant

-- ITEM 1 --

-- Nathan Aird

-- Develop five (5) stored procedures that will do the following:

/* 
a. Return the chef(s) that have a preferred vendor and what item(s) these chefs prefer
from these vendors. Also include the price for these items.
*/

/*
b. Return the sum of the ingredients by recipe. Also included with this will be the recipe
items.
*/

/*
c. Show me the ingredients used in each recipe and the prices listed for those dishes that
use the ingredients.
*/

/*
d. Show me the kitchen details. These details can either be all records or by individual
chef.
*/

create or alter procedure spN_KitchenDetails
as
	select *
	from Kitchen
go

exec spN_KitchenDetails

go

/*
e. Return information on the customers that dine at the restaurant. This stored procedure
should be able to run and return individual customer information
*/

create or alter procedure spN_CustomerDetails
as
	select *
	from Customer
go

-- ITEM 2 --

-- Landon Heezen

/* Develop the following indexes for the tables listed below. Foe each table, select what you
think is the appropriate field. Document why you made this selection. */

-- a.

-- Creates a non-clustered composite index on the Charity table to make finding the charities contact information much easier without the additional columns

DROP INDEX IF EXISTS IX_Charity_ContactInformation
ON dbo.Charity

CREATE NONCLUSTERED INDEX IX_Charity_ContactInformation
ON dbo.Charity (CharityName, ContactName, PhoneNumber, EmailAddress)

-- b.

/* Creates a simple non-clustered index on one of the table's foreign keys for finding the location of specific food items on the menu
or to search for other necessary information on the RestaurantLocation table in queries */

DROP INDEX IF EXISTS IX_MenuItem_RestaurantLocationID
ON dbo.MenuItem

CREATE NONCLUSTERED INDEX IX_MenuItem_RestaurantLocationID
ON dbo.MenuItem (RestaurantLocationID)

-- c.

-- Creates a non-clustered composite index that can be used to quickly find which recipes are currently active and being used

DROP INDEX IF EXISTS IX_Recipe_Status
ON dbo.Recipe

CREATE NONCLUSTERED INDEX IX_Recipe_Status
ON dbo.Recipe (RecipeName, IsActive)

-- d. 

-- Creates a non-clustered composite filtered index to find all dine-in customers and when they dine in so they could possibly receive loyalty deals

DROP INDEX IF EXISTS IX_CustomerOrder_DineInCustomers
ON dbo.CustomerOrder

CREATE NONCLUSTERED INDEX IX_CustomerOrder_DineInCustomers
ON dbo.CustomerOrder (CustomerID, OrderDateTime)
WHERE OrderType = 'Dine-In'

-- e.

/* Creates a unique non-clustered composite index to locate what customers will be showing up at what restaurant locations and when
while ensuring that the same customer can't have more than one reservation at the same location */

DROP INDEX IF EXISTS IX_Reservation_CustomerLocationDate
ON dbo.Reservation

CREATE UNIQUE NONCLUSTERED INDEX IX_Reservation_CustomerLocationDate
ON dbo.Reservation (CustomerID, RestaurantLocationID, ReservationDateTime)

-- ITEM 3 --

-- Cody Ferguson + Osman Abdirahman

/* For two (2) tables above (your choice), develop stored procedures that will allow you to
perform CRUD (create/insert/update/delete) operations against those tables. This means that
each table will have one stored procedure for each of the following tasks: */

/*
a. SELECT from
*/
--1. Create procedure
--returns one charity by it is charity_ID
CREATE PROCEDURE dbo.spN_GetCharity
@CharityID INT
--the start of the procedure’s instructions
AS 
BEGIN 
SET NOCOUNT on;

--Chooses which columns to return.
SELECT 
CharityID, 
CharityName,
ContactName,
PhoneNumber,
EmailAddress,
Address,
DateTime

FROM Charity
--Returns only the charity whose ID matches the value supplied to the procedure.
WHERE CharityID =@CharityID 
if @@ROWCOUNT = 0
SELECT 'No charity found with that ID.' AS resultmessage;
END
GO
--TEST
EXEC dbo.spN_GetCharity @CharityID = 1;
GO

/*
b. INSERT into. It is up to you to decide what field(s) to include in the insert based on the
requirements above.
*/
--2 insert: Add a charity and return the new record
CREATE PROCEDURE dbo.spN_INSERTCharity
@CharityName varchar(50),
@ContactName varchar(50),
@PhoneNumber varchar(50),
@EmailAddress varchar(50),
@Address varchar(50)
--The procedure’s instructions start.
AS
--Starting the body of the procedure.
BEGIN
--Hides “1 row affected” messages. Your SELECT result still appears
SET NOCOUNT ON;
BEGIN TRY
INSERT INTO Charity (
CharityName, 
ContactName, 
PhoneNumber,
EmailAddress, 
Address, 
DateTime)
--Provides one value for each column, in the same order
VALUES
(@CharityName, 
@ContactName, 
@PhoneNumber,
@EmailAddress,@Address,
GETDATE());
--Returns the charity record after inserting it
SELECT
CharityID,
CharityName,
ContactName,
PhoneNumber,
EmailAddress,
DateTime
FROM Charity
WHERE CharityID = SCOPE_IDENTITY();
END TRY
BEGIN CATCH
--Displays the error as a result, so you can see what went wrong.
SELECT ERROR_MESSAGE() AS resultmessage;
END CATCH
END
--TEST
EXEC dbo.spN_InsertCharity
    @CharityName = 'Week 4 Test Charity',
    @ContactName = 'Test Contact',
    @PhoneNumber = '01-555-0101',
    @EmailAddress = 'test@example.ie',
    @Address = '10 Main Street, Dublin';
GO

/*
c. UPDATE – this will mean updating most fields on each table. It is up to you to decide
what field(s) to include when updating each table. For each update, you will need to
update at least three (3) fields.
*/
--3.UPDATE: Change five fields and return the updated record.
CREATE PROCEDURE dbo.spN_updateCharity
@CharityID int,
@CharityName varchar(50),
@ContactName varchar(50),
@PhoneNumber varchar(50),
@EmailAddress varchar(50),
@Address varchar(50)
--The procedure’s instructions start.
AS
--Starting the body of the procedure.
BEGIN
--Hides “1 row affected” messages. Your SELECT result still appears
SET NOCOUNT ON;
BEGIN TRY
UPDATE Charity
SET 
CharityName = @CharityName,
ContactName = @ContactName,
PhoneNumber = @PhoneNumber,
EmailAddress = @EmailAddress,
 Address = @Address
--Returns all columns from the new version of the updated row.
  OUTPUT INSERTED.*
 WHERE CharityID = @CharityID
 --Checks whether the UPDATE changed zero rows
 IF @@ROWCOUNT = 0
 --Returns a message when there was no matching charity.
 SELECT 'No charity found with that ID.' AS ResultMessage;
 END TRY
 --Runs if an error occurs in the TRY section.
 BEGIN CATCH
 SELECT ERROR_MESSAGE() AS ResultMessage;
 END CATCH
 END;
 GO
 -- Test
 EXEC dbo.spN_UpdateCharity
    @CharityID = 17,
    @CharityName = 'catholic charity',
    @ContactName = 'head of catholic',
    @PhoneNumber = '01-555-0202',
    @EmailAddress = 'catholic@example.ie',
    @Address = '20 Main Street, Dublin';
    GO

/*
d. DELETE – this will mean deleting a record from the table. When completing this step,
keep in mind the relationships you established in the previous step.
*/
 -- 4. DELETE: Protect charities referenced by Donation.
 CREATE PROCEDURE dbo.spN_DeleteCharity
 @CharityID  INT
 AS 
 BEGIN
 SET NOCOUNT ON;
 IF EXISTS
( SELECT 1
FROM Donation
WHERE CharityID =@CharityID
)
BEGIN 
SELECT 'Cannot delete this charity because it has donations.' AS ResultMessage;
RETURN;
END;
BEGIN TRY
DELETE FROM Charity
OUTPUT DELETED.*
WHERE CharityID =@CharityID

IF @@ROWCOUNT = 0
SELECT 'No charity found with that ID.' AS ResultMessage;
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE() AS ResultMessage;
END CATCH
END;
GO
--TEST
EXEC dbo.spN_DeleteCharity @CharityID = 101;
GO
-- Verify that the charity was deleted.
EXEC dbo.spN_GetCharity @CharityID = 101;

/*
e. Name each stored procedure with the appropriate table name and action. For example,
if we have the table Server above, each procedure will be named as follows:
*/

-- i. SELECT – spN_GetServer
-- ii. INSERT – spN_InsertServer
-- iii. UPDATE – spN_UpdateServer
-- iv. DELETE – spN_DeleteServer

/*
f. At least one stored procedure for each action (select, insert, update and delete) needs
to have at least one parameter as part of the stored procedure.
*/

/*
g. At least one stored procedure for each action (select, insert, update and delete) needs
to have at least one parameter as part of the stored procedure.
*/

/*
h. When each stored procedure is executed, it should not generate any exceptions and all
should return data.
*/
