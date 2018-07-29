
/****** Object:  StoredProcedure [dbo].[DBScript_InitTables]    Script Date: 10/11/2017 14:47:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[z_ChangeFieldLength]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[z_ChangeFieldLength]
GO

create PROCEDURE [dbo].[z_ChangeFieldLength]
AS
Begin
alter table   [dbo].[MarketDefinitions]
  alter column Name nvarchar(500)
  
  alter table   [dbo].[MarketDefinitions]
  alter column [Description] nvarchar(800)
  
  alter table   [dbo].[MarketDefinitions]
  alter column [GuiId] nvarchar(80)
  ----------------------------
  alter table   dbo.MarketDefinitionPacks
  alter column Pack nvarchar(200)
  
  alter table   dbo.MarketDefinitionPacks
  alter column MarketBase nvarchar(200)
  
  alter table   dbo.MarketDefinitionPacks
  alter column MarketBaseId nvarchar(20)
  
  alter table   dbo.MarketDefinitionPacks
  alter column GroupNumber nvarchar(50)
  
  alter table   dbo.MarketDefinitionPacks
  alter column GroupName nvarchar(200)
  
  alter table   dbo.MarketDefinitionPacks
  alter column Factor nvarchar(20)
  
  alter table   dbo.MarketDefinitionPacks
  alter column PFC nvarchar(20)
  
  alter table   dbo.MarketDefinitionPacks
  alter column Manufacturer nvarchar(200)
  
  alter table   dbo.MarketDefinitionPacks
  alter column ATC4 nvarchar(10)
  
  alter table   dbo.MarketDefinitionPacks
  alter column NEC4 nvarchar(10)
  
  alter table   dbo.MarketDefinitionPacks
  alter column DataRefreshType nvarchar(20)
  
  alter table   dbo.MarketDefinitionPacks
  alter column StateStatus nvarchar(20)
  
  alter table   dbo.MarketDefinitionPacks
  alter column  Alignment nvarchar(20)
  
   alter table   dbo.MarketDefinitionPacks
  alter column Product  nvarchar(200)
  
   alter table   dbo.MarketDefinitionPacks
  alter column   Molecule nvarchar(3000)
  ----------------------------
  alter table   dbo.MarketDefinitionBaseMaps
  alter column Name  nvarchar(200)
  
   alter table   dbo.MarketDefinitionBaseMaps
  alter column  DataRefreshType  nvarchar(20)
  
  ----------------------------
  alter table   dbo.MarketBases
  alter column Name  nvarchar(200)
  
  alter table   dbo.MarketBases
  alter column  [Description]  nvarchar(200)
  
  alter table   dbo.MarketBases
  alter column  Suffix  nvarchar(30)
  
  alter table   dbo.MarketBases
  alter column  DurationTo  nvarchar(20)
  
  alter table   dbo.MarketBases
  alter column   DurationFrom nvarchar(20)
  
  alter table   dbo.MarketBases
  alter column  GuiId  nvarchar(80)
  
  alter table   dbo.MarketBases
  alter column  BaseType  nvarchar(50)
  
  ----------------------------
   alter table   dbo.BaseFilters
  alter column Name  nvarchar(100)
  
  alter table   dbo.BaseFilters
  alter column   Criteria nvarchar(100)
  
  alter table   dbo.BaseFilters
  alter column   [Values] nvarchar(800)
  ----------------------------
  alter table   dbo.AccessPrivilege
  alter column AccessPrivilegeName  nvarchar(50)
  
  alter table   dbo.[Action]
  alter column  ActionName  nvarchar(300)
  
  ----------------------------
  alter table   dbo.AdditionalFilters
  alter column Name  nvarchar(100)
  
  alter table   dbo.AdditionalFilters
  alter column   Criteria nvarchar(80)
  
  alter table   dbo.AdditionalFilters
  alter column  [Values]  nvarchar(200)
  
  ----------------------------
  alter table   dbo.CADPages
  alter column cadPageTitle  nvarchar(300)
  
  alter table   dbo.CADPages
  alter column  cadPageDescription  nvarchar(1000)
  
  alter table   dbo.CADPages
  alter column  cadPagePharmacyFileUrl  nvarchar(300)
  
  alter table   dbo.CADPages
  alter column  cadPageHospitalFileUrl  nvarchar(300)
  
  alter table   dbo.CADPages
  alter column  cadPageCreatedBy  nvarchar(50)
  
  alter table   dbo.CADPages
  alter column  cadPageModifiedBy  nvarchar(50)
  
  ----------------------------
  alter table   dbo.MonthlyDataSummaries
  alter column monthlyDataSummaryTitle  nvarchar(300)
  
  alter table   dbo.MonthlyDataSummaries
  alter column  monthlyDataSummaryDescription  nvarchar(1000)
  
  alter table   dbo.MonthlyDataSummaries
  alter column  monthlyDataSummaryFileUrl  nvarchar(300)
   
  alter table   dbo.MonthlyDataSummaries
  alter column  monthlyDataSummaryCreatedBy  nvarchar(50)
  
  alter table   dbo.MonthlyDataSummaries
  alter column  monthlyDataSummaryModifiedBy  nvarchar(50)
  
  ----------------------------
  alter table   dbo.MonthlyNewproducts
  alter column   monthlyNewProductTitle nvarchar(300)
  
  alter table   dbo.MonthlyNewproducts
  alter column   monthlyNewProductDescription nvarchar(1000)
  
  alter table   dbo.MonthlyNewproducts
  alter column  monthlyNewProductFileUrl  nvarchar(300)
   
  alter table   dbo.MonthlyNewproducts
  alter column   monthlyNewProductCreatedBy nvarchar(50)
  
  alter table   dbo.MonthlyNewproducts
  alter column  monthlyNewProductModifiedBy  nvarchar(50)
    
  ----------------------------
  alter table   dbo.NewsAlerts
  alter column  newsAlertTitle  nvarchar(300)
  
  alter table   dbo.NewsAlerts
  alter column   newsAlertDescription nvarchar(1000)
  
  alter table   dbo.NewsAlerts
  alter column   newsAlertImageUrl nvarchar(300)
   
  alter table   dbo.NewsAlerts
  alter column   newsAlertCreatedBy nvarchar(50)
  
  alter table   dbo.NewsAlerts
  alter column   newsAlertModifiedBy nvarchar(50)
    ----------------------------
  alter table   dbo.PopularLinks
  alter column  popularLinkTitle  nvarchar(300)
  
  alter table   dbo.PopularLinks
  alter column   popularLinkDescription nvarchar(1000)
    
  alter table   dbo.PopularLinks
  alter column  popularLinkCreatedBy  nvarchar(50)
  
  alter table   dbo.PopularLinks
  alter column  popularLinkModifiedBy  nvarchar(50)
    ----------------------------
  alter table   dbo.Clients
  alter column  [Name]  nvarchar(300)
  
  alter table  dbo.Country
  alter column  [Name]  nvarchar(80)
  
   alter table  dbo.Country
  alter column  ISOCode  nvarchar(30)
  
  alter table dbo.DataType 
  alter column  [Name] nvarchar(80)
  
  alter table  dbo.DeliveryType
  alter column  [Name] nvarchar(80)
  
  alter table  dbo.[File]
  alter column  [Name] nvarchar(80)
    
  alter table  dbo.[FileType]
  alter column  [Name] nvarchar(20)
  
  alter table  dbo.Frequency
  alter column  [Name] nvarchar(300)
  
  alter table  dbo.FrequencyType
  alter column  [Name] nvarchar(50)
  
  alter table  dbo.FrequencyType
  alter column DefaultYears  nvarchar(10)
  
  --------------------------------------
  alter table  dbo.Groups
  alter column Name  nvarchar(200)
  
  alter table  dbo.Groups
  alter column GroupNumber  nvarchar(20)
  
  alter table  dbo.Groups
  alter column  CustomGroupNumber nvarchar(20)
  
  alter table  dbo.Groups
  alter column  ParentGroupNumber nvarchar(20)
  
  alter table  dbo.Groups
  alter column CustomGroupNumberSpace  nvarchar(20)
  
  --------------------------------------
  alter table  dbo.Groups2
  alter column Name  nvarchar(200)
  
  alter table  dbo.Groups2
  alter column GroupNumber  nvarchar(20)
  
  alter table  dbo.Groups2
  alter column  CustomGroupNumber nvarchar(20)
  
   --------------------------------------
  alter table  dbo.Levels
  alter column Name  nvarchar(200)
  
  alter table  dbo.Levels
  alter column  LevelColor nvarchar(20)
  
  alter table  dbo.Levels
  alter column BackgroundColor  nvarchar(20)
  
   ----------------------------
  alter table   dbo.Listings
  alter column  listingTitle  nvarchar(300)
  
  alter table   dbo.Listings
  alter column   listingDescription nvarchar(1000)
  
  alter table   dbo.Listings
  alter column   listingPharmacyFileUrl nvarchar(300)
   
  alter table   dbo.Listings
  alter column   listingHospitalFileUrl nvarchar(50)
  
  alter table   dbo.Listings
  alter column  listingCreatedBy  nvarchar(50)
  
   alter table   dbo.Listings
  alter column   listingModifiedBy nvarchar(50)
  
  --------------------
  alter table   dbo.Restriction
  alter column Name   nvarchar(200)
  
  alter table   dbo.[Role]
  alter column   RoleName nvarchar(80)
  
   --------------------
  alter table   dbo.Section
  alter column SectionName   nvarchar(150)
  
   --------------------
  alter table   dbo.[Service]
  alter column  Name  nvarchar(150)
  
   alter table   dbo.ServiceTerritory
  alter column   TerritoryBase nvarchar(150)
  
   --------------------
  alter table dbo.[Source]
  alter column Name   nvarchar(60)
  --subscription
  alter table dbo.Subscription
  alter column Name   nvarchar(200)
  
  alter table dbo.Subscription
  alter column   Country nvarchar(80)
  
  alter table dbo.Subscription
  alter column  [Service]  nvarchar(60)
  
  alter table dbo.Subscription
  alter column  Data  nvarchar(80)
  
  alter table dbo.Subscription
  alter column [Source]   nvarchar(80)
  
  alter table dbo.tblOutlet
  alter column [Address]   nvarchar(500)
    --------------------
  alter table dbo.Territories
  alter column Name   nvarchar(200)
  
   alter table dbo.Territories
  alter column GuiId   nvarchar(60)
  
  End  
  

exec [dbo].[z_ChangeFieldLength]

Go

