
CREATE PROCEDURE [dbo].[GetAllBricks] 
AS
BEGIN
	SET NOCOUNT ON;

select Brick Code, BrickName Name, Address, 
BannerGroup,State, Panel, BrickLocation as BrickOutletLocation,
'brick' Type from dbo.tblBrick where ChangeFlag<>'D'
	
END


