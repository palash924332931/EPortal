
 CREATE PROCEDURE [dbo].[MIPImportTerritoryDefinition] 
	@pTeamCode nvarchar(20),
	@pclientId int,
	@pIRPClientNo int,
	@pDeliverableId int
AS
BEGIN
	SET NOCOUNT ON;

	declare @AD nvarchar(20)
	declare @LD nvarchar(20)

	declare @guid nvarchar(max);
	set @guid =  NEWID();
	declare @territoryId int
	print('Loading: ')

	--### STEP 1 : insert into Territories
	
	select @AD = max(AD) from Territories where client_id = @pClientId
	select @LD = max(LD) from Territories where client_id = @pClientId

	if @AD is null begin set @AD = 1 end
	if @LD is null begin set @LD = 1 end

	insert into Territories (Name, RootGroup_id,Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, team_code)
	select  distinct team_name, NULL, @pclientId, 1, 0, @guid, @pIRPClientNo, @pTeamCode,@AD+1,@LD+1, team_code 
	from vw_Everest_TXR_FeedOUT where team_code = @pTeamCode

	--storing the recently inserted territory auto inc. ID
	select @territoryId = id from territories where GuiId = @guid
	--set @territoryId = 13094
	print('TerritoryId : ')
	print(@territoryId)
	
	--### STEP 2 : insert into Levels

	select row_number() over (partition by team_code order by geog_level) as levelNo, geog_level, geog_level_name into #tLevels from
	(
		select distinct team_code, geog_level, geog_level_name from vw_Everest_TXR_FeedOUT where team_code = @pTeamCode and geog_level_name <> 'Brick'
	)A

	--select * from #tLevels

	insert into Levels (name, levelNumber, levelIdLength, territoryId, IRPLevelID)
	select geog_level_name, levelNo, case when levelNo = 1 then 0 when levelNo = 2 then 1 else 2 end, @territoryId, geog_level from #tLevels

	--### STEP 3 : insert into Groups
	select 	a.geog_level,a.geog_level_name,b.levelNo, level1_code, level1_name,level2_code, level2_name,level3_code, level3_name,level4_code, level4_name,terr_code, terr_name, subterr1_code, subterr1_name, subterr2_code, subterr2_name
		,geog_code, geog_name, parent_geog_code into #tGroups 
	from vw_Everest_TXR_FeedOUT a join #tLevels b on a.geog_level = b.geog_level 
	where a.team_code = @pTeamCode and a.geog_level_name <> 'Brick' and (geog_code <> 'UN' and geog_code not like '%UNASSIGNED%') 
	order by a.geog_level

	delete from #tGroups where geog_name like '%UNASSIGNED%'

	insert into Groups(name, levelno, GroupCode, ParentGroupCode, GroupNumber, IsOrphan, PaddingLeft, TerritoryId)
	select geog_name, LevelNo, geog_code, parent_geog_code, cast(LevelNo as varchar) + cast(ROW_NUMBER() over(partition by LevelNo order by geog_code) as varchar),
		0, 130, @territoryId from  #tGroups 

	select distinct a.Id, a.GroupCode into #tParentGroups
	from (select Id, GroupCode from Groups where TerritoryId = @territoryId) a join #tGroups b on a.GroupCode COLLATE DATABASE_DEFAULT= b.parent_geog_code COLLATE DATABASE_DEFAULT

	update a set a.ParentId = b.Id
	from Groups a join #tParentGroups b on a.ParentGroupCode = b.GroupCode
	where a.TerritoryId = @territoryId and a.ParentGroupCode is not null
	---------------------------------------------------------------

	--select * from Groups
	--truncate table Groups
	select G.Id, S.GroupNumber into #parent from Groups G join Groups S on G.ParentId = S.Id where G.territoryId = @territoryId
	update Groups set ParentGroupNumber = IG.GroupNumber
	from Groups G join #parent IG on G.Id = IG.Id

	update Groups set CustomGroupNumberSpace = IG.CustomGroupNumberSpace
	from Groups G join IRP.GroupNumberMap IG on G.GroupNumber =  IG.GroupNumber
	where TerritoryId = @territoryId
	--exec testGroupUpdate @territoryId

	drop table #parent

	update Territories set RootGroup_id = G.Id
	from Territories T join Groups G on T.Id  = G.TerritoryId 
	where ParentId is NULL and T.Id  =  @territoryId

	--### STEP 4 : insert into OutletBrickAllocations
	-----------------------------------------------------------------------------------------------
	select a.parent_geog_code parent, b.CustomGroupNumberSpace, b.name, b.levelNo, a.geog_code Item into #tempItems 
	from vw_Everest_TXR_FeedOUT a 
	join (select * from groups where territoryId = @territoryId) b on a.parent_geog_code COLLATE DATABASE_DEFAULT = b.GroupCode
	where a.team_code = @pTeamCode and a.geog_level_name = 'Brick' AND a.parent_geog_code <> 'UN'

	insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, BrickOutletLocation, TerritoryId )
	select distinct t.CustomGroupNumberSpace NodeCode, t.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.BrickName BrickOutletName, l.Name LevelName, 'Brick' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, b.BrickLocation, @territoryId 
	from #tempItems t 
	join tblBrick b on t.Item COLLATE DATABASE_DEFAULT = b.Brick COLLATE DATABASE_DEFAULT
	join Levels l on t.LevelNo = l.levelnumber and l.TerritoryId = @territoryId
	-----------------------------------------------------------------------------------------------
	--select * from OutletBrickAllocations

	drop table #tempItems	

	---UPDATE CUSTOM GROUP NUMBER SPACE ---
	--exec [dbo].[IRPImportTerritoryCustomGroupNumber] @pTerritoryId=@territoryId
    
	--INSERT INTO DELIVERABLE MAPPING
	delete from  deliveryterritory where deliverableid = @pDeliverableId
	insert into deliveryterritory(deliverableid, territoryid) values (@pDeliverableId, @territoryId)
	print('End: ')
	print(@territoryId)

	--exec dbo.MIPImportTerritoryDefinitionStep2 @pTeamCode, @territoryId, @pDeliverableId


END