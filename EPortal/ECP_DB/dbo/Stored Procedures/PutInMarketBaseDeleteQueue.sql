CREATE PROCEDURE [dbo].[PutInMarketBaseDeleteQueue]
	@MarketBaseId int,
	@CompleteDeleteFlag int,
	@subscriptionId int = 0
as
begin
	declare @mdCount int
	declare @mbCount int
	declare @marketbaseName nvarchar(120);
	
	select @mdCount = count(id) from marketdefinitionbasemaps where marketbaseid = @MarketBaseId
	
	if @mdCount = 0
	begin
		Select @marketbaseName=Name+' '+Suffix from Marketbases Where Id=@MarketBaseId
		if @CompleteDeleteFlag = 1
		begin
			delete from ClientMarketBases where MarketBaseId = @MarketBaseId
			delete from subscriptionmarket where MarketBaseId = @MarketBaseId
			delete from MarketBases where id = @MarketBaseId
		end
		select 'Market base <b>'+@marketbaseName+'</b> has been successfully deleted' as Result
	end
	else
	begin
		select @mbCount = count(*) from MarketBaseDeleteQueue where marketbaseid = @MarketBaseId and CompleteDeleteFlag = @CompleteDeleteFlag and subscriptionId = @subscriptionId
		if @mbCount = 0 
		begin
			insert into MarketBaseDeleteQueue values (@MarketBaseId, @CompleteDeleteFlag, @subscriptionId)
		end
		select 'Market base settings saved. <br/><div >Note: This will not take effect in existing market definitions until the overnight refresh process has run</div>' as Result
	end

end

--alter table MarketBaseDeleteQueue add SubscriptionId int