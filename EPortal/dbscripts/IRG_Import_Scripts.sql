USE [EverestPortalUAT]
GO
/****** Object:  StoredProcedure [dbo].[IRPImportDuplicateTerritoryDefinition]    Script Date: 10/10/2017 3:43:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportDuplicateTerritoryDefinition] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
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
	
	--### STEP 1 : insert into Territories
	--refDimensionID
	--select @refDimensionID = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0

	insert into Territories (Id, Name, RootGroup_id,RootLevel_id,Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, DimensionId)
	select I.DimensionID, I.DimensionName, NULL, NULL, C.ClientID, case when BaseId = 2 then 0 else 1 end, 0, NULL, G.SRAClient as SRA_Client, G.SRASuffix as SRA_Suffix, G.AD, G.LD, @pTerritoryId 
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId join [IRP].[GeographyDimOptions] G on G.DimensionID=@pTerritoryId
	where I.DimensionID = @pTerritoryId and I.VersionTo =32767 and G.VersionTo =32767 and (G.SRAClient is not null or G.AD is not null or G.LD is not null)

	select @territoryType = IsBrickBased from Territories where Id = @pTerritoryId 

	-- Implement refDimensionId if needed
	select @refTerritoryid = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0
	if @refTerritoryid <> @pTerritoryId
	begin
		update Territories set Id = @refTerritoryid+@territoryInc where Id = @pTerritoryId
		set @pTerritoryId = @refTerritoryid
	end


	--### STEP 2 : insert into Levels

	select @lastLevel = MAX(LevelNo) from IRP.Levels where DimensionID = @pTerritoryId and VersionTo > 0
	if @territoryType = 1 
	begin 
		set @lastLevel = @lastLevel - 1
	end 

	print('Last level: ')
	print(@lastLevel)

	insert into Levels (Id, Name, LevelNumber, LevelIDLength, LevelColor, BackgroundColor, TerritoryId)
	select Id+@levelInc, Name, LevelNumber, LevelIDLength, NULL, NULL, TerritoryId+@territoryInc 
	from dbo.Levels where TerritoryId = @pTerritoryId 

	--select * from Levels
	update Levels set LevelIdLength =  0 where LevelNumber = 1

	--### STEP 3 : insert into Groups

	--insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, TerritoryId)
	--select ItemID+@groupInc, Name, Parent+@groupInc, LevelNo, cast(LevelNo as varchar) + cast(ROW_NUMBER() over(partition by LevelNo order by ItemID) as varchar), 0, 130, DimensionID+@territoryInc from IRP.Items 
	--where DimensionID = @pTerritoryId and LevelNO <= @lastLevel and VersionTo > 0

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

	update Territories set RootGroup_id = G.Id
	from Territories T join Groups G on T.Id = G.TerritoryId+@territoryInc
	where ParentId is NULL and T.Id = @pTerritoryId+@territoryInc

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

--exec [dbo].[IRPImportDuplicateTerritoryDefinition2] 963





GO
/****** Object:  StoredProcedure [dbo].[IRPImportMarketDefinition]    Script Date: 10/10/2017 3:43:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportMarketDefinition] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name +' ' + M.Suffix, D.MarketBaseId, 'dynamic', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, Molecule)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
		from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
		where MarketBaseId = @pMarketBaseId
		print('where clause :' +@whereClause)

		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''dynamic'', ' + cast(@marketDefinitionId as varchar) + ', ''dynamic-right'' 
		, ProductName as Product, M.Description as Molecule from DimProduct_Expanded left join DMMoleculeConcat M on M.FCC = DimProduct_Expanded.FCC' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end


	drop table #loopTable
	declare @finalQuery varchar(max)
	print('union clause:' +@unionClause)
	print('in+unclause: ' + @insertStatement+@unionClause)
					
	set @finalQuery = left(@insertStatement+@unionClause, len(@insertStatement+@unionClause)-6)
		
	print('Final Query: ' + @finalQuery)
	EXEC(@finalQuery)
	
		
	
	--EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks
END


--[dbo].[IRPImportMarketDefinition2] 2150
--[dbo].[IRPImportMarketDefinition2] 3916
--[dbo].[IRPImportMarketDefinition2] 4280
--[dbo].[IRPImportMarketDefinition2] 2812



GO
/****** Object:  StoredProcedure [dbo].[IRPImportMarketDefinitionMultipleMBAndPack]    Script Date: 10/10/2017 3:43:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportMarketDefinitionMultipleMBAndPack] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name +' ' + M.Suffix, D.MarketBaseId, 'static', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, Molecule)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
		from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
		where MarketBaseId = @pMarketBaseId
		print(@whereClause)

		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''static'', ' + cast(@marketDefinitionId as varchar) + ', ''static-left'' 
		, ProductName as Product, M.Description as Molecule from DimProduct_Expanded left join DMMoleculeConcat M on M.FCC = DimProduct_Expanded.FCC' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end


	drop table #loopTable
	declare @finalQuery varchar(max)
	set @finalQuery = left(@insertStatement+@unionClause, len(@insertStatement+@unionClause) - 6)
	print('Final Query: ' + @finalQuery)
	
	EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks

	select  DISTINCT
	CASE WHEN TRY_CONVERT(int, p.item) IS not NULL   
    THEN p.item
    ELSE null  
    END AS FCC
	,p.Name,
	case Charindex(';', g.shortname)
	when 0 then null
	when 1 then null
	else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
	end as groupname,
	case Charindex(';', g.shortname)
	when 0 then null
	when LEN(g.shortname) then null
	else Substring(g.shortname, Charindex(';', g.shortname)+8, LEN(g.shortname))
	end as factor,
	g.number [groupno]
	into #fcctemp
	from irp.items g
	join irp.items p
	on g.itemid = p.parent
	where g.dimensionid = @pDimensionId
	and p.itemtype = 1
	and p.versionto > 0

	update m set Alignment = 'dynamic-right'
	from MarketDefinitionPacks m where m.PFC in (select distinct PFC from dimproduct_expanded where FCC in (select distinct FCC from #fcctemp))
	and marketdefinitionid = @marketDefinitionId
END


--[dbo].[IRPImportMarketDefinitionMultipleMBAndPack] 2150




GO
/****** Object:  StoredProcedure [dbo].[IRPImportPackBaseMarketDefinition]    Script Date: 10/10/2017 3:43:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[IRPImportPackBaseMarketDefinition] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name + ' ' + M.Suffix , D.MarketBaseId, 'static', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)

	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 

	select top 1 @marketBaseId=Id, @marketBaseName=Name + ' ' + Suffix 
	from MarketBases M join IRP.DimensionBaseMap D on M.Id = D.MarketBaseId
	where D.DimensionId = @pDimensionId

	select  DISTINCT
	CASE WHEN TRY_CONVERT(int, p.item) IS not NULL   
    THEN p.item
    ELSE null  
    END AS FCC
	,p.Name,
	case Charindex(';', g.shortname)
	when 0 then null
	when 1 then null
	else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
	end as groupname,
	case Charindex(';', g.shortname)
	when 0 then null
	when LEN(g.shortname) then null
	else Substring(g.shortname, Charindex(';', g.shortname)+8, LEN(g.shortname))
	end as factor,
	g.number [groupno]
	into #fcctemp
	from irp.items g
	join irp.items p
	on g.itemid = p.parent
	where g.dimensionid = @pDimensionId
	and p.itemtype = 1
	and p.versionto > 0
	
	insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, GroupNumber, GroupName, Factor, Molecule)
	select distinct p.Pack_Description, @marketBaseName, cast(@marketBaseId as varchar), p.PFC, p.ORG_LONG_NAME, p.ATC4_Code, p.NEC4_Code, 'static', cast(@marketDefinitionId as varchar), 'dynamic-right', p.[ProductName], f.groupno, f.groupname, f.factor, M.Description
	from DimProduct_Expanded p
	join #fcctemp f	on f.fcc = p.fcc
	left join DMMoleculeConcat M on M.FCC = p.FCC

	select count(*) from #fcctemp
	select 'def id:' + cast(@marketDefinitionId as varchar)

	

	-------------FOR STATIC LEFT -----------------
	select distinct ATC4 into #ATC4 from MarketDefinitionPacks where Alignment like '%right%' and MarketDefinitionID=@marketDefinitionId
	print('#ATC4 :')

	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, Molecule)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId
			
		IF EXISTS (select distinct Criteria from basefilters where MarketBaseId=@pMarketBaseId and criteria not like 'ATC%')
			BEGIN
				select @whereClause = ' where ATC4_code in (select * from #ATC4) AND  ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
				from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
				where MarketBaseId = @pMarketBaseId
				print('whereClause IF: ' + @whereClause)
			END
		ELSE
			BEGIN
				select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
				from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
				where MarketBaseId = @pMarketBaseId
				print('whereClause ELSE: ' + @whereClause)
			END 


		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''' MarketBase, ' + cast(@pMarketBaseId as varchar) + ' MarketBaseId, PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''static''  DataRefreshType, ' + cast(@marketDefinitionId as varchar) + ' MarketDefinitionId, ''static-left'' Alignment 
		, ProductName as Product, M.Description as Molecule from DimProduct_Expanded left join DMMoleculeConcat M on M.FCC = DimProduct_Expanded.FCC' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end


	drop table #loopTable
	declare @finalQuery varchar(max)
	set @unionClause = left(@unionClause, len(@unionClause)-6) 
	set @finalQuery = @insertStatement + 'select * from (' + @unionClause + ')Z where Z.PFC not in (select distinct PFC from dbo.DIMPRODUCT_EXPANDED where FCC in (select distinct FCC from #fcctemp))'
	--set @finalQuery = left(@insertStatement+@finalQuery, len(@insertStatement+@finalQuery) - 4)
	print('Final Query: ' + @finalQuery)

	
	EXEC(@finalQuery)
	
	drop table #fcctemp

END





GO
/****** Object:  StoredProcedure [dbo].[IRPImportTerritoryCustomGroupNumber]    Script Date: 10/10/2017 3:43:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IRPImportTerritoryCustomGroupNumber] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	--SET IDENTITY_INSERT [dbo].[Territories] ON;
	--SET IDENTITY_INSERT [dbo].[Levels] ON;
	--SET IDENTITY_INSERT [dbo].[Levels] ON
	--SET IDENTITY_INSERT [dbo].[OutletBrickAllocations] ON;

declare @IDLen2 int 
declare @IDLen3 int 
declare @IDLen4 int 
declare @IDLen5 int 


-----------------update levels id length------------

	update l
	set l.levelidlength=B.length
	from levels l
	join 
	(
	select levelid,levelno, [end] - start + 1 length from
	(
		   select *, cast(substring(Options, 7, 1) as int) start, cast(right(Options, 1) as int) 'end'
		   from IRP.Levels 
		   where 
		   options <> '' and 
		   dimensionid = @pTerritoryId and 
		   versionto > 0
	)A)B
	on l.id=b.levelid
	and l.levelnumber=B.levelno
	where l.levelnumber > 1
-------------------------------------------------------------------------

select @IDLen2=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=2
select @IDLen3=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=3
select @IDLen4=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=4
select @IDLen5=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=5

------------------level 2-------------------------------------------------------

update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, replace(Number, '-','') cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 2)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

------------------level 3-------------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 3)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

--------------------level 4-----------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + 1, @IDLen4) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 4)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

--------------------level 5-----------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + 1, @IDLen4) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + @IDLen4 + 1, @IDLen5) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 5)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

-------update nodecode from Items---------
--update o
--set o.nodecode=replace(i.number,'-','')
--from outletbrickallocations o
--join IRP.Items i
--on o.territoryid=i.dimensionid
--and o.brickoutletcode=i.Item
--where o.territoryid=@pTerritoryId

--update o
--set o.nodecode=g.customgroupnumberspace
--from outletbrickallocations o
--join groups g
--on o.territoryid=g.territoryid
--and o.nodecode=g.customgroupnumber
--where o.territoryid=@pTerritoryId

update o
set o.NodeCode = g.NewCGN
from OutletBrickAllocations o join Groups g on o.TerritoryId = g.TerritoryId and o.NodeCode = g.CustomGroupNumberSpace
where o.TerritoryId = @pTerritoryId

update Groups set CustomGroupNumberSpace = NewCGN 
where TerritoryId = @pTerritoryId
	
	--SET IDENTITY_INSERT [dbo].[Territories] OFF;
	--SET IDENTITY_INSERT [dbo].[Levels] OFF;
	--SET IDENTITY_INSERT [dbo].[Levels] OFF
	--SET IDENTITY_INSERT [dbo].[OutletBrickAllocations] OFF;

END


--exec [dbo].[IRPImportTerritoryDefinition_Groups] 3989





GO
/****** Object:  StoredProcedure [dbo].[IRPImportTerritoryDefinition]    Script Date: 10/10/2017 3:43:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportTerritoryDefinition] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	declare @territoryType varchar(10)
	declare @lastLevel int
	declare @refTerritoryid int
	print('Loading: ')
	print(@pTerritoryId)
	--### STEP 1 : insert into Territories
	insert into Territories (Id, Name, RootGroup_id,RootLevel_id,Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, DimensionId)
	select  distinct I.DimensionID,I.DimensionName, NULL, NULL, C.ClientID, case when BaseId = 2 then 0 else 1 end, 0, NULL, G.SRAClient as SRA_Client, G.SRASuffix as SRA_Suffix, G.AD, G.LD, @pTerritoryId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId join [IRP].[GeographyDimOptions] G on I.DimensionID=G.DimensionID
	where I.DimensionID = @pTerritoryId and I.VersionTo =32767 and G.VersionTo = 32767 and (G.SRAClient is not null or G.AD is not null or G.LD is not null)
	
	select @territoryType = IsBrickBased from Territories where Id = @pTerritoryId 

	-- Implement refDimensionId if needed

	select @refTerritoryid = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0
	if @refTerritoryid <> @pTerritoryId
	begin
		update Territories set Id = @refTerritoryid where Id = @pTerritoryId
		set @pTerritoryId = @refTerritoryid
	end

	--### STEP 2 : insert into Levels

	select @lastLevel = MAX(LevelNo) from IRP.Levels where DimensionID = @pTerritoryId and VersionTo > 0
	if @territoryType = 1 
	begin 
		set @lastLevel = @lastLevel - 1
	end 

	print('Last level: ')
	print(@lastLevel)

	insert into Levels (Id, Name, LevelNumber, LevelIDLength, LevelColor, BackgroundColor, TerritoryId)
	select LevelID, LevelName, LevelNo, case when LevelNo < 3 then 1 else 2 end, NULL, NULL, DimensionID 
	from IRP.Levels where DimensionID = @pTerritoryId and LevelNo <= @lastLevel - 1 and VersionTo > 0

	update Levels set LevelIdLength =  0 where LevelNumber = 1
	--select * from Levels

	--### STEP 3 : insert into Groups

	insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, TerritoryId)
	select ItemID, Name, Parent, LevelNo, cast(LevelNo as varchar) + cast(ROW_NUMBER() over(partition by LevelNo order by ItemID) as varchar), 0, 130, DimensionID from IRP.Items 
	where DimensionID = @pTerritoryId and LevelNO <= @lastLevel and VersionTo > 0

	--select * from Groups
	--truncate table Groups
	select G.Id, S.GroupNumber into #parent from Groups G join Groups S on G.ParentId = S.Id
	update Groups set ParentGroupNumber = IG.GroupNumber
	from Groups G join #parent IG on G.Id = IG.Id

	update Groups set CustomGroupNumberSpace = IG.CustomGroupNumberSpace
	from Groups G join IRP.GroupNumberMap IG on G.GroupNumber =  IG.GroupNumber
	where TerritoryId = @pTerritoryId

	drop table #parent

	update Territories set RootGroup_id = G.Id
	from Territories T join Groups G on T.Id = G.TerritoryId
	where ParentId is NULL and T.Id = @pTerritoryId

	--### STEP 4 : insert into OutletBrickAllocations
	print('territory type: ')
	print (@territoryType)
	select DimensionID, LevelNo, Parent, Item into #tempItems from IRP.Items where DimensionID = @pTerritoryId and LevelNo = @lastLevel and VersionTo > 0
	if @territoryType = 1 
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, BrickOutletLocation, TerritoryId )
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.BrickName BrickOutletName, l.Name LevelName, 'Brick' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, b.BrickLocation, t.DimensionID TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		left join tblBrick b on t.Item = b.Brick
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end
	else
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type,BannerGroup, State, Panel, TerritoryId)
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.OutletName BrickOutletName, l.Name LevelName, 'Outlet' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, t.DimensionID TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		left join [IRP].[IMSOutletMaster] x on x.OID = t.Item
		left join tblOutlet b on x.EID = b.EID
		--left join tblOutlet b on t.Item = b.EID
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end

	--select * from OutletBrickAllocations
	delete from Groups where LevelNo = @lastLevel and TerritoryId = @pTerritoryId

	drop table #tempItems	

	---UPDATE CUSTOM GROUP NUMBER SPACE ---
	exec [dbo].[IRPImportTerritoryCustomGroupNumber] @pTerritoryId=@pTerritoryId
    print('End: ')
	print(@pTerritoryId)
END

--exec [dbo].[IRPImportTerritoryDefinition] 3249
--exec [dbo].[IRPImportTerritoryDefinition] 66
--exec [dbo].[IRPImportTerritoryDefinition] 78
--exec [dbo].[IRPImportTerritoryDefinition] 1247
--exec [dbo].[IRPImportTerritoryDefinition] 847
--exec [dbo].[IRPImportTerritoryDefinition] 1229
--exec [dbo].[IRPImportTerritoryDefinition] 3198
--exec [dbo].[IRPImportTerritoryDefinition] 1319
--exec [dbo].[IRPImportTerritoryDefinition] 3994
--exec [dbo].[IRPImportTerritoryDefinition] 1631

--SELECT * FROM TBLOUTLET
--SELECT * FROM DIMOUTLET





GO
