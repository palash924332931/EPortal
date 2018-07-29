CREATE PROCEDURE [dbo].[GetDimensionBaseMaps]
	@pMarketBaseId int
AS
BEGIN
	Select a.DimensionId, b.DimensionName,0 as Id,a.MarketBaseId 
	from IRP.DimensionBaseMap a join IRP.Dimension b on a.DimensionId = b.DimensionId
	where a.MarketBaseId = @pMarketBaseId
END