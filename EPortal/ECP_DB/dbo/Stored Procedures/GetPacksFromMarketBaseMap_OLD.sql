

CREATE PROCEDURE [dbo].[GetPacksFromMarketBaseMap_OLD]
 @MarketDefinitionId int, 
 @MarketBaseId int,
 @MarketDefBaseMapId int
AS
BEGIN
	SET NOCOUNT ON;

	----------MARKET BASE : BASE FILTERS CONSTRUCTION IN WHERE CLAUSE-------------
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName 
	into #baseFilters
	from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketBaseId = @MarketBaseId

	--select * from #baseFilters

	select marketbaseid, Criteria + ' in ' + '(''' + [Values] + ''') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	--select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where ' + conditions from
		(
			SELECT 
				b.marketbaseid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.marketbaseid = b.marketbaseid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.marketbaseid, b.conditions
			--ORDER BY 1
		)c
	
	--set @whereClause = left(@whereClause, len(@whereClause) - 4)
	print(@whereClause)

	

	----------MARKET DEF BASE MAP: ADDITIONAL FILTERS CONSTRUCTION -------------
	--drop table #additionalFilters
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketDefinitionBaseMapId, C.ColumnName 
	into #additionalFilters
	from dbo.AdditionalFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketDefinitionBaseMapId = @MarketDefBaseMapId

	--select * from #additionalFilters

	--drop table #columnsToAppend2
	select marketdefinitionbasemapid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend2
	from #additionalFilters 

	--select * from #columnsToAppend2

	declare @additionalFilterConditions nvarchar(max)

	select distinct @additionalFilterConditions = conditions from
		(
			SELECT 
				b.marketdefinitionbasemapid, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend2 a
				WHERE a.marketdefinitionbasemapid = b.marketdefinitionbasemapid
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend2 b
			GROUP BY b.marketdefinitionbasemapid, b.conditions
			--ORDER BY 1
		)c

	
	print(@additionalFilterConditions)

	------Final SELECT query CONSTRUCTION---------
	set @selectSql = 'select distinct ' + cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, PFC, FCC from DimProduct_Expanded ' 
					+ @whereClause + @additionalFilterConditions

	set @selectSql = left(@selectSql, len(@selectSql) - 4)
	print(@selectSql)
	--EXEC(@selectSql)

	-----STORING THE OUTPUT OF QUERY INTO TEMPORARY TABLE VARIABLE
	declare @QueryResult table(MarketBaseId int, PFC varchar(30), FCC varchar(30))
	insert @QueryResult EXEC(@selectSql)
	--select * from @QueryResult

	-------comparing with HISTORY-----------
	select Q.MarketBaseId, Q.PFC, Q.FCC, H.CHANGE_FLAG into #packStatus
	from @QueryResult Q join [HISTORY_TDW-ECP_DIM_PRODUCT] H on Q.PFC = H.PFC and Q.FCC = H.FCC

	--select * from #packStatus

	------Market Definition Packs update----------
	-----------INSERT NEW PACKS--------------
	select distinct Pack_Description as Pack, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' MarketBase, PS.MarketBaseId MarketBaseId, '' GroupNumber, '' GroupName, '' Factor, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, 'XXXXXXXX' DataRefreshType, '' as StateStatus, @MarketDefinitionId as MarketDefinitionId, 'XXXXXXXXXXXXXXX' Alignment, P.ProductName as Product
	into #newPacks
	from #packStatus PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	where PS.CHANGE_FLAG = 'A'

	--select * from #newPacks

	update #newPacks set MarketBase = MB.Name
	from MarketBases MB 
	where MB.Id = #newPacks.MarketBaseId 

	----
	update #newPacks set DataRefreshType= MD.DataRefreshType, Alignment = MD.DataRefreshType + '-' + case when MD.DataRefreshType = 'static' then 'left' else 'right' end 
	from MarketDefinitionBaseMaps MD 
	where MD.Id = @MarketDefBaseMapId

	--update #newPacks set Alignment= MP.Alignment
	--from MarketDefinitionPacks MP 
	--where MP.MarketBaseId = #newPacks.MarketBaseId and MP.MarketDefinitionId = @MarketDefinitionId

	--select * from #newPacks

	select * into #packsToInsert from 
	(
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product from #newPacks
		except
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product from MarketDefinitionPacks where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId
	)A

	insert into MarketDefinitionPacks select * from #packsToInsert

	------INSERT INTO CLIENT PACK EXCEPTION------
	insert into ClientPackException  
	select distinct clientId,np.FCC,0 from [ClientPackException] cp
	inner join DIMProduct_Expanded dp on cp.PackExceptionId = dp.FCC
	inner join #newPacks np on dp.PFC = np.PFC and dp.FCC = np.FCC
	where dp.Prod_cd in (select distinct Prod_cd from DIMProduct_Expanded where FCC in (select distinct FCC from #newPacks))


	-----------DELETE PACKS--------------
	delete from MarketDefinitionPacks 
	where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId and PFC in 
		(
			select distinct PFC from #packStatus where CHANGE_FLAG = 'D'
		)
END


--[dbo].[GetPacksFromMarketBaseMap] 430,653,569