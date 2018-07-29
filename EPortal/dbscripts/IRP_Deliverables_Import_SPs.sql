IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IRPProcessDeliverablesIAM'))
   DROP PROCEDURE dbo.IRPProcessDeliverablesIAM
GO
CREATE procedure dbo.IRPProcessDeliverablesIAM
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IRPImportDeliverablesIAM'))
   DROP PROCEDURE dbo.IRPImportDeliverablesIAM
GO
--EXEC IRPImportDeliverablesIAM 481
CREATE procedure dbo.IRPImportDeliverablesIAM
( @ClientNo int)
As
BEGIN
	--Declare @ClientNo int
	--set @ClientNo=481
	DECLARE @RowsToProcess  int,@RP int
	DECLARE @CurrentRow     int,@CR int

	DECLARE @RptNo  int,@ClientId  int,@ClientName varchar(500),@bkt_Sel varchar(100),@cat_Sel varchar(100),@RptId int,@RptName varchar(500)
	DECLARE @Value int,@writerParamId int,@WriterId int
	DECLARE @FreqType int,@FreqId int, @Period varchar(50), @Service varchar(100),@DataType varchar(100), @Source varchar(100),@DeliveryType varchar(100),@ReportWriterCode varchar(50)

	DECLARE @Deliverables TABLE (RowID int not null primary key identity(1,1), clientid int,ClientName varchar(100), 
	FreqType int,Frequency int, Period varchar(100), [Service] varchar(100),DataType varchar(100), Source varchar(100),ReportWriter varchar(50),country varchar(10),deliveryType varchar(100)
	 )  
	set @DeliveryType='IAM'

	DECLARE @table1 TABLE (RowID int not null primary key identity(1,1), clientno int, ReportID int,ReportNo int, ReportName varchar(500),WriterID int  ) 
	--Get Client Id
	 Select @ClientId = ClientId, @ClientName = ClientName from IRP.Client where ClientNo=@ClientNo and VersionTo=32767
	 
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
			set @Value=0
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
			
			
		
		insert into @Deliverables(clientid,ClientName,FreqType,Frequency, Period, [Service],DataType,Source,ReportWriter,country,deliveryType )
			values (@ClientId,@ClientName, @FreqType,@FreqId,@Period,@Service,@DataType,@Source,@ReportWriterCode,'AUS',@DeliveryType)
		

	END
	insert into dbo.IRG_Deliverables_IAM
	select * from @Deliverables
-- Insert records into subscription & deliverables from IRG_Deliverables_IAM table
	execute dbo.IRPProcessDeliverablesIAM
	
	delete from dbo.IRG_Deliverables_IAM where Clientid=@ClientId

	
END
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IRPProcessDeliverablesNonIAM'))
   DROP PROCEDURE dbo.IRPProcessDeliverablesNonIAM
GO
Create procedure dbo.IRPProcessDeliverablesNonIAM
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
		inner join IRG_ExtractionType E on D.ReportWriter = E.ExtType
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
		select top 1 @clientId = id from clients where left(Name,3)=  left(LTrim(RTrim(@client)),3) -- checking only first 3 characters
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IRPImportDeliverablesNonIAM'))
   DROP PROCEDURE dbo.IRPImportDeliverablesNonIAM
GO
--exec IRPImportDeliverablesNonIAM 044
CREATE procedure dbo.IRPImportDeliverablesNonIAM
( @ClientNo int)
As
BEGIN

	DECLARE @RowsToProcess  int,@RP int
	DECLARE @CurrentRow     int,@CR int

	DECLARE @ClientId  int,@ClientName varchar(500),@bkt_Sel varchar(100),@cat_Sel varchar(100),@RptNo int,@RptName varchar(500)
	DECLARE @Value int,@writerParamId int,@WriterId int
	DECLARE @FreqType int,@FreqId int, @Period varchar(50), @Service varchar(100),@DataType varchar(100), @Source varchar(100),@DeliveryType varchar(100),@ReportWriterCode varchar(50),
	@XREFClient int

	DECLARE @Deliverables TABLE (RowID int not null primary key identity(1,1), Clientid int,ClientName varchar(100), BKT_SEL varchar(100),CAT_SEL varchar(100),
	FreqType int,Frequency int, Period varchar(100), [Service] varchar(100),DataType varchar(100), Source varchar(100),ReportWriter varchar(50),Country varchar(10),DeliveryType varchar(100),
	 RPT_NO int, XREF_Client int)  
	--Kimberley Clark - 412,AZ - 044,NicePak - 017,P&G - 481

	--set @ClientNo =044
	set @DeliveryType='FlatFile'
	--Get Client Id
	Select @ClientId = ClientId, @ClientName = ClientName from IRP.Client where ClientNo=@ClientNo and VersionTo=32767
	 
	DECLARE @table1 TABLE (RowID int not null primary key identity(1,1), clientNo int,rptNo int, bkt_sel varchar(100),cat_sel varchar(100),XREF_Client int,rptSelection varchar(500)  )  
	INSERT into @table1 (clientNo,rptNo, bkt_sel, cat_sel, XREF_Client,rptSelection) 
	select  CLD.CLIENT_NO, CLD.RPT_NO, BKT_SEL, CAT_SEL, XREF_CLIENT,RPT_SELECTION  from IRP.CLD 
	inner join IRP.RD on CLD.CLIENT_NO = RD.CLIENT_NO and CLD.RPT_NO = RD.RPT_NO
	where CLD.CLIENT_NO=@ClientNo and RD.RPT_SELECTION not in ('ID','IA','IB','IW')

	SET @RowsToProcess=@@ROWCOUNT
	--select * from @table1
	SET @CurrentRow=0
	WHILE @CurrentRow<@RowsToProcess
	BEGIN
		SET @CurrentRow=@CurrentRow+1
		SELECT  @RptNo =rptNo,  @bkt_Sel = BKT_SEL,@cat_Sel= cat_sel, @ReportWriterCode = rptSelection, @XREFClient=XREF_Client FROM @table1 WHERE RowID=@CurrentRow
			
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
		
		insert into @Deliverables(clientid,ClientName, cat_sel, FreqType,Frequency, Period, [Service],DataType,Source,ReportWriter,country,deliveryType,RPT_NO, XREF_Client )
			values (@ClientId,@ClientName, @cat_Sel, @FreqType,@FreqId,@Period,@Service,@DataType,@Source,@ReportWriterCode,'AUS',@DeliveryType,@RptNo,@XREFClient)
		

	END
--select * from @Deliverables
insert into dbo.IRG_Deliverables_NonIAM
	select * from @Deliverables
-- Insert records into subscription & deliverables from IRG_Deliverables_IAM table
	execute dbo.IRPProcessDeliverablesNonIAM
	
	delete from dbo.IRG_Deliverables_NonIAM where Clientid=@ClientId
END
