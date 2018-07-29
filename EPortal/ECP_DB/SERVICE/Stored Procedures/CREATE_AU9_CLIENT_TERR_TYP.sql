﻿
CREATE PROCEDURE [SERVICE].[CREATE_AU9_CLIENT_TERR_TYP]
AS
BEGIN

TRUNCATE TABLE [SERVICE].[AU9_CLIENT_TERR_TYP]

--;WITH CTE
--AS
--	(
--	SELECT TERRITORY_ID,VERSION_NO,MAX_LVL_NO,LEVEL_NAME,'LVL_'+CAST(LEVEL_NUMBER AS VARCHAR)+'_TERR_TYP_NM' LEVEL_NM_COL
--	FROM(
		
--		SELECT
--			a.ID as TERRITORY_ID
--			,b.Name as LEVEL_NAME
--			,b.LevelNumber AS LEVEL_NUMBER
--			,c.MAX_LVL AS MAX_LVL_NO
--			,1 AS VERSION_NO
--		FROM [dbo].[Territories] A
--		INNER JOIN [dbo].[Levels] B
--		ON A.Id=B.TerritoryId
--		INNER JOIN 
--		(
--		SELECT
--			TerritoryId,MAX(LevelNumber) AS MAX_LVL
--		FROM [dbo].[Levels]
--		GROUP BY TerritoryId
--		) C
--		ON a.Id=C.TerritoryId
--		) p
--	)
--INSERT INTO [SERVICE].[AU9_CLIENT_TERR_TYP]
--SELECT 
--	 TERRITORY_ID AS [CLIENT_TERR_ID]
--	,VERSION_NO AS [CLIENT_TERR_VERS_NBR]
--	,[LVL_1_TERR_TYP_NM]
--	,[LVL_2_TERR_TYP_NM]
--	,[LVL_3_TERR_TYP_NM]
--	,[LVL_4_TERR_TYP_NM]
--	,[LVL_5_TERR_TYP_NM]
--	,[LVL_6_TERR_TYP_NM]
--	,[LVL_7_TERR_TYP_NM]
--	,[LVL_8_TERR_TYP_NM]
--	,MAX_LVL_NO AS [TERR_LOWEST_LVL_NBR]
--	,'' AS [RPTG_LVL_RSTR]
--FROM CTE

--PIVOT
--	(
--	MAX (LEVEL_NAME)
--	FOR LEVEL_NM_COL IN
--		([LVL_1_TERR_TYP_NM],[LVL_2_TERR_TYP_NM],[LVL_3_TERR_TYP_NM],[LVL_4_TERR_TYP_NM]
--		,[LVL_5_TERR_TYP_NM],[LVL_6_TERR_TYP_NM],[LVL_7_TERR_TYP_NM],[LVL_8_TERR_TYP_NM]
--		)
--	) AS PVT


;WITH CTE
AS
	(
	SELECT TERRITORY_ID,CLIENT_ID,VERSION_NO,MAX_LVL_NO,LEVEL_NAME,'LVL_'+CAST(LEVEL_NUMBER AS VARCHAR)+'_TERR_TYP_NM' LEVEL_NM_COL
	FROM(
		
		SELECT
			a.ID as TERRITORY_ID
			,a.Client_id as CLIENT_ID
			,b.Name as LEVEL_NAME
			,b.LevelNumber AS LEVEL_NUMBER
			,c.MAX_LVL AS MAX_LVL_NO
			,1 AS VERSION_NO
		FROM [dbo].[Territories] A
		INNER JOIN [dbo].[Levels] B
		ON A.Id=B.TerritoryId
		INNER JOIN 
		(
		SELECT
			TerritoryId,MAX(LevelNumber) AS MAX_LVL
		FROM [dbo].[Levels]
		GROUP BY TerritoryId
		) C
		ON a.Id=C.TerritoryId
		) p
	)

INSERT INTO [SERVICE].[AU9_CLIENT_TERR_TYP]
SELECT 
	 TERRITORY_ID AS [CLIENT_TERR_ID]
	,CLIENT_ID  AS [CLIENT_ID]
	,VERSION_NO AS [CLIENT_TERR_VERS_NBR]
	,[LVL_1_TERR_TYP_NM]
	,[LVL_2_TERR_TYP_NM]
	,[LVL_3_TERR_TYP_NM]
	,[LVL_4_TERR_TYP_NM]
	,[LVL_5_TERR_TYP_NM]
	,[LVL_6_TERR_TYP_NM]
	,[LVL_7_TERR_TYP_NM]
	,[LVL_8_TERR_TYP_NM]
	,MAX_LVL_NO AS [TERR_LOWEST_LVL_NBR]
	,'' AS [RPTG_LVL_RSTR]
FROM CTE

PIVOT
	(
	MAX (LEVEL_NAME)
	FOR LEVEL_NM_COL IN
		([LVL_1_TERR_TYP_NM],[LVL_2_TERR_TYP_NM],[LVL_3_TERR_TYP_NM],[LVL_4_TERR_TYP_NM]
		,[LVL_5_TERR_TYP_NM],[LVL_6_TERR_TYP_NM],[LVL_7_TERR_TYP_NM],[LVL_8_TERR_TYP_NM]
		)
	) AS PVT

END



