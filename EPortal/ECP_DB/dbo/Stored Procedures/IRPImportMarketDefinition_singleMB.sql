

CREATE PROCEDURE [dbo].[IRPImportMarketDefinition_singleMB] 
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
	select M.Name, D.MarketBaseId, 'dynamic', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	select @marketBaseId=M.Id, @marketBaseName=Name 
	from MarketBases M join IRP.DimensionBaseMap D on M.Id = D.MarketBaseId
	where D.DimensionId = @pDimensionId

	declare @whereClause nvarchar(max)
	select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
	from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
	where MarketBaseId = (select MarketBaseId from IRP.DimensionBaseMap where DimensionId = @pDimensionId)
	print(@whereClause)

	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment)
	select Pack_Description, '''+ @marketBaseName +''', ' + cast(@marketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''dynamic'', ' + cast(@marketDefinitionId as varchar) + ', ''dynamic-right'' 
	from DimProduct_Expanded'

	print(@insertStatement+@whereClause)
	EXEC(@insertStatement+@whereClause)

	--select * from MarketDefinitionPacks
END



--[dbo].[IRPImportMarketDefinition] 3916
--[dbo].[IRPImportMarketDefinition] 4280
--[dbo].[IRPImportMarketDefinition] 2812
--[dbo].[IRPImportMarketDefinition] 4605



