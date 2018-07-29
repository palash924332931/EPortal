
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
	declare @ReportId int
	-----------------declare temp-----------------
	--declare @SubscriptionTemp TABLE(SubscriptionId int not null primary key identity(1,1),name varchar(100),clientId varchar(100),StartDate datetime,EndDate datetime ,active varchar(100),LastModified varchar(100), modifiedby varchar(100), CountryId varchar(100),serviceId varchar(100),SourceId varchar(100),DataTypeId varchar(100),ServiceTerritoryId varchar(100))
	--declare @DeliverablesTemp table(SubscriptionId varchar(100),ReportWriterId varchar(100),FrequencyTypeId varchar(100),FrequencyId varchar(100),Periodid varchar(100),StartDate datetime,EndDate datetime,LastModified varchar(100),ModifiedBy varchar(100),DeliveryTypeId varchar(100))

	------------------------------------------
	set nocount on

	DECLARE subCursor CURSOR FOR
	Select ClientName,[Service],Country,DataType,Source,DeliveryType,ReportWriter,FreqType,Frequency,Period,ReportId from dbo.IRG_Deliverables_IAM
	
	--SELECT  Client,[Service],Country,[DATA type], Source,[Delivery Type],[Report writer],[Report writer name],[frequency type],frequency,
	--[deliver to],[# years]  FROM  dbo.[z_Delivery Details] 


	OPEN subCursor  
	FETCH NEXT FROM subCursor INTO @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,
	@Frequency,@Years,@ReportId
	set @cnt =1
	WHILE @@Fetch_Status = 0 

	BEGIN

		--select @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@ReportWriter,@FrequencyType,@Frequency,@DeliverTo,@Years
		select  @clientId = 0,@countryId = 0,@serviceId = 0, @sourceId = 0, @datatypeId = 0
		--select top 1 @clientId = id from clients where Name = LTrim(RTrim(@client)) 
		if @Client = 'GlaxoSmithKline Consumer Healthcare'
		set @Client ='GSK Consumer'
		select top 1 @clientId = id from clients where Name = LTrim(RTrim(@client)) -- checking only first 3 characters
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

			   ----INSERT INTO DeliveryReport
			   --select distinct DeliverableId, ReportId into #tDeliveryReport from DeliveryReport
			   MERGE [dbo].DeliveryReport AS TARGET
				USING (select @deliverablesId DeliverableId, @ReportId ReportId) AS SOURCE
				ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.ReportId=SOURCE.ReportId)

				WHEN NOT MATCHED BY TARGET THEN
				insert(deliverableid, ReportId)
				values(SOURCE.deliverableid, SOURCE.ReportId)
				;
			   --insert into DeliveryReport (DeliverableId, ReportId) values(@deliverablesId,@ReportId)

		   end
		Print 'Row =' + cast(@cnt as varchar)
		end
		set @cnt =@cnt +1
		FETCH NEXT FROM subCursor INTO @client,@service,@country,@datatype,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,@Frequency,@Years,@ReportId
	    

	End 

	Close subCursor
	Deallocate subCursor

	--Select * from @SubscriptionTemp
	--Select * from @DeliverablesTemp
	--Select * from DeliveryReport
	--drop table dbo.IRG_Deliverables_IAM

END

--select * from subscription where clientid = 43
--select * from deliverables where subscriptionid in (select subscriptionid from subscription where clientid = 43)