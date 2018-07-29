
-- =============================================  
CREATE PROCEDURE [dbo].[RevalidateMarketDefinitionV2]   
 -- Add the parameters for the stored procedure here  
 @MarketBaseId int   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
  
-- get Packs for MB  
CREATE TABLE #MarketBaseWithPack(MarketBaseId nvarchar(20),PFC nvarchar(20) ,FCC nvarchar(Max))  
CREATE TABLE #RemovePacks(MarketBaseId nvarchar(20),PFC nvarchar(20))  
CREATE TABLE #AddPacks(MarketBaseId nvarchar(20),PFC nvarchar(20))  
                                
INSERT #MarketBaseWithPack (MarketBaseId, PFC,FCC)  
   EXEC GetPacksFromMarketBase @MarketBaseId  
  
SELECT * FROM #MarketBaseWithPack  
  
---Update Market Base name in [MarketDefinitionPacks] table  
UPDATE [MarketDefinitionPacks]  
SET MarketBase = (SELECT DISTINCT NAME+' '+Suffix FROM [MarketBases] WHERE ID = @MarketBaseId)  
WHERE MarketBaseId= cast(@MarketBaseId as varchar)  
  
---Update Market Base name in [[MarketDefinitionBaseMaps]] table  
UPDATE [MarketDefinitionBaseMaps]  
SET [Name] = (SELECT DISTINCT NAME+' '+Suffix FROM [MarketBases] WHERE ID = @MarketBaseId)  
WHERE MarketBaseId= cast(@MarketBaseId as varchar) 
  
--Get MarketDef IDs for MBs  
SELECT DISTINCT [MarketDefinitionId],[MarketBaseId]  
INTO #MarketDefinitionDetails  
FROM [dbo].[MarketDefinitionPacks]  
WHERE [MarketBaseId] IN (SELECT MarketBaseId FROM #MarketBaseWithPack)  
  
SELECT * FROM #MarketDefinitionDetails  
  
----Remove Packs from Market Def  
DECLARE @Count int;  
DECLARE @MyCursor CURSOR;  
DECLARE @MyField int;  
BEGIN  
    SET @MyCursor = CURSOR FOR  
    SELECT DISTINCT [MarketDefinitionId] from #MarketDefinitionDetails  
          
  
    OPEN @MyCursor   
    FETCH NEXT FROM @MyCursor   
    INTO @MyField  
  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
 -------------Pack will be removed---------------  
      INSERT INTO #RemovePacks  
   SELECT * FROM   
   (SELECT DISTINCT MarketBaseId,PFC FROM [MarketDefinitionPacks]  
   WHERE [MarketDefinitionId]=@MyField AND [MarketBaseId]=@MarketBaseId  
      EXCEPT  
      SELECT DISTINCT MarketBaseId, PFC FROM #MarketBaseWithPack) A  
  
   ---removing packs from Market Def  
   SELECT 'PACKS REMOVED', * FROM #RemovePacks  
   DELETE FROM [MarketDefinitionPacks]  
   WHERE PFC IN (SELECT DISTINCT PFC FROM #RemovePacks)    
   AND [MarketDefinitionId]=@MyField AND MarketBaseId=@MarketBaseId  
  
   -------------Pack will be added---------------  
   INSERT INTO #AddPacks  
   SELECT * FROM   
   (SELECT DISTINCT MarketBaseId, PFC FROM #MarketBaseWithPack  
    EXCEPT  
    SELECT DISTINCT MarketBaseId,PFC FROM [MarketDefinitionPacks]  
    WHERE [MarketDefinitionId]=@MyField AND [MarketBaseId]=@MarketBaseId) A  
  
    ---add packs into Market Def  
    INSERT INTO [MarketDefinitionPacks]  
    SELECT DISTINCT Pack_Description AS Pack ,   
                    MDBM.[Name]  AS MarketBase,   
                       MDBM.[MarketBaseId]  AS MarketBaseId,  
                       '' AS GroupNumber,   
        '' AS GroupName,   
        '' AS Factor,   
        DIMProduct_Expanded.PFC AS PFC,    
           Org_Long_Name AS Manufacturer,   
        ATC4_Code AS ATC4,   
        NEC4_Code AS NEC4,  
           MDBM.[DataRefreshType]  AS DataRefreshType,   
        '' AS [StateStatus],  
        MDBM.[MarketDefinitionId] AS [MarketDefinitionId],  
        CASE   
       WHEN MDBM.[DataRefreshType] ='dynamic' THEN MDBM.[DataRefreshType]+'-right'  
       ELSE  MDBM.[DataRefreshType]+'-left'  
        END AS [Alignment],  
        ProductName AS Product,  
           'A' AS [ChangeFlag],
		DM.Description Molecule    
   FROM  DIMProduct_Expanded   
      JOIN DMMoleculeConcat DM   
      ON DIMProduct_Expanded.FCC = DM.FCC  
      JOIN #AddPacks  
      ON #AddPacks.PFC = DIMProduct_Expanded.PFC  
      JOIN [MarketDefinitionBaseMaps] MDBM  
      ON #AddPacks.MarketBaseId= CONVERT(nvarchar(Max), MDBM.[MarketBaseId])  
      WHERE MDBM.[MarketDefinitionId]=@MyField  
  
      FETCH NEXT FROM @MyCursor   
      INTO @MyField   
    END;   
  
    CLOSE @MyCursor ;  
    DEALLOCATE @MyCursor;  
END;  
  
--DROP TABLE #MarketBaseWithPack  
--DROP TABLE #RemovePacks  
--DROP TABLE #AddPacks  
  
END  

--exec RevalidateMarketDefinitionV2 552
  --Select * from #MarketBaseWithPack  
  



