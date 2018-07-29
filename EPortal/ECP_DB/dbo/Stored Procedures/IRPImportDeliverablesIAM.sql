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
				set @Service = 'Profits'
			else if @Service = 'PROBE Packs Manufacturer' or @Service ='PROBE Packs Exceptions' or @Service = 'PROBE Pack Manufacturer'
			BEGIN

				Declare @PFCDifference int
				set @PFCDifference = -1

				select @PFCDifference

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

				select @pfcdifference
				
				if (@PFCDifference > 0) 
					SET @Service = 'PROFITS + PROBE'
				ELSE 
					set @Service = 'PROBE'

			END
			----else
			----	set @Service = 'Probe'
			----
			--set @Value=0
			--select @Value=Value, @writerParamId = WriterParameterID from IRP.ReportParameter where reportid = @RptId  and VersionTo=32767 and Code='DimChannel'
			--select @DataType= DimensionName from IRP.Dimension where dimensiontype= 4 and DimensionID = @Value
			--set @DataType =  LEFT(@DataType, CHARINDEX('Channel', @DataType) - 1)
			--set @DataType =  replace(@DataType,'Combined',' Retail + Hospital')

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
				if (len(@DataType) >0) BEGIN  SET @DataType = CONCAT (@DataType, ' + ', 'Other' ) END
				ELSE BEGIN set @DataType = 'Other' END
			end
			
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

	select * from IRG_Deliverables_IAM
-- Insert records into subscription & deliverables from IRG_Deliverables_IAM table
	
	
	execute dbo.IRPProcessDeliverablesIAM
	
	delete from dbo.IRG_Deliverables_IAM where Clientid=@ClientId


END