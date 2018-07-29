CREATE procedure [dbo].[UpdateDataRefreshType]
	@NewMarketDefId int
as
begin

	UPDATE A set A.DataRefreshType = B.DataRefreshType
	from MarketDefinitionBaseMaps A
	join 
	(
		select distinct MarketBaseId, DataRefreshType, MarketDefinitionId from MarketDefinitionPacks 
		where marketdefinitionid = @NewMarketDefId and MarketBaseId not like '%,%'
	)B 
	on A.MarketDefinitionId = B.MarketDefinitionId and A.MarketBaseId = cast(B.MarketBaseId as varchar)
	where A.marketdefinitionid = @NewMarketDefId

end



