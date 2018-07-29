CREATE PROCEDURE [dbo].[GetAllOutlets] 
	@Role int = NULL
AS
BEGIN
	SET NOCOUNT ON;
if(@Role <> 1)
begin
	select cast(Outlet as nvarchar) Code, OutletName Name, Address, 
	BannerGroup,State, Panel, OutletLocation as BrickOutletLocation,
	'outlet' Type from dbo.tblOutlet
	where panel <> 'O' and changeflag <> 'D' Order by cast(outlet as int) asc
end

else
begin
	select cast(Outlet as nvarchar) Code, OutletName Name, Address, 
	BannerGroup,State, Panel, OutletLocation as BrickOutletLocation,
	'outlet' Type from dbo.tblOutlet where changeflag <> 'D' Order by cast(outlet as int) asc
end
	
END

