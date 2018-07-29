
/****** Object:  Schema [IRP]    Script Date: 25/09/2017 10:44:14 PM ******/
CREATE SCHEMA [IRP]
GO
/****** Object:  Schema [SERVICE]    Script Date: 25/09/2017 10:44:14 PM ******/
CREATE SCHEMA [SERVICE]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDefaultStartDate]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[IRPProcessDeliverablesIAM]
As
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
	Select ClientName,[Service],Country,DataType,Source,DeliveryType,ReportWriter,FreqType,Frequency,Period from dbo.IRG_Deliverables_IAM
	
	--SELECT  Client,[Service],Country,[DATA type], Source,[Delivery Type],[Report writer],[Report writer name],[frequency type],frequency,
	--[deliver to],[# years]  FROM  dbo.[z_Delivery Details] 


	OPEN subCursor  
	FETCH NEXT FROM subCursor INTO @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,
	@Frequency,@Years
	set @cnt =1
	WHILE @@Fetch_Status = 0 

	BEGIN
	print ' Inside Cursor' 

		--select @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@ReportWriter,@FrequencyType,@Frequency,@DeliverTo,@Years
		select  @clientId = 0,@countryId = 0,@serviceId = 0, @sourceId = 0, @datatypeId = 0
		--select top 1 @clientId = id from clients where Name = LTrim(RTrim(@client)) 
		if @Client = 'GlaxoSmithKline Consumer Healthcare'
		set @Client ='GSK Consumer'
		--select top 1 @clientId = id from clients where left(Name,3)=  left(LTrim(RTrim(@client)),3) -- checking only first 3 characters
		select top 1 @clientId = id from clients where Name =  LTrim(RTrim(@client)) -- checking entire name
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
			else if LTrim(RTrim(@service))='profits' or LTrim(RTrim(@service))='profit' 
			set @TerritoryBase='brick'
			else if LTrim(RTrim(@service))='Audit' or LTrim(RTrim(@service))='IMS Reference' or LTrim(RTrim(@service))='Nielsen feed' or LTrim(RTrim(@service))='Pharma Trend' 
			set @TerritoryBase='NA'
			
			print ' subscrription insert '
			
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
		--select top 1 @FrequencyTypeId = FrequencyTypeId from FrequencyType where Name = LTrim(RTrim(@FrequencyType))
		--select top 1 @FrequencyId = FrequencyId from Frequency where Name = LTrim(RTrim(@Frequency))
		 Set @FrequencyTypeId = @FrequencyType
		 Set @FrequencyId = @Frequency
		 --select  @Years
		if ISNUMERIC(left(SUBSTRING(@Years, CHARINDEX(' ', @Years)+1,LEN(@Years)),1))=1
		begin
		--select 'num', SUBSTRING(@Years, CHARINDEX(' ', @Years)+2,4), LEFT(@Years, charindex(' ', @Years) - 1)
		if SUBSTRING(@Years, CHARINDEX(' ', @Years)+2,4) = 'Week'
			begin
			 if LEFT(@Years, charindex(' ', @Years) - 1)  = '104'
			 set @Years = '2 Years'
			 else
			 set @Years = LEFT(@Years, charindex(' ', @Years) - 1) + 'Weeks'
			 end
		--else if SUBSTRING(@Years, CHARINDEX(' ', @Years)+2,4) = 'Year'
		--	set @Years = LEFT(@Years, charindex(' ', @Years) - 1) + 'Years'
		end
		
		select top 1 @PeriodId = Periodid from Period where Name = @Years
		select @DeliveryTypeId = DeliveryTypeId from DeliveryType where Name=LTrim(RTrim(@DeliveryType))
	    --select @DeliveryType,@DeliveryTypeId
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
		  if @SubscriptionId is not null
		  begin
		   if not exists (select * from Deliverables where SubscriptionId = @SubscriptionId and ReportWriterId = @ReportWriterId and FrequencyTypeId = @FrequencyTypeId
		   and FrequencyId = case when @FrequencyId = 0 then null else @FrequencyId end and Periodid = @PeriodId and DeliveryTypeId = @DeliveryTypeId)
		   begin
			   insert into Deliverables (SubscriptionId,ReportWriterId,FrequencyTypeId,FrequencyId,Periodid,StartDate,EndDate,LastModified,ModifiedBy,DeliveryTypeId)
			   values (@SubscriptionId,@ReportWriterId,@FrequencyTypeId,case when @FrequencyId = 0 then null else @FrequencyId end,@PeriodId,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
			   DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1),CAST(GETDATE() AS DATE),1,@DeliveryTypeId)
			   SELECT @deliverablesId = SCOPE_IDENTITY()
			   --select 'deliverables id=' + cast(@deliverablesId as varchar)
			   Print 'Deliverables inserted- id=' + cast(@deliverablesId as varchar)
			   --select top 1 @deliverToId = id from clients where left(Name,3) = Left(LTrim(RTrim(@DeliverTo)),3)
			   --select top 1 @deliverToId = id from clients where Name =  LTrim(RTrim(@client))
		       
			   insert into DeliveryClient (DeliverableId, ClientId) values(@deliverablesId,@ClientId)
		   end
		Print 'Row =' + cast(@cnt as varchar)
		end
		set @cnt =@cnt +1
		FETCH NEXT FROM subCursor INTO @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,@Frequency,@Years
	    

	End 

	Close subCursor
	Deallocate subCursor

	--drop table dbo.IRG_Deliverables_IAM
END

GO


/****** Object:  StoredProcedure [dbo].[IRPProcessDeliverablesNonIAM]    Script Date: 9/11/2017 2:26:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IRPProcessDeliverablesNonIAM]
As
BEGIN

declare @Client varchar(100),@service varchar(100),@country varchar(100),@Datatype varchar(100),@source varchar(100),@DeliveryType varchar(100),
	@ReportWriterCode varchar(100),@ReportWriter varchar(100),@FrequencyType varchar(100),@Frequency varchar(500),@DeliverTo varchar(100), @Years varchar(100)
	Declare @CatSel varchar(50)
	declare @ClientId int,@countryId int,@serviceId int, @sourceId int,@datatypeId int,@ReportWriterId int, @FrequencyTypeId int, @FrequencyId int,@PeriodId int,@DeliveryTypeId int,
	@deliverToId int
	declare @subscriptionId int,@deliverablesId int
	declare @TerritoryBase varchar(50),@TerritoryBaseId int
	declare @cnt int
	set nocount on

	DECLARE subCursor CURSOR FOR
	Select ClientName, D.Country, 
	Case C.DataType when 'Other' then case when len([OUTLET DESCRIPTIONS])>0 then 'Other Outlet' else C.DataType end else C.DataType end,
	E.[Service],E.Source,E.Deliverable,ExtType,FreqType,Frequency,Period from dbo.IRG_Deliverables_NonIAM D
		inner join IRG_Cat_sel C on D.cat_sel=C.cat 
		inner join IRG_ExtractionType E on substring(D.ReportWriter,1,2) = E.ExtType
		where C.DataType is not null and E.Source is not null and ExtType is not null and E.[Service] is not null
	--Select ClientName, D.Country, C.DataType,E.[Service],E.Source,DeliveryType,ExtType,FreqType,Frequency,Period from dbo.IRG_Deliverables_NonIAM D
	--	inner join IRG_Cat_sel C on D.cat_sel=C.cat 
	--	inner join IRG_ExtractionType E on D.ReportWriter = E.ExtType
	--	where C.DataType is not null and E.Source is not null and ExtType is not null and E.[Service] is not null
		--Datatype vs Data
	

	OPEN subCursor  
	FETCH NEXT FROM subCursor INTO @client,@country,@DataType,@Service,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,@Frequency,@Years
	set @cnt =1
	WHILE @@Fetch_Status = 0 

	BEGIN

		--select @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@ReportWriter,@FrequencyType,@Frequency,@DeliverTo,@Years
		select  @clientId = 0,@countryId = 0,@serviceId = 0, @sourceId = 0, @datatypeId = 0
		set @datatype =  replace(@datatype,'Combined','Retail + Hospital')
		--select top 1 @clientId = id from clients where Name = LTrim(RTrim(@client)) 
		if @Client = 'GlaxoSmithKline Consumer Healthcare'
		set @Client ='GSK Consumer'
		if @service = 'Profits'
			set @service = 'Profit'
	    if @service = 'PROFITS/PROBE'
			set @service = 'PROFITS + PROBE'
		--select top 1 @clientId = id from clients where left(Name,3)=  left(LTrim(RTrim(@client)),3) -- checking only first 3 characters
		select top 1 @clientId = id from clients where Name=  @client
		select top 1 @countryId = CountryId from Country where Name = LTrim(RTrim(@country))
		select top 1 @serviceId = ServiceId from service where Name = LTrim(RTrim(@service))
		select top 1 @sourceId = sourceId from [dbo].[Source] where Name = LTrim(RTrim(@source))
		select top 1 @datatypeId = DataTypeId from Datatype where Name = LTrim(RTrim(@datatype)) 
		--select @client,@service,@serviceId,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@ReportWriter,@FrequencyType,@Frequency,@DeliverTo,@Years
		set @subscriptionId=0
		select @subscriptionId = SubscriptionId from Subscription where ClientId = @Clientid and CountryId = @countryId and ServiceId = @serviceId and SourceId = @sourceId and DataTypeId = @datatypeId
		--select @subscriptionId as subscriptionid,@Clientid client,@countryId country,@serviceId [service],@sourceId source,@datatypeId datatype
		if (@subscriptionId is null or @subscriptionId  < 1)
		begin
		
			if LTrim(RTrim(@service))='probe'  or LTrim(RTrim(@service)) = 'PROFITS + PROBE'
			set @TerritoryBase='both'
			else if LTrim(RTrim(@service))='profits' or LTrim(RTrim(@service))='profit' 
			set @TerritoryBase='brick'
			else if LTrim(RTrim(@service))='Audit' or LTrim(RTrim(@service))='IMS Reference' or LTrim(RTrim(@service))='Nielsen feed' or LTrim(RTrim(@service))='Pharma Trend' 
			set @TerritoryBase='NA'
			
			
			
			select @TerritoryBaseId=ServiceTerritoryid from ServiceTerritory where TerritoryBase=@TerritoryBase
		
--		 insert into subscription table
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
		--select top 1 @FrequencyTypeId = FrequencyTypeId from FrequencyType where Name = LTrim(RTrim(@FrequencyType))
		--select top 1 @FrequencyId = FrequencyId from Frequency where Name = LTrim(RTrim(@Frequency))
		 Set @FrequencyTypeId = @FrequencyType
		 Set @FrequencyId = @Frequency
		select top 1 @PeriodId = Periodid from Period where Name = @Years
		--select @DeliveryTypeId = DeliveryTypeId from DeliveryType where Name=LTrim(RTrim(@DeliveryType))
	    set @DeliveryType=LTrim(RTrim(@DeliveryType))
		select @DeliveryTypeId = DeliveryTypeId from DeliveryType where Name like '%'+@DeliveryType + '%'
		
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
		  --declare @DelId bit
		  --set @DelId = 0
		  --select @DelId = 1 from Deliverables where SubscriptionId = @SubscriptionId and ReportWriterId= @ReportWriterId and FrequencyTypeId = @FrequencyTypeId
		  --if @DelId <> 1 
		  if @SubscriptionId is not null
		  BEGIN
			  if not exists (select * from Deliverables where SubscriptionId = @SubscriptionId and ReportWriterId = @ReportWriterId and FrequencyTypeId = @FrequencyTypeId
			   and FrequencyId = case when @FrequencyId = 0 then null else @FrequencyId end and Periodid = @PeriodId and DeliveryTypeId = @DeliveryTypeId)
			   
			  begin
			   insert into Deliverables (SubscriptionId,ReportWriterId,FrequencyTypeId,FrequencyId,Periodid,StartDate,EndDate,LastModified,ModifiedBy,DeliveryTypeId)
			   values (@SubscriptionId,@ReportWriterId,@FrequencyTypeId,case when @FrequencyId = 0 then null else @FrequencyId end,@PeriodId,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
			   DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1),CAST(GETDATE() AS DATE),1,@DeliveryTypeId)
			   SELECT @deliverablesId = SCOPE_IDENTITY()
			   --select 'deliverables id=' + cast(@deliverablesId as varchar)
			   Print 'Deliverables inserted- id=' + cast(@deliverablesId as varchar)
			   
		       
			   insert into DeliveryClient (DeliverableId, ClientId) values(@deliverablesId,@ClientId)
			   end
			Print 'Row =' + cast(@cnt as varchar)
			END
		set @cnt =@cnt +1
		FETCH NEXT FROM subCursor INTO @client,@country,@DataType,@Service,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,@Frequency,@Years
	    

	End 

	Close subCursor
	Deallocate subCursor

	--delete from dbo.IRG_Deliverables_NonIAM
	
END

GO

CREATE FUNCTION [dbo].[fnGetDefaultStartDate]()  
RETURNS datetime   
AS   
 
BEGIN  
    DECLARE @ret datetime;
	   
    select @ret=Schedule_To from Maintenance_Calendar where GETDATE() between Schedule_From and Schedule_To
	if @ret is null
	select top 1 @ret =  Schedule_To from Maintenance_Calendar where Schedule_To >  GETDATE() order by Schedule_To
	if @ret is null
	set @ret=getdate()

    RETURN @ret;  
END;  


GO
/****** Object:  UserDefinedFunction [dbo].[GetStateFromBrick]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetStateFromBrick]
(
@Brick varchar(50)
)
RETURNS varchar(20)
AS
BEGIN
	DECLARE @ret varchar(20)='', @LeftChar varchar(5)

	Set @LeftChar=left(@Brick,1)
	
	if @LeftChar='2'
		Set @ret='NSW'
		
	if @LeftChar='3'
		Set @ret='VIC'
		
	if @LeftChar='4'
		Set @ret='QLD'
		
	if @LeftChar='0'
		Set @ret='NT'
		
	if @LeftChar='5'
		Set @ret='SA'
		
	if @LeftChar='6'
		Set @ret='WA'
	
	if @LeftChar='7'
		Set @ret='TAS'

	RETURN @ret

END


GO
/****** Object:  Table [dbo].[[BaseFilters]]]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[[BaseFilters]]](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Criteria] [nvarchar](max) NULL,
	[Values] [nvarchar](max) NULL,
	[IsEnabled] [bit] NOT NULL,
	[MarketBaseId] [int] NOT NULL,
	[IsRestricted] [bit] NULL,
	[IsBaseFilterType] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AccessPrivilege]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessPrivilege](
	[AccessPrivilegeID] [int] IDENTITY(1,1) NOT NULL,
	[AccessPrivilegeName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__AccessPr__6ABF757125690803] PRIMARY KEY CLUSTERED 
(
	[AccessPrivilegeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Action]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Action](
	[ActionID] [int] IDENTITY(1,1) NOT NULL,
	[ActionName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[ModuleID] [int] NULL,
 CONSTRAINT [PK__Action__FFE3F4B969D4400A] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AdditionalFilters]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aus_sales_report]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[BaseFilters]    Script Date: 25/09/2017 10:44:14 PM ******/
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
 CONSTRAINT [PK_BaseFilters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BaseFilters_bak]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseFilters_bak](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Criteria] [nvarchar](max) NULL,
	[Values] [nvarchar](max) NULL,
	[IsEnabled] [bit] NOT NULL,
	[MarketBaseId] [int] NOT NULL,
	[IsRestricted] [bit] NULL,
	[IsBaseFilterType] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Brick_XYCords]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[CADPages]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientMarketBases]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientMarketBases_Extended]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientMFR]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientMFR](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[MFRId] [int] NULL,
 CONSTRAINT [PK__ClientMF__3214EC0732E411A2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientNumberMap]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientPackException]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientPackException](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[PackExceptionId] [int] NULL,
	[ProductLevel] [bit] NULL,
	[ExpiryDate] [datetime] NULL,
 CONSTRAINT [PK__ClientPa__3214EC07B92B4FA0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientRelease]    Script Date: 25/09/2017 10:44:14 PM ******/
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
 CONSTRAINT [PK__ClientRe__3214EC070AC3179C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientRelease_Extended]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Clients]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[IsMyClient] [bit] NOT NULL,
	[DivisionOf] [int] NULL,
	[IRPClientId] [int] NULL,
	[IRPClientNo] [int] NULL,
 CONSTRAINT [PK_dbo.Clients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CONFIG_ECP_MKT_DEF_FILTERS]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONFIG_ECP_MKT_DEF_FILTERS](
	[FilterValue] [nvarchar](max) NULL,
	[ColumnName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ISOCode] [nvarchar](max) NULL,
 CONSTRAINT [PK__Country__10D1609FA77BC0AD] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DataType]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataType](
	[DataTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK__DataType__4382081F57CB4A5F] PRIMARY KEY CLUSTERED 
(
	[DataTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Deliverables]    Script Date: 25/09/2017 10:44:14 PM ******/
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
 CONSTRAINT [PK__Delivera__71A9170EE89621A3] PRIMARY KEY CLUSTERED 
(
	[DeliverableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryClient]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryClient](
	[DeliveryClientId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NULL,
	[ClientId] [int] NULL,
 CONSTRAINT [PK__Delivery__0BFCC04FBA03552A] PRIMARY KEY CLUSTERED 
(
	[DeliveryClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryClient_Extended]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryMarket]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryMarket](
	[DeliveryMarketId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NULL,
	[MarketDefId] [int] NULL,
 CONSTRAINT [PK__Delivery__C0E96CC9BD923B05] PRIMARY KEY CLUSTERED 
(
	[DeliveryMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryTerritory]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryTerritory](
	[DeliveryTerritoryId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NULL,
	[TerritoryId] [int] NULL,
 CONSTRAINT [PK__Delivery__A8CAEA30550E46D6] PRIMARY KEY CLUSTERED 
(
	[DeliveryTerritoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryThirdParty]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryThirdParty](
	[DeliveryThirdPartyId] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NOT NULL,
	[ThirdPartyId] [int] NOT NULL,
 CONSTRAINT [PK__Delivery__0AB5FD1223F0EA5A] PRIMARY KEY CLUSTERED 
(
	[DeliveryThirdPartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryType]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryType](
	[DeliveryTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK__Delivery__6B117964B1284DF2] PRIMARY KEY CLUSTERED 
(
	[DeliveryTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [dbo].[DIMProduct_Expanded]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[PFC] [varchar](15) NOT NULL,
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
	[TIME_STAMP] [datetime] NULL,
 CONSTRAINT [PK_DimProduct] PRIMARY KEY CLUSTERED 
(
	[PackID] ASC,
	[PFC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[DIMOutlet]    Script Date: 10/10/2017 10:43:20 PM ******/
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
	[Outl_Brk] [varchar](30) NULL,
	[EID] [varchar](30) NULL,
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
	[TIME_STAMP] [datetime] NULL,
	[BRICK_CHANGE_FLAG] [varchar](1) NULL,
	[BRICK_TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DIMProduct_Expanded_BK]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DIMProduct_Expanded_BK](
	[PackID] [int] NOT NULL,
	[Prod_cd] [int] NULL,
	[Pack_cd] [smallint] NULL,
	[PFC] [varchar](15) NOT NULL,
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
/****** Object:  Table [dbo].[DMMolecule]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[DMMolecule_BK]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DMMolecule_BK](
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
/****** Object:  Table [dbo].[DMMoleculeConcat]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DMMoleculeConcat](
	[FCC] [int] NULL,
	[Description] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[File]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK__File__6F0F98BFC907FC98] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FileType]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileType](
	[FileTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK__FileType__0896759E80A8BCE3] PRIMARY KEY CLUSTERED 
(
	[FileTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Frequency]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Frequency](
	[FrequencyId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[FrequencyTypeId] [int] NULL,
 CONSTRAINT [PK__Frequenc__5924749894230510] PRIMARY KEY CLUSTERED 
(
	[FrequencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FrequencyType]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FrequencyType](
	[FrequencyTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[DefaultYears] [nvarchar](max) NULL,
 CONSTRAINT [PK__Frequenc__829BB4BC81802169] PRIMARY KEY CLUSTERED 
(
	[FrequencyTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GoogleMapBricks]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[GoogleMapTerritories]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GoogleMapTerritories](
	[id] [int] NULL,
	[statecode] [nvarchar](40) NULL,
	[territory] [nvarchar](100) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Groups]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[IsOrphan] [bit] NOT NULL,
	[PaddingLeft] [int] NOT NULL,
	[ParentGroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumberSpace] [nvarchar](max) NULL,
	[TerritoryId] [int] NULL CONSTRAINT [DF_TerritoryId]  DEFAULT ((0)),
	[NewCGN] [nvarchar](50) NULL,
	[LevelNo] [int] NULL,
	[IRPItemID] [int] NULL,
 CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Groups_old]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[groups2]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_MOLECULE]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_OUTLET]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[TIME_STAMP] [datetime] NULL,
	[BRICK_CHANGE_FLAG] [varchar](1) NULL,
	[BRICK_TIME_STAMP] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_PRODUCT]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[HISTORY_TDW-ECP_DIM_PRODUCTx]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[IRG_CAT_SEL]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IRG_CAT_SEL](
	[Cat] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[RGPF CC TABLE OUTPUT TYPES - entity types] [nvarchar](255) NULL,
	[OUTLET DESCRIPTIONS] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IRG_Deliverables_IAM]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IRG_Deliverables_IAM](
	[RowID] [float] NULL,
	[clientid] [float] NULL,
	[ClientName] [nvarchar](255) NULL,
	[FreqType] [float] NULL,
	[Frequency] [float] NULL,
	[Period] [nvarchar](255) NULL,
	[Service] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[ReportWriter] [nvarchar](255) NULL,
	[country] [nvarchar](255) NULL,
	[deliveryType] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IRG_Deliverables_NonIAM]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IRG_Deliverables_NonIAM](
	[RowID] [float] NULL,
	[Clientid] [float] NULL,
	[ClientName] [nvarchar](255) NULL,
	[BKT_SEL] [nvarchar](255) NULL,
	[CAT_SEL] [nvarchar](255) NULL,
	[FreqType] [float] NULL,
	[Frequency] [float] NULL,
	[Period] [nvarchar](255) NULL,
	[Service] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[ReportWriter] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[DeliveryType] [nvarchar](255) NULL,
	[RPT_NO] [float] NULL,
	[XREF_Client] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IRG_ExtractionType]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IRG_ExtractionType](
	[ExtType] [nvarchar](255) NULL,
	[ExtDesc] [nvarchar](255) NULL,
	[Data] [nvarchar](255) NULL,
	[Level] [nvarchar](255) NULL,
	[Restriction] [nvarchar](255) NULL,
	[Comment] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Service] [nvarchar](255) NULL,
	[Data1] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[Deliverable] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Levels]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Levels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[LevelNumber] [int] NOT NULL,
	[LevelIDLength] [int] NOT NULL,
	[LevelColor] [nvarchar](max) NULL,
	[BackgroundColor] [nvarchar](max) NULL,
	[TerritoryId] [int] NOT NULL,
	[IRPLevelID] [int] NULL,
 CONSTRAINT [PK_dbo.Levels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[levels2]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[Listings]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LockHistories]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LockHistories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DefId] [int] NULL,
	[DocType] [nvarchar](200) NULL,
	[LockType] [nvarchar](200) NULL,
	[LockTime] [datetime] NULL,
	[ReleaseTime] [datetime] NULL,
	[Status] [nvarchar](100) NULL,
	[UserId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Maintenance_Calendar]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Maintenance_Calendar](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [varchar](30) NOT NULL,
	[Schedule_From] [datetime] NULL,
	[Schedule_To] [datetime] NULL,
	[ActionDate] [datetime] NULL CONSTRAINT [DF_ActionDate]  DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Maintenance_Calendar_Staging]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Maintenance_Calendar_Staging](
	[Year] [int] NOT NULL,
	[Month] [varchar](30) NOT NULL,
	[Schedule_From] [datetime] NULL,
	[Schedule_To] [datetime] NULL,
	[ActionDate] [datetime] NULL CONSTRAINT [Staging_ActionDate]  DEFAULT (getdate())
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MarketBases]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitionBaseMaps]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitionPacks]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitions]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[DimensionId] [int] NULL,
 CONSTRAINT [PK_dbo.MarketDefinitions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitions_Extended]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketDefinitionsPackTest]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[MarketDefWithMarketBase]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[MatrketDefinition]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MatrketDefinition](
	[Market_Base] [nvarchar](max) NULL,
	[Market_BaseID] [int] NULL,
	[Base_Filter_Name] [nvarchar](max) NULL,
	[Base_Criteria] [nvarchar](max) NULL,
	[Base_Values] [nvarchar](max) NULL,
	[MarketDefinitionId] [int] NULL,
	[DataRefreshType] [nvarchar](max) NULL,
	[MarketDefinitionBaseMapId] [int] NULL,
	[MDBase_Filter_Name] [nvarchar](max) NULL,
	[MDBase_Criteria] [nvarchar](max) NULL,
	[MDBase_Values] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Module]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Module](
	[ModuleID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[SectionID] [int] NULL,
 CONSTRAINT [PK__Module__2B7477874BB99F3C] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MonthlyDataSummaries]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MonthlyNewproducts]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsAlerts]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OutletBrickAllocations]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[BrickOutletLocation] [char](30) NULL,
	[TerritoryId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.OutletBrickAllocations1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutletBrickAllocations_BK]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutletBrickAllocations_BK](
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
	[TerritoryId] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutletBrickAllocations_old]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PackMarketBases]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackMarketBases](
	[PackId] [int] NOT NULL,
	[MarketBaseId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Period]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Period](
	[PeriodId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Number] [int] NULL,
 CONSTRAINT [PK__Period__E521BB167320E6E3] PRIMARY KEY CLUSTERED 
(
	[PeriodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PopularLinks]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RAW_TDW-ECP_DIM_MOLECULE]    Script Date: 25/09/2017 10:44:14 PM ******/
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

/****** Object:  Table [dbo].[RAW_TDW-ECP_DIM_OUTLET]    Script Date: 10/10/2017 10:36:04 PM ******/
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
	[ACTIVE_DATE] [datetime2](7) NULL,
	[OTLT_LOC_CD] [varchar](30) NULL,
	[OUTLET] [smallint] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RAW_TDW-ECP_DIM_PRODUCT]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[ReportFieldList]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportFieldList](
	[FieldID] [int] NOT NULL,
	[FieldName] [varchar](100) NOT NULL,
	[FieldDescription] [varchar](200) NULL,
	[TableName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ReportFieldList] PRIMARY KEY CLUSTERED 
(
	[FieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportFieldsByModule]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportFieldsByModule](
	[ModuleID] [int] NULL,
	[FieldID] [int] NULL,
	[UserTypeID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReportFilters]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportFilters](
	[FilterID] [int] IDENTITY(1,1) NOT NULL,
	[FilterName] [varchar](100) NOT NULL,
	[FilterType] [varchar](20) NOT NULL,
	[FilterDescription] [varchar](200) NULL,
	[SelectedFields] [varchar](max) NULL,
	[ModuleID] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_ReportFilters] PRIMARY KEY CLUSTERED 
(
	[FilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportModules]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportModules](
	[ModuleID] [int] NOT NULL,
	[ModuleName] [varchar](50) NULL,
	[ModuleDesc] [varchar](50) NULL,
 CONSTRAINT [PK_ReportModules] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportSection]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportSection](
	[ReportSectionID] [int] IDENTITY(1,1) NOT NULL,
	[ReportSectionName] [varchar](50) NOT NULL,
	[UserTypeID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportWriter]    Script Date: 25/09/2017 10:44:14 PM ******/
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
 CONSTRAINT [PK__ReportWr__BE9ECEA28A3C1DDD] PRIMARY KEY CLUSTERED 
(
	[ReportWriterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Restriction]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restriction](
	[RestrictionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK__Restrict__529D86BA81246785] PRIMARY KEY CLUSTERED 
(
	[RestrictionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Role]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[IsExternal] [bit] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK__Role__8AFACE3AA7B59CCE] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleAction]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Section]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Section](
	[SectionID] [int] IDENTITY(1,1) NOT NULL,
	[SectionName] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__Section__80EF0892FAE93E66] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Service]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[ServiceId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK__Service__C51BB00A0ABDBAF6] PRIMARY KEY CLUSTERED 
(
	[ServiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceConfiguration]    Script Date: 25/09/2017 10:44:14 PM ******/
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
 CONSTRAINT [PK__ServiceC__3214EC07EC38992F] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ServiceTerritory]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceTerritory](
	[ServiceTerritoryId] [int] IDENTITY(1,1) NOT NULL,
	[TerritoryBase] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK__ServiceT__9E26E799A417F686] PRIMARY KEY CLUSTERED 
(
	[ServiceTerritoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Source]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Source](
	[SourceId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK__Source__16E019194AAC1782] PRIMARY KEY CLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 25/09/2017 10:44:14 PM ******/
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
 CONSTRAINT [PK__Subscrip__9A2B249DACFF9B1C] PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subscription_Extended]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubscriptionMarket]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubscriptionMarket](
	[SubscriptionMarketId] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionId] [int] NULL,
	[MarketBaseId] [int] NULL,
 CONSTRAINT [PK__Subscrip__9585FB84031A6821] PRIMARY KEY CLUSTERED 
(
	[SubscriptionMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblBrick]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[ChangeFlag] [varchar](1) NULL,
	[BrickLocation] [char](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOutlet]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[ChangeFlag] [varchar](1) NULL,
	[EID] [varchar](30) NULL,
	[OutletLocation] [char](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Territories]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[SRA_Client] [nvarchar](100) NULL,
	[SRA_Suffix] [nvarchar](100) NULL,
	[AD] [nvarchar](100) NULL,
	[LD] [nvarchar](100) NULL,
	[DimensionID] [int] NULL,
 CONSTRAINT [PK_dbo.Territories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Territories_Extended]    Script Date: 25/09/2017 10:44:14 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[territories2]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[Test_Table]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Test_Table](
	[FCC] [int] NULL,
	[PFC] [varchar](15) NULL,
	[PACK_DESCRIPTION] [varchar](80) NULL,
	[ATC4_CODE] [varchar](30) NULL,
	[CHANGE_FLAG] [varchar](1) NULL,
	[TIME_STAMP] [datetime] NULL,
	[Run_Time] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ThirdParty]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThirdParty](
	[ThirdPartyId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK__ThirdPar__E86D456FDA5D4A93] PRIMARY KEY CLUSTERED 
(
	[ThirdPartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	[IsActive] [bit] NOT NULL,
	[ReceiveEmail] [bit] NULL,
	[Password] [varchar](50) NULL,
	[PwdEncrypted] [int] NULL,
	[MaintenancePeriodEmail] [bit] NULL DEFAULT ((0)),
	[NewsAlertEmail] [bit] NULL DEFAULT ((0)),
 CONSTRAINT [PK__User__1788CCAC48593536] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserClient]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClient](
	[UserClientId] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
 CONSTRAINT [PK__UserClie__A5FB1175805E4720] PRIMARY KEY CLUSTERED 
(
	[UserClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserLogin_History]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserLogin_History](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[UserName] [varchar](500) NULL,
	[UserType] [int] NULL,
	[RoleID] [int] NULL,
	[LoginDate] [datetime] NULL,
	[Comment] [varchar](200) NULL,
 CONSTRAINT [PK__UserLogi__3214EC27C70282A3] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserLogin_History1]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserLogin_History1](
	[ID] [int] NOT NULL,
	[UserID] [int] NULL,
	[UserName] [varchar](500) NULL,
	[UserType] [int] NULL,
	[RoleID] [int] NULL,
	[LoginDate] [datetime] NULL,
	[Comment] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[UserRolesId] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK__UserRole__43D8BF2DC56C0FD2] PRIMARY KEY CLUSTERED 
(
	[UserRolesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserType]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserType](
	[UserTypeID] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__UserType__40D2D8F67E38746B] PRIMARY KEY CLUSTERED 
(
	[UserTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[z_Items]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[z_UserList]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[z_UserList](
	[Users] [nvarchar](255) NULL,
	[First Name] [nvarchar](255) NULL,
	[Last Name] [nvarchar](255) NULL,
	[Role] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[Bases]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[BasesFields]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[CLD]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [IRP].[CLD](
	[CLIENT_NO] [smallint] NOT NULL,
	[RPT_NO] [smallint] NOT NULL,
	[BKT_SEL] [char](4) NULL,
	[CAT_SEL] [char](4) NULL,
	[FY_END] [char](2) NULL,
	[RPT_PRD] [char](1) NULL,
	[RPT_START] [char](2) NULL,
	[RPT_END] [char](2) NULL,
	[XREF_CLIENT] [smallint] NULL,
	[XREF_FCD] [smallint] NULL,
	[LVL_TOTAL] [char](8) NULL,
	[SRA_TYPE] [char](1) NULL,
	[SRA_CLIENT] [smallint] NULL,
	[SRA_SUFFIX] [char](1) NULL,
	[timestamp] [timestamp] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [IRP].[Client]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[ClientMap]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[Dimension]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[DimensionBaseMap]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[DimensionBaseMap](
	[DimensionId] [int] NULL,
	[MarketBaseId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[DimensionType]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[GeographyDimOptions]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[GroupNumberMap]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[IMSBrickMaster]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[IMSBrickMaster](
	[StateCode] [nvarchar](40) NOT NULL,
	[StateName] [nvarchar](100) NOT NULL,
	[BrickCode] [nvarchar](40) NOT NULL,
	[BrickName] [nvarchar](100) NOT NULL,
	[BrickShortName] [nvarchar](100) NOT NULL,
	[Pharmacies] [int] NOT NULL,
	[Hospitals] [int] NOT NULL,
	[Others] [int] NOT NULL,
	[Inactive] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[IMSBrickOutletMaster]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [IRP].[IMSBrickOutletMaster](
	[OID] [bigint] NOT NULL,
	[Eid] [int] NULL,
	[Aid] [int] NULL,
	[Type] [char](2) NOT NULL,
	[Name] [varchar](30) NOT NULL,
	[Address] [varchar](89) NOT NULL,
	[StateCode] [tinyint] NOT NULL,
	[State] [varchar](5) NOT NULL,
	[BrickCode] [char](5) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[PostCode] [smallint] NOT NULL,
	[BrickSuffix] [char](1) NOT NULL,
	[Banner] [varchar](200) NULL,
	[Outlet] [smallint] NOT NULL,
	[Active] [smalldatetime] NULL,
	[Inactive] [smalldatetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [IRP].[IMSOutletMaster]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [IRP].[IMSOutletMaster](
	[OID] [bigint] NOT NULL,
	[EID] [int] NULL,
	[AID] [tinyint] NULL,
	[Type] [char](2) NOT NULL,
	[Name] [varchar](30) NOT NULL,
	[Address] [varchar](89) NOT NULL,
	[StateCode] [tinyint] NOT NULL,
	[State] [varchar](5) NOT NULL,
	[BrickCode] [char](5) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[PostCode] [smallint] NOT NULL,
	[BrickSuffix] [char](1) NOT NULL,
	[Banner] [varchar](200) NULL,
	[Outlet] [smallint] NOT NULL,
	[Active] [datetime] NULL,
	[Inactive] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [IRP].[Items]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[Levels]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [IRP].[OutletMaster]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [IRP].[OutletMaster](
	[Postcode] [smallint] NOT NULL,
	[Outlet] [smallint] NOT NULL,
	[name] [varchar](40) NULL,
	[Addr1] [varchar](30) NULL,
	[Addr2] [varchar](30) NULL,
	[Suburb] [varchar](30) NULL,
	[FullAddress] [varchar](89) NULL,
	[Phone] [char](15) NULL,
	[FaxNo] [char](15) NULL,
	[BedCount] [smallint] NULL,
	[inactive_date] [smalldatetime] NULL,
	[sbrick] [char](5) NOT NULL,
	[sbrick_desc] [varchar](50) NOT NULL,
	[out_type] [char](2) NULL,
	[entity_type] [char](2) NULL,
	[BannerGroup] [varchar](10) NULL,
	[Outl_Brk] [varchar](8) NOT NULL,
	[Retail_Sbrick] [char](5) NOT NULL,
	[Retail_Sbrick_Desc] [varchar](50) NOT NULL,
	[XCoord] [decimal](11, 6) NULL,
	[YCoord] [decimal](11, 6) NULL,
	[Active_date] [smalldatetime] NULL,
	[State_Code] [varchar](3) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [IRP].[RD]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [IRP].[RD](
	[CLIENT_NO] [smallint] NOT NULL,
	[RPT_NO] [smallint] NOT NULL,
	[MR_FILENO] [smallint] NULL,
	[LD_FILENO] [smallint] NULL,
	[GD_FILENO] [smallint] NULL,
	[AD_FILENO] [smallint] NULL,
	[CD_FILENO] [smallint] NULL,
	[OUT_FILENO] [char](1) NULL,
	[RPT_SELECTION] [char](8) NULL,
	[REPORT_NAME] [char](25) NULL,
	[CAT_TOT] [char](1) NULL,
	[timestamp] [timestamp] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [IRP].[Report]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[Report](
	[ReportID] [smallint] NOT NULL,
	[ClientID] [smallint] NOT NULL,
	[ReportNo] [smallint] NOT NULL,
	[ReportName] [nvarchar](100) NULL,
	[ReportStart] [smallint] NULL,
	[ReportEnd] [smallint] NULL,
	[DataStart] [smallint] NULL,
	[DataEnd] [smallint] NULL,
	[WriterID] [smallint] NOT NULL,
	[Media] [nvarchar](100) NOT NULL,
	[Delivery] [nvarchar](100) NOT NULL,
	[Options] [nvarchar](100) NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[ReportParameter]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[ReportParameter](
	[ReportParameterID] [int] NOT NULL,
	[ReportID] [smallint] NOT NULL,
	[WriterParameterID] [smallint] NOT NULL,
	[Code] [nvarchar](40) NOT NULL,
	[Name] [nvarchar](40) NOT NULL,
	[Type] [tinyint] NOT NULL,
	[DimensionType] [tinyint] NULL,
	[PCount] [tinyint] NOT NULL,
	[Value] [nvarchar](100) NULL,
	[VersionFrom] [smallint] NOT NULL,
	[VersionTo] [smallint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [IRP].[Writer]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IRP].[Writer](
	[WriterId] [smallint] NOT NULL,
	[WriterCode] [nvarchar](4) NOT NULL,
	[WriterName] [nvarchar](20) NOT NULL,
	[WriterDescription] [nvarchar](100) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [SERVICE].[AU9_CLIENT_MKT_PACK]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [SERVICE].[AU9_CLIENT_TERR]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [SERVICE].[AU9_CLIENT_TERR_RAW]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  Table [SERVICE].[AU9_CLIENT_TERR_TYP]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  View [dbo].[GoogleMapStates]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  View [dbo].[vw_GroupsLevelWise]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  View [dbo].[vw_Outlet_Combined]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  View [dbo].[vw_OutletBrickAll]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  View [dbo].[vwBrick]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vwBrick]
AS
SELECT DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName, '' AS [Address], CHANGE_FLAG as ChangeFlag
FROM     dbo.DIMOutlet









GO
/****** Object:  View [dbo].[vwOutlet]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vwOutlet]
AS
SELECT DISTINCT Outl_brk Outlet, Name AS OutletName, REPLACE(REPLACE(FullAddr, CHAR(13), ' '), CHAR(10), ' ') AS [Address], CHANGE_FLAG as ChangeFlag
FROM     dbo.DIMOutlet









GO
/****** Object:  View [dbo].[vwTerritories]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[vwTerritories]
AS
 SELECT Id, CASE WHEN SRA_Client is not null then Name+' ('+SRA_Client +'' + SRA_Suffix+')' ELSE Name END as Name, RootGroup_id, RootLevel_Id, Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD
FROM Territories


GO
ALTER TABLE [dbo].[Action]  WITH CHECK ADD  CONSTRAINT [FK__Action__ModuleID__43D61337] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Module] ([ModuleID])
GO
ALTER TABLE [dbo].[Action] CHECK CONSTRAINT [FK__Action__ModuleID__43D61337]
GO
ALTER TABLE [dbo].[AdditionalFilters]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AdditionalFilters_dbo.MarketDefinitionBaseMaps_MarketDefinitionBaseMapId] FOREIGN KEY([MarketDefinitionBaseMapId])
REFERENCES [dbo].[MarketDefinitionBaseMaps] ([Id])
GO
ALTER TABLE [dbo].[AdditionalFilters] CHECK CONSTRAINT [FK_dbo.AdditionalFilters_dbo.MarketDefinitionBaseMaps_MarketDefinitionBaseMapId]
GO
ALTER TABLE [dbo].[ClientMFR]  WITH CHECK ADD  CONSTRAINT [FK__ClientMFR__Clien__46B27FE2] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[ClientMFR] CHECK CONSTRAINT [FK__ClientMFR__Clien__46B27FE2]
GO
ALTER TABLE [dbo].[ClientPackException]  WITH CHECK ADD  CONSTRAINT [FK__ClientPac__Clien__47A6A41B] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[ClientPackException] CHECK CONSTRAINT [FK__ClientPac__Clien__47A6A41B]
GO
ALTER TABLE [dbo].[ClientRelease]  WITH CHECK ADD  CONSTRAINT [FK__ClientRel__Clien__489AC854] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[ClientRelease] CHECK CONSTRAINT [FK__ClientRel__Clien__489AC854]
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD  CONSTRAINT [FK__Deliverab__Deliv__498EEC8D] FOREIGN KEY([DeliveryTypeId])
REFERENCES [dbo].[DeliveryType] ([DeliveryTypeId])
GO
ALTER TABLE [dbo].[Deliverables] CHECK CONSTRAINT [FK__Deliverab__Deliv__498EEC8D]
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD  CONSTRAINT [FK__Deliverab__Frequ__4A8310C6] FOREIGN KEY([FrequencyTypeId])
REFERENCES [dbo].[FrequencyType] ([FrequencyTypeId])
GO
ALTER TABLE [dbo].[Deliverables] CHECK CONSTRAINT [FK__Deliverab__Frequ__4A8310C6]
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD  CONSTRAINT [FK__Deliverab__Perio__4B7734FF] FOREIGN KEY([PeriodId])
REFERENCES [dbo].[Period] ([PeriodId])
GO
ALTER TABLE [dbo].[Deliverables] CHECK CONSTRAINT [FK__Deliverab__Perio__4B7734FF]
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD  CONSTRAINT [FK__Deliverab__Repor__4C6B5938] FOREIGN KEY([ReportWriterId])
REFERENCES [dbo].[ReportWriter] ([ReportWriterId])
GO
ALTER TABLE [dbo].[Deliverables] CHECK CONSTRAINT [FK__Deliverab__Repor__4C6B5938]
GO
ALTER TABLE [dbo].[Deliverables]  WITH CHECK ADD  CONSTRAINT [FK__Deliverab__Subsc__4D5F7D71] FOREIGN KEY([SubscriptionId])
REFERENCES [dbo].[Subscription] ([SubscriptionId])
GO
ALTER TABLE [dbo].[Deliverables] CHECK CONSTRAINT [FK__Deliverab__Subsc__4D5F7D71]
GO
ALTER TABLE [dbo].[DeliveryClient]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryC__Clien__4E53A1AA] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[DeliveryClient] CHECK CONSTRAINT [FK__DeliveryC__Clien__4E53A1AA]
GO
ALTER TABLE [dbo].[DeliveryClient]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryC__Deliv__4F47C5E3] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryClient] CHECK CONSTRAINT [FK__DeliveryC__Deliv__4F47C5E3]
GO
ALTER TABLE [dbo].[DeliveryMarket]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryM__Deliv__503BEA1C] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryMarket] CHECK CONSTRAINT [FK__DeliveryM__Deliv__503BEA1C]
GO
ALTER TABLE [dbo].[DeliveryMarket]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryM__Marke__51300E55] FOREIGN KEY([MarketDefId])
REFERENCES [dbo].[MarketDefinitions] ([Id])
GO
ALTER TABLE [dbo].[DeliveryMarket] CHECK CONSTRAINT [FK__DeliveryM__Marke__51300E55]
GO
ALTER TABLE [dbo].[DeliveryTerritory]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryT__Deliv__5224328E] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryTerritory] CHECK CONSTRAINT [FK__DeliveryT__Deliv__5224328E]
GO
ALTER TABLE [dbo].[DeliveryTerritory]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryT__Terri__45BE5BA9] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
GO
ALTER TABLE [dbo].[DeliveryTerritory] CHECK CONSTRAINT [FK__DeliveryT__Terri__45BE5BA9]
GO
ALTER TABLE [dbo].[DeliveryThirdParty]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryT__Deliv__540C7B00] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([DeliverableId])
GO
ALTER TABLE [dbo].[DeliveryThirdParty] CHECK CONSTRAINT [FK__DeliveryT__Deliv__540C7B00]
GO
ALTER TABLE [dbo].[DeliveryThirdParty]  WITH CHECK ADD  CONSTRAINT [FK__DeliveryT__Third__55009F39] FOREIGN KEY([ThirdPartyId])
REFERENCES [dbo].[ThirdParty] ([ThirdPartyId])
GO
ALTER TABLE [dbo].[DeliveryThirdParty] CHECK CONSTRAINT [FK__DeliveryT__Third__55009F39]
GO
ALTER TABLE [dbo].[Frequency]  WITH CHECK ADD  CONSTRAINT [FK__Frequency__Frequ__55F4C372] FOREIGN KEY([FrequencyTypeId])
REFERENCES [dbo].[FrequencyType] ([FrequencyTypeId])
GO
ALTER TABLE [dbo].[Frequency] CHECK CONSTRAINT [FK__Frequency__Frequ__55F4C372]
GO
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Groups] ([Id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id]
GO
ALTER TABLE [dbo].[Levels]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Levels_dbo.Territories_TerritoryId] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
GO
ALTER TABLE [dbo].[Levels] CHECK CONSTRAINT [FK_dbo.Levels_dbo.Territories_TerritoryId]
GO
ALTER TABLE [dbo].[LockHistories]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketBases_MarketBaseId] FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps] CHECK CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketBases_MarketBaseId]
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketDefinitions_MarketDefinitionId] FOREIGN KEY([MarketDefinitionId])
REFERENCES [dbo].[MarketDefinitions] ([Id])
GO
ALTER TABLE [dbo].[MarketDefinitionBaseMaps] CHECK CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketDefinitions_MarketDefinitionId]
GO
ALTER TABLE [dbo].[MarketDefinitionPacks]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitionPacks_dbo.MarketDefinitions_MarketDefinitionId] FOREIGN KEY([MarketDefinitionId])
REFERENCES [dbo].[MarketDefinitions] ([Id])
GO
ALTER TABLE [dbo].[MarketDefinitionPacks] CHECK CONSTRAINT [FK_dbo.MarketDefinitionPacks_dbo.MarketDefinitions_MarketDefinitionId]
GO
ALTER TABLE [dbo].[MarketDefinitions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MarketDefinitions_dbo.Clients_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
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
GO
ALTER TABLE [dbo].[OutletBrickAllocations] CHECK CONSTRAINT [FK_dbo.OutletBrickAllocations1_dbo.Territories_TerritoryId]
GO
ALTER TABLE [dbo].[OutletBrickAllocations_old]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OutletBrickAllocations_dbo.Territories_TerritoryId] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
GO
ALTER TABLE [dbo].[OutletBrickAllocations_old] CHECK CONSTRAINT [FK_dbo.OutletBrickAllocations_dbo.Territories_TerritoryId]
GO
ALTER TABLE [dbo].[PackMarketBases]  WITH CHECK ADD  CONSTRAINT [FK__PackMarke__Marke__5F7E2DAC] FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
GO
ALTER TABLE [dbo].[PackMarketBases] CHECK CONSTRAINT [FK__PackMarke__Marke__5F7E2DAC]
GO
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByFilterID] FOREIGN KEY([FieldID])
REFERENCES [dbo].[ReportFieldList] ([FieldID])
GO
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByFilterID]
GO
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[ReportModules] ([ModuleID])
GO
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByModuleID]
GO
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByUserID] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByUserID]
GO
ALTER TABLE [dbo].[ReportFilters]  WITH CHECK ADD  CONSTRAINT [fk_ModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[ReportModules] ([ModuleID])
GO
ALTER TABLE [dbo].[ReportFilters] CHECK CONSTRAINT [fk_ModuleID]
GO
ALTER TABLE [dbo].[ReportFilters]  WITH CHECK ADD  CONSTRAINT [FK_ReportFilters_ReportFilters] FOREIGN KEY([FilterID])
REFERENCES [dbo].[ReportFilters] ([FilterID])
GO
ALTER TABLE [dbo].[ReportFilters] CHECK CONSTRAINT [FK_ReportFilters_ReportFilters]
GO
ALTER TABLE [dbo].[ReportSection]  WITH CHECK ADD  CONSTRAINT [FK_ReportSection_UserType] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
ALTER TABLE [dbo].[ReportSection] CHECK CONSTRAINT [FK_ReportSection_UserType]
GO
ALTER TABLE [dbo].[ReportWriter]  WITH CHECK ADD  CONSTRAINT [FK__ReportWri__Deliv__607251E5] FOREIGN KEY([DeliveryTypeId])
REFERENCES [dbo].[DeliveryType] ([DeliveryTypeId])
GO
ALTER TABLE [dbo].[ReportWriter] CHECK CONSTRAINT [FK__ReportWri__Deliv__607251E5]
GO
ALTER TABLE [dbo].[ReportWriter]  WITH CHECK ADD  CONSTRAINT [FK__ReportWri__FileI__6166761E] FOREIGN KEY([FileId])
REFERENCES [dbo].[File] ([FileId])
GO
ALTER TABLE [dbo].[ReportWriter] CHECK CONSTRAINT [FK__ReportWri__FileI__6166761E]
GO
ALTER TABLE [dbo].[ReportWriter]  WITH CHECK ADD  CONSTRAINT [FK__ReportWri__FileT__625A9A57] FOREIGN KEY([FileTypeId])
REFERENCES [dbo].[FileType] ([FileTypeId])
GO
ALTER TABLE [dbo].[ReportWriter] CHECK CONSTRAINT [FK__ReportWri__FileT__625A9A57]
GO
ALTER TABLE [dbo].[RoleAction]  WITH CHECK ADD  CONSTRAINT [FK__RoleActio__Acces__634EBE90] FOREIGN KEY([AccessPrivilegeID])
REFERENCES [dbo].[AccessPrivilege] ([AccessPrivilegeID])
GO
ALTER TABLE [dbo].[RoleAction] CHECK CONSTRAINT [FK__RoleActio__Acces__634EBE90]
GO
ALTER TABLE [dbo].[RoleAction]  WITH CHECK ADD  CONSTRAINT [FK__RoleActio__Actio__6442E2C9] FOREIGN KEY([ActionID])
REFERENCES [dbo].[Action] ([ActionID])
GO
ALTER TABLE [dbo].[RoleAction] CHECK CONSTRAINT [FK__RoleActio__Actio__6442E2C9]
GO
ALTER TABLE [dbo].[RoleAction]  WITH CHECK ADD  CONSTRAINT [FK__RoleActio__RoleI__65370702] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[RoleAction] CHECK CONSTRAINT [FK__RoleActio__RoleI__65370702]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Clien__662B2B3B] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK__Subscript__Clien__662B2B3B]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Count__671F4F74] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK__Subscript__Count__671F4F74]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__DataT__681373AD] FOREIGN KEY([DataTypeId])
REFERENCES [dbo].[DataType] ([DataTypeId])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK__Subscript__DataT__681373AD]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Servi__690797E6] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[Service] ([ServiceId])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK__Subscript__Servi__690797E6]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Servi__69FBBC1F] FOREIGN KEY([ServiceTerritoryId])
REFERENCES [dbo].[ServiceTerritory] ([ServiceTerritoryId])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK__Subscript__Servi__69FBBC1F]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Sourc__6AEFE058] FOREIGN KEY([SourceId])
REFERENCES [dbo].[Source] ([SourceId])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK__Subscript__Sourc__6AEFE058]
GO
ALTER TABLE [dbo].[SubscriptionMarket]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Marke__6BE40491] FOREIGN KEY([MarketBaseId])
REFERENCES [dbo].[MarketBases] ([Id])
GO
ALTER TABLE [dbo].[SubscriptionMarket] CHECK CONSTRAINT [FK__Subscript__Marke__6BE40491]
GO
ALTER TABLE [dbo].[SubscriptionMarket]  WITH CHECK ADD  CONSTRAINT [FK__Subscript__Subsc__6CD828CA] FOREIGN KEY([SubscriptionId])
REFERENCES [dbo].[Subscription] ([SubscriptionId])
GO
ALTER TABLE [dbo].[SubscriptionMarket] CHECK CONSTRAINT [FK__Subscript__Subsc__6CD828CA]
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
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK__User__UserTypeID__70A8B9AE] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK__User__UserTypeID__70A8B9AE]
GO
ALTER TABLE [dbo].[UserClient]  WITH CHECK ADD  CONSTRAINT [FK__UserClien__Clien__719CDDE7] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO
ALTER TABLE [dbo].[UserClient] CHECK CONSTRAINT [FK__UserClien__Clien__719CDDE7]
GO
ALTER TABLE [dbo].[UserClient]  WITH CHECK ADD  CONSTRAINT [FK__UserClien__UserI__72910220] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserClient] CHECK CONSTRAINT [FK__UserClien__UserI__72910220]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK__UserRole__RoleId__73852659] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK__UserRole__RoleId__73852659]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK__UserRole__UserID__74794A92] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK__UserRole__UserID__74794A92]
GO
/****** Object:  StoredProcedure [dbo].[CheckUserLogin]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec [dbo].CheckUserLogin 'Admin@au.imshealth.com','ECP888'
CREATE PROCEDURE [dbo].[CheckUserLogin]
 @userName varchar(300), @pwd varchar(50)
AS
BEGIN
--update [dbo].[User]
--  set LastName=SUBSTRING(UserName,CHARINDEX('.',UserName)+1,LEN(UserName)-CHARINDEX('.',UserName))
--  where LastName=''
 
  
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
	join dbo.[Role] r on ur.RoleId=r.RoleID
	where [UserName]=@userName and [Password]=@pwd and u.IsActive=1
		
END






GO
/****** Object:  StoredProcedure [dbo].[CombineMultipleMarketBasesForAll]    Script Date: 25/09/2017 10:44:14 PM ******/
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
			select rownum, pack, GroupNumber, GroupName, isnull(Factor, '') Factor, PFC, isnull(Manufacturer,'') Manufacturer, ATC4, isnull(NEC4, '') NEC4, DataRefreshType, isnull(StateStatus, '') StateStatus, MarketDefinitionId, Alignment, Product, isnull(ChangeFlag, '') ChangeFlag, isnull(Molecule, '') Molecule
			,count(*) as kount 
			from 
			(
				select rank() over (order by pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule) as rownum,
				pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
				from MarketDefinitionPacks
				where 
				--MarketDefinitionId = 220 and 
				MarketBaseId is not null --
			)A
			group by rownum, pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
			--order by marketdefinitionid, pack
		)B
		where B.kount > 1
		--order by marketdefinitionid, pack
	)C
	join MarketDefinitionPacks M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC AND C.GroupNumber = M.GroupNumber 
	and C.ATC4 = M.ATC4 and C.NEC4 = isnull(M.NEC4,'') and C.Manufacturer = isnull(M.Manufacturer,'')
	order by C.marketdefinitionid, C.pack

	--select * from #t

	IF OBJECT_ID('tempdb..#aggregatedMarketBase') IS NOT NULL drop table #aggregatedMarketBase
	select pack, 
		STUFF((SELECT ', ' + CAST(MarketBase AS VARCHAR(500)) [text()]
			 FROM #t 
			 WHERE Pack = t.Pack and MarketDefinitionId = t.MarketDefinitionId and PFC = t.PFC AND GroupNumber = t.GroupNumber and ATC4 = t.ATC4 and NEC4 = t.NEC4 and Manufacturer = t.Manufacturer
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' ') MarketBase,
			STUFF((SELECT ', ' + CAST(MarketBaseId AS VARCHAR(500)) [text()]
			 FROM #t 
			 WHERE Pack = t.Pack and MarketDefinitionId = t.MarketDefinitionId and PFC = t.PFC AND GroupNumber = t.GroupNumber and ATC4 = t.ATC4 and NEC4 = t.NEC4 and Manufacturer = t.Manufacturer
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' ') MarketBaseId,
		GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
	into #aggregatedMarketBase
	from #t t
	group by pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule

	--select * from #aggregatedMarketBase

	--select C.* from MarketDefinitionPacks C 
	--inner join #t M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC --AND C.GroupNumber = M.GroupNumber and C.ATC4 = M.ATC4 and C.NEC4 = isnull(M.NEC4,'') and C.Manufacturer = isnull(M.Manufacturer,'')

	
	-----DELETE RECORDS/PACKS COMMON FOR MULTIPLE MARKET BASES------
	delete C from MarketDefinitionPacks C 
	inner join #t M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC --AND C.GroupNumber = M.GroupNumber and C.ATC4 = M.ATC4 and C.NEC4 = isnull(M.NEC4,'') and C.Manufacturer = isnull(M.Manufacturer,'')
	--and id not in (198252)

	-----INSERT COMIBNED MARKET BASES FOR COMMON PACKS--------
	insert into MarketDefinitionPacks select * from #aggregatedMarketBase

END


--[dbo].[CombineMultipleMarketBasesForAll]







GO

/****** Object:  StoredProcedure [dbo].[CreateUser]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[CreateUser] 
CREATE PROCEDURE [dbo].[CreateUser]
 @UserName varchar(300), @FirstName varchar(80), @LastName varchar(80),
 @Email varchar(300), @Pwd varchar(50), @RoleID int, @UserType int
AS
BEGIN
declare @id int
If (select count(*) from [dbo].[User] where username=@UserName)=0 
Begin
INSERT INTO  [dbo].[User]
           ([UserName]           ,[FirstName]           ,[LastName]
           ,[email]           ,[UserTypeID]           ,[IsActive]
           ,[ReceiveEmail]           ,[Password])
     VALUES (@UserName
           ,@FirstName          ,@LastName          ,@Email
           ,@UserType          ,1           ,1           ,@Pwd)
    
	set @id=@@IDENTITY       
--select * from [dbo].[User] order by UserID desc

--INSERT INTO  [dbo].[UserClient]
--           ([UserID]           ,[ClientId])
--     select 49, ? from clients
     
 INSERT INTO  [dbo].[UserRole]
           ([UserID]           ,[RoleId])
     VALUES  (@id           ,@RoleID)

end


SELECT *
  FROM  [dbo].[user] u
  join [dbo].[UserRole] ur on u.userid=ur.UserID
  join dbo.Role r on ur.RoleId=r.RoleID
  where u.username=@UserName
  
  /*
  INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (16,2)
     
     INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (17,16)
     INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (18,17)
     INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (19,18)
*/
--SELECT *
--  FROM  [dbo].[RoleAction] ra
--  join dbo.Role r on ra.RoleId=r.RoleID
--  join dbo.Action a on ra.ActionID=a.ActionID
--  join dbo.AccessPrivilege ap on ap.AccessPrivilegeID=ra.AccessPrivilegeID
--  join dbo.Module m on a.ModuleID=m.ModuleID
--  join dbo.Section s on m.SectionID=s.SectionID
--  where ra.RoleId=5 and  a.ActionName='Use global navigation toolbar'
/*
SELECT  u.UserID,u.UserName,u.FirstName,u.LastName,u.Password,u.email,r.RoleName,c.Name Client
  FROM [ECP].[dbo].[User] u
  join dbo.UserRole ur on u.UserID=ur.userid
  join [Role] r on ur.RoleId=r.RoleID
  join dbo.UserClient uc on u.UserID=uc.UserID
  join dbo.Clients c on uc.ClientId=c.Id 
   where u.UserID>=14 and UserTypeID=2
   order by UserName 
   */
  
END





GO
/****** Object:  StoredProcedure [dbo].[CreateUserFromList]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[CreateUserFromList] 
CREATE PROCEDURE [dbo].[CreateUserFromList]

AS
BEGIN
declare @UserName varchar(300), @FirstName varchar(80), @LastName varchar(80),
 @Email varchar(300), @Pwd varchar(50), @RoleID int, @UserType int,
 @Role varchar(100)
DECLARE user_cursor CURSOR FOR   
   SELECT TOP 1000 [Users]      ,[First Name]
      ,[Last Name]      ,[Role]
  FROM [ECP].[dbo].[z_UserList]
   where users like '%au.imshe%'

    OPEN user_cursor  
    FETCH NEXT FROM user_cursor INTO @UserName,@FirstName,@LastName,@Role
   

    WHILE @@FETCH_STATUS = 0  
    BEGIN  

	select @Roleid=RoleId from dbo.role where rolename like '%'+@Role+'%'

      exec  [dbo].[CreateUser] @UserName , @FirstName, @LastName ,
 @UserName, 'ECP888',@Roleid, 1
     FETCH NEXT FROM user_cursor INTO @UserName,@FirstName,@LastName,@Role
        END  

    CLOSE user_cursor  
    DEALLOCATE user_cursor  
        -- Get the next vendor.  

  
END





GO
/****** Object:  StoredProcedure [dbo].[CreateUserRolefromList]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[CreateUserFromList] 
CREATE PROCEDURE [dbo].[CreateUserRolefromList]

AS
BEGIN
declare @UserName varchar(300), @FirstName varchar(80), @LastName varchar(80),
 @Email varchar(300), @Pwd varchar(50), @RoleID int, @UserType int, @userid int,
 @Role varchar(100)
DECLARE user_cursor CURSOR FOR   
   SELECT [Role],userid
  FROM [ECP].[dbo].[z_UserList] ul join dbo.[user] u on ul.users=u.username
   where users like '%au.imshe%'

    OPEN user_cursor  
    FETCH NEXT FROM user_cursor INTO @Role,@userid

    WHILE @@FETCH_STATUS = 0  
    BEGIN  

	print @Role
	if @Role='GTM'
	set @Roleid=3
	else
	select @Roleid=RoleId from dbo.role where rolename like '%'+rtrim(ltrim(@Role))+'%'

     if (select count(*) from userrole where userid=@userid and roleid=@RoleID)=0
	 INSERT INTO  [dbo].[UserRole]
           ([UserID]           ,[RoleId])
     VALUES  (@userid           ,@RoleID)

     FETCH NEXT FROM user_cursor INTO @Role,@userid
        END  

    CLOSE user_cursor  
    DEALLOCATE user_cursor  
        -- Get the next vendor.  

  
END





GO
/****** Object:  StoredProcedure [dbo].[DeleteMarketBase]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteMarketDefinition]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DeleteMarketDefinition]
@MarketDefID as int
AS
BEGIN
	Delete from DeliveryMarket Where MarketDefId=@MarketDefID
	Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)
	Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID
	Delete From MarketDefinitionPacks Where MarketDefinitionId=@MarketDefID
	Delete From MarketDefinitions Where Id=@MarketDefID
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteMarketDefinitionBaseMap]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DeleteMarketDefinitionBaseMap]
@MarketDefID as int
AS
BEGIN
	Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)
	Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteSubscibedID]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DeleteSubscibedID]
@DefID as int,
@Module as nvarchar(100)

AS
BEGIN
       IF @Module='Market Definition'
       BEGIN
       Delete from DeliveryMarket Where MarketDefId=@DefID
       END

       IF @Module='Territory Definition'
       BEGIN
             Delete from DeliveryTerritory Where TerritoryId=@DefID
       END

END


GO

/****** Object:  StoredProcedure [dbo].[GetAllBricks]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllBricks] 
AS
BEGIN
	SET NOCOUNT ON;

select Brick Code, BrickName Name, Address, 
BannerGroup,State, Panel, BrickLocation as BrickOutletLocation,
'brick' Type from dbo.tblBrick
	
END


GO
/****** Object:  StoredProcedure [dbo].[GetAllOutlets]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllOutlets] 
	@Role int = NULL
AS
BEGIN
	SET NOCOUNT ON;
if(@Role <> 1)
begin
	select cast(Outlet as nvarchar) Code, OutletName Name, Address, 
	BannerGroup,State, Panel, OutletLocation as BrickOutletLocation,
	'outlet' Type from dbo.tblOutlet
	where panel <> 'O'
end

else
begin
	select cast(Outlet as nvarchar) Code, OutletName Name, Address, 
	BannerGroup,State, Panel, OutletLocation as BrickOutletLocation,
	'outlet' Type from dbo.tblOutlet
end
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetBroadcast_Emails]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetClientMarketBase]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetClientMarketBaseDetails]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	  ,MB.BaseType
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
  order by  MarketBaseName

	
END





GO
/****** Object:  StoredProcedure [dbo].[GetEffectedMarketDefName]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetLandingPageContents]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetLandingPageContents_bk]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetMarketBaseForMarketDef]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetPacksFromClientMarketBase]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetPacksFromClientMarketBase]  1," " "Org_Long_Name like 'A PAK%' AND ProductName like '1000 HOUR%'"
--
CREATE PROCEDURE [dbo].[GetPacksFromClientMarketBase]    
 @Clientid int  ,  
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
  --if @searchType = 0   
  -- set @whereClause = @whereClause + ' and Pack_Description like '''  + @searchString + '%'''  
  -- else  
  -- set @whereClause = @whereClause + ' and Pack_Description like ' + '''%' + @searchString + '%''' 
  if len(@searchString) > 1
     set @whereClause = @whereClause + ' and ' + @searchString
  set @selectSql = 'insert into #Result select distinct ''' + @MarketBaseName + ''', Pack_Description from DimProduct_Expanded A
   left join  dbo.DMMolecule B on A.FCC = B.FCC ' + @whereClause    
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
/****** Object:  StoredProcedure [dbo].[GetPacksFromMarketBase]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetPacksFromMarketBaseMap]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetPacksFromMarketBaseMap_OLD]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetUpdatedBricks]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetUpdatedBricks] 
	-- Add the parameters for the stored procedure here
	@TerritoryId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select   A.BrickId Code, A.BrickName Name, A.Address Address, A.BannerGroup, A.State, A.Panel, A.BrickOutletLocation,
--B.BannerGroup, B.State, B.Panel,
'brick' Type from
(select Brick as BrickId, BrickName, ISNULL(Address, '') Address, ISNULL(BannerGroup, '') BannerGroup, State, Panel, BrickLocation as BrickOutletLocation from tblBrick 
except
select BrickOutletCode, BrickOutletName, ISNULL(Address, '') Address, BannerGroup, State, Panel, BrickOutletLocation from OutletBrickAllocations
where TerritoryId = @TerritoryId and Type = 'brick')A
--join tblBrick B
--on A.BrickId=B.brick and A.BrickName=b.BrickName
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetUpdatedOutlets]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	cast(A.OutletId as nvarchar) Code, A.OutletName Name, A.Address, A.BannerGroup, A.State, A.Panel, A.BrickOutletLocation, 
	--B.BannerGroup, B.State, B.Panel,
	'outlet' Type from
	(
		select cast(Outlet as nvarchar) OutletId, OutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, OutletLocation as BrickOutletLocation from tblOutlet 
			except
		select BrickOutletCode, BrickOutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, BrickOutletLocation from OutletBrickAllocations
		where TerritoryId = @TerritoryId and Type = 'outlet'
	)A
	where A.panel <> 'O'
end
else
begin
	select --ROW_NUMBER() OVER( ORDER BY A.OutletId) as NID, 
	cast(A.OutletId as nvarchar) Code, A.OutletName Name, A.Address, A.BannerGroup, A.State, A.Panel, A.BrickOutletLocation,
	--B.BannerGroup, B.State, B.Panel,
	'outlet' Type from
	(
		select cast(Outlet as nvarchar) OutletId, OutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, OutletLocation as BrickOutletLocation from tblOutlet 
			except
		select BrickOutletCode, BrickOutletName, rtrim(ltrim(Address)) Address, BannerGroup, State, Panel, BrickOutletLocation from OutletBrickAllocations
		where TerritoryId = @TerritoryId and Type = 'outlet'
	)A
end
END

--exec [dbo].[GetUpdatedOutlets] @TerritoryId=N'1031'

--select top 10 * from dimoutlet
--select top 10 * from tblOutlet
--select top 10 * from tblBrick
--




GO
/****** Object:  StoredProcedure [dbo].[InsertTerritoryIdGroupTable]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[IRPDeleteGroupsLevelsBricks]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IRPDeleteGroupsLevelsBricks] 
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	declare @rootGroupId int;
	
	--------delete from OutletBrickAllocations--------
	delete from OutletBrickAllocations where TerritoryId = @pTerritoryId;
	
	--------delete from Groups--------
	select @rootGroupId = RootGroup_id from Territories where Id = @pTerritoryId;
	update Territories set RootGroup_id = NULL where Id = @pTerritoryId;
	;WITH CTEGroups AS (
	  SELECT *
	  FROM Groups
	  WHERE Id = @rootGroupId
	  UNION ALL
	  SELECT t1.*
	  FROM Groups t1 INNER JOIN
	  CTEGroups v ON t1.ParentId = v.Id
	 )
	DELETE
	FROM Groups
	WHERE Id IN (SELECT Id FROM CTEGroups);
	
	--------delete from Levels--------
	delete from Levels where TerritoryId = @pTerritoryId;
	
END


GO
/****** Object:  StoredProcedure [dbo].[IRPDeleteMarketDefinitionFromDimensionID]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[IRPDeleteMarketDefinitionFromDimensionID]
@DimensionID as int
AS
BEGIN
Declare @MarketDefID int
select @MarketDefID=ID from MarketDefinitions where DimensionID=@DimensionID
print(@MarketDefID)
	Delete from DeliveryMarket Where MarketDefId=@MarketDefID
	Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)
	Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID
	Delete From MarketDefinitionPacks Where MarketDefinitionId=@MarketDefID
	Delete From MarketDefinitions Where Id=@MarketDefID
END

GO
/****** Object:  StoredProcedure [dbo].[IRPDeleteTerritory]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select top 100 * from groups

CREATE PROCEDURE [dbo].[IRPDeleteTerritory] 
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	declare @rootGroupId int;
	
	--Read deliverables id before deleting territory
	
	DECLARE @TempDelivery TABLE ( DeliverableId int)
	insert into @TempDelivery (DeliverableId) select distinct DeliverableId from DeliveryTerritory where TerritoryId = @pTerritoryId
	
	--------delete from DeliveryTerritory--------
    delete From DeliveryTerritory Where TerritoryID=@pTerritoryId;

	--------delete from OutletBrickAllocations--------
	delete from OutletBrickAllocations where TerritoryId = @pTerritoryId;
	
	--------delete from Groups--------
	select @rootGroupId = RootGroup_id from Territories where Id = @pTerritoryId;
	update Territories set RootGroup_id = NULL where Id = @pTerritoryId;
	;WITH CTEGroups AS (
	  SELECT *
	  FROM Groups
	  WHERE Id = @rootGroupId
	  UNION ALL
	  SELECT t1.*
	  FROM Groups t1 INNER JOIN
	  CTEGroups v ON t1.ParentId = v.Id
	 )
	DELETE
	FROM Groups
	WHERE Id IN (SELECT Id FROM CTEGroups);
	
	--------delete from Levels--------
	delete from Levels where TerritoryId = @pTerritoryId;

	--------delete from Territories--------
	delete from Territories where Id = @pTerritoryId;
	
	-- update Restriction level in Deliverables 
		
		declare @Delid int,@Restrictionid int,@LvlNo int
		while exists (select DeliverableId from @TempDelivery)
		begin
			Set @LvlNo=0
			select top 1 @Delid = DeliverableId from @TempDelivery order by DeliverableId asc
			--
			select @Restrictionid = RestrictionId from Deliverables where DeliverableId=@Delid
			if @Restrictionid is not null and @Restrictionid > 0
				begin
				select @LvlNo=min(lvl) from(
				select max(LevelNumber)lvl from [Levels] where TerritoryId in(select TerritoryId from DeliveryTerritory
						where DeliverableId =@Delid) group by TerritoryId )x

				if  @Restrictionid > @LvlNo or @LvlNo is null
				begin
					Update Deliverables set RestrictionId=null where DeliverableId=@Delid
				end
			end

			delete @TempDelivery  where DeliverableId = @Delid

		end
END

-- TO TEST --
---------------------------------------------
	--select * from territories
	--select * from groups where id >= 1470
	--declare @id int
	--set @id = 1116
	--select * from Territories where id = @id order by 1
	--select * from Levels where TerritoryId = @id
	--select * from Groups where TerritoryId = @id --and CustomGroupNumberSpace is null--and levelNo = 3 order by LevelNo
	--select * from OutletBrickAllocations where TerritoryId = @id --order by 
---------------------------------------------

--[dbo].[IRPDeleteTerritory] 1116


/****** Object:  StoredProcedure [dbo].[IRPImportDeliverablesIAM]    Script Date: 10/11/2017 2:43:37 AM ******/

/****** Object:  StoredProcedure [dbo].[IRPImportDeliverablesIAM]    Script Date: 5/12/2017 3:54:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IRPImportDeliverablesIAM]
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
			/*
			set frequencyType as below based on WriterparamterValue..
			 if '0' --monthly
			'1','2','3' --quarterly
			'22','23','24','25' --tri 
			'4','5','6','7','8','9' --biannual
			'10','11','12','13','14','15','16','17','18','19','20','21' --annual
			if no entry --weekly
			*/
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
			else if @Service = 'PROBE Packs Manufacturer' or @Service ='PROBE Packs Exceptions' or @Service = 'PROBE Pack Manufacturer'
				set @Service = 'PROBE'
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



GO

/****** Object:  StoredProcedure [dbo].[IRPImportDeliverablesNonIAM]    Script Date: 10/11/2017 2:46:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec IRPImportDeliverablesNonIAM 044
CREATE procedure [dbo].[IRPImportDeliverablesNonIAM]
( @ClientNo int)
As
BEGIN

	DECLARE @RowsToProcess  int,@RP int
	DECLARE @CurrentRow     int,@CR int

	DECLARE @ClientId  int,@ClientName varchar(500),@bkt_Sel varchar(100),@cat_Sel varchar(100),@RptNo int,@RptName varchar(500)
	
	DECLARE @Lvl_total char(8)

	DECLARE @Value int,@writerParamId int,@WriterId int
	DECLARE @FreqType int,@FreqId int, @Period varchar(50), @Service varchar(100),@DataType varchar(100), @Source varchar(100),@DeliveryType varchar(100),@ReportWriterCode varchar(50),
	@XREFClient int

	DECLARE @Deliverables TABLE (RowID int not null primary key identity(1,1), Clientid int,ClientName varchar(100), BKT_SEL varchar(100),CAT_SEL varchar(100),
	FreqType int,Frequency int, Period varchar(100), [Service] varchar(100),DataType varchar(100), Source varchar(100),ReportWriter varchar(50),Country varchar(10),DeliveryType varchar(100),
	 RPT_NO int, XREF_Client int, report_name varchar(500),  lvl_total char(8))  
	--Kimberley Clark - 412,AZ - 044,NicePak - 017,P&G - 481

	--set @ClientNo =044
	set @DeliveryType='FlatFile'
	--Get Client Id
	 --Select @ClientId = ClientId, @ClientName = ClientName from IRP.Client where ClientNo=@ClientNo and VersionTo=32767
	   /*  This  below change is done to accomadate the client Merging done in Everest */
		Select  @ClientId =irpclientid, @ClientName =Name from dbo.Clients where id in (
		select clientID from irp.ClientMap where IRPClientNo = @ClientNo )
	 
	DECLARE @table1 TABLE (RowID int not null primary key identity(1,1), clientNo int,rptNo int, bkt_sel varchar(100),cat_sel varchar(100),XREF_Client int,rptSelection varchar(500),report_name varchar(500), lvl_total char(8) )  
	INSERT into @table1 (clientNo,rptNo, bkt_sel, cat_sel, XREF_Client,rptSelection,report_name, lvl_total)
	select  CLD.CLIENT_NO, CLD.RPT_NO, BKT_SEL, CAT_SEL, XREF_CLIENT,RPT_SELECTION, report_name,lvl_total from IRP.CLD 
	inner join IRP.RD on CLD.CLIENT_NO = RD.CLIENT_NO and CLD.RPT_NO = RD.RPT_NO
	where CLD.CLIENT_NO=@ClientNo and RD.RPT_SELECTION not in ('ID','IA','IB','IW')

	SET @RowsToProcess=@@ROWCOUNT
	--select * from @table1
	SET @CurrentRow=0
	WHILE @CurrentRow<@RowsToProcess
	BEGIN
		SET @CurrentRow=@CurrentRow+1
		SELECT  @RptNo =rptNo,  @RptName=report_name, @bkt_Sel = BKT_SEL,@cat_Sel= cat_sel, @ReportWriterCode = rptSelection, @XREFClient=XREF_Client, @Lvl_total = lvl_total
		FROM @table1 WHERE RowID=@CurrentRow
			
			--Report writer
			--select * from IRP.CLD where CLIENT_NO = 44 and RPT_SELECTION not in ('ID','IA','IB','IW')
			-- Frequency
			set @FreqType=1 -- monthly
			set @FreqId = 1 
			--Source
			Set @source ='Sell In'
			
			
			--Period
			if @bkt_Sel = 'F1M1'  or @bkt_Sel = 'H1M1' or @bkt_Sel = 'OA1Y'
			set @Period = '1 Year'
			else if @bkt_Sel = 'FLT1'  or @bkt_Sel = 'FLT2' or @bkt_Sel = 'H2M1' or @bkt_Sel = 'H2W1' or @bkt_Sel = 'OA2Y' or @bkt_Sel = 'RXF2' or @bkt_Sel = 'T1RA' or @bkt_Sel = 'T5UN'
			set @Period = '2 Years'
			else if @bkt_Sel = 'F3M1'  or @bkt_Sel = 'F3M2' or @bkt_Sel = 'F3M3' or @bkt_Sel = 'H3M1'
			set @Period = '3 Years'
			else if @bkt_Sel = 'F5M1'  or @bkt_Sel = 'F5M2' or @bkt_Sel = 'F5M3' or @bkt_Sel = 'H5M1' or @bkt_Sel = 'H5M3'
			set @Period = '5 Years'
			
			--select * from dbo.CLIENTEXCEPTIONS where ClientNo=44
			--select * from dbo.ClientMfr where ClientNo=44
		
		insert into @Deliverables(clientid,ClientName, cat_sel, FreqType,Frequency, Period, [Service],DataType,Source,ReportWriter,country,deliveryType,RPT_NO, XREF_Client, report_name, lvl_total )
			values (@ClientId,@ClientName, @cat_Sel, @FreqType,@FreqId,@Period,@Service,@DataType,@Source,@ReportWriterCode,'AUS',@DeliveryType,@RptNo,@XREFClient, @rptname, @Lvl_total)
		

	END
--select * from @Deliverables
insert into dbo.IRG_Deliverables_NonIAM
	select * from @Deliverables
-- Insert records into subscription & deliverables from IRG_Deliverables_IAM table
	execute dbo.IRPProcessDeliverablesNonIAM
	
	delete from dbo.IRG_Deliverables_NonIAM where Clientid=@ClientId
END

GO


--EXEC IRPImportDeliverablesIAM 481


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportDeliveryMarketAndTerritory]
AS
BEGIN
	SET NOCOUNT ON;

	Print ' Linking  the Delivery To Market'
	---insert into deliveryMarket table
	select distinct a.deliverableid, e.id marketdefinitionid into #tm1 
	from deliveryreport a 
	join (select distinct reportid, value from IRP.ReportParameter where code = 'DimProd' and versionto = 32767)d on a.reportid = d.reportid
	join MarketDefinitions e on e.dimensionid = d.value

	select distinct a.deliverableid, e.id MarketDefinitionId into #tm2
	from deliveryreportname a 
	join IRP.Dimension c on a.ReportName = c.DimensionName
	join MarketDefinitions e on e.dimensionid = c.DimensionId
	where c.versionto > 0

	MERGE [dbo].[deliverymarket] AS TARGET
	USING #tm1 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.MarketDefId=SOURCE.MarketDefinitionId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, MarketDefId)
	values(SOURCE.deliverableid, SOURCE.MarketDefinitionId)
	;

	MERGE [dbo].[deliverymarket] AS TARGET
	USING #tm2 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.MarketDefId=SOURCE.MarketDefinitionId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, MarketDefId)
	values(SOURCE.deliverableid, SOURCE.MarketDefinitionId)
	;

	---insert into deliveryTerritory table
	
	Print ' Linking  the Delivery To Territory 1'
	select distinct a.deliverableid, e.id TerritoryId into #tt1
	from deliveryreport a 
	join (select distinct reportid, value from IRP.ReportParameter where code = 'DimGeog' and versionto = 32767)d on a.reportid = d.reportid
	join Territories e on e.dimensionid = d.value

	select distinct a.deliverableid, e.id TerritoryId into #tt2
	from deliveryreportname a 
	join IRP.Dimension c on a.ReportName = c.DimensionName
	join Territories e on e.dimensionid = c.DimensionId
	where c.versionto > 0
	

	
	MERGE [dbo].[deliveryTerritory] AS TARGET
	USING #tt1 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.TerritoryId=SOURCE.TerritoryId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, TerritoryId)
	values(SOURCE.deliverableid, SOURCE.TerritoryId)
	;
	Print ' Linking  the Delivery To Territory 1 completed successfully'
	Print ' Linking  the Delivery To Territory 2 Starting'
	MERGE [dbo].[deliveryTerritory] AS TARGET
	USING #tt2 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.TerritoryId=SOURCE.TerritoryId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, TerritoryId)
	values(SOURCE.deliverableid, SOURCE.TerritoryId)
	;

	---------INCLUDE MISSING MARKET BASES TO SUBSCRIPTION

	Print ' Linking  the Subscription To Market Started '
	select distinct subscriptionid, marketbaseid into #tmb from(
		select c.subscriptionid, a.*, e.marketbaseid from deliverymarket a 
		join deliverables b on a.deliverableid = b.deliverableid
		join subscription c on c.subscriptionid = b.subscriptionid
		join marketdefinitionbasemaps e on e.marketdefinitionid = a.marketdefid
	)A

	MERGE [dbo].[subscriptionmarket] AS TARGET
	USING #tmb AS SOURCE
	ON (TARGET.subscriptionid=SOURCE.subscriptionid AND TARGET.marketbaseid=SOURCE.marketbaseid)

	WHEN NOT MATCHED BY TARGET THEN
	insert(subscriptionid, marketbaseid)
	values(SOURCE.subscriptionid, SOURCE.marketbaseid)
	;

	Print ' Linking  the Subscription To Market completed '
	
END
GO

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
	--select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name +' ' + M.Suffix, D.MarketBaseId, 'dynamic', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, Molecule)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + 
		case when c.FilterValue = 'Molecule' then c.ColumnName + ' like ' + '(' + left([Values], 1) + '%' + substring([Values], 2, len([Values]) -2) + '%' + right([Values], 1) +')'
		else c.ColumnName + ' in ' + '(' + [Values] +')'  end 
		from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
		where MarketBaseId = @pMarketBaseId
		print('where clause :' +@whereClause)

		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''dynamic'', ' + cast(@marketDefinitionId as varchar) + ', ''dynamic-right'' 
		, ProductName as Product, M.Description as Molecule from DimProduct_Expanded left join DMMoleculeConcat M on M.FCC = DimProduct_Expanded.FCC' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end


	drop table #loopTable
	declare @finalQuery varchar(max)
	print('union clause:' +@unionClause)
	print('in+unclause: ' + @insertStatement+@unionClause)
					
	set @finalQuery = left(@insertStatement+@unionClause, len(@insertStatement+@unionClause)-6)
		
	print('Final Query: ' + @finalQuery)
	EXEC(@finalQuery)
	
	update marketdefinitionpacks
	set groupname=''
	where groupname is null

	update marketdefinitionpacks
	set groupnumber=''
	where groupnumber is null	
	
	--EXEC(@finalQuery)
	
	--select * from MarketDefinitionPacks
END


--[dbo].[IRPImportMarketDefinition] 2150
--[dbo].[IRPImportMarketDefinition] 3916
--[dbo].[IRPImportMarketDefinition] 4280
--[dbo].[IRPImportMarketDefinition] 2812




GO




CREATE PROCEDURE [dbo].[IRPImportPackBaseMarketDefinition] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	--select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name + ' ' + M.Suffix , D.MarketBaseId, 'static', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)

	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 

	select top 1 @marketBaseId=Id, @marketBaseName=Name + ' ' + Suffix 
	from MarketBases M join IRP.DimensionBaseMap D on M.Id = D.MarketBaseId
	where D.DimensionId = @pDimensionId

	--grouping information entry
	--declare @maxLevel int
	--select distinct @maxLevel=max(levelno) from irp.items where dimensionid=@pDimensionId
	--and shortname is not null or shortname<>'' and (number is not null or number<>'') and versionto=32767 
	---

	select  DISTINCT
	CASE WHEN TRY_CONVERT(int, p.item) IS not NULL   
    THEN p.item
    ELSE null  
    END AS FCC
	,p.Name,
	case Charindex(';', g.shortname)
	when 0 then ''
	when 1 then ''
	else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
	end as groupname,
	case Charindex(';', g.shortname)
	when 0 then ''
	when LEN(g.shortname) then ''
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
	and g.versionto > 0

	-----add on 28/11/2017


	/*select distinct groupname into #group from #fcctemp where groupname is not null or groupname <>''
	while not exists(select * from #group)
	begin
	    declare @maxLevel2 int
		select distinct @maxLevel2=max(i.levelno) from irp.items i join #fcctemp f on i.item=f.fcc where f.fcc is not null and i.versionto>0
		if(@maxLevel=@maxLevel2)
			Begin
				update f
				set f.groupname= (case Charindex(';', i.shortname)
					when 0 then null
					when 1 then null
					else Substring(i.shortname, 1,Charindex(';', i.shortname)-1)
					end),
				    f.factor= (case Charindex(';', i.shortname)
					when 0 then null
					when LEN(i.shortname) then null
					else Substring(i.shortname, Charindex(';', i.shortname)+8, LEN(i.shortname))
					end),
					f.groupno=i.number
				from #fcctemp f
				join irp.items i
				on f.fcc=i.item
				where i.dimensionid=@pDimensionId
				and i.versionto>0
				and f.groupname is null or f.groupname =''
				
			End
	end*/

	-----add end mayela

	insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, GroupNumber, GroupName, Factor, Molecule)
	select distinct p.Pack_Description, @marketBaseName, cast(@marketBaseId as varchar), p.PFC, p.ORG_LONG_NAME, p.ATC4_Code, p.NEC4_Code, 'static', cast(@marketDefinitionId as varchar), 'dynamic-right', p.[ProductName], f.groupno, f.groupname, f.factor, M.Description
	from DimProduct_Expanded p
	join #fcctemp f	on f.fcc = p.fcc
	left join DMMoleculeConcat M on M.FCC = p.FCC

	select count(*) from #fcctemp
	select 'def id:' + cast(@marketDefinitionId as varchar)

	

	-------------FOR STATIC LEFT -----------------
	select distinct ATC4 into #ATC4 from MarketDefinitionPacks where Alignment like '%right%' and MarketDefinitionID=@marketDefinitionId
	print('#ATC4 :')

	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, Molecule)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId
			
		IF EXISTS (select distinct Criteria from basefilters where MarketBaseId=@pMarketBaseId and criteria not like 'ATC%')
			BEGIN
				select @whereClause = ' where ATC4_code in (select * from #ATC4) AND  ' + 
				case when c.FilterValue = 'Molecule' then c.ColumnName + ' like ' + '(' + left([Values], 1) + '%' + substring([Values], 2, len([Values]) -2) + '%' + right([Values], 1) +')'
				else c.ColumnName + ' in ' + '(' + [Values] +')'  end  
				from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
				where MarketBaseId = @pMarketBaseId
				print('whereClause IF: ' + @whereClause)
			END
		ELSE
			BEGIN
				select @whereClause = ' where ' 
				+ 
				case when c.FilterValue = 'Molecule' then c.ColumnName + ' like ' + '(' + left([Values], 1) + '%' + substring([Values], 2, len([Values]) -2) + '%' + right([Values], 1) +')'
				else c.ColumnName + ' in ' + '(' + [Values] +')'  end  
				from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
				where MarketBaseId = @pMarketBaseId
				print('whereClause ELSE: ' + @whereClause)
			END 


		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''' MarketBase, ' + cast(@pMarketBaseId as varchar) + ' MarketBaseId, PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''static''  DataRefreshType, ' + cast(@marketDefinitionId as varchar) + ' MarketDefinitionId, ''static-left'' Alignment 
		, ProductName as Product, M.Description as Molecule from DimProduct_Expanded left join DMMoleculeConcat M on M.FCC = DimProduct_Expanded.FCC' + @whereClause + ' UNION '

		print('Union Clause')
		print(@unionClause)
		--EXEC(@insertStatement+@whereClause)

		delete #loopTable
		where MarketBaseId = @pMarketBaseId
	end


	drop table #loopTable
	declare @finalQuery varchar(max)
	set @unionClause = left(@unionClause, len(@unionClause)-6) 
	set @finalQuery = @insertStatement + 'select * from (' + @unionClause + ')Z where Z.PFC not in (select distinct PFC from dbo.DIMPRODUCT_EXPANDED where FCC in (select distinct FCC from #fcctemp))'
	--set @finalQuery = left(@insertStatement+@finalQuery, len(@insertStatement+@finalQuery) - 4)
	print('Final Query: ' + @finalQuery)

	
	EXEC(@finalQuery)
	
	drop table #fcctemp
	
	
	update marketdefinitionpacks set groupnumber = '' where groupnumber is null
	update marketdefinitionpacks set groupname = '' where groupname is null
	update marketdefinitionpacks set factor = '' where factor is null

END



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportMarketDefinitionMultipleMBAndPack] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	--## STEP 1: INSERT INTO MarketDefinitions
	insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
	--select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
	select DimensionName, NULL, C.ClientId, NULL, DimensionId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
	where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions

	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
	select M.Name +' ' + M.Suffix, D.MarketBaseId, 'static', @marketDefinitionId
	from IRP.DimensionBaseMap D join MarketBases M on D.MarketBaseId = M.Id
	where DimensionId = @pDimensionId

	--select * from MarketDefinitionBaseMaps

	--## STEP 3: INSERT INTO MarketDefinitionPacks
	declare @marketBaseId int
	declare @marketBaseName nvarchar(200)
	declare @whereClause nvarchar(max)
	declare @unionClause nvarchar(max)
	declare @insertStatement nvarchar(max) 
	set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, Molecule)'

	select * into #loopTable from IRP.DimensionBaseMap where DimensionId = @pDimensionId 

	declare @pMarketBaseId int
	set @unionClause = ''

	while exists(select * from #loopTable)
	begin
		-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
		select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
		select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId

		select @whereClause = ' where ' + 
		case when c.FilterValue = 'Molecule' then c.ColumnName + ' like ' + '(' + left([Values], 1) + '%' + substring([Values], 2, len([Values]) -2) + '%' + right([Values], 1) +')'
		else c.ColumnName + ' in ' + '(' + [Values] +')'  end 
		from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
		where MarketBaseId = @pMarketBaseId
		print(@whereClause)

		set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''static'', ' + cast(@marketDefinitionId as varchar) + ', ''static-left'' 
		, ProductName as Product, M.Description as Molecule from DimProduct_Expanded left join DMMoleculeConcat M on M.FCC = DimProduct_Expanded.FCC' + @whereClause + ' UNION '

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

	--grouping information entry
	--declare @maxLevel int
	--select distinct @maxLevel=max(levelno) from irp.items where dimensionid=@pDimensionId
	--and shortname is not null or shortname<>'' and (number is not null or number<>'') and versionto=32767 
	---

	select  DISTINCT
	CASE WHEN TRY_CONVERT(int, p.item) IS not NULL   
    THEN p.item
    ELSE null  
    END AS FCC
	,p.Name,
	case Charindex(';', g.shortname)
	when 0 then ''
	when 1 then ''
	else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
	end as groupname,
	case Charindex(';', g.shortname)
	when 0 then ''
	when LEN(g.shortname) then ''
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
	and g.versionto > 0

	update m set Alignment = 'dynamic-right',m.groupname=f.groupname,m.factor=f.factor,m.groupnumber=f.groupno
	from MarketDefinitionPacks m join dimproduct_expanded d on m.pfc=d.pfc join #fcctemp f on d.fcc=f.fcc
	where m.PFC in (select distinct PFC from dimproduct_expanded where FCC in (select distinct FCC from #fcctemp))
	and marketdefinitionid = @marketDefinitionId
	
	
	update marketdefinitionpacks set groupnumber = '' where groupnumber is null
	update marketdefinitionpacks set groupname = '' where groupname is null
	update marketdefinitionpacks set factor = '' where factor is null

 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportMarketDefinitionForClient] 
	-- Add the parameters for the stored procedure here
	@pClientId int 
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @dimensionId int
	declare @kount int
	declare @baseid int
	
	select distinct a.dimensionid into #tMkt from irp.dimension a
	join IRP.dimensionbasemap b on a.dimensionid=b.dimensionid
	where a.clientid in (select distinct irpclientid from irp.clientmap where clientid =@pClientId)
	and b.dimensionid not in (select distinct dimensionid from MarketDefinitions)
	and versionto=32767 and a.dimensionname not like '%PROBE Packs Exceptions%' 

	while exists(select * from #tMkt)
	begin
		select @dimensionId = (select top 1 dimensionid from #tMkt order by dimensionId asc)
		
		-- CHECK IF non-pack based market definition
		select @baseid = baseid from irp.dimension where dimensionid = @dimensionId
		if(@baseid <> 4)
		begin
			exec [dbo].[IRPImportMarketDefinition] @dimensionId
				exec [dbo].[IRPImportLogStatus] 'M', @pClientId, @dimensionId
		end

		else 
		begin
			--CHECK IF multiple MB pack based market definiton  
			select @kount = kount from
			(
				select distinct A.dimensionid, kount from 
				(
					select distinct Dimensionid, 
					count(Dimensionid) as kount from IRP.dimensionbasemap group by dimensionid having dimensionid = @dimensionId
				)A
				join irp.dimension B on A.dimensionid = B.dimensionid
				where B.versionto > 0 and B.baseid = 4 
			)X

			if(@kount > 1)
			begin
				exec [dbo].[IRPImportMarketDefinitionMultipleMBAndPack] @dimensionId
					exec [dbo].[IRPImportLogStatus] 'M', @pClientId, @dimensionId
			end

			--CHECK IF single MB pack based market definiton 
			if(@kount = 1)
			begin
				exec [dbo].[IRPImportPackBaseMarketDefinition] @dimensionId
					exec [dbo].[IRPImportLogStatus] 'M', @pClientId, @dimensionId
			end

		end

		delete #tMkt where dimensionid = @dimensionId

	end
	drop table #tMkt

	---SP to combine marketbase

	EXEC [CombineMultipleMarketBasesForAll]

END
GO

GO

create PROCEDURE [dbo].[PopulateMaintenanceCalendar] 
AS
BEGIN

Update Maintenance_Calendar
Set Schedule_From=a.Schedule_From,Schedule_To=a.Schedule_To
From Maintenance_Calendar_Staging a
Join  Maintenance_Calendar b on a.[year]=b.[year] and LEFT(a.Month,3)=LEFT(b.Month,3)

INSERT INTO  [dbo].[Maintenance_Calendar]
           ([Year]           ,[Month]
           ,[Schedule_From]           ,[Schedule_To]
           ,[ActionDate])
Select		a.[Year]           ,a.[Month]
           ,a.[Schedule_From]           ,a.[Schedule_To]
           ,a.[ActionDate]
from Maintenance_Calendar_Staging a
left join  Maintenance_Calendar b on a.[year]=b.[year] and LEFT(a.Month,3)=LEFT(b.Month,3)
where b.ID is null


END





GO
/****** Object:  StoredProcedure [dbo].[prGetMarketBase]    Script Date: 25/09/2017 10:44:14 PM ******/
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
                           SELECT CMB.[MarketBaseId] as [Id]
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
					  JOIN Subscription S
					  ON CMB.[ClientId] =S.ClientId
					  JOIN SubscriptionMarket SM
					  ON SM.SubscriptionId = S.SubscriptionId and SM.MarketbaseId = CMB.[MarketBaseId]
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
                           SELECT CMB.[MarketBaseId] as [Id]
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
					  JOIN Subscription S
					  ON CMB.[ClientId] =S.ClientId
					  JOIN SubscriptionMarket SM
					  ON SM.SubscriptionId = S.SubscriptionId and SM.MarketbaseId = CMB.[MarketBaseId]
                      left join 
                           (select distinct MarketBaseId from MarketDefinitionBaseMaps where MarketDefinitionId in (@MarketDefId))A on A.MarketBaseId = CMB.[MarketBaseId]
                      WHERE CMB.[ClientId]=@ClientId
                    )X
       END
END



GO
/****** Object:  StoredProcedure [dbo].[procBuildQueryFromMarketBase]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ProcessAllMarketDefinitionsForDelta]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	EXEC [CombineMultipleMarketBasesForAll]
END


--[dbo].[ProcessPacksFromMarketBaseMap] 430,653,569
--[dbo].[ProcessMarketDefinitionForNewDataLoad] 430
--select * from MarketDefinitionBaseMaps where MarketDefinitionId = 430
--select * from MarketDefinitions







GO
/****** Object:  StoredProcedure [dbo].[ProcessMarketDefinitionForNewDataLoad]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ProcessPacksFromMarketBaseMap]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	set @whereClause = replace(@whereClause, '&amp;', '&')
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

		set @additionalFilterConditions = replace(@additionalFilterConditions, '&amp;', '&')
		print('Additional Filters: ' + @additionalFilterConditions)
	end
	--------Final SELECT query CONSTRUCTION-----------
	--print('reached inside final query')
	set @selectSql = 'select distinct ' + cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, PFC, DIMProduct_Expanded.FCC from DimProduct_Expanded' 
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

	print('PACK IN HISTORY: ')
	select * from #packInHistory

	------Market Definition Packs update----------
	-----------INSERT NEW PACKS--------------
	select distinct Pack_Description as Pack, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' MarketBase, PS.MarketBaseId MarketBaseId, '' GroupNumber, '' GroupName, '' Factor, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, 'XXXXXXXX' DataRefreshType, '' as StateStatus, @MarketDefinitionId as MarketDefinitionId, 'XXXXXXXXXXXXXXX' Alignment, P.ProductName as Product,  MC.Description as Molecule
	into #newPacks
	from #packInHistory PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	left join DMMoleculeConcat MC
	on P.Fcc=MC.FCC
	where PS.CHANGE_FLAG = 'A'

	print('new packs:' )
	--select * from #newPacks

	update #newPacks set MarketBase = MB.Name + ' ' + MB.Suffix
	from MarketBases MB 
	where MB.Id = #newPacks.MarketBaseId 

	----
	update #newPacks set DataRefreshType= MD.DataRefreshType, 
	Alignment = MD.DataRefreshType + '-' + case when MD.DataRefreshType = 'static' then 'left' else 'right' end 
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

	insert into MarketDefinitionPacks 
	select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, 'A' Change_Flag, Molecule  
	from #packsToInsert
	
	print('#packsToInsert:' )
	select * from #packsToInsert

	-----------DELETE PACKS--------------
	delete from MarketDefinitionPacks 
	where PFC in 
   --and MarketBaseId = @MarketBaseId 
		(
			select distinct PFC from #packInHistory where CHANGE_FLAG = 'D'
		)

	-----------UPDATE MODIFIED PACKS--------------
	select distinct Pack_Description as Pack, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, P.ProductName as Product, MC.Description as Molecule
	into #modifiedPacks
	from #packInHistory PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	left join DMMoleculeConcat MC
	on P.Fcc=MC.FCC
	where PS.CHANGE_FLAG = 'M'

	
	--print('Modified Packs: ')
	--select * from #modifiedPacks
	update MarketDefinitionPacks 
	set Pack=M.Pack, Manufacturer=M.Manufacturer, ATC4=m.ATC4, NEC4=M.NEC4, Product=M.Product, Molecule=M.Molecule
	from MarketDefinitionPacks MD join #modifiedPacks M on MD.PFC = M.PFC 

END


--[dbo].[ProcessPacksFromMarketBaseMap] 430,653,56




GO
/****** Object:  StoredProcedure [dbo].[ProcessTerritoryForDelta]    Script Date: 25/09/2017 10:44:14 PM ******/
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
	from DimOutlet where BRICK_CHANGE_FLAG = 'D') A 
	on A.Brick = O.BrickOutletCode 
	where O.type = 'brick'

	---MODIFY BRICKS---
	update O 
	set O.BrickOutletName = A.BrickName
	from OutletBrickAllocations O  
	join 
	(select DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName
	from DimOutlet where BRICK_CHANGE_FLAG = 'M') A 
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
/****** Object:  StoredProcedure [dbo].[RemoveExpiredMarketBases]    Script Date: 25/09/2017 10:44:14 PM ******/
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

		DELETE FROM  [dbo].[MarketDefinitionBaseMaps]
		WHERE [MarketBaseId]=@MyField

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

	DELETE FROM [dbo].[SubscriptionMarket] 
	WHERE MarketBaseId = @MyField


	
	-----------REMOVE MARKET DEFINITINO IF IT HAD ONLY MB
	SELECT DISTINCT [MarketDefinitionId]
	INTO #TEMP
	FROM [dbo].[MarketDefinitionPacks]
	WHERE [MarketBaseId]=@MyField

	----------------------------------------------------------
		DECLARE @Count1 int;
		DECLARE @MyCursor1 CURSOR;
		DECLARE @MyField1 int;
		BEGIN
			SET @MyCursor1 = CURSOR FOR
			SELECT DISTINCT [MarketDefinitionId] from #TEMP
        

			OPEN @MyCursor1 
			FETCH NEXT FROM @MyCursor1
			INTO @MyField1

			WHILE @@FETCH_STATUS = 0
			BEGIN
			  SELECT @Count1=COUNT(*) from #TEMP
			  WHERE [MarketDefinitionId]=@MyField1 
			  IF(@Count1>0) 
					BEGIN
						DELETE FROM [dbo].[MarketDefinitions]
						WHERE ID=@MyField1
						delete from deliverymarket where marketdefid =  @MyField1
					END

			  FETCH NEXT FROM @MyCursor1 
			  INTO @MyField1 
			END; 

			CLOSE @MyCursor1 ;
			DEALLOCATE @MyCursor1;
		END;

	----------------------------------------------------------


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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UnsubscribeMarketBase] 
	-- Add the parameters for the stored procedure here
	@MarketBaseId int,
	@SubscriptionId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--select name + ' ' + suffix from marketbases where id = 3213
	declare @marketbasename varchar(500)
	select @marketbasename  = name + ' ' + suffix from marketbases where id = @MarketBaseId

	SELECT DISTINCT [MarketDefinitionId]
	INTO #TEMP
	FROM [dbo].[MarketDefinitionBaseMaps]
	WHERE [MarketBaseId]=cast(@MarketBaseId as varchar)


--to del market base

--DELETE FROM dbo.AdditionalFilters 
--where marketdefinitionbasemapid in (select id from [dbo].[MarketDefinitionBaseMaps] where [MarketBaseId]=@MarketBaseId)

--DELETE FROM  [dbo].[MarketDefinitionBaseMaps]
--WHERE [MarketBaseId]=@MarketBaseId

--DELETE FROM [dbo].[MarketDefinitionPacks]
--WHERE [MarketBaseId]=@MarketBaseId

---for MarketDefinitionPacks
	DELETE FROM [dbo].[MarketDefinitionPacks]
	WHERE [MarketBaseId]=cast(@MarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar), '')
	,[MarketBase] = replace([MarketBase], ','+cast(@marketbasename as varchar), '')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@MarketBaseId as varchar)+',', '')
	,[MarketBase] = replace([MarketBase], cast(@marketbasename as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@MarketBaseId as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar)+',', ',')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MarketBaseId as varchar)+',%'

	-------considering space---------

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar), '')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar), '')
	WHERE [MarketBaseId] LIKE '%, '+cast(@MarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@MarketBaseId as varchar)+',', '')
	,[MarketBase] = replace([MarketBase], cast(@MarketBaseName as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@MarketBaseId as varchar)+' ,%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar)+',', ',')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%, '+cast(@MarketBaseId as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar)+',', ',')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MarketBaseId as varchar)+' ,%'

	DELETE FROM [dbo].[SubscriptionMarket] 
	WHERE MarketBaseId = @MarketBaseId and subscriptionid = @SubscriptionId

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
      SELECT @Count=COUNT(*) from marketdefinitionbasemaps
	  WHERE [MarketDefinitionId]=@MyField 
	  	
		DELETE FROM dbo.AdditionalFilters 
		where marketdefinitionbasemapid in 
			(select id from [dbo].[MarketDefinitionBaseMaps] where [MarketBaseId]=@MarketBaseId and marketdefinitionid = @MyField)

		DELETE FROM  [dbo].[MarketDefinitionBaseMaps]
		WHERE [MarketBaseId]=@MarketBaseId and marketdefinitionid = @MyField
	  
	  IF(@Count=1) 
			BEGIN
				delete from deliverymarket where marketdefid =  @MyField
				DELETE FROM [dbo].[MarketDefinitions] WHERE ID=@MyField
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


/****** Object:  StoredProcedure [dbo].[RevalidateMarketDefinition]    Script Date: 25/09/2017 10:44:14 PM ******/
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
           'A' AS [ChangeFlag],
		DM.Description Molecule    
   FROM  DIMProduct_Expanded   
      JOIN DMMoleculeConcat DM   
      ON DIMProduct_Expanded.FCC = DM.FCC  
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

--[dbo].[RevalidateMarketDefinition] 1110
  
  



GO
/****** Object:  StoredProcedure [dbo].[SP_TEST]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_TEST]
AS
BEGIN

insert into Test_Table
select top 2 A.*, GETDATE() as Run_Time 
from [Mirror].[dbo].[HISTORY_TDW-ECP_DIM_PRODUCT] A

END
GO

/****** Object:  StoredProcedure [dbo].[IRPImportTerritoryDefinition]    Script Date: 15-Dec-17 5:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportTerritoryDefinition] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	declare @territoryType varchar(10)
	declare @lastLevel int
	declare @refTerritoryid int
	print('Loading: ')
	print(@pTerritoryId)
	--### STEP 1 : insert into Territories
	insert into Territories (Id, Name, RootGroup_id,RootLevel_id,Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, DimensionId)
	select  distinct I.DimensionID,I.DimensionName, NULL, NULL, C.ClientID, case when BaseId = 2 then 0 else 1 end, 0, NULL, G.SRAClient as SRA_Client, G.SRASuffix as SRA_Suffix, G.AD, G.LD, @pTerritoryId
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId join [IRP].[GeographyDimOptions] G on I.DimensionID=G.DimensionID
	where I.DimensionID = @pTerritoryId and I.VersionTo =32767 and G.VersionTo = 32767 and (G.SRAClient is not null or G.AD is not null or G.LD is not null)
	
	select @territoryType = IsBrickBased from Territories where Id = @pTerritoryId 

	-- Implement refDimensionId if needed

	select @refTerritoryid = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0
	if @refTerritoryid <> @pTerritoryId
	begin
		update Territories set Id = @refTerritoryid where Id = @pTerritoryId
		set @pTerritoryId = @refTerritoryid
	end

	--### STEP 2 : insert into Levels

	select @lastLevel = MAX(LevelNo) from IRP.Levels where DimensionID = @pTerritoryId and VersionTo > 0
	if @territoryType = 1 
	begin 
		set @lastLevel = @lastLevel - 1
	end 

	print('Last level: ')
	print(@lastLevel)

	insert into Levels (Id, Name, LevelNumber, LevelIDLength, LevelColor, BackgroundColor, TerritoryId)
	select LevelID, LevelName, LevelNo, case when LevelNo < 3 then 1 else 2 end, NULL, NULL, DimensionID 
	from IRP.Levels where DimensionID = @pTerritoryId and LevelNo <= @lastLevel - 1 and VersionTo > 0

	update Levels set LevelIdLength =  0 where LevelNumber = 1
	--select * from Levels

	--### STEP 3 : insert into Groups

	insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, TerritoryId)
	select ItemID, Name, Parent, LevelNo, cast(LevelNo as varchar) + cast(ROW_NUMBER() over(partition by LevelNo order by ItemID) as varchar), 0, 130, DimensionID from IRP.Items 
	where DimensionID = @pTerritoryId and LevelNO <= @lastLevel and VersionTo > 0

	--select * from Groups
	--truncate table Groups
	select G.Id, S.GroupNumber into #parent from Groups G join Groups S on G.ParentId = S.Id
	update Groups set ParentGroupNumber = IG.GroupNumber
	from Groups G join #parent IG on G.Id = IG.Id

	update Groups set CustomGroupNumberSpace = IG.CustomGroupNumberSpace
	from Groups G join IRP.GroupNumberMap IG on G.GroupNumber =  IG.GroupNumber
	where TerritoryId = @pTerritoryId

	drop table #parent

	update Territories set RootGroup_id = G.Id
	from Territories T join Groups G on T.Id = G.TerritoryId
	where ParentId is NULL and T.Id = @pTerritoryId

	--### STEP 4 : insert into OutletBrickAllocations
	print('territory type: ')
	print (@territoryType)

	print('last level final')
	print(@lastLevel)

	select DimensionID, LevelNo, Parent, Item into #tempItems from IRP.Items where DimensionID = @pTerritoryId and LevelNo = @lastLevel and VersionTo > 0
	if @territoryType = 1 
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, BrickOutletLocation, TerritoryId )
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.BrickName BrickOutletName, l.Name LevelName, 'Brick' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, b.BrickLocation, t.DimensionID TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		join tblBrick b on t.Item = b.Brick
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end
	else
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type,BannerGroup, State, Panel, TerritoryId)
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.OutletName BrickOutletName, l.Name LevelName, 'Outlet' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, t.DimensionID TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		join [IRP].[IMSOutletMaster] x on x.OID = t.Item
		join tblOutlet b on x.EID = b.EID
		--left join tblOutlet b on t.Item = b.EID
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end

	--select * from OutletBrickAllocations
	delete from Groups where LevelNo = @lastLevel and TerritoryId = @pTerritoryId

	--delete unavailable bricks in TDW from ECP
	delete from outletbrickallocations where BrickOutletCode in ('0800I','2000I','3000I','3199D','4000I','4566B','5000I','6000I','7000I')
	
	drop table #tempItems	

	---UPDATE CUSTOM GROUP NUMBER SPACE ---
	exec [dbo].[IRPImportTerritoryCustomGroupNumber] @pTerritoryId=@pTerritoryId
    print('End: ')
	print(@pTerritoryId)
END
GO

/****** Object:  StoredProcedure [dbo].[IRPImportDuplicateTerritoryDefinition]    Script Date: 15-Dec-17 6:18:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IRPImportDuplicateTerritoryDefinition] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	declare @territoryType varchar(10)
	declare @lastLevel int
	--declare @refDimensionID int
	declare @refTerritoryid int

	declare @territoryInc int 
	declare @levelInc int 
	declare @groupInc int 
	declare @OBAInc int

	print('Loading: ')
	print(@pTerritoryId)

	select @territoryInc = (mAX(iD) - MIN(Id)) + 10 from Territories
	select @levelInc = (mAX(iD) - MIN(Id)) + 10 from Levels
	select @groupInc = (mAX(iD) - MIN(Id)) + 10 from Groups
	
	--### STEP 1 : insert into Territories
	--refDimensionID
	--select @refDimensionID = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0

	insert into Territories (Id, Name, RootGroup_id,RootLevel_id,Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, DimensionId)
	select I.DimensionID, I.DimensionName, NULL, NULL, C.ClientID, case when BaseId = 2 then 0 else 1 end, 0, NULL, G.SRAClient as SRA_Client, G.SRASuffix as SRA_Suffix, G.AD, G.LD, @pTerritoryId 
	from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId join [IRP].[GeographyDimOptions] G on G.DimensionID=@pTerritoryId
	where I.DimensionID = @pTerritoryId and I.VersionTo =32767 and G.VersionTo =32767 and (G.SRAClient is not null or G.AD is not null or G.LD is not null)

	select @territoryType = IsBrickBased from Territories where Id = @pTerritoryId 

	-- Implement refDimensionId if needed
	select @refTerritoryid = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0
	if @refTerritoryid <> @pTerritoryId
	begin
		update Territories set Id = @refTerritoryid+@territoryInc where Id = @pTerritoryId
		set @pTerritoryId = @refTerritoryid
	end


	--### STEP 2 : insert into Levels

	select @lastLevel = MAX(LevelNo) from IRP.Levels where DimensionID = @pTerritoryId and VersionTo > 0
	if @territoryType = 1 
	begin 
		set @lastLevel = @lastLevel - 1
	end 

	print('Last level: ')
	print(@lastLevel)

	insert into Levels (Id, Name, LevelNumber, LevelIDLength, LevelColor, BackgroundColor, TerritoryId)
	select Id+@levelInc, Name, LevelNumber, LevelIDLength, NULL, NULL, TerritoryId+@territoryInc 
	from dbo.Levels where TerritoryId = @pTerritoryId 

	--select * from Levels
	update Levels set LevelIdLength =  0 where LevelNumber = 1

	--### STEP 3 : insert into Groups

	--insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, TerritoryId)
	--select ItemID+@groupInc, Name, Parent+@groupInc, LevelNo, cast(LevelNo as varchar) + cast(ROW_NUMBER() over(partition by LevelNo order by ItemID) as varchar), 0, 130, DimensionID+@territoryInc from IRP.Items 
	--where DimensionID = @pTerritoryId and LevelNO <= @lastLevel and VersionTo > 0

	insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, CustomGroupNumber,CustomGroupNumberSpace,TerritoryId)
	select Id+@groupInc, Name, ParentId+@groupInc, LevelNo, GroupNumber, 0, 130, CustomGroupNumber,CustomGroupNumberSpace, TerritoryId+@territoryInc from dbo.Groups
	where TerritoryId = @pTerritoryId 

	--select * from Groups
	--truncate table Groups
	select G.Id, S.GroupNumber into #parent from Groups G join Groups S on G.ParentId = S.Id
	update Groups set ParentGroupNumber = IG.GroupNumber
	from Groups G join #parent IG on G.Id = IG.Id

	--update Groups set CustomGroupNumberSpace = IG.CustomGroupNumberSpace
	--from Groups G join IRP.GroupNumberMap IG on G.GroupNumber =  IG.GroupNumber

	drop table #parent

	update Territories set RootGroup_id = G.Id
	from Territories T join Groups G on T.Id = G.TerritoryId+@territoryInc
	where ParentId is NULL and T.Id = @pTerritoryId+@territoryInc

	--### STEP 4 : insert into OutletBrickAllocations
	print('territory type: ')
	print (@territoryType)
	select DimensionID, LevelNo, Parent, Item into #tempItems from IRP.Items where DimensionID = @pTerritoryId and LevelNo = @lastLevel and VersionTo > 0
	if @territoryType = 1 
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, BrickOutletLocation, TerritoryId)
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.BrickName BrickOutletName, l.Name LevelName, 'Brick' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, b.BrickLocation, t.DimensionID+@territoryInc TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		left join tblBrick b on t.Item = b.Brick
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end
	else
	begin
		insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, TerritoryId)
		select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.OutletName BrickOutletName, l.Name LevelName, 'Outlet' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, t.DimensionID+@territoryInc TerritoryId 
		from #tempItems t 
		join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
		left join tblOutlet b on t.Item = b.Outlet
		join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
		where G.TerritoryId = @pTerritoryId
	end

	--select * from OutletBrickAllocations
	delete from Groups where LevelNo = @lastLevel and TerritoryId = @pTerritoryId+@territoryInc

	drop table #tempItems
	print('END: ')
	print(@pTerritoryId)	
END
GO

/****** Object:  StoredProcedure [dbo].[IRPImportTerritoryCustomGroupNumber]    Script Date: 15-Dec-17 6:15:33 PM ******/
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
	--SET IDENTITY_INSERT [dbo].[Territories] ON;
	--SET IDENTITY_INSERT [dbo].[Levels] ON;
	--SET IDENTITY_INSERT [dbo].[Levels] ON
	--SET IDENTITY_INSERT [dbo].[OutletBrickAllocations] ON;

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
	
	--SET IDENTITY_INSERT [dbo].[Territories] OFF;
	--SET IDENTITY_INSERT [dbo].[Levels] OFF;
	--SET IDENTITY_INSERT [dbo].[Levels] OFF
	--SET IDENTITY_INSERT [dbo].[OutletBrickAllocations] OFF;

END
GO

/****** Object:  StoredProcedure [dbo].[IRPImportTerritoryDefinitionForClient]    Script Date: 15-Dec-17 6:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[IRPImportTerritoryDefinitionForClient] 
	-- Add the parameters for the stored procedure here
	@pClientId int 
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @dimensionId int
	declare @refDimensionId int
	declare @parentClientId int
	declare @refClientId int

	declare @Tkount int
	declare @Lkount int
	declare @Gkount int
	declare @Okount int

	declare @RefKount int

	--IMPORT NON-REF TERRITORIES
	select distinct dimensionid into #tDim from irp.dimension
	where clientid in (select distinct irpclientid from irp.clientmap where clientid in (@pClientId))
	and dimensionid=refdimensionid and baseid in (1,2,11,12)
	and dimensionid not in (select distinct dimensionid from territories)
	and versionto=32767 

	while exists(select * from #tDim)
	begin
		select @dimensionId = (select top 1 dimensionid from #tDim order by dimensionId asc)
		exec [dbo].[IRPImportTerritoryDefinition] @dimensionId
			exec [dbo].[IRPImportLogStatus] 'T', @pClientId, @dimensionId

		delete #tDim where dimensionid = @dimensionId

	end
	drop table #tDim

	--IMPORT REF TERRITORIES

	select distinct dimensionId, refdimensionid into #tDim2 from irp.dimension
	where clientid in (select distinct irpclientid from irp.clientmap where clientid in (@pClientId))
	and dimensionid<>refdimensionid and baseid in (1,2,11,12)
	and versionto=32767 and dimensionId not in
	(select distinct dimensionid from territories where dimensionid is not null)

	while exists(select * from #tDim2)
	begin
		select @refDimensionId = (select top 1 refdimensionid from #tDim2 order by dimensionId asc)
		select @dimensionId = (select top 1 dimensionid from #tDim2 order by dimensionId asc)
		
		select @RefKount = count(*) from territories where dimensionid = @refDimensionId

		if (@RefKount > 0)
		begin
			exec [dbo].[IRPImportDuplicateTerritoryDefinition] @dimensionId
				exec [dbo].[IRPImportLogStatus] 'T', @pClientId, @dimensionId
		end
		else
		begin
			--CHECK IF CLIENT EXISTS FOR REFERENCE PARENT
			select distinct @parentClientId = clientid from irp.dimension where dimensionid= @refDimensionId
			and versionto=32767 and clientid not in(select distinct irpclientid from irp.clientmap)
		
			if(@parentClientId <> '' or @parentClientId is not null) -- this means - parent client NOT exists
			begin
				insert into clients
				select clientname as Name,0 as IsMyClient,null as DivisionOf, clientid as IRPClientId, clientno as IRPClientNo
				from irp.client 
				where clientid = @parentClientId
				and versionto=32767

				insert into irp.clientmap
				select a.id as clientid,b.clientid as irpclientid, b.clientno as clientno
				from clients a join	IRP.client b on a.name=b.clientname
				where b.versionto=32767
				and a.id not in (select distinct clientid from IRP.clientMap)
				and b.clientid=@parentClientId
			end
			
			exec [dbo].[IRPImportTerritoryDefinition] @refDimensionId
				select @refClientId = client_id from territories where dimensionid = @refDimensionId
				exec [dbo].[IRPImportLogStatus] 'T', @refClientId, @refDimensionId
			exec [dbo].[IRPImportDuplicateTerritoryDefinition] @dimensionId
				exec [dbo].[IRPImportLogStatus] 'T', @pClientId, @dimensionId
			
		end
		
		delete #tDim2 where dimensionid = @dimensionId
	end
	drop table #tDim2

END
GO

/****** Object:  StoredProcedure [dbo].[UpdateBricks_AfterImport]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateBricks_AfterImport]
AS
BEGIN
--Select * into  [ECP_Archive].[dbo].[DIMOutlet_bk_on_20170712] 
--FROM  [dbo].[DIMOutlet] 
	
--Select * into  [ECP_Archive].[dbo].[DIMProduct_bk_on_20170712] 
--FROM  [dbo].[DIMProduct_Expanded]

--Select * into  [ECP_Archive].[dbo].[DIMMolecule_bk_on_20170712] 
--FROM  [dbo].[DMMolecule]

--Select * into  [ECP_Archive].[dbo].[DIMMoleculeConcat_bk_on_20170712] 
--FROM  [dbo].[DMMoleculeConcat]

select * from [dbo].[DIMProduct_Expanded]
where Study_Indicators1='' and Study_Indicators3='' and Study_Indicators5=''
and (Study_Indicators2<>'' or Study_Indicators4<>'')

update [dbo].[DIMProduct_Expanded]
set CHANGE_FLAG='D'
where Study_Indicators1='' and Study_Indicators3='' and Study_Indicators5=''
and (Study_Indicators2<>'' or Study_Indicators4<>'')
  
update  [dbo].[DIMOutlet]
  set CHANGE_FLAG='D'
  where State_Code=''
  
 Select  Retail_Sbrick,State_code, dbo.GetStateFromBrick(Retail_Sbrick)
 from  [dbo].[DIMOutlet]
 where Retail_Sbrick in
 (SELECT Retail_Sbrick
  FROM  [dbo].[DIMOutlet]
  where State_Code<>''
 group by Retail_Sbrick 
 having COUNT(distinct State_Code)>1)
 
 update  [dbo].[DIMOutlet]
 set State_code= dbo.GetStateFromBrick(Retail_Sbrick)
 where Retail_Sbrick in
 (SELECT Retail_Sbrick
  FROM  [dbo].[DIMOutlet]
  where State_Code<>''
 group by Retail_Sbrick 
 having COUNT(distinct State_Code)>1)
 
END





GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomGroupNumberForAllTerritories]    Script Date: 25/09/2017 10:44:14 PM ******/
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
		EXEC [dbo].[IRPImportTerritoryCustomGroupNumber]  @pTerritoryId

		delete #loopTable
		where Id = @pTerritoryId
	end

	drop table #loopTable
END

--[dbo].[UpdateCustomGroupNumberForAllTerritories] 






GO
/****** Object:  StoredProcedure [dbo].[UpdateDataRefreshType]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateMarketBaseId]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateMarketDefinitionId]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[z_ECP_AddExtendedTables]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[z_QC]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[z_QC_1]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[z_QC_1]
 
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
/****** Object:  StoredProcedure [dbo].[z_WebpageSecurity]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_AU9_CLIENT_MKT_PACK]    Script Date: 25/09/2017 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [SERVICE].[CREATE_AU9_CLIENT_MKT_PACK]
AS
BEGIN

TRUNCATE TABLE [SERVICE].[AU9_CLIENT_MKT_PACK]
INSERT INTO [SERVICE].[AU9_CLIENT_MKT_PACK]

SELECT distinct
	 CAST([MarketDefinitionId] AS INT) AS [CLIENT_MKT_ID]
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

update [SERVICE].[AU9_CLIENT_MKT_PACK]
set PACK_GRP_ID=null
where PACK_GRP_ID =''

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
/****** Object:  StoredProcedure [SERVICE].[CREATE_AU9_CLIENT_TERR]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_AU9_CLIENT_TERR_TYP]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL1]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL2]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL3]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL4]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL5]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL6]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL7]    Script Date: 25/09/2017 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [SERVICE].[CREATE_CT_LVL8]    Script Date: 25/09/2017 10:44:14 PM ******/
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

CREATE TABLE [IRP].[OutletLimitedOwnData](
	[OutletType] [varchar](2) NOT NULL,
	[Client_No] [smallint] NOT NULL,
	[Client_Name] [varchar](25) NOT NULL,
 CONSTRAINT [PK_OutletLimitedOwnData] PRIMARY KEY CLUSTERED 
(
	[OutletType] ASC,
	[Client_No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

GO


