CREATE VIEW [dbo].[vwMarket_LO]
AS
SELECT TOP (100) PERCENT i.IRPClientNo AS [Client number], c.Name AS [Client name], m.DimensionId AS [Market number], m.Name AS [Market name], 
                  p.GroupNumber AS [Group number], p.GroupName AS [Group name], p.Factor, p.PFC
FROM     IRP.ClientMap AS i INNER JOIN
                  dbo.Clients AS c ON c.Id = i.ClientId INNER JOIN
                  dbo.MarketDefinitions AS m ON m.ClientId = c.Id INNER JOIN
                  dbo.MarketDefinitionPacks AS p ON m.Id = p.MarketDefinitionId AND p.Alignment = 'dynamic-right'
ORDER BY [Market number]
