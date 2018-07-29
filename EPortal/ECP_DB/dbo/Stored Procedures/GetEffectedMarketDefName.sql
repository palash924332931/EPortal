CREATE PROCEDURE [dbo].[GetEffectedMarketDefName] 
	-- Add the parameters for the stored procedure here
	@MarketBaseId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT 
      distinct MD.[Name]
  FROM [dbo].[MarketDefinitionBaseMaps] MBP
  join [dbo].[MarketDefinitions] MD
  on MBP.MarketDefinitionId = MD.Id
  WHERE MBP.MarketBaseId = @MarketBaseId

 
	
END






