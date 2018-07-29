

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UnsubscribeMarketBase] 
	-- Add the parameters for the stored procedure here
	@MarketBaseId int,
	@SubscriptionId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--select name + ' ' + suffix from marketbases where id = 3213
	declare @kount int
	declare @marketbasename varchar(500)
	select @marketbasename  = name + ' ' + suffix from marketbases where id = @MarketBaseId

	DELETE FROM [dbo].[SubscriptionMarket] 
	WHERE MarketBaseId = @MarketBaseId and subscriptionid = @SubscriptionId

	delete from deliverymarket where marketdefid in (
		select distinct dm.marketdefid from deliverables d 
		join deliverymarket dm on d.deliverableid = dm.deliverableid
		join (select marketdefinitionid from marketdefinitionbasemaps where marketbaseid = @MarketBaseId) c on c.marketdefinitionid = dm.marketdefid
		where d.subscriptionid = @SubscriptionId 
	)

	select @kount = count(*) from subscriptionmarket where MarketBaseId = @MarketBaseId
	if @kount = 0
	begin
		exec [dbo].[PutInMarketBaseDeleteQueue] @MarketBaseId, 0, @SubscriptionId
		select 'Market Base settings saved. <br/><div >Note: This will not take effect in existing market definitions until the overnight refresh process has run.</div>' as Result
	end
	else 
	Select '';	

END

--select * from everestportaldb.dbo.deliverymarket









