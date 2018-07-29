
CREATE PROCEDURE [dbo].[BuildQueryForMarketGroup]
	 @MarketDefinitionId int, 
	 @GroupId int
AS
BEGIN
	SET NOCOUNT ON;

	declare @trimVal int
	declare @finalClause nvarchar(100)
	set @trimval = 4
	set @finalClause = ' AND CHANGEFLAG = ''A'''

	----------MARKET BASE : BASE FILTERS CONSTRUCTION IN WHERE CLAUSE-------------
	select B.Id, B.Name, replace(B.criteria, ' ', '' ) as Criteria, B.[Values], B.GroupId, C.ColumnName
	into #groupFilters
	from dbo.marketgroupfilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on replace(B.criteria, ' ', '' ) = C.FilterValue
	where B.MarketDefinitionId = @MarketDefinitionId and B.GroupId = @GroupId

	select * from #groupFilters

	select GroupId, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend
	from #groupFilters 

	select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where MarketDefinitionId = ' + cast(@MarketDefinitionId as nvarchar) + ' and ' + conditions from
		(
			SELECT 
				b.GroupId, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.GroupId = b.GroupId
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.GroupId, b.conditions
			--ORDER BY 1
		)c
	
	--set @whereClause = left(@whereClause, len(@whereClause) - 4)
	set @whereClause = replace(@whereClause, '&amp;', '&')
	print('Group Filter: ' + @whereClause)

	--------Final SELECT query CONSTRUCTION-----------
	--print('reached inside final query')
	set @selectSql = 'select distinct MarketDefinitionId, ' + cast(@GroupID as nvarchar) + '  as GroupID,' + ' PFC, CHANGEFLAG from MarketDefinitionPacks' 
					+ @whereClause --+ '( ' + @additionalFilterConditions + ' )' 

	set @selectSql = left(@selectSql, len(@selectSql) - @trimVal) --+ @finalClause
	print('Final Query: ' + @selectSql)

	insert into MarketGroupQuery VALUES
	(@MarketDefinitionId, @GroupId, @selectSql)


END

--select top 10 * from MarketBaseMapQuery