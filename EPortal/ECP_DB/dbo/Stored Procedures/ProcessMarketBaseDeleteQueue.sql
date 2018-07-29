CREATE PROCEDURE [dbo].[ProcessMarketBaseDeleteQueue]
as
begin
	declare @MarketBaseid int
	declare @CompleteDeleteFlag int
	declare @subscriptionId int
	select * into #loopTableMB from MarketBaseDeleteQueue
	
	while exists(select * from #loopTableMB)
	begin
		select @MarketBaseid = (select top 1 MarketBaseId
							from #loopTableMB
							order by MarketBaseId asc, CompleteDeleteFlag, subscriptionId)
		select @CompleteDeleteFlag = (select top 1 CompleteDeleteFlag
							from #loopTableMB
							order by MarketBaseId asc, CompleteDeleteFlag, subscriptionId)
		select @subscriptionId = (select top 1 SubscriptionId
							from #loopTableMB
							order by MarketBaseId asc, CompleteDeleteFlag, subscriptionId)

		print('Mkt base id : ')
		print(@MarketBaseid)
		print('flag : ')
		print(@CompleteDeleteFlag)
		print('subscriptoin : ')
		print(@subscriptionId)
		-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
		EXEC [dbo].[DeleteMarketBaseFinal] @pMarketBaseId = @MarketBaseid, @pCompleteDeleteFlag = @CompleteDeleteFlag, @pSubscriptionId = @subscriptionId

		delete #loopTableMB where MarketBaseId = @MarketBaseid and CompleteDeleteFlag = @CompleteDeleteFlag and SubscriptionId = @SubscriptionId
		delete MarketBaseDeleteQueue where MarketBaseId = @MarketBaseid and CompleteDeleteFlag = @CompleteDeleteFlag and SubscriptionId = @SubscriptionId
	end

	drop table #loopTableMB	
end