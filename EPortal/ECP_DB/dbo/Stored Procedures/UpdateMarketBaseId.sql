

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMarketBaseId] 
	-- Add the parameters for the stored procedure here
	@OldMarketBaseId int ,
	@NewMarketBaseId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


UPDATE [dbo].[MarketDefinitionBaseMaps]
SET [MarketBaseId]= @NewMarketBaseId
WHERE [MarketBaseId]=@OldMarketBaseId

	---for MarketDefinitionPacks
	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] =  cast(@NewMarketBaseId as varchar)
	WHERE [MarketBaseId]=cast(@OldMarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@OldMarketBaseId as varchar), ','+cast(@NewMarketBaseId as varchar))
	WHERE [MarketBaseId] LIKE '%,'+cast(@OldMarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@OldMarketBaseId as varchar)+',', cast(@NewMarketBaseId as varchar)+',')
	WHERE [MarketBaseId] LIKE cast(@OldMarketBaseId as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@OldMarketBaseId as varchar)+',', ','+cast(@NewMarketBaseId as varchar)+',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@OldMarketBaseId as varchar)+',%'

  
UPDATE [dbo].[ClientMarketBases]
 SET [MarketBaseId]= @NewMarketBaseId
 WHERE [MarketBaseId]=@OldMarketBaseId
 
 ---for subscription Module
 UPDATE [dbo].[SubscriptionMarket]
 SET [MarketBaseId]= @NewMarketBaseId
 WHERE [MarketBaseId]=@OldMarketBaseId

END

--[dbo].[UpdateMarketBaseId] 10000, 20000 







