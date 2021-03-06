﻿
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

			--service
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
			where rd.RPT_NO = @RptNo and rd.CLIENT_NO = @ClientNo
			INTERSECT
			(
			select convert(varchar, p.PFC) PFC from irp.rd rd
			join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
			join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
			--mfr
			join irp.clientmfr m on m.ClientNo =c.ClientNo
			join DIMProduct_Expanded p on m.mfrno = p.Org_code
			where rd.RPT_NO = @RptNo and rd.CLIENT_NO = @ClientNo
			union
			select convert(varchar, ce.Pack) PFC from irp.rd rd
			join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
			join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
			--exceptions
			join irp.CLIENTEXCEPTIONS ce on ce.ClientNo = c.ClientNo
			where rd.RPT_NO = @RptNo and rd.CLIENT_NO = @ClientNo
			)
			) packs


			IF (@PFCDifference=0) set @Service = 'PROFITS'
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
			where rd.RPT_NO = @RptNo and rd.CLIENT_NO = @ClientNo
			EXCEPT
			(
			select convert(varchar, p.PFC) PFC from irp.rd rd
			join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
			join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
			--mfr
			join irp.clientmfr m on m.ClientNo =c.ClientNo
			join DIMProduct_Expanded p on m.mfrno = p.Org_code
			where rd.RPT_NO = @RptNo and rd.CLIENT_NO = @ClientNo
			union
			select convert(varchar, ce.Pack) PFC from irp.rd rd
			join irp.Client c on c.VersionTo = 32767 and rd.CLIENT_NO = c.ClientNo 
			join irp.cld Cld on c.ClientNo = cld.XREF_CLIENT and rd.RPT_NO = cld.RPT_NO
			--exceptions
			join irp.CLIENTEXCEPTIONS ce on ce.ClientNo = c.ClientNo
			where rd.RPT_NO = @RptNo and rd.CLIENT_NO = @ClientNo
			)
			) packs

			if (@PFCDifference > 0) 
								SET @Service = 'PROFITS+PROBE'
							ELSE 
								set @Service = 'PROBE'

			END
			END

			--datatype
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
				if (len(@DataType) >0) BEGIN  SET @DataType = CONCAT (@DataType, ' + ', 'Other' ) END
				ELSE BEGIN set @DataType = 'Other' END
			end

		
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
