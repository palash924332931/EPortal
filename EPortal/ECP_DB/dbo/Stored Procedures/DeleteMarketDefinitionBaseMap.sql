Create Procedure [dbo].[DeleteMarketDefinitionBaseMap]
@MarketDefID as int
AS
BEGIN
	Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)
	Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID
END

