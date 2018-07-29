CREATE PROCEDURE [dbo].[EditDimensionBaseMap]
	@marektbaseId int,
    @TVP TYPDimensionBaseMap READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from IRP.DimensionBaseMap where MarketBaseId = @marektbaseId
		insert into IRP.DimensionBaseMap select * from @TVP 
	commit