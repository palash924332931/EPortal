CREATE VIEW [dbo].[vw_EverestTXR]
AS
SELECT map.irpClientNo IMSClientNo, C.Name ClientName, T .Id TeamId, T .name TerritoryName, L.LevelNumber, L.Name LevelName, G.Name GroupName, 
                  G.CustomGroupNumber GroupNumber, G.GroupCode, T .IsBrickBased, g.ParentId, g.id GroupId
FROM     Groups G JOIN
                  Levels L ON L.TerritoryId = G.TerritoryId AND L.LevelNumber = G.LevelNo JOIN
                  Territories T ON T .id = G.TerritoryId JOIN
                  Clients C ON T .Client_Id = C.Id JOIN
                  IRP.ClientMap map ON map.ClientId = c.Id
WHERE  (G.IsUnassigned IS NULL OR
                  G.IsUnassigned = 0)
UNION ALL
SELECT map.irpClientNo IMSClientNo, C.Name ClientName, T .Id TeamId, T .name TerritoryName, L.LevelNumber + 1, CASE T.IsBrickBased WHEN 1 THEN 'BRICK' ELSE 'OUTLET' END LevelName, 
o.BrickOutletName GroupName, G.CustomGroupNumber GroupNumber, O.BrickOutletCode GroupCode, T .IsBrickBased, g.Id ParentId, null GroupId
FROM Groups G JOIN
                  OutletBrickAllocations O ON G.TerritoryId = O.TerritoryId AND g.CustomGroupNumberSpace = o.NodeCode JOIN
                  Levels L ON L.TerritoryId = G.TerritoryId AND L.LevelNumber = G.LevelNo JOIN
                  Territories T ON T .id = G.TerritoryId JOIN
                  Clients C ON T .Client_Id = C.Id JOIN
                  IRP.ClientMap map ON map.ClientId = c.Id
WHERE  (G.IsUnassigned IS NULL OR
                  G.IsUnassigned = 0) 
UNION ALL
SELECT DISTINCT 
                  map.irpClientNo IMSClientNo, C.Name ClientName, T .Id TeamId, T .name TerritoryName, L.LevelNumber + 1, CASE T.IsBrickBased WHEN 1 THEN 'BRICK' ELSE 'OUTLET' END LevelName, 
				  D .BrickName GroupName, G.CustomGroupNumber GroupNumber, O.OutletBrickCode GroupCode, T .IsBrickBased,  g.Id ParentId, null GroupId
FROM     Groups G JOIN
                  UnassignedBrickOutlet O ON G.TerritoryId = O.TerritoryId AND G.Id = o.GroupId JOIN
                  tblBrick D ON D .Brick = O.OutletBrickCode JOIN
                  Levels L ON L.TerritoryId = G.TerritoryId AND L.LevelNumber = G.LevelNo JOIN
                  Territories T ON T .id = G.TerritoryId JOIN
                  Clients C ON T .Client_Id = C.Id JOIN
                  IRP.ClientMap map ON map.ClientId = c.Id
WHERE  G.IsUnassigned = 1 AND T .isbrickbased = 1
UNION ALL
SELECT map.irpClientNo IMSClientNo, C.Name ClientName, T .Id TeamId, T .name TerritoryName, L.LevelNumber + 1, CASE T.IsBrickBased WHEN 1 THEN 'BRICK' ELSE 'OUTLET' END LevelName, 
				  D.Outl_Brk GroupName, G.CustomGroupNumber GroupNumber, O.OutletBrickCode GroupCode, T .IsBrickBased,  g.Id ParentId, null GroupId
FROM     Groups G JOIN
                  UnassignedBrickOutlet O ON G.TerritoryId = O.TerritoryId AND G.Id = o.GroupId JOIN
                  DIMOutlet D ON D .Outl_Brk = O.OutletBrickCode JOIN
                  Levels L ON L.TerritoryId = G.TerritoryId AND L.LevelNumber = G.LevelNo JOIN
                  Territories T ON T .id = G.TerritoryId JOIN
                  Clients C ON T .Client_Id = C.Id JOIN
                  IRP.ClientMap map ON map.ClientId = c.Id
WHERE  G.IsUnassigned = 1 AND T .isbrickbased = 0
GO