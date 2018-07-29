
CREATE PROCEDURE [dbo].[BuildQueryForDelta] 
AS
BEGIN
	SET NOCOUNT ON;
	truncate table MarketBaseMapQuery

	select * into #loopTable4 from MarketDefinitions --where id = 58
		select * from #loopTable4

		declare @pMarketDefinitionId int

		while exists(select * from #loopTable4)
		begin
			select @pMarketDefinitionId = (select top 1 Id
							   from #loopTable4
							   order by Id asc)

			print('Mkt def id : ')
			print(@pMarketDefinitionId)
			-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
			EXEC [dbo].[BuildQueryForNewDataLoad] @MarketDefinitionId = @pMarketDefinitionId

			delete #loopTable4 where Id = @pMarketDefinitionId
		end

		drop table #loopTable4

END
