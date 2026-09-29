-- SQL Programming Advanced: Final Project --
-- By: Osman Abdirahman, Landon Heezen, Nathan Aird, Cody Ferguson --

-- WEEK 7 DELIVERABLES --

USE Restaurant
GO

-- Deliverable 1 --

-- Landon Heezen --

-- Perform the following tasks:

-- a. Disable the NT SERVICE\SQLSERVERAGENT login at the database level


	
/* b. Add a new role/user called ‘RestaurantUser’ at the Restaurant database level (not at the
server level) */
-- i. Assign the schema db_backupoperator to this role/user.


	
/* c. Create a role/user in the Restaurant database called ‘RestaurantDoAnything’ and grant
the necessary permissions for this role/user to do anything to the Restaurant database */


	
/* d. Create a role/user that is called ‘RestaurantAddDeleteDb’ and grant the necessary
permissions for this role/user to create, alter, drop, or restore any database, but is not
allowed to insert into any database */


	
/* e. Create a role/user that is called ‘RestaurantPower’ that can modify the rights/privileges
of users in the Restaurant database.
*/

-- Deliverable 2 --

-- Cody Ferguson --

/* For all five (5) stored procedures developed in Week 4 Deliverables, Item 1, perform the
following actions. Generate the necessary SQL scripts for each action and save them to a folder
on your VM desktop called ‘Week 7 sp Object Permissions */

/* a. Assign ‘execute’ permissions to the object in Week 4 Deliverables, Item 1a, to schema
‘dbo’ */


	
/* b. Assign ‘View Definition’ permissions to the user ‘RestaurantUser’ to the stored
procedure listed in Week 4 Deliverables, Item 1b. */


	
/* c. Assign ‘Alter’ permissions to the user ‘RestaurantAddDeleteDb’ to the stored procedure
listed in Week 4 Deliverables, Item 1c. */


	
/* d. Assign ‘Take Ownership’ permissions to the user ‘RestaurantPower’ to the stored
procedure listed in Week 4 Deliverables, Item 1d. */


	
/* e. Assign ‘Control’ permission to the user RestaurantDoAnything’ to the stored procedure
listed in Week 4 Deliverables, Item 1e. */

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



/* e. Table: Table name used for item p in Week 2 Deliverables; user/role: [table name
here]_table_user; permissions: db_datareader, db_datawriter */


