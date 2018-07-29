CREATE procedure [dbo].[GetMarketGroupPacks]
	@pMarketDefinitionId int
as
begin
	select a.id, a.GroupId,a.PFC,
	Pack_Description AS Pack , Org_Long_Name AS Manufacturer, 
	ATC1_Code AS ATC1, ATC2_Code AS ATC2, ATC3_Code AS ATC3, ATC4_Code AS ATC4, 
	NEC1_Code AS NEC1, NEC2_Code AS NEC2, NEC3_Code AS NEC3, NEC4_Code AS NEC4,  
	ProductName AS Product, [Frm_Flgs3_Desc] AS Branding, [FRM_Flgs5_Desc] AS Flagging, 
	dm.[Description] AS Molecule, a.MarketDefinitionId
	from [dbo].marketgrouppacks a
	join dimproduct_expanded b on a.PFC = b.PFC 
	join dmmoleculeconcat dm on dm.FCC = b.FCC
	where a.marketdefinitionid = @pMarketDefinitionId
end