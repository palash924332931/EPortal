
CREATE PROCEDURE [dbo].[IRPImportMarketDefinition2] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name + ' ' + M.Suffix, D.MarketBaseId, 'dynamic', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
		from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
		where MarketBaseId = @pMarketBaseId
		print(@whereClause)

		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''dynamic'', ' + cast(@marketDefinitionId as varchar) + ', ''dynamic-right'' 
		from DimProduct_Expanded' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end

	print('Semi-Final Query: ' + @insertStatement + @unionClause)

	drop table #loopTable
	declare @finalQuery varchar(max)
	set @finalQuery = left(@insertStatement+@unionClause, len(@insertStatement+@unionClause) - 6)
	print('Final Query: ' + @finalQuery)
	EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks
END


--[dbo].[IRPImportMarketDefinition2] 2150
--[dbo].[IRPImportMarketDefinition2] 3916
--[dbo].[IRPImportMarketDefinition2] 4280
--[dbo].[IRPImportMarketDefinition2] 2812




