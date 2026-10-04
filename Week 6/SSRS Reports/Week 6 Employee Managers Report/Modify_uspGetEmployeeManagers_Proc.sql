USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[uspGetEmployeeManagers]    Script Date: 10/4/2026 3:33:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER   procedure [dbo].[uspGetEmployeeManagers]
    @BusinessEntityID [int] = 0
AS
BEGIN
    SET NOCOUNT ON;

    if @BusinessEntityID > 0
        -- Use recursive query to list out all Employees required for a particular Manager
        WITH [EMP_cte]([BusinessEntityID], [OrganizationNode], [FirstName], [LastName], [JobTitle], [RecursionLevel]) -- CTE name and columns
        AS (
            SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], 0 -- Get the initial Employee
            FROM [HumanResources].[Employee] e 
			    INNER JOIN [Person].[Person] as p
			    ON p.[BusinessEntityID] = e.[BusinessEntityID]
            WHERE e.[BusinessEntityID] = @BusinessEntityID
            UNION ALL
            SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], [RecursionLevel] + 1 -- Join recursive member to anchor
            FROM [HumanResources].[Employee] e 
                INNER JOIN [EMP_cte]
                ON e.[OrganizationNode] = [EMP_cte].[OrganizationNode].GetAncestor(1)
                INNER JOIN [Person].[Person] p 
                ON p.[BusinessEntityID] = e.[BusinessEntityID]
        )
        -- Join back to Employee to return the manager name 
        SELECT [EMP_cte].[RecursionLevel], [EMP_cte].[BusinessEntityID], [EMP_cte].[FirstName], [EMP_cte].[LastName],
            [EMP_cte].[OrganizationNode].ToString() AS [OrganizationNode], p.[FirstName] AS 'ManagerFirstName', p.[LastName] AS 'ManagerLastName'  -- Outer select from the CTE
        FROM [EMP_cte] 
            INNER JOIN [HumanResources].[Employee] e 
            ON [EMP_cte].[OrganizationNode].GetAncestor(1) = e.[OrganizationNode]
            INNER JOIN [Person].[Person] p 
            ON p.[BusinessEntityID] = e.[BusinessEntityID]
        ORDER BY [RecursionLevel], [EMP_cte].[OrganizationNode].ToString()
        OPTION (MAXRECURSION 25); 
    else
        select 0 as 'RecursionLevel', e.BusinessEntityID, ep.FirstName, ep.LastName, e.OrganizationNode.ToString() AS [OrganizationNode], 
               mp.[FirstName] AS 'ManagerFirstName', mp.[LastName] AS 'ManagerLastName'
        from HumanResources.Employee e
            inner join Person.Person ep
            on e.BusinessEntityID = ep.BusinessEntityID
            inner join HumanResources.Employee m
            on SUBSTRING(e.OrganizationNode.ToString(),1,len(e.OrganizationNode.ToString()) - 2) = m.OrganizationNode.ToString()
            inner join Person.Person mp
            on m.BusinessEntityID = mp.BusinessEntityID
        order by e.BusinessEntityID;

    
END;
GO