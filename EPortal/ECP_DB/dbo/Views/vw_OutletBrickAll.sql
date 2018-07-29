

CREATE VIEW [dbo].[vw_OutletBrickAll]
AS


SELECT 
	 O.Id ID
	,O.TerritoryId
	,O.BrickOutletCode
	,O.BrickOutletName
	,O.NodeCode
	,O.NodeName
	,O.Type TYPE
	,D.Outlet OUTLET_CODE
	,D.OutletId OUTLET_ID
	,D.Name OUTLET_NAME
	,D.FullAddr ADDRESS
	,D.PostCode  POST_CODE
FROM dbo.OutletBrickAllocations O
INNER JOIN dbo.DimOutlet D
ON O.BrickOutletCode = D.Sbrick AND O.BrickOutletName = D.Sbrick_Desc





