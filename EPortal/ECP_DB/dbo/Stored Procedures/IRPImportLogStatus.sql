CREATE Procedure [dbo].[IRPImportLogStatus]
	@pImportType char(1),
	@pClientId int ,
	@dimensionId int,
	@key nvarchar(100),
	@pUser nvarchar(100)

AS
BEGIN
	
	if(@pImportType = 'T')
	begin
		declare @Tkount int
		declare @Lkount int
		declare @Gkount int
		declare @Okount int

		declare @RefKount int



			select @Tkount = count(*) from territories where dimensionid = @dimensionId
			select @Lkount = count(*) from Levels where territoryId = (select id from territories where dimensionid = @dimensionId)
			select @Gkount = count(*) from Groups where territoryId = (select id from territories where dimensionid = @dimensionId)
			select @Okount = count(*) from OutletBrickAllocations 
			where territoryId = (select id from territories where dimensionid = @dimensionId)

			if(@Tkount = 0 OR @Lkount = 0 OR @Gkount = 0 OR @Okount = 0)
			begin
				insert into dbo.IRPImportLog (ClientId, DimType, DimensionId, [Status], TimeOfImport, [Key], UserName)
				values (@pClientId, @pImportType, @dimensionId, 'FAILED', cast(GETDATE() as DATE), @key, @pUser) 

				exec [IRPDeleteTerritory] (select id from territories where dimensionid = @dimensionId)
			end
			else
			begin
				insert into dbo.IRPImportLog (ClientId, DimType, DimensionId, [Status], TimeOfImport, [Key], UserName)
				values (@pClientId, @pImportType, @dimensionId, 'SUCCESS', GETDATE(), @Key, @pUser) 
			end
		end
		else
		begin
			declare @Mkount int
			declare @Bkount int
			declare @Pkount int

			select @Mkount = count(*) from MarketDefinitions where dimensionid = @dimensionId
			select @Bkount = count(*) from MarketDefinitionBaseMaps where MarketDefinitionId = (select id from MarketDefinitions where dimensionid = @dimensionId)
			select @Pkount = count(*) from MarketDefinitionPacks where MarketDefinitionId = (select id from MarketDefinitions where dimensionid = @dimensionId)
			
			if(@Mkount = 0 OR @Bkount = 0 OR @Pkount = 0)
			begin
				insert into dbo.IRPImportLog (ClientId, DimType, DimensionId, [Status], TimeOfImport, [Key], UserName)
				values (@pClientId, @pImportType, @dimensionId, 'FAILED', cast(GETDATE() as DATE), @key, @pUser) 
				
				exec [IRPDeleteMarketDefinitionFromDimensionID] @dimensionId
			end
			else
			begin
				insert into dbo.IRPImportLog (ClientId, DimType, DimensionId, [Status], TimeOfImport, [Key], UserName)
				values (@pClientId, @pImportType, @dimensionId, 'SUCCESS', GETDATE(), @key, @pUser) 
			end

		end

END
