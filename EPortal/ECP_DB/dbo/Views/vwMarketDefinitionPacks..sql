CREATE VIEW [dbo].[vwMarketDefinitionPacks]
AS
SELECT b.ATC1_Code AS ATC1, b.ATC2_Code AS ATC2, b.ATC3_Code AS ATC3, b.NEC1_Code AS NEC1, b.NEC2_Code AS NEC2, b.NEC3_Code AS NEC3, 
                  b.FRM_Flgs5_Desc AS Flagging, b.Frm_Flgs3_Desc AS Branding, b.Poison_Schedule AS PoisonSchedule, b.Form_Desc_Abbr AS Form, a.Id, a.Pack, a.MarketBase, 
                  a.MarketBaseId, a.GroupNumber, a.GroupName, a.Factor, a.PFC, a.Manufacturer, a.ATC4, a.NEC4, a.DataRefreshType, a.StateStatus, a.MarketDefinitionId, a.Alignment, 
                  a.Product, a.ChangeFlag, a.Molecule
FROM     dbo.MarketDefinitionPacks AS a INNER JOIN
                  dbo.DIMProduct_Expanded AS b ON a.PFC = b.PFC

GO