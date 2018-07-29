

CREATE PROCEDURE [dbo].[CopyMarketBase] 
	@ClientNo_Source INT,
	@ClientNo_Destination INT
AS
BEGIN

	--DECLARE @ClientNo INT = 82
	DECLARE @ClientID_dbo INT, @ClientID_copy INT, @is_error bit = 0
	--@ClientName VARCHAR(100), 

	--SELECT @ClientName=ClientName FROM IRP.Client WHERE ClientNo = @ClientNo

	--Print @ClientName

	--IF @ClientName IS NULL OR @ClientName = ''
	--BEGIN
	--	PRINT 'Client number does not exist in IRP.Client table.'
	--	set @is_error = 1
	--END

	--SELECT @ClientID_dbo=Id FROM dbo.Clients WHERE Name = @ClientName
	--SELECT @ClientID_copy=Id FROM copy.Clients WHERE Name = @ClientName

	SELECT @ClientID_dbo=ClientId FROM [IRP].[ClientMap] WHERE IRPClientNo = @ClientNo_Destination
	SELECT @ClientID_copy=ClientId FROM [copy].[ClientMap] WHERE IRPClientNo = @ClientNo_Source

	print 'Dbo_ClientId ' + Convert(varchar(5),@ClientID_dbo)
	print 'Copy_ClientId ' + Convert(varchar(5),@ClientID_copy)

	IF @ClientID_dbo IS NULL OR @ClientID_copy IS NULL
	BEGIN
		PRINT 'Client id does not exist in either IRP.ClientMap or copy.ClientMap table.'
		set @is_error = 1
	END

	if @is_error = 0 
	begin
		DECLARE @Id INT, @MarketBaseId INT
		Declare @min_id Char(11)
		select @min_id = min(Id) from copy.ClientMarketBases where ClientId = @ClientID_copy

		print 'min_id ' + @min_id

	while @min_id is not null
	begin
		select @Id=Id, @MarketBaseId=MarketBaseId from copy.ClientMarketBases where Id = @min_id
		print convert(varchar(5), @Id) + ' ' + convert(varchar(5), @ClientID_dbo) + ' ' + convert(varchar(5), @MarketBaseId)

		select @min_id = min(Id) from copy.ClientMarketBases where ClientId = @ClientID_copy and Id > @min_id
		print 'min_id ' + @min_id
		SET IDENTITY_INSERT [dbo].[ClientMarketBases] ON 
		--GO
		INSERT INTO dbo.ClientMarketBases(Id, ClientId, MarketBaseId) VALUES (@Id, @ClientID_dbo, @MarketBaseId)
		SET IDENTITY_INSERT [dbo].[ClientMarketBases] OFF 
		--GO
	end 
	
		-- ********** Subscription Market ****************************
	
		declare @min_subscription_id char(11), @min_subscription_market_id char(11), @subscription_id char(11), @market_base_id char(11)
		declare @subscription_name nvarchar(max)
		declare @subscription_market_id char(11)

		select @min_subscription_id = min(SubscriptionId) from dbo.Subscription where ClientId = @ClientID_dbo
		print '@min_subscription_id ' + convert(varchar(11), @min_subscription_id)
	
	while @min_subscription_id is not null
	begin
		select @subscription_name = Name from dbo.Subscription where SubscriptionId = @min_subscription_id

		select @subscription_id = SubscriptionId from copy.Subscription where ClientId = @ClientID_copy and Name = @subscription_name
		select @min_subscription_market_id = min(SubscriptionMarketId) from copy.SubscriptionMarket where SubscriptionId = @subscription_id

		print '@min_subscription_market_id ' + convert(varchar(10), @min_subscription_market_id)
		-----
		while @min_subscription_market_id is not null
		begin
			select @subscription_market_id = SubscriptionMarketId,@market_base_id = MarketBaseId  from copy.SubscriptionMarket where SubscriptionMarketId = @min_subscription_market_id
			print '@subscription_market_id -->' + convert(varchar(11), @subscription_market_id)
			
			SET IDENTITY_INSERT [dbo].[SubscriptionMarket] ON 
			INSERT [dbo].[SubscriptionMarket] ([SubscriptionMarketId], [SubscriptionId], [MarketBaseId]) VALUES (@subscription_market_id, @min_subscription_id, @market_base_id)
			SET IDENTITY_INSERT [dbo].[SubscriptionMarket] OFF 
		
			select @min_subscription_market_id = min(SubscriptionMarketId) from copy.SubscriptionMarket where SubscriptionId =@subscription_id and   SubscriptionMarketId > @min_subscription_market_id
		end
		select @min_subscription_id = min(SubscriptionId) from dbo.Subscription where ClientId = @ClientID_dbo  and SubscriptionId > @min_subscription_id
		print '2. @min_subscription_id ' + convert(varchar(11), @min_subscription_id)
	end
	end

END


