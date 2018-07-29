

create PROCEDURE [dbo].[z_ECP_AddExtendedTables] 

AS
BEGIN

CREATE TABLE [dbo].[Territories_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TerritoryId] [int] NOT NULL,
	[Client_No] [int] NULL,
	
 CONSTRAINT [PK_dbo.Territories_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[Subscription_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionId] [int] NOT NULL,
	[Client_No] [int] NULL,
	
 CONSTRAINT [PK_dbo.Subscription_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[MarketDefinitions_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketDefinitionId] [int] NOT NULL,
	[Client_No] [int] NULL,
	
 CONSTRAINT [PK_dbo.MarketDefinitions_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[DeliveryClient_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryClientId] [int] NOT NULL,
	[Client_No] [int] NULL,
	
 CONSTRAINT [PK_dbo.DeliveryClient_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[ClientMarketBases_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientMarketBaseId] [int] NOT NULL,
	[Client_No] [int] NULL,
	
 CONSTRAINT [PK_dbo.ClientMarketBases_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[ClientRelease_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientReleaseId] [int] NOT NULL,
	[Client_No] [int] NULL,
	
 CONSTRAINT [PK_dbo.ClientRelease_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


END




