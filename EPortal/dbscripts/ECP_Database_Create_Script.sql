

/****** Object:  Schema [IRP]    Script Date: 6/07/2017 5:59:13 PM ******/
CREATE SCHEMA [IRP]
GO
/****** Object:  Schema [SERVICE]    Script Date: 6/07/2017 5:59:13 PM ******/
CREATE SCHEMA [SERVICE]
GO
/****** Object:  Table [dbo].[AccessPrivilege]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessPrivilege](
	[AccessPrivilegeID] [int] IDENTITY(1,1) NOT NULL,
	[AccessPrivilegeName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[AccessPrivilegeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Action]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Action](
	[ActionID] [int] IDENTITY(1,1) NOT NULL,
	[ActionName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[ModuleID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AdditionalFilters]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdditionalFilters](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Criteria] [nvarchar](max) NULL,
	[Values] [nvarchar](max) NULL,
	[IsEnabled] [bit] NOT NULL,
	[MarketDefinitionBaseMapId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AdditionalFilters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aus_sales_report]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aus_sales_report](
	[pfc] [nvarchar](max) NULL,
	[groupNumber] [nvarchar](max) NULL,
	[GroupName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BaseFilters]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseFilters](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Criteria] [nvarchar](max) NULL,
	[Values] [nvarchar](max) NULL,
	[IsEnabled] [bit] NOT NULL,
	[MarketBaseId] [int] NOT NULL,
	[IsRestricted] [bit] NULL,
	[IsBaseFilterType] [bit] NULL,
 CONSTRAINT [PK_dbo.BaseFilters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Brick_XYCords]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Brick_XYCords](
	[ID] [int] NOT NULL,
	[Retail_Sbrick] [char](5) NULL,
	[postcode] [smallint] NULL,
	[suburb] [varchar](30) NULL,
	[NumberOutlets] [int] NULL,
	[max_XCord] [decimal](9, 6) NULL,
	[max_YCord] [decimal](9, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CADPages]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CADPages](
	[cadPageId] [int] IDENTITY(1,1) NOT NULL,
	[cadPageTitle] [nvarchar](max) NULL,
	[cadPageDescription] [nvarchar](max) NULL,
	[cadPagePharmacyFileUrl] [nvarchar](max) NULL,
	[cadPageHospitalFileUrl] [nvarchar](max) NULL,
	[cadPageCreatedOn] [datetime] NULL,
	[cadPageCreatedBy] [nvarchar](max) NULL,
	[cadPageModifiedOn] [datetime] NULL,
	[cadPageModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.CADPages] PRIMARY KEY CLUSTERED 
(
	[cadPageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientMarketBases]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientMarketBases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[MarketBaseId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ClientMarketBases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientMarketBases_Extended]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientMarketBases_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientMarketBaseId] [int] NOT NULL,
	[Client_No] [int] NULL,
 CONSTRAINT [PK_dbo.ClientMarketBases_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientMFR]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientMFR](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[MFRId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientNumberMap]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientNumberMap](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[ClientID] [int] NOT NULL,
	[ClientNo] [int] NULL,
 CONSTRAINT [PK_dbo.ClientNumberMap] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientPackException]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientPackException](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[PackExceptionId] [int] NULL,
	[ProductLevel] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientRelease]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientRelease](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[CapitalChemist] [bit] NULL,
	[Census] [bit] NULL,
	[Onekey] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientRelease_Extended]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientRelease_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientReleaseId] [int] NOT NULL,
	[Client_No] [int] NULL,
 CONSTRAINT [PK_dbo.ClientRelease_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Clients]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[IsMyClient] [bit] NOT NULL,
	[DivisionOf] [int] NULL,
 CONSTRAINT [PK_dbo.Clients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CONFIG_ECP_MKT_DEF_FILTERS]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONFIG_ECP_MKT_DEF_FILTERS](
	[FilterValue] [nvarchar](max) NULL,
	[ColumnName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ISOCode] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DataType]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataType](
	[DataTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[DataTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Deliverables]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Deliverables](
	[DeliverableId] [int] IDENTITY(1,1) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[DeliverableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryClient]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryClient](
	[DeliveryClientId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NULL,
	[ClientId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryClient_Extended]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryClient_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryClientId] [int] NOT NULL,
	[Client_No] [int] NULL,
 CONSTRAINT [PK_dbo.DeliveryClient_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryMarket]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryMarket](
	[DeliveryMarketId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NULL,
	[MarketDefId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryTerritory]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryTerritory](
	[DeliveryTerritoryId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NULL,
	[TerritoryId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryTerritoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryThirdParty]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryThirdParty](
	[DeliveryThirdPartyId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NOT NULL,
	[ThirdPartyId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryThirdPartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryType]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryType](
	[DeliveryTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIMOutlet]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DIMOutlet](
	[OutletID] [int] NOT NULL,
	[PostCode] [int] NULL,
	[Outlet] [smallint] NULL,
	[Outl_Brk] [varchar](8) NULL,
	[EID] [int] NULL,
	[AID] [tinyint] NULL,
	[Name] [varchar](80) NULL,
	[FullAddr] [varchar](400) NULL,
	[Addr1] [varchar](200) NULL,
	[Addr2] [varchar](100) NULL,
	[Suburb] [varchar](100) NULL,
	[Phone] [varchar](15) NULL,
	[XCord] [decimal](9, 6) NULL,
	[YCord] [decimal](9, 6) NULL,
	[Entity_Type] [char](30) NULL,
	[Display] [varchar](30) NULL,
	[BannerGroup_Desc] [varchar](500) NULL,
	[Retail_Sbrick] [char](30) NULL,
	[Retail_Sbrick_Desc] [varchar](80) NULL,
	[Sbrick] [char](30) NULL,
	[Sbrick_Desc] [varchar](80) NULL,
	[State_Code] [varchar](40) NULL,
	[Out_Type] [varchar](20) NULL,
	[Outlet_Type_Desc] [varchar](80) NULL,
	[Inactive_Date] [datetime2](7) NULL,
	[Active_Date] [datetime2](7) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DIMProduct_Expanded]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DIMProduct_Expanded](
	[PackID] [int] NOT NULL,
	[Prod_cd] [int] NULL,
	[Pack_cd] [smallint] NULL,
	[PFC] [varchar](15) NULL,
	[ProductName] [varchar](18) NULL,
	[Product_Long_Name] [varchar](80) NULL,
	[Pack_Description] [varchar](80) NULL,
	[Pack_Long_Name] [varchar](194) NULL,
	[FCC] [int] NULL,
	[ATC1_Code] [varchar](30) NULL,
	[ATC1_Desc] [nvarchar](50) NULL,
	[ATC2_Code] [varchar](30) NULL,
	[ATC2_Desc] [nvarchar](50) NULL,
	[ATC3_Code] [varchar](30) NULL,
	[ATC3_Desc] [nvarchar](50) NULL,
	[ATC4_Code] [varchar](30) NULL,
	[ATC4_Desc] [nvarchar](50) NULL,
	[NEC1_Code] [varchar](30) NULL,
	[NEC1_Desc] [varchar](50) NULL,
	[NEC1_LongDesc] [varchar](80) NULL,
	[NEC2_Code] [varchar](30) NULL,
	[NEC2_desc] [varchar](50) NULL,
	[NEC2_LongDesc] [varchar](80) NULL,
	[NEC3_Code] [varchar](30) NULL,
	[NEC3_Desc] [varchar](50) NULL,
	[NEC3_LongDesc] [varchar](80) NULL,
	[NEC4_Code] [varchar](30) NULL,
	[NEC4_Desc] [varchar](50) NULL,
	[NEC4_LongDesc] [varchar](80) NULL,
	[CH_Segment_Code] [varchar](3) NULL,
	[CH_Segment_Desc] [varchar](50) NULL,
	[WHO1_Code] [varchar](30) NULL,
	[WHO1_Desc] [varchar](50) NULL,
	[WHO2_Code] [varchar](30) NULL,
	[WHO2_Desc] [varchar](50) NULL,
	[WHO3_Code] [varchar](30) NULL,
	[WHO3_Desc] [varchar](50) NULL,
	[WHO4_Code] [varchar](30) NULL,
	[WHO4_Desc] [varchar](50) NULL,
	[WHO5_Code] [varchar](30) NULL,
	[WHO5_Desc] [varchar](50) NULL,
	[FRM_Flgs1] [char](30) NULL,
	[FRM_Flgs1_Desc] [varchar](50) NULL,
	[FRM_Flgs2] [char](30) NULL,
	[FRM_Flgs2_Desc] [varchar](50) NULL,
	[FRM_Flgs3] [char](30) NULL,
	[Frm_Flgs3_Desc] [varchar](50) NULL,
	[FRM_Flgs4] [char](30) NULL,
	[FRM_Flgs4_Desc] [varchar](50) NULL,
	[FRM_Flgs5] [char](30) NULL,
	[FRM_Flgs5_Desc] [varchar](50) NULL,
	[FRM_Flgs6] [char](30) NULL,
	[Compound_Indicator] [varchar](12) NULL,
	[Compound_Ind_Desc] [varchar](15) NULL,
	[PBS_Formulary] [varchar](30) NULL,
	[PBS_Formulary_Date] [datetime2](7) NULL,
	[Poison_Schedule] [varchar](30) NULL,
	[Poison_Schedule_Desc] [varchar](35) NULL,
	[Stdy_Ind1_Code] [char](1) NULL,
	[Study_Indicators1] [varchar](30) NULL,
	[Stdy_Ind2_Code] [char](1) NULL,
	[Study_Indicators2] [varchar](30) NULL,
	[Stdy_Ind3_Code] [char](1) NULL,
	[Study_Indicators3] [varchar](30) NULL,
	[Stdy_Ind4_Code] [char](1) NULL,
	[Study_Indicators4] [varchar](30) NULL,
	[Stdy_Ind5_Code] [char](1) NULL,
	[Study_Indicators5] [varchar](30) NULL,
	[Stdy_Ind6_Code] [char](1) NULL,
	[Study_Indicators6] [varchar](30) NULL,
	[PackLaunch] [datetime2](7) NULL,
	[Prod_lch] [datetime2](7) NULL,
	[Org_Code] [int] NULL,
	[Org_Abbr] [varchar](20) NULL,
	[Org_Short_Name] [varchar](50) NULL,
	[Org_Long_Name] [varchar](80) NULL,
	[Out_td_dt] [datetime2](7) NULL,
	[pk_size] [int] NULL,
	[vol_wt_uns] [real] NULL,
	[vol_wt_meas] [varchar](30) NULL,
	[strgh_uns] [real] NULL,
	[strgh_meas] [varchar](30) NULL,
	[Conc_Unit] [numeric](18, 2) NULL,
	[Conc_Meas] [varchar](5) NULL,
	[Additional_Strength] [varchar](4) NULL,
	[Additional_Pack_Info] [varchar](4) NULL,
	[Recommended_Retail_Price] [numeric](18, 2) NULL,
	[Ret_Price_Effective_Date] [datetime] NULL,
	[Editable_Pack_Description] [varchar](80) NULL,
	[APN] [varchar](18) NULL,
	[Trade_Product_Pack_ID] [varchar](18) NULL,
	[Form_Desc_Abbr] [varchar](30) NULL,
	[Form_Desc_Short] [varchar](50) NULL,
	[Form_Desc_Long] [varchar](80) NULL,
	[NFC1_Code] [nvarchar](30) NULL,
	[NFC1_Desc] [nvarchar](50) NULL,
	[NFC2_Code] [nvarchar](30) NULL,
	[NFC2_Desc] [nvarchar](50) NULL,
	[NFC3_Code] [nvarchar](30) NULL,
	[NFC3_Desc] [nvarchar](50) NULL,
	[Price_Effective_Date] [datetime] NULL,
	[Last_amd] [datetime2](7) NULL,
	[PBS_Start_Date] [datetime2](7) NULL,
	[PBS_End_Date] [datetime2](7) NULL,
	[Supplier_Code] [numeric](15, 0) NULL,
	[Supplier_Product_Code] [varchar](20) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DMMolecule]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DMMolecule](
	[FCC] [int] NULL,
	[MOLECULE] [varchar](30) NULL,
	[SYNONYM] [tinyint] NULL,
	[PARENT] [int] NULL,
	[DESCRIPTION] [varchar](80) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DMMoleculeConcat]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DMMoleculeConcat](
	[FCC] [int] NULL,
	[Description] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[File]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FileType]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileType](
	[FileTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[FileTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Frequency]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Frequency](
	[FrequencyId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[FrequencyTypeId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[FrequencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FrequencyType]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FrequencyType](
	[FrequencyTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[DefaultYears] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[FrequencyTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GoogleMapBricks]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GoogleMapBricks](
	[id] [int] NOT NULL,
	[lat] [decimal](9, 6) NULL,
	[lng] [decimal](9, 6) NULL,
	[label] [char](5) NULL,
	[name] [nvarchar](100) NOT NULL,
	[statecode] [nvarchar](40) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[GroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumber] [nvarchar](max) NULL,
	[IsOrphan] [bit] NOT NULL CONSTRAINT [DF__Groups__IsLineHi__1E6F845E]  DEFAULT ((0)),
	[PaddingLeft] [int] NOT NULL CONSTRAINT [DF__Groups__PaddingL__1F63A897]  DEFAULT ((0)),
	[ParentGroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumberSpace] [nvarchar](max) NULL,
	[TerritoryId] [int] NULL,
 CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Groups_old]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups_old](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[GroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumber] [nvarchar](max) NULL,
	[IsOrphan] [bit] NOT NULL,
	[PaddingLeft] [int] NOT NULL,
	[ParentGroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumberSpace] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[groups2]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[groups2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[GroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumber] [nvarchar](max) NULL,
	[IsLineHide] [bit] NOT NULL,
	[PaddingLeft] [int] NOT NULL,
	[ParentGroupNumber] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_MOLECULE]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HISTORY_TDW-ECP_DIM_MOLECULE](
	[FCC] [int] NULL,
	[PACK_DESCRIPTION] [varchar](80) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_OUTLET]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HISTORY_TDW-ECP_DIM_OUTLET](
	[OutletID] [int] NOT NULL,
	[PostCode] [int] NULL,
	[Outlet] [smallint] NULL,
	[Outl_Brk] [varchar](8) NULL,
	[EID] [int] NULL,
	[AID] [tinyint] NULL,
	[Name] [varchar](80) NULL,
	[FullAddr] [varchar](400) NULL,
	[Addr1] [varchar](200) NULL,
	[Addr2] [varchar](100) NULL,
	[Suburb] [varchar](100) NULL,
	[Phone] [varchar](15) NULL,
	[XCord] [decimal](9, 6) NULL,
	[YCord] [decimal](9, 6) NULL,
	[Entity_Type] [char](30) NULL,
	[Display] [varchar](30) NULL,
	[BannerGroup_Desc] [varchar](500) NULL,
	[Retail_Sbrick] [char](30) NULL,
	[Retail_Sbrick_Desc] [varchar](80) NULL,
	[Sbrick] [char](30) NULL,
	[Sbrick_Desc] [varchar](80) NULL,
	[State_Code] [varchar](40) NULL,
	[Out_Type] [varchar](20) NULL,
	[Outlet_Type_Desc] [varchar](80) NULL,
	[Inactive_Date] [datetime2](7) NULL,
	[Active_Date] [datetime2](7) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_PRODUCT]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HISTORY_TDW-ECP_DIM_PRODUCT](
	[FCC] [int] NULL,
	[PFC] [varchar](15) NULL,
	[PACK_DESCRIPTION] [varchar](80) NULL,
	[ATC4_CODE] [varchar](30) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_PRODUCTx]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HISTORY_TDW-ECP_DIM_PRODUCTx](
	[FCC] [int] NULL,
	[PFC] [varchar](15) NULL,
	[PACK_DESCRIPTION] [varchar](80) NULL,
	[ATC4_CODE] [varchar](30) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Levels]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Levels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[LevelNumber] [int] NOT NULL,
	[LevelIDLength] [int] NOT NULL DEFAULT ((0)),
	[LevelColor] [nvarchar](max) NULL,
	[BackgroundColor] [nvarchar](max) NULL,
	[TerritoryId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Levels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[levels2]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[levels2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[LevelNumber] [int] NOT NULL,
	[LevelIDLength] [int] NOT NULL,
	[LevelColor] [nvarchar](max) NULL,
	[BackgroundColor] [nvarchar](max) NULL,
	[TerritoryId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Listings]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Listings](
	[listingId] [int] IDENTITY(1,1) NOT NULL,
	[listingTitle] [nvarchar](max) NULL,
	[listingDescription] [nvarchar](max) NULL,
	[listingPharmacyFileUrl] [nvarchar](max) NULL,
	[listingHospitalFileUrl] [nvarchar](max) NULL,
	[listingCreatedOn] [datetime] NULL,
	[listingCreatedBy] [nvarchar](max) NULL,
	[listingModifiedOn] [datetime] NULL,
	[listingModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Listings] PRIMARY KEY CLUSTERED 
(
	[listingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketBases]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketBases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Suffix] [nvarchar](max) NULL,
	[DurationTo] [nvarchar](max) NULL,
	[DurationFrom] [nvarchar](max) NULL,
	[GuiId] [nvarchar](max) NULL,
	[BaseType] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.MarketBases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitionBaseMaps]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitionBaseMaps](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[MarketBaseId] [int] NOT NULL,
	[DataRefreshType] [nvarchar](max) NULL,
	[MarketDefinitionId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.MarketDefinitionBaseMaps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitionPacks]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitionPacks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
	[MarketDefinitionId] [int] NOT NULL,
	[Alignment] [nvarchar](max) NULL,
	[Product] [nvarchar](max) NULL,
	[ChangeFlag] [nchar](1) NULL,
	[Molecule] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.MarketDefinitionPacks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitions]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NOT NULL,
	[GuiId] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.MarketDefinitions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitions_Extended]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitions_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketDefinitionId] [int] NOT NULL,
	[Client_No] [int] NULL,
 CONSTRAINT [PK_dbo.MarketDefinitions_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitionsPackTest]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitionsPackTest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
	[MarketDefinitionId] [int] NOT NULL,
	[Alignment] [nvarchar](max) NULL,
	[Product] [nvarchar](max) NULL,
	[ChangeFlag] [nchar](1) NULL,
	[Molecule] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefWithMarketBase]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefWithMarketBase](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketDefId] [nvarchar](10) NULL,
	[MarketBaseId] [nvarchar](10) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Module]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Module](
	[ModuleID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[SectionID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mole]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mole](
	[FCC] [int] NOT NULL,
	[Molecule] [int] NOT NULL,
	[Synonym] [tinyint] NOT NULL,
	[Parent] [int] NOT NULL,
	[Description] [varchar](70) NOT NULL,
 CONSTRAINT [PK_mole] PRIMARY KEY CLUSTERED 
(
	[FCC] ASC,
	[Molecule] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MonthlyDataSummaries]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonthlyDataSummaries](
	[monthlyDataSummaryId] [int] IDENTITY(1,1) NOT NULL,
	[monthlyDataSummaryTitle] [nvarchar](max) NULL,
	[monthlyDataSummaryDescription] [nvarchar](max) NULL,
	[monthlyDataSummaryFileUrl] [nvarchar](max) NULL,
	[monthlyDataSummaryCreatedOn] [datetime] NULL,
	[monthlyDataSummaryCreatedBy] [nvarchar](max) NULL,
	[monthlyDataSummaryModifiedOn] [datetime] NULL,
	[monthlyDataSummaryModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.MonthlyDataSummaries] PRIMARY KEY CLUSTERED 
(
	[monthlyDataSummaryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MonthlyNewproducts]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonthlyNewproducts](
	[monthlyNewProductId] [int] IDENTITY(1,1) NOT NULL,
	[monthlyNewProductTitle] [nvarchar](max) NULL,
	[monthlyNewProductDescription] [nvarchar](max) NULL,
	[monthlyNewProductFileUrl] [nvarchar](max) NULL,
	[monthlyNewProductCreatedOn] [datetime] NULL,
	[monthlyNewProductCreatedBy] [nvarchar](max) NULL,
	[monthlyNewProductModifiedOn] [datetime] NULL,
	[monthlyNewProductModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.MonthlyNewproducts] PRIMARY KEY CLUSTERED 
(
	[monthlyNewProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsAlerts]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsAlerts](
	[newsAlertId] [int] IDENTITY(1,1) NOT NULL,
	[newsAlertTitle] [nvarchar](max) NULL,
	[newsAlertDescription] [nvarchar](max) NULL,
	[newsAlertImageUrl] [nvarchar](max) NULL,
	[newsAlertAltImage] [nvarchar](max) NULL,
	[newsAlertCreatedOn] [datetime] NULL,
	[newsAlertCreatedBy] [nvarchar](max) NULL,
	[newsAlertModifiedOn] [datetime] NULL,
	[newsAlertModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.NewsAlerts] PRIMARY KEY CLUSTERED 
(
	[newsAlertId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OutletBrickAllocations]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutletBrickAllocations](
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
	[TerritoryId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.OutletBrickAllocations1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutletBrickAllocations_old]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OutletBrickAllocations_old](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NodeCode] [nvarchar](max) NULL,
	[NodeName] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[BrickOutletCode] [nvarchar](max) NULL,
	[BrickOutletName] [nvarchar](max) NULL,
	[LevelName] [nvarchar](max) NULL,
	[CustomGroupNumberSpace] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[TerritoryId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.OutletBrickAllocations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PackMarketBases]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackMarketBases](
	[PackId] [int] NOT NULL,
	[MarketBaseId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Period]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Period](
	[PeriodId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Number] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PeriodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PopularLinks]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PopularLinks](
	[popularLinkId] [int] IDENTITY(1,1) NOT NULL,
	[popularLinkTitle] [nvarchar](max) NULL,
	[popularLinkDescription] [nvarchar](max) NULL,
	[popularLinkDisplayOrder] [smallint] NOT NULL,
	[popularLinkCreatedOn] [smalldatetime] NULL,
	[popularLinkCreatedBy] [nvarchar](max) NULL,
	[popularLinkModifiedOn] [smalldatetime] NULL,
	[popularLinkModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_PopularLinks] PRIMARY KEY CLUSTERED 
(
	[popularLinkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RAW_TDW-ECP_DIM_MOLECULE]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RAW_TDW-ECP_DIM_MOLECULE](
	[FCC] [int] NULL,
	[MOLECULE] [varchar](30) NULL,
	[SYNONYM] [tinyint] NULL,
	[PARENT] [int] NULL,
	[DESCRIPTION] [varchar](80) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RAW_TDW-ECP_DIM_OUTLET]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RAW_TDW-ECP_DIM_OUTLET](
	[OTLT_CD] [int] NULL,
	[POSTCODE] [int] NULL,
	[AID] [tinyint] NULL,
	[NAME] [varchar](80) NULL,
	[FULLADDR] [varchar](400) NULL,
	[ADDR1] [varchar](200) NULL,
	[ADDR2] [varchar](100) NULL,
	[SUBURB] [varchar](100) NULL,
	[PHONE] [varchar](15) NULL,
	[XCORD] [decimal](9, 6) NULL,
	[YCORD] [decimal](9, 6) NULL,
	[ENTITY_TYPE] [varchar](30) NULL,
	[DISPLAY] [varchar](30) NULL,
	[BANNERGROUP_DESC] [varchar](500) NULL,
	[RETAIL_SBRICK] [varchar](30) NULL,
	[RETAIL_SBRICK_DESC] [varchar](80) NULL,
	[SBRICK] [varchar](30) NULL,
	[SBRICK_DESC] [varchar](80) NULL,
	[STATE_CODE] [varchar](40) NULL,
	[OUT_TYPE] [varchar](20) NULL,
	[OUTLET_TYPE_DESC] [varchar](80) NULL,
	[INACTIVE_DATE] [datetime2](7) NULL,
	[ACTIVE_DATE] [datetime2](7) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RAW_TDW-ECP_DIM_PRODUCT]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RAW_TDW-ECP_DIM_PRODUCT](
	[PackID] [int] NOT NULL,
	[Prod_cd] [int] NULL,
	[Pack_cd] [smallint] NULL,
	[PFC] [varchar](15) NULL,
	[ProductName] [varchar](18) NULL,
	[Product_Long_Name] [varchar](80) NULL,
	[Pack_Description] [varchar](80) NULL,
	[Pack_Long_Name] [varchar](194) NULL,
	[FCC] [int] NULL,
	[ATC1_Code] [varchar](30) NULL,
	[ATC1_Desc] [nvarchar](50) NULL,
	[ATC2_Code] [varchar](30) NULL,
	[ATC2_Desc] [nvarchar](50) NULL,
	[ATC3_Code] [varchar](30) NULL,
	[ATC3_Desc] [nvarchar](50) NULL,
	[ATC4_Code] [varchar](30) NULL,
	[ATC4_Desc] [nvarchar](50) NULL,
	[NEC1_Code] [varchar](30) NULL,
	[NEC1_Desc] [varchar](50) NULL,
	[NEC1_LongDesc] [varchar](80) NULL,
	[NEC2_Code] [varchar](30) NULL,
	[NEC2_desc] [varchar](50) NULL,
	[NEC2_LongDesc] [varchar](80) NULL,
	[NEC3_Code] [varchar](30) NULL,
	[NEC3_Desc] [varchar](50) NULL,
	[NEC3_LongDesc] [varchar](80) NULL,
	[NEC4_Code] [varchar](30) NULL,
	[NEC4_Desc] [varchar](50) NULL,
	[NEC4_LongDesc] [varchar](80) NULL,
	[CH_Segment_Code] [varchar](3) NULL,
	[CH_Segment_Desc] [varchar](50) NULL,
	[WHO1_Code] [varchar](30) NULL,
	[WHO1_Desc] [varchar](50) NULL,
	[WHO2_Code] [varchar](30) NULL,
	[WHO2_Desc] [varchar](50) NULL,
	[WHO3_Code] [varchar](30) NULL,
	[WHO3_Desc] [varchar](50) NULL,
	[WHO4_Code] [varchar](30) NULL,
	[WHO4_Desc] [varchar](50) NULL,
	[WHO5_Code] [varchar](30) NULL,
	[WHO5_Desc] [varchar](50) NULL,
	[FRM_Flgs1] [char](30) NULL,
	[FRM_Flgs1_Desc] [varchar](50) NULL,
	[FRM_Flgs2] [char](30) NULL,
	[FRM_Flgs2_Desc] [varchar](50) NULL,
	[FRM_Flgs3] [char](30) NULL,
	[Frm_Flgs3_Desc] [varchar](50) NULL,
	[FRM_Flgs4] [char](30) NULL,
	[FRM_Flgs4_Desc] [varchar](50) NULL,
	[FRM_Flgs5] [char](30) NULL,
	[FRM_Flgs5_Desc] [varchar](50) NULL,
	[FRM_Flgs6] [char](30) NULL,
	[Compound_Indicator] [varchar](12) NULL,
	[Compound_Ind_Desc] [varchar](15) NULL,
	[PBS_Formulary] [varchar](30) NULL,
	[PBS_Formulary_Date] [datetime2](7) NULL,
	[Poison_Schedule] [varchar](30) NULL,
	[Poison_Schedule_Desc] [varchar](35) NULL,
	[Stdy_Ind1_Code] [char](1) NULL,
	[Study_Indicators1] [varchar](30) NULL,
	[Stdy_Ind2_Code] [char](1) NULL,
	[Study_Indicators2] [varchar](30) NULL,
	[Stdy_Ind3_Code] [char](1) NULL,
	[Study_Indicators3] [varchar](30) NULL,
	[Stdy_Ind4_Code] [char](1) NULL,
	[Study_Indicators4] [varchar](30) NULL,
	[Stdy_Ind5_Code] [char](1) NULL,
	[Study_Indicators5] [varchar](30) NULL,
	[Stdy_Ind6_Code] [char](1) NULL,
	[Study_Indicators6] [varchar](30) NULL,
	[PackLaunch] [datetime2](7) NULL,
	[Prod_lch] [datetime2](7) NULL,
	[Org_Code] [int] NULL,
	[Org_Abbr] [varchar](20) NULL,
	[Org_Short_Name] [varchar](50) NULL,
	[Org_Long_Name] [varchar](80) NULL,
	[Out_td_dt] [datetime2](7) NULL,
	[pk_size] [int] NULL,
	[vol_wt_uns] [real] NULL,
	[vol_wt_meas] [varchar](30) NULL,
	[strgh_uns] [real] NULL,
	[strgh_meas] [varchar](30) NULL,
	[Conc_Unit] [numeric](18, 2) NULL,
	[Conc_Meas] [decimal](16, 3) NULL,
	[Additional_Strength] [varchar](4) NULL,
	[Additional_Pack_Info] [varchar](4) NULL,
	[Recommended_Retail_Price] [numeric](18, 2) NULL,
	[Ret_Price_Effective_Date] [datetime] NULL,
	[Editable_Pack_Description] [varchar](80) NULL,
	[APN] [varchar](18) NULL,
	[Trade_Product_Pack_ID] [varchar](18) NULL,
	[Form_Desc_Abbr] [varchar](30) NULL,
	[Form_Desc_Short] [varchar](50) NULL,
	[Form_Desc_Long] [varchar](80) NULL,
	[NFC1_Code] [nvarchar](30) NULL,
	[NFC1_Desc] [nvarchar](50) NULL,
	[NFC2_Code] [nvarchar](30) NULL,
	[NFC2_Desc] [nvarchar](50) NULL,
	[NFC3_Code] [nvarchar](30) NULL,
	[NFC3_Desc] [nvarchar](50) NULL,
	[Price_Effective_Date] [datetime] NULL,
	[Last_amd] [datetime2](7) NULL,
	[PBS_Start_Date] [datetime2](7) NULL,
	[PBS_End_Date] [datetime2](7) NULL,
	[Supplier_Code] [numeric](15, 0) NULL,
	[Supplier_Product_Code] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportWriter]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportWriter](
	[ReportWriterId] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](max) NULL,
	[Name] [nvarchar](max) NULL,
	[FileTypeId] [int] NULL,
	[DeliveryTypeId] [int] NULL,
	[FileId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportWriterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Restriction]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restriction](
	[RestrictionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RestrictionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Role]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleAction]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleAction](
	[RolePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NULL,
	[ActionID] [int] NULL,
	[AccessPrivilegeID] [int] NULL,
 CONSTRAINT [PK_RoleAction] PRIMARY KEY CLUSTERED 
(
	[RolePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Section]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Section](
	[SectionID] [int] IDENTITY(1,1) NOT NULL,
	[SectionName] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Service]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[ServiceId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceConfiguration]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ServiceConfiguration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Serviceid] [int] NULL,
	[configuation] [varchar](100) NULL,
	[value] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ServiceTerritory]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceTerritory](
	[ServiceTerritoryId] [int] IDENTITY(1,1) NOT NULL,
	[TerritoryBase] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceTerritoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Source]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Source](
	[SourceId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription](
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
PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subscription_Extended]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionId] [int] NOT NULL,
	[Client_No] [int] NULL,
 CONSTRAINT [PK_dbo.Subscription_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubscriptionMarket]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubscriptionMarket](
	[SubscriptionMarketId] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionId] [int] NULL,
	[MarketBaseId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SubscriptionMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblBrick]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBrick](
	[Brick] [char](5) NULL,
	[BrickName] [varchar](50) NULL,
	[Address] [varchar](1) NOT NULL,
	[BannerGroup] [varchar](60) NULL,
	[State] [varchar](10) NULL,
	[Panel] [varchar](10) NULL,
	[ChangeFlag] [varchar](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOutlet]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOutlet](
	[Outlet] [varchar](16) NULL,
	[OutletName] [varchar](40) NULL,
	[Address] [varchar](8000) NULL,
	[BannerGroup] [varchar](60) NULL,
	[State] [varchar](10) NULL,
	[Panel] [varchar](10) NULL,
	[ChangeFlag] [varchar](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Territories]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Territories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[RootGroup_id] [int] NULL,
	[RootLevel_Id] [int] NULL,
	[Client_id] [int] NULL,
	[IsBrickBased] [bit] NULL,
	[IsUsed] [bit] NULL,
	[GuiId] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Territories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Territories_Extended]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Territories_Extended](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TerritoryId] [int] NOT NULL,
	[Client_No] [int] NULL,
 CONSTRAINT [PK_dbo.Territories_Extended] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[territories2]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[territories2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[RootGroup_id] [int] NULL,
	[RootLevel_Id] [int] NULL,
	[Client_id] [int] NULL,
	[IsBrickBased] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ThirdParty]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThirdParty](
	[ThirdPartyId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Active] [bit] NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[ThirdPartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](300) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[email] [varchar](300) NULL,
	[UserTypeID] [int] NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[ReceiveEmail] [bit] NULL DEFAULT ((1)),
	[Password] [varchar](50) NULL,
	[PwdEncrypted] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserClient]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClient](
	[UserClientId] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserLogin_History]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[UserLogin_History](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[UserName] [varchar](500) NULL,
	[UserType] [int] NULL,
	[RoleID] [int] NULL,
	[LoginDate] [datetime] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[UserLogin_History] ADD [Comment] [varchar](200) NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[UserRolesId] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserRolesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserType]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserType](
	[UserTypeID] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[UserTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[z_Items]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[z_Items](
	[ItemID] [int] NOT NULL,
	[DimensionID] [smallint] NULL,
	[RefItemID] [int] NULL,
	[LevelNo] [int] NULL,
	[Parent] [int] NULL,
	[ItemType] [tinyint] NOT NULL,
	[Number] [nvarchar](40) NOT NULL,
	[ShortName] [nvarchar](40) NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Item] [nvarchar](20) NULL,
	[Visible] [bit] NOT NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY NONCLUSTERED 
(
	[ItemID] ASC,
	[VersionFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SERVICE].[AU9_CLIENT_MKT_PACK]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SERVICE].[AU9_CLIENT_MKT_PACK](
	[CLIENT_MKT_ID] [bigint] NULL,
	[CLIENT_MKT_VERS_NBR] [int] NULL,
	[FCC] [int] NULL,
	[PACK_GRP_ID] [varchar](50) NULL,
	[PACK_GRP_NM] [varchar](50) NULL,
	[MKT_FCT] [decimal](15, 5) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SERVICE].[AU9_CLIENT_TERR]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SERVICE].[AU9_CLIENT_TERR](
	[CLIENT_TERR_ID] [bigint] NULL,
	[CLIENT_TERR_VERS_NBR] [int] NULL,
	[OTLT_CD] [varchar](30) NULL,
	[LVL_1_TERR_CD] [varchar](30) NULL,
	[LVL_1_TERR_NM] [varchar](50) NULL,
	[LVL_2_TERR_CD] [varchar](30) NULL,
	[LVL_2_TERR_NM] [varchar](50) NULL,
	[LVL_3_TERR_CD] [varchar](30) NULL,
	[LVL_3_TERR_NM] [varchar](50) NULL,
	[LVL_4_TERR_CD] [varchar](30) NULL,
	[LVL_4_TERR_NM] [varchar](50) NULL,
	[LVL_5_TERR_CD] [varchar](30) NULL,
	[LVL_5_TERR_NM] [varchar](50) NULL,
	[LVL_6_TERR_CD] [varchar](30) NULL,
	[LVL_6_TERR_NM] [varchar](50) NULL,
	[LVL_7_TERR_CD] [varchar](30) NULL,
	[LVL_7_TERR_NM] [varchar](50) NULL,
	[LVL_8_TERR_CD] [varchar](30) NULL,
	[LVL_8_TERR_NM] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SERVICE].[AU9_CLIENT_TERR_RAW]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SERVICE].[AU9_CLIENT_TERR_RAW](
	[GROUP_ID] [int] NOT NULL,
	[PARENT_ID] [int] NULL,
	[ROOT_GROUP_ID] [int] NULL,
	[GROUP_NAME] [nvarchar](max) NULL,
	[LEVEL_NUMBER] [nvarchar](max) NULL,
	[LEVEL_CD] [nvarchar](max) NULL,
	[LEVEL_NM] [nvarchar](max) NULL,
	[GROUP_NUMBER] [nvarchar](max) NULL,
	[TERRITORY_ID] [int] NULL,
	[NODE_CODE] [nvarchar](max) NULL,
	[NODE_NAME] [nvarchar](max) NULL,
	[TYPE] [nvarchar](max) NULL,
	[OUTLET_CODE] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [SERVICE].[AU9_CLIENT_TERR_TYP]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SERVICE].[AU9_CLIENT_TERR_TYP](
	[CLIENT_TERR_ID] [bigint] NULL,
	[CLIENT_ID] [int] NULL,
	[CLIENT_TERR_VERS_NBR] [int] NULL,
	[LVL_1_TERR_TYP_NM] [varchar](50) NULL,
	[LVL_2_TERR_TYP_NM] [varchar](50) NULL,
	[LVL_3_TERR_TYP_NM] [varchar](50) NULL,
	[LVL_4_TERR_TYP_NM] [varchar](50) NULL,
	[LVL_5_TERR_TYP_NM] [varchar](50) NULL,
	[LVL_6_TERR_TYP_NM] [varchar](50) NULL,
	[LVL_7_TERR_TYP_NM] [varchar](50) NULL,
	[LVL_8_TERR_TYP_NM] [varchar](50) NULL,
	[TERR_LOWEST_LVL_NBR] [varchar](30) NULL,
	[RPTG_LVL_RSTR] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[GoogleMapStates]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [dbo].[GoogleMapStates] order by id

create VIEW [dbo].[GoogleMapStates]
AS

select ItemID as id,ShortName as statecode
FROM [dbo].[z_Items]
  where DimensionID =836 and LevelNo =2

GO
/****** Object:  View [dbo].[GoogleMapTerritories]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[GoogleMapTerritories]
AS

select Convert(int,ROW_NUMBER() OVER(ORDER BY [statecode] ASC,territory ASC)) AS id, [statecode], territory
From (
	SELECT distinct  [statecode],[Name] territory
	  FROM [dbo].[GoogleMapBricks]
) a

GO
/****** Object:  View [dbo].[MatrketDefinition]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create VIEW [dbo].[MatrketDefinition]
AS

select A.Name as Market_Base, A.ID as Market_BaseID,
B.Name as Base_Filter_Name, B.Criteria as Base_Criteria, B.[Values] as Base_Values,
C.MarketDefinitionId,C.DataRefreshType,C.ID as MarketDefinitionBaseMapId,
D.Name as MDBase_Filter_Name,D.Criteria as MDBase_Criteria, D.[Values] as MDBase_Values

 from [dbo].MarketBases A
 join [dbo].BaseFilters B
 on A.ID=B.MarketBaseId
 full outer join [dbo].[MarketDefinitionBaseMaps] C
 on A.ID=C.MarketBaseId
 full outer join [dbo].[AdditionalFilters] D
 on C.Id=D.MarketDefinitionBaseMapId
 where 
 --D.Criteria is not  null
 C.MarketDefinitionId = 430


GO
/****** Object:  View [dbo].[vw_GroupsLevelWise]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_GroupsLevelWise]
AS
			SELECT 
				 id AS GROUP_ID
				,ParentId AS PARENT_ID
				,id AS ROOT_GROUP_ID
				,Name AS GROUP_NAME
				,LEFT(GroupNumber,1) AS LEVEL_NUMBER
				,GroupNumber AS GROUP_NUMBER
				,TerritoryId AS TERRITORY_ID
				,CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups
			WHERE GroupNumber like '1%'
			UNION
			---LEVEL 2
			SELECT 
				 id AS GROUP_ID
				, ParentId AS PARENT_ID
				,ParentId AS ROOT_GROUP_ID
				,Name AS GROUP_NAME
				,LEFT(GroupNumber,1) AS LEVEL_NUMBER
				,GroupNumber AS GROUP_NUMBER
				,TerritoryId AS TERRITORY_ID
				,CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups
			WHERE GroupNumber like '2%'
			UNION
			--LEVEL 3
			SELECT 
				 lvl3.Id AS GROUP_ID
				,lvl3.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl3.Name AS GROUP_NAME
				,LEFT(lvl3.GroupNumber,1) AS LEVEL_NUMBER
				,lvl3.GroupNumber AS GROUP_NUMBER
				,lvl3.TerritoryId AS TERRITORY_ID
				,lvl3.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl3
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			on lvl2.Id=lvl3.ParentId
			WHERE lvl3.GroupNumber like '3%'
			UNION
			--LEVEL 4
			SELECT 
				 lvl4.Id AS GROUP_ID
				,lvl4.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl4.Name AS GROUP_NAME
				,LEFT(lvl4.GroupNumber,1) AS LEVEL_NUMBER
				,lvl4.GroupNumber AS GROUP_NUMBER
				,lvl4.TerritoryId AS TERRITORY_ID
				,lvl4.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl4
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl4.GroupNumber like '4%'
			UNION
			--LEVEL 5
			SELECT 
				 lvl5.Id AS GROUP_ID
				,lvl5.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl5.Name AS GROUP_NAME
				,LEFT(lvl5.GroupNumber,1) AS LEVEL_NUMBER
				,lvl5.GroupNumber AS GROUP_NUMBER
				,lvl5.TerritoryId AS TERRITORY_ID
				,lvl5.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl5
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl5.GroupNumber like '5%'
			UNION
			--LEVEL 6
			SELECT 
				 lvl6.Id AS GROUP_ID
				,lvl6.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl6.Name AS GROUP_NAME
				,LEFT(lvl6.GroupNumber,1) AS LEVEL_NUMBER
				,lvl6.GroupNumber AS GROUP_NUMBER
				,lvl6.TerritoryId AS TERRITORY_ID
				,lvl6.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl6
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '5%') AS lvl5
			ON lvl5.Id=lvl6.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl6.GroupNumber like '6%'
			UNION
			--LEVEL 7
			SELECT 
				 lvl7.Id AS GROUP_ID
				,lvl7.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl7.Name AS GROUP_NAME
				,LEFT(lvl7.GroupNumber,1) AS LEVEL_NUMBER
				,lvl7.GroupNumber AS GROUP_NUMBER
				,lvl7.TerritoryId AS TERRITORY_ID
				,lvl7.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl7
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '6%') AS lvl6
			ON lvl6.Id=lvl7.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '5%') AS lvl5
			ON lvl5.Id=lvl6.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl7.GroupNumber like '7%'
			UNION
			--LEVEL 8
			SELECT 
				 lvl8.Id AS GROUP_ID
				,lvl8.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl8.Name AS GROUP_NAME
				,LEFT(lvl8.GroupNumber,1) AS LEVEL_NUMBER
				,lvl8.GroupNumber AS GROUP_NUMBER
				,lvl8.TerritoryId AS TERRITORY_ID
				,lvl8.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl8
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '7%') AS lvl7
			ON lvl7.Id=lvl8.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '6%') AS lvl6
			ON lvl6.Id=lvl7.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '5%') AS lvl5
			ON lvl5.Id=lvl6.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl8.GroupNumber like '8%'
			



GO
/****** Object:  View [dbo].[vw_Outlet_Combined]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_Outlet_Combined]
AS


SELECT 
	 O.Id ID
	,O.TerritoryId TERRITORY_ID
	,O.BrickOutletCode BRICK_CODE
	,O.BrickOutletName BRICK_NAME
	,O.NodeCode NODE_CODE
	,O.NodeName NODE_NAME
	,O.Type TYPE
	,D.Outlet OUTLET_CODE
	,D.OutletId OUTLET_ID
	,D.Name OUTLET_NAME
	,D.FullAddr ADDRESS
	,D.PostCode  POST_CODE
FROM dbo.OutletBrickAllocations O
INNER JOIN dbo.DimOutlet D
ON O.BrickOutletCode = D.Sbrick AND O.BrickOutletName = D.Sbrick_Desc

GO
/****** Object:  View [dbo].[vw_OutletBrickAll]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_OutletBrickAll]
AS


SELECT 
	 O.Id ID
	,O.TerritoryId
	,O.BrickOutletCode
	,O.BrickOutletName
	,O.NodeCode
	,O.NodeName
	,O.Type TYPE
	,D.Outlet OUTLET_CODE
	,D.OutletId OUTLET_ID
	,D.Name OUTLET_NAME
	,D.FullAddr ADDRESS
	,D.PostCode  POST_CODE
FROM dbo.OutletBrickAllocations O
INNER JOIN dbo.DimOutlet D
ON O.BrickOutletCode = D.Sbrick AND O.BrickOutletName = D.Sbrick_Desc


GO
/****** Object:  View [dbo].[vwBrick]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vwBrick]
AS
SELECT DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName, '' AS [Address], CHANGE_FLAG as ChangeFlag
FROM     dbo.DIMOutlet






GO
/****** Object:  View [dbo].[vwOutlet]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vwOutlet]
AS
SELECT DISTINCT Outl_brk Outlet, Name AS OutletName, REPLACE(REPLACE(FullAddr, CHAR(13), ' '), CHAR(10), ' ') AS [Address], CHANGE_FLAG as ChangeFlag
FROM     dbo.DIMOutlet






GO
ALTER TABLE [dbo].[Action]  WITH CHECK ADD FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Module] ([ModuleID])
GO
ALTER TABLE [dbo].[AdditionalFilters]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AdditionalFilters_dbo.MarketDefinitionBaseMaps_MarketDefinitionBaseMapId] FOREIGN KEY([MarketDefinitionBaseMapId])
REFERENCES [dbo].[MarketDefinitionBaseMaps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AdditionalFilters] CHECK CONSTRAINT [FK_dbo.AdditionalFilters_dbo.MarketDefinitionBaseMaps_MarketDefinitionBaseMapId]
GO
ALTER TABLE [dbo].[BaseFilters]  WITH CHECK ADD  CONSTRAINT [FK_dbo.BaseFilters_dbo.MarketBases_MarketBaseId] FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BaseFilters] CHECK CONSTRAINT [FK_dbo.BaseFilters_dbo.MarketBases_MarketBaseId]
GO
ALTER TABLE [dbo].[ClientMFR]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[ClientPackException]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[ClientRelease]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD FOREIGN KEY([DeliveryTypeId])
REFERENCES [dbo].[DeliveryType] ([DeliveryTypeId])
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD FOREIGN KEY([FrequencyTypeId])
REFERENCES [dbo].[FrequencyType] ([FrequencyTypeId])
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD FOREIGN KEY([PeriodId])
REFERENCES [dbo].[Period] ([PeriodId])
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD FOREIGN KEY([ReportWriterId])
REFERENCES [dbo].[ReportWriter] ([ReportWriterId])
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD FOREIGN KEY([SubscriptionId])
REFERENCES [dbo].[Subscription] ([SubscriptionId])
GO
ALTER TABLE [dbo].[DeliveryClient]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[DeliveryClient]  WITH CHECK ADD FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryMarket]  WITH CHECK ADD FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryMarket]  WITH CHECK ADD FOREIGN KEY([MarketDefId])
REFERENCES [dbo].[MarketDefinitions] ([Id])
GO
ALTER TABLE [dbo].[DeliveryTerritory]  WITH CHECK ADD FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryTerritory]  WITH CHECK ADD FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
GO
ALTER TABLE [dbo].[DeliveryThirdParty]  WITH CHECK ADD FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryThirdParty]  WITH CHECK ADD FOREIGN KEY([ThirdPartyId])
REFERENCES [dbo].[ThirdParty] ([ThirdPartyId])
GO
ALTER TABLE [dbo].[Frequency]  WITH CHECK ADD FOREIGN KEY([FrequencyTypeId])
REFERENCES [dbo].[FrequencyType] ([FrequencyTypeId])
GO
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Groups] ([Id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id]
GO
ALTER TABLE [dbo].[Levels]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Levels_dbo.Territories_TerritoryId] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Levels] CHECK CONSTRAINT [FK_dbo.Levels_dbo.Territories_TerritoryId]
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketBases_MarketBaseId] FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps] CHECK CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketBases_MarketBaseId]
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketDefinitions_MarketDefinitionId] FOREIGN KEY([MarketDefinitionId])
REFERENCES [dbo].[MarketDefinitions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps] CHECK CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketDefinitions_MarketDefinitionId]
GO
ALTER TABLE [dbo].[MarketDefinitionPacks]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitionPacks_dbo.MarketDefinitions_MarketDefinitionId] FOREIGN KEY([MarketDefinitionId])
REFERENCES [dbo].[MarketDefinitions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MarketDefinitionPacks] CHECK CONSTRAINT [FK_dbo.MarketDefinitionPacks_dbo.MarketDefinitions_MarketDefinitionId]
GO
ALTER TABLE [dbo].[MarketDefinitions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitions_dbo.Clients_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MarketDefinitions] CHECK CONSTRAINT [FK_dbo.MarketDefinitions_dbo.Clients_ClientId]
GO
ALTER TABLE [dbo].[Module]  WITH CHECK ADD  CONSTRAINT [fk_section_module] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO
ALTER TABLE [dbo].[Module] CHECK CONSTRAINT [fk_section_module]
GO
ALTER TABLE [dbo].[OutletBrickAllocations]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OutletBrickAllocations1_dbo.Territories_TerritoryId] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OutletBrickAllocations] CHECK CONSTRAINT [FK_dbo.OutletBrickAllocations1_dbo.Territories_TerritoryId]
GO
ALTER TABLE [dbo].[OutletBrickAllocations_old]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OutletBrickAllocations_dbo.Territories_TerritoryId] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OutletBrickAllocations_old] CHECK CONSTRAINT [FK_dbo.OutletBrickAllocations_dbo.Territories_TerritoryId]
GO
ALTER TABLE [dbo].[PackMarketBases]  WITH CHECK ADD FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
GO
ALTER TABLE [dbo].[ReportWriter]  WITH CHECK ADD FOREIGN KEY([DeliveryTypeId])
REFERENCES [dbo].[DeliveryType] ([DeliveryTypeId])
GO
ALTER TABLE [dbo].[ReportWriter]  WITH CHECK ADD FOREIGN KEY([FileId])
REFERENCES [dbo].[File] ([FileId])
GO
ALTER TABLE [dbo].[ReportWriter]  WITH CHECK ADD FOREIGN KEY([FileTypeId])
REFERENCES [dbo].[FileType] ([FileTypeId])
GO
ALTER TABLE [dbo].[RoleAction]  WITH CHECK ADD FOREIGN KEY([AccessPrivilegeID])
REFERENCES [dbo].[AccessPrivilege] ([AccessPrivilegeID])
GO
ALTER TABLE [dbo].[RoleAction]  WITH CHECK ADD FOREIGN KEY([ActionID])
REFERENCES [dbo].[Action] ([ActionID])
GO
ALTER TABLE [dbo].[RoleAction]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD FOREIGN KEY([DataTypeId])
REFERENCES [dbo].[DataType] ([DataTypeId])
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD FOREIGN KEY([ServiceId])
REFERENCES [dbo].[Service] ([ServiceId])
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD FOREIGN KEY([ServiceTerritoryId])
REFERENCES [dbo].[ServiceTerritory] ([ServiceTerritoryId])
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD FOREIGN KEY([SourceId])
REFERENCES [dbo].[Source] ([SourceId])
GO
ALTER TABLE [dbo].[SubscriptionMarket]  WITH CHECK ADD FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
GO
ALTER TABLE [dbo].[SubscriptionMarket]  WITH CHECK ADD FOREIGN KEY([SubscriptionId])
REFERENCES [dbo].[Subscription] ([SubscriptionId])
GO
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Territories_dbo.Groups_RootGroup_id] FOREIGN KEY([RootGroup_id])
REFERENCES [dbo].[Groups] ([Id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_dbo.Territories_dbo.Groups_RootGroup_id]
GO
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Territories_dbo.Levels_RootLevel_Id] FOREIGN KEY([RootLevel_Id])
REFERENCES [dbo].[Levels] ([Id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_dbo.Territories_dbo.Levels_RootLevel_Id]
GO
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_Territories] FOREIGN KEY([Id])
REFERENCES [dbo].[Territories] ([Id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_Territories_Territories]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
ALTER TABLE [dbo].[UserClient]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[UserClient]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
/****** Object:  StoredProcedure [dbo].[CheckUserLogin]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec [dbo].CheckUserLogin 'dmurray@au.imshealth.com','ECP789'
CREATE PROCEDURE [dbo].[CheckUserLogin]
 @userName varchar(300), @pwd varchar(50)
AS
BEGIN
--update [dbo].[User]
--  set LastName=SUBSTRING(UserName,CHARINDEX('.',UserName)+1,LEN(UserName)-CHARINDEX('.',UserName))
--  where LastName=''
 --update [dbo].[User]
 -- set [UserName]=email
  
	INSERT INTO [dbo].[UserLogin_History]
           ([UserID]           ,[UserName]           ,[UserType]
           ,[RoleID]           ,[LoginDate])
    Select (select UserID from [dbo].[User] where [UserName]=@userName),  @userName,
		   (select UserTypeID from [dbo].[User] where [UserName]=@userName),
		   (SELECT RoleId 
			FROM [dbo].[User] u
			join dbo.UserRole ur on u.UserID=ur.UserID
			where [UserName]=@userName), GETDATE()

	SELECT u.UserID, r.RoleID, r.RoleName, u.email EmailId, FirstName+'.'+LastName username
	FROM [dbo].[User] u
	join dbo.UserRole ur on u.UserID=ur.UserID
	join dbo.Role r on ur.RoleId=r.RoleID
	where [UserName]=@userName and [Password]=@pwd and u.IsActive=1
	
	--SELECT u.UserID, RoleID, UserTypeID, username
	--FROM [dbo].[User] u
	--join dbo.UserRole ur on u.UserID=ur.UserID
	--where [UserName]=@userName and [Password]=@pwd and IsActive=1
	
END



GO
/****** Object:  StoredProcedure [dbo].[CombineMultipleMarketBasesForAll]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CombineMultipleMarketBasesForAll]
 
AS
BEGIN
	SET NOCOUNT ON;
	----REMOVE DUPLICATE RECORDS FROM MarketDefinitionPacks----
	with CTE_DUP as
	(
		select row_number() over (
			partition by pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
			order by pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
		) as rownum,
		pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
		from MarketDefinitionPacks
		where --MarketDefinitionId = 553 and 
		MarketBaseId is not null
	)
	--select * from CTE_DUP where rownum > 1 order by marketdefinitionid, pack;
	delete from CTE_DUP where rownum > 1;

	----COMBINING MULTIPLE MARKET BASES-----
	IF OBJECT_ID('tempdb..#t') IS NOT NULL drop table #t

	select C.pack, M.MarketBase, M.MarketBaseId, C.GroupNumber, C.GroupName, C.Factor, C.PFC, C.Manufacturer, C.ATC4, C.NEC4, C.DataRefreshType, C.StateStatus, C.MarketDefinitionId, C.Alignment, C.Product, C.ChangeFlag, C.Molecule
	into #t
	from(
		select distinct rownum, pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
		from(
			select rownum, pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
			,count(*) as kount 
			from 
			(
				select rank() over (order by pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule) as rownum,
				pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
				from MarketDefinitionPacks
				where 
				--MarketDefinitionId = 502 and 
				MarketBaseId is not null --
			)A
			group by rownum, pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
			--order by marketdefinitionid, pack
		)B
		where B.kount > 1
		--order by marketdefinitionid, pack
	)C
	join MarketDefinitionPacks M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC AND C.GroupNumber = M.GroupName and C.ATC4 = M.ATC4 and C.NEC4 = M.NEC4 and C.Manufacturer = M.Manufacturer
	order by C.marketdefinitionid, C.pack

	--select * from #t

	IF OBJECT_ID('tempdb..#aggregatedMarketBase') IS NOT NULL drop table #aggregatedMarketBase
	select pack, 
		STUFF((SELECT ', ' + CAST(MarketBase AS VARCHAR(500)) [text()]
			 FROM #t 
			 WHERE Pack = t.Pack and MarketDefinitionId = t.MarketDefinitionId and PFC = t.PFC AND GroupNumber = t.GroupName and ATC4 = t.ATC4 and NEC4 = t.NEC4 and Manufacturer = t.Manufacturer
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' ') MarketBase,
			STUFF((SELECT ', ' + CAST(MarketBaseId AS VARCHAR(500)) [text()]
			 FROM #t 
			 WHERE Pack = t.Pack and MarketDefinitionId = t.MarketDefinitionId and PFC = t.PFC AND GroupNumber = t.GroupName and ATC4 = t.ATC4 and NEC4 = t.NEC4 and Manufacturer = t.Manufacturer
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' ') MarketBaseId,
		GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
	into #aggregatedMarketBase
	from #t t
	group by pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule

	--select * from #aggregatedMarketBase

	-----DELETE RECORDS/PACKS COMMON FOR MULTIPLE MARKET BASES------
	delete C from MarketDefinitionPacks C 
	inner join #t M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC AND C.GroupNumber = M.GroupName and C.ATC4 = M.ATC4 and C.NEC4 = M.NEC4 and C.Manufacturer = M.Manufacturer

	-----INSERT COMIBNED MARKET BASES FOR COMMON PACKS--------
	insert into MarketDefinitionPacks select * from #aggregatedMarketBase

END


--[dbo].[CombineMultipleMarketBasesForAll]




GO
/****** Object:  StoredProcedure [dbo].[CreateDMMoleculeConcat]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateDMMoleculeConcat]

AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('dbo.DMMoleculeConcat') IS NOT NULL DROP TABLE DMMoleculeConcat
	select FCC, substring([Description], 4, 5000) [Description] 
	into DMMoleculeConcat
	from
	(
		SELECT 
			b.FCC, 
			(SELECT DISTINCT ' | ' + a.Description
			FROM DMMolecule a
			WHERE a.FCC = b.FCC --order by Description
			FOR XML PATH('')) [Description]
		FROM DMMolecule b
	GROUP BY b.FCC
	)A

END





GO
/****** Object:  StoredProcedure [dbo].[DeleteMarketBase]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMarketBase] 
	-- Add the parameters for the stored procedure here
	@MarketBaseId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT DISTINCT [MarketDefinitionId]
INTO #TEMP
FROM [dbo].[MarketDefinitionPacks]
WHERE [MarketBaseId]=@MarketBaseId


--to del market base
DELETE  FROM [dbo].[MarketBases]
WHERE ID=@MarketBaseId

DELETE FROM [dbo].[BaseFilters]
WHERE [MarketBaseId]=@MarketBaseId

DELETE FROM [ClientMarketBases]
WHERE [MarketBaseId]=@MarketBaseId

DELETE FROM  [dbo].[MarketDefinitionBaseMaps]
WHERE [MarketBaseId]=@MarketBaseId

--DELETE FROM [dbo].[MarketDefinitionPacks]
--WHERE [MarketBaseId]=@MarketBaseId

---for MarketDefinitionPacks
	DELETE FROM [dbo].[MarketDefinitionPacks]
	WHERE [MarketBaseId]=cast(@MarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar), '')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@MarketBaseId as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@MarketBaseId as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MarketBaseId as varchar)+',%'

-----------------------------------------
--delete market definition if it uses only one deleted MB

DECLARE @Count int;
DECLARE @MyCursor CURSOR;
DECLARE @MyField int;
BEGIN
    SET @MyCursor = CURSOR FOR
    SELECT DISTINCT [MarketDefinitionId] from #TEMP
        

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @MyField

    WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @Count=COUNT(*) from #TEMP
	  WHERE [MarketDefinitionId]=@MyField 
	  IF(@Count>0) 
			BEGIN
				DELETE FROM [dbo].[MarketDefinitions]
				WHERE ID=@MyField 
			END

      FETCH NEXT FROM @MyCursor 
      INTO @MyField 
    END; 

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;
--------------------------------------------
END



GO
/****** Object:  StoredProcedure [dbo].[GenerateBricksAndOutlets]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateBricksAndOutlets] 
AS
BEGIN
	SET NOCOUNT ON;

	truncate table tblBrick
	insert into tblBrick
	--SELECT DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName, '' AS [Address], CHANGE_FLAG as ChangeFlag
	--FROM dbo.DIMOutlet
	SELECT DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName, '' AS [Address], '' as BannerGroup, 
	State_Code as [State], 
	case when isnumeric(SBRICK)<>1 then 'H' else 'R' end as Panel,
	CHANGE_FLAG as ChangeFlag
	FROM dbo.DIMOutlet
	where State_Code <> ''  and Sbrick is not null

	------insert to tbloutlet
	truncate table tblOutlet
	insert into tblOutlet
	SELECT DISTINCT Outl_brk Outlet, Name AS OutletName, REPLACE(REPLACE(FullAddr, CHAR(13), ' '), CHAR(10), ' ') AS [Address], BannerGroup_Desc as BannerGroup,
	State_Code as [State], 
	case when left(ENTITY_TYPE,1) = 'H' and left(out_type,1)=2 then 'H'
		 when left(ENTITY_TYPE,1) = 'P' then 'R' 
		 when left(ENTITY_TYPE,1) = 'o' then 'O' end as Panel,
	
	CHANGE_FLAG as ChangeFlag
	FROM dbo.DIMOutlet
	where State_Code <> ''  and Outl_brk is not null

END

--select * from tblOutlet where State = '' or State is null
--exec [GenerateBricksAndOutlets]






GO
/****** Object:  StoredProcedure [dbo].[GetAllBricks]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllBricks] 
AS
BEGIN
	SET NOCOUNT ON;

select Brick Code, BrickName Name, Address, 
BannerGroup,State, Panel,
'brick' Type from dbo.tblBrick
	
END




GO
/****** Object:  StoredProcedure [dbo].[GetAllOutlets]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllOutlets] 
	@Role int = NULL
AS
BEGIN
	SET NOCOUNT ON;
if(@Role <> 1)
begin
	select cast(Outlet as nvarchar) Code, OutletName Name, Address, 
	BannerGroup,State, Panel,
	'outlet' Type from dbo.tblOutlet
	where panel <> 'O'
end

else
begin
	select cast(Outlet as nvarchar) Code, OutletName Name, Address, 
	BannerGroup,State, Panel,
	'outlet' Type from dbo.tblOutlet
end
	
END

--exec [dbo].[GetAllOutlets]  'analyst'




GO
/****** Object:  StoredProcedure [dbo].[GetBroadcast_Emails]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBroadcast_Emails] 
AS
BEGIN
	
	SELECT distinct  [email]
	  FROM [dbo].[User]
	  where [IsActive]=1
	
END



GO
/****** Object:  StoredProcedure [dbo].[GetClientMarketBase]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetClientMarketBase] 
	-- Add the parameters for the stored procedure here
	@ClientId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--declare @ClientMarketBase as TABLE (Id int, ClientId int, ClientName nvarchar(max),MarketBaseId int , MarketBaseName nvarchar(max), Description nvarchar(max));

    -- Insert statements for procedure here
--insert  @ClientMarketBase
	SELECT CMB.[Id]
      ,CMB.[ClientId]
	  ,C.Name ClientName
      ,CMB.[MarketBaseId]
	  ,MB.Name +' '+MB.Suffix MarketBaseName
	  ,MB.Description 
	  ,BF.[Id] BaseFilterId
      ,BF.[Name] BaseFilterName
      ,BF.[Criteria] BaseFilterCriteria
      ,BF.[Values] BaseFilterValues
	  ,BF.IsEnabled BaseFilterIsEnabled
	  ,BF.IsRestricted IsRestricted
	  ,BF.IsBaseFilterType IsBaseFilterType
  FROM [ClientMarketBases] CMB
  JOIN [Clients] C
  ON CMB.[ClientId] =C.Id
  JOIN [MarketBases] MB
  ON CMB.[MarketBaseId] = MB.Id
  JOIN [BaseFilters] BF
  ON CMB.MarketBaseId = BF.MarketBaseId
  WHERE CMB.[ClientId]=@ClientId
  

	
END



GO
/****** Object:  StoredProcedure [dbo].[GetClientMarketBaseDetails]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetClientMarketBaseDetails] 
	-- Add the parameters for the stored procedure here
	@ClientId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--declare @ClientMarketBase as TABLE (Id int, ClientId int, ClientName nvarchar(max),MarketBaseId int , MarketBaseName nvarchar(max), Description nvarchar(max));

    -- Insert statements for procedure here
--insert  @ClientMarketBase
	SELECT distinct CMB.[Id]
      ,CMB.[ClientId]
	  ,C.Name ClientName
      ,CMB.[MarketBaseId]
	  ,MB.Name+' '+MB.Suffix MarketBaseName
	  ,MB.Description 
	  --,BF.[Id] BaseFilterId
   --   ,BF.[Name] BaseFilterName
   --   ,BF.[Criteria] BaseFilterCriteria
   --   ,BF.[Values] BaseFilterValues
	  --,BF.IsEnabled BaseFilterIsEnabled
	  ,MB.[DurationTo]  as DurationFrom
	  ,MB.DurationFrom as DurationTo
  FROM [ClientMarketBases] CMB
  JOIN [Clients] C
  ON CMB.[ClientId] =C.Id
  JOIN [MarketBases] MB
  ON CMB.[MarketBaseId] = MB.Id
  JOIN [BaseFilters] BF
  ON CMB.MarketBaseId = BF.MarketBaseId
 WHERE CMB.[ClientId]=@ClientId
  

	
END



GO
/****** Object:  StoredProcedure [dbo].[GetEffectedMarketDefName]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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



GO
/****** Object:  StoredProcedure [dbo].[GetLandingPageContents]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--exec [dbo].[GetLandingPageContents] 
CREATE PROCEDURE [dbo].[GetLandingPageContents]
 
AS
BEGIN
	SELECT TOP 1 monthlyDataSummaryId Id, [monthlyDataSummaryTitle] Title
      ,[monthlyDataSummaryDescription] [Desc]      , 'DataSum' ContentType
	FROM [dbo].[MonthlyDataSummaries]
	Union
	SELECT TOP 1 monthlyNewProductId  Id, [monthlyNewProductTitle] Title
      ,[monthlyNewProductDescription] [Desc]      , 'NewProduct' ContentType
	FROM [dbo].[MonthlyNewproducts]
	Union
	SELECT TOP 1 listingId Id,  [listingTitle] Title
      ,[listingDescription] [Desc] , 'Listing' ContentType
	FROM [dbo].[Listings]
    Union
    SELECT TOP 1 cadPageId Id,  [cadPageTitle] Title
      ,[cadPageDescription] [Desc] , 'CAD' ContentType
	FROM  [dbo].[CADPages]
	Union Select * from
	(SELECT TOP 1 [newsAlertId] Id      ,[newsAlertTitle] Title
      ,[newsAlertDescription] [Desc] , 'News1' ContentType
		FROM  [dbo].[NewsAlerts]
		order by ContentType,ID) a
	Union Select * from
	(SELECT TOP 1 [newsAlertId] Id      ,[newsAlertTitle] Title
      ,[newsAlertDescription] [Desc] , 'News2' ContentType
		FROM  [dbo].[NewsAlerts]
		order by ContentType,ID desc) b
	--Union Select * from
	--(SELECT top 10000  [popularLinkId] Id 
	--	,[popularLinkTitle] Title 
	--	,[popularLinkDescription] [Desc] , 'Link' ContentType
	--	FROM  [dbo].[PopularLinks]
	--	 ) l
	order by contenttype,id
END



GO
/****** Object:  StoredProcedure [dbo].[GetLandingPageContents_bk]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--exec [dbo].[GetLandingPageContents]
create PROCEDURE [dbo].[GetLandingPageContents_bk]
 
AS
BEGIN
	SELECT TOP 1 monthlyDataSummaryId Id, [monthlyDataSummaryTitle] Title
      ,[monthlyDataSummaryDescription] [Desc]      , 'DataSum' ContentType
	FROM [dbo].[MonthlyDataSummaries]
	Union
	SELECT TOP 1 monthlyNewProductId  Id, [monthlyNewProductTitle] Title
      ,[monthlyNewProductDescription] [Desc]      , 'NewProduct' ContentType
	FROM [dbo].[MonthlyNewproducts]
	Union
	SELECT TOP 1 listingId Id,  [listingTitle] Title
      ,[listingDescription] [Desc] , 'Listing' ContentType
	FROM [dbo].[Listings]
    Union
    SELECT TOP 1 cadPageId Id,  [cadPageTitle] Title
      ,[cadPageDescription] [Desc] , 'CAD' ContentType
	FROM [dbo].[CADPages]
	Union Select * from
	(SELECT TOP 1 [newsAlertId] Id      ,[newsAlertTitle] Title
      ,[newsAlertDescription] [Desc] , 'News1' ContentType
		FROM [dbo].[NewsAlerts]
		order by ContentType,ID) a
	Union Select * from
	(SELECT TOP 1 [newsAlertId] Id      ,[newsAlertTitle] Title
      ,[newsAlertDescription] [Desc] , 'News2' ContentType
		FROM [dbo].[NewsAlerts]
		order by ContentType,ID desc) b
END



GO
/****** Object:  StoredProcedure [dbo].[GetMarketBaseForMarketDef]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetMarketBaseForMarketDef] 
	-- Add the parameters for the stored procedure here
	@ClientId int,
	@MarketDefId int  
AS
BEGIN	
	SELECT distinct CMB.[MarketBaseId] as Id
		  ,CMB.[ClientId]
		  ,C.Name ClientName
		  ,CMB.[MarketBaseId]
		  ,MB.Name +' '+MB.Suffix MarketBaseName
	  FROM [ClientMarketBases] CMB
	  JOIN [Clients] C
	  ON CMB.[ClientId] =C.Id
	  JOIN [MarketBases] MB
	  ON CMB.[MarketBaseId] = MB.Id
	  WHERE CMB.[ClientId]=2 AND CMB.MarketBaseId=518-- in (Select MarketBaseId From MarketDefWithMarketBase Where MarketDefId=457);
End

GO
/****** Object:  StoredProcedure [dbo].[GetPacksFromClientMarketBase]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetPacksFromClientMarketBase]  5,0,'beta'
CREATE PROCEDURE [dbo].[GetPacksFromClientMarketBase]  
 @Clientid int  ,
  @searchType int=0,
  @searchString varchar(max)
AS  
BEGIN  
 SET NOCOUNT ON;  
  
  declare  @MarketBaseId int  
  DECLARE @MarketBaseName varchar(max)
  DECLARE @ClientMktBaseCursor as CURSOR;
  SET @ClientMktBaseCursor = CURSOR FAST_FORWARD FOR

SELECT MarketBaseId from ClientMarketBases where ClientId=@Clientid

create table #Result (
	MarketBase varchar(max),	
	Pack nvarchar(max)
	
)

OPEN @ClientMktBaseCursor
FETCH NEXT FROM @ClientMktBaseCursor INTO @MarketBaseId
 WHILE @@FETCH_STATUS = 0
BEGIN
--set @MarketBaseId=3
 select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName   
 into #baseFilters  
 from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue  
 where B.MarketBaseId = @MarketBaseId and name <> 'Molecule'
  
 --select * from #baseFilters  
  select @MarketBaseName = Name + ' ' + Suffix from MarketBases  where ID=@MarketBaseId
 select marketbaseid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions  
 into #columnsToAppend  
 from #baseFilters   
  
 --select * from #columnsToAppend  
  
 declare @whereClause nvarchar(max)  
 declare @selectSql nvarchar(max)  
  set @whereClause = ''
  set @selectSql =''
 select distinct @whereClause = ' where ' + conditions from  
  (  
   SELECT   
    b.marketbaseid,   
    (SELECT ' ' + a.conditions   
    FROM #columnsToAppend a  
    WHERE a.marketbaseid = b.marketbaseid  
    FOR XML PATH('')) [conditions]  
   FROM #columnsToAppend b  
   GROUP BY b.marketbaseid, b.conditions  
   --ORDER BY 1  
  )c  
 
 if len(@whereClause) > 0
	 begin
	 set @whereClause = left(@whereClause, len(@whereClause) - 4)  
	 print(@whereClause) 
	 if @searchType = 0 
	  set @whereClause = @whereClause + ' and Pack_Description like '''  + @searchString + '%'''
	  else
	  set @whereClause = @whereClause + ' and Pack_Description like ' + '''%' + @searchString + '%'''
	  
	 set @selectSql = 'insert into #Result select distinct ''' + @MarketBaseName + ''', Pack_Description from DimProduct_Expanded ' + @whereClause  
	 --print @MarketBaseId 
	 print(@selectSql)  
	 EXEC(@selectSql)  
	  end
	   FETCH NEXT FROM @ClientMktBaseCursor INTO @MarketBaseId
	   drop table #baseFilters
	  drop table #columnsToAppend
	  
	end
CLOSE @ClientMktBaseCursor;
DEALLOCATE @ClientMktBaseCursor;
--select * from #Result 
SELECT Pack
, STUFF((SELECT ', ' + A.marketbase FROM #Result A
Where A.Pack=B.Pack FOR XML PATH('')),1,1,'') As [MarketBase]
From #Result B
Group By Pack
end
  
 
GO
/****** Object:  StoredProcedure [dbo].[GetPacksFromMarketBase]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPacksFromMarketBase]
 @MarketBaseId int
AS
BEGIN
	SET NOCOUNT ON;

	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName 
	into #baseFilters
	from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketBaseId = @MarketBaseId

	--select * from #baseFilters

	select marketbaseid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	--select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where ' + conditions from
		(
			SELECT 
				b.marketbaseid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.marketbaseid = b.marketbaseid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.marketbaseid, b.conditions
			--ORDER BY 1
		)c
	
	set @whereClause = left(@whereClause, len(@whereClause) - 4)
	print(@whereClause)

	set @selectSql = 'select distinct ' + cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, PFC, FCC from DimProduct_Expanded ' + @whereClause

	print(@selectSql)
	EXEC(@selectSql)
	
END

--[dbo].[GetPacksFromMarketBase] 653




GO
/****** Object:  StoredProcedure [dbo].[GetPacksFromMarketBaseMap]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetPacksFromMarketBaseMap]
 @MarketDefinitionId int, 
 @MarketBaseId int,
 @MarketDefBaseMapId int
AS
BEGIN
	SET NOCOUNT ON;

	----------MARKET BASE : BASE FILTERS CONSTRUCTION IN WHERE CLAUSE-------------
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName 
	into #baseFilters
	from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketBaseId = @MarketBaseId

	--select * from #baseFilters

	select marketbaseid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	--select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where ' + conditions from
		(
			SELECT 
				b.marketbaseid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.marketbaseid = b.marketbaseid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.marketbaseid, b.conditions
			--ORDER BY 1
		)c
	
	--set @whereClause = left(@whereClause, len(@whereClause) - 4)
	print(@whereClause)

	

	----------MARKET DEF BASE MAP: ADDITIONAL FILTERS CONSTRUCTION -------------
	--drop table #additionalFilters
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketDefinitionBaseMapId, C.ColumnName 
	into #additionalFilters
	from dbo.AdditionalFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketDefinitionBaseMapId = @MarketDefBaseMapId

	--select * from #additionalFilters

	--drop table #columnsToAppend2
	select marketdefinitionbasemapid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend2
	from #additionalFilters 

	--select * from #columnsToAppend2

	declare @additionalFilterConditions nvarchar(max)

	select distinct @additionalFilterConditions = conditions from
		(
			SELECT 
				b.marketdefinitionbasemapid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend2 a
				WHERE a.marketdefinitionbasemapid = b.marketdefinitionbasemapid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend2 b
			GROUP BY b.marketdefinitionbasemapid, b.conditions
			--ORDER BY 1
		)c

	
	print(@additionalFilterConditions)

	------Final SELECT query CONSTRUCTION---------
	set @selectSql = 'select distinct ' + cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, PFC, FCC from DimProduct_Expanded ' 
					+ @whereClause + @additionalFilterConditions

	set @selectSql = left(@selectSql, len(@selectSql) - 4)
	print(@selectSql)
	--EXEC(@selectSql)

	-----STORING THE OUTPUT OF QUERY INTO TEMPORARY TABLE VARIABLE
	declare @QueryResult table(MarketBaseId int, PFC varchar(30), FCC varchar(30))
	insert @QueryResult EXEC(@selectSql)
	--select * from @QueryResult

	-------comparing with HISTORY-----------
	select Q.MarketBaseId, Q.PFC, Q.FCC, H.CHANGE_FLAG into #packStatus
	from @QueryResult Q join [HISTORY_TDW-ECP_DIM_PRODUCT] H on Q.PFC = H.PFC and Q.FCC = H.FCC

	--select * from #packStatus

	------Market Definition Packs update----------
	-----------INSERT NEW PACKS--------------
	select distinct Pack_Description as Pack, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' MarketBase, PS.MarketBaseId MarketBaseId, '' GroupNumber, '' GroupName, '' Factor, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, 'XXXXXXXX' DataRefreshType, '' as StateStatus, @MarketDefinitionId as MarketDefinitionId, 'XXXXXXXXXXXXXXX' Alignment, P.ProductName as Product, MC.Description as Molecule
	into #newPacks
	from #packStatus PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	join DMMoleculeConcat MC
	on P.Fcc=MC.FCC
	where PS.CHANGE_FLAG = 'A'

	--select * from #newPacks

	update #newPacks set MarketBase = MB.Name
	from MarketBases MB 
	where MB.Id = #newPacks.MarketBaseId 

	----
	update #newPacks set DataRefreshType= MD.DataRefreshType, Alignment = MD.DataRefreshType + '-' + case when MD.DataRefreshType = 'static' then 'left' else 'right' end 
	from MarketDefinitionBaseMaps MD 
	where MD.Id = @MarketDefBaseMapId

	--update #newPacks set Alignment= MP.Alignment
	--from MarketDefinitionPacks MP 
	--where MP.MarketBaseId = #newPacks.MarketBaseId and MP.MarketDefinitionId = @MarketDefinitionId

	--select * from #newPacks

	--split marketdefinitionpacks table
	select A.[pack], A.[MarketBase], Split.a.value('.', 'VARCHAR(100)') AS MarketBaseID,A.[GroupNumber], A.[GroupName], A.[Factor], A.[PFC], A.[Manufacturer], A.[ATC4], A.[NEC4], A.[DataRefreshType], A.[StateStatus], A.[MarketDefinitionId], A.[Alignment], A.[Product],A.[Molecule]
	into #mdpSplit
	from  (select [pack],MarketBase,GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, Molecule,
         CAST ('<M>' + REPLACE([MarketBaseId], ',', '</M><M>') + '</M>' AS XML) AS MarketBaseID  
		 from  MarketDefinitionPacks where MarketDefinitionId =@MarketDefinitionId) AS A CROSS APPLY MarketBaseID.nodes ('/M') AS Split(a)
	

	select * into #packsToInsert from 
	(
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, 'A' as Change_Flag, Molecule from #newPacks
		except
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, 'A' as Change_Flag, Molecule from #mdpSplit where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId
	)A

	insert into MarketDefinitionPacks select * from #packsToInsert

	-----------UPDATE MODIFIED PACKS--------------
	select distinct Pack_Description as Pack, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, P.ProductName as Product, MC.Description as Molecule
	into #modifiedPacks
	from #packStatus PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	join DMMoleculeConcat MC
	on P.Fcc=MC.FCC
	where PS.CHANGE_FLAG = 'M'

	
	--print('Modified Packs: ')
	--select * from #modifiedPacks
	update MarketDefinitionPacks 
	set Pack=M.Pack, Manufacturer=M.Manufacturer, ATC4=m.ATC4, NEC4=M.NEC4, Product=M.Product, Molecule=M.Molecule
	from MarketDefinitionPacks MD join #modifiedPacks M on MD.PFC = M.PFC 


	-----------DELETE PACKS--------------
	delete from MarketDefinitionPacks 
	where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId and PFC in 
		(
			select distinct PFC from #packStatus where CHANGE_FLAG = 'D'
		)

	--------INSERT INTO CLIENT PACK EXCEPTION------
	--insert into ClientPackException  
	--select distinct clientId,np.FCC,0 from [ClientPackException] cp
	--inner join DIMProduct_Expanded dp on cp.PackExceptionId = dp.FCC
	--inner join #newPacks np on dp.PFC = np.PFC and dp.FCC = np.FCC
	--where dp.Prod_cd in (select distinct Prod_cd from DIMProduct_Expanded where FCC in (select distinct FCC from #newPacks))
   
END


--[dbo].[GetPacksFromMarketBaseMap] 430,653,569





GO
/****** Object:  StoredProcedure [dbo].[GetPacksFromMarketBaseMap_OLD]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetPacksFromMarketBaseMap_OLD]
 @MarketDefinitionId int, 
 @MarketBaseId int,
 @MarketDefBaseMapId int
AS
BEGIN
	SET NOCOUNT ON;

	----------MARKET BASE : BASE FILTERS CONSTRUCTION IN WHERE CLAUSE-------------
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName 
	into #baseFilters
	from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketBaseId = @MarketBaseId

	--select * from #baseFilters

	select marketbaseid, Criteria + ' in ' + '(''' + [Values] + ''') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	--select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where ' + conditions from
		(
			SELECT 
				b.marketbaseid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.marketbaseid = b.marketbaseid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.marketbaseid, b.conditions
			--ORDER BY 1
		)c
	
	--set @whereClause = left(@whereClause, len(@whereClause) - 4)
	print(@whereClause)

	

	----------MARKET DEF BASE MAP: ADDITIONAL FILTERS CONSTRUCTION -------------
	--drop table #additionalFilters
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketDefinitionBaseMapId, C.ColumnName 
	into #additionalFilters
	from dbo.AdditionalFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketDefinitionBaseMapId = @MarketDefBaseMapId

	--select * from #additionalFilters

	--drop table #columnsToAppend2
	select marketdefinitionbasemapid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend2
	from #additionalFilters 

	--select * from #columnsToAppend2

	declare @additionalFilterConditions nvarchar(max)

	select distinct @additionalFilterConditions = conditions from
		(
			SELECT 
				b.marketdefinitionbasemapid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend2 a
				WHERE a.marketdefinitionbasemapid = b.marketdefinitionbasemapid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend2 b
			GROUP BY b.marketdefinitionbasemapid, b.conditions
			--ORDER BY 1
		)c

	
	print(@additionalFilterConditions)

	------Final SELECT query CONSTRUCTION---------
	set @selectSql = 'select distinct ' + cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, PFC, FCC from DimProduct_Expanded ' 
					+ @whereClause + @additionalFilterConditions

	set @selectSql = left(@selectSql, len(@selectSql) - 4)
	print(@selectSql)
	--EXEC(@selectSql)

	-----STORING THE OUTPUT OF QUERY INTO TEMPORARY TABLE VARIABLE
	declare @QueryResult table(MarketBaseId int, PFC varchar(30), FCC varchar(30))
	insert @QueryResult EXEC(@selectSql)
	--select * from @QueryResult

	-------comparing with HISTORY-----------
	select Q.MarketBaseId, Q.PFC, Q.FCC, H.CHANGE_FLAG into #packStatus
	from @QueryResult Q join [HISTORY_TDW-ECP_DIM_PRODUCT] H on Q.PFC = H.PFC and Q.FCC = H.FCC

	--select * from #packStatus

	------Market Definition Packs update----------
	-----------INSERT NEW PACKS--------------
	select distinct Pack_Description as Pack, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' MarketBase, PS.MarketBaseId MarketBaseId, '' GroupNumber, '' GroupName, '' Factor, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, 'XXXXXXXX' DataRefreshType, '' as StateStatus, @MarketDefinitionId as MarketDefinitionId, 'XXXXXXXXXXXXXXX' Alignment, P.ProductName as Product
	into #newPacks
	from #packStatus PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	where PS.CHANGE_FLAG = 'A'

	--select * from #newPacks

	update #newPacks set MarketBase = MB.Name
	from MarketBases MB 
	where MB.Id = #newPacks.MarketBaseId 

	----
	update #newPacks set DataRefreshType= MD.DataRefreshType, Alignment = MD.DataRefreshType + '-' + case when MD.DataRefreshType = 'static' then 'left' else 'right' end 
	from MarketDefinitionBaseMaps MD 
	where MD.Id = @MarketDefBaseMapId

	--update #newPacks set Alignment= MP.Alignment
	--from MarketDefinitionPacks MP 
	--where MP.MarketBaseId = #newPacks.MarketBaseId and MP.MarketDefinitionId = @MarketDefinitionId

	--select * from #newPacks

	select * into #packsToInsert from 
	(
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product from #newPacks
		except
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product from MarketDefinitionPacks where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId
	)A

	insert into MarketDefinitionPacks select * from #packsToInsert

	------INSERT INTO CLIENT PACK EXCEPTION------
	insert into ClientPackException  
	select distinct clientId,np.FCC,0 from [ClientPackException] cp
	inner join DIMProduct_Expanded dp on cp.PackExceptionId = dp.FCC
	inner join #newPacks np on dp.PFC = np.PFC and dp.FCC = np.FCC
	where dp.Prod_cd in (select distinct Prod_cd from DIMProduct_Expanded where FCC in (select distinct FCC from #newPacks))


	-----------DELETE PACKS--------------
	delete from MarketDefinitionPacks 
	where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId and PFC in 
		(
			select distinct PFC from #packStatus where CHANGE_FLAG = 'D'
		)
END


--[dbo].[GetPacksFromMarketBaseMap] 430,653,569





GO
/****** Object:  StoredProcedure [dbo].[GetUpdatedBricks]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- exec [dbo].[GetUpdatedBricks]  1389
-- =============================================
CREATE PROCEDURE [dbo].[GetUpdatedBricks] 
	-- Add the parameters for the stored procedure here
	@TerritoryId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select   A.BrickId Code, A.BrickName Name, A.Address Address, A.BannerGroup, A.State, A.Panel, 
--B.BannerGroup, B.State, B.Panel,
'brick' Type from
(select Brick as BrickId, BrickName, ISNULL(Address, '') Address, ISNULL(BannerGroup, '') BannerGroup, State, Panel from tblBrick 
except
select BrickOutletCode, BrickOutletName, ISNULL(Address, '') Address, BannerGroup, State, Panel from OutletBrickAllocations
where TerritoryId = @TerritoryId and Type = 'brick')A
--join tblBrick B
--on A.BrickId=B.brick and A.BrickName=b.BrickName
	
END

--exec [dbo].[GetUpdatedBricks] @TerritoryId=N'1031'



GO
/****** Object:  StoredProcedure [dbo].[GetUpdatedOutlets]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUpdatedOutlets] 
	-- Add the parameters for the stored procedure here
	@TerritoryId int,
	@Role int = NULL 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if(@Role <> 1)
begin
	select --ROW_NUMBER() OVER( ORDER BY A.OutletId) as NID, 
	cast(A.OutletId as nvarchar) Code, A.OutletName Name, A.Address, A.BannerGroup, A.State, A.Panel, 
	--B.BannerGroup, B.State, B.Panel,
	'outlet' Type from
	(
		select cast(Outlet as nvarchar) OutletId, OutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel from tblOutlet 
			except
		select BrickOutletCode, BrickOutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel from OutletBrickAllocations
		where TerritoryId = @TerritoryId and Type = 'outlet'
	)A
	where A.panel <> 'O'
end
else
begin
	select --ROW_NUMBER() OVER( ORDER BY A.OutletId) as NID, 
	cast(A.OutletId as nvarchar) Code, A.OutletName Name, A.Address, A.BannerGroup, A.State, A.Panel, 
	--B.BannerGroup, B.State, B.Panel,
	'outlet' Type from
	(
		select cast(Outlet as nvarchar) OutletId, OutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel from tblOutlet 
			except
		select BrickOutletCode, BrickOutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel from OutletBrickAllocations
		where TerritoryId = @TerritoryId and Type = 'outlet'
	)A
end
END

--exec [dbo].[GetUpdatedOutlets] @TerritoryId=N'1031'



GO
/****** Object:  StoredProcedure [dbo].[InsertTerritoryIdGroupTable]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[InsertTerritoryIdGroupTable]
AS
BEGIN
update G
set G.TerritoryId=T.Id
from dbo.Groups G
join [dbo].[vw_GroupsLevelWise] V
on G.id=V.GROUP_ID
join [dbo].[Territories] T
on T.RootGroup_id=V.ROOT_GROUP_ID
END
GO
/****** Object:  StoredProcedure [dbo].[prGetMarketBase]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[prGetMarketBase] 
	@ClientId int,
	@MarketDefId varchar(10),
	@Type varchar(100)

AS
BEGIN
	IF @Type='All Market Base'
	BEGIN
		select X.[Id]
			  ,X.[ClientId]
			  ,X.ClientName
			  ,X.[MarketBaseId]	  
			  ,X.UsedMarketBaseStatus
			  ,X.MarketBaseName
			  ,X.Description 
			  ,X.BaseFilterId
			  ,X.BaseFilterName
			  ,X.BaseFilterCriteria
			  ,X.BaseFilterValues
			  ,X.BaseFilterIsEnabled
			  ,X.IsRestricted
			  ,X.IsBaseFilterType
			from(
				SELECT CMB.[Id]
				  ,CMB.[ClientId]
				  ,C.Name ClientName
				  ,CMB.[MarketBaseId]
				  ,'false' UsedMarketBaseStatus
				  ,MB.Name +' '+MB.Suffix MarketBaseName
				  ,MB.Description 
				  ,BF.[Id] BaseFilterId
				  ,BF.[Name] BaseFilterName
				  ,BF.[Criteria] BaseFilterCriteria
				  ,BF.[Values] BaseFilterValues
				  ,BF.IsEnabled BaseFilterIsEnabled
				  ,BF.IsRestricted IsRestricted
				  ,BF.IsBaseFilterType IsBaseFilterType
			  FROM [ClientMarketBases] CMB
			  JOIN [Clients] C
			  ON CMB.[ClientId] =C.Id
			  JOIN [MarketBases] MB
			  ON CMB.[MarketBaseId] = MB.Id
			  JOIN [BaseFilters] BF
			  ON CMB.MarketBaseId = BF.MarketBaseId
			  WHERE CMB.[ClientId]=@ClientId
			)X

	END
	IF @Type='According to MarketDef'
	BEGIN
		select X.[Id]
			  ,X.[ClientId]
			  ,X.ClientName
			  ,X.[MarketBaseId]	  
			  ,X.UsedMarketBaseStatus
			  ,X.MarketBaseName
			  ,X.Description 
			  ,X.BaseFilterId
			  ,X.BaseFilterName
			  ,X.BaseFilterCriteria
			  ,X.BaseFilterValues
			  ,X.BaseFilterIsEnabled
			  ,X.IsRestricted
			  ,X.IsBaseFilterType
			from(
				SELECT CMB.[Id]
				  ,CMB.[ClientId]
				  ,C.Name ClientName
				  ,CMB.[MarketBaseId], A.MarketBaseId AS UsedMarketBaseId
				  ,case when CMB.[MarketBaseId] = A.MarketBaseId then 'true' else 'false' end UsedMarketBaseStatus
				  ,MB.Name +' '+MB.Suffix MarketBaseName
				  ,MB.Description 
				  ,BF.[Id] BaseFilterId
				  ,BF.[Name] BaseFilterName
				  ,BF.[Criteria] BaseFilterCriteria
				  ,BF.[Values] BaseFilterValues
				  ,BF.IsEnabled BaseFilterIsEnabled
				  ,BF.IsRestricted IsRestricted
				  ,BF.IsBaseFilterType IsBaseFilterType
			  FROM [ClientMarketBases] CMB
			  JOIN [Clients] C
			  ON CMB.[ClientId] =C.Id
			  JOIN [MarketBases] MB
			  ON CMB.[MarketBaseId] = MB.Id
			  JOIN [BaseFilters] BF
			  ON CMB.MarketBaseId = BF.MarketBaseId
			  left join 
				(select distinct MarketBaseId from MarketDefinitionBaseMaps where MarketDefinitionId in (@MarketDefId))A on A.MarketBaseId = CMB.[MarketBaseId]
			  WHERE CMB.[ClientId]=@ClientId
			)X
	END
END

--select * from MarketDefinitionBaseMaps Where MarketDefinitionId=484

Exec prGetMarketBase '2','309','According to MarketDef'
GO
/****** Object:  StoredProcedure [dbo].[procBuildQueryFromMarketBase]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE PROCEDURE [dbo].[procBuildQueryFromMarketBase]
(
	 @MarketBaseId int
)
AS
BEGIN
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName 
	into #baseFilters
	from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketBaseId = @MarketBaseId

	--select * from #baseFilters

	select marketbaseid, Criteria + ' in ' + '(''' + [Values] + ''') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	--select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where ' + conditions from
		(
			SELECT 
				b.marketbaseid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.marketbaseid = b.marketbaseid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.marketbaseid, b.conditions
			--ORDER BY 1
		)c
	
	set @whereClause = left(@whereClause, len(@whereClause) - 4)
	print(@whereClause)

	set @selectSql = 'select distinct ' + cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, PFC, FCC from DimProduct_Expanded ' + @whereClause

	print(@selectSql)
	select @selectSql

END

GO
/****** Object:  StoredProcedure [dbo].[ProcessAllMarketDefinitionsForDelta]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProcessAllMarketDefinitionsForDelta] 
AS
BEGIN
	SET NOCOUNT ON;

	select * into #loopTable from MarketDefinitions
	select * from #loopTable

	declare @pMarketDefinitionId int

	while exists(select * from #loopTable)
	begin
		select @pMarketDefinitionId = (select top 1 Id
						   from #loopTable
						   order by Id asc)

		print('Mkt def id : ')
		print(@pMarketDefinitionId)
		-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
		EXEC [dbo].[ProcessMarketDefinitionForNewDataLoad] @MarketDefinitionId = @pMarketDefinitionId

		delete #loopTable
		where Id = @pMarketDefinitionId
	end

	drop table #loopTable
END


--[dbo].[ProcessPacksFromMarketBaseMap] 430,653,569
--[dbo].[ProcessMarketDefinitionForNewDataLoad] 430
--select * from MarketDefinitionBaseMaps where MarketDefinitionId = 430
--select * from MarketDefinitions




GO
/****** Object:  StoredProcedure [dbo].[ProcessMarketDefinitionForNewDataLoad]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProcessMarketDefinitionForNewDataLoad]
 @MarketDefinitionId int 
AS
BEGIN
	SET NOCOUNT ON;

	print('MarketDefinitionId: ')
	print(@MarketDefinitionId)
	
	select * into #loopTable from MarketDefinitionBaseMaps
	where MarketDefinitionId = @MarketDefinitionId
	--select* from #loopTable
	declare @pMarketDefinitionBaseMapId int
	declare @pMarketBaseId int

	while exists(select * from #loopTable)
	begin
		select @pMarketDefinitionBaseMapId = (select top 1 Id
						   from #loopTable
						   order by Id asc)
		select @pMarketBaseId = MarketBaseId from #loopTable where Id = @pMarketDefinitionBaseMapId

		-------CALL SP TO PROCESS PACKS FOR ROW-------
		EXEC [dbo].[ProcessPacksFromMarketBaseMap] @MarketDefinitionId = @MarketDefinitionId,@MarketBaseId = @pMarketBaseId,@MarketDefBaseMapId = @pMarketDefinitionBaseMapId

		delete #loopTable
		where Id = @pMarketDefinitionBaseMapId
	end

	drop table #loopTable
END


--[dbo].[ProcessPacksFromMarketBaseMap] 430,653,569
--[dbo].[ProcessMarketDefinitionForNewDataLoad] 430
--select * from MarketDefinitionBaseMaps where MarketDefinitionId = 430




GO
/****** Object:  StoredProcedure [dbo].[ProcessPacksFromMarketBaseMap]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProcessPacksFromMarketBaseMap]
 @MarketDefinitionId int, 
 @MarketBaseId int,
 @MarketDefBaseMapId int
AS
BEGIN
	SET NOCOUNT ON;

	----------MARKET BASE : BASE FILTERS CONSTRUCTION IN WHERE CLAUSE-------------
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName 
	into #baseFilters
	from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketBaseId = @MarketBaseId

	select * from #baseFilters

	select marketbaseid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where ' + conditions from
		(
			SELECT 
				b.marketbaseid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.marketbaseid = b.marketbaseid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.marketbaseid, b.conditions
			--ORDER BY 1
		)c
	
	--set @whereClause = left(@whereClause, len(@whereClause) - 4)
	print('Base Filter: ' + @whereClause)

	

	----------MARKET DEF BASE MAP: ADDITIONAL FILTERS CONSTRUCTION -------------
	--drop table #additionalFilters
	declare @additionalFilterCount int
	declare @additionalFilterConditions nvarchar(max) = ''

	select @additionalFilterCount = count(AF.id) from AdditionalFilters AF join MarketDefinitionBaseMaps MB on AF.MarketDefinitionBaseMapId = MB.Id
	where MB.Id = @MarketDefBaseMapId
	--print(@additionalFilterCount)
	if @additionalFilterCount > 0
	begin
		select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketDefinitionBaseMapId, C.ColumnName 
		into #additionalFilters
		from dbo.AdditionalFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
		where B.MarketDefinitionBaseMapId = @MarketDefBaseMapId

		select * from #additionalFilters

		--drop table #columnsToAppend2
		select marketdefinitionbasemapid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
		into #columnsToAppend2
		from #additionalFilters 

		--select * from #columnsToAppend2

		

		select distinct @additionalFilterConditions = conditions from
			(
				SELECT 
					b.marketdefinitionbasemapid, 
					(SELECT ' ' + a.conditions 
					FROM #columnsToAppend2 a
					WHERE a.marketdefinitionbasemapid = b.marketdefinitionbasemapid
					FOR XML PATH('')) [conditions]
				FROM #columnsToAppend2 b
				GROUP BY b.marketdefinitionbasemapid, b.conditions
				--ORDER BY 1
			)c

	
		print('Additional Filters: ' + @additionalFilterConditions)
	end
	--------Final SELECT query CONSTRUCTION-----------
	--print('reached inside final query')
	set @selectSql = 'select distinct ' + cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, PFC, DIMProduct_Expanded.FCC from DimProduct_Expanded JOIN DMMolecule ON DIMProduct_Expanded.FCC = DMMolecule.FCC' 
					+ @whereClause + @additionalFilterConditions

	set @selectSql = left(@selectSql, len(@selectSql) - 4)
	print('Final Query: ' + @selectSql)
	--EXEC(@selectSql)

	-----STORING THE OUTPUT OF QUERY INTO TEMPORARY TABLE VARIABLE
	declare @QueryResult table(MarketBaseId int, PFC varchar(30), FCC varchar(30))
	insert @QueryResult EXEC(@selectSql)

	--select * from @QueryResult

	-------COMPARING with HISTORY-----------
	select Q.MarketBaseId, Q.PFC, Q.FCC, H.CHANGE_FLAG into #packInHistory
	from @QueryResult Q join [HISTORY_TDW-ECP_DIM_PRODUCT] H on Q.PFC = H.PFC and Q.FCC = H.FCC

	--select * from #packInHistory

	------Market Definition Packs update----------
	-----------INSERT NEW PACKS--------------
	select distinct Pack_Description as Pack, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' MarketBase, PS.MarketBaseId MarketBaseId, '' GroupNumber, '' GroupName, '' Factor, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, 'XXXXXXXX' DataRefreshType, '' as StateStatus, @MarketDefinitionId as MarketDefinitionId, 'XXXXXXXXXXXXXXX' Alignment, P.ProductName as Product,  MC.Description as Molecule
	into #newPacks
	from #packInHistory PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	join DMMoleculeConcat MC
	on P.Fcc=MC.FCC
	where PS.CHANGE_FLAG = 'A'

	--print('new packs:' )
	--select * from #newPacks

	update #newPacks set MarketBase = MB.Name
	from MarketBases MB 
	where MB.Id = #newPacks.MarketBaseId 

	----
	update #newPacks set DataRefreshType= MD.DataRefreshType, Alignment = MD.DataRefreshType + '-' + case when MD.DataRefreshType = 'static' then 'left' else 'right' end 
	from MarketDefinitionBaseMaps MD 
	where MD.Id = @MarketDefBaseMapId

	--select * from #newPacks


	--Split marketdefinitionpacks table
	select A.[pack], A.[MarketBase], Split.a.value('.', 'VARCHAR(100)') AS MarketBaseID,A.[GroupNumber], A.[GroupName], A.[Factor], A.[PFC], A.[Manufacturer], A.[ATC4], A.[NEC4], A.[DataRefreshType], A.[StateStatus], A.[MarketDefinitionId], A.[Alignment], A.[Product],A.[Molecule]
	into #mdpSplit
	from  (select [pack],MarketBase,GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, Molecule,
         CAST ('<M>' + REPLACE([MarketBaseId], ',', '</M><M>') + '</M>' AS XML) AS MarketBaseID  
		 from  MarketDefinitionPacks where MarketDefinitionId =@MarketDefinitionId) AS A CROSS APPLY MarketBaseID.nodes ('/M') AS Split(a)
	
	-----TRIM SPACE------
	update #mdpSplit set MarketBaseId = LTRIM(RTRIM(MarketBaseId))

	--update market base name
	update s
	set s.MarketBase=mb.Name
	from #mdpSplit s
	join MarketBases mb
	on mb.id=s.MarketBaseID
--where s.MarketBase like '%,%'
	
	print('Split:' )
	select * from #mdpSplit

	select * into #packsToInsert from 
	(
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, Molecule from #newPacks
		except
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, Molecule from #mdpSplit where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId
	)A

	insert into MarketDefinitionPacks select *, 'A' Change_Flag from #packsToInsert
	
	print('#packsToInsert:' )
	select * from #packsToInsert
	-----------DELETE PACKS--------------
	delete from MarketDefinitionPacks 
	where MarketDefinitionId = @MarketDefinitionId and PFC in 
   --and MarketBaseId = @MarketBaseId 
		(
			select distinct PFC from #packInHistory where CHANGE_FLAG = 'D'
		)

	-----------UPDATE MODIFIED PACKS--------------
	select distinct Pack_Description as Pack, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, P.ProductName as Product, MC.Description as Molecule
	into #modifiedPacks
	from #packInHistory PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	join DMMoleculeConcat MC
	on P.Fcc=MC.FCC
	where PS.CHANGE_FLAG = 'M'

	
	--print('Modified Packs: ')
	--select * from #modifiedPacks
	update MarketDefinitionPacks 
	set Pack=M.Pack, Manufacturer=M.Manufacturer, ATC4=m.ATC4, NEC4=M.NEC4, Product=M.Product, Molecule=M.Molecule
	from MarketDefinitionPacks MD join #modifiedPacks M on MD.PFC = M.PFC 

END


--[dbo].[ProcessPacksFromMarketBaseMap] 430,653,569




GO
/****** Object:  StoredProcedure [dbo].[ProcessTerritoryForDelta]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProcessTerritoryForDelta]


AS
BEGIN
	SET NOCOUNT ON;

	---DELETE BRICKS---
	delete O from OutletBrickAllocations O  
	join 
	(select DISTINCT Sbrick AS Brick
	from DimOutlet where CHANGE_FLAG = 'D') A 
	on A.Brick = O.BrickOutletCode 
	where O.type = 'brick'

	---MODIFY BRICKS---
	update O 
	set O.BrickOutletName = A.BrickName
	from OutletBrickAllocations O  
	join 
	(select DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName
	from DimOutlet where CHANGE_FLAG = 'M') A 
	on A.Brick = O.BrickOutletCode
	where O.type = 'brick'

	--DELETE OUTLETS--
	delete O from OutletBrickAllocations O  
	join 
	(select DISTINCT Outl_brk Outlet
	from DimOutlet where CHANGE_FLAG = 'D') A 
	on A.Outlet = O.BrickOutletCode 
	where O.type = 'outlet'

	--MODIFY OUTLETS--
	update O 
	set O.BrickOutletName = A.OutletName, O.[Address] = A.[Address]
	from OutletBrickAllocations O  
	join 
	(select DISTINCT Outl_brk Outlet, Name AS OutletName, REPLACE(REPLACE(FullAddr, CHAR(13), ' '), CHAR(10), ' ') AS [Address]
	from DimOutlet where CHANGE_FLAG = 'M') A 
	on A.Outlet = O.BrickOutletCode 
	where O.type = 'outlet'

END

GO
/****** Object:  StoredProcedure [dbo].[RemoveExpiredMarketBases]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RemoveExpiredMarketBases] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


CREATE TABLE #MarketBaseIds(MarketBaseId NVARCHAR(Max))
CREATE TABLE #RemovePacks(MarketBaseId NVARCHAR(Max),PFC NVARCHAR(Max))



-------------- GET EXPIRED MARKET BASES ------------------
INSERT INTO #MarketBaseIds
SELECT  [Id] AS MarketBaseId
FROM [dbo].[MarketBases]
WHERE [DurationFrom] < cast (GETDATE() as DATE)
---AND ID =680



----Remove Packs from Market Def
DECLARE @Count int;
DECLARE @MyCursor CURSOR;
DECLARE @MyField int;
BEGIN
    SET @MyCursor = CURSOR FOR
    SELECT DISTINCT [MarketBaseId] from #MarketBaseIds
        

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @MyField

    WHILE @@FETCH_STATUS = 0
    BEGIN

	 --------- GET PACKS FOR EXPIRED MARKET BASES --------------                           
	  INSERT #RemovePacks (MarketBaseId, PFC,FCC)
      EXEC GetPacksFromMarketBase @MyField

	  ------ REMOVING PACKS FROM MARKET_DEFINITION FOR EXPIRED MARKET BASES -----------
	  SELECT 'PACKS REMOVED', * FROM #RemovePacks
	  --DELETE FROM [MarketDefinitionPacks]
	  --WHERE PFC IN (SELECT DISTINCT PFC FROM #RemovePacks)  
	  --AND  MarketBaseId=@MyField

	 ---for MarketDefinitionPacks
	DELETE FROM [dbo].[MarketDefinitionPacks]
	WHERE PFC IN (SELECT DISTINCT PFC FROM #RemovePacks) AND [MarketBaseId]=cast(@MyField as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MyField as varchar), '')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MyField as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@MyField as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@MyField as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MyField as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MyField as varchar)+',%'

      FETCH NEXT FROM @MyCursor 
      INTO @MyField 
    END; 

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;

DROP TABLE #MarketBase
DROP TABLE #RemovePacks


END



GO
/****** Object:  StoredProcedure [dbo].[RevalidateMarketDefinition]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[RevalidateMarketDefinition]   
 -- Add the parameters for the stored procedure here  
 @MarketBaseId int   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
  
-- get Packs for MB  
CREATE TABLE #MarketBaseWithPack(MarketBaseId nvarchar(Max),PFC nvarchar(Max) ,FCC nvarchar(Max))  
CREATE TABLE #RemovePacks(MarketBaseId nvarchar(Max),PFC nvarchar(Max))  
CREATE TABLE #AddPacks(MarketBaseId nvarchar(Max),PFC nvarchar(Max))  
                                
INSERT #MarketBaseWithPack (MarketBaseId, PFC,FCC)  
   EXEC GetPacksFromMarketBase @MarketBaseId  
  
SELECT * FROM #MarketBaseWithPack  
  
---Update Market Base name in [MarketDefinitionPacks] table  
UPDATE [MarketDefinitionPacks]  
SET MarketBase = (SELECT DISTINCT NAME+' '+Suffix FROM [MarketBases] WHERE ID = @MarketBaseId)  
WHERE MarketBaseId= cast(@MarketBaseId as varchar)  
  
---Update Market Base name in [[MarketDefinitionBaseMaps]] table  
UPDATE [MarketDefinitionBaseMaps]  
SET [Name] = (SELECT DISTINCT NAME+' '+Suffix FROM [MarketBases] WHERE ID = @MarketBaseId)  
WHERE MarketBaseId= cast(@MarketBaseId as varchar) 
  
--Get MarketDef IDs for MBs  
SELECT DISTINCT [MarketDefinitionId],[MarketBaseId]  
INTO #MarketDefinitionDetails  
FROM [dbo].[MarketDefinitionPacks]  
WHERE [MarketBaseId] IN (SELECT MarketBaseId FROM #MarketBaseWithPack)  
  
SELECT * FROM #MarketDefinitionDetails  
  
----Remove Packs from Market Def  
DECLARE @Count int;  
DECLARE @MyCursor CURSOR;  
DECLARE @MyField int;  
BEGIN  
    SET @MyCursor = CURSOR FOR  
    SELECT DISTINCT [MarketDefinitionId] from #MarketDefinitionDetails  
          
  
    OPEN @MyCursor   
    FETCH NEXT FROM @MyCursor   
    INTO @MyField  
  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
 -------------Pack will be removed---------------  
      INSERT INTO #RemovePacks  
   SELECT * FROM   
   (SELECT DISTINCT MarketBaseId,PFC FROM [MarketDefinitionPacks]  
   WHERE [MarketDefinitionId]=@MyField AND [MarketBaseId]=@MarketBaseId  
      EXCEPT  
      SELECT DISTINCT MarketBaseId, PFC FROM #MarketBaseWithPack) A  
  
   ---removing packs from Market Def  
   SELECT 'PACKS REMOVED', * FROM #RemovePacks  
   DELETE FROM [MarketDefinitionPacks]  
   WHERE PFC IN (SELECT DISTINCT PFC FROM #RemovePacks)    
   AND [MarketDefinitionId]=@MyField AND MarketBaseId=@MarketBaseId  
  
   -------------Pack will be added---------------  
   INSERT INTO #AddPacks  
   SELECT * FROM   
   (SELECT DISTINCT MarketBaseId, PFC FROM #MarketBaseWithPack  
    EXCEPT  
    SELECT DISTINCT MarketBaseId,PFC FROM [MarketDefinitionPacks]  
    WHERE [MarketDefinitionId]=@MyField AND [MarketBaseId]=@MarketBaseId) A  
  
    ---add packs into Market Def  
    INSERT INTO [MarketDefinitionPacks]  
    SELECT DISTINCT Pack_Description AS Pack ,   
                    MDBM.[Name]  AS MarketBase,   
                       MDBM.[MarketBaseId]  AS MarketBaseId,  
                       '' AS GroupNumber,   
        '' AS GroupName,   
        '' AS Factor,   
        DIMProduct_Expanded.PFC AS PFC,    
           Org_Long_Name AS Manufacturer,   
        ATC4_Code AS ATC4,   
        NEC4_Code AS NEC4,  
           MDBM.[DataRefreshType]  AS DataRefreshType,   
        '' AS [StateStatus],  
        MDBM.[MarketDefinitionId] AS [MarketDefinitionId],  
        CASE   
       WHEN MDBM.[DataRefreshType] ='dynamic' THEN MDBM.[DataRefreshType]+'-right'  
       ELSE  MDBM.[DataRefreshType]+'-left'  
        END AS [Alignment],  
        ProductName AS Product,  
           'A' AS [ChangeFlag]     
   FROM  DIMProduct_Expanded   
      JOIN DMMolecule   
      ON DIMProduct_Expanded.FCC = DMMolecule.FCC  
      JOIN #AddPacks  
      ON #AddPacks.PFC = DIMProduct_Expanded.PFC  
      JOIN [MarketDefinitionBaseMaps] MDBM  
      ON #AddPacks.MarketBaseId= CONVERT(nvarchar(Max), MDBM.[MarketBaseId])  
      WHERE MDBM.[MarketDefinitionId]=@MyField  
  
      FETCH NEXT FROM @MyCursor   
      INTO @MyField   
    END;   
  
    CLOSE @MyCursor ;  
    DEALLOCATE @MyCursor;  
END;  
  
DROP TABLE #MarketBaseWithPack  
DROP TABLE #RemovePacks  
DROP TABLE #AddPacks  
  
END  
  
  
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomGroupNumberForAllTerritories]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateCustomGroupNumberForAllTerritories] 
AS
BEGIN
	SET NOCOUNT ON;

	select * into #loopTable from Territories
	select * from #loopTable

	declare @pTerritoryId int

	while exists(select * from #loopTable)
	begin
		select @pTerritoryId = (select top 1 Id
						   from #loopTable
						   order by Id asc)

		print('TxR id : ')
		print(@pTerritoryId)
		-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
		EXEC [dbo].[IRPImportTerritoryDefinition_Groups]  @pTerritoryId

		delete #loopTable
		where Id = @pTerritoryId
	end

	drop table #loopTable
END

--[dbo].[UpdateCustomGroupNumberForAllTerritories] 



GO
/****** Object:  StoredProcedure [dbo].[UpdateDataRefreshType]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateDataRefreshType]
	@NewMarketDefId int
as
begin

	UPDATE A set A.DataRefreshType = B.DataRefreshType
	from MarketDefinitionBaseMaps A
	join 
	(
		select distinct MarketBaseId, DataRefreshType, MarketDefinitionId from MarketDefinitionPacks 
		where marketdefinitionid = @NewMarketDefId and MarketBaseId not like '%,%'
	)B 
	on A.MarketDefinitionId = B.MarketDefinitionId and A.MarketBaseId = cast(B.MarketBaseId as varchar)
	where A.marketdefinitionid = @NewMarketDefId

end
GO
/****** Object:  StoredProcedure [dbo].[UpdateMarketBaseId]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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




GO
/****** Object:  StoredProcedure [dbo].[UpdateMarketDefinitionId]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [dbo].[z_ECP_AddExtendedTables]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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

GO
/****** Object:  StoredProcedure [dbo].[z_QC]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[z_QC] 
	
AS
BEGIN
select c.Name Client, t.*,g.numberOfBricks from dbo.Territories t
join (
select TerritoryId ,COUNT(*) numberOfBricks
from OutletBrickAllocations
where  Type = 'brick'
group by TerritoryId) g on t.Id=g.TerritoryId
join dbo.Clients c on t.Client_id=c.Id
order by numberOfBricks 

END



GO
/****** Object:  StoredProcedure [dbo].[z_WebpageSecurity]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[z_WebpageSecurity]
 
AS
BEGIN

--alter table [dbo].[User]
--  add PwdEncrypted int null

--INSERT INTO [dbo].[Section]
--           ([SectionName]           ,[IsActive])
--     VALUES           ('Admin'           ,1)
	
--INSERT INTO [dbo].[Module]
--           ([ModuleName]           ,[IsActive]           ,[SectionID])
--     VALUES ('Admin', 1, 5)
       
----INSERT INTO  [dbo].[Action]
----           ([ActionName]           ,[IsActive]           ,[ModuleID])
----     VALUES ('Admin access',1,12)
     
     --only production user can see/edit/etc on admin
  INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  4,61, [AccessPrivilegeID]
  FROM  [dbo].[AccessPrivilege]

 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  4,14, 1
  --FROM  [dbo].[AccessPrivilege]
 
 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  4,62, 1
    
    INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  7,61, [AccessPrivilegeID]
  FROM  [dbo].[AccessPrivilege]

 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  7,14, 1
  --FROM  [dbo].[AccessPrivilege]
 
 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  7,62, 1
    /*
    INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  5,61, [AccessPrivilegeID]
  FROM  [dbo].[AccessPrivilege]

 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  5,14, 1
  --FROM  [dbo].[AccessPrivilege]
 
 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  5,62, 1
    */

 --update  [dbo].[Action]
 -- set [ActionName]='Admin'
 -- where [ActionName]='Admin Access'

--SELECT *
--  FROM  [dbo].[RoleAction] ra
--  join dbo.Role r on ra.RoleId=r.RoleID
--  join dbo.Action a on ra.ActionID=a.ActionID
--  join dbo.AccessPrivilege ap on ap.AccessPrivilegeID=ra.AccessPrivilegeID
--  join dbo.Module m on a.ModuleID=m.ModuleID
--  join dbo.Section s on m.SectionID=s.SectionID
--  where ra.RoleId=5 and  a.ActionName='Use global navigation toolbar'
  
END



GO
/****** Object:  StoredProcedure [IRP].[IRPImportSubscription_Deliverable]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [IRP].[IRPImportSubscription_Deliverable] 
AS
BEGIN
--insert into Period values('160 Weeks',160)
--update [Service] set Name='Reference' where Name='IMS Reference'
--insert into DataType values ('API + AHI')
--insert into DataType values ('Product')

--select * from dbo.[z_Delivery Details]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE (TABLE_SCHEMA = 'dbo' or TABLE_SCHEMA = 'irp') AND  TABLE_NAME = 'z_Delivery Details')
BEGIN

	declare @Client varchar(100),@service varchar(100),@country varchar(100),@Datatype varchar(100),@source varchar(100),@DeliveryType varchar(100),
	@ReportWriterCode varchar(100),@ReportWriter varchar(100),@FrequencyType varchar(100),@Frequency varchar(500),@DeliverTo varchar(100), @Years varchar(100)

	declare @ClientId int,@countryId int,@serviceId int, @sourceId int,@datatypeId int,@ReportWriterId int, @FrequencyTypeId int, @FrequencyId int,@PeriodId int,@DeliveryTypeId int,
	@deliverToId int
	declare @subscriptionId int,@deliverablesId int
	declare @TerritoryBase varchar(50),@TerritoryBaseId int
	declare @cnt int
	set nocount on

	DECLARE subCursor CURSOR FOR

	SELECT  Client,[Service],Country,[DATA type], Source,[Delivery Type],[Report writer],[Report writer name],[frequency type],frequency,
	[deliver to],[# years]  FROM  dbo.[z_Delivery Details] 

	OPEN subCursor  
	FETCH NEXT FROM subCursor INTO @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@ReportWriter,@FrequencyType,@Frequency,@DeliverTo,@Years
	set @cnt =1
	WHILE @@Fetch_Status = 0 

	BEGIN

		--select @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@ReportWriter,@FrequencyType,@Frequency,@DeliverTo,@Years
		select  @clientId = 0,@countryId = 0,@serviceId = 0, @sourceId = 0, @datatypeId = 0
		--select top 1 @clientId = id from clients where Name = LTrim(RTrim(@client)) 
		if @Client = 'GlaxoSmithKline Consumer Healthcare'
		set @Client ='GSK Consumer'
		select top 1 @clientId = id from clients where left(Name,3)=  left(LTrim(RTrim(@client)),3) -- checking only first 3 characters
		select top 1 @countryId = CountryId from Country where Name = LTrim(RTrim(@country))
		select top 1 @serviceId = ServiceId from service where Name = LTrim(RTrim(@service))
		select top 1 @sourceId = sourceId from [dbo].[Source] where Name = LTrim(RTrim(@source))
		select top 1 @datatypeId = DataTypeId from Datatype where Name = LTrim(RTrim(@datatype)) 
		set @subscriptionId=0
		select @subscriptionId = SubscriptionId from Subscription where ClientId = @Clientid and CountryId = @countryId and ServiceId = @serviceId and SourceId = @sourceId and DataTypeId = @datatypeId
		--select @subscriptionId as subscriptionid,@Clientid client,@countryId country,@serviceId [service],@sourceId source,@datatypeId datatype
		if (@subscriptionId is null or @subscriptionId  < 1)
		begin
		
			if LTrim(RTrim(@service))='probe'  or LTrim(RTrim(@service)) = 'PROFITS + PROBE'
			set @TerritoryBase='both'
			else if LTrim(RTrim(@service))='profits' 
			set @TerritoryBase='brick'
			else if LTrim(RTrim(@service))='Audit' or LTrim(RTrim(@service))='IMS Reference' or LTrim(RTrim(@service))='Nielsen feed' or LTrim(RTrim(@service))='Pharma Trend' 
			set @TerritoryBase='NA'
			
			
			
			select @TerritoryBaseId=ServiceTerritoryid from ServiceTerritory where TerritoryBase=@TerritoryBase
		
		-- insert into subscription table
		   insert into Subscription (name,clientId,StartDate,EndDate,active,LastModified,modifiedby, CountryId,serviceId,SourceId,DataTypeId,ServiceTerritoryId)
		   values (@country +' '+@service + ' ' + @source+ ' ' + @datatype ,@clientId,
		   DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1),
		   1,CAST(GETDATE() AS DATE),1,
		   @countryId,@serviceId,@sourceId,@datatypeId,@TerritoryBaseId)
		   SELECT @subscriptionId = SCOPE_IDENTITY()
		   Print 'subscription inserted- id=' + cast(@subscriptionId as varchar)
		end
		select @ReportWriterId=0, @FrequencyTypeId= 0, @FrequencyId = 0,@PeriodId =0
		select top 1 @ReportWriterId = ReportWriterId from ReportWriter where code = LTrim(RTrim(@ReportWriterCode))
		select top 1 @FrequencyTypeId = FrequencyTypeId from FrequencyType where Name = LTrim(RTrim(@FrequencyType))
		select top 1 @FrequencyId = FrequencyId from Frequency where Name = LTrim(RTrim(@Frequency))
		select top 1 @PeriodId = Periodid from Period where Number=LTrim(RTrim(@Years))
		select @DeliveryTypeId = DeliveryTypeId from DeliveryType where Name=LTrim(RTrim(@DeliveryType))
	    
		if LTrim(RTrim(@service))='Nielsen feed' or LTrim(RTrim(@service))='Pharma Trend' 
		begin
			select @ReportWriterId = null, @FrequencyId = null,@PeriodId =null
			
			if LTrim(RTrim(@service))='Pharma Trend' 
			begin
				select top 1 @PeriodId = Periodid from Period where Number=3
			end
			if LTrim(RTrim(@service))='Nielsen feed' 
			begin
				select top 1 @PeriodId = Periodid from Period where Number=160
			end
			if @PeriodId is null or @PeriodId = 0
			begin
				select top 1 @PeriodId = Periodid from Period where Number=3
			end
			insert into ServiceConfiguration values(@serviceId,'period',@PeriodId)
			insert into ServiceConfiguration values(@serviceId,'frequency',0)
		end
		--select @ReportWriterId,@FrequencyTypeId,@FrequencyId,@PeriodId,@DeliveryTypeId
		  -- insert into  deliverables
		  
		   insert into Deliverables (SubscriptionId,ReportWriterId,FrequencyTypeId,FrequencyId,Periodid,StartDate,EndDate,LastModified,ModifiedBy,DeliveryTypeId)
		   values (@SubscriptionId,@ReportWriterId,@FrequencyTypeId,case when @FrequencyId =0 then null else @FrequencyId end,@PeriodId,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
		   DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1),CAST(GETDATE() AS DATE),1,@DeliveryTypeId)
		   SELECT @deliverablesId = SCOPE_IDENTITY()
		   --select 'deliverables id=' + cast(@deliverablesId as varchar)
		   Print 'Deliverables inserted- id=' + cast(@deliverablesId as varchar)
		   select top 1 @deliverToId = id from clients where left(Name,3) = Left(LTrim(RTrim(@DeliverTo)),3)
		   --select top 1 @deliverToId = id from clients where Name =  LTrim(RTrim(@client))
	       
		   insert into DeliveryClient (DeliverableId, ClientId) values(@deliverablesId,@deliverToId)
		Print 'Row =' + cast(@cnt as varchar)
		set @cnt =@cnt +1
		FETCH NEXT FROM subCursor INTO @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@ReportWriter,@FrequencyType,@Frequency,@DeliverTo,@Years
	    

	End 

	Close subCursor
	Deallocate subCursor
END
ELSE
BEGIN
Print 'The table z_Delivery Details does not exist'
END
End

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_AU9_CLIENT_MKT_PACK]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [SERVICE].[CREATE_AU9_CLIENT_MKT_PACK]
AS
BEGIN

TRUNCATE TABLE [SERVICE].[AU9_CLIENT_MKT_PACK]
INSERT INTO [SERVICE].[AU9_CLIENT_MKT_PACK]

SELECT
	 CAST([Id] AS INT) AS [CLIENT_MKT_ID]
	,CAST('1' AS INT) AS [CLIENT_MKT_VERS_NBR]
	,CAST(B.FCC AS INT) AS [FCC]
    ,CAST([GroupNumber] AS VARCHAR(50)) AS [PACK_GRP_ID]
	--,CASE
	--	WHEN GroupNumber IN ('GR','N',NULL)
	--	THEN 0
	--	ELSE CAST(GroupNumber AS INT)
	-- END AS [PACK_GRP_ID]
    ,CAST([GroupName] AS VARCHAR(MAX)) AS [PACK_GRP_NM]
    ,CAST(ROUND([Factor],2) AS DECIMAL(15,5)) AS [MKT_FCT]
    --,A.[PFC] AS PFC
FROM [dbo].[MarketDefinitionPacks] A
JOIN 
(SELECT DISTINCT [PFC],[FCC] FROM [dbo].[DIMProduct_Expanded]) B
ON A.PFC=B.PFC



--SELECT 
--	   [CLIENT_MKT_ID]
--      ,[CLIENT_MKT_VERS_NBR]
--      ,[FCC]
--      ,[PACK_GRP_ID]
--      ,[PACK_GRP_NM]
--      ,[MKT_FCT]
--FROM [ECP_TO_TDW].[SERVICE].[AU9_CLIENT_MKT_PACK]
END


GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_AU9_CLIENT_TERR]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SERVICE].[CREATE_AU9_CLIENT_TERR]
AS
BEGIN


TRUNCATE TABLE [SERVICE].[AU9_CLIENT_TERR_RAW]

EXECUTE [SERVICE].[CREATE_CT_LVL1]
EXECUTE [SERVICE].[CREATE_CT_LVL2]
EXECUTE [SERVICE].[CREATE_CT_LVL3]
EXECUTE [SERVICE].[CREATE_CT_LVL4]
EXECUTE [SERVICE].[CREATE_CT_LVL5]
EXECUTE [SERVICE].[CREATE_CT_LVL6]
EXECUTE [SERVICE].[CREATE_CT_LVL7]
EXECUTE [SERVICE].[CREATE_CT_LVL8]


TRUNCATE TABLE [SERVICE].[AU9_CLIENT_TERR]
INSERT INTO [SERVICE].[AU9_CLIENT_TERR]

SELECT
	 X.CLIENT_TERR_ID
	,'1' AS [CLIENT_TERR_VERS_NBR]
	,X.OUTLET
	,X.LVL_1_TERR_NM
	,Y.LVL_1_TERR_CD
	,X.LVL_2_TERR_NM
	,Y.LVL_2_TERR_CD
	,X.LVL_3_TERR_NM
	,Y.LVL_3_TERR_CD
	,X.LVL_4_TERR_NM
	,Y.LVL_4_TERR_CD
	,X.LVL_5_TERR_NM
	,Y.LVL_5_TERR_CD
	,X.LVL_6_TERR_NM
	,Y.LVL_6_TERR_CD
	,X.LVL_7_TERR_NM
	,Y.LVL_7_TERR_CD
	,X.LVL_8_TERR_NM
	,Y.LVL_8_TERR_CD
FROM 
	(
	SELECT 
		 TERRITORY_ID AS [CLIENT_TERR_ID]
		,OUTLET_CODE AS OUTLET
		,[LVL_1_TERR_NM]
		,[LVL_2_TERR_NM]
		,[LVL_3_TERR_NM]
		,[LVL_4_TERR_NM]
		,[LVL_5_TERR_NM]
		,[LVL_6_TERR_NM]
		,[LVL_7_TERR_NM]
		,[LVL_8_TERR_NM]
	FROM (SELECT [TERRITORY_ID]
		  ,[NODE_NAME]
		  ,[TYPE]
		  ,[OUTLET_CODE], LEVEL_NM FROM [SERVICE].[AU9_CLIENT_TERR_RAW]) P
	PIVOT
		(
		MAX (NODE_NAME)
		FOR LEVEL_NM IN
			([LVL_1_TERR_NM],[LVL_2_TERR_NM],[LVL_3_TERR_NM],[LVL_4_TERR_NM],[LVL_5_TERR_NM],[LVL_6_TERR_NM],[LVL_7_TERR_NM],[LVL_8_TERR_NM]
			)
		) AS PVT
	)  X
	JOIN
	(
	SELECT 
		 TERRITORY_ID AS [CLIENT_TERR_ID]
		 ,OUTLET_CODE AS OUTLET
		,[LVL_1_TERR_CD]
		,[LVL_2_TERR_CD]
		,[LVL_3_TERR_CD]
		,[LVL_4_TERR_CD]
		,[LVL_5_TERR_CD]
		,[LVL_6_TERR_CD]
		,[LVL_7_TERR_CD]
		,[LVL_8_TERR_CD]

	FROM (SELECT [TERRITORY_ID]
		  ,NODE_CODE
		  ,[TYPE]
		  ,[OUTLET_CODE], LEVEL_CD FROM [ECP_TO_TDW].[STAGE].[CLIENT_TERR_RAW]) P

	PIVOT
		(
		MAX (NODE_CODE)
		FOR LEVEL_CD IN
			([LVL_1_TERR_CD],[LVL_2_TERR_CD],[LVL_3_TERR_CD],[LVL_4_TERR_CD],[LVL_5_TERR_CD],[LVL_6_TERR_CD],[LVL_7_TERR_CD],[LVL_8_TERR_CD])
		) AS PVT
	) Y
ON X.CLIENT_TERR_ID=Y.CLIENT_TERR_ID and X.OUTLET=Y.OUTLET

END

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_AU9_CLIENT_TERR_TYP]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SERVICE].[CREATE_AU9_CLIENT_TERR_TYP]
AS
BEGIN

TRUNCATE TABLE [SERVICE].[AU9_CLIENT_TERR_TYP]

--;WITH CTE
--AS
--	(
--	SELECT TERRITORY_ID,VERSION_NO,MAX_LVL_NO,LEVEL_NAME,'LVL_'+CAST(LEVEL_NUMBER AS VARCHAR)+'_TERR_TYP_NM' LEVEL_NM_COL
--	FROM(
		
--		SELECT
--			a.ID as TERRITORY_ID
--			,b.Name as LEVEL_NAME
--			,b.LevelNumber AS LEVEL_NUMBER
--			,c.MAX_LVL AS MAX_LVL_NO
--			,1 AS VERSION_NO
--		FROM [dbo].[Territories] A
--		INNER JOIN [dbo].[Levels] B
--		ON A.Id=B.TerritoryId
--		INNER JOIN 
--		(
--		SELECT
--			TerritoryId,MAX(LevelNumber) AS MAX_LVL
--		FROM [dbo].[Levels]
--		GROUP BY TerritoryId
--		) C
--		ON a.Id=C.TerritoryId
--		) p
--	)
--INSERT INTO [SERVICE].[AU9_CLIENT_TERR_TYP]
--SELECT 
--	 TERRITORY_ID AS [CLIENT_TERR_ID]
--	,VERSION_NO AS [CLIENT_TERR_VERS_NBR]
--	,[LVL_1_TERR_TYP_NM]
--	,[LVL_2_TERR_TYP_NM]
--	,[LVL_3_TERR_TYP_NM]
--	,[LVL_4_TERR_TYP_NM]
--	,[LVL_5_TERR_TYP_NM]
--	,[LVL_6_TERR_TYP_NM]
--	,[LVL_7_TERR_TYP_NM]
--	,[LVL_8_TERR_TYP_NM]
--	,MAX_LVL_NO AS [TERR_LOWEST_LVL_NBR]
--	,'' AS [RPTG_LVL_RSTR]
--FROM CTE

--PIVOT
--	(
--	MAX (LEVEL_NAME)
--	FOR LEVEL_NM_COL IN
--		([LVL_1_TERR_TYP_NM],[LVL_2_TERR_TYP_NM],[LVL_3_TERR_TYP_NM],[LVL_4_TERR_TYP_NM]
--		,[LVL_5_TERR_TYP_NM],[LVL_6_TERR_TYP_NM],[LVL_7_TERR_TYP_NM],[LVL_8_TERR_TYP_NM]
--		)
--	) AS PVT


;WITH CTE
AS
	(
	SELECT TERRITORY_ID,CLIENT_ID,VERSION_NO,MAX_LVL_NO,LEVEL_NAME,'LVL_'+CAST(LEVEL_NUMBER AS VARCHAR)+'_TERR_TYP_NM' LEVEL_NM_COL
	FROM(
		
		SELECT
			a.ID as TERRITORY_ID
			,a.Client_id as CLIENT_ID
			,b.Name as LEVEL_NAME
			,b.LevelNumber AS LEVEL_NUMBER
			,c.MAX_LVL AS MAX_LVL_NO
			,1 AS VERSION_NO
		FROM [dbo].[Territories] A
		INNER JOIN [dbo].[Levels] B
		ON A.Id=B.TerritoryId
		INNER JOIN 
		(
		SELECT
			TerritoryId,MAX(LevelNumber) AS MAX_LVL
		FROM [dbo].[Levels]
		GROUP BY TerritoryId
		) C
		ON a.Id=C.TerritoryId
		) p
	)

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_TYP]
SELECT 
	 TERRITORY_ID AS [CLIENT_TERR_ID]
	,CLIENT_ID  AS [CLIENT_ID]
	,VERSION_NO AS [CLIENT_TERR_VERS_NBR]
	,[LVL_1_TERR_TYP_NM]
	,[LVL_2_TERR_TYP_NM]
	,[LVL_3_TERR_TYP_NM]
	,[LVL_4_TERR_TYP_NM]
	,[LVL_5_TERR_TYP_NM]
	,[LVL_6_TERR_TYP_NM]
	,[LVL_7_TERR_TYP_NM]
	,[LVL_8_TERR_TYP_NM]
	,MAX_LVL_NO AS [TERR_LOWEST_LVL_NBR]
	,'' AS [RPTG_LVL_RSTR]
FROM CTE

PIVOT
	(
	MAX (LEVEL_NAME)
	FOR LEVEL_NM_COL IN
		([LVL_1_TERR_TYP_NM],[LVL_2_TERR_TYP_NM],[LVL_3_TERR_TYP_NM],[LVL_4_TERR_TYP_NM]
		,[LVL_5_TERR_TYP_NM],[LVL_6_TERR_TYP_NM],[LVL_7_TERR_TYP_NM],[LVL_8_TERR_TYP_NM]
		)
	) AS PVT

END

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL1]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [SERVICE].[CREATE_CT_LVL1]
as
begin
insert into [SERVICE].[AU9_CLIENT_TERR_RAW]
select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1.[ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1 
join OutletBrickAllocations obat
on l1.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
and l1.GROUP_NAME=obat.NodeName
and l1.TERRITORY_ID=obat.TerritoryId
where  l1.LEVEL_NUMBER=1

--and obat.Type='Outlet' 

end

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL2]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [SERVICE].[CREATE_CT_LVL2]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l2.[ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
on l2.PARENT_ID=l1.GROUP_ID
join dbo.OutletBrickAllocations obat
on l2.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
and l2.GROUP_NAME=obat.NodeName
and l2.TERRITORY_ID=obat.TerritoryId
--where obat.Type='Outlet'	

UNION ----L1

select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1.[ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,obat.NodeName As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from  dbo.vw_GroupsLevelWise l2
		inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
		on l2.PARENT_ID=l1.GROUP_ID
		join dbo.OutletBrickAllocations obat
		on l2.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
		and l2.GROUP_NAME=obat.NodeName
		and l2.TERRITORY_ID=obat.TerritoryId
		--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1

end

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL3]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [SERVICE].[CREATE_CT_LVL3]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]

select 
	 l3.[GROUP_ID]
    ,l3.[PARENT_ID]
    ,l3.[ROOT_GROUP_ID]
    ,l3.[GROUP_NAME]
    ,l3.[LEVEL_NUMBER]
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l3.[GROUP_NUMBER]
    ,l3.[TERRITORY_ID]
    ,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l3.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l3
inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
on l3.PARENT_ID=l2.GROUP_ID
inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
on l2.PARENT_ID=l1.GROUP_ID
join dbo.OutletBrickAllocations obat
on l3.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
and l3.GROUP_NAME=obat.NodeName
and l3.TERRITORY_ID=obat.TerritoryId
--where obat.Type='Outlet'	

UNION

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join
	(select l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,obat.NodeName As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l3
		inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
		on l3.PARENT_ID=l2.GROUP_ID
		inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
		on l2.PARENT_ID=l1.GROUP_ID
		join dbo.OutletBrickAllocations obat
		on l3.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
		and l3.GROUP_NAME=obat.NodeName
		and l3.TERRITORY_ID=obat.TerritoryId
		--where obat.Type='Outlet'
	) gl 
	on gl.l2_ID=l2.GROUP_ID
where l2.LEVEL_NUMBER=2

UNION ----L1

select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,obat.NodeName As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l3
		inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
		on l3.PARENT_ID=l2.GROUP_ID
		inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
		on l2.PARENT_ID=l1.GROUP_ID
		join dbo.OutletBrickAllocations obat
		on l3.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
		and l3.GROUP_NAME=obat.NodeName
		and l3.TERRITORY_ID=obat.TerritoryId
		--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1

end
GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL4]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [SERVICE].[CREATE_CT_LVL4]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]

	select 
		 l4.[GROUP_ID]
		,l4.[PARENT_ID]
		,l4.[ROOT_GROUP_ID]
		,l4.[GROUP_NAME]
		,l4.[LEVEL_NUMBER]
		,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
		,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
		,l4.[GROUP_NUMBER]
		,l4.[TERRITORY_ID]
		,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,l4.[GROUP_NAME] As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l4
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l4.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l4.GROUP_NAME=obat.NodeName
	and l4.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	

	UNION

	select 
		 l3.[GROUP_ID]
		,l3.[PARENT_ID]
		,l3.[ROOT_GROUP_ID]
		,l3.[GROUP_NAME]
		,l3.[LEVEL_NUMBER]
		,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
		,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
		,l3.[GROUP_NUMBER]
		,l3.[TERRITORY_ID]
		,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,l3.GROUP_NAME As NODE_NAME
		,TYPE AS TYPE
		,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l3
	inner join
		(select l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l4
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
			on l4.PARENT_ID=l3.GROUP_ID
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
			on l3.PARENT_ID=l2.GROUP_ID
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
			on l2.PARENT_ID=l1.GROUP_ID
			join dbo.OutletBrickAllocations obat
			on l4.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
			and l4.GROUP_NAME=obat.NodeName
			and l4.TERRITORY_ID=obat.TerritoryId
			--where obat.Type='Outlet'
		) gl 
		on gl.l3_ID=l3.GROUP_ID
	where l3.LEVEL_NUMBER=3


	UNION

	select 
		 l2.[GROUP_ID]
		,l2.[PARENT_ID]
		,l1_ID as [ROOT_GROUP_ID]
		,l2.[GROUP_NAME]
		,l2.[LEVEL_NUMBER]
		,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
		,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
		,l2.[GROUP_NUMBER]
		,l2.[TERRITORY_ID]
		,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,l2.[GROUP_NAME] As NODE_NAME
		,TYPE AS TYPE
		,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l2
	inner join
		(select l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l4
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
			on l4.PARENT_ID=l3.GROUP_ID
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
			on l3.PARENT_ID=l2.GROUP_ID
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
			on l2.PARENT_ID=l1.GROUP_ID
			join dbo.OutletBrickAllocations obat
			on l4.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
			and l4.GROUP_NAME=obat.NodeName
			and l4.TERRITORY_ID=obat.TerritoryId
			--where obat.Type='Outlet'
		) gl 
		on gl.l2_ID=l2.GROUP_ID
	where l2.LEVEL_NUMBER=2

	UNION ----L1

	select 
		 l1.[GROUP_ID]
		,l1.[PARENT_ID]
		,l1_ID as [ROOT_GROUP_ID]
		,l1.[GROUP_NAME]
		,l1.[LEVEL_NUMBER]
		,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
		,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
		,l1.[GROUP_NUMBER]
		,l1.[TERRITORY_ID]
		,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,l1.[GROUP_NAME] As NODE_NAME
		,TYPE AS TYPE
		,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l1
	inner join
		(select l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l4
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
			on l4.PARENT_ID=l3.GROUP_ID
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
			on l3.PARENT_ID=l2.GROUP_ID
			inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
			on l2.PARENT_ID=l1.GROUP_ID
			join dbo.OutletBrickAllocations obat
			on l4.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
			and l4.GROUP_NAME=obat.NodeName
			and l4.TERRITORY_ID=obat.TerritoryId
			--where obat.Type='Outlet'
		) gl 
		on gl.l1_ID=l1.GROUP_ID
	where l1.LEVEL_NUMBER=1

end

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL5]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [SERVICE].[CREATE_CT_LVL5]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]

select 
	 l5.[GROUP_ID]
    ,l5.[PARENT_ID]
    ,l5.[ROOT_GROUP_ID]
    ,l5.[GROUP_NAME]
    ,l5.[LEVEL_NUMBER]
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l5.[GROUP_NUMBER]
    ,l5.[TERRITORY_ID]
    ,l5.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l5.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l5
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l5.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l5.GROUP_NAME=obat.NodeName
	and l5.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	

UNION

select 
	 l4.[GROUP_ID]
    ,l4.[PARENT_ID]
    ,l4.ROOT_GROUP_ID
    ,l4.[GROUP_NAME]
    ,l4.[LEVEL_NUMBER]
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l4.[GROUP_NUMBER]
    ,l4.[TERRITORY_ID]
    ,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l4.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l4
	inner join
		(select l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l5
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l5.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l5.GROUP_NAME=obat.NodeName
	and l5.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l4_ID=l4.GROUP_ID
	where l4.LEVEL_NUMBER=4


UNION

select 
	 l3.[GROUP_ID]
    ,l3.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l3.[GROUP_NAME]
    ,l3.[LEVEL_NUMBER]
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l3.[GROUP_NUMBER]
    ,l3.[TERRITORY_ID]
    ,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l3.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l3
inner join
	(select l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l5
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l5.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l5.GROUP_NAME=obat.NodeName
	and l5.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l3_ID=l3.GROUP_ID
where l3.LEVEL_NUMBER=3

UNION

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join
	(select l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l5
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l5.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l5.GROUP_NAME=obat.NodeName
	and l5.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l2_ID=l2.GROUP_ID
where l2.LEVEL_NUMBER=2

UNION ----L1

select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1.[ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] AS NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l5
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l5.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l5.GROUP_NAME=obat.NodeName
	and l5.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1


end

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL6]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [SERVICE].[CREATE_CT_LVL6]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]

select 
	 l6.[GROUP_ID]
    ,l6.[PARENT_ID]
    ,l6.[ROOT_GROUP_ID]
    ,l6.[GROUP_NAME]
    ,l6.[LEVEL_NUMBER]
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l6.[GROUP_NUMBER]
    ,l6.[TERRITORY_ID]
    ,l6.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l6.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l6
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l6.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l6.GROUP_NAME=obat.NodeName
	and l6.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	

UNION

select 
	 l5.[GROUP_ID]
    ,l5.[PARENT_ID]
    ,l5.ROOT_GROUP_ID
    ,l5.[GROUP_NAME]
    ,l5.[LEVEL_NUMBER]
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l5.[GROUP_NUMBER]
    ,l5.[TERRITORY_ID]
    ,l5.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l5.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l5
	inner join
		(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l6
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l6.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l6.GROUP_NAME=obat.NodeName
	and l6.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l5_ID=l5.GROUP_ID
	where l5.LEVEL_NUMBER=5

UNION

select 
	 l4.[GROUP_ID]
    ,l4.[PARENT_ID]
    ,l4.ROOT_GROUP_ID
    ,l4.[GROUP_NAME]
    ,l4.[LEVEL_NUMBER]
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l4.[GROUP_NUMBER]
    ,l4.[TERRITORY_ID]
    ,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l4.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l4
	inner join
		(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l6
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l6.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l6.GROUP_NAME=obat.NodeName
	and l6.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l4_ID=l4.GROUP_ID
	where l4.LEVEL_NUMBER=4


UNION

select 
	 l3.[GROUP_ID]
    ,l3.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l3.[GROUP_NAME]
    ,l3.[LEVEL_NUMBER]
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l3.[GROUP_NUMBER]
    ,l3.[TERRITORY_ID]
    ,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l3.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l3
inner join
	(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l6
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l6.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l6.GROUP_NAME=obat.NodeName
	and l6.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l3_ID=l3.GROUP_ID
where l3.LEVEL_NUMBER=3

UNION

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join
	(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l6
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l6.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l6.GROUP_NAME=obat.NodeName
	and l6.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l2_ID=l2.GROUP_ID
where l2.LEVEL_NUMBER=2

UNION ----L1

select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1.[ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] AS NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l6
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l6.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l6.GROUP_NAME=obat.NodeName
	and l6.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1

end

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL7]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [SERVICE].[CREATE_CT_LVL7]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]

select 
	 l7.[GROUP_ID]
    ,l7.[PARENT_ID]
    ,l7.[ROOT_GROUP_ID]
    ,l7.[GROUP_NAME]
    ,l7.[LEVEL_NUMBER]
	,'LVL_'+l7.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l7.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l7.[GROUP_NUMBER]
    ,l7.[TERRITORY_ID]
    ,l7.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l7.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l7
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l7.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l7.GROUP_NAME=obat.NodeName
	and l7.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	

UNION

select 
	 l6.[GROUP_ID]
    ,l6.[PARENT_ID]
    ,l6.ROOT_GROUP_ID
    ,l6.[GROUP_NAME]
    ,l6.[LEVEL_NUMBER]
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l6.[GROUP_NUMBER]
    ,l6.[TERRITORY_ID]
    ,l6.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l6.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l6
	inner join
		(select l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l7
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l7.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l7.GROUP_NAME=obat.NodeName
	and l7.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l6_ID=l6.GROUP_ID
	where l6.LEVEL_NUMBER=6


UNION

select 
	 l5.[GROUP_ID]
    ,l5.[PARENT_ID]
    ,l5.ROOT_GROUP_ID
    ,l5.[GROUP_NAME]
    ,l5.[LEVEL_NUMBER]
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l5.[GROUP_NUMBER]
    ,l5.[TERRITORY_ID]
    ,l5.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l5.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l5
	inner join
		(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l7
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l7.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l7.GROUP_NAME=obat.NodeName
	and l7.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l5_ID=l5.GROUP_ID
	where l5.LEVEL_NUMBER=5

UNION

select 
	 l4.[GROUP_ID]
    ,l4.[PARENT_ID]
    ,l4.ROOT_GROUP_ID
    ,l4.[GROUP_NAME]
    ,l4.[LEVEL_NUMBER]
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l4.[GROUP_NUMBER]
    ,l4.[TERRITORY_ID]
    ,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l4.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l4
	inner join
		(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l7
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l7.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l7.GROUP_NAME=obat.NodeName
	and l7.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l4_ID=l4.GROUP_ID
	where l4.LEVEL_NUMBER=4

UNION

select 
	 l3.[GROUP_ID]
    ,l3.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l3.[GROUP_NAME]
    ,l3.[LEVEL_NUMBER]
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l3.[GROUP_NUMBER]
    ,l3.[TERRITORY_ID]
    ,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l3.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l3
inner join
	(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l7
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l7.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l7.GROUP_NAME=obat.NodeName
	and l7.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l3_ID=l3.GROUP_ID
where l3.LEVEL_NUMBER=3

UNION

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join
	(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l7
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l7.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l7.GROUP_NAME=obat.NodeName
	and l7.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l2_ID=l2.GROUP_ID
where l2.LEVEL_NUMBER=2

UNION ----L1

select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1.[ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] AS NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l7
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l7.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l7.GROUP_NAME=obat.NodeName
	and l7.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1

end

GO
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL8]    Script Date: 6/07/2017 5:59:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [SERVICE].[CREATE_CT_LVL8]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]
select 
	 l8.[GROUP_ID]
    ,l8.[PARENT_ID]
    ,l8.[ROOT_GROUP_ID]
    ,l8.[GROUP_NAME]
    ,l8.[LEVEL_NUMBER]
	,'LVL_'+l8.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l8.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l8.[GROUP_NUMBER]
    ,l8.[TERRITORY_ID]
    ,l8.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l8.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	

UNION

select 
	 l7.[GROUP_ID]
    ,l7.[PARENT_ID]
    ,l7.ROOT_GROUP_ID
    ,l7.[GROUP_NAME]
    ,l7.[LEVEL_NUMBER]
	,'LVL_'+l7.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l7.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l7.[GROUP_NUMBER]
    ,l7.[TERRITORY_ID]
    ,l7.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l7.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l7
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	
		) gl 
		on gl.l7_ID=l7.GROUP_ID
	where l7.LEVEL_NUMBER=7


UNION

select 
	 l6.[GROUP_ID]
    ,l6.[PARENT_ID]
    ,l6.ROOT_GROUP_ID
    ,l6.[GROUP_NAME]
    ,l6.[LEVEL_NUMBER]
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l6.[GROUP_NUMBER]
    ,l6.[TERRITORY_ID]
    ,l6.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l6.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l6
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l6_ID=l6.GROUP_ID
	where l6.LEVEL_NUMBER=6


UNION

select 
	 l5.[GROUP_ID]
    ,l5.[PARENT_ID]
    ,l5.ROOT_GROUP_ID
    ,l5.[GROUP_NAME]
    ,l5.[LEVEL_NUMBER]
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l5.[GROUP_NUMBER]
    ,l5.[TERRITORY_ID]
    ,l5.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l5.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l5
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l5_ID=l5.GROUP_ID
	where l5.LEVEL_NUMBER=5

UNION

select 
	 l4.[GROUP_ID]
    ,l4.[PARENT_ID]
    ,l4.ROOT_GROUP_ID
    ,l4.[GROUP_NAME]
    ,l4.[LEVEL_NUMBER]
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l4.[GROUP_NUMBER]
    ,l4.[TERRITORY_ID]
    ,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l4.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l4
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l4_ID=l4.GROUP_ID
	where l4.LEVEL_NUMBER=4

UNION

select 
	 l3.[GROUP_ID]
    ,l3.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l3.[GROUP_NAME]
    ,l3.[LEVEL_NUMBER]
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l3.[GROUP_NUMBER]
    ,l3.[TERRITORY_ID]
    ,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l3.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l3
inner join
	(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l3_ID=l3.GROUP_ID
where l3.LEVEL_NUMBER=3

UNION

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join
	(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l2_ID=l2.GROUP_ID
where l2.LEVEL_NUMBER=2

UNION ----L1

select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1.[ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] AS NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1

end

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DIMOutlet"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 252
               Right = 388
            End
            DisplayFlags = 280
            TopColumn = 15
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBrick'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBrick'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DIMOutlet"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 168
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwOutlet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwOutlet'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[Bases](
	[BaseID] [smallint] NOT NULL,
	[DimensionTypeID] [tinyint] NOT NULL,
	[BaseName] [nvarchar](100) NOT NULL,
	[BaseTable] [nvarchar](100) NOT NULL,
	[LinkField] [nvarchar](100) NULL,
	[PopulationSP] [nvarchar](100) NOT NULL,
	[SubBaseTable] [nvarchar](100) NOT NULL,
	[JoinField] [nvarchar](100) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[BasesFields]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[BasesFields](
	[BaseID] [smallint] NOT NULL,
	[FieldID] [smallint] NOT NULL,
	[FieldName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NULL,
	[DisplayNameForeign] [nvarchar](100) NULL,
	[DataType] [nvarchar](20) NOT NULL,
	[Criteria] [bit] NULL,
	[GroupBy] [bit] NULL,
	[SubBase] [tinyint] NULL,
	[DefGroup] [tinyint] NULL,
	[Link] [tinyint] NULL,
	[Displayed] [bit] NULL,
	[DisplayOrder] [tinyint] NULL,
	[DescriptionField] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[Client]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[Client](
	[ClientID] [smallint] NOT NULL,
	[CorporationID] [smallint] NOT NULL,
	[ClientNo] [smallint] NOT NULL,
	[ClientName] [nvarchar](100) NOT NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[ClientMap]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[ClientMap](
	[ClientId] [int] NULL,
	[IRPClientId] [smallint] NULL,
	[IRPClientNo] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[Dimension]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[Dimension](
	[DimensionID] [smallint] NOT NULL,
	[RefDimensionID] [smallint] NULL,
	[ClientID] [smallint] NOT NULL,
	[DimensionType] [tinyint] NOT NULL,
	[DimensionName] [nvarchar](100) NOT NULL,
	[Levels] [tinyint] NOT NULL,
	[BaseID] [smallint] NOT NULL,
	[Valid] [bit] NOT NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[DimensionBaseMap]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[DimensionBaseMap](
	[DimensionId] [int] NULL,
	[MarketBaseId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[DimensionType]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[DimensionType](
	[DimensionTypeID] [tinyint] NOT NULL,
	[DimensionTypeName] [nvarchar](40) NOT NULL,
	[OptionsTable] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[GeographyDimOptions]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [IRP].[GeographyDimOptions](
	[DimensionID] [smallint] NOT NULL,
	[Unassigned] [bit] NOT NULL,
	[UName] [nvarchar](40) NULL,
	[UChar] [nvarchar](2) NULL,
	[SRAClient] [smallint] NULL,
	[SRASuffix] [char](1) NULL,
	[LD] [tinyint] NULL,
	[AD] [tinyint] NULL,
	[Options] [varchar](100) NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [IRP].[GroupNumberMap]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[GroupNumberMap](
	[Level] [int] NULL,
	[GroupNumber] [nvarchar](10) NULL,
	[CustomGroupNumberSpace] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [IRP].[Items]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[Items](
	[ItemID] [int] NOT NULL,
	[DimensionID] [smallint] NULL,
	[RefItemID] [int] NULL,
	[LevelNo] [int] NULL,
	[Parent] [int] NULL,
	[ItemType] [tinyint] NOT NULL,
	[Number] [nvarchar](40) NOT NULL,
	[ShortName] [nvarchar](40) NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Item] [nvarchar](20) NULL,
	[Visible] [bit] NOT NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[Levels]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[Levels](
	[LevelID] [int] NOT NULL,
	[DimensionID] [smallint] NULL,
	[RefLevelID] [int] NULL,
	[LevelNo] [tinyint] NOT NULL,
	[RefLevelNo] [tinyint] NOT NULL,
	[LevelName] [nvarchar](100) NOT NULL,
	[LevelType] [tinyint] NOT NULL,
	[MaxSiblings] [bigint] NOT NULL,
	[Visible] [bit] NOT NULL,
	[Options] [nvarchar](40) NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE dbo.Groups ADD NewCGN nvarchar(50) NULL
go
ALTER TABLE dbo.Groups Add LevelNo int null
go
ALTER TABLE dbo.MarketDefinitions Add DimensionId int null
go

/****** Object:  StoredProcedure [dbo].[IRPImportMarketDefinition]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportMarketDefinition] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name, D.MarketBaseId, 'dynamic', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
		from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
		where MarketBaseId = @pMarketBaseId
		print(@whereClause)

		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''dynamic'', ' + cast(@marketDefinitionId as varchar) + ', ''dynamic-right'' 
		from DimProduct_Expanded' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end


	drop table #loopTable
	declare @finalQuery varchar(max)
	set @finalQuery = left(@insertStatement+@unionClause, len(@insertStatement+@unionClause) - 6)
	print('Final Query: ' + @finalQuery)
	
	EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks
END


--[dbo].[IRPImportMarketDefinition2] 2150
--[dbo].[IRPImportMarketDefinition2] 3916
--[dbo].[IRPImportMarketDefinition2] 4280
--[dbo].[IRPImportMarketDefinition2] 2812

GO
/****** Object:  StoredProcedure [dbo].[IRPImportMarketDefinition_singleMB]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportMarketDefinition_singleMB] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name, D.MarketBaseId, 'dynamic', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	select @marketBaseId=Id, @marketBaseName=Name 
	from MarketBases M join IRP.DimensionBaseMap D on M.Id = D.MarketBaseId
	where D.DimensionId = @pDimensionId

	declare @whereClause nvarchar(max)
	select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
	from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
	where MarketBaseId = (select MarketBaseId from IRP.DimensionBaseMap where DimensionId = @pDimensionId)
	print(@whereClause)

	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment)
	select Pack_Description, '''+ @marketBaseName +''', ' + cast(@marketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''dynamic'', ' + cast(@marketDefinitionId as varchar) + ', ''dynamic-right'' 
	from DimProduct_Expanded'

	print(@insertStatement+@whereClause)
	EXEC(@insertStatement+@whereClause)

	--select * from MarketDefinitionPacks
END



--[dbo].[IRPImportMarketDefinition] 3916
--[dbo].[IRPImportMarketDefinition] 4280
--[dbo].[IRPImportMarketDefinition] 2812
--[dbo].[IRPImportMarketDefinition] 4605
GO
/****** Object:  StoredProcedure [dbo].[IRPImportMarketDefinition2]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportMarketDefinition2] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	--insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	--insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name, D.MarketBaseId, 'dynamic', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + c.ColumnName + ' in ' + '(' + [Values] +')'  
		from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
		where MarketBaseId = @pMarketBaseId
		print(@whereClause)

		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''dynamic'', ' + cast(@marketDefinitionId as varchar) + ', ''dynamic-right'' 
		from DimProduct_Expanded' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end

	print('Semi-Final Query: ' + @insertStatement + @unionClause)

	drop table #loopTable
	declare @finalQuery varchar(max)
	set @finalQuery = left(@insertStatement+@unionClause, len(@insertStatement+@unionClause) - 6)
	print('Final Query: ' + @finalQuery)
	--EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks
END


--[dbo].[IRPImportMarketDefinition2] 2150
--[dbo].[IRPImportMarketDefinition2] 3916
--[dbo].[IRPImportMarketDefinition2] 4280
--[dbo].[IRPImportMarketDefinition2] 2812

GO
/****** Object:  StoredProcedure [dbo].[IRPImportPackBaseMarketDefinition]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[IRPImportPackBaseMarketDefinition] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name, D.MarketBaseId, 'static', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	select top 1 @marketBaseId=Id, @marketBaseName=Name 
	from MarketBases M join IRP.DimensionBaseMap D on M.Id = D.MarketBaseId
	where D.DimensionId = @pDimensionId

	select  
	CASE WHEN TRY_CONVERT(int, p.item) IS not NULL   
    THEN p.item
    ELSE null  
    END AS FCC
	,p.Name,
	case Charindex(';', g.shortname)
	when 0 then null
	when 1 then null
	else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
	end as groupname,
	case Charindex(';', g.shortname)
	when 0 then null
	when LEN(g.shortname) then null
	else Substring(g.shortname, Charindex(';', g.shortname)+8, LEN(g.shortname))
	end as factor,
	g.number [groupno]
	into #fcctemp
	from irp.items g
	join irp.items p
	on g.itemid = p.parent
	where g.dimensionid = @pDimensionId
	and p.itemtype = 1
	and p.versionto > 0
	
	insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, GroupNumber, GroupName, Factor)
	select p.Pack_Description, @marketBaseName, cast(@marketBaseId as varchar), p.PFC, p.ORG_LONG_NAME, p.ATC4_Code, p.NEC4_Code, 'static', cast(@marketDefinitionId as varchar), 'dynamic-right', f.groupno, f.groupname, f.factor
	from DimProduct_Expanded p
	join #fcctemp f
	on f.fcc = p.fcc

	select count(*) from #fcctemp
	select 'def id:' + cast(@marketDefinitionId as varchar)

	drop table #fcctemp
	

END


GO
/****** Object:  StoredProcedure [dbo].[IRPImportTerritoryCustomGroupNumber]    Script Date: 6/07/2017 6:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[IRPImportTerritoryCustomGroupNumber] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;

declare @IDLen2 int 
declare @IDLen3 int 
declare @IDLen4 int 
declare @IDLen5 int 


-----------------update levels id length------------

	update l
	set l.levelidlength=B.length
	from levels l
	join 
	(
	select levelid,levelno, [end] - start + 1 length from
	(
		   select *, cast(substring(Options, 7, 1) as int) start, cast(right(Options, 1) as int) 'end'
		   from IRP.Levels 
		   where 
		   options <> '' and 
		   dimensionid = @pTerritoryId and 
		   versionto > 0
	)A)B
	on l.id=b.levelid
	and l.levelnumber=B.levelno
	where l.levelnumber > 1
-------------------------------------------------------------------------

select @IDLen2=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=2
select @IDLen3=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=3
select @IDLen4=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=4
select @IDLen5=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=5

------------------level 2-------------------------------------------------------

update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, replace(Number, '-','') cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 2)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

------------------level 3-------------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 3)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

--------------------level 4-----------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + 1, @IDLen4) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 4)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

--------------------level 5-----------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + 1, @IDLen4) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + @IDLen4 + 1, @IDLen5) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 5)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

-------update nodecode from Items---------
--update o
--set o.nodecode=replace(i.number,'-','')
--from outletbrickallocations o
--join IRP.Items i
--on o.territoryid=i.dimensionid
--and o.brickoutletcode=i.Item
--where o.territoryid=@pTerritoryId

--update o
--set o.nodecode=g.customgroupnumberspace
--from outletbrickallocations o
--join groups g
--on o.territoryid=g.territoryid
--and o.nodecode=g.customgroupnumber
--where o.territoryid=@pTerritoryId

update o
set o.NodeCode = g.NewCGN
from OutletBrickAllocations o join Groups g on o.TerritoryId = g.TerritoryId and o.NodeCode = g.CustomGroupNumberSpace
where o.TerritoryId = @pTerritoryId

update Groups set CustomGroupNumberSpace = NewCGN 
where TerritoryId = @pTerritoryId


END


--exec [dbo].[IRPImportTerritoryDefinition_Groups] 3989



GO
--exec [dbo].[IRPImportTerritoryDefinition] 3249
--exec [dbo].[IRPImportTerritoryDefinition] 66
--exec [dbo].[IRPImportTerritoryDefinition] 78
--exec [dbo].[IRPImportTerritoryDefinition] 1247
--exec [dbo].[IRPImportTerritoryDefinition] 847
--exec [dbo].[IRPImportTerritoryDefinition] 1229
--exec [dbo].[IRPImportTerritoryDefinition] 3198
--exec [dbo].[IRPImportTerritoryDefinition] 1319
--exec [dbo].[IRPImportTerritoryDefinition] 3994
--exec [dbo].[IRPImportTerritoryDefinition] 1631



GO

