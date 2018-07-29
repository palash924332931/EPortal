
CREATE PROCEDURE [dbo].[IRPImportMarketDefinitionMultipleMBAndPack_TEMP] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	--insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	--insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
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
	print('FINAL QUERY: ' + @finalQuery)
	
	--EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks

	--select  DISTINCT
	--CASE WHEN TRY_CONVERT(int, p.item) IS not NULL   
 --   THEN p.item
 --   ELSE null  
 --   END AS FCC
	--,p.Name,
	--case Charindex(';', g.shortname)
	--when 0 then null
	--when 1 then null
	--else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
	--end as groupname,
	--case Charindex(';', g.shortname)
	--when 0 then null
	--when LEN(g.shortname) then null
	--else Substring(g.shortname, Charindex(';', g.shortname)+8, LEN(g.shortname))
	--end as factor,
	--g.number [groupno]
	--into #fcctemp
	--from irp.items g
	--join irp.items p
	--on g.itemid = p.parent
	--where g.dimensionid = @pDimensionId
	--and p.itemtype = 1
	--and p.versionto > 0
	--and g.versionto > 0

	--update m set Alignment = 'dynamic-right'
	--from MarketDefinitionPacks m where m.PFC in (select distinct PFC from dimproduct_expanded where FCC in (select distinct FCC from #fcctemp))
	--and marketdefinitionid = @marketDefinitionId
END


--[dbo].[IRPImportMarketDefinitionMultipleMBAndPack] 2150


--exec [dbo].[IRPImportMarketDefinitionMultipleMBAndPack_TEMP] 1686

