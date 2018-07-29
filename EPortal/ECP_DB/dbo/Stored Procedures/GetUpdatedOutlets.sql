

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUpdatedOutlets] 
	-- Add the parameters for the stored procedure here
	@TerritoryId int,
	@Role int = NULL 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if(@Role <> 1)
begin
	select --ROW_NUMBER() OVER( ORDER BY A.OutletId) as NID, 
	cast(A.OutletId as nvarchar) Code, A.OutletName Name, A.Address, A.BannerGroup, A.State, A.Panel, A.BrickOutletLocation, 
	--B.BannerGroup, B.State, B.Panel,
	'outlet' Type from
	(
		select cast(Outlet as nvarchar) OutletId, OutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, OutletLocation as BrickOutletLocation from tblOutlet where changeflag <> 'D'
			except
		select BrickOutletCode, BrickOutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, BrickOutletLocation from OutletBrickAllocations
		where TerritoryId = @TerritoryId and Type = 'outlet'
	)A
	where A.panel <> 'O' Order by cast(A.OutletId as int) asc
end
else
begin
	select --ROW_NUMBER() OVER( ORDER BY A.OutletId) as NID, 
	cast(A.OutletId as nvarchar) Code, A.OutletName Name, A.Address, A.BannerGroup, A.State, A.Panel, A.BrickOutletLocation,
	--B.BannerGroup, B.State, B.Panel,
	'outlet' Type from
	(
		select cast(Outlet as nvarchar) OutletId, OutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, OutletLocation as BrickOutletLocation from tblOutlet where changeflag <> 'D'
			except
		select BrickOutletCode, BrickOutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, BrickOutletLocation from OutletBrickAllocations
		where TerritoryId = @TerritoryId and Type = 'outlet'
	)A
	Order by cast(A.OutletId as int) asc
end
END

--exec [dbo].[GetUpdatedOutlets] @TerritoryId=N'1031'

--select top 10 * from dimoutlet
--select top 10 * from tblOutlet
--select top 10 * from tblBrick
--




