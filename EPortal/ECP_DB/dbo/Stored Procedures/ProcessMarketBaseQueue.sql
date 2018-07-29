CREATE PROCEDURE [dbo].[ProcessMarketBaseQueue]
as
begin
	declare @pMarketBaseid int
	select MarketBaseId into #loopTableMB from MarketBaseQueue
	
	while exists(select * from #loopTableMB)
	begin
		select @pMarketBaseid = (select top 1 MarketBaseId
							from #loopTableMB
							order by MarketBaseId asc)

		print('Mkt base id : ')
		print(@pMarketBaseid)
		-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
		EXEC [dbo].[RevalidateMarketDefinition] @MarketBaseId = @pMarketBaseid

		delete #loopTableMB where MarketBaseId = @pMarketBaseid
		delete MarketBaseQueue where MarketBaseId = @pMarketBaseid
	end

	drop table #loopTableMB	
end