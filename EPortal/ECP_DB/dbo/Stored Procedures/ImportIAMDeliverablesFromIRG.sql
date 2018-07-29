CREATE procedure [dbo].[ImportIAMDeliverablesFromIRG]
( @ClientNo int)
As
BEGIN
SET NOCOUNT ON

--declare @Debug int = 0, @donotUpdate int = 0

------Sections---------
--1. Validations
--5. Deliverables
--5.1. Country
--5.2. Source
--5.3. Service
--5.4. DataType
--5.5. Duration
--5.5. Frequency
--5.6 FrequencyType
--5.7 Period
--5.8 DeliveryType
--5.9 Mask
--6.2 Subchannel
------Sections---------

BEGIN TRAN

BEGIN TRY
-------Variable Declarations---------
--TEMP TABLES
DECLARE @ImportInfo TABLE (ImportInfoType varchar(20), Code varchar(20), ImportMessage varchar(500), ImportInformation varchar(5000))
DECLARE @ImportData TABLE (ImportDataType varchar(20), ImportData varchar(20))
DECLARE @Deliverables TABLE (ClientId int, CountryId int, ServiceId int, SourceId int, DataTypeId int, SubscriptionDurationFrom datetime, SubscriptionDurationTo datetime, ServiceTerritoryId int, 
ClientNo int, ReportNo int, DeliveryTypeId int, FrequencyId int, FrequencyTypeId int, PeriodId int, DeliverablesDurationFrom datetime, DeliverablesDurationTo datetime, ReportId int, ReportName varchar(100), ReportWriterId int, Mask bit, PRIMARY KEY (ClientNo, ReportNo) )
DECLARE @Report TABLE (RowID int not null primary key identity(1,1), clientno int, ReportID int, ReportNo int, ReportName varchar(500), WriterID int  )
DECLARE @DeliverablesData TABLE ([Status] varchar(20), SubscriptionId int,	ReportWriterId int,	FrequencyTypeId int,	RestrictionId int,	PeriodId int,	Frequencyid int,	StartDate datetime,	EndDate datetime,	[probe] varchar(500),	PackException bit,	Census bit,	OneKey	bit,LastModified	datetime,ModifiedBy	int,DeliveryTypeId int, DeliverableId int, Mask bit)
DECLARE @SubscriptionData TABLE ([Status] varchar(20), Name VARCHAR(500),	ClientId int,	StartDate datetime,	EndDate datetime,	ServiceTerritoryId int,	Active bit,	LastModified datetime,	ModifiedBy int,	CountryId int,	ServiceId int,	DataTypeId int,	SourceId int, SubscriptionId int) 
--TEMP VARIABLES
DECLARE @ClientId int
DECLARE @ValidationError int, @RowsToProcess int, @CurrentRow int
-------Variable Declarations---------

--constants to use in import information table
declare @CnstInfoTypeErr varchar(20), @SectionClient varchar(20), @StdMsgNotFound varchar(500), @StdMsgDuplicate varchar(500)
select @CnstInfoTypeErr = 'ERROR'
select @SectionClient = 'Client'
select @StdMsgNotFound = 'Data not found'
select @StdMsgDuplicate = 'Multiple entries found'
--constants to use in import information table



----------------------------------------1.VALIDATIONS---------------------------------
--do we have right data copied from IRG
--is there an entry in irp.client
--are there duplicate entries in irp.client
declare @clientnocount int
select @clientnocount = count(ClientNo) from irp.Client where ClientNo = @clientno and versionto = 32767 group by ClientNo 

if (@clientnocount is null) BEGIN INSERT INTO @ImportInfo values (@CnstInfoTypeErr, @SectionClient, @StdMsgNotFound, null) END
ELSE BEGIN 
if (@clientnocount > 1) BEGIN INSERT INTO @ImportInfo values (@CnstInfoTypeErr, @SectionClient, @StdMsgDuplicate, null) END
END

--have we mapped right data from IRG to Everest
--is there an entry in irp.clientmap
--are there duplicate entries in irp.clientmap
---------select * from irp.ClientMap where IRPClientNo = @clientno

--do we have right data in everest client table for the mapped IRG client
--is there an entry in Clients
--are there duplicate entries in Clients
---------select * from clients where id = 12

--check the IAM deliverables 
--do we have right data copied from IRG in  tables
--is there an entries in IRP.Report, IRP.ReportParameter
--are there duplicate entries in IRP.Report, IRP.ReportParameter
---------select * from irp.report where clientid = 672 and versionto = 32767 and ReportNo <> 0


--------------return validation errors
--select ImportInfoType , Code , ImportMessage , ImportInformation from @ImportInfo order by ImportInfoType, Code
--select ImportDataType , ImportData  from @ImportData order by ImportDataType 
--------------return validation errors

----------------------------------------1.VALIDATIONS---------------------------------


----------------------------------------5.SUBSCRIPTIONS and DELIVERABLES---------------------------------

---------Get Everest Client ID
SELECT @ClientId = ClientId FROM IRP.ClientMap WHERE IRPClientNo = @ClientNo
IF (@ClientId is null) GOTO NoClient

---------5a.Get the reports / deliverables for the client
INSERT into @Report (clientno,ReportID,ReportNo,ReportName,WriterID) 
	SELECT  @clientNo,ReportID,ReportNo,ReportName,WriterID FROM IRP.Report R
	join IRP.Client C on R.ClientId = C.ClientId and C.VersionTo = 32767
	where R.VersionTo=32767 and R.ReportNo <> 0 and C.ClientNo = @ClientNo

--if (@Debug =1) SELECT * FROM @Report

---------5b. Loop through each deliverable
SET @RowsToProcess=@@ROWCOUNT
SET @CurrentRow=0
WHILE @CurrentRow<@RowsToProcess
BEGIN
	SET @CurrentRow=@CurrentRow+1
	DECLARE @CountryId int, @ServiceId int, @SourceId int, @DataTypeId int, @SubscriptionDurationFrom datetime, @SubscriptionDurationTo datetime, @ServiceTerritoryId int, @ReportWriterCode VARCHAR(100), @ReportWriterId int
	DECLARE  @DeliveryTypeId int, @FrequencyId int, @FrequencyTypeId int, @PeriodId int, @DeliverablesDurationFrom datetime, @DeliverablesDurationTo datetime
	DECLARE @ReportNo int, @RptId int, @RptName varchar(500),@WriterId int
	SELECT @RptId=ReportID, @RptName = ReportName,@WriterId= writerid, @ReportNo=ReportNo 
	FROM @Report WHERE RowID=@CurrentRow
	
	SELECT @ReportWriterCode = WriterCode from IRP.Writer where writerid=@WriterId
	SELECT top 1 @ReportWriterId = ReportWriterId from ReportWriter where code = LTrim(RTrim(@ReportWriterCode)) and DeliveryTypeId = 3

--------5.1. Country
SET @CountryId=1 --defaulted to AUS
--------5.2. Source
SET @SourceId=1 --defaulted to Sell In
--------5.5. Duration
SET @SubscriptionDurationFrom=DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) --defaulted to jan 1
SET @SubscriptionDurationTo=DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1) --defaulted to dec 31
--------5.8 DeliveryType default to IAM
SET @DeliveryTypeId = 3
--------5.3. Service
DECLARE @service varchar(100)
SELECT @Service=Name from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='ProbePack'
IF @Service = 'NO PROBE'
	SET @ServiceId = 2 --PROFITS
ELSE IF @Service = 'PROBE Packs Manufacturer' or @Service ='PROBE Packs Exceptions' or @Service = 'PROBE Pack Manufacturer'
BEGIN
	Declare @PFCDifference int
	set @PFCDifference = -1

	select @PFCDifference = Count(pfc) from (
	(select rp.ReportID, p.PFC from irp.ReportParameter rp
	join irp.Report r on r.ReportID = rp.ReportID and r.ReportID = @RptId and rp.VersionTo = 32767  and r.VersionTo = 32767 and rp.code = 'DimProd'
	join irp.Dimension d on d.DimensionID = rp.Value and d.VersionTo = 32767 and d.BaseID = 16
	join irp.Items i on i.DimensionID = d.DimensionID and i.VersionTo = 32767 and i.Item is not null
	join DIMProduct_Expanded p on i.Item = p.Org_Abbr	
	UNION
	select rp.ReportID, p.PFC from irp.ReportParameter rp
	join irp.Report r on r.ReportID = rp.ReportID  and r.ReportID = @RptId and rp.VersionTo = 32767  and r.VersionTo = 32767 and rp.code = 'DimProd'
	join irp.Dimension d on d.DimensionID = rp.Value and d.VersionTo = 32767 and d.BaseID = 5
	join irp.Items i on i.DimensionID = d.DimensionID  and i.VersionTo = 32767 and i.Item is not null
	join DIMProduct_Expanded p on i.Item = p.ATC4_Code
	UNION
	select rp.ReportID, p.PFC from irp.ReportParameter rp
	join irp.Report r on r.ReportID = rp.ReportID  and r.ReportID = @RptId and rp.VersionTo = 32767  and r.VersionTo = 32767 and rp.code = 'DimProd'
	join irp.Dimension d on d.DimensionID = rp.Value and d.VersionTo = 32767 and d.BaseID = 4
	join irp.Items i on i.DimensionID = d.DimensionID and i.Item is not null
	join DIMProduct_Expanded p on i.Item = convert(varchar, p.fcc)	
	)
	EXCEPT
	(
	--probe pack mfr
	select rp.ReportID, p.PFC from irp.ReportParameter rp
	join irp.Report r on r.ReportID = rp.ReportID  and r.ReportID = @RptId and rp.VersionTo = 32767  and r.VersionTo = 32767 and rp.code = 'ProbePack'
	join irp.Dimension d on d.DimensionID = rp.Value  and d.VersionTo = 32767 and d.BaseID = 16
	join irp.Items i on i.DimensionID = d.DimensionID  and i.Item is not null
	join DIMProduct_Expanded p on i.Item = p.Org_Abbr	
	UNION
	--probe pack exceptions
	select rp.ReportID, p.PFC from irp.ReportParameter rp
	join irp.Report r on r.ReportID = rp.ReportID  and r.ReportID = @RptId and rp.VersionTo = 32767  and r.VersionTo = 32767 and rp.code = 'ProbePack'
	join irp.Dimension d on d.DimensionID = rp.Value   and d.VersionTo = 32767 and d.BaseID = 4
	join irp.Items i on i.DimensionID = d.DimensionID   and i.Item is not null
	join DIMProduct_Expanded p on i.Item = convert(varchar, p.fcc)
	)) packs
	join irp.Report r on packs.ReportID = r.reportid
	group by r.ReportId, r.ReportName
				
	if (@PFCDifference > 0) 
		SET @ServiceId = 7
	ELSE 
		set @ServiceId = 1
END	

--------5.4. DataType
DECLARE @DataType varchar(100)
if exists (select distinct(t.outletCategory) 
	from irp.ReportParameter r
	join irp.Items i on i.DimensionID = r.Value and i.item is not null and i.VersionTo = 32767
	join irp.OutletMaster o on o.entity_type = i.item
	join irp.outlettype t on t.outlettype = o.out_type and t.OutletCategory = 'R'
	where r.ReportID = @RptId and r.VersionTo = 32767 and r.Code = 'DimChannel')
	begin
		set @DataType = 'Retail'
	end

	if exists (select distinct(t.outletCategory) 
	from irp.ReportParameter r
	join irp.Items i on i.DimensionID = r.Value and i.item is not null and i.VersionTo = 32767
	join irp.OutletMaster o on o.entity_type = i.item
	join irp.outlettype t on t.outlettype = o.out_type and t.OutletCategory = 'H'
	where r.ReportID = @RptId and r.VersionTo = 32767 and r.Code = 'DimChannel')
	begin
		if (len(@DataType) >0) BEGIN  SET @DataType = CONCAT (@DataType, ' + ', 'Hospital' ) END
		ELSE BEGIN set @DataType = 'Hospital' END
				
	end

	if exists (select distinct(t.outletCategory) 
		from irp.ReportParameter r
	join irp.Items i on i.DimensionID = r.Value and i.item is not null and i.VersionTo = 32767
	join irp.OutletMaster o on o.entity_type = i.item
	join irp.outlettype t on t.outlettype = o.out_type and t.OutletCategory = 'O'
	where r.ReportID = @RptId and r.VersionTo = 32767 and r.Code = 'DimChannel')
	begin
		if (len(@DataType) >0) BEGIN  SET @DataType = CONCAT (@DataType, ' + ', 'Other Outlet' ) END
		ELSE BEGIN set @DataType = 'Other Outlet' END
	end

	SELECT @DataTypeId = DataTypeId FROM DataType WHERE Name = @DataType

--------5.5. ServiceTerritory
	IF @ServiceId = 1 SET @ServiceTerritoryId = 2 --Outlet level for PROBE
	ELSE if @ServiceId = 2 SET @ServiceTerritoryId = 1 --Brick level for PROFITS
	ELSE if @ServiceId = 7 SET @ServiceTerritoryId = 3 --Both level for PROFITS + PROBE
	ELSE SET @ServiceTerritoryId = 4 --set as N/A


----------5.6 Period
	DECLARE @Value int, @writerParamId int, @Period varchar(100)
	set @Value=0
	select @Value=Value, @writerParamId = WriterParameterID from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='DimPeri'
	DECLARE @string varchar(100),@start int,@end int,@len int
	select @string = DimensionName from IRP.Dimension where dimensiontype= 3 and DimensionID = @Value
			
	--set @string = replace(@string, ' ' , '')
	--set @len = len(@string)
	--set @start = PATINDEX('%[0-9]%',@string)
	--set @end = PATINDEX('%[^0-9]%',substring(@string, @start, @len))-1
	--print substring(@string, @start, @end)
	--if left(SUBSTRING(@string,PATINDEX('%[0-9]%',@string)+2,5),5) = 'month'
	--begin 
	--	SET @Period = cast(cast(substring(@string, @start, @end) as int)/12 as varchar) + ' Years'
	--end
	--else
	--begin
	--	select @Period= substring(@string, @start, @end) + ' ' + SUBSTRING(@string,PATINDEX('%[0-9]%',@string)+2,5)
	--end

	SET @Period = cast(cast(substring(@string, PATINDEX('%[0-9][0-9] Months%', @string), 2) as int)/12 as varchar) + ' Years'
	SELECT @PeriodId = PeriodId from Period where Name = @Period

---------5.7 FrequencyType and Frequency
	DECLARE @FrequencyValue int, @FreqType int, @FreqId int
	set @FrequencyValue=-999
	select @FrequencyValue=Value, @writerParamId = WriterParameterID from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='Delivery'
	set @FreqType = 0
	set @FreqId =0
	if @FrequencyValue = 0 
		begin
		set @FreqType = 1
		set @FreqId =1
		end
	else if @FrequencyValue= 1 or @FrequencyValue= 2 or @FrequencyValue= 3
		begin 
		set @FreqType = 2  
		if @FrequencyValue= 1 set @FreqId =4
		if @FrequencyValue= 2 set @FreqId =3
		if @FrequencyValue= 3 set @FreqId =2
		end
	else if @FrequencyValue= 22 or @FrequencyValue= 23 or @FrequencyValue= 24 or  @FrequencyValue= 25
		begin
		set @FreqType = 3
		if @FrequencyValue= 22 set @FreqId =8
		if @FrequencyValue= 23 set @FreqId =7
		if @FrequencyValue= 24 set @FreqId =6
		if @FrequencyValue= 25 set @FreqId =5
		end
	else if @FrequencyValue= 4 or @FrequencyValue= 5 or @FrequencyValue= 6 or @FrequencyValue= 7 or @FrequencyValue= 8 or @FrequencyValue= 9
		begin
		set @FreqType = 4
		if @FrequencyValue= 4 set @FreqId =14
		if @FrequencyValue= 5 set @FreqId =13
		if @FrequencyValue= 6 set @FreqId =12
		if @FrequencyValue= 7 set @FreqId =11
		if @FrequencyValue= 8 set @FreqId =10
		if @FrequencyValue= 9 set @FreqId =9
		end
	else if @FrequencyValue= 10 or @FrequencyValue= 11 or @FrequencyValue= 12 or @FrequencyValue= 13 or 
	@FrequencyValue= 14 or @FrequencyValue= 15 or @FrequencyValue= 16 or @FrequencyValue= 17 or @FrequencyValue= 18 
	or @FrequencyValue= 19 or @FrequencyValue= 20 or @FrequencyValue= 21
		begin
		set @FreqType = 5
		if @FrequencyValue= 10 set @FreqId =26
		if @FrequencyValue= 11 set @FreqId =25
		if @FrequencyValue= 12 set @FreqId =24
		if @FrequencyValue= 13 set @FreqId =23
		if @FrequencyValue= 14 set @FreqId =22
		if @FrequencyValue= 15 set @FreqId =21
		if @FrequencyValue= 16 set @FreqId =20
		if @FrequencyValue= 17 set @FreqId =19
		if @FrequencyValue= 18 set @FreqId =18
		if @FrequencyValue= 19 set @FreqId =17
		if @FrequencyValue= 20 set @FreqId =16
		if @FrequencyValue= 21 set @FreqId =15
		end
	else 
		begin
		set @FreqType = 6
		set @FreqId =27
		end

SET @FrequencyId = @FreqId
SET @FrequencyTypeId = @FreqType

----------5.9 Mask
DECLARE @Mask bit
SET @Mask = 0
	IF EXISTS (select * from irp.ReportParameter where Code = 'mask' and ReportID = @RptId and versionto =32767)
	BEGIN
	  SET @Mask = 1
	END

-- set deliverables duration same as subscription duration
SET @DeliverablesDurationFrom = @SubscriptionDurationFrom
SET @DeliverablesDurationTo = @SubscriptionDurationTo


	INSERT INTO @Deliverables Values
	(@ClientId, @CountryId, @ServiceId, @SourceId, @DataTypeId, @SubscriptionDurationFrom, @SubscriptionDurationTo, @ServiceTerritoryId,
@ClientNo, @ReportNo, @DeliveryTypeId, @FrequencyId, @FrequencyTypeId, @PeriodId, @DeliverablesDurationFrom, @DeliverablesDurationTo, @RptId, @RptName, @ReportWriterId, @Mask)

IF (@datatypeid is null OR @serviceid is null OR @periodid is null or @frequencyid is null or @frequencytypeid is null or @reportwriterid is null or @deliverytypeid is null)
BEGIN
--SELECT * FROM @deliverables
RAISERROR ('One of the computed parameters is null, aborting import.', -- Message text.  
               21, -- Severity.  
               1 -- State.  
               );  
END


Declare @NewSubscriptionName varchar(200)
SElect @NewSubscriptionName  = C.Name from Country c where c.countryid = @countryid
SElect @NewSubscriptionName  = @NewSubscriptionName+' '+Svc.Name from [SErvice] svc where svc.serviceid = @serviceid
SElect @NewSubscriptionName  = @NewSubscriptionName+' '+Dt.Name from DataTYpe dt where dt.DataTYpeid = @DataTYpeid
SElect @NewSubscriptionName  = @NewSubscriptionName+' '+src.Name from [Source] src where src.Sourceid = @Sourceid

IF EXISTS (Select * from DeliveryReport where ReportId = @rptid)
BEGIN
	Declare @ExistingDeliverableId int, @ExistingSubscriptionId int
	Select @ExistingDeliverableId = DeliverableID from DeliveryReport where ReportId = @rptid
	Select @ExistingSubscriptionId  = SubscriptionId from Deliverables where DeliverableId = @ExistingDeliverableId

	UPDATE Deliverables 
	SET DeliveryTypeId=DeliveryTypeId, FrequencyId=@FrequencyId, FrequencyTypeId=@FrequencyTypeId, PeriodId=@PeriodId
	WHERE DeliverableId = @ExistingDeliverableId
	
	UPDATE Subscription 
	SET ServiceId=@ServiceId, SourceId=@SourceId, DataTypeId=@DataTypeId, CountryId=@CountryId, ServiceTerritoryId=@ServiceTerritoryId, Name = @NewSubscriptionName
	WHERE SubscriptionId = @ExistingSubscriptionId

	Delete from @DeliverablesData where DeliverableId = @ExistingDeliverableId
	Delete from @SubscriptionData where SubscriptionId = @ExistingSubscriptionId

	Insert into @DeliverablesData values ('UPDATED', @ExistingSubscriptionId,	@ReportWriterId,	@FrequencyTypeId,	null,	@PeriodId,	@Frequencyid,	@SubscriptionDurationFrom,	@DeliverablesDurationTo,	null,	null,	null,	null, GETDATE(), 1, @DeliveryTypeId, @ExistingDeliverableId, @Mask)
	Insert into @SubscriptionData values ('UPDATED', @NewSubscriptionName,	@ClientId,	@DeliverablesDurationFrom,	@SubscriptionDurationTo,	@ServiceTerritoryId,	1,	Getdate(),	1,	@CountryId,	@ServiceId,	@DataTypeId,	@SourceId, @ExistingSubscriptionId) 

END
ELSE
BEGIN

	Declare @NewSubscriptionID int, @NewDeliverableID 	int
	IF EXISTS (SELECT * from Subscription where ClientId = @ClientId and CountryId = @CountryId and [Serviceid]=@serviceid and [SourceId]=@sourceId and DataTypeID = @DataTypeId)
	BEGIN
		SELECT @NewSubscriptionID = SubscriptionId from Subscription where ClientId = @ClientId and CountryId = @CountryId and [Serviceid]=@serviceid and [SourceId]=@sourceId and DataTypeID = @DataTypeId
	END
	ELSE
	BEGIN
	INSERT INTO Subscription (Name,	ClientId,	Country	,[Service]	,Data,	[Source],	StartDate,	EndDate,	ServiceTerritoryId,	Active,	LastModified,	ModifiedBy,	CountryId,	ServiceId,	DataTypeId,	SourceId) 
	values (@NewSubscriptionName, @clientid, null, null, null, null, @SubscriptionDurationFrom, @SubscriptionDurationTo, @ServiceTerritoryId, 1, GetDate(), 1, @CountryId,	@ServiceId,	@DataTypeId,	@SourceId)
	SELECT @NewSubscriptionID = SCOPE_IDENTITY()

		Insert into @SubscriptionData values ('NEW', @NewSubscriptionName,	@ClientId,	@DeliverablesDurationFrom,	@SubscriptionDurationTo,	@ServiceTerritoryId,	1,	Getdate(),	1,	@CountryId,	@ServiceId,	@DataTypeId,	@SourceId, @NewSubscriptionID) 

	END

	INSERT INTO Deliverables (SubscriptionId,	ReportWriterId,	FrequencyTypeId,	RestrictionId,	PeriodId,	Frequencyid,	StartDate,	EndDate,	[probe],	PackException,	Census,	OneKey	,LastModified	,ModifiedBy	,DeliveryTypeId, Mask)
	values (@NewSubscriptionID,	@ReportWriterId,	@FrequencyTypeId,	null,	@PeriodId,	@Frequencyid,	@DeliverablesDurationFrom,	@DeliverablesDurationTo,	null,	null,	null,	null,GetDate(),1,@DeliveryTypeId, @Mask)
	SELECT @NewDeliverableID = SCOPE_IDENTITY()

    Insert into @DeliverablesData values ('NEW', @NewSubscriptionID,	@ReportWriterId,	@FrequencyTypeId,	null,	@PeriodId,	@Frequencyid,	@SubscriptionDurationFrom,	@DeliverablesDurationTo,	null,	null,	null,	null, GETDATE(), 1, @DeliveryTypeId, @NewDeliverableID, @Mask)
	
	INSERT INTO DeliveryReport (deliverableid, reportid) values (@NewDeliverableID, @rptid)


END
END

--6.2 Subchannels
----------------------------- insert subchannels -------------------------------

--entity type table - mapped to DataType
--deliverables to entity type
--iam entity type from items table
--non iam outlettype - outlet master - entity type
--add all entity types for the category (datatype) where non iam outlettype is empty

IF OBJECT_ID('tempdb..#SubChannels') IS NOT NULL
begin
        drop table #SubChannels
end

CREATE TABLE #SubChannels
( 
  [DeliverableId] int
, [EntityTypeId] int
)

--get the entity type id for entries in items table
insert into #SubChannels (EntityTypeId, DeliverableId) select e.EntityTypeId, dl.DeliverableId 
from irp.ReportParameter rp
join irp.Dimension d on rp.VersionTo = 32767 and d.VersionTo = 32767
and rp.Code= 'DimChannel' and rp.Value = d.DimensionID
join irp.Items i on i.Versionto = 32767 and i.DimensionID = d.DimensionID and i.item is not null
join DeliveryReport dr on dr.ReportID = rp.ReportID
join Deliverables dl on dr.DeliverableId = dl.DeliverableId
join Subscription s on s.SubscriptionId = dl.SubscriptionId and s.ClientId = @ClientId
join EntityType e on i.Item = e.EntityTypeCode

MERGE INTO subchannels AS sc
USING (SELECT entitytypeid,deliverableid FROM #subchannels group by entitytypeid,deliverableid) AS tsc 
ON (tsc.entitytypeid = sc.entitytypeid and tsc.deliverableid = sc.deliverableid) 
WHEN NOT MATCHED THEN  
    INSERT (entitytypeid, deliverableid) 
    VALUES (tsc.entitytypeid, tsc.deliverableid); 

drop table #SubChannels

----------------------------- insert subchannels -------------------------------

--IF @debug=1
--BEGIN
--SELECT cn.Name Country, svc.Name [Service], src.Name [Source],  dty.Name DataType, dt.Name DeliveryType, rw.code ReportWriter, fr.Name Frequency, ft.Name FrequencyType, pr.Name Period, ST.TerritoryBase TerritoryBase, d.* FROM @Deliverables d INNER JOIN
--dbo.Country AS cn ON cn.CountryId = d.CountryId INNER JOIN
--dbo.DataType AS dty ON dty.DataTypeId = d.DataTypeId INNER JOIN
--dbo.Service AS svc ON svc.ServiceId = d.ServiceId INNER JOIN
--dbo.ServiceTerritory AS st ON st.ServiceTerritoryId = d.ServiceTerritoryId INNER JOIN
--dbo.Source AS src ON src.SourceId = d.SourceId INNER JOIN
--dbo.ReportWriter AS rw ON rw.ReportWriterId = d.ReportWriterId INNER JOIN
--dbo.Frequency AS fr ON fr.FrequencyId = d.Frequencyid INNER JOIN
--dbo.FrequencyType AS ft ON ft.FrequencyTypeId = d.FrequencyTypeId INNER JOIN
--dbo.Period AS pr ON pr.PeriodId = d.PeriodId INNER JOIN
--dbo.DeliveryType AS dt ON dt.DeliveryTypeId = d.DeliveryTypeId
--END -- @debug=1

NOClient:

SELECT dt.Name DeliveryType, rw.code ReportWriter, fr.Name Frequency, ft.Name FrequencyType, pr.Name Period,  d.* FROM @DeliverablesData d INNER JOIN
dbo.ReportWriter AS rw ON rw.ReportWriterId = d.ReportWriterId INNER JOIN
dbo.Frequency AS fr ON fr.FrequencyId = d.Frequencyid INNER JOIN
dbo.FrequencyType AS ft ON ft.FrequencyTypeId = d.FrequencyTypeId INNER JOIN
dbo.Period AS pr ON pr.PeriodId = d.PeriodId INNER JOIN
dbo.DeliveryType AS dt ON dt.DeliveryTypeId = d.DeliveryTypeId inner join
dbo.deliverables as de on de.deliverableid = d.deliverableid


SELECT cn.Name Country, svc.Name [Service], src.Name [Source], ST.TerritoryBase TerritoryBase, dty.Name DataType, s.* from @SubscriptionData s INNER JOIN
dbo.Country AS cn ON cn.CountryId = s.CountryId INNER JOIN
dbo.DataType AS dty ON dty.DataTypeId = s.DataTypeId INNER JOIN
dbo.Service AS svc ON svc.ServiceId = s.ServiceId INNER JOIN
dbo.ServiceTerritory AS st ON st.ServiceTerritoryId = s.ServiceTerritoryId INNER JOIN
dbo.Source AS src ON src.SourceId = s.SourceId


COMMIT
END TRY
BEGIN CATCH
--rollback on error
    ROLLBACK
	PRINT ERROR_MESSAGE();
END CATCH;

SET NOCOUNT OFF
END
