CREATE PROCEDURE [dbo].[IRPDeleteGroupsLevelsBricks] 
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	declare @rootGroupId int;
	
	--------delete from OutletBrickAllocations--------
	delete from OutletBrickAllocations where TerritoryId = @pTerritoryId;
	
	--------delete from Groups--------
	select @rootGroupId = RootGroup_id from Territories where Id = @pTerritoryId;
	update Territories set RootGroup_id = NULL where Id = @pTerritoryId;
	;WITH CTEGroups AS (
	  SELECT *
	  FROM Groups
	  WHERE Id = @rootGroupId
	  UNION ALL
	  SELECT t1.*
	  FROM Groups t1 INNER JOIN
	  CTEGroups v ON t1.ParentId = v.Id
	 )
	DELETE
	FROM Groups
	WHERE Id IN (SELECT Id FROM CTEGroups);
	
	--------delete from Levels--------
	delete from Levels where TerritoryId = @pTerritoryId;
	
END


