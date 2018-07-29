--  PROBE Packs Manufacturer

With cteProbe
 as 
(
  select distinct cm.ClientId,p.Org_Code from [IRP].[Dimension] d
inner Join [IRP].client c
on c.ClientID = d.ClientID
inner Join irp.clientmap cm
on cm.IRPClientNo = c.ClientNo
inner Join irp.items  it
on it.DimensionID = d.DimensionID
inner Join  dbo.DIMProduct_Expanded p
on p.Org_Abbr = it.item
where dimensionName like 'PROBE Packs Manufacturer'
and d.versionTo = 32767
and c.VersionTo = 32767
and it.VersionTo = 32767
and cm.clientID  in(

select id from dbo.clients where id in(
select clientId from irp.clientmap where irpclientid in (

select clientId from irp.dimension where dimensionName = 'PROBE Packs Manufacturer' and versionTo = 32767
and clientId in ( select irpclientId from irp.clientmap))

)

))
MERGE [dbo].ClientMFR as target_table
using cteProbe as source
on target_table.clientID = source.ClientId and target_table.MFRID = source.org_Code
WHEN matched THEN
update 
SET target_table.MFRID = source.org_code
WHEN NOT MATCHED THEN
INSERT   (ClientId, MFRId) 
VALUES (source.ClientId, source.org_code);

-- Capital Chemist
With cteCapital
 as 
(
select cm.ClientId from irp.[OutletLimitedOwnData] Outlet
inner Join irp.ClientMap cm
on Outlet.Client_No = cm.IRPClientNo
)
MERGE [dbo].[ClientRelease] as target_table
using cteCapital as source
on target_table.clientID = source.ClientId
WHEN matched THEN
update 
SET target_table.capitalChemist = 1
WHEN NOT MATCHED THEN
INSERT   (clientId, CapitalChemist) 
VALUES (source.ClientId, 1);


