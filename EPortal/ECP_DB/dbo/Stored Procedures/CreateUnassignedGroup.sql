CREATE PROCEDURE [dbo].[CreateUnassignedGroup] 
@territoryid int
AS
BEGIN

declare  @levelnumber int, @TotalLevelIDLength int =0, @levelidlength int, @isbrickbased int
DECLARE @groupnumber varchar(20), @parentid int, @newGroupId int, @groupNumberWithSpace varchar(20) = null, @groupNumberWithSpaceParent varchar(20) = null
select @parentid = rootgroup_id from Territories where id = @territoryid

DECLARE db_cursor CURSOR FOR 
SELECT levelnumber, LevelIDLength 
FROM levels where 
territoryid = @territoryid and LevelNumber <> 1
order by LevelNumber asc

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @levelnumber, @LevelIDLength
---------------------- new stored proc
WHILE @@FETCH_STATUS = 0  
BEGIN  
	   -------get the max length
	  select  @TotalLevelIDLength =@TotalLevelIDLength +  @LevelIDLength
	  select @groupnumber = REPLICATE('9', @TotalLevelIDLength)

      -------concatenate and create group numbers with spaces
	  if (@parentid is not null and @parentid>0 ) BEGIN  select @groupNumberWithSpaceParent = CustomGroupNumberSpace from groups where Id = @parentid END
	  if (@groupNumberWithSpaceParent is null or @groupNumberWithSpaceParent = '') BEGIN SELECT @groupNumberWithSpace = convert(varchar(20), @groupnumber) print convert(varchar(20), @groupnumber) END
	  ELSE BEGIN select @groupNumberWithSpace = CONCAT(@groupNumberWithSpaceParent, ' ', REPLICATE('9', @LevelIDLength)) END

	  if(@levelnumber <> 1)
	  BEGIN
		if not exists (select * from Groups where ParentId = @parentid and LevelNo = @levelnumber and GroupNumber = @groupnumber)
		BEGIN
			INSERT INTO Groups (name, ParentId, GroupNumber, CustomGroupNumber, CustomGroupNumberSpace, IsOrphan, PaddingLeft, ParentGroupNumber, TerritoryId, NewCGN, LevelNo, IRPItemID, IsUnassigned) 
			values ('unassigned', @parentid, @groupnumber, @groupnumber, @groupNumberWithSpace, 0, 130, null, @territoryid, null, @levelnumber, null, 1)

			set @parentid = @@IDENTITY

		END
	  END
	  
      FETCH NEXT FROM db_cursor INTO @levelnumber, @LevelIDLength
END 

CLOSE db_cursor  
DEALLOCATE db_cursor

Declare @GroupId int
SELECT @GroupId = Id from Groups where TerritoryId = @territoryid and LevelNo = (
select Max(LevelNo) from groups where TerritoryId = @territoryid and IsUnassigned = 1
group by TerritoryId)

select @isbrickbased = IsBrickBased from Territories where id = @territoryid
delete from UnassignedBrickOutlet where TerritoryId = @territoryid			
IF (@isbrickbased =0)
BEGIN
INSERT INTO UnassignedBrickOutlet (TerritoryId, OutletBrickCode, GroupId)
select @territoryid, Outl_Brk, @GroupId from DIMOutlet d
except  
select @territoryid, BrickOutletCode, @GroupId  from OutletBrickAllocations where TerritoryId = @territoryid
END
ELSE
BEGIN
INSERT INTO UnassignedBrickOutlet (TerritoryId, OutletBrickCode, GroupId)
select @territoryid, Sbrick, @GroupId from DIMOutlet d
except  
select @territoryid, BrickOutletCode, @GroupId  from OutletBrickAllocations where TerritoryId = @territoryid			    
END



END
GO
