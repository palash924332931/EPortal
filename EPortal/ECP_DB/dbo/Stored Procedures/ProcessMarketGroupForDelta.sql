CREATE PROCEDURE [dbo].[ProcessMarketGroupForDelta]

AS
BEGIN
	SET NOCOUNT ON;

	select distinct MarketDefinitionId, GroupId into #loopTable7 from MarketGroupFilters --where MarketDefinitionId = @MarketDefinitionId
	--select* from #loopTable7
	declare @pMarketDefinitionId int
	declare @pGroupId int

	while exists(select * from #loopTable7)
	begin
		select @pMarketDefinitionId = (select top 1 MarketDefinitionId
						   from #loopTable7
						   order by MarketDefinitionId, GroupID asc)
		select @pGroupID = (select top 1 GroupID from #loopTable7 order by MarketDefinitionId, GroupID asc)

		print('MarketDefinitionId: ')
		print(@pMarketDefinitionId)

		print('GroupId: ')
		print(@pGroupID)

		-------CALL SP TO PROCESS PACKS FOR ROW-------
		EXEC [dbo].[ProcessPacksFromMarketGroup] 
		@MarketDefinitionId = @pMarketDefinitionId,
		@GroupID = @pGroupID

		delete #loopTable7 where MarketDefinitionId = @pMarketDefinitionId and GroupID = @pGroupID
	
	end

	drop table #loopTable7
END