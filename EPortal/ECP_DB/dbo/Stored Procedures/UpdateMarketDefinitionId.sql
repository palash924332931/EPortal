CREATE PROCEDURE [dbo].[UpdateMarketDefinitionId] 
	-- Add the parameters for the stored procedure here
	@OldMarketDefId int ,
	@NewMarketDefId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


 
 ---for Delivery Module
	UPDATE [dbo].DeliveryMarket
	SET MarketDefId= @NewMarketDefId
	WHERE MarketDefId=@OldMarketDefId

 ---for MarketDefinitionBaseMap DataRefreshType changes
	exec [dbo].[UpdateDataRefreshType] @NewMarketDefId

END



