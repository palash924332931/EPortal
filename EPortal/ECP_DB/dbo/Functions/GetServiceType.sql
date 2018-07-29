CREATE FUNCTION GetServiceType( @ClientNo as int,@ReportNo as int, @ReportWriterCode as varchar(2))
RETURNS varchar(30)
as

BEGIN
Declare @service varchar(100)
	SET @service = null
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
					SET @Service = 'PROFITS+PROBE'
				ELSE 
					set @Service = 'PROBE'

END --@PFCDifference = 0 ELSE
END --@reportwritercode in ('AD', 'C9', 'C6', 'C5' )
ELSE
BEGIN
	--IF (@debug=1) BEGIN print 'look up irgextracttype ' END
 
	Select @service = [service] from IRG_ExtractionType where @ReportWriterCode = ExtType
	If (@service = 'PROFITS/PROBE') SET @service = 'PROFITS + PROBE'
	--BEGIN Select @ServiceId = ServiceId from [Service] where Name = @service END
	
END

RETURN (@service);

END;