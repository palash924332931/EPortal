
ALTER TABLE IRP.DimensionBaseMap
   ADD Id INT IDENTITY
       CONSTRAINT PK_DimensionBaseMap PRIMARY KEY CLUSTERED
	   
	   

CREATE TYPE [dbo].[TYPDimensionBaseMap] AS TABLE(
	[DimensionId] [int] NULL,
	[MarketbaseId] [int] NULL
)
GO

CREATE PROCEDURE [dbo].[EditDimensionBaseMap]
	@marektbaseId int,
    @TVP TYPDimensionBaseMap READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from IRP.DimensionBaseMap where MarketBaseId = @marektbaseId
		insert into IRP.DimensionBaseMap select * from @TVP 
	commit
	
CREATE procedure [dbo].[GetIRPDimensionsForMarketbase]
 @pClientId int 
as
begin

	select 0 as Id, 0 as MarketbaseId, cast(DimensionId as int) as DimensionId , DimensionName from irp.Dimension where clientid IN (select irpclientid from irp.clientmap  where clientid = @pClientId) AND
		dimensiontype = 2 and versionto > 0 
end

CREATE PROCEDURE [dbo].[GetDimensionBaseMaps]
	@pMarketBaseId int
AS
BEGIN
	Select a.DimensionId, b.DimensionName,0 as Id,a.MarketBaseId 
	from IRP.DimensionBaseMap a join IRP.Dimension b on a.DimensionId = b.DimensionId
	where a.MarketBaseId = @pMarketBaseId
END