﻿

CREATE PROCEDURE [dbo].[GENERATE_DIM_OUTLET]
AS
BEGIN

--update [RAW_TDW-ECP_DIM_OUTLET]-----
--Update Statecode according to Rachel's ref
UPDATE dbo.[RAW_TDW-ECP_DIM_OUTLET]  
SET State_Code = 
( CASE  
WHEN (left(Sbrick,1) = 0) THEN 'NT' 
WHEN (left(Sbrick,1) = 2) THEN 'NSW' 
WHEN (left(Sbrick,1) = 3) THEN 'VIC' 
WHEN (left(Sbrick,1) = 4) THEN 'QLD' 
WHEN (left(Sbrick,1) = 5) THEN 'SA' 
WHEN (left(Sbrick,1) = 6) THEN 'WA' 
WHEN (left(Sbrick,1) = 7) THEN 'TAS' 
ELSE  (State_Code)
END )

--------Update Raw and dimoutlet------------
---BrickIncorrectNullLookup
--RAW Table
update a
set a.retail_sbrick=o.retail_sbrick
,a.retail_sbrick_desc=o.retail_sbrick_desc
from [RAW_TDW-ECP_DIM_OUTLET] a 
join BrickIncorrectNullLookup b
on a.otlt_cd=b.otlt_cd
join irp.OutletMaster o
on b.otlt_cd=o.outl_brk

---------------------------------------------
----BrickIncorrectLookup
--RAW Table
update a
set a.retail_sbrick=b.Sbrick 
,a.retail_sbrick_desc=b.Sbrick_Desc 
from [RAW_TDW-ECP_DIM_OUTLET] a join BrickIncorrectLookup b
on a.otlt_cd=b.otlt_cd 

------------------update rest of duplicate---
update [RAW_TDW-ECP_DIM_OUTLET]
set retail_sbrick=sbrick,
retail_sbrick_desc=sbrick_desc
where sbrick in (select a.sbrick from 
(select distinct sbrick, count(distinct retail_sbrick) rsbricknum from [RAW_TDW-ECP_DIM_OUTLET] 
where sbrick is not null
group by sbrick)A
where a.rsbricknum>1)
and sbrick<>retail_sbrick

-------------------------------------------------------------------------------

declare @count int
select @count=count(*) from [dbo].[RAW_TDW-ECP_DIM_OUTLET]

if @count > 0 
begin
	MERGE [dbo].[DIMOutlet] AS TARGET
	USING [dbo].[RAW_TDW-ECP_DIM_OUTLET] AS SOURCE
	ON (TARGET.[Outl_Brk]=SOURCE.OTLT_CD)

	WHEN MATCHED
	THEN
	UPDATE SET TARGET.CHANGE_FLAG =
		CASE
			WHEN
				LTRIM(RTRIM(TARGET.[Outl_Brk]))	<>	LTRIM(RTRIM(SOURCE.[OTLT_CD]))	OR
				LTRIM(RTRIM(TARGET.[Name]))	<>	LTRIM(RTRIM(SOURCE.[Name]))	OR
				LTRIM(RTRIM(TARGET.[FullAddr]))	<>	LTRIM(RTRIM(SOURCE.[FullAddr]))	OR
				--LTRIM(RTRIM(TARGET.[Addr1]))	<>	LTRIM(RTRIM(SOURCE.[Addr1]))	OR
				--LTRIM(RTRIM(TARGET.[Addr2]))	<>	LTRIM(RTRIM(SOURCE.[Addr2]))	OR
				--LTRIM(RTRIM(TARGET.[Suburb]))	<>	LTRIM(RTRIM(SOURCE.[Suburb]))	OR
				--LTRIM(RTRIM(TARGET.[Phone]))	<>	LTRIM(RTRIM(SOURCE.[Phone]))	OR
				--LTRIM(RTRIM(TARGET.[XCord]))	<>	LTRIM(RTRIM(SOURCE.[XCord]))	OR
				--LTRIM(RTRIM(TARGET.[YCord]))	<>	LTRIM(RTRIM(SOURCE.[YCord]))	OR
				LTRIM(RTRIM(TARGET.[Entity_Type]))	<>	LTRIM(RTRIM(SOURCE.[Entity_Type]))	OR
				--LTRIM(RTRIM(TARGET.[Display]))	<>	LTRIM(RTRIM(SOURCE.[Display]))	OR
				LTRIM(RTRIM(TARGET.[BannerGroup_Desc]))	<>	LTRIM(RTRIM(SOURCE.[BannerGroup_Desc]))	OR
				--LTRIM(RTRIM(TARGET.[Retail_Sbrick_Desc]))	<>	LTRIM(RTRIM(SOURCE.[Retail_Sbrick_Desc]))	OR
				--LTRIM(RTRIM(TARGET.[Sbrick]))	<>	LTRIM(RTRIM(SOURCE.[Sbrick]))	OR
				--LTRIM(RTRIM(TARGET.[Sbrick_Desc]))	<>	LTRIM(RTRIM(SOURCE.[Sbrick_Desc]))	OR
				LTRIM(RTRIM(TARGET.[State_Code]))	<>	LTRIM(RTRIM(SOURCE.[State_Code])) OR
				LTRIM(RTRIM(TARGET.[Outlet]))	<>	LTRIM(RTRIM(SOURCE.[Outlet])) OR
				LTRIM(RTRIM(TARGET.[Out_Type]))	<>	LTRIM(RTRIM(SOURCE.[Out_Type]))	
			THEN 'M'
			ELSE 'U'
		END
		,TARGET.BRICK_CHANGE_FLAG =
		CASE
			WHEN
				--LTRIM(RTRIM(TARGET.[Retail_Sbrick_Desc]))	<>	LTRIM(RTRIM(SOURCE.[Retail_Sbrick_Desc]))	OR
				LTRIM(RTRIM(TARGET.[BannerGroup_Desc]))	<>	LTRIM(RTRIM(SOURCE.[BannerGroup_Desc]))	OR
				LTRIM(RTRIM(TARGET.[State_Code]))	<>	LTRIM(RTRIM(SOURCE.[State_Code])) OR
				LTRIM(RTRIM(TARGET.[Sbrick]))	<>	LTRIM(RTRIM(SOURCE.[Sbrick]))	OR
				LTRIM(RTRIM(TARGET.[Sbrick_Desc]))	<>	LTRIM(RTRIM(SOURCE.[Sbrick_Desc]))
			THEN 'M'
			ELSE 'U'
		END
		,TARGET.[OUTLETID]=SOURCE.OTLT_CD
		,TARGET.[POSTCODE]=SOURCE.[POSTCODE]
		,TARGET.[AID]=SOURCE.[AID]
		,TARGET.[NAME]=SOURCE.[NAME]
		,TARGET.[FULLADDR]=SOURCE.[FULLADDR]
		,TARGET.[ADDR1]=SOURCE.[ADDR1]
		,TARGET.[ADDR2]=SOURCE.[ADDR2]
		,TARGET.[SUBURB]=SOURCE.[SUBURB]
		,TARGET.[PHONE]=SOURCE.[PHONE]
		,TARGET.[XCORD]=SOURCE.[XCORD]
		,TARGET.[YCORD]=SOURCE.[YCORD]
		,TARGET.[ENTITY_TYPE]=SOURCE.[ENTITY_TYPE]
		,TARGET.[DISPLAY]=SOURCE.[DISPLAY]
		,TARGET.[BANNERGROUP_DESC]=SOURCE.[BANNERGROUP_DESC]
		,TARGET.[RETAIL_SBRICK]=SOURCE.[RETAIL_SBRICK]
		,TARGET.[RETAIL_SBRICK_DESC]=SOURCE.[RETAIL_SBRICK_DESC]
		,TARGET.[SBRICK]=SOURCE.[SBRICK]
		,TARGET.[SBRICK_DESC]=SOURCE.[SBRICK_DESC]
		,TARGET.[STATE_CODE]=SOURCE.[STATE_CODE]
		,TARGET.[EID]=SOURCE.[OTLT_LOC_CD] --ADDED 27-08-2017 BY ASHFAQ
		,TARGET.[Outlet]=SOURCE.[Outlet] --ADDED 18/9
		,TARGET.[Outl_Brk]=SOURCE.[OTLT_CD] --ADDED 27-08-2017 BY ASHFAQ
		,TARGET.[OUT_TYPE]=SOURCE.[OUT_TYPE]
		,TARGET.[OUTLET_TYPE_DESC]=SOURCE.[OUTLET_TYPE_DESC]
		,TARGET.[INACTIVE_DATE]=SOURCE.[INACTIVE_DATE]
		,TARGET.[ACTIVE_DATE]=SOURCE.[ACTIVE_DATE]
		,TARGET.[TIME_STAMP]=GETDATE()
		,TARGET.[BRICK_TIME_STAMP]=GETDATE()

	WHEN NOT MATCHED BY TARGET THEN
		INSERT (OUTLETID, POSTCODE, Outl_Brk, EID, AID, NAME, FULLADDR, ADDR1, ADDR2, SUBURB, PHONE,
				XCORD, YCORD, ENTITY_TYPE, DISPLAY,BANNERGROUP_DESC, RETAIL_SBRICK, RETAIL_SBRICK_DESC, SBRICK, SBRICK_DESC,
				STATE_CODE, OUT_TYPE, OUTLET_TYPE_DESC, INACTIVE_DATE, ACTIVE_DATE, CHANGE_FLAG, TIME_STAMP, BRICK_CHANGE_FLAG, [BRICK_TIME_STAMP])

		VALUES(SOURCE.OTLT_CD, SOURCE.POSTCODE, SOURCE.OTLT_CD, SOURCE.OTLT_LOC_CD, SOURCE.AID, SOURCE.NAME, SOURCE.FULLADDR, SOURCE.ADDR1, SOURCE.ADDR2, SOURCE.SUBURB, SOURCE.PHONE, SOURCE.XCORD, SOURCE.YCORD, SOURCE.ENTITY_TYPE,
		 SOURCE.DISPLAY,SOURCE.BANNERGROUP_DESC, SOURCE.RETAIL_SBRICK, SOURCE.RETAIL_SBRICK_DESC, SOURCE.SBRICK, SOURCE.SBRICK_DESC, SOURCE.STATE_CODE,SOURCE.[OUT_TYPE], SOURCE.[OUTLET_TYPE_DESC],
		  SOURCE.INACTIVE_DATE, SOURCE.ACTIVE_DATE,'A',GETDATE(),'U',GETDATE())

	WHEN NOT MATCHED BY SOURCE THEN
		UPDATE SET TARGET.CHANGE_FLAG='D',
		TARGET.[TIME_STAMP]=GETDATE(),
		TARGET.BRICK_CHANGE_FLAG='U',
		TARGET.[BRICK_TIME_STAMP]=GETDATE();
		/*
	/*----SBRICK CHANGE FLAG START-----*/

	MERGE [dbo].[DIMOutlet] AS TARGET
	USING [dbo].[RAW_TDW-ECP_DIM_OUTLET] AS SOURCE
	ON (TARGET.[Sbrick]=SOURCE.[Sbrick])

	WHEN MATCHED
	THEN
	UPDATE SET TARGET.BRICK_CHANGE_FLAG =
		CASE
			WHEN
				LTRIM(RTRIM(TARGET.[Retail_Sbrick_Desc]))	<>	LTRIM(RTRIM(SOURCE.[Retail_Sbrick_Desc]))	OR
				LTRIM(RTRIM(TARGET.[Sbrick]))	<>	LTRIM(RTRIM(SOURCE.[Sbrick]))	OR
				LTRIM(RTRIM(TARGET.[Sbrick_Desc]))	<>	LTRIM(RTRIM(SOURCE.[Sbrick_Desc]))
			THEN 'M'
			ELSE 'U'
		END
		,TARGET.[BRICK_TIME_STAMP]=GETDATE()

	WHEN NOT MATCHED BY TARGET THEN
		INSERT (BRICK_CHANGE_FLAG, BRICK_TIME_STAMP)

		VALUES('A',GETDATE())

	WHEN NOT MATCHED BY SOURCE THEN
		UPDATE SET TARGET.[BRICK_CHANGE_FLAG]='D',
		TARGET.[BRICK_TIME_STAMP]=GETDATE();

		/*----SBRICK CHANGE FLAG END-----*/
		*/

	INSERT INTO  [dbo].[HISTORY_TDW-ECP_DIM_OUTLET] 
	SELECT *

	FROM [dbo].[DIMOutlet]
	WHERE CHANGE_FLAG<>'U' AND BRICK_CHANGE_FLAG<>'U'

	UPDATE A SET A.TIME_STAMP=B.TIME_STAMP,A.BRICK_TIME_STAMP=B.BRICK_TIME_STAMP FROM [dbo].[DIMOutlet] A
	INNER JOIN (
	SELECT
		 [OUTLETID]
		,[POSTCODE]
		,[Outlet]
		,[Outl_Brk]
		,[EID]
		,[AID]
		,[NAME]
		,[FULLADDR]
		,[ADDR1]
		,[ADDR2]
		,[SUBURB]
		,[PHONE]
		,[XCORD]
		,[YCORD]
		,[ENTITY_TYPE]
		,[DISPLAY]
		,[BANNERGROUP_DESC]
		,[RETAIL_SBRICK]
		,[RETAIL_SBRICK_DESC]
		,[SBRICK]
		,[SBRICK_DESC]
		,[STATE_CODE]
		,[OUT_TYPE]
		,[OUTLET_TYPE_DESC]
		,[INACTIVE_DATE]
		,[ACTIVE_DATE]
		,[CHANGE_FLAG],
		MIN(TIME_STAMP)AS TIME_STAMP
		,[BRICK_CHANGE_FLAG],
		MIN(BRICK_TIME_STAMP)AS BRICK_TIME_STAMP
	FROM [dbo].[HISTORY_TDW-ECP_DIM_OUTLET]
	WHERE CHANGE_FLAG='D'  AND BRICK_CHANGE_FLAG='D'
	GROUP BY [OUTLETID]
		,[POSTCODE]
		,[Outlet]
		,[Outl_Brk]
		,[EID]
		,[AID]
		,[NAME]
		,[FULLADDR]
		,[ADDR1]
		,[ADDR2]
		,[SUBURB]
		,[PHONE]
		,[XCORD]
		,[YCORD]
		,[ENTITY_TYPE]
		,[DISPLAY]
		,BANNERGROUP_DESC
		,[RETAIL_SBRICK]
		,[RETAIL_SBRICK_DESC]
		,[SBRICK]
		,[SBRICK_DESC]
		,[STATE_CODE]
		,[OUT_TYPE]
		,[OUTLET_TYPE_DESC]
		,[INACTIVE_DATE]
		,[ACTIVE_DATE]
		,[CHANGE_FLAG]
		,[BRICK_CHANGE_FLAG]) B
	ON A.[OUTLETID]=B.[OUTLETID]
	WHERE A.CHANGE_FLAG='D' AND B.CHANGE_FLAG='D'
	AND A.BRICK_CHANGE_FLAG='D' AND B.BRICK_CHANGE_FLAG='D'

	;With CTE
	AS
	(
	SELECT *,ROW_NUMBER ()OVER(PARTITION BY [OUTLETID] ORDER BY [OUTLETID], TIME_STAMP ASC) Cnt 
	FROM [dbo].[HISTORY_TDW-ECP_DIM_OUTLET] WHERE  CHANGE_FLAG='D'
	)
	DELETE FROM CTE WHERE Cnt>1


	;With CTE
	AS
	(
	SELECT *,ROW_NUMBER ()OVER(PARTITION BY [SBRICK] ORDER BY [SBRICK], BRICK_TIME_STAMP ASC) Cnt 
	FROM [dbo].[HISTORY_TDW-ECP_DIM_OUTLET] WHERE  BRICK_CHANGE_FLAG='D'
	)
	DELETE FROM CTE WHERE Cnt>1 --AND BRICK_CHANGE_FLAG IS NULL AND BRICK_TIME_STAMP IS NULL
end


END




