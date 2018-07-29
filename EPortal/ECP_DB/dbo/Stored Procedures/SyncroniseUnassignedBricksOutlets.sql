

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SyncroniseUnassignedBricksOutlets]
	@territoryid int
AS
BEGIN

declare  @isbrickbased int

select @isbrickbased = IsBrickBased from Territories where id = @territoryid


Declare @GroupId int
SELECT @GroupId = Id from Groups where TerritoryId = @territoryid and LevelNo = (
select Max(LevelNo) from groups where TerritoryId = @territoryid and IsUnassigned = 1
group by TerritoryId)  and IsUnassigned = 1


			
IF (@isbrickbased =0)
BEGIN

MERGE UnassignedBrickOutlet u
USING (select distinct @territoryid territoryid, Outl_Brk from DIMOutlet d
except select territoryid, BrickOutletCode  from OutletBrickAllocations where TerritoryId = @territoryid) src
 on u.territoryid = src.territoryid and u.OutletBrickCode = src.Outl_Brk
WHEN  NOT MATCHED by source and u.territoryid = @territoryid and u.groupid = @groupid
THEN delete 
WHEN  NOT MATCHED by target
then insert values (@territoryid, src.Outl_Brk, @groupid);

END
ELSE
BEGIN
MERGE UnassignedBrickOutlet u
USING (select distinct @territoryid territoryid, sbrick from DIMOutlet d
except select territoryid, BrickOutletCode  from OutletBrickAllocations where TerritoryId = @territoryid) src
 on u.territoryid = src.territoryid and u.OutletBrickCode = src.sbrick
WHEN  NOT MATCHED by source and u.territoryid = @territoryid and u.groupid = @groupid
THEN delete 
WHEN  NOT MATCHED by target
then insert values (@territoryid, src.sbrick, @groupid);
END

END