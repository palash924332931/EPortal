


------------------------------------------------------------------
--EXEC SP_BrickGroupLevelTerritory
--SELECT TOP 100 * FROM dbo.BrickGroupLevelTerritory
CREATE PROCEDURE [SERVICE].[CREATE_TERRITORY_OUTPUT_1]
AS
BEGIN
SET NOCOUNT ON;

	exec [dbo].[SP_LevelTerritory]

	truncate table [SERVICE].[AU9_CLIENT_TERR_TYP]

	insert into [SERVICE].[AU9_CLIENT_TERR_TYP]
	select territoryid [CLIENT_TERR_ID],clientid [CLIENT_ID],1 [CLIENT_TERR_VERS_NBR], 
	[LVL_1_TERR_TYP_NM],[LVL_2_TERR_TYP_NM],[LVL_3_TERR_TYP_NM],
	[LVL_4_TERR_TYP_NM],[LVL_5_TERR_TYP_NM],[LVL_6_TERR_TYP_NM],
	[LVL_7_TERR_TYP_NM],[LVL_8_TERR_TYP_NM],[TERR_LOWEST_LVL_NBR],
	null as [RPTG_LVL_RSTR] from levelterritory

END
        
