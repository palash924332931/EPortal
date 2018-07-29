
CREATE PROCEDURE [dbo].[GetUpdatedBricks] 
	-- Add the parameters for the stored procedure here
	@TerritoryId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select   A.BrickId Code, A.BrickName Name, A.Address Address, A.BannerGroup, A.State, A.Panel, A.BrickOutletLocation,
--B.BannerGroup, B.State, B.Panel,
'brick' Type from
(select Brick as BrickId, BrickName, ISNULL(Address, '') Address, ISNULL(BannerGroup, '') BannerGroup, State, Panel, BrickLocation as BrickOutletLocation from tblBrick where changeflag <> 'D'
except
select BrickOutletCode, BrickOutletName, ISNULL(Address, '') Address, BannerGroup, State, Panel, BrickOutletLocation from OutletBrickAllocations
where TerritoryId = @TerritoryId and Type = 'brick')A
--join tblBrick B
--on A.BrickId=B.brick and A.BrickName=b.BrickName
	
END

