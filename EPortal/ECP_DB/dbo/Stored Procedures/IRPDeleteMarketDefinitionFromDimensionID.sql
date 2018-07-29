CREATE Procedure [dbo].[IRPDeleteMarketDefinitionFromDimensionID]
@DimensionID as int
AS
BEGIN
Declare @MarketDefID int

select id into #tid from marketdefinitions where DimensionID=@DimensionID

while exists(select * from #tid)
	begin
		select @MarketDefID = (select top 1 id
							from #tid
							order by Id asc)

		-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
		print(@MarketDefID)
		Delete from DeliveryMarket Where MarketDefId=@MarketDefID
		Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)
		Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID
		Delete From MarketDefinitionPacks Where MarketDefinitionId=@MarketDefID
		Delete From MarketDefinitions Where Id=@MarketDefID

		delete #tid where id = @MarketDefID
	end

	drop table #tid

END

