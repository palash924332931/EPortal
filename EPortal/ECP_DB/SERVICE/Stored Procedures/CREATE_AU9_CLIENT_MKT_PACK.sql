CREATE PROCEDURE [SERVICE].[CREATE_AU9_CLIENT_MKT_PACK]
AS
BEGIN

TRUNCATE TABLE [SERVICE].[AU9_CLIENT_MKT_PACK]
INSERT INTO [SERVICE].[AU9_CLIENT_MKT_PACK]

SELECT distinct
	 CAST([MarketDefinitionId] AS INT) AS [CLIENT_MKT_ID]
	,max(d.transferid) AS [CLIENT_MKT_VERS_NBR]
	,CAST(B.FCC AS INT) AS [FCC]
    ,CAST([GroupNumber] AS VARCHAR(50)) AS [PACK_GRP_ID]
	--,CASE
	--	WHEN GroupNumber IN ('GR','N',NULL)
	--	THEN 0
	--	ELSE CAST(GroupNumber AS INT)
	-- END AS [PACK_GRP_ID]
    ,CAST([GroupName] AS VARCHAR(MAX)) AS [PACK_GRP_NM]
    ,CAST(ROUND([Factor],2) AS DECIMAL(15,5)) AS [MKT_FCT]
	,C.clientid
    --,A.[PFC] AS PFC
FROM [dbo].[MarketDefPack_History] A
JOIN 
(SELECT DISTINCT [PFC],[FCC] FROM [dbo].[DIMProduct_Expanded]) B ON A.PFC=B.PFC
join MarketDefinitions_History C on C.MarketDefId = A.MarketDefinitionId
join SubmittedDimensionsForReport d on d.DimensionType = 3 and d.DimensionId = c.MarketDefId
where Alignment = 'dynamic-right'
group by d.transferid, d.DimensionId, d.DimensionType, [MarketDefinitionId], B.FCC, [GroupNumber], [Factor], C.clientid, [GroupName]

update [SERVICE].[AU9_CLIENT_MKT_PACK]
set PACK_GRP_ID=null
where PACK_GRP_ID =''

--SELECT 
--	   [CLIENT_MKT_ID]
--      ,[CLIENT_MKT_VERS_NBR]
--      ,[FCC]
--      ,[PACK_GRP_ID]
--      ,[PACK_GRP_NM]
--      ,[MKT_FCT]
--FROM [ECP_TO_TDW].[SERVICE].[AU9_CLIENT_MKT_PACK]

----------OVERALL QC report-------------
	IF OBJECT_ID('dbo.QCTDWWriteback') IS NOT NULL DROP TABLE QCTDWWriteback
	select CLIENT_MKT_ID MarketDefinitionId, count(FCC) [Count], GETDATE() [Time] 
	into QCTDWWriteback 
	from [SERVICE].[AU9_CLIENT_MKT_PACK]
	group by CLIENT_MKT_ID

END

--select * from [SERVICE].[AU9_CLIENT_MKT_PACK]
GO