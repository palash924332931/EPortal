CREATE PROCEDURE [dbo].[EditPxRBaseMap]
	@marektbaseId int,
    @TVP TYPPxRBaseMap READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from MIP.MKTPxRBaseMap where MarketBaseId = @marektbaseId
		insert into MIP.MKTPxRBaseMap select * from @TVP 
	commit