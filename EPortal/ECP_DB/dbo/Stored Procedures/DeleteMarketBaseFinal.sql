
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMarketBaseFinal] 
	@pMarketBaseId int,
	@pCompleteDeleteFlag int,
	@pSubscriptionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


CREATE TABLE #RemovePacks(MarketBaseId NVARCHAR(Max),PFC NVARCHAR(Max),FCC NVARCHAR(Max))
	
	exec [UnsubscribeMarketBase] @pMarketBaseId, @pSubscriptionId

	declare @marketbasename varchar(500)
	select @marketbasename  = name + ' ' + suffix from marketbases where id = @pMarketBaseId

	--------- GET PACKS FOR EXPIRED MARKET BASES --------------                           
	INSERT #RemovePacks (MarketBaseId, PFC,FCC)
    EXEC GetPacksFromMarketBase @pMarketBaseId

	------ REMOVING PACKS FROM MARKET_DEFINITION FOR EXPIRED MARKET BASES -----------

	 ---for MarketDefinitionPacks
	DELETE FROM [dbo].[MarketDefinitionPacks]
	WHERE PFC COLLATE DATABASE_DEFAULT IN (SELECT DISTINCT PFC FROM #RemovePacks) AND [MarketBaseId]=cast(@pMarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@pMarketBaseId as varchar), '')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar), '')
	WHERE [MarketBaseId] LIKE '%,'+cast(@pMarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@pMarketBaseId as varchar)+',', '')
	,[MarketBase] = replace([MarketBase], cast(@MarketBaseName as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@pMarketBaseId as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@pMarketBaseId as varchar)+',', ',')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@pMarketBaseId as varchar)+',%'

	-------considering space---------

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@pMarketBaseId as varchar), '')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar), '')
	WHERE [MarketBaseId] LIKE '%, '+cast(@pMarketBaseId as varchar)

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], cast(@pMarketBaseId as varchar)+',', '')
	,[MarketBase] = replace([MarketBase], cast(@MarketBaseName as varchar)+',', '')
	WHERE [MarketBaseId] LIKE cast(@pMarketBaseId as varchar)+' ,%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@pMarketBaseId as varchar)+',', ',')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%, '+cast(@pMarketBaseId as varchar)+',%'

	UPDATE [dbo].[MarketDefinitionPacks]
	SET [MarketBaseId] = replace([MarketBaseId], ','+cast(@pMarketBaseId as varchar)+',', ',')
	,[MarketBase] = replace([MarketBase], ','+cast(@MarketBasename as varchar)+',', ',')
	WHERE [MarketBaseId] LIKE '%,'+cast(@pMarketBaseId as varchar)+' ,%'
	--DELETE FROM [dbo].[SubscriptionMarket] 
	--WHERE MarketBaseId = @pMarketBaseId

	

	
	-----------REMOVE MARKET DEFINITION IF IT HAD ONLY MB
	SELECT DISTINCT [MarketDefinitionId]
	INTO #TEMP
	FROM [dbo].[MarketDefinitionBaseMaps]
	WHERE [MarketBaseId]=cast(@pMarketBaseId as varchar)

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
				SELECT @Count1=COUNT(*) from [MarketDefinitionBaseMaps]
				WHERE [MarketDefinitionId]=@MyField1 

				DELETE FROM dbo.AdditionalFilters 
				where marketdefinitionbasemapid in 
					(select id from [dbo].[MarketDefinitionBaseMaps] where [MarketBaseId]=@pMarketBaseId and marketdefinitionid = @MyField1)

				DELETE FROM  [dbo].[MarketDefinitionBaseMaps]
				WHERE [MarketBaseId]=@pMarketBaseId and marketdefinitionid = @MyField1

				
				delete from subscriptionmarket where MarketBaseId = @pMarketBaseId
				delete from basefilters where MarketBaseId = @pMarketBaseId
				--delete from MarketBases where id = @pMarketBaseId

			  IF(@Count1=1) 
					BEGIN
						delete from deliverymarket where marketdefid =  @MyField1
						DELETE FROM [dbo].[MarketDefinitions]
						WHERE ID=@MyField1
						
					END

			  FETCH NEXT FROM @MyCursor1 
			  INTO @MyField1 
			END; 

			CLOSE @MyCursor1 ;
			DEALLOCATE @MyCursor1;
		END;

		if @pCompleteDeleteFlag = 1
		begin
			delete from ClientMarketBases where MarketBaseId = @pMarketBaseId
			-------AUDIT DELETE INFO------
			insert into DeleteLogTable 
			select 'B', a.Id, [name] + ' ' + suffix,null, b.clientid, null,getdate() from MarketBases a join ClientMarketBases b on a.id = b.MarketBaseId
		    where a.Id=@pMarketBaseId
			--select top 10 * from MarketBase_history 
			insert into MarketBase_history (MBId, [version], name, suffix, durationTo, durationFrom, baseType, modifieddate)
			select Id, -1, name, suffix, durationTo, durationFrom, baseType, getdate() from MarketBases where Id=@pMarketBaseId

			delete from MarketBases where id = @pMarketBaseId
		end
	---------------------------------------------------------

	DROP TABLE #RemovePacks

	--------MARKET BASE DELETE IF NEEDED----------
	--if @pCompleteDeleteFlag = 1
	--begin
	--	delete from ClientMarketBases where MarketBaseId = @pMarketBaseId
	--	delete from subscriptionmarket where MarketBaseId = @pMarketBaseId
	--	delete from basefilters where MarketBaseId = @pMarketBaseId
	--	delete from MarketBases where id = @pMarketBaseId
	--end


END

--exec DeleteMarketBaseFinal 32,1