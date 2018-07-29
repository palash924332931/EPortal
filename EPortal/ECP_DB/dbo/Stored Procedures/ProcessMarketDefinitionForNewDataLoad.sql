CREATE PROCEDURE [dbo].[ProcessMarketDefinitionForNewDataLoad]
 @MarketDefinitionId int 
AS
BEGIN
	SET NOCOUNT ON;

	print('MarketDefinitionId: ')
	print(@MarketDefinitionId)
	
	
	select * into #loopTable2 from MarketDefinitionBaseMaps
	where MarketDefinitionId = @MarketDefinitionId
	--select* from #loopTable2
	declare @pMarketDefinitionBaseMapId int
	declare @pMarketBaseId int

	while exists(select * from #loopTable2)
	begin
		select @pMarketDefinitionBaseMapId = (select top 1 Id
						   from #loopTable2
						   order by Id asc)
		select @pMarketBaseId = MarketBaseId from #loopTable2 where Id = @pMarketDefinitionBaseMapId

		print('MarketBaseId: ')
		print(@pMarketBaseId)

		print('MarketDefBaseMapId: ')
		print(@pMarketDefinitionBaseMapId)

		-------CALL SP TO PROCESS PACKS FOR ROW-------
		EXEC [dbo].[ProcessPacksFromMarketBaseMap] 
		@MarketDefinitionId = @MarketDefinitionId,
		@MarketBaseId = @pMarketBaseId,
		@MarketDefBaseMapId = @pMarketDefinitionBaseMapId

		delete #loopTable2
		where Id = @pMarketDefinitionBaseMapId
	end

	drop table #loopTable2
END


--[dbo].[ProcessPacksFromMarketBaseMap] 430,653,569
--[dbo].[ProcessMarketDefinitionForNewDataLoad] 430
--select * from MarketDefinitionBaseMaps where MarketDefinitionId = 430
--select * from marketdefinitions

--[dbo].[ProcessMarketDefinitionForNewDataLoad] 1
