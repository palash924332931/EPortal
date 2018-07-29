Create procedure [dbo].[GetIRPDimensionsForMarketbase]
 @pClientId int 
as
begin

	select 0 as Id, 0 as MarketbaseId, cast(DimensionId as int) as DimensionId , DimensionName from irp.Dimension where clientid IN (select irpclientid from irp.clientmap  where clientid = @pClientId) AND
		dimensiontype = 2 and versionto > 0 
end