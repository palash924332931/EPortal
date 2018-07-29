CREATE PROCEDURE [dbo].[SP_LevelTerritory]
	
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


