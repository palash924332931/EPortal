

CREATE PROCEDURE [dbo].[BuildQueryForGroupDelta]

AS
BEGIN
	SET NOCOUNT ON;

	truncate table MarketGroupQuery
	
	select distinct MarketDefinitionId, GroupId into #loopTable5 from MarketGroupFilters --where MarketDefinitionId = @MarketDefinitionId
	--select* from #loopTable5
	declare @pMarketDefinitionId int
	declare @pGroupId int

	while exists(select * from #loopTable5)
	begin
		select @pMarketDefinitionId = (select top 1 MarketDefinitionId
						   from #loopTable5
						   order by MarketDefinitionId, GroupID asc)
		select @pGroupID = (select top 1 GroupID from #loopTable5 order by MarketDefinitionId, GroupID asc)

		print('MarketDefinitionId: ')
		print(@pMarketDefinitionId)

		print('GroupId: ')
		print(@pGroupID)

		-------CALL SP TO PROCESS PACKS FOR ROW-------
		EXEC [dbo].[BuildQueryForMarketGroup] 
		@MarketDefinitionId = @pMarketDefinitionId,
		@GroupID = @pGroupID

		delete #loopTable5 where MarketDefinitionId = @pMarketDefinitionId and GroupID = @pGroupID
	
	end

	drop table #loopTable5
END