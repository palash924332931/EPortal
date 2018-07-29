
CREATE procedure [SERVICE].[CREATE_CT_LVL8]
as
begin

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_RAW]
select 
	 l8.[GROUP_ID]
    ,l8.[PARENT_ID]
    ,l8.[ROOT_GROUP_ID]
    ,l8.[GROUP_NAME]
    ,l8.[LEVEL_NUMBER]
	,'LVL_'+l8.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l8.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l8.[GROUP_NUMBER]
    ,l8.[TERRITORY_ID]
    ,l8.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l8.[GROUP_NAME] As NODE_NAME
	,obat.Type AS TYPE
	,obat.BrickOutletCode AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	

UNION

select 
	 l7.[GROUP_ID]
    ,l7.[PARENT_ID]
    ,l7.ROOT_GROUP_ID
    ,l7.[GROUP_NAME]
    ,l7.[LEVEL_NUMBER]
	,'LVL_'+l7.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l7.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l7.[GROUP_NUMBER]
    ,l7.[TERRITORY_ID]
    ,l7.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l7.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l7
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'	
		) gl 
		on gl.l7_ID=l7.GROUP_ID
	where l7.LEVEL_NUMBER=7


UNION

select 
	 l6.[GROUP_ID]
    ,l6.[PARENT_ID]
    ,l6.ROOT_GROUP_ID
    ,l6.[GROUP_NAME]
    ,l6.[LEVEL_NUMBER]
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l6.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l6.[GROUP_NUMBER]
    ,l6.[TERRITORY_ID]
    ,l6.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l6.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l6
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l6_ID=l6.GROUP_ID
	where l6.LEVEL_NUMBER=6


UNION

select 
	 l5.[GROUP_ID]
    ,l5.[PARENT_ID]
    ,l5.ROOT_GROUP_ID
    ,l5.[GROUP_NAME]
    ,l5.[LEVEL_NUMBER]
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l5.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l5.[GROUP_NUMBER]
    ,l5.[TERRITORY_ID]
    ,l5.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l5.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l5
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l5_ID=l5.GROUP_ID
	where l5.LEVEL_NUMBER=5

UNION

select 
	 l4.[GROUP_ID]
    ,l4.[PARENT_ID]
    ,l4.ROOT_GROUP_ID
    ,l4.[GROUP_NAME]
    ,l4.[LEVEL_NUMBER]
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l4.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l4.[GROUP_NUMBER]
    ,l4.[TERRITORY_ID]
    ,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l4.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
	from dbo.vw_GroupsLevelWise l4
	inner join
		(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
		) gl 
		on gl.l4_ID=l4.GROUP_ID
	where l4.LEVEL_NUMBER=4

UNION

select 
	 l3.[GROUP_ID]
    ,l3.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l3.[GROUP_NAME]
    ,l3.[LEVEL_NUMBER]
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l3.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l3.[GROUP_NUMBER]
    ,l3.[TERRITORY_ID]
    ,l3.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l3.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l3
inner join
	(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l3_ID=l3.GROUP_ID
where l3.LEVEL_NUMBER=3

UNION

select 
	 l2.[GROUP_ID]
    ,l2.[PARENT_ID]
    ,l1_ID as [ROOT_GROUP_ID]
    ,l2.[GROUP_NAME]
    ,l2.[LEVEL_NUMBER]
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_CD' AS LEVEL_CD
	,'LVL_'+l2.[LEVEL_NUMBER]+'_TERR_NM' AS LEVEL_NM
    ,l2.[GROUP_NUMBER]
    ,l2.[TERRITORY_ID]
    ,l2.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
	,l2.[GROUP_NAME] As NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l2
inner join
	(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l2_ID=l2.GROUP_ID
where l2.LEVEL_NUMBER=2

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
	,l1.[GROUP_NAME] AS NODE_NAME
	,TYPE AS TYPE
	,OUTLET_CODE AS OUTLET_CODE
from dbo.vw_GroupsLevelWise l1
inner join
	(select l8.GROUP_ID l8_ID,l7.GROUP_ID l7_ID,l6.GROUP_ID l6_ID, l5.GROUP_ID l5_ID,l4.GROUP_ID l4_ID,l3.GROUP_ID l3_ID,l2.GROUP_ID l2_ID,l1.GROUP_ID l1_ID,l4.[CUSTOM_GROUP_NUMBER_SPACE] AS NODE_CODE
		,obat.NodeName As NODE_NAME
		,obat.Type AS TYPE
		,obat.BrickOutletCode AS OUTLET_CODE
		from dbo.vw_GroupsLevelWise l8
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l7
	on l8.PARENT_ID=l7.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l6
	on l7.PARENT_ID=l6.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=5) l5
	on l6.PARENT_ID=l5.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=4) l4
	on l5.PARENT_ID=l4.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=3) l3
	on l4.PARENT_ID=l3.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=2) l2
	on l3.PARENT_ID=l2.GROUP_ID
	inner join (SELECT * FROM dbo.vw_GroupsLevelWise WHERE LEVEL_NUMBER=1) l1
	on l2.PARENT_ID=l1.GROUP_ID
	join dbo.OutletBrickAllocations obat
	on l8.CUSTOM_GROUP_NUMBER_SPACE=obat.NodeCode
	and l8.GROUP_NAME=obat.NodeName
	and l8.TERRITORY_ID=obat.TerritoryId
	--where obat.Type='Outlet'
	) gl 
	on gl.l1_ID=l1.GROUP_ID
where l1.LEVEL_NUMBER=1

end




