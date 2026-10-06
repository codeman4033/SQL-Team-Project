-- SQL Programming Advanced: Final Project --
-- By: Osman Abdirahman, Landon Heezen, Nathan Aird, Cody Ferguson --

-- WEEK 7 DELIVERABLES --

USE Restaurant
GO

-- Deliverable 1 --

-- Landon Heezen --

-- Perform the following tasks:

-- a. Disable the NT SERVICE\SQLSERVERAGENT login at the database level

ALTER LOGIN [NT SERVICE\SQLSERVERAGENT] DISABLE
	
/* b. Add a new role/user called ‘RestaurantUser’ at the Restaurant database level (not at the
server level) */
-- i. Assign the schema db_backupoperator to this role/user.

IF NOT EXISTS (SELECT 1
			   FROM sys.database_principals
			   WHERE name = 'RestaurantUser')

BEGIN

	CREATE USER RestaurantUser
	WITHOUT LOGIN
	WITH DEFAULT_SCHEMA = db_backupoperator

END

/* c. Create a role/user in the Restaurant database called ‘RestaurantDoAnything’ and grant
the necessary permissions for this role/user to do anything to the Restaurant database */

IF NOT EXISTS (SELECT 1
			   FROM sys.database_principals
			   WHERE name = 'RestaurantDoAnything')

BEGIN

	CREATE USER RestaurantDoAnything
	WITHOUT LOGIN

	ALTER ROLE db_owner
	ADD MEMBER RestaurantDoAnything

END

/* d. Create a role/user that is called ‘RestaurantAddDeleteDb’ and grant the necessary
permissions for this role/user to create, alter, drop, or restore any database, but is not
allowed to insert into any database */

IF NOT EXISTS (SELECT 1
			   FROM sys.server_principals
			   WHERE name = 'RestaurantAddDeleteDb')

BEGIN

	CREATE LOGIN RestaurantAddDeleteDb
	WITH PASSWORD = 'P@ssword'

	GRANT CREATE ANY DATABASE
	TO RestaurantAddDeleteDb

	GRANT ALTER ANY DATABASE
	TO RestaurantAddDeleteDb

END
	
/* e. Create a role/user that is called ‘RestaurantPower’ that can modify the rights/privileges
of users in the Restaurant database.
*/

IF NOT EXISTS (SELECT 1
			   FROM sys.database_principals
			   WHERE name = 'RestaurantPower')

BEGIN

	CREATE USER RestaurantPower
	WITHOUT LOGIN

	GRANT ALTER ANY USER
	TO RestaurantPower

END

GO

-- Deliverable 2 --

-- Cody Ferguson --

/* a. Assign 'execute' permissions to the object in Week 4 Deliverables, Item 1a, to schema 'dbo' */

GRANT EXECUTE
ON OBJECT::dbo.spN_ChefDetails
TO dbo;
GO


/* b. Assign 'View Definition' permissions to the user 'RestaurantUser' to the stored
procedure listed in Week 4 Deliverables, Item 1b. */

GRANT VIEW DEFINITION
ON OBJECT::dbo.spN_RecipeDetails
TO RestaurantUser;
GO


/* c. Assign 'Alter' permissions to the user 'RestaurantAddDeleteDb' to the stored
procedure listed in Week 4 Deliverables, Item 1c. */

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'RestaurantAddDeleteDb'
)
BEGIN
    CREATE USER RestaurantAddDeleteDb
    FOR LOGIN RestaurantAddDeleteDb;
END;
GO

GRANT ALTER
ON OBJECT::dbo.spN_RecipeIngredients
TO RestaurantAddDeleteDb;
GO


/* d. Assign 'Take Ownership' permissions to the user 'RestaurantPower' to the stored
procedure listed in Week 4 Deliverables, Item 1d. */

GRANT TAKE OWNERSHIP
ON OBJECT::dbo.spN_KitchenDetails
TO RestaurantPower;
GO


/* e. Assign 'Control' permission to the user 'RestaurantDoAnything' to the stored
procedure listed in Week 4 Deliverables, Item 1e. */

GRANT CONTROL
ON OBJECT::dbo.spN_CustomerDetails
TO RestaurantDoAnything;
GO

-- Deliverable 3 --

-- Osman Abdirahman & Nathan Aird --

/* For the following tables, create the provided user/role and assign the required permissions
to that user/role */

/* a. Table: Table name used for item h in Week 2 Deliverables; user/role: [table name
here]_table_user; permissions: db_datareader */
/* i. For example, if that table was named Recipes, the role would be called
recipe_table_user. */



/* b. Table: Table name used for item l in Week 2 Deliverables; user/role: [table name
here]_table_user; permissions: guest */


	
/* c. Table: Table name used for item o in Week 2 Deliverables; user/role: [table name
here]_table_user; permissions: db_datawriter */


	
/* d. Table: Table name used for item b in Week 2 Deliverables; user/role: [table name
here]_table_user; permissions: db_accessadmin */

create login employee_table_user with password = 'password';
create user employee_table_user;
alter role [db_accessadmin] add member employee_table_user;

/* e. Table: Table name used for item p in Week 2 Deliverables; user/role: [table name
here]_table_user; permissions: db_datareader, db_datawriter */

create login reservation_table_user with password = 'password';
create user reservation_table_user;
alter role db_datareader add member reservation_table_user;
alter role db_datawriter add member reservation_table_user;
