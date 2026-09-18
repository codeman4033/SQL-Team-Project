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

-- ITEM 2 --

-- Landon Heezen

/* Develop the following indexes for the tables listed below. Foe each table, select what you
think is the appropriate field. Document why you made this selection. */

-- a.



-- b.



-- c.



-- d. 



-- e.


-- ITEM 3 --

-- Cody Ferguson + Osman Abdirahman

/* For two (2) tables above (your choice), develop stored procedures that will allow you to
perform CRUD (create/insert/update/delete) operations against those tables. This means that
each table will have one stored procedure for each of the following tasks: */

/*
a. SELECT from
*/

/*
b. INSERT into. It is up to you to decide what field(s) to include in the insert based on the
requirements above.
*/

/*
c. UPDATE – this will mean updating most fields on each table. It is up to you to decide
what field(s) to include when updating each table. For each update, you will need to
update at least three (3) fields.
*/

/*
d. DELETE – this will mean deleting a record from the table. When completing this step,
keep in mind the relationships you established in the previous step.
*/

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
