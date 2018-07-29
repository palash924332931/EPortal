Create Procedure [dbo].[DeleteMarketDefinition]
@MarketDefID as int
AS
BEGIN
	Delete from DeliveryMarket Where MarketDefId=@MarketDefID
	Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)
	Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID
	Delete From MarketDefinitionPacks Where MarketDefinitionId=@MarketDefID
	Delete From MarketDefinitions Where Id=@MarketDefID
END

