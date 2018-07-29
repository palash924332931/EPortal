IF COL_LENGTH('Territories', 'SRA_Client') IS NULL
BEGIN
    ALTER TABLE Territories
    ADD SRA_Client nvarchar(100)
END

IF COL_LENGTH('Territories', 'SRA_Suffix') IS NULL
BEGIN
    ALTER TABLE Territories
    ADD SRA_Suffix nvarchar(100)
END

IF COL_LENGTH('Territories', 'AD') IS NULL
BEGIN
    ALTER TABLE Territories
    ADD AD nvarchar(100)
END


IF COL_LENGTH('Territories', 'LD') IS NULL
BEGIN
    ALTER TABLE Territories
    ADD LD nvarchar(100)
END

---set default values for TerritoryId column of groups table
ALTER TABLE Groups ADD CONSTRAINT DF_TerritoryId DEFAULT 0 FOR TerritoryId;

Select * from Territories Where client_Id=2

-- create view for territories
IF EXISTS(select * FROM sys.views where name = 'vwTerritories')
BEGIN
 DROP VIEW vwTerritories
END 
GO
Create View vwTerritories
AS
 SELECT Id, CASE WHEN SRA_Client is not null then Name+' ('+SRA_Client +'' + SRA_Suffix+')' ELSE Name END as Name, RootGroup_id, RootLevel_Id, Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD
FROM Territories
GO


--- Procedure to delete groups levels and bricks of territroy
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[IRPDeleteGroupsLevelsBricks]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN	
 DROP procedure IRPDeleteGroupsLevelsBricks
END 
GO
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
GO

