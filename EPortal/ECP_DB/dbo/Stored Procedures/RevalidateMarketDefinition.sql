  
  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[RevalidateMarketDefinition]   
 -- Add the parameters for the stored procedure here  
 @MarketBaseId int   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
  
-- get Packs for MB  
CREATE TABLE #MarketBaseWithPack(MarketBaseId nvarchar(Max),PFC nvarchar(Max) ,FCC nvarchar(Max))  
CREATE TABLE #RemovePacks(Id int, MarketBaseId nvarchar(Max),PFC nvarchar(Max))  
CREATE TABLE #AddPacks(MarketBaseId nvarchar(Max),PFC nvarchar(Max))  
                                
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
WHERE [MarketBaseId] COLLATE DATABASE_DEFAULT IN (SELECT distinct MarketBaseId COLLATE DATABASE_DEFAULT FROM #MarketBaseWithPack )  
  
SELECT * FROM #MarketDefinitionDetails  
 
 
 --IGNORING ALL COMMA ENTRIES in MARKETDEFINITIONPACKS
IF OBJECT_ID(N'tempdb..#nonCommaMarketDefinitionPacks') IS NOT NULL drop table #nonCommaMarketDefinitionPacks
select distinct id, marketdefinitionid, marketbaseid, PFC into #nonCommaMarketDefinitionPacks from marketdefinitionpacks where marketbaseid not like '%,%'
 
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
   truncate table #RemovePacks  
   INSERT INTO #RemovePacks  
   SELECT B.id, A.* FROM   
   (SELECT DISTINCT MarketBaseId COLLATE DATABASE_DEFAULT MarketBaseId,PFC COLLATE DATABASE_DEFAULT PFC FROM #nonCommaMarketDefinitionPacks  
   WHERE [MarketDefinitionId]=@MyField AND [MarketBaseId]=@MarketBaseId  
      EXCEPT  
      SELECT DISTINCT MarketBaseId COLLATE DATABASE_DEFAULT MarketBaseId, PFC COLLATE DATABASE_DEFAULT PFC FROM #MarketBaseWithPack) A
	join   #nonCommaMarketDefinitionPacks B on A.MarketBaseId = B.MarketBaseId and A.PFC = B.PFC
  
   ---removing packs from Market Def  

   SELECT 'PACKS REMOVED', * FROM #RemovePacks  
   --DELETE FROM [MarketDefinitionPacks]  
   --WHERE PFC COLLATE DATABASE_DEFAULT IN (SELECT DISTINCT PFC COLLATE DATABASE_DEFAULT FROM #RemovePacks)    
   --AND [MarketDefinitionId]=@MyField AND MarketBaseId=@MarketBaseId  

   DELETE FROM MarketDefinitionPacks WHERE id in (select ID from #RemovePacks)	
	  
   -------------Pack will be added---------------  
   truncate table #AddPacks  
   INSERT INTO #AddPacks  
   SELECT * FROM   
   (SELECT DISTINCT MarketBaseId COLLATE DATABASE_DEFAULT MarketBaseId, PFC COLLATE DATABASE_DEFAULT PFC FROM #MarketBaseWithPack  
    EXCEPT  
    SELECT DISTINCT MarketBaseId COLLATE DATABASE_DEFAULT MarketBaseId,PFC COLLATE DATABASE_DEFAULT PFC FROM #nonCommaMarketDefinitionPacks  
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
      ON #AddPacks.PFC COLLATE DATABASE_DEFAULT = DIMProduct_Expanded.PFC COLLATE DATABASE_DEFAULT  
      JOIN [MarketDefinitionBaseMaps] MDBM  
      ON #AddPacks.MarketBaseId= CONVERT(nvarchar(Max), MDBM.[MarketBaseId])  
      WHERE MDBM.[MarketDefinitionId]=@MyField  
  
      FETCH NEXT FROM @MyCursor   
      INTO @MyField   
    END;   
  
    CLOSE @MyCursor ;  
    DEALLOCATE @MyCursor;  
END;  
  
DROP TABLE #MarketBaseWithPack  
DROP TABLE #RemovePacks  
DROP TABLE #AddPacks  
  
END  

--[dbo].[RevalidateMarketDefinition] 546
  
  



