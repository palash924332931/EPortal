
CREATE PROCEDURE [dbo].[IRPImportMarketDefinition] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;
	-- Delete existing Market Definition if any
	exec [dbo].[IRPDeleteMarketDefinitionFromDimensionID] @pDimensionId

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	--select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
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

	select a.* into #loopTable from IRP.DimensionBaseMap a join marketbases b on a.marketbaseid = b.id where DimensionId = @pDimensionId

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + 
		case when c.FilterValue = 'Molecule' then c.ColumnName + ' like ' + '(' + left([Values], 1) + '%' + substring([Values], 2, len([Values]) -2) + '%' + right([Values], 1) +')'
		else c.ColumnName + ' in ' + '(' + [Values] +')'  end 
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
	
	update marketdefinitionpacks
	set groupname=''
	where groupname is null

	update marketdefinitionpacks
	set groupnumber=''
	where groupnumber is null	
	
	--EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks
END


--[dbo].[IRPImportMarketDefinition2] 2150
--[dbo].[IRPImportMarketDefinition2] 3916
--[dbo].[IRPImportMarketDefinition2] 4280
--[dbo].[IRPImportMarketDefinition2] 2812



