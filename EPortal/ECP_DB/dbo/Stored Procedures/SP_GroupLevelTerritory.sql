CREATE PROCEDURE [dbo].[SP_GroupLevelTerritory]
	@territoryid int,@CGNS varchar(11)
AS
BEGIN
SET NOCOUNT ON;

declare @levelnameshiearchy table
(
	id int,
	name varchar(15),
	levelno int,
	parentid int,
	nodecode varchar(15),
	territoryid int
);

WITH EntityChildren AS
(
	SELECT gr.id,gr.name,levelno,parentid as parentid,customgroupnumberspace as nodecode,gr.territoryid  FROM groups  gr
	
	WHERE gr.territoryid = @territoryid
	and customgroupnumberspace =  @CGNS
	UNION ALL
	SELECT e.id,e.name,e.levelno,e.parentid,e.customgroupnumberspace as nodecode,e.territoryid FROM groups e INNER JOIN EntityChildren e2 on e.id = e2.parentid
	and e.territoryid = e2.territoryid
)
insert into @levelnameshiearchy
SELECT id,name,levelno,isnull(parentid,1) as parentid,isnull(nodecode,1)as nodecode ,territoryid
from EntityChildren

insert into dbo.GroupLevelTerritory
(territoryid,LVL_1_TERR_CD,LVL_2_TERR_CD,LVL_3_TERR_CD,LVL_4_TERR_CD,LVL_5_TERR_CD,LVL_6_TERR_CD,LVL_7_TERR_CD,LVL_8_TERR_CD,
LVL_1_TERR_NM,LVL_2_TERR_NM,LVL_3_TERR_NM,LVL_4_TERR_NM,LVL_5_TERR_NM,LVL_6_TERR_NM,LVL_7_TERR_NM,LVL_8_TERR_NM,nodecode)
select a.*,b.nodecode
from
(
SELECT 
	territoryid,
	max([1]) as LVL_1_TERR_CD, max([2]) LVL_2_TERR_CD, max([3]) LVL_3_TERR_CD, max([4]) LVL_4_TERR_CD, max([5]) LVL_5_TERR_CD, max([6]) LVL_6_TERR_CD, max([7]) LVL_7_TERR_CD, max([8]) LVL_8_TERR_CD
	,max([9]) as LVL_1_TERR_NM, max([10]) LVL_2_TERR_NM, max([11]) LVL_3_TERR_NM, max([12]) LVL_4_TERR_NM, max([13]) LVL_5_TERR_NM, max([14]) LVL_6_TERR_NM, max([15]) LVL_7_TERR_NM, max([16]) LVL_8_TERR_NM


FROM

(

	select territoryid,levelno, case when col ='nodecode' then 0
	when col = 'name' then 8
	end+levelno new_col,
	value
	from @levelnameshiearchy
	unpivot
	(
		value for col in (nodecode,name)
		   
	)unpiv

    ) AS SourceTable
PIVOT
(
	max(value)
	FOR new_col IN ([1], [2], [3], [4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16])
) AS PivotTable
group by territoryid
)a left outer join 
(
	SELECT distinct customgroupnumberspace as nodecode,territoryid  FROM groups WHERE territoryid = @territoryid
	and customgroupnumberspace =  @CGNS
)
b
on a.territoryid=b.territoryid


END

