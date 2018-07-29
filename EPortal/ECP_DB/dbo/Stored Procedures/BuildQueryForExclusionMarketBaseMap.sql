
CREATE PROCEDURE [dbo].[BuildQueryForExclusionMarketBaseMap]
 @MarketDefinitionId int, 
 @MarketBaseId int,
 @MarketDefBaseMapId int
AS
BEGIN
	SET NOCOUNT ON;

	declare @trimVal int
	declare @finalClause nvarchar(100)
	set @trimval = 8
	set @finalClause = ''

	----------MARKET BASE : BASE FILTERS CONSTRUCTION IN WHERE CLAUSE-------------
	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName, B.IsRestricted 
	into #baseFilters
	from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on replace(B.criteria, ' ', '' ) = C.FilterValue
	where B.MarketBaseId = @MarketBaseId

	select * from #baseFilters

	select marketbaseid, Criteria + case when IsRestricted = 0 then ' in ' else ' not in ' end + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	select * from #columnsToAppend

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
	set @whereClause = replace(@whereClause, '&amp;', '&')
	print('Base Filter: ' + @whereClause)

	

	----------MARKET DEF BASE MAP: ADDITIONAL FILTERS CONSTRUCTION -------------
	--drop table #additionalFilters
	declare @additionalFilterCount int
	declare @additionalFilterConditions nvarchar(max) = ''

	select @additionalFilterCount = count(AF.id) from AdditionalFilters AF join MarketDefinitionBaseMaps MB on AF.MarketDefinitionBaseMapId = MB.Id
	where MB.Id = @MarketDefBaseMapId
	--print(@additionalFilterCount)
	if @additionalFilterCount > 0
	begin
		select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketDefinitionBaseMapId, C.ColumnName, B.IsEnabled 
		into #additionalFilters
		from dbo.AdditionalFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on replace(B.criteria, ' ', '' ) = C.FilterValue
		where B.MarketDefinitionBaseMapId = @MarketDefBaseMapId

		select * from #additionalFilters

		--drop table #columnsToAppend2
		select marketdefinitionbasemapid, Criteria + case when isEnabled = 1 then ' in ' else ' not in ' end + '(' + [Values] + ')' + 
		case when criteria like '%ATC%' OR criteria like '%NEC%' then ' OR ' else 'AND ' end conditions
		into #columnsToAppend2
		from #additionalFilters 

		--select * from #columnsToAppend2

		

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

		set @additionalFilterConditions = replace(@additionalFilterConditions, '&amp;', '&') 
		print('Additional Filters: ' + @additionalFilterConditions)

		set @trimVal = 6
		set @finalClause = ')' 
	end
	--------Final SELECT query CONSTRUCTION-----------
	--print('reached inside final query')
	set @selectSql = 'select distinct PFC, excluded_dimproduct_Expanded.FCC, pack_description,' + cast(@MarketDefinitionId as nvarchar) + ' as MarketDefinitionId, md.name MarketDefinitionName,'
		+ cast(@MarketBaseId as nvarchar) + ' as MarketBaseId, mb.name + '' ''+ mb.suffix MarketBaseName, c.name ClientName,  [rule] ReasonForExclusion, [time_stamp] DateExcluded from excluded_dimproduct_Expanded left join dmmoleculeconcat M on excluded_dimproduct_Expanded.fcc = M.fcc
		 join MarketDefinitions md on md.id = ' + cast(@MarketDefinitionId as varchar) +
		' join clients c on c.id = md.clientid 
		 join marketbases mb on mb.id=' + cast(@MarketBaseId as varchar) + ' ' 
					+ @whereClause + '( ' + @additionalFilterConditions + ' )' 

	set @selectSql = left(@selectSql, len(@selectSql) - @trimVal) + @finalClause
	print('Final Query: ' + @selectSql)

	insert into PackExclusionQuery VALUES
	(@MarketDefinitionId, @MarketBaseId, @MarketDefBaseMapId, @selectSql)


END


