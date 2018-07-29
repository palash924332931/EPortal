USE [master]
GO
/****** Object:  Database [EverestClientPortal]    Script Date: 20-Jan-17 11:30:26 AM ******/
CREATE DATABASE [EverestClientPortal]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EverestClientPortal', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\EverestClientPortal.mdf' , SIZE = 132288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'EverestClientPortal_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\EverestClientPortal_log.ldf' , SIZE = 138496KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [EverestClientPortal] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EverestClientPortal].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EverestClientPortal] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EverestClientPortal] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EverestClientPortal] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EverestClientPortal] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EverestClientPortal] SET ARITHABORT OFF 
GO
ALTER DATABASE [EverestClientPortal] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [EverestClientPortal] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EverestClientPortal] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EverestClientPortal] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EverestClientPortal] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [EverestClientPortal] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EverestClientPortal] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EverestClientPortal] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EverestClientPortal] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EverestClientPortal] SET  ENABLE_BROKER 
GO
ALTER DATABASE [EverestClientPortal] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EverestClientPortal] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EverestClientPortal] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EverestClientPortal] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [EverestClientPortal] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EverestClientPortal] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [EverestClientPortal] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EverestClientPortal] SET RECOVERY FULL 
GO
ALTER DATABASE [EverestClientPortal] SET  MULTI_USER 
GO
ALTER DATABASE [EverestClientPortal] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [EverestClientPortal] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EverestClientPortal] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [EverestClientPortal] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [EverestClientPortal] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'EverestClientPortal', N'ON'
GO
USE [EverestClientPortal]
GO
/****** Object:  Table [dbo].[AdditionalFilters]    Script Date: 20-Jan-17 11:30:34 AM ******/
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
/****** Object:  Table [dbo].[BaseFilters]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
 CONSTRAINT [PK_dbo.BaseFilters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CADPages]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[ClientMarketBases]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[Clients]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[IsMyClient] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Clients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIMProduct_Expanded]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
	[Pack_Description] [varchar](64) NULL,
	[Pack_Long_Name] [varchar](194) NULL,
	[FCC] [int] NULL,
	[ATC1_Code] [varchar](5) NULL,
	[ATC1_Desc] [varchar](25) NULL,
	[ATC2_Code] [varchar](5) NULL,
	[ATC2_Desc] [nvarchar](25) NULL,
	[ATC3_Code] [varchar](5) NULL,
	[ATC3_Desc] [nvarchar](25) NULL,
	[ATC4_Code] [varchar](5) NULL,
	[ATC4_Desc] [nvarchar](25) NULL,
	[NEC1_Code] [varchar](12) NULL,
	[NEC1_Desc] [varchar](30) NULL,
	[NEC1_LongDesc] [varchar](80) NULL,
	[NEC2_Code] [varchar](12) NULL,
	[NEC2_desc] [varchar](30) NULL,
	[NEC2_LongDesc] [varchar](80) NULL,
	[NEC3_Code] [varchar](12) NULL,
	[NEC3_Desc] [varchar](30) NULL,
	[NEC3_LongDesc] [varchar](80) NULL,
	[NEC4_Code] [varchar](12) NULL,
	[NEC4_Desc] [varchar](30) NULL,
	[NEC4_LongDesc] [varchar](80) NULL,
	[CH_Segment_Code] [varchar](3) NULL,
	[CH_Segment_Desc] [varchar](20) NULL,
	[WHO1_Code] [varchar](12) NULL,
	[WHO1_Desc] [varchar](30) NULL,
	[WHO2_Code] [varchar](12) NULL,
	[WHO2_Desc] [varchar](30) NULL,
	[WHO3_Code] [varchar](12) NULL,
	[WHO3_Desc] [varchar](30) NULL,
	[WHO4_Code] [varchar](12) NULL,
	[WHO4_Desc] [varchar](30) NULL,
	[WHO5_Code] [varchar](12) NULL,
	[WHO5_Desc] [varchar](30) NULL,
	[FRM_Flgs1] [char](1) NULL,
	[FRM_Flgs1_Desc] [varchar](50) NULL,
	[FRM_Flgs2] [char](1) NULL,
	[FRM_Flgs2_Desc] [varchar](50) NULL,
	[FRM_Flgs3] [char](1) NULL,
	[Frm_Flgs3_Desc] [varchar](50) NULL,
	[FRM_Flgs4] [char](1) NULL,
	[FRM_Flgs4_Desc] [varchar](50) NULL,
	[FRM_Flgs5] [char](1) NULL,
	[FRM_Flgs5_Desc] [varchar](50) NULL,
	[FRM_Flgs6] [char](1) NULL,
	[Compound_Indicator] [varchar](12) NULL,
	[Compound_Ind_Desc] [varchar](15) NULL,
	[PBS_Formulary] [varchar](12) NULL,
	[PBS_Formulary_Date] [datetime] NULL,
	[Poison_Schedule] [varchar](12) NULL,
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
	[PackLaunch] [datetime] NULL,
	[Prod_lch] [datetime] NULL,
	[Org_Code] [int] NULL,
	[Org_Abbr] [varchar](3) NULL,
	[Org_Short_Name] [varchar](18) NULL,
	[Org_Long_Name] [varchar](80) NULL,
	[Out_td_dt] [datetime] NULL,
	[Prtd_Price] [smallmoney] NULL,
	[pk_size] [int] NULL,
	[vol_wt_uns] [real] NULL,
	[vol_wt_meas] [varchar](2) NULL,
	[strgh_uns] [real] NULL,
	[strgh_meas] [varchar](2) NULL,
	[Conc_Unit] [numeric](18, 2) NULL,
	[Conc_Meas] [varchar](5) NULL,
	[Additional_Strength] [varchar](4) NULL,
	[Additional_Pack_Info] [varchar](4) NULL,
	[Recommended_Retail_Price] [numeric](18, 2) NULL,
	[Ret_Price_Effective_Date] [datetime] NULL,
	[Editable_Pack_Description] [varchar](80) NULL,
	[APN] [varchar](18) NULL,
	[Trade_Product_Pack_ID] [varchar](18) NULL,
	[Form_Desc_Abbr] [varchar](12) NULL,
	[Form_Desc_Short] [varchar](30) NULL,
	[Form_Desc_Long] [varchar](80) NULL,
	[NFC1_Code] [nvarchar](1) NULL,
	[NFC1_Desc] [nvarchar](30) NULL,
	[NFC2_Code] [nvarchar](2) NULL,
	[NFC2_Desc] [nvarchar](30) NULL,
	[NFC3_Code] [nvarchar](3) NULL,
	[NFC3_Desc] [nvarchar](30) NULL,
	[Price_Effective_Date] [datetime] NULL,
	[Last_amd] [datetime] NULL,
	[PBS_Start_Date] [datetime] NULL,
	[PBS_End_Date] [datetime] NULL,
	[Supplier_Code] [numeric](15, 0) NULL,
	[Supplier_Product_Code] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DMMolecule]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DMMolecule](
	[FCC] [int] NULL,
	[Molecule] [int] NOT NULL,
	[Synonym] [tinyint] NOT NULL,
	[Parent] [int] NOT NULL,
	[Description] [varchar](70) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[GroupIdPrefix] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[Parent_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Levels]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Levels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Parent_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Levels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Listings]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[MarketBases]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketBases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.MarketBases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitionBaseMaps]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[MarketDefinitionPacks]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitionPacks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Pack] [nvarchar](max) NULL,
	[MarketBase] [nvarchar](max) NULL,
	[GroupNumber] [nvarchar](max) NULL,
	[GroupName] [nvarchar](max) NULL,
	[Factor] [nvarchar](max) NULL,
	[PFC] [nvarchar](max) NULL,
	[Manufacturer] [nvarchar](max) NULL,
	[ATC4] [nvarchar](max) NULL,
	[NEC4] [nvarchar](max) NULL,
	[DataRefreshType] [nvarchar](max) NULL,
	[MarketDefinitionId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.MarketDefinitionPacks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitions]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketDefinitions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.MarketDefinitions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MonthlyDataSummaries]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[MonthlyNewproducts]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[NewsAlerts]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[PackMarketBases]    Script Date: 20-Jan-17 11:30:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackMarketBases](
	[PackId] [int] NOT NULL,
	[MarketBaseId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PopularLinks]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
/****** Object:  Table [dbo].[Territories]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
 CONSTRAINT [PK_dbo.Territories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

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
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id] FOREIGN KEY([Parent_Id])
REFERENCES [dbo].[Groups] ([id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id]
GO
ALTER TABLE [dbo].[Levels]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Levels_dbo.Levels_Parent_Id] FOREIGN KEY([Parent_Id])
REFERENCES [dbo].[Levels] ([Id])
GO
ALTER TABLE [dbo].[Levels] CHECK CONSTRAINT [FK_dbo.Levels_dbo.Levels_Parent_Id]
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
ALTER TABLE [dbo].[PackMarketBases]  WITH CHECK ADD FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
GO
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Territories_dbo.Groups_RootGroup_id] FOREIGN KEY([RootGroup_id])
REFERENCES [dbo].[Groups] ([id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_dbo.Territories_dbo.Groups_RootGroup_id]
GO
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Territories_dbo.Levels_RootLevel_Id] FOREIGN KEY([RootLevel_Id])
REFERENCES [dbo].[Levels] ([Id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_dbo.Territories_dbo.Levels_RootLevel_Id]
GO
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_Clients] FOREIGN KEY([Client_id])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_Territories_Clients]
GO
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_Territories] FOREIGN KEY([Id])
REFERENCES [dbo].[Territories] ([Id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_Territories_Territories]
GO
/****** Object:  StoredProcedure [dbo].[GetClientMarketBase]    Script Date: 20-Jan-17 11:30:35 AM ******/
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
	  ,MB.Name MarketBaseName
	  ,MB.Description 
	  ,BF.[Id] BaseFilterId
      ,BF.[Name] BaseFilterName
      ,BF.[Criteria] BaseFilterCriteria
      ,BF.[Values] BaseFilterValues
	  ,BF.IsEnabled BaseFilterIsEnabled
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
USE [master]
GO
ALTER DATABASE [EverestClientPortal] SET  READ_WRITE 
GO
