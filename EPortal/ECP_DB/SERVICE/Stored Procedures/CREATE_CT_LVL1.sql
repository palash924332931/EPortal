
CREATE procedure [SERVICE].[CREATE_CT_LVL1]
as
begin
insert into [SERVICE].[AU9_CLIENT_TERR_RAW]
select 
	 l1.[GROUP_ID]
    ,l1.[PARENT_ID]
    ,l1.[ROOT_GROUP_ID]
    ,l1.[GROUP_NAME]
    ,l1.[LEVEL_NUMBER]
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l1.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l1.[GROUP_NUMBER]
    ,l1.[TERRITORY_ID]
    ,l1.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l1.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1 
join OutletBrickAllocations obat
on l1.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
and l1.GROUP_NAME=obat.NodeName
and l1.TERRITORY_ID=obat.TerritoryId
where  l1.LEVEL_NUMBER=1

--and obat.Type='Outlet' 

end




