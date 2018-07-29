

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RemoveExpiredMarketBases] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


CREATE TABLE #MarketBaseIds(MarketBaseId NVARCHAR(Max))
CREATE TABLE #RemovePacks(MarketBaseId NVARCHAR(Max),PFC NVARCHAR(Max))



-------------- GET EXPIRED MARKET BASES ------------------
INSERT INTO #MarketBaseIds
SELECT  [Id] AS MarketBaseId
FROM [dbo].[MarketBases]
WHERE [DurationFrom] < cast (GETDATE() as DATE)
---AND ID =680



----Remove Packs from Market Def
DECLARE @Count int;
DECLARE @MyCursor CURSOR;
DECLARE @MyField int;
BEGIN
    SET @MyCursor = CURSOR FOR
    SELECT DISTINCT [MarketBaseId] from #MarketBaseIds
        

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @MyField

    WHILE @@FETCH_STATUS = 0
    BEGIN

		DELETE FROM  [dbo].[MarketDefinitionBaseMaps]
		WHERE [MarketBaseId]=@MyField

	 --------- GET PACKS FOR EXPIRED MARKET BASES --------------                           
	  INSERT #RemovePacks (MarketBaseId, PFC,FCC)
      EXEC GetPacksFromMarketBase @MyField

	  ------ REMOVING PACKS FROM MARKET_DEFINITION FOR EXPIRED MARKET BASES -----------
	  SELECT 'PACKS REMOVED', * FROM #RemovePacks
	  --DELETE FROM [MarketDefinitionPacks]
	  --WHERE PFC IN (SELECT DISTINCT PFC FROM #RemovePacks)  
	  --AND  MarketBaseId=@MyField

	 ---for MarketDefinitionPacks
	DELETE FROM [dbo].[MarketDefinitionPacks]
	WHERE PFC IN (SELECT DISTINCT PFC FROM #RemovePacks) AND [MarketBaseId]=cast(@MyField as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MyField as varchar), '')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MyField as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@MyField as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@MyField as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MyField as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MyField as varchar)+',%'

	DELETE FROM [dbo].[SubscriptionMarket] 
	WHERE MarketBaseId = @MyField


	
	-----------REMOVE MARKET DEFINITINO IF IT HAD ONLY MB
	SELECT DISTINCT [MarketDefinitionId]
	INTO #TEMP
	FROM [dbo].[MarketDefinitionPacks]
	WHERE [MarketBaseId]=@MyField

	----------------------------------------------------------
		DECLARE @Count1 int;
		DECLARE @MyCursor1 CURSOR;
		DECLARE @MyField1 int;
		BEGIN
			SET @MyCursor1 = CURSOR FOR
			SELECT DISTINCT [MarketDefinitionId] from #TEMP
        

			OPEN @MyCursor1 
			FETCH NEXT FROM @MyCursor1
			INTO @MyField1

			WHILE @@FETCH_STATUS = 0
			BEGIN
			  SELECT @Count1=COUNT(*) from #TEMP
			  WHERE [MarketDefinitionId]=@MyField1 
			  IF(@Count1>0) 
					BEGIN
						DELETE FROM [dbo].[MarketDefinitions]
						WHERE ID=@MyField1
						delete from deliverymarket where marketdefid =  @MyField1
					END

			  FETCH NEXT FROM @MyCursor1 
			  INTO @MyField1 
			END; 

			CLOSE @MyCursor1 ;
			DEALLOCATE @MyCursor1;
		END;

	----------------------------------------------------------


      FETCH NEXT FROM @MyCursor 
      INTO @MyField 
    END; 

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;

DROP TABLE #MarketBase
DROP TABLE #RemovePacks



END

--select * from subscriptionMarket






