

Create table dbo.LevelTerritory
(	TERRITORYID int, clientid int,
	LVL_1_TERR_TYP_NM varchar(15),
	LVL_2_TERR_TYP_NM varchar(15),
	LVL_3_TERR_TYP_NM varchar(15),
	LVL_4_TERR_TYP_NM varchar(15),
	LVL_5_TERR_TYP_NM varchar(15),
	LVL_6_TERR_TYP_NM varchar(15),
	LVL_7_TERR_TYP_NM varchar(15),
	LVL_8_TERR_TYP_NM varchar(15),
	TERR_LOWEST_LVL_NBR  int
)
GO
--select distinct territoryid,customgroupnumberspace as cnt from groups
--where territoryid = 1653
--group by territoryid
--order by cnt
--EXEC SP_LevelTerritory
--SELECT * FROM dbo.LevelTerritory
create PROCEDURE [dbo].[SP_LevelTerritory]
	
AS
BEGIN
SET NOCOUNT ON;
TRUNCATE TABLE dbo.LevelTerritory

INSERT INTO dbo.LevelTerritory
SELECT A.*,B.CNT AS TERR_LOWEST_LVL_NBR
FROM
(
	SELECT Territoryid,clientid, [1] as LVL_1_TERR_TYP_NM,[2] as LVL_2_TERR_TYP_NM,[3] as LVL_3_TERR_TYP_NM,[4] as LVL_4_TERR_TYP_NM,[5] as LVL_5_TERR_TYP_NM
	,[6] as LVL_6_TERR_TYP_NM,[7] as LVL_7_TERR_TYP_NM,[8] as LVL_8_TERR_TYP_NM
	FROM 
	(SELECT Territoryid,client_id clientid, a.Name,LevelNumber from levels a join territories b on a.territoryid = b.id) p
	PIVOT
	(
	max(name)
	FOR levelNumber IN
	( [1],[2],[3],[4],[5],[6],[7],[8])
	) AS pvt

)A LEFT OUTER JOIN (
					select territoryid,count(*) as cnt from levels
					group by territoryid
					) B ON A.TERRITORYID=B.TERRITORYID

END
----------------
GO

CREATE TABLE [dbo].[BrickGroupLevelTerritory](
	[territoryid] [int] NULL,
	[lvl_1_terr_cd] [varchar](15) NULL,
	[LVL_2_TERR_CD] [varchar](15) NULL,
	[LVL_3_TERR_CD] [varchar](15) NULL,
	[LVL_4_TERR_CD] [varchar](15) NULL,
	[LVL_5_TERR_CD] [varchar](15) NULL,
	[LVL_6_TERR_CD] [varchar](15) NULL,
	[LVL_7_TERR_CD] [varchar](15) NULL,
	[LVL_8_TERR_CD] [varchar](15) NULL,

	[LVL_1_TERR_NM] [varchar](15) NULL,
	[LVL_2_TERR_NM] [varchar](15) NULL,
	[LVL_3_TERR_NM] [varchar](15) NULL,
	[LVL_4_TERR_NM] [varchar](15) NULL,
	[LVL_5_TERR_NM] [varchar](15) NULL,
	[LVL_6_TERR_NM] [varchar](15) NULL,
	[LVL_7_TERR_NM] [varchar](15) NULL,
	[LVL_8_TERR_NM] [varchar](15) NULL,

	[BrickOutletCode] [varchar](10) NULL,
	[BrickOutletName] [varchar](30) NULL,
	[nodecode] [varchar](15) NULL
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[GroupLevelTerritory](
	[territoryid] [int] NULL,
	[lvl_1_terr_cd] [varchar](15) NULL,
	[LVL_2_TERR_CD] [varchar](15) NULL,
	[LVL_3_TERR_CD] [varchar](15) NULL,
	[LVL_4_TERR_CD] [varchar](15) NULL,
	[LVL_5_TERR_CD] [varchar](15) NULL,
	[LVL_6_TERR_CD] [varchar](15) NULL,
	[LVL_7_TERR_CD] [varchar](15) NULL,
	[LVL_8_TERR_CD] [varchar](15) NULL,

	[LVL_1_TERR_NM] [varchar](15) NULL,
	[LVL_2_TERR_NM] [varchar](15) NULL,
	[LVL_3_TERR_NM] [varchar](15) NULL,
	[LVL_4_TERR_NM] [varchar](15) NULL,
	[LVL_5_TERR_NM] [varchar](15) NULL,
	[LVL_6_TERR_NM] [varchar](15) NULL,
	[LVL_7_TERR_NM] [varchar](15) NULL,
	[LVL_8_TERR_NM] [varchar](15) NULL,

	[BrickOutletCode] [varchar](10) NULL,
	[BrickOutletName] [varchar](30) NULL,
	[nodecode] [varchar](15) NULL
) ON [PRIMARY]

GO



------------------------------------------------------------------
--EXEC SP_BrickGroupLevelTerritory
--SELECT TOP 100 * FROM dbo.BrickGroupLevelTerritory
create PROCEDURE [dbo].[SP_BrickGroupLevelTerritory]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @territoryId int,
			@nodecode varchar(15)
	TRUNCATE TABLE dbo.GroupLevelTerritory
	TRUNCATE TABLE dbo.BrickGroupLevelTerritory

	DECLARE vendor_cursor CURSOR FOR   
		select distinct nodecode,territoryid from dbo.OutletBrickAllocations
		order by territoryid
	

	OPEN vendor_cursor  

	FETCH NEXT FROM vendor_cursor   
	INTO @nodecode, @territoryId  

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		EXEC [dbo].[SP_GroupLevelTerritory] @territoryId,@nodecode
		FETCH NEXT FROM vendor_cursor   
		INTO @nodecode, @territoryId
	END   
	CLOSE vendor_cursor;  
	DEALLOCATE vendor_cursor;
	 
-- Cursor Ends

	insert into dbo.BrickGroupLevelTerritory
	(territoryid,nodecode,BrickOutletCode,BrickOutletName)
	select territoryid,NodeCode,BrickOutletCode,BrickOutletName
	from dbo.OutletBrickAllocations
--Brick level data insertion ends

	update u
	set u.LVL_1_TERR_CD = s.LVL_1_TERR_CD,
	u.LVL_2_TERR_CD = s.LVL_2_TERR_CD,
	u.LVL_3_TERR_CD=s.LVL_3_TERR_CD,
	u.LVL_4_TERR_CD =s.LVL_4_TERR_CD,
	u.LVL_5_TERR_CD = s.LVL_5_TERR_CD,
	u.LVL_6_TERR_CD = s.LVL_6_TERR_CD,
	u.LVL_7_TERR_CD = s.LVL_7_TERR_CD,
	u.LVL_8_TERR_CD = s.LVL_8_TERR_CD,

	u.LVL_1_TERR_NM =s.LVL_1_TERR_NM,
	u.LVL_2_TERR_NM =s.LVL_2_TERR_NM,
	u.LVL_3_TERR_NM =s.LVL_3_TERR_NM,
	u.LVL_4_TERR_NM =s.LVL_4_TERR_NM,
	u.LVL_5_TERR_NM =s.LVL_5_TERR_NM,
	u.LVL_6_TERR_NM =s.LVL_6_TERR_NM,
	u.LVL_7_TERR_NM =s.LVL_7_TERR_NM,
	u.LVL_8_TERR_NM =s.LVL_8_TERR_NM

	from dbo.BrickGroupLevelTerritory u
		left outer join dbo.GroupLevelTerritory s on
			u.territoryid = s.territoryid
			and u.nodecode = s.nodecode

--All brick level root path update done
END
        
GO     
--------------------------------------------------------------------

create PROCEDURE [dbo].[SP_GroupLevelTerritory]
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

GO

CREATE PROCEDURE [SERVICE].[CREATE_TERRITORY_OUTPUT]
AS
BEGIN

	exec [dbo].[SP_LevelTerritory]
	exec [SP_BrickGroupLevelTerritory]


	truncate table [SERVICE].[AU9_CLIENT_TERR_TYP]

	insert into [SERVICE].[AU9_CLIENT_TERR_TYP]
	select territoryid [CLIENT_TERR_ID],clientid [CLIENT_ID],1 [CLIENT_TERR_VERS_NBR], 
	[LVL_1_TERR_TYP_NM],[LVL_2_TERR_TYP_NM],[LVL_3_TERR_TYP_NM],
	[LVL_4_TERR_TYP_NM],[LVL_5_TERR_TYP_NM],[LVL_6_TERR_TYP_NM],
	[LVL_7_TERR_TYP_NM],[LVL_8_TERR_TYP_NM],[TERR_LOWEST_LVL_NBR],
	null as [RPTG_LVL_RSTR] from levelterritory

	truncate table [SERVICE].[AU9_CLIENT_TERR]

	insert into [SERVICE].[AU9_CLIENT_TERR]
	SELECT DISTINCT [territoryid] [CLIENT_TERR_ID], 1 [CLIENT_TERR_VERS_NBR], [BrickOutletCode]
		  ,[lvl_1_terr_cd]
		  ,[LVL_2_TERR_CD]
		  ,[LVL_3_TERR_CD]
		  ,[LVL_4_TERR_CD]
		  ,[LVL_5_TERR_CD]
		  ,[LVL_6_TERR_CD]
		  ,[LVL_7_TERR_CD]
		  ,[LVL_8_TERR_CD]

		  ,[LVL_1_TERR_NM]
		  ,[LVL_2_TERR_NM]
		  ,[LVL_3_TERR_NM]
		  ,[LVL_4_TERR_NM]
		  ,[LVL_5_TERR_NM]
		  ,[LVL_6_TERR_NM]
		  ,[LVL_7_TERR_NM]
		  ,[LVL_8_TERR_NM]
	FROM [dbo].[BrickGroupLevelTerritory]


END






--select * from  [dbo].[BrickGroupLevelTerritory]
--select * from levelterritory

--truncate table [SERVICE].[AU9_CLIENT_TERR_TYP]
--insert into [SERVICE].[AU9_CLIENT_TERR_TYP]

--exec [dbo].[SP_LevelTerritory]
--exec [SP_BrickGroupLevelTerritory]
--select * from  [dbo].[BrickGroupLevelTerritory]

--insert into [SERVICE].[AU9_CLIENT_TERR_TYP]
--select territoryid [CLIENT_TERR_ID],clientid [CLIENT_ID],1 [CLIENT_TERR_VERS_NBR], 
--[LVL_1_TERR_TYP_NM],[LVL_2_TERR_TYP_NM],[LVL_3_TERR_TYP_NM],
--[LVL_4_TERR_TYP_NM],[LVL_5_TERR_TYP_NM],[LVL_6_TERR_TYP_NM],
--[LVL_7_TERR_TYP_NM],[LVL_8_TERR_TYP_NM],[TERR_LOWEST_LVL_NBR],
--null as [RPTG_LVL_RSTR] from levelterritory



