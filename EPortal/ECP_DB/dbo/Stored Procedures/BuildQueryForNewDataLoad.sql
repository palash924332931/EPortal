
CREATE PROCEDURE [dbo].[BuildQueryForNewDataLoad]
 @MarketDefinitionId int 
AS
BEGIN
	SET NOCOUNT ON;

	print('MarketDefinitionId: ')
	print(@MarketDefinitionId)
	
	
	select * into #loopTable3 from MarketDefinitionBaseMaps
	where MarketDefinitionId = @MarketDefinitionId
	--select* from #loopTable3
	declare @pMarketDefinitionBaseMapId int
	declare @pMarketBaseId int

	while exists(select * from #loopTable3)
	begin
		select @pMarketDefinitionBaseMapId = (select top 1 Id
						   from #loopTable3
						   order by Id asc)
		select @pMarketBaseId = MarketBaseId from #loopTable3 where Id = @pMarketDefinitionBaseMapId

		print('MarketBaseId: ')
		print(@pMarketBaseId)

		print('MarketDefBaseMapId: ')
		print(@pMarketDefinitionBaseMapId)

		-------CALL SP TO PROCESS PACKS FOR ROW-------
		EXEC [dbo].[BuildQueryForMarketBaseMap] 
		@MarketDefinitionId = @MarketDefinitionId,
		@MarketBaseId = @pMarketBaseId,
		@MarketDefBaseMapId = @pMarketDefinitionBaseMapId

		delete #loopTable3 where Id = @pMarketDefinitionBaseMapId
	end

	drop table #loopTable3
END
