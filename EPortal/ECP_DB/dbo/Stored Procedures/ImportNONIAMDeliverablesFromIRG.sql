CREATE procedure [dbo].[ImportNONIAMDeliverablesFromIRG]
( @ClientNo int)
As
BEGIN
SET NOCOUNT ON

declare @debug int = 0

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
--6.2 Subchannels
------Sections---------

BEGIN TRAN

BEGIN TRY
-------Variable Declarations---------
Declare @ClientId int, @RowsToProcess int, @CurrentRow int
-------Variable Declarations---------
-------Table Declarations---------
DECLARE @Report TABLE (RowID int not null primary key identity(1,1), clientNo int,rptNo int, bkt_sel varchar(100),cat_sel varchar(100),XREF_Client int,rptSelection varchar(500),report_name varchar(500), lvl_total char(8) )  
DECLARE @Deliverables TABLE (RowID int not null identity(1,1), ClientId int, CountryId int, ServiceId int, SourceId int, DataTypeId int, SubscriptionDurationFrom datetime, SubscriptionDurationTo datetime, ServiceTerritoryId int, 
ClientNo int, ReportNo int, DeliveryTypeId int, FrequencyId int, FrequencyTypeId int, PeriodId int, DeliverablesDurationFrom datetime, DeliverablesDurationTo datetime, ReportName varchar(100), ReportWriterId int, RestrictionId int, PRIMARY KEY (ClientNo, ReportNo, ReportWriterId) )
DECLARE @DeliverablesData TABLE ([Status] varchar(20), SubscriptionId int,	ReportWriterId int,	FrequencyTypeId int,	RestrictionId int,	PeriodId int,	Frequencyid int,	StartDate datetime,	EndDate datetime,	[probe] varchar(500),	PackException bit,	Census bit,	OneKey	bit,LastModified	datetime,ModifiedBy	int,DeliveryTypeId int, DeliverableId int)
DECLARE @SubscriptionData TABLE ([Status] varchar(20), Name VARCHAR(500),	ClientId int,	StartDate datetime,	EndDate datetime,	ServiceTerritoryId int,	Active bit,	LastModified datetime,	ModifiedBy int,	CountryId int,	ServiceId int,	DataTypeId int,	SourceId int, SubscriptionId int) 
-------Table Declarations---------

----------------------------------------1.VALIDATIONS---------------------------------
----------------------------------------1.VALIDATIONS---------------------------------


----------------------------------------5.SUBSCRIPTIONS and DELIVERABLES---------------------------------

---------Get Everest Client ID
SELECT @ClientId = ClientId FROM IRP.ClientMap WHERE IRPClientNo = @ClientNo

if (@ClientId is null) GOTO NoClient


---------5a.Get the reports / deliverables for the client
INSERT into @Report (clientNo,rptNo, bkt_sel, cat_sel, XREF_Client,rptSelection,report_name, lvl_total)
select  CLD.CLIENT_NO, CLD.RPT_NO, BKT_SEL, CAT_SEL, XREF_CLIENT,RPT_SELECTION, report_name,lvl_total from IRP.CLD 
	inner join IRP.RD on CLD.CLIENT_NO = RD.CLIENT_NO and CLD.RPT_NO = RD.RPT_NO
	where RD.RPT_SELECTION not in ('ID','IA','IB','IW') and len(rpt_selection) = 2 and @ClientNo = CLD.CLIENT_NO
	UNION
	select  CLD.CLIENT_NO, CLD.RPT_NO, BKT_SEL, CAT_SEL, XREF_CLIENT,SUBSTRING(RPT_SELECTION, 1, 2) RPT_SELECTION, report_name,lvl_total from IRP.CLD 
	inner join IRP.RD on CLD.CLIENT_NO = RD.CLIENT_NO and CLD.RPT_NO = RD.RPT_NO
	where RD.RPT_SELECTION not in ('ID','IA','IB','IW') and len(rpt_selection) = 4 and @ClientNo = CLD.CLIENT_NO
	UNION
	select  CLD.CLIENT_NO, CLD.RPT_NO, BKT_SEL, CAT_SEL, XREF_CLIENT,SUBSTRING(RPT_SELECTION, 3, 2) RPT_SELECTION, report_name,lvl_total from IRP.CLD 
	inner join IRP.RD on CLD.CLIENT_NO = RD.CLIENT_NO and CLD.RPT_NO = RD.RPT_NO
	where RD.RPT_SELECTION not in ('ID','IA','IB','IW') and len(rpt_selection) = 4 and @ClientNo = CLD.CLIENT_NO

--if (@Debug =1) BEGIN SELECT * FROM @Report END


---------5b. Loop through each deliverable

SET @RowsToProcess=@@ROWCOUNT
SET @CurrentRow=0
--if (@Debug =1) PRINT 'Loop through each deliverable, number of rows: '  + convert(varchar(10), @RowsToProcess)
WHILE @CurrentRow<@RowsToProcess
BEGIN
	SET @CurrentRow=@CurrentRow+1
	--if (@Debug =1) BEGIN PRINT 'loop ' + convert(varchar(10), @CurrentRow) END

	-- variables used for each deliverable --
	DECLARE @CountryId int, @ServiceId int, @SourceId int, @DataTypeId int, @SubscriptionDurationFrom datetime, @SubscriptionDurationTo datetime, @ServiceTerritoryId int, @ReportWriterCode VARCHAR(100), @ReportWriterId int
	DECLARE  @DeliveryTypeId int, @FrequencyId int, @FrequencyTypeId int, @PeriodId int, @DeliverablesDurationFrom datetime, @DeliverablesDurationTo datetime
	DECLARE @ReportNo int, @RptName varchar(500),@WriterId int, @ClientName varchar(500),@bkt_Sel varchar(100),@cat_Sel varchar(100), @Lvl_total char(8), @XREFClient int	
	-- variables used for each deliverable --
	
	SELECT  @ReportNo=rptNo,  @RptName=report_name, @bkt_Sel = BKT_SEL,@cat_Sel= cat_sel, @ReportWriterCode = LTRIM(RTRIM(rptSelection)), @XREFClient=XREF_Client, @Lvl_total = lvl_total
		FROM @Report WHERE RowID=@CurrentRow
DECLARE @data varchar(100)
set @data = null
	SELECT top 1 @data = [Data] from IRG_ExtractionType where ExtType = LTrim(RTrim(@ReportWriterCode))
	SELECT top 1 @ReportWriterId = ReportWriterId from ReportWriter where code = LTrim(RTrim(@ReportWriterCode))

--if (@debug = 1) BEGIN print isnull(@data, 'null') END

IF ((@data is null) OR (@data in ('Audit','Reference', 'Demographics')))
 GOTO SkipDeliverable
 
--------5.1. Country
SET @CountryId=1 --defaulted to AUS
--------5.2. Source
SET @SourceId=1 --defaulted to Sell In
--------5.5. Duration
SET @SubscriptionDurationFrom=DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) --defaulted to jan 1
SET @SubscriptionDurationTo=DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1) --defaulted to dec 31
     -- set deliverables duration same as subscription duration
SET @DeliverablesDurationFrom = @SubscriptionDurationFrom
SET @DeliverablesDurationTo = @SubscriptionDurationTo
---------5.7 FrequencyType and Frequency
set @FrequencyTypeId=1 -- default to monthly
set @FrequencyId = 1

--------5.3. Service
--if (@Debug =1) BEGIN 
--PRINT '5.3. Service'
--PRINT 'ReportWritercode' + @reportwritercode
--END

if (@ReportWriterCode in ('AD', 'C9', 'C6', 'C5' ))
BEGIN
Declare @PFCDifference int
set @PFCDifference = -1

				select @PFCDifference = Count(PFC) from (
select convert(varchar, p.PFC) PFC from irp.Dimension d
join irp.Client c on d.VersionTo = 32767 and c.VersionTo = 32767 and c.ClientID = d.ClientID
join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT
join irp.rd rd on rd.CLIENT_NO = cld.CLIENT_NO and rd.RPT_NO = cld.RPT_NO and d.DimensionName = rd.REPORT_NAME
--items
join irp.Items i on i.DimensionID = d.DimensionID and i.VersionTo = 32767 and i.Item is not null 
join DIMProduct_Expanded p on i.item = convert(varchar, p.fcc)
where rd.RPT_NO = @ReportNo and rd.CLIENT_NO = @ClientNo
INTERSECT
(
select convert(varchar, p.PFC) PFC from irp.rd rd
join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
--mfr
join irp.clientmfr m on m.ClientNo =c.ClientNo
join DIMProduct_Expanded p on m.mfrno = p.Org_code
where rd.RPT_NO = @ReportNo and rd.CLIENT_NO = @ClientNo
union
select convert(varchar, ce.Pack) PFC from irp.rd rd
join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
--exceptions
join irp.CLIENTEXCEPTIONS ce on ce.ClientNo = c.ClientNo
where rd.RPT_NO = @ReportNo and rd.CLIENT_NO = @ClientNo
)
) packs


IF (@PFCDifference=0) set @ServiceId = 2 --'PROFITS'
ELSE
BEGIN
--probe or profits+probe
				set @PFCDifference = -1

				select @PFCDifference = Count(PFC) from (
select convert(varchar, p.PFC) PFC from irp.Dimension d
join irp.Client c on d.VersionTo = 32767 and c.VersionTo = 32767 and c.ClientID = d.ClientID
join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT
join irp.rd rd on rd.CLIENT_NO = cld.CLIENT_NO and rd.RPT_NO = cld.RPT_NO and d.DimensionName = rd.REPORT_NAME
--items
join irp.Items i on i.DimensionID = d.DimensionID and i.VersionTo = 32767 and i.Item is not null 
join DIMProduct_Expanded p on i.item = convert(varchar, p.fcc)
where rd.RPT_NO = @ReportNo and rd.CLIENT_NO = @ClientNo
EXCEPT
(
select convert(varchar, p.PFC) PFC from irp.rd rd
join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
--mfr
join irp.clientmfr m on m.ClientNo =c.ClientNo
join DIMProduct_Expanded p on m.mfrno = p.Org_code
where rd.RPT_NO = @ReportNo and rd.CLIENT_NO = @ClientNo
union
select convert(varchar, ce.Pack) PFC from irp.rd rd
join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
--exceptions
join irp.CLIENTEXCEPTIONS ce on ce.ClientNo = c.ClientNo
where rd.RPT_NO = @ReportNo and rd.CLIENT_NO = @ClientNo
)
) packs

				if (@PFCDifference > 0) 
					SET @ServiceId = 7 --'PROFITS+PROBE'
				ELSE 
					set @ServiceId = 1 --'PROBE'

END --@PFCDifference = 0 ELSE
END --@reportwritercode in ('AD', 'C9', 'C6', 'C5' )
ELSE
BEGIN
	--IF (@debug=1) BEGIN print 'look up irgextracttype ' END
 
	Declare @service varchar(100)
	SET @service = null
	Select @service = [service] from IRG_ExtractionType where @ReportWriterCode = ExtType
	If (@service = 'PROFITS/PROBE') SET @service = 'PROFITS + PROBE'
	BEGIN Select @ServiceId = ServiceId from [Service] where Name = @service END
	
END

--if (@debug = 1) BEGIN print 'Reportwritercode ''' + @ReportWriterCode + ''' ,Service: ' +  isnull(@service, 'null') END


--------5.4. DataType
--if (@Debug =1) PRINT '5.4. DataType'
Declare @DataType varchar(100)
set @DataType =null
if exists (select * from IRG_CAT_SEL where Cat = @cat_Sel and DataType = 'Retail')
begin
	set @DataType = 'Retail'
end

if exists (select * from IRG_CAT_SEL where Cat = @cat_Sel and DataType = 'Hospital')
begin
	if (len(@DataType) >0) BEGIN  SET @DataType = CONCAT (@DataType, ' + ', 'Hospital' ) END
	ELSE BEGIN set @DataType = 'Hospital' END
				
end

if exists (select * from IRG_CAT_SEL where Cat = @cat_Sel and DataType = 'Other')
begin
	if (len(@DataType) >0) BEGIN  SET @DataType = CONCAT (@DataType, ' + ', 'Other Outlet' ) END
	ELSE BEGIN set @DataType = 'Other Outlet' END
end

SELECT @DataTypeId = DataTypeId from DataType where Name = @DataType

--------5.5. ServiceTerritory
	IF @ServiceId = 1 SET @ServiceTerritoryId = 2 --Outlet level for PROBE
	ELSE if @ServiceId = 2 SET @ServiceTerritoryId = 1 --Brick level for PROFITS
	ELSE if @ServiceId = 7 SET @ServiceTerritoryId = 3 --Both level for PROFITS + PROBE
	ELSE SET @ServiceTerritoryId = 4 --set as N/A

----------5.6 Period
Declare @period varchar(100)
SET @period = null
if @bkt_Sel = 'F1M1'  or @bkt_Sel = 'H1M1' or @bkt_Sel = 'OA1Y'
set @Period = '1 Year'
else if @bkt_Sel = 'FLT1'  or @bkt_Sel = 'FLT2' or @bkt_Sel = 'H2M1' or @bkt_Sel = 'H2W1' or @bkt_Sel = 'OA2Y' or @bkt_Sel = 'RXF2' or @bkt_Sel = 'T1RA' or @bkt_Sel = 'T5UN'
set @Period = '2 Years'
else if @bkt_Sel = 'F3M1'  or @bkt_Sel = 'F3M2' or @bkt_Sel = 'F3M3' or @bkt_Sel = 'H3M1'
set @Period = '3 Years'
else if @bkt_Sel = 'F5M1'  or @bkt_Sel = 'F5M2' or @bkt_Sel = 'F5M3' or @bkt_Sel = 'H5M1' or @bkt_Sel = 'H5M3'
set @Period = '5 Years'
SELECT @PeriodId = PeriodId from Period where Name = @Period

--------5.8 DeliveryType
--if (@Debug =1) PRINT '5.8 DeliveryType'
Declare @DeliveryType varchar(100)
SET @DeliveryType = null
Select @DeliveryType = [Deliverable] from IRG_ExtractionType where @ReportWriterCode = ExtType
If (@DeliveryType = 'CBG') SET @DeliveryType = 'CBG Dashboard'
Select @DeliveryTypeId = DeliveryTypeId from [DeliveryType] where Name = @DeliveryType
--------5.8 DeliveryType

--------5.9 Restriction
Declare @RestrictionId int
SET @RestrictionId = null
if @Lvl_Total is null 
	set @RestrictionId = null
else
	set @RestrictionId = cast(@Lvl_total as int)
--------5.9 Restriction

INSERT INTO @Deliverables Values
	(@ClientId, @CountryId, @ServiceId, @SourceId, @DataTypeId, @SubscriptionDurationFrom, @SubscriptionDurationTo, @ServiceTerritoryId,
@ClientNo, @ReportNo, @DeliveryTypeId, @FrequencyId, @FrequencyTypeId, @PeriodId, @DeliverablesDurationFrom, @DeliverablesDurationTo, @RptName, @ReportWriterId, @RestrictionId)


IF (@datatypeid is null OR @serviceid is null OR @periodid is null or @frequencyid is null or @frequencytypeid is null or @reportwriterid is null or @deliverytypeid is null)
BEGIN
PRINT 'One of the computed parameters is null, aborting import.'
RAISERROR ('One of the computed parameters is null, aborting import.', -- Message text.  
				21, -- Severity.  
				1 -- State.  
				);  
END





--if (@Debug =1) PRINT 'Insert or Update Subscirption & Deliverables'
Declare @NewSubscriptionName varchar(200)
SElect @NewSubscriptionName  = C.Name from Country c where c.countryid = @countryid
SElect @NewSubscriptionName  = @NewSubscriptionName+' '+Svc.Name from [SErvice] svc where svc.serviceid = @serviceid
SElect @NewSubscriptionName  = @NewSubscriptionName+' '+Dt.Name from DataTYpe dt where dt.DataTYpeid = @DataTYpeid
SElect @NewSubscriptionName  = @NewSubscriptionName+' '+src.Name from [Source] src where src.Sourceid = @Sourceid

IF EXISTS (Select * from DeliveryReport dr join Deliverables d on d.DeliverableId = dr.DeliverableId
join subscription s on s.SubscriptionId = d.SubscriptionId
where s.ClientId=@ClientId and ReportNo=@ReportNo and ReportwriterCode = @ReportWriterCode)
BEGIN

	Declare @ExistingDeliverableId int, @ExistingSubscriptionId int
	Select @ExistingDeliverableId = dr.DeliverableId from DeliveryReport dr join Deliverables d on d.DeliverableId = dr.DeliverableId
join subscription s on s.SubscriptionId = d.SubscriptionId
where s.ClientId=@ClientId and ReportNo=@ReportNo and ReportwriterCode = @ReportWriterCode
	Select @ExistingSubscriptionId  = SubscriptionId from Deliverables where DeliverableId = @ExistingDeliverableId

	UPDATE Deliverables 
	SET DeliveryTypeId=DeliveryTypeId, FrequencyId=@FrequencyId, FrequencyTypeId=@FrequencyTypeId, PeriodId=@PeriodId, ReportWriterId= @ReportWriterId, RestrictionId=@RestrictionId
	WHERE DeliverableId = @ExistingDeliverableId
	
	UPDATE Subscription 
	SET ServiceId=@ServiceId, SourceId=@SourceId, DataTypeId=@DataTypeId, CountryId=@CountryId, ServiceTerritoryId=@ServiceTerritoryId, Name = @NewSubscriptionName
	WHERE SubscriptionId = @ExistingSubscriptionId

	Delete from @DeliverablesData where DeliverableId = @ExistingDeliverableId
	Delete from @SubscriptionData where SubscriptionId = @ExistingSubscriptionId

	Insert into @DeliverablesData values ('UPDATED', @ExistingSubscriptionId,	@ReportWriterId,	@FrequencyTypeId,	@RestrictionId,	@PeriodId,	@Frequencyid,	@SubscriptionDurationFrom,	@DeliverablesDurationTo,	null,	null,	null,	null, GETDATE(), 1, @DeliveryTypeId, @ExistingDeliverableId)
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
		SELECT @NewSubscriptionID = scope_identity()

		Insert into @SubscriptionData values ('NEW', @NewSubscriptionName,	@ClientId,	@DeliverablesDurationFrom,	@SubscriptionDurationTo,	@ServiceTerritoryId,	1,	Getdate(),	1,	@CountryId,	@ServiceId,	@DataTypeId,	@SourceId, @NewSubscriptionID) 

	END

	IF EXISTS (SELECT * from Deliverables WHERE SubscriptionId = @NewSubscriptionID and @ReportWriterId=ReportWriterId and @FrequencyTypeId = FrequencyTypeId and @PeriodId =PeriodId and	@Frequencyid=Frequencyid and	@DeliveryTypeId=DeliveryTypeId)
	BEGIN
		SELECT @NewDeliverableID = DeliverableId from  Deliverables WHERE SubscriptionId = @NewSubscriptionID and @ReportWriterId=ReportWriterId and @FrequencyTypeId = FrequencyTypeId and @PeriodId =PeriodId and	@Frequencyid=Frequencyid and	@DeliveryTypeId=DeliveryTypeId
	END
	ELSE
	  INSERT INTO Deliverables (SubscriptionId,	ReportWriterId,	FrequencyTypeId,	RestrictionId,	PeriodId,	Frequencyid,	StartDate,	EndDate,	[probe],	PackException,	Census,	OneKey	,LastModified	,ModifiedBy	,DeliveryTypeId)
	  values (@NewSubscriptionID,	@ReportWriterId,	@FrequencyTypeId,	@RestrictionId,	@PeriodId,	@Frequencyid,	@DeliverablesDurationFrom,	@DeliverablesDurationTo,	null,	null,	null,	null,GetDate(),1,@DeliveryTypeId)
	  SELECT @NewDeliverableID = scope_identity()
	
	  Insert into @DeliverablesData values ('NEW', @NewSubscriptionID,	@ReportWriterId,	@FrequencyTypeId,	@RestrictionId,	@PeriodId,	@Frequencyid,	@SubscriptionDurationFrom,	@DeliverablesDurationTo,	null,	null,	null,	null, GETDATE(), 1, @DeliveryTypeId, @NewDeliverableID)
	  
	END --deliverable exists else insert


SkipDeliverable:
END --loop

--DELETE FROM @DeliverablesData where DeliverableId IS null --clean up unresolved entries to deliveryreport due to unresolved identity of deliverableid
NoClient:

COMMIT
END TRY
BEGIN CATCH
--rollback on error
    ROLLBACK
	PRINT ERROR_MESSAGE();
	GOTO GotError
END CATCH;

--IF (@debug =1) BEGIN select * from @Deliverables END

--------------------------------- update deliveryreport table -----------------------
BEGIN TRY
select @RowsToProcess=count(*) from @Deliverables
SET @CurrentRow=0
WHILE @CurrentRow<@RowsToProcess
BEGIN
	SET @CurrentRow=@CurrentRow+1

Declare @deliverableIdforReport int
set @deliverableIdforReport = null

select @clientid = d.clientid, @RptName = d.ReportName,
@CountryId = d.CountryId, @serviceid =d.[Serviceid], @sourceid=d.[SourceId], @DataTypeID =d.DataTypeID
, @ReportWriterId=d.ReportWriterId , @FrequencyTypeId = d.FrequencyTypeId , @PeriodId =d.PeriodId , @Frequencyid=d.Frequencyid , @DeliveryTypeId=d.DeliveryTypeId,
@ReportNo = d.ReportNo, @RptName = d.ReportName, @ReportWriterCode = w.code
from @deliverables d 
join ReportWriter w on w.ReportWriterId = d.ReportWriterId
where d.rowid = @currentrow


SELECT  @deliverableIdforReport = d.deliverableid from deliverables d 
join Subscription s on s.SubscriptionId = d.SubscriptionId 
where s.ClientId = @ClientId and s.CountryId = @CountryId and s.[Serviceid]=@serviceid and s.[SourceId]=@sourceId and s.DataTypeID = @DataTypeId
and @ReportWriterId=d.ReportWriterId and @FrequencyTypeId = d.FrequencyTypeId and @PeriodId =d.PeriodId and	@Frequencyid=d.Frequencyid and	@DeliveryTypeId=d.DeliveryTypeId

--PRINT 'SELECT  d.deliverableid from deliverables d join Subscription s on s.SubscriptionId = d.SubscriptionId' + 
--' where s.ClientId = '+convert(varchar(10),@ClientId)+' and s.CountryId = '+convert(varchar(10),@CountryId)+' and s.[Serviceid]='+convert(varchar(10),@serviceid)+'   and s.[SourceId]='+convert(varchar(10),@sourceId)+'  and s.DataTypeID = '+convert(varchar(10),@DataTypeId) + '
--and '+convert(varchar(10),@ReportWriterId)+'=d.ReportWriterId and '+convert(varchar(10),@FrequencyTypeId) +'  = d.FrequencyTypeId and '+convert(varchar(10),@PeriodId) +'  =d.PeriodId and	'+convert(varchar(10),@Frequencyid) +' =d.Frequencyid and	'+convert(varchar(10),@DeliveryTypeId) +' =d.DeliveryTypeId'


	IF @deliverableIdforReport is not null
	BEGIN

		--print 		'select * from  deliveryreport r join deliverables d on 
		--d.DeliverableId = r.DeliverableId
		--join Subscription s on s.SubscriptionId = d.SubscriptionId and s.ClientId = '+convert(varchar(10), @ClientId)+
		--'where r.reportno='+convert(varchar(10), @ReportNo)+' and  r.ReportWriterCode = '+convert(varchar(10), @ReportWriterCode)

		if not exists( select * from  deliveryreport r join deliverables d on 
		d.DeliverableId = r.DeliverableId
		join Subscription s on s.SubscriptionId = d.SubscriptionId and s.ClientId = @ClientId
		where r.reportno=@ReportNo and  r.ReportWriterCode = @ReportWriterCode)
		BEGIN
		--print 'added into delivery report - deliverableid:'+ convert(varchar(20),@deliverableIdforReport)  +' reportno:'+ convert(varchar(20),@reportno) +'  ReportWriterCode :'+ @ReportWriterCode +' reportname:'+ @RptName
		INSERT INTO DeliveryReport(deliverableid, reportno,  ReportWriterCode, reportname) values (@deliverableIdforReport, @ReportNo, @ReportWriterCode, @RptName)
		END
	END
	ELSE PRINT 'Unable to find match deliverable for reportno:' + convert(varchar(20),@reportno) + ' reportwriter:' + @reportwritercode

END
END TRY
BEGIN CATCH
--rollback on error    
	PRINT 'Error in insert to delivery report'
	PRINT ERROR_MESSAGE();
END CATCH;

----------------------- insert subchannels ------------------
--entity type table - mapped to DataType
--deliverables to entity type
--iam entity type from items table
--non iam outlettype - outlet master - entity type
--add all entity types for the category (datatype) where non iam outlettype is empty
BEGIN TRY
IF OBJECT_ID('tempdb..#SubChannels') IS NOT NULL
begin
        drop table #SubChannels
end

CREATE TABLE #SubChannels
( 
  [DeliverableId] int
, [EntityTypeId] int
)

-- 6.2 Subchannels
---subchannels for comma separated values in IRG_CAT_SEL----
--get the entity type id for entries matching in 'RGPF CC TABLE OUTPUT TYPES - entity types' column in irg_cat_sel
insert into #SubChannels (EntityTypeId, DeliverableId) select e.EntityTypeId, d.DeliverableId from DeliveryReport dr
join deliverables d on dr.DeliverableId =dr.DeliverableId and d.DeliveryTypeId in (1,2) 
join subscription s on d.SubscriptionId = s.SubscriptionId and s.ClientId = @ClientId
join clients c on s.ClientId = c.id
join irp.cld cld on cld.RPT_NO = dr.ReportNo and cld.CLIENT_NO = c.IRPClientNo
join 
--split the comma separated entry and find the entity type
(SELECT A.Cat, Split.a.value('.', 'VARCHAR(100)') AS String  
FROM  (SELECT [RGPF CC TABLE OUTPUT TYPES - entity types],  Cat, 
     CAST ('<M>' + REPLACE([RGPF CC TABLE OUTPUT TYPES - entity types], ',', '</M><M>') + '</M>' AS XML) AS String  
	 FROM  [IRG_CAT_SEL]) AS A CROSS APPLY String.nodes ('/M') AS Split(a)) b
	 on b.cat = cld.cat_sel and b.String is not null and b.String <> ''
	 join irp.OutletMaster om on om.out_type = ltrim(rtrim(b.String))
	 join EntityType e on e.entitytypecode = om.entity_type

----subchannels for empty entries in IRG_CAT_SEL
--get all entity type ids for retail / hospital / other if entries in 'RGPF CC TABLE OUTPUT TYPES - entity types' column in irg_cat_sel which is empty
insert into #SubChannels (EntityTypeId, DeliverableId) select e.EntityTypeId, d.DeliverableId from DeliveryReport dr
join deliverables d on dr.DeliverableId =dr.DeliverableId and d.DeliveryTypeId in (1,2) 
join subscription s on d.SubscriptionId = s.SubscriptionId  and s.ClientId = @ClientId
join clients c on s.ClientId = c.id
join irp.cld cld on cld.RPT_NO = dr.ReportNo and cld.CLIENT_NO = c.IRPClientNo
join [IRG_CAT_SEL] cat on cat.Cat = cld.CAT_SEL and ([RGPF CC TABLE OUTPUT TYPES - entity types] is null or RTRIM(LTRIM([RGPF CC TABLE OUTPUT TYPES - entity types])) = '')
join irp.OutletType ot on cat.DataType = ot.OutletCategoryName
join irp.outletmaster om on om.out_type = ot.OutletType
join EntityType e on e.EntityTypeCode = om.entity_type

MERGE INTO subchannels AS sc
USING (SELECT entitytypeid,deliverableid FROM #subchannels group by entitytypeid,deliverableid) AS tsc 
ON (tsc.entitytypeid = sc.entitytypeid and tsc.deliverableid = sc.deliverableid) 
WHEN NOT MATCHED THEN  
    INSERT (entitytypeid, deliverableid) 
    VALUES (tsc.entitytypeid, tsc.deliverableid); 

drop table #SubChannels

END TRY
BEGIN CATCH
	PRINT 'Error in insert subchannels'
	PRINT ERROR_MESSAGE();
END CATCH;

GotError:

--IF (@debug=1)  
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


SELECT dt.Name DeliveryType, rw.code ReportWriter, fr.Name Frequency, ft.Name FrequencyType, pr.Name Period,  d.* FROM @DeliverablesData d INNER JOIN
dbo.ReportWriter AS rw ON rw.ReportWriterId = d.ReportWriterId INNER JOIN
dbo.Frequency AS fr ON fr.FrequencyId = d.Frequencyid INNER JOIN
dbo.FrequencyType AS ft ON ft.FrequencyTypeId = d.FrequencyTypeId INNER JOIN
dbo.Period AS pr ON pr.PeriodId = d.PeriodId INNER JOIN
dbo.DeliveryType AS dt ON dt.DeliveryTypeId = d.DeliveryTypeId
join Deliverables de on d.DeliverableId = de.DeliverableId
join Subscription s on s.SubscriptionId = d.SubscriptionId and s.ClientId = @ClientId

SELECT cn.Name Country, svc.Name [Service], src.Name [Source], ST.TerritoryBase TerritoryBase, dty.Name DataType, s.* from @SubscriptionData s INNER JOIN
dbo.Country AS cn ON cn.CountryId = s.CountryId INNER JOIN
dbo.DataType AS dty ON dty.DataTypeId = s.DataTypeId INNER JOIN
dbo.Service AS svc ON svc.ServiceId = s.ServiceId INNER JOIN
dbo.ServiceTerritory AS st ON st.ServiceTerritoryId = s.ServiceTerritoryId INNER JOIN
dbo.Source AS src ON src.SourceId = s.SourceId


SET NOCOUNT OFF
END



-------------------------- earlier implementation for reference---------------

--if LTrim(RTrim(@service))='Nielsen feed' or LTrim(RTrim(@service))='Pharma Trend' 
--		begin
--			select @ReportWriterId = null, @FrequencyId = null,@PeriodId =null
			
--			if LTrim(RTrim(@service))='Pharma Trend' 
--			begin
--				select top 1 @PeriodId = Periodid from Period where Number=3
--			end
--			if LTrim(RTrim(@service))='Nielsen feed' 
--			begin
--				select top 1 @PeriodId = Periodid from Period where Number=160
--			end
--			if @PeriodId is null or @PeriodId = 0
--			begin
--				select top 1 @PeriodId = Periodid from Period where Number=3
--			end
--			insert into ServiceConfiguration values(@serviceId,'period',@PeriodId)
--			insert into ServiceConfiguration values(@serviceId,'frequency',0)
--		end

-------------------------- earlier implementation---------------
