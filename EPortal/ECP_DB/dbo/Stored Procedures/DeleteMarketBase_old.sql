

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMarketBase_old] 
	-- Add the parameters for the stored procedure here
	@MarketBaseId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT DISTINCT [MarketDefinitionId]
INTO #TEMP
FROM [dbo].[MarketDefinitionPacks]
WHERE [MarketBaseId]=@MarketBaseId


--to del market base
DELETE  FROM [dbo].[MarketBases]
WHERE ID=@MarketBaseId

DELETE FROM [dbo].[BaseFilters]
WHERE [MarketBaseId]=@MarketBaseId

DELETE FROM [ClientMarketBases]
WHERE [MarketBaseId]=@MarketBaseId

DELETE FROM  [dbo].[MarketDefinitionBaseMaps]
WHERE [MarketBaseId]=@MarketBaseId

--DELETE FROM [dbo].[MarketDefinitionPacks]
--WHERE [MarketBaseId]=@MarketBaseId

---for MarketDefinitionPacks
	DELETE FROM [dbo].[MarketDefinitionPacks]
	WHERE [MarketBaseId]=cast(@MarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar), '')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@MarketBaseId as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@MarketBaseId as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@MarketBaseId as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@MarketBaseId as varchar)+',%'

-----------------------------------------
--delete market definition if it uses only one deleted MB

DECLARE @Count int;
DECLARE @MyCursor CURSOR;
DECLARE @MyField int;
BEGIN
    SET @MyCursor = CURSOR FOR
    SELECT DISTINCT [MarketDefinitionId] from #TEMP
        

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @MyField

    WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @Count=COUNT(*) from #TEMP
	  WHERE [MarketDefinitionId]=@MyField 
	  IF(@Count>0) 
			BEGIN
				DELETE FROM [dbo].[MarketDefinitions]
				WHERE ID=@MyField 
			END

      FETCH NEXT FROM @MyCursor 
      INTO @MyField 
    END; 

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;
--------------------------------------------
END






