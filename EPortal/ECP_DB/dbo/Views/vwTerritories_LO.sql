CREATE VIEW [dbo].[vwTerritories_LO]
AS
SELECT TOP (100) PERCENT i.IRPClientNo AS 'Client number', c.Name AS 'Client name', t.DimensionID AS 'Territory number', t.Name AS 'Territory name', 
                  t.SRA_Client AS 'SRA client number', t.SRA_Suffix AS 'SRA suffix', REPLACE(COALESCE (o1.NodeCode, o2.NodeCode, o3.NodeCode, o4.NodeCode, o5.NodeCode, 
                  o6.NodeCode), ' ', '') AS TerritoryGroup, COALESCE (o1.BrickOutletCode, o2.BrickOutletCode, o3.BrickOutletCode, o4.BrickOutletCode, o5.BrickOutletCode, 
                  o6.BrickOutletCode) AS Brick, l1.LevelNumber AS 'Level1Number', l1.Name AS 'Level1Name', g1.GroupNumber AS 'Group1Number', g1.Name AS 'Group1Name', 
                  l2.LevelNumber AS 'Level2Number', l2.Name AS 'Level2Name', g2.GroupNumber AS 'Group2Number', g2.Name AS 'Group2Name', l3.LevelNumber AS 'Level3Number', 
                  l3.Name AS 'Level3Name', g3.GroupNumber AS 'Group3Number', g3.Name AS 'Group3Name', l4.LevelNumber AS 'Level4Number', l4.Name AS 'Level4Name', 
                  g4.GroupNumber AS 'Group4Number', g4.Name AS 'Group4Name', l5.LevelNumber AS 'Level5Number', l5.Name AS 'Level5Name', g5.GroupNumber AS 'Group5Number', 
                  g5.Name AS 'Group5Name', l6.LevelNumber AS 'Level6Number', l6.Name AS 'Level6Name', g6.GroupNumber AS 'Group6Number', g6.Name AS 'Group6Name'
FROM     IRP.ClientMap AS i INNER JOIN
                  dbo.Clients AS c ON c.Id = i.ClientId INNER JOIN
                  dbo.Territories AS t ON t.Client_id = c.Id INNER JOIN
                  dbo.Groups AS g1 ON g1.TerritoryId = t.Id AND g1.LevelNo = 1 LEFT OUTER JOIN
                  dbo.Groups AS g2 ON g2.TerritoryId = t.Id AND g2.LevelNo = 2 AND g2.ParentId = g1.Id LEFT OUTER JOIN
                  dbo.Groups AS g3 ON g3.TerritoryId = t.Id AND g3.LevelNo = 3 AND g3.ParentId = g2.Id LEFT OUTER JOIN
                  dbo.Groups AS g4 ON g4.TerritoryId = t.Id AND g4.LevelNo = 4 AND g4.ParentId = g3.Id LEFT OUTER JOIN
                  dbo.Groups AS g5 ON g5.TerritoryId = t.Id AND g5.LevelNo = 5 AND g5.ParentId = g4.Id LEFT OUTER JOIN
                  dbo.Groups AS g6 ON g6.TerritoryId = t.Id AND g6.LevelNo = 6 AND g6.ParentId = g5.Id LEFT OUTER JOIN
                  dbo.Levels AS l1 ON t.Id = l1.TerritoryId AND l1.LevelNumber = 1 LEFT OUTER JOIN
                  dbo.Levels AS l2 ON t.Id = l2.TerritoryId AND l2.LevelNumber = 2 LEFT OUTER JOIN
                  dbo.Levels AS l3 ON t.Id = l3.TerritoryId AND l3.LevelNumber = 3 LEFT OUTER JOIN
                  dbo.Levels AS l4 ON t.Id = l4.TerritoryId AND l4.LevelNumber = 4 LEFT OUTER JOIN
                  dbo.Levels AS l5 ON t.Id = l5.TerritoryId AND l5.LevelNumber = 5 LEFT OUTER JOIN
                  dbo.Levels AS l6 ON t.Id = l6.TerritoryId AND l6.LevelNumber = 6 LEFT OUTER JOIN
                  dbo.OutletBrickAllocations AS o1 ON g1.CustomGroupNumberSpace = o1.NodeCode AND o1.TerritoryId = g1.TerritoryId AND g1.LevelNo = 1 LEFT OUTER JOIN
                  dbo.OutletBrickAllocations AS o2 ON g2.CustomGroupNumberSpace = o2.NodeCode AND o2.TerritoryId = g2.TerritoryId AND g2.LevelNo = 2 LEFT OUTER JOIN
                  dbo.OutletBrickAllocations AS o3 ON g3.CustomGroupNumberSpace = o3.NodeCode AND o3.TerritoryId = g3.TerritoryId AND g3.LevelNo = 3 LEFT OUTER JOIN
                  dbo.OutletBrickAllocations AS o4 ON g4.CustomGroupNumberSpace = o4.NodeCode AND o4.TerritoryId = g4.TerritoryId AND g4.LevelNo = 4 LEFT OUTER JOIN
                  dbo.OutletBrickAllocations AS o5 ON g5.CustomGroupNumberSpace = o5.NodeCode AND o5.TerritoryId = g5.TerritoryId AND g5.LevelNo = 5 LEFT OUTER JOIN
                  dbo.OutletBrickAllocations AS o6 ON g6.CustomGroupNumberSpace = o6.NodeCode AND o6.TerritoryId = g6.TerritoryId AND g6.LevelNo = 6
ORDER BY t.Id