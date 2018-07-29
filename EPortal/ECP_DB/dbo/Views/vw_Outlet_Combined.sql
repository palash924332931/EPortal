
CREATE VIEW [dbo].[vw_Outlet_Combined]
AS


SELECT 
	 O.Id ID
	,O.TerritoryId TERRITORY_ID
	,O.BrickOutletCode BRICK_CODE
	,O.BrickOutletName BRICK_NAME
	,O.NodeCode NODE_CODE
	,O.NodeName NODE_NAME
	,O.Type TYPE
	,D.Outlet OUTLET_CODE
	,D.OutletId OUTLET_ID
	,D.Name OUTLET_NAME
	,D.FullAddr ADDRESS
	,D.PostCode  POST_CODE
FROM dbo.OutletBrickAllocations O
INNER JOIN dbo.DimOutlet D
ON O.BrickOutletCode = D.Sbrick AND O.BrickOutletName = D.Sbrick_Desc




