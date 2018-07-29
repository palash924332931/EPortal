

CREATE PROCEDURE [dbo].[IRPImportMarketQC] 
		 
AS
BEGIN
	SET NOCOUNT ON;

	declare @dimensionId int

	truncate table IRPQCMarketExcludedPacks
	---------IRP Items count for market definitions-----------

	select distinct a.dimensionid,count(a.itemid)as ItemCount,b.DimensionName,d.id as clientid,d.name as clientname into #source from irp.items a
	left join irp.dimension b on a.dimensionid=b.dimensionid
	left join irp.clientmap c on b.clientid=c.irpclientid
	left join clients d on c.clientid=d.id
	where b.baseid=4 and a.levelno=3 and b.versionto>0 and a.versionto > 0
	and a.dimensionid in (select distinct dimensionid from marketdefinitions)
	--AND a.DIMENSIONID = 2237
	group by a.dimensionid,b.DimensionName,d.id,d.name
	order by a.dimensionid 

	--select * from #source order by dimensionid

	----------ECP Items count after import----------------------
	select distinct b.dimensionid, count(distinct a.PFC)ItemCount, a.marketdefinitionid,b.clientid
	into #dest 
	 from marketdefinitionpacks a
	join marketdefinitions b on a.marketdefinitionid=b.id join irp.dimension c on c.dimensionid=b.dimensionid 
	join irp.items i on i.dimensionid= c.dimensionid and i.levelno=c.levels
	join marketbases m on a.marketbaseid=m.id
	--join dimproduct_expanded e on i.item=e.fcc
	where c.versionto>0 and 
	c.baseid=4 and 
	alignment='dynamic-right'
	AND c.DIMENSIONID in (select distinct dimensionid from marketdefinitions)
	and a.marketbaseid not like('%,%')
	group by a.marketdefinitionid,b.dimensionid,b.clientid
	--,m.name,m.suffix
	--order by b.dimensionid 

----------------Insert excluded packs in qc table--------------------------------

	insert into IRPQCMarketExcludedPacks

	select a.*
	,b.pack_description as Pack_Description
	from (
	select a.item as fcc, a.dimensionid 
	from irp.items a 
	join marketdefinitions b on a.dimensionid=b.dimensionid
	 where a.levelno=3
	and a.versionto>0
	and b.id in (select distinct marketdefinitionid from marketdefinitionpacks)
	--order by a.dimensionid,a.itemid

	except

	select c.fcc, b.dimensionid from marketdefinitionpacks a
	join marketdefinitions b on a.marketdefinitionid=b.id
	join dimproduct_expanded c on a.pfc=c.pfc
	where a.alignment='dynamic-right')A
	--join dimproduct_expanded b
	join  excluded_dimproduct_expanded B
	on a.fcc=b.fcc


	select distinct dimensionid, count(distinct fcc) ItemCount into #exPacks from IRPQCMarketExcludedPacks
	group by dimensionid

-----Final report import count-------------------------------------------- 

select a.ClientId,a.ClientName,
a.Dimensionid as IRPDimensionID, a.DimensionName,
t.name as MarketBaseName,b.MarketDefinitionId, isnull(a.Itemcount,0) as IRPItemCount, 
isnull(b.Itemcount,0) as ECPItemCount
, isnull(c.Itemcount,0) as ExcludedPackCount
, isnull(b.Itemcount,0)+isnull(c.Itemcount,0) as TotalItemCount,a.Itemcount-(isnull(b.Itemcount,0)+isnull(c.Itemcount,0)) as [Difference]
from #source a 
left join #dest b on a.dimensionid=b.dimensionid 
left join #exPacks c on a.dimensionid=c.dimensionid
left join marketdefinitionbasemaps t on t.marketdefinitionid=b.marketdefinitionid
--where a.dimensionid=3863
order by a.dimensionid,b.marketdefinitionid

----------Final report Group---------------

----------------IRP------------------
select a.dimensionid,a.marketdefinitionid,count(distinct fcc) as GroupNameCountIRP
into #g1 
from (select  DISTINCT p.dimensionid,m.id as marketdefinitionid,
    CASE WHEN TRY_CONVERT(int, p.item) IS not NULL 
    THEN p.item
    ELSE null  
    END AS FCC,
	   d.pfc,
       p.Name,
       case Charindex(';', g.shortname)
       when 0 then null
       when 1 then null
       else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
       end as groupname,
       case Charindex(';', g.shortname)
       when 0 then null
       when LEN(g.shortname) then null
       else Substring(g.shortname, Charindex(';', g.shortname)+8, LEN(g.shortname))
       end as factor,
       g.number [groupno]
       from irp.items g
       join irp.items p
       on g.itemid = p.parent
       join marketdefinitions m 
       on p.dimensionid=m.dimensionid
       join dimproduct_expanded d on d.fcc=p.item
       where g.dimensionid 
       in (select distinct dimensionid from marketdefinitions where id in
       (select distinct marketdefinitionid from marketdefinitionpacks))
       and p.itemtype = 1
       and p.versionto > 0
       and g.versionto > 0
       and TRY_CONVERT(int, p.item) IS not NULL 
	   and g.shortname is not null)a
	   group by a.dimensionid,a.marketdefinitionid
	   

-------ECP--------------------------------------------------
	   select distinct marketdefinitionid,count(distinct pfc) GroupNameCountECP into #g2 from marketdefinitionpacks 
	   where groupname not like '' 
	   group by marketdefinitionid

	   select a.*,isnull(b.GroupNameCountECP,0) GroupNameCountECP ,a.groupnamecountIRP-isnull(b.GroupNameCountECP,0) as [Difference]
	   from #g1 a left join #g2 b on a.marketdefinitionid=b.marketdefinitionid order by a.dimensionid

END


--use preprod
--exec [dbo].[IRPImportMarketQC]

--drop table #source
--drop table #dest
--drop table #exPacks

--select * from IRPQCMarketExcludedPacks

