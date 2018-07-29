CREATE PROCEDURE [dbo].[IRPImportDuplicateTerritoryDefinition] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	
	SET IDENTITY_INSERT Territories ON
	
	declare @territoryType varchar(10)
	declare @lastLevel int
	--declare @refDimensionID int
	declare @refTerritoryid int

	declare @territoryInc int 
	declare @levelInc int 
	declare @groupInc int 
	declare @OBAInc int

	print('Loading: ')
	print(@pTerritoryId)

	select @territoryInc = (mAX(iD) - MIN(Id)) + 10 from Territories
	select @levelInc = (mAX(iD) - MIN(Id)) + 10 from Levels
	select @groupInc = (mAX(iD) - MIN(Id)) + 10 from Groups

	-- Delete existing Territory Definition if any
	declare @tCount int
	declare @tId int
	select @tCount = count(Id) from Territories where DimensionId = @pTerritoryId
	select @tId = Id from Territories where DimensionId = @pTerritoryId

	if @tCount > 0
		begin
			exec [IRPDeleteTerritory] @tId
		end
	
	--### STEP 1 : insert into Territories
	--refDimensionID
	--select @refDimensionID = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0

	select @refTerritoryid = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0
	
	insert into Territories (Id, Name, RootGroup_id,RootLevel_id,Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, DimensionId)
	select @refTerritoryid+@territoryInc, I.DimensionName, NULL, NULL, C.ClientID, case when BaseId = 2 then 0 else 1 end, 0, NULL, G.SRAClient as SRA_Client, G.SRASuffix as SRA_Suffix, G.AD, G.LD, @pTerritoryId 
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId join [IRP].[GeographyDimOptions] G on G.DimensionID=@pTerritoryId
	where I.DimensionID = @pTerritoryId and I.VersionTo =32767 and G.VersionTo =32767 and (G.SRAClient is not null or G.AD is not null or G.LD is not null)


	select @territoryType = IsBrickBased from Territories where Id = @refTerritoryid+@territoryInc 

	-- Implement refDimensionId 
	set @pTerritoryId = @refTerritoryid
	--if @refTerritoryid <> @pTerritoryId
	--begin
	--	--update Territories set Id = @refTerritoryid+@territoryInc where Id = @pTerritoryId
	--	set @pTerritoryId = @refTerritoryid
	--end


	--### STEP 2 : insert into Levels

	select @lastLevel = MAX(LevelNo) from IRP.Levels where DimensionID = @pTerritoryId and VersionTo > 0
	if @territoryType = 1 
	begin 
		set @lastLevel = @lastLevel - 1
	end 

	print('Last level: ')
	print(@lastLevel)

	SET IDENTITY_INSERT Territories OFF
	SET IDENTITY_INSERT Levels ON

	insert into Levels (Id, Name, LevelNumber, LevelIDLength, LevelColor, BackgroundColor, TerritoryId)
	select Id+@levelInc, Name, LevelNumber, LevelIDLength, NULL, NULL, TerritoryId+@territoryInc 
	from dbo.Levels where TerritoryId = @pTerritoryId 

	--select * from Levels
	update Levels set LevelIdLength =  0 where LevelNumber = 1

	--### STEP 3 : insert into Groups

	--insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, TerritoryId)
	--select ItemID+@groupInc, Name, Parent+@groupInc, LevelNo, cast(LevelNo as varchar) + cast(ROW_NUMBER() over(partition by LevelNo order by ItemID) as varchar), 0, 130, DimensionID+@territoryInc from IRP.Items 
	--where DimensionID = @pTerritoryId and LevelNO <= @lastLevel and VersionTo > 0

	SET IDENTITY_INSERT Levels OFF
	SET IDENTITY_INSERT Groups ON

	insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, CustomGroupNumber,CustomGroupNumberSpace,TerritoryId)
	select Id+@groupInc, Name, ParentId+@groupInc, LevelNo, GroupNumber, 0, 130, CustomGroupNumber,CustomGroupNumberSpace, TerritoryId+@territoryInc from dbo.Groups
	where TerritoryId = @pTerritoryId 

	--select * from Groups
	--truncate table Groups
	select G.Id, S.GroupNumber into #parent from Groups G join Groups S on G.ParentId = S.Id
	update Groups set ParentGroupNumber = IG.GroupNumber
	from Groups G join #parent IG on G.Id = IG.Id

	--update Groups set CustomGroupNumberSpace = IG.CustomGroupNumberSpace
	--from Groups G join IRP.GroupNumberMap IG on G.GroupNumber =  IG.GroupNumber

	drop table #parent

	declare @rgID int
	select @rgID= ID from groups where territoryid =@pTerritoryId+@territoryInc and parentid is null

	update Territories set RootGroup_id = @rgID where id=@pTerritoryId+@territoryInc

	--update Territories set RootGroup_id = G.Id
	--from Territories T join Groups G on T.Id = G.TerritoryId+@territoryInc
	--where ParentId is NULL and T.Id =  @pTerritoryId+@territoryInc
	--and G.TerritoryId=@pTerritoryId+@territoryInc

	--### STEP 4 : insert into OutletBrickAllocations
	print('territory type: ')
	print (@territoryType)
	select DimensionID, LevelNo, Parent, Item into #tempItems from IRP.Items where DimensionID = @pTerritoryId and LevelNo = @lastLevel and VersionTo > 0
	if @territoryType = 1 
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, BrickOutletLocation, TerritoryId)
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.BrickName BrickOutletName, l.Name LevelName, 'Brick' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, b.BrickLocation, t.DimensionID+@territoryInc TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		left join tblBrick b on t.Item = b.Brick
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end
	else
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, TerritoryId)
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.OutletName BrickOutletName, l.Name LevelName, 'Outlet' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, t.DimensionID+@territoryInc TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		left join tblOutlet b on t.Item = b.Outlet
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end

	--select * from OutletBrickAllocations
	delete from Groups where LevelNo = @lastLevel and TerritoryId = @pTerritoryId+@territoryInc

	drop table #tempItems
	print('END: ')
	print(@pTerritoryId)	
END





