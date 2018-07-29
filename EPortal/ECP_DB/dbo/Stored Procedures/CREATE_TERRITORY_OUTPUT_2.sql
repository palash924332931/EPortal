


------------------------------------------------------------------
--EXEC SP_BrickGroupLevelTerritory
--SELECT TOP 100 * FROM dbo.BrickGroupLevelTerritory
CREATE PROCEDURE [dbo].[CREATE_TERRITORY_OUTPUT_2]
AS
BEGIN
SET NOCOUNT ON;

	exec [SP_BrickGroupLevelTerritory]

	truncate table [SERVICE].[AU9_CLIENT_TERR]

	insert into [SERVICE].[AU9_CLIENT_TERR]
	SELECT distinct [territoryid] [CLIENT_TERR_ID], 1 [CLIENT_TERR_VERS_NBR], [BrickOutletCode]
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