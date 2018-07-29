

CREATE PROCEDURE [dbo].[ProcessPacksFromMarketGroup]
 @MarketDefinitionId int, 
 @GroupId int
AS
BEGIN
	SET NOCOUNT ON;

	declare @selectSql nvarchar(max)
	declare @countNewPacks int

	select @selectSql = query from MarketGroupQuery
	where MarketDefinitionId = @MarketDefinitionId and GroupID = @GroupID 

----FROM HERE 2-----
	--select distinct 24 as MarketBaseId, PFC, dimproduct_Expanded_test2.FCC, CHANGE_FLAG from dimproduct_Expanded_test2 where  [Org_Long_Name] in ('A PAK') AND CHANGE_FLAG = 'A'

	-----STORING THE OUTPUT OF QUERY INTO TEMPORARY TABLE VARIABLE
	declare @QueryResult table(MarketDefinitionId int, GroupID int, PFC varchar(30), CHANGE_FLAG char(1))
	insert @QueryResult EXEC(@selectSql)

	--select * from @QueryResult

	-------COMPARING with HISTORY-----------
	--select Q.MarketBaseId, Q.PFC, Q.FCC, H.CHANGE_FLAG into #packInHistory
	--from @QueryResult Q join [HISTORY_TDW-ECP_DIM_PRODUCT] H on Q.PFC = H.PFC and Q.FCC = H.FCC
	
	IF OBJECT_ID(N'tempdb..#packInHistory') IS NOT NULL drop table #packInHistory
	select * into #packInHistory from @QueryResult

	print('PACK IN HISTORY: ')
	select * from #packInHistory

	------Market Definition Packs update----------
	-----------INSERT NEW PACKS--------------
	IF OBJECT_ID(N'tempdb..#newPacks') IS NOT NULL drop table #newPacks
	select * into #newPacks
	from #packInHistory PS 
	--where PS.CHANGE_FLAG = 'A'

	--print('new packs:' )
	--select * from #newPacks

	select @countNewPacks = count(*) from #newPacks
	print('Count New Packs: ')
	print(@countNewPacks)
	if @countNewPacks > 0
	begin
		
		select * into #packsToInsert from
		( 
			select MarketDefinitionId, GroupId, PFC from
			(
				select MarketDefinitionId, GroupId, PFC from #newPacks
				except
				select MarketDefinitionId,  PFC from MarketGroupPacks where MarketDefinitionId = @MarketDefinitionId and GroupId = @GroupId
			)A 
		)C

		insert into MarketGroupPacks 
		select PFC, GroupID, MarketDefinitionId from #packsToInsert
	
		print('#packsToInsert:' )
		select * from #packsToInsert
	end

END