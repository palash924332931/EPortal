CREATE VIEW dbo.vw_Territory
AS
SELECT Id AS TerritoryId, Name, RootGroup_id, RootLevel_Id, Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, DimensionID, LastSaved, IsReferenced, 
                  team_code
FROM     dbo.Territories
GO