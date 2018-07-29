CREATE procedure [dbo].[IRPProcessDeliverablesNonIAM]
As
BEGIN
	
	declare @Lvl_total char(8)
	declare @RestrictionId int
	declare @rptname varchar(500)

	declare @DeliveryReportName table (DeliverableId int, ReportName varchar(500) )

	declare @Client varchar(100),@service varchar(100),@country varchar(100),@Datatype varchar(100),@source varchar(100),@DeliveryType varchar(100),
	@ReportWriterCode varchar(100),@ReportWriter varchar(100),@FrequencyType varchar(100),@Frequency varchar(500),@DeliverTo varchar(100), @Years varchar(100)
	Declare @CatSel varchar(50)
	declare @ClientId int,@countryId int,@serviceId int, @sourceId int,@datatypeId int,@ReportWriterId int, @FrequencyTypeId int, @FrequencyId int,@PeriodId int,@DeliveryTypeId int,
	@deliverToId int
	declare @subscriptionId int,@deliverablesId int
	declare @TerritoryBase varchar(50),@TerritoryBaseId int
	declare @cnt int
	set nocount on

	--keep the data
	Select ClientName, D.Country, 
	Case C.DataType when 'Other' then case when len([OUTLET DESCRIPTIONS])>0 then 'Other Outlet' else C.DataType end else C.DataType end DataType,
	E.[Service],E.Source,E.Deliverable,ExtType,FreqType,Frequency,Period, report_name, lvl_total 
	into #tt from dbo.IRG_Deliverables_NonIAM D
		inner join IRG_Cat_sel C on D.cat_sel=C.cat 
		inner join IRG_ExtractionType E on substring(D.ReportWriter,1,2) = E.ExtType
		OR substring(D.ReportWriter,3,2) = E.ExtType
		OR substring(D.ReportWriter,5,2) = E.ExtType
		where C.DataType is not null and E.Source is not null and ExtType is not null and E.[Service] is not null
	

	DECLARE subCursor CURSOR FOR
	Select ClientName, D.Country, 
	Case C.DataType when 'Other' then case when len([OUTLET DESCRIPTIONS])>0 then 'Other Outlet' else C.DataType end else C.DataType end,
	E.[Service],E.Source,E.Deliverable,ExtType,FreqType,Frequency,Period, report_name,lvl_total from dbo.IRG_Deliverables_NonIAM D
		inner join IRG_Cat_sel C on D.cat_sel=C.cat 
		inner join IRG_ExtractionType E on substring(D.ReportWriter,1,2) = E.ExtType
		OR substring(D.ReportWriter,3,2) = E.ExtType
		OR substring(D.ReportWriter,5,2) = E.ExtType
		where C.DataType is not null and E.Source is not null and ExtType is not null and E.[Service] is not null
	
	OPEN subCursor  
	FETCH NEXT FROM subCursor INTO @client,@country,@DataType,@Service,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,@Frequency,@Years,@rptname,@Lvl_total
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
			Print ' Client Name = ' + @client
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
		Print 'Client ID = ' + cast(@clientId as varchar)
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
			  --insert into Deliverables table
				   if @Lvl_Total is null 
						set @RestrictionId = null
				   else
						set @RestrictionId = cast(@Lvl_total as int)

				   insert into Deliverables (SubscriptionId,ReportWriterId,FrequencyTypeId,FrequencyId,Periodid,StartDate,EndDate,LastModified,ModifiedBy,DeliveryTypeId, RestrictionId)
				   values (@SubscriptionId,@ReportWriterId,@FrequencyTypeId,case when @FrequencyId = 0 then null else @FrequencyId end,@PeriodId,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
				   DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1),CAST(GETDATE() AS DATE),1,@DeliveryTypeId, @RestrictionId)
				   SELECT @deliverablesId = SCOPE_IDENTITY()
				   --select 'deliverables id=' + cast(@deliverablesId as varchar)
				   Print 'Deliverables inserted- id=' + cast(@deliverablesId as varchar)
			   
		       
				   insert into DeliveryClient (DeliverableId, ClientId) values(@deliverablesId,@ClientId)

				   ---INSERT INTO DELIVERYREPORTNAME

				   insert into @DeliveryReportName (DeliverableId, ReportName) values (@deliverablesId, @ReportWriterCode)

				   
			   			   
			   end
			Print 'Row =' + cast(@cnt as varchar)
			END
		set @cnt =@cnt +1
		FETCH NEXT FROM subCursor INTO @client,@country,@DataType,@Service,@source,@DeliveryType,@ReportWriterCode,@FrequencyType,@Frequency,@Years, @rptname, @Lvl_total
	    

	End 

	Close subCursor
	Deallocate subCursor

	--select * from @DeliveryReportName

	MERGE [dbo].DeliveryReportName AS TARGET
	USING (select distinct  a.deliverableid deliverableid, b.report_name reportname from @DeliveryReportName a join #tt b on a.ReportName = b.ExtType) AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.ReportName=SOURCE.ReportName)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, ReportName)
	values(SOURCE.deliverableid, SOURCE.ReportName)
	;
	

	--delete from dbo.IRG_Deliverables_NonIAM
	--select * from dbo.IRG_Deliverables_NonIAM
	
END
--select * from clients where irpclientno = 94
--exec [IRPImportDeliverablesNonIAM] 94
--exec [IRPProcessDeliverablesNonIAM]

--select * from deliveryreportname
--use preprod
--select * from deliverables where subscriptionid in (select subscriptionid from subscription where clientid = 76)
--select * into deliverablesTemp from deliverables where deliverableid in (201, 202, 203)

--delete from deliveryclient where deliverableid in (201, 202, 203)
--delete from deliverables where deliverableid in (201, 202, 203)

--select * into deliveryclientTemp from deliveryclient where deliverableid in (201, 202, 203)

--select * from deliveryreportname 
--where deliverableid in (select deliverableid from deliverables where subscriptionid in (select subscriptionid from subscription where clientid = 76))
