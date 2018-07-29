--update IRP dimension from preprod

select d.DimensionID, d.DimensionName, d1.DimensionID, d1.DimensionName
from irp.Dimension d
join preprod.irp.dimension d1 on d.dimensionid = d1.dimensionid
where d.dimensionname <> d1.dimensionname
and d.VersionTo = 32767
and d1.VersionTo = 32767

begin tran

update irp.Dimension
set irp.Dimension.DimensionName = d1.dimensionname
from irp.Dimension d
join preprod.irp.dimension d1 on d.dimensionid = d1.dimensionid
where d.dimensionname <> d1.dimensionname
and d.VersionTo = 32767
and d1.VersionTo = 32767


rollback


--update territories

select d.DimensionID, d.DimensionName, t.id , t.name, c.Name
from Territories t
join preprod.irp.Dimension d on d.dimensionid = t.dimensionid
join clients c on c.id = t.Client_id
where d.dimensionname <> t.name
and d.VersionTo = 32767

begin tran
update Territories
set Territories.name = d.dimensionname
from Territories t
join irp.Dimension d on d.dimensionid = t.dimensionid
join clients c on c.id = t.Client_id
where d.dimensionname <> t.name
and d.VersionTo = 32767
rollback


select d.DimensionID, d.DimensionName, m.id , m.name, c.Name
from MarketDefinitions m
join preprod.irp.Dimension d on d.dimensionid = m.dimensionid
join clients c on c.id = m.ClientId
where d.dimensionname <> m.name
and d.VersionTo = 32767

begin tran
update MarketDefinitions
set MarketDefinitions.name = d.dimensionname
from MarketDefinitions m
join irp.Dimension d on d.dimensionid = m.dimensionid
join clients c on c.id = m.ClientId
where d.dimensionname <> m.name
and d.VersionTo = 32767
rollback
