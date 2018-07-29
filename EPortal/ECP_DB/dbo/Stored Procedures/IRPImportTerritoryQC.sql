

CREATE PROCEDURE [dbo].[IRPImportTerritoryQC] 
		 
AS
BEGIN
	SET NOCOUNT ON;

	--------------Territory check---------------------
	---ECP--------------------------------------------
	select distinct A.territoryid,t.DimensionId,t.name,A.ItemNum,'N' as IsRef into #source
	from (select distinct o.territoryid, count(distinct o.brickOutletcode) as ItemNum from outletbrickallocations o
	group by o.territoryid)A
	join territories t on A.territoryid=t.id
	where t.id=t.dimensionid
	order by dimensionid 

	---IRG---------------------------------------------
	--drop table #t
	select distinct dimensionid,max(levelno) as maxlevel into #t from irp.items
	where dimensionid in (select distinct dimensionid from territories) and versionto>0
	group by dimensionid

	select distinct t.dimensionid, count(i.item)as IRPItems into #dest from irp.items i
	join #t t on i.dimensionid=t.dimensionid and i.levelno=t.maxlevel
	where i.dimensionid in (select distinct dimensionid from territories)
	and i.versionto=32767 
	group by t.dimensionid
	order by t.dimensionid

	---Reference territory---------------------------------------------

	---ECP-----------------------------------
	insert into #source
	select distinct A.territoryid,t.DimensionId,t.name,A.ItemNum, 'Y' as IsRef
	from (select distinct o.territoryid, count(distinct o.brickOutletcode) as ItemNum from outletbrickallocations o
	group by o.territoryid)A
	join territories t on A.territoryid=t.id
	where t.id<>t.dimensionid
	and t.Guiid is null
	order by dimensionid 

	---IRG------------------------------------

	--drop table #p
	select distinct dimensionid,max(levelno) as maxlevel into #p from irp.items
	where dimensionid in (select distinct dimensionid from territories where id=dimensionid) and versionto>0
	group by dimensionid

	insert into #dest
	select D.dimensionid,A.IRPItems from (select distinct t.dimensionid, count(i.item)as IRPItems from irp.items i
	join #p t on i.dimensionid=t.dimensionid and i.levelno=t.maxlevel
	where i.dimensionid in (select distinct dimensionid from territories)
	and i.versionto=32767 
	group by t.dimensionid
	)A join irp.dimension d on A.dimensionid=d.refdimensionid
	where d.dimensionid in (select distinct dimensionid from territories where id<>dimensionid)
	order by d.dimensionid

--Final Report:
select  distinct a.territoryid,b.dimensionid as DimensionID,a.Name,a.IsRef, b.IRPItems as IRPItemCount, a.ItemNum as ECPItemCount, isnull(b.IRPItems,0)-isnull(a.ItemNum,0) as ItemDifference
from #source a left join #dest b on a.dimensionid=b.dimensionid 
order by b.dimensionid


--AD LD SRA Suffix check
--drop table #SRA
select a.id as TerritoryId,a.DimensionId, a.Name,b.SRAClient as IRP_SRA_Client,a.SRA_Client as ECP_SRA_Client,
b.SRASuffix as IRP_SRASuffix,a.SRA_Suffix as ECP_SRASuffix, b.AD as IRP_AD,a.AD as ECP_AD,b.LD as IRP_LD,a.LD as ECP_LD  
into #SRA 
from territories a
join [IRP].[GeographyDimOptions] b
on a.dimensionid=b.dimensionid
where b.versionto>0
and a.guiid is null and a.dimensionid is not null


----Not matched SRA/Suffix/AD/LD Report
select TerritoryId,DimensionId, Name,IRP_SRA_Client,ECP_SRA_Client,IRP_SRASuffix,ECP_SRASuffix,IRP_AD,ECP_AD,IRP_LD,ECP_LD,'Not Matched' as CheckInfo
from #SRA
where 
isnull(IRP_SRA_Client,'')<>isnull(ECP_SRA_Client,'')
OR isnull(IRP_SRASuffix,'')<>isnull(ECP_SRASuffix,'')
OR isnull(IRP_AD,'')<>isnull(ECP_AD,'')
OR isnull(IRP_LD,'')<>isnull(ECP_LD,'')


--select * from [IRP].[GeographyDimOptions]
----count of territory per client-------

select distinct Clientid, count(distinct dimensionid) TerrCount into #t1 from 
irp.dimension where clientid in (select distinct irpclientid from irp.clientmap)
and baseid in (1,2,11,12) and versionto>0
group by clientid

select distinct client_id, count(distinct id) as TerrCount into #t2 from
territories where GuiId is null and dimensionid is not null
group by client_id

--count report
select a.clientid,d.name as ClientName,a.TerrCount as IRPTerrCount,b.TerrCount as ECPTerrCount,a.TerrCount-b.TerrCount as [Difference]
from #t1 a left join irp.clientmap c on a.clientid=c.irpclientid
left join #t2 b on c.clientid=b.client_id
join clients d on d.id=b.client_id
order by a.clientid


END


--exec [dbo].[IRPImportTerritoryQC]

--drop table #source
--drop table #dest
--drop table #exPacks



