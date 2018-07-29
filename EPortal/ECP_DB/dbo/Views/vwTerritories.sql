
CREATE View [dbo].[vwTerritories]
AS
 SELECT Id, CASE WHEN SRA_Client is not null then Name+' ('+SRA_Client +'' + SRA_Suffix+')' ELSE Name END as Name, RootGroup_id, RootLevel_Id, Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD,CASE WHEN DimensionID is null then 0 ELSE DimensionID END as DimensionID,LastSaved, IsReferenced
FROM Territories