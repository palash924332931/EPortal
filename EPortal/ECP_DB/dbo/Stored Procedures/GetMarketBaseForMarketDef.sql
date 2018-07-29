Create PROCEDURE [dbo].[GetMarketBaseForMarketDef] 
	-- Add the parameters for the stored procedure here
	@ClientId int,
	@MarketDefId int  
AS
BEGIN	
	SELECT distinct CMB.[MarketBaseId] as Id
		  ,CMB.[ClientId]
		  ,C.Name ClientName
		  ,CMB.[MarketBaseId]
		  ,MB.Name +' '+MB.Suffix MarketBaseName
	  FROM [ClientMarketBases] CMB
	  JOIN [Clients] C
	  ON CMB.[ClientId] =C.Id
	  JOIN [MarketBases] MB
	  ON CMB.[MarketBaseId] = MB.Id
	  WHERE CMB.[ClientId]=2 AND CMB.MarketBaseId=518-- in (Select MarketBaseId From MarketDefWithMarketBase Where MarketDefId=457);
End




