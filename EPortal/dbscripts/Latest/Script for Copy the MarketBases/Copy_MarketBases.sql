/***** Create copy schema **********/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'copy') 
BEGIN
	Exec ('create schema copy')
END
/****** Clients **********/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'copy' AND TABLE_NAME = 'Clients')
BEGIN

CREATE TABLE [copy].[Clients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[IsMyClient] [bit] NOT NULL,
	[DivisionOf] [int] NULL,
	[IRPClientId] [int] NULL,
	[IRPClientNo] [int] NULL,
 CONSTRAINT [PK_copy.Clients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

END
/***** ClientMap ********/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'copy' AND TABLE_NAME = 'ClientMap')
BEGIN
CREATE TABLE [copy].[ClientMap](
	[ClientId] [int] NULL,
	[IRPClientId] [smallint] NULL,
	[IRPClientNo] [smallint] NULL
) ON [PRIMARY]
END
/***** MarketBases *********/

--IF NOT EXISTS (SELECT * 
--                 FROM INFORMATION_SCHEMA.TABLES 
--                 WHERE TABLE_SCHEMA = 'copy' 
--                 AND  TABLE_NAME = 'MarketBases')
--BEGIN

--CREATE TABLE [copy].[MarketBases](
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[Name] [nvarchar](max) NULL,
--	[Description] [nvarchar](max) NULL,
--	[Suffix] [nvarchar](max) NULL,
--	[DurationTo] [nvarchar](max) NULL,
--	[DurationFrom] [nvarchar](max) NULL,
--	[GuiId] [nvarchar](max) NULL,
--	[BaseType] [nvarchar](max) NULL,
-- CONSTRAINT [PK_copy.MarketBases] PRIMARY KEY CLUSTERED 
--(
--	[Id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--END

/******BaseFilters ***********/
--IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'copy' AND TABLE_NAME = 'BaseFilters' )
--BEGIN

--CREATE TABLE [copy].[BaseFilters](
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[Name] [nvarchar](max) NULL,
--	[Criteria] [nvarchar](max) NULL,
--	[Values] [nvarchar](max) NULL,
--	[IsEnabled] [bit] NOT NULL,
--	[MarketBaseId] [int] NOT NULL,
--	[IsRestricted] [bit] NULL,
--	[IsBaseFilterType] [bit] NULL,
-- CONSTRAINT [PK_BaseFilters] PRIMARY KEY CLUSTERED 
--(
--	[Id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--END

/**********Subscription *******************/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'copy' AND TABLE_NAME = 'Subscription')
BEGIN

CREATE TABLE [copy].[Subscription](
	[SubscriptionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[Country] [nvarchar](max) NULL,
	[Service] [nvarchar](max) NULL,
	[Data] [nvarchar](max) NULL,
	[Source] [nvarchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ServiceTerritoryId] [int] NULL,
	[Active] [bit] NULL,
	[LastModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[CountryId] [int] NULL,
	[ServiceId] [int] NULL,
	[DataTypeId] [int] NULL,
	[SourceId] [int] NULL,
 CONSTRAINT [PK__Subscrip__9A2B249DACFF9B1C] PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


ALTER TABLE [copy].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Clien__662B2B3B] FOREIGN KEY([ClientId])
REFERENCES [copy].[Clients] ([Id])

ALTER TABLE [copy].[Subscription] CHECK CONSTRAINT [FK__Subscript__Clien__662B2B3B]

ALTER TABLE [copy].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Count__671F4F74] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])

ALTER TABLE [copy].[Subscription] CHECK CONSTRAINT [FK__Subscript__Count__671F4F74]

ALTER TABLE [copy].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__DataT__681373AD] FOREIGN KEY([DataTypeId])
REFERENCES [dbo].[DataType] ([DataTypeId])

ALTER TABLE [copy].[Subscription] CHECK CONSTRAINT [FK__Subscript__DataT__681373AD]

ALTER TABLE [copy].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Servi__690797E6] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[Service] ([ServiceId])

ALTER TABLE [copy].[Subscription] CHECK CONSTRAINT [FK__Subscript__Servi__690797E6]

ALTER TABLE [copy].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Servi__69FBBC1F] FOREIGN KEY([ServiceTerritoryId])
REFERENCES [dbo].[ServiceTerritory] ([ServiceTerritoryId])

ALTER TABLE [copy].[Subscription] CHECK CONSTRAINT [FK__Subscript__Servi__69FBBC1F]

ALTER TABLE [copy].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Sourc__6AEFE058] FOREIGN KEY([SourceId])
REFERENCES [dbo].[Source] ([SourceId])

ALTER TABLE [copy].[Subscription] CHECK CONSTRAINT [FK__Subscript__Sourc__6AEFE058]

END

/******** Subscription Market**************/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'copy' AND TABLE_NAME = 'SubscriptionMarket')
BEGIN

CREATE TABLE [copy].[SubscriptionMarket](
	[SubscriptionMarketId] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionId] [int] NULL,
	[MarketBaseId] [int] NULL,
 CONSTRAINT [PK__Subscrip__9585FB84031A6821] PRIMARY KEY CLUSTERED 
(
	[SubscriptionMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]



ALTER TABLE [copy].[SubscriptionMarket]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Marke__6BE40491] FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])


ALTER TABLE [copy].[SubscriptionMarket] CHECK CONSTRAINT [FK__Subscript__Marke__6BE40491]


ALTER TABLE [copy].[SubscriptionMarket]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Subsc__6CD828CA] FOREIGN KEY([SubscriptionId])
REFERENCES [copy].[Subscription] ([SubscriptionId])


ALTER TABLE [copy].[SubscriptionMarket] CHECK CONSTRAINT [FK__Subscript__Subsc__6CD828CA]

END

/********** ClientMarketBases **********************/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'copy' AND TABLE_NAME = 'ClientMarketBases')
BEGIN

CREATE TABLE [copy].[ClientMarketBases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[MarketBaseId] [int] NOT NULL,
 CONSTRAINT [PK_copy.ClientMarketBases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

END

/****** StoredProcedure [dbo].[CopyMarketBase] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.CopyMarketBase'))
	DROP PROCEDURE [dbo].[CopyMarketBase]
GO

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





