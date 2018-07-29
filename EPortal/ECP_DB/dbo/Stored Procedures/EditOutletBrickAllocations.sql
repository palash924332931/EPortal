

CREATE PROCEDURE [dbo].[EditOutletBrickAllocations]
	@territoryID int,
    @TVP TYP_OutletBrickAllocations READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from OutletBrickAllocations where territoryID = @territoryID
		insert into OutletBrickAllocations select * from @TVP 
	commit

