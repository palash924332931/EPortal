
CREATE PROCEDURE [dbo].[PutInMarketBaseQueue]
	@MarketBaseId int,
	@UserId int
as
begin
	declare @mdCount int
	declare @mbCount int
	
	select @mdCount = count(id) from marketdefinitionbasemaps where marketbaseid = @MarketBaseId
	
	if @mdCount = 0
	begin
		select 'Market base has been successfully updated.' as Result
	end
	else
	begin
		select @mbCount = count(*) from MarketBaseQueue where marketbaseid = @MarketBaseId
		if @mbCount = 0 
		begin
			insert into MarketBaseQueue values (@MarketBaseId,@UserId)
			update A set A.name = b.name + ' ' + b.Suffix from marketdefinitionbasemaps A join marketbases B on A.marketbaseid = B.id
			where b.id = @MarketBaseId
			
		end
		select 'Market Base settings saved. <br/><div >Note: This will not take effect in existing market definitions until the overnight refresh process has run</div>' as Result
	end

end
