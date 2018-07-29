CREATE PROCEDURE [dbo].[ProcessTerritoryForDelta]


AS
BEGIN
	SET NOCOUNT ON;

	select brickoutletcode into #Dbricks from OutletBrickAllocations where brickoutletcode not in (select brick from tblBrick) and type = 'brick' group by brickoutletcode
	select brickoutletcode into #Doutlets from OutletBrickAllocations where brickoutletcode not in (select outlet from tbloutlet) and type = 'outlet' group by brickoutletcode

	delete from OutletBrickAllocations where BrickOutletCode in (select brickoutletcode from #Dbricks) and type = 'brick'
	delete from OutletBrickAllocations where BrickOutletCode in (select brickoutletcode from #Doutlets) and type = 'outlet'

	---DELETE BRICKS---
	delete O from OutletBrickAllocations O  
	join 
	(select DISTINCT Brick
	from tblBrick where ChangeFlag = 'D') A 
	on A.Brick = O.BrickOutletCode 
	where O.type = 'brick'

	---MODIFY BRICKS---
	update O 
	set O.BrickOutletName = A.BrickName, O.State = A.State, O.Panel  = A.Panel, O.BrickOutletLocation = A.BrickLocation
	from OutletBrickAllocations O  
	join 
	(select DISTINCT Brick, BrickName, State, Panel, BrickLocation
	from tblBrick where ChangeFlag = 'M') A 
	on A.Brick = O.BrickOutletCode
	where O.type = 'brick'

	--DELETE OUTLETS--
	delete O from OutletBrickAllocations O  
	join 
	(select DISTINCT Outlet
	from tblOutlet where ChangeFlag = 'D') A 
	on A.Outlet = O.BrickOutletCode 
	where O.type = 'outlet'

	--MODIFY OUTLETS--
	update O 
	set O.BrickOutletName = A.OutletName, O.[Address] = A.[Address], O.BannerGroup = A.BannerGroup, O.State = A.State, O.Panel = A.Panel
	from OutletBrickAllocations O  
	join 
	(select DISTINCT Outlet, OutletName, [Address], BannerGroup, State, Panel
	from tblOutlet where ChangeFlag = 'M') A 
	on A.Outlet = O.BrickOutletCode 
	where O.type = 'outlet'

END
