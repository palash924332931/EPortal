IF NOT EXISTS (SELECT * FROM sys.objects WHERE name like '%TYP_MarketDefinitionPacks%')
BEGIN
CREATE TYPE [dbo].[TYP_MarketDefinitionPacks] AS TABLE(
    [Pack] [nvarchar](500) NULL,
    [MarketBase] [nvarchar](500) NULL,
    [MarketBaseId] [nvarchar](500) NULL,
    [GroupNumber] [nvarchar](500) NULL,
    [GroupName] [nvarchar](500) NULL,
    [Factor] [nvarchar](500) NULL,
    [PFC] [nvarchar](500) NULL,
    [Manufacturer] [nvarchar](500) NULL,
    [ATC4] [nvarchar](500) NULL,
    [NEC4] [nvarchar](500) NULL,
    [DataRefreshType] [nvarchar](500) NULL,
    [StateStatus] [nvarchar](500) NULL,
    [MarketDefinitionId] [int] NOT NULL,
    [Alignment] [nvarchar](500) NULL,
    [Product] [nvarchar](500) NULL,
    [ChangeFlag] [nchar](1) NULL,
    [Molecule] [nvarchar](500) NULL
)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name like '%TYP_OutletBrickAllocations%')
BEGIN
CREATE TYPE [dbo].[TYP_OutletBrickAllocations] AS TABLE(
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
    [TerritoryId] [int] NOT NULL
 )
 END
 GO


/****** Object:  StoredProcedure [dbo].[EditMarketDefinition]    Script Date: 21/12/2017 5:34:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'EditMarketDefinition')
DROP PROCEDURE [dbo].[EditMarketDefinition]
GO 


CREATE PROCEDURE [dbo].[EditMarketDefinition]
(
	@marketdefinitionid int,
    @TVP TYP_MarketDefinitionPacks READONLY
	)
    AS
    SET NOCOUNT ON
	begin transaction
		delete from marketdefinitionpacks where marketdefinitionid = @marketdefinitionid
		insert into marketdefinitionpacks select * from @TVP 
	commit

GO

/****** Object:  StoredProcedure [dbo].[EditOutletBrickAllocations]    Script Date: 21/12/2017 5:43:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'EditOutletBrickAllocations')
DROP PROCEDURE [dbo].[EditOutletBrickAllocations]
GO 


CREATE PROCEDURE [dbo].[EditOutletBrickAllocations]
	@territoryID int,
    @TVP TYP_OutletBrickAllocations READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from OutletBrickAllocations where territoryID = @territoryID
		insert into OutletBrickAllocations select * from @TVP 
	commit

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'z_ChangeFieldLength')
DROP PROCEDURE [dbo].[z_ChangeFieldLength]
GO 

CREATE PROCEDURE [dbo].[z_ChangeFieldLength]
AS

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

GO



/****** Object:  StoredProcedure [dbo].[IRPImportDeliverablesIAM]    Script Date: 10/01/2018 2:51:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[IRPImportDeliverablesIAM]
( @ClientNo int)
As
BEGIN
	--Declare @ClientNo int
	--set @ClientNo=138
	DECLARE @RowsToProcess  int,@RP int
	DECLARE @CurrentRow     int,@CR int

	DECLARE @RptNo  int,@ClientId  int,@ClientName varchar(500),@bkt_Sel varchar(100),@cat_Sel varchar(100),@RptId int,@RptName varchar(500)
	DECLARE @Value int,@writerParamId int,@WriterId int
	DECLARE @FreqType int,@FreqId int, @Period varchar(50), @Service varchar(100),@DataType varchar(100), @Source varchar(100),@DeliveryType varchar(100),@ReportWriterCode varchar(50)
	
	DECLARE @Deliverables TABLE (RowID int not null primary key identity(1,1), clientid int,ClientName varchar(100), 
	FreqType int,Frequency int, Period varchar(100), [Service] varchar(100),DataType varchar(100), Source varchar(100),ReportWriter varchar(50),country varchar(10),deliveryType varchar(100),reportId varchar(100)
	 )
	set @DeliveryType='IAM'

	DECLARE @table1 TABLE (RowID int not null primary key identity(1,1), clientno int, ReportID int,ReportNo int, ReportName varchar(500),WriterID int  ) 
	--Get Client Id
	 --Select @ClientId = ClientID, @ClientName = ClientName from IRP.Client where ClientNo=@ClientNo and VersionTo=32767
	 --Select @ClientId = irpClientId, @ClientName = Name from dbo.Clients where irpClientNo=@ClientNo 
	 
Select  @ClientId =irpclientid, @ClientName =Name from dbo.Clients where id in (
select clientID from irp.ClientMap where IRPClientNo = @ClientNo )
	 Print @ClientId
	 Print @ClientName
	INSERT into @table1 (clientno,ReportID,ReportNo,ReportName,WriterID) 
	SELECT  ClientID,ReportID,ReportNo,ReportName,WriterID FROM IRP.Report where ClientID = @ClientId and VersionTo=32767 and ReportNo <> 0 


	SET @RowsToProcess=@@ROWCOUNT

	SET @CurrentRow=0
	WHILE @CurrentRow<@RowsToProcess
	BEGIN
		SET @CurrentRow=@CurrentRow+1
		SELECT @RptId=ReportID, @RptName = ReportName,@WriterId= writerid FROM @table1 WHERE RowID=@CurrentRow
			
			--Report writer
			select @ReportWriterCode = WriterCode from IRP.Writer where writerid=@WriterId
			--print @WriterId + @ReportWriterCode
			-- frequency
			set @Value=-999
			select @Value=Value, @writerParamId = WriterParameterID from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='Delivery'
			set @FreqType = 0
			set @FreqId =0
			if @Value = 0 
				begin
				set @FreqType = 1
				set @FreqId =1
				end
			else if @Value= 1 or @Value= 2 or @Value= 3
				begin 
				set @FreqType = 2  
				if @Value= 1 set @FreqId =4
				if @Value= 2 set @FreqId =3
				if @Value= 3 set @FreqId =2
				end
			else if @Value= 22 or @Value= 23 or @Value= 24 or  @Value= 25
				begin
				set @FreqType = 3
				if @Value= 22 set @FreqId =8
				if @Value= 23 set @FreqId =7
				if @Value= 24 set @FreqId =6
				if @Value= 25 set @FreqId =5
				end
			else if @Value= 4 or @Value= 5 or @Value= 6 or @Value= 7 or @Value= 8 or @Value= 9
				begin
				set @FreqType = 4
				if @Value= 4 set @FreqId =14
				if @Value= 5 set @FreqId =13
				if @Value= 6 set @FreqId =12
				if @Value= 7 set @FreqId =11
				if @Value= 8 set @FreqId =10
				if @Value= 9 set @FreqId =9
				end
			else if @Value= 10 or @Value= 11 or @Value= 12 or @Value= 13 or @Value= 14 or @Value= 15 or @Value= 16 or @Value= 17 or @Value= 18 or @Value= 19 or @Value= 20 or @Value= 21
				begin
				set @FreqType = 5
				if @Value= 10 set @FreqId =26
				if @Value= 11 set @FreqId =25
				if @Value= 12 set @FreqId =24
				if @Value= 13 set @FreqId =23
				if @Value= 14 set @FreqId =22
				if @Value= 15 set @FreqId =21
				if @Value= 16 set @FreqId =20
				if @Value= 17 set @FreqId =19
				if @Value= 18 set @FreqId =18
				if @Value= 19 set @FreqId =17
				if @Value= 20 set @FreqId =16
				if @Value= 21 set @FreqId =15
				end
			else 
				begin
				set @FreqType = 6
				set @FreqId =27
				end
			-- Source
			Set @source ='Sell In'
			----
			--set @Value=0
			--select @Value=Value, @writerParamId = WriterParameterID from dbo.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='ProbePack'
			--select @Service= DimensionName from dbo.Dimension where dimensiontype= 2 and DimensionID = @Value
			-- Service
			set @Value=0
			select @Service=Name from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='ProbePack'
			--select @Service= DimensionName from dbo.Dimension where dimensiontype= 2 and DimensionID = @Value
			if @Service = 'NO PROBE'
				set @Service = 'Profit'
			else if @Service = 'PROBE Packs Manufacturer' or @Service ='PROBE Packs Exceptions'
			BEGIN

				Declare @PFCDifference int
				set @PFCDifference = -1

				select @PFCDifference = Count(pfc) from (
				(select c.ClientName, rp.ReportID, p.PFC from irp.ReportParameter rp
				join irp.Report r on r.ReportID = rp.ReportID
				join irp.Client c on c.ClientID = r.ClientID
				join irp.Dimension d on d.DimensionID = rp.Value
				join irp.Items i on i.DimensionID = d.DimensionID
				join DIMProduct_Expanded p on i.Item = p.Org_Abbr
				where c.ClientID = @clientid and
				c.VersionTo = 32767 and r.VersionTo = 32767 and rp.VersionTo = 32767  and d.VersionTo = 32767 and i.VersionTo = 32767
				and (code = 'DimProd')
				and d.BaseID = 16
				and i.Item is not null
				UNION
				select c.ClientName, rp.ReportID, p.PFC from irp.ReportParameter rp
				join irp.Report r on r.ReportID = rp.ReportID
				join irp.Client c on c.ClientID = r.ClientID
				join irp.Dimension d on d.DimensionID = rp.Value
				join irp.Items i on i.DimensionID = d.DimensionID
				join DIMProduct_Expanded p on i.Item = p.ATC4_Code
				where c.ClientID = @clientid and
				c.VersionTo = 32767 and r.VersionTo = 32767 and rp.VersionTo = 32767  and d.VersionTo = 32767 and i.VersionTo = 32767
				and (code = 'DimProd')
				and d.BaseID = 5
				and i.Item is not null
				UNION
				select c.ClientName, rp.ReportID, p.PFC from irp.ReportParameter rp
				join irp.Report r on r.ReportID = rp.ReportID
				join irp.Client c on c.ClientID = r.ClientID
				join irp.Dimension d on d.DimensionID = rp.Value
				join irp.Items i on i.DimensionID = d.DimensionID
				join DIMProduct_Expanded p on i.Item = convert(varchar, p.fcc)
				where c.ClientID = @clientid and
				c.VersionTo = 32767 and r.VersionTo = 32767 and rp.VersionTo = 32767  and d.VersionTo = 32767 and i.VersionTo = 32767
				and (code = 'DimProd')
				and d.BaseID = 4
				and i.Item is not null
				)
				EXCEPT
				(
				--probe pack mfr
				select c.ClientName, rp.ReportID, p.PFC from irp.ReportParameter rp
				join irp.Report r on r.ReportID = rp.ReportID
				join irp.Client c on c.ClientID = r.ClientID
				join irp.Dimension d on d.DimensionID = rp.Value
				join irp.Items i on i.DimensionID = d.DimensionID
				join DIMProduct_Expanded p on i.Item = p.Org_Abbr
				where c.ClientID = @clientid and
				c.VersionTo = 32767 and r.VersionTo = 32767 and rp.VersionTo = 32767  and d.VersionTo = 32767 and i.VersionTo = 32767
				and (rp.code = 'ProbePack')
				and d.BaseID = 16
				and i.Item is not null
				UNION
				--probe pack exceptions
				select c.ClientName, rp.ReportID, p.PFC from irp.ReportParameter rp
				join irp.Report r on r.ReportID = rp.ReportID
				join irp.Client c on c.ClientID = r.ClientID
				join irp.Dimension d on d.DimensionID = rp.Value
				join irp.Items i on i.DimensionID = d.DimensionID
				join DIMProduct_Expanded p on i.Item = convert(varchar, p.fcc)
				where c.ClientID = @clientid and
				c.VersionTo = 32767 and r.VersionTo = 32767 and rp.VersionTo = 32767  and d.VersionTo = 32767 and i.VersionTo = 32767
				and (code = 'ProbePack')
				and d.BaseID = 4
				and i.Item is not null
				)) packs
				join irp.Report r on packs.ReportID = r.reportid
				group by r.ReportId, ClientName, r.ReportName
				order by ClientName

				
				if (@PFCDifference > 0) 
					SET @Service = 'PROFITS+PROBE'
				ELSE 
					set @Service = 'PROBE'

			END
			--else
			--	set @Service = 'Probe'
			--
			set @Value=0
			select @Value=Value, @writerParamId = WriterParameterID from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='DimChannel'
			select @DataType= DimensionName from IRP.Dimension where dimensiontype= 4 and DimensionID = @Value
			set @DataType =  LEFT(@DataType, CHARINDEX('Channel', @DataType) - 1)
			set @DataType =  replace(@DataType,'Combined',' Retail + Hospital')
			
			--Period
			set @Value=0
			select @Value=Value, @writerParamId = WriterParameterID from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='DimPeri'
			DECLARE @string varchar(100),@start int,@end int,@len int
			select @string = DimensionName from IRP.Dimension where dimensiontype= 3 and DimensionID = @Value
			
			set @string = replace(@string, ' ' , '')
			set @len = len(@string)
			set @start = PATINDEX('%[0-9]%',@string)
			set @end = PATINDEX('%[^0-9]%',substring(@string, @start, @len))-1
			print substring(@string, @start, @end)
			if left(SUBSTRING(@string,PATINDEX('%[0-9]%',@string)+2,5),5) = 'month'
			begin 
				SET @Period = cast(cast(substring(@string, @start, @end) as int)/12 as varchar) + ' Years'
			end
			else
			begin
				select @Period= substring(@string, @start, @end) + ' ' + SUBSTRING(@string,PATINDEX('%[0-9]%',@string)+2,5)
			end
			
			
		
		--insert into @Deliverables(clientid,ClientName,FreqType,Frequency, Period, [Service],DataType,Source,ReportWriter,country,deliveryType )
			--values (@ClientId,@ClientName, @FreqType,@FreqId,@Period,@Service,@DataType,@Source,@ReportWriterCode,'AUS',@DeliveryType)

			insert into @Deliverables(clientid,ClientName,FreqType,Frequency, Period, [Service],DataType,Source,ReportWriter,country,deliveryType,reportId )
			values (@ClientId,@ClientName, @FreqType,@FreqId,@Period,@Service,@DataType,@Source,@ReportWriterCode,'AUS',@DeliveryType,@RptId)
		

	END	

	insert into dbo.IRG_Deliverables_IAM
	select * from @Deliverables

	--select * from IRG_Deliverables_IAM
-- Insert records into subscription & deliverables from IRG_Deliverables_IAM table
	
	
	execute dbo.IRPProcessDeliverablesIAM
	
	delete from dbo.IRG_Deliverables_IAM where Clientid=@ClientId

	
END

GO