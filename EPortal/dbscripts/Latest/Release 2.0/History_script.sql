ALTER TABLE [dbo].[MarketBases]
ADD LastSaved datetime;


ALTER TABLE [dbo].[MarketDefinitions]
ADD LastSaved datetime;


ALTER TABLE [dbo].[Territories]
ADD LastSaved datetime;

ALTER View [dbo].[vwTerritories]
AS
 SELECT Id, CASE WHEN SRA_Client is not null then Name+' ('+SRA_Client +'' + SRA_Suffix+')' ELSE Name END as Name, RootGroup_id, RootLevel_Id, Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD,CASE WHEN DimensionID is null then 0 ELSE DimensionID END as DimensionID,LastSaved
FROM Territories

GO
/****** Object:  Table [dbo].[AdditionalFilter_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdditionalFilter_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketDefBaseMap_HistoryId] [int] NOT NULL,
	[MarketDefVersion] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Criteria] [nvarchar](max) NULL,
	[Values] [nvarchar](max) NULL,
	[IsEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_AdditionalFilter_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BaseFilter_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseFilter_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Criteria] [nvarchar](max) NULL,
	[Values] [nvarchar](max) NULL,
	[IsEnabled] [bit] NOT NULL,
	[MarketBaseMBId] [int] NOT NULL,
	[MarketBaseVersion] [int] NOT NULL,
	[IsRestricted] [bit] NULL,
	[IsBaseFilterType] [bit] NULL,
 CONSTRAINT [PK_BaseFilter_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Deliverables_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Deliverables_History](
	[DeliverableId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[SubscriptionId] [int] NULL,
	[ReportWriterId] [int] NULL,
	[FrequencyTypeId] [int] NULL,
	[RestrictionId] [int] NULL,
	[PeriodId] [int] NULL,
	[Frequencyid] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[probe] [bit] NULL,
	[PackException] [bit] NULL,
	[Census] [bit] NULL,
	[OneKey] [bit] NULL,
	[LastModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[DeliveryTypeId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[UserId] [int] NULL,
	[IsSentToTDW] [bit] NULL CONSTRAINT [DC_Constraint]  DEFAULT ((0)),
	[TDWTransferDate] [datetime] NULL,
	[TDWUserId] [int] NULL,
	[LastSaved] [datetime2](7) NULL,
 CONSTRAINT [PK_Deliverables_History] PRIMARY KEY CLUSTERED 
(
	[DeliverableId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryClient_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryClient_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryClientId] [int] NOT NULL,
	[DeliverableId] [int] NULL,
	[DeliverableVersion] [int] NULL,
	[ClientId] [int] NULL,
 CONSTRAINT [PK_DeliveryClient_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryMarket_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryMarket_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryMarketId] [int] NOT NULL,
	[DeliverableId] [int] NULL,
	[DeliverableVersion] [int] NULL,
	[MarketDefId] [int] NULL,
	[MarketDefVersion] [int] NULL,
 CONSTRAINT [PK_DeliveryMarket_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryTerritory_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryTerritory_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryTerritoryId] [int] NOT NULL,
	[DeliverableId] [int] NULL,
	[DeliverableVersion] [int] NULL,
	[TerritoryId] [int] NULL,
	[TerritoryVersion] [int] NULL,
 CONSTRAINT [PK_DeliveryTerritory_History_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryThirdParty_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryThirdParty_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryThirdPartyId] [int] NOT NULL,
	[DeliverableId] [int] NOT NULL,
	[DeliverableVersion] [int] NULL,
	[ThirdPartyId] [int] NOT NULL,
 CONSTRAINT [PK__DeliveryThirdParty_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Groups_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[GroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumber] [nvarchar](max) NULL,
	[IsOrphan] [bit] NOT NULL,
	[PaddingLeft] [int] NOT NULL,
	[ParentGroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumberSpace] [nvarchar](max) NULL,
	[TerritoryId] [int] NOT NULL,
	[TerritoryVersion] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[NewCGN] [nvarchar](50) NULL,
	[LevelNo] [int] NULL,
	[IRPItemID] [int] NULL,
 CONSTRAINT [PK_Groups_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Levels_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Levels_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[LevelNumber] [int] NOT NULL,
	[LevelIDLength] [int] NOT NULL,
	[LevelColor] [nvarchar](max) NULL,
	[BackgroundColor] [nvarchar](max) NULL,
	[LevelId] [int] NOT NULL,
	[TerritoryId] [int] NOT NULL,
	[TerritoryVersion] [int] NOT NULL,
	[IRPLevelID] [int] NULL,
 CONSTRAINT [PK_Levels_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketBase_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketBase_History](
	[MBId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Suffix] [nvarchar](max) NULL,
	[DurationTo] [nvarchar](max) NULL,
	[DurationFrom] [nvarchar](max) NULL,
	[GuiId] [nvarchar](max) NULL,
	[BaseType] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[UserId] [int] NULL,
	[IsSentToTDW] [bit] NULL CONSTRAINT [MB_Constraint]  DEFAULT ((0)),
	[TDWTransferDate] [datetime] NULL,
	[TDWUserId] [int] NULL,
	[LastSaved] [datetime] NULL,
 CONSTRAINT [PK_MarketBase_History] PRIMARY KEY CLUSTERED 
(
	[MBId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefBaseMap_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefBaseMap_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketDefId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[MarketBaseId] [int] NOT NULL,
	[MarketBaseVersion] [int] NOT NULL,
	[DataRefreshType] [nvarchar](max) NULL,
 CONSTRAINT [PK_MarketDefBaseMap_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitions_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitions_History](
	[MarketDefId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NOT NULL,
	[GuiId] [nvarchar](max) NULL,
	[DimensionId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[UserId] [int] NULL,
	[IsSentToTDW] [bit] NULL,
	[TDWTransferDate] [datetime] NULL,
	[TDWUserId] [int] NULL,
	[LastSaved] [datetime] NULL,
 CONSTRAINT [PK_MarketDefinitions_History] PRIMARY KEY CLUSTERED 
(
	[MarketDefId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefPack_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefPack_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketDefinitionId] [int] NOT NULL,
	[MarketDefVersion] [int] NOT NULL,
	[Pack] [nvarchar](max) NULL,
	[MarketBase] [nvarchar](max) NULL,
	[MarketBaseId] [nvarchar](max) NULL,
	[GroupNumber] [nvarchar](max) NULL,
	[GroupName] [nvarchar](max) NULL,
	[Factor] [nvarchar](max) NULL,
	[PFC] [nvarchar](max) NULL,
	[Manufacturer] [nvarchar](max) NULL,
	[ATC4] [nvarchar](max) NULL,
	[NEC4] [nvarchar](max) NULL,
	[DataRefreshType] [nvarchar](max) NULL,
	[StateStatus] [nvarchar](max) NULL,
	[Alignment] [nvarchar](max) NULL,
	[Product] [nvarchar](max) NULL,
	[ChangeFlag] [nchar](1) NULL,
	[Molecule] [nvarchar](max) NULL,
 CONSTRAINT [PK_MarketDefPack_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OutletBrickAllocations_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutletBrickAllocations_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NodeCode] [nvarchar](50) NULL,
	[NodeName] [nvarchar](300) NULL,
	[Address] [nvarchar](500) NULL,
	[BrickOutletCode] [nvarchar](50) NULL,
	[BrickOutletName] [nvarchar](500) NULL,
	[LevelName] [nvarchar](500) NULL,
	[CustomGroupNumberSpace] [nvarchar](500) NULL,
	[Type] [nvarchar](50) NULL,
	[BannerGroup] [varchar](500) NULL,
	[State] [varchar](40) NULL,
	[Panel] [char](1) NULL,
	[BrickOutletLocation] [char](30) NULL,
	[TerritoryId] [int] NOT NULL,
	[TerritoryVersion] [int] NOT NULL,
 CONSTRAINT [PK_OutletBrickAllocations_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportFilters_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportFilters_History](
	[FilterID] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[FilterName] [varchar](100) NOT NULL,
	[FilterType] [varchar](20) NOT NULL,
	[FilterDescription] [varchar](200) NULL,
	[SelectedFields] [varchar](max) NULL,
	[ModuleID] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UserId] [int] NULL,
	[IsSentToTDW] [bit] NULL,
	[TDWTransferDate] [datetime] NULL,
	[TDWUserId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_ReportFilters_History] PRIMARY KEY CLUSTERED 
(
	[FilterID] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Subscription_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription_History](
	[SubscriptionId] [int] NOT NULL,
	[Version] [int] NOT NULL,
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
	[ModifiedDate] [datetime] NULL,
	[UserId] [int] NULL,
	[IsSentToTDW] [bit] NULL DEFAULT ((0)),
	[TDWTransferDate] [datetime] NULL,
	[TDWUserId] [int] NULL,
	[LastSaved] [datetime] NULL,
 CONSTRAINT [PK__Subscription_History] PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubscriptionMarket_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubscriptionMarket_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionMarketId] [int] NOT NULL,
	[SubscriptionId] [int] NULL,
	[SubscriptionVersion] [int] NULL,
	[MarketBaseId] [int] NULL,
	[MarketBaseVersion] [int] NULL,
 CONSTRAINT [PK__SubscriptionMarket_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Territories_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Territories_History](
	[TerritoryId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[RootGroup_id] [int] NULL,
	[RootLevel_Id] [int] NULL,
	[Client_id] [int] NULL,
	[IsBrickBased] [bit] NULL,
	[IsUsed] [bit] NULL,
	[GuiId] [nvarchar](max) NULL,
	[SRA_Client] [nvarchar](100) NULL,
	[SRA_Suffix] [nvarchar](100) NULL,
	[AD] [nvarchar](100) NULL,
	[LD] [nvarchar](100) NULL,
	[DimensionID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[UserId] [int] NULL,
	[IsSentToTDW] [bit] NULL DEFAULT ((0)),
	[TDWTransferDate] [datetime] NULL,
	[TDWUserId] [int] NULL,
	[LastSaved] [datetime] NULL,
 CONSTRAINT [PK_Territories_History] PRIMARY KEY CLUSTERED 
(
	[TerritoryId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User_History](
	[UserID] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[UserName] [varchar](300) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[email] [varchar](300) NULL,
	[UserTypeID] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[ReceiveEmail] [bit] NULL,
	[PwdEncrypted] [int] NULL,
	[MaintenancePeriodEmail] [bit] NULL DEFAULT ((0)),
	[NewsAlertEmail] [bit] NULL DEFAULT ((0)),
	[ModifiedDate] [datetime] NULL,
	[ModifiedUserId] [int] NULL,
	[IsSentToTDW] [bit] NULL DEFAULT ((0)),
	[TDWTransferDate] [datetime] NULL,
	[TDWUserId] [int] NULL,
 CONSTRAINT [PK__User_History] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserClient_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClient_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[UserVersion] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
 CONSTRAINT [PK_UserClient_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRole_History]    Script Date: 24/01/2018 4:53:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[UserVersion] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_UserRole_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ReportFilters_History] ADD  CONSTRAINT [RF_Constraint]  DEFAULT ((0)) FOR [IsSentToTDW]
GO
ALTER TABLE [dbo].[MarketDefBaseMap_History]  WITH CHECK ADD  CONSTRAINT [FK_MarketDefBaseMap_History_MarketDefinitions_History] FOREIGN KEY([MarketDefId], [Version])
REFERENCES [dbo].[MarketDefinitions_History] ([MarketDefId], [Version])
GO
ALTER TABLE [dbo].[MarketDefBaseMap_History] CHECK CONSTRAINT [FK_MarketDefBaseMap_History_MarketDefinitions_History]
GO
ALTER TABLE [dbo].[MarketDefPack_History]  WITH CHECK ADD  CONSTRAINT [FK_MarketDefPack_History_MarketDefinitions_History] FOREIGN KEY([MarketDefinitionId], [MarketDefVersion])
REFERENCES [dbo].[MarketDefinitions_History] ([MarketDefId], [Version])
GO
ALTER TABLE [dbo].[MarketDefPack_History] CHECK CONSTRAINT [FK_MarketDefPack_History_MarketDefinitions_History]
GO
