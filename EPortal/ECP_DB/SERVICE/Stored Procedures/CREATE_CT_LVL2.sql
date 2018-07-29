
CREATE procedure [SERVICE].[CREATE_CT_LVL2]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l2.[ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
on l2.PARENT_ID=l1.GROUP_ID
join dbo.OutletBrickAllocations obat
on l2.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
and l2.GROUP_NAME=obat.NodeName
and l2.TERRITORY_ID=obat.TerritoryId
--where obat.Type='Outlet'	

UNION ----L1

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
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,obat.NodeName As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from  dbo.vw_GroupsLevelWise l2
		inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
		on l2.PARENT_ID=l1.GROUP_ID
		join dbo.OutletBrickAllocations obat
		on l2.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
		and l2.GROUP_NAME=obat.NodeName
		and l2.TERRITORY_ID=obat.TerritoryId
		--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1

end




