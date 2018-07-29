/****** Object:  StoredProcedure [dbo].[GetPacksFromMarketBaseHistory]    Script Date: 3/02/2018 2:33:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetPacksFromMarketBaseHistory]
 @MarketBaseId int,
 @Version int
AS
BEGIN
	SET NOCOUNT ON;

	declare @HasMolecule bit
	set @HasMolecule = 0
	declare @ConditionValue nvarchar(500)

	select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseMBId,B.MarketBaseVersion, C.ColumnName 
	into #baseFilters
	from dbo.BaseFilter_History B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue
	where B.MarketBaseMBId = @MarketBaseId and b.MarketBaseVersion=@Version and B.Criteria not in ('Molecule')

	--select * from #baseFilters
	if((select count(*) from  dbo.BaseFilter_History where MarketBaseMBId = @MarketBaseId and MarketBaseVersion=@Version and Criteria='Molecule')>=1)
	begin
	 set @HasMolecule=1
	 set @ConditionValue= (select [Values] from  dbo.BaseFilter_History where MarketBaseMBId = @MarketBaseId and MarketBaseVersion=@Version and Criteria='Molecule')
	end
	  

	select MarketBaseMBId, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions
	into #columnsToAppend
	from #baseFilters 

	--select * from #columnsToAppend

	declare @whereClause nvarchar(max)
	declare @selectSql nvarchar(max)

	select distinct @whereClause = ' where ' + conditions from
		(
			SELECT 
				b.MarketBaseMBId, 
				(SELECT ' ' + a.conditions 
				FROM #columnsToAppend a
				WHERE a.MarketBaseMBId = b.MarketBaseMBId
				FOR XML PATH('')) [conditions]
			FROM #columnsToAppend b
			GROUP BY b.MarketBaseMBId, b.conditions
			--ORDER BY 1
		)c
	
	set @whereClause = left(@whereClause, len(@whereClause) - 4)
	print(@whereClause)

	if(@HasMolecule=0)
	begin
	set @selectSql = 'select distinct PFC, FCC from DimProduct_Expanded ' + @whereClause
	end

	if(@HasMolecule=1)
	begin
	set @selectSql = 'select distinct PFC, P.FCC from DimProduct_Expanded P join [DMMolecule] M on P.FCC=M.FCC ' + @whereClause+ ' and M.Description in ('+@ConditionValue+')'
	end

	print(@selectSql)
	EXEC(@selectSql)
	
END
GO


