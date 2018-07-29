
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateUnassignedGroupsForAll]
AS
BEGIN

Declare @territoryId int

DECLARE territories_cursor CURSOR  
    FOR SELECT Id FROM Territories
OPEN territories_cursor  
FETCH NEXT FROM territories_cursor
into @territoryId

WHILE @@FETCH_STATUS = 0  
BEGIN      
		exec CreateUnassignedGroup @territoryId
	FETCH NEXT FROM territories_cursor
	into @territoryId
END

close territories_cursor
deallocate territories_cursor

END