CREATE PROCEDURE [dbo].[AuditMarketBaseSettingsReport]
@marketBaseId int,
@versionFrom int,
@versionTo int

AS
BEGIN
	SET NOCOUNT ON;
	--drop table #MBS
	SELECT 
	   MH.MBID,MH.[version],0 AS PackCount,
	   STUFF((SELECT '; ' + BF.criteria +'=' +replace(BF.[Values],'''','') 
			  FROM Basefilter_History BF
			  WHERE BF.MarketBaseMBId = MH.MBID and BF.MarketBaseVersion=MH.[version]
			  FOR XML PATH('')), 1, 1, '') [SETTINGS]
	into #MBS
	FROM marketbase_History MH
	Where MH.MBId=@marketBaseId And [version]> @versionFrom and [version]<=@versionTo
	GROUP BY MH.MBID,MH.[version]
	ORDER BY 1

	
	---------------------------------------
	declare @version int
	
	declare @trimVal int
    declare @finalClause nvarchar(100)
    set @trimval = 8
    set @finalClause = ''

	select distinct [version] into #loopTableVersion from #MBS
	while exists(select * from #loopTableVersion)
    begin
        select @version = (select top 1 [version]
                                    from #loopTableVersion
                                    order by [version] asc)

        print('version id: ')
        print(@version)

        ---------------------PACK COUNT---------------------------------
	   
       ----------MARKET BASE : BASE FILTERS CONSTRUCTION IN WHERE CLAUSE-------------
       IF OBJECT_ID(N'tempdb..#baseFilters') IS NOT NULL drop table #baseFilters
	   select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.marketbasembid MarketBaseId, C.ColumnName, B.IsRestricted 
       into #baseFilters
       from (select * from dbo.BaseFilter_history where marketbasembid = @MarketBaseId and marketbaseversion= @Version) B 
	   join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on replace(B.criteria, ' ', '' ) = C.FilterValue
       --where B.MarketBaseId = @MarketBaseId

       --select * from #baseFilters
	   IF OBJECT_ID(N'tempdb..#columnsToAppend') IS NOT NULL drop table #columnsToAppend
       select marketbaseid, Criteria + case when IsRestricted = 0 then ' in ' else ' not in ' end + '(' + [Values] + ') AND ' conditions
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
       
       set @whereClause = left(@whereClause, len(@whereClause) - 4)
       set @whereClause = replace(@whereClause, '&amp;', '&')
       print('Base Filter: ' + @whereClause)

       

       
       --------Final SELECT query CONSTRUCTION-----------
       --print('reached inside final query')
       set @selectSql = 'select distinct PFC from dimproduct_Expanded left join dmmoleculeconcat M on dimproduct_Expanded.fcc = M.fcc' 
                                 + @whereClause 

       --set @selectSql = left(@selectSql, len(@selectSql) - @trimVal) + @finalClause
       set @selectSql = 'select count(*) [packcount] from (' + @selectSql + ')X'
	   print('Final Query: ' + @selectSql)

	   declare @QueryResult table(PACKCOUNT int)
       declare @packcount int
	   insert @QueryResult EXEC(@selectSql)
	   select @packcount=PACKCOUNT from @QueryResult

	   update #MBS set packcount = @packcount
	   where [version] = @version

	-----------------------------------------------------------------

        delete #loopTableVersion where [version] = @version
    end

    drop table #loopTableVersion

	---------------------------------------

	--------FINAL REPORT------------
	select b.name+ ' ' + b.suffix as MarketBaseName,a.Settings, a.[Version] as VersionNumber, c.FirstName+ ' ' + c.LastName as SubmittedBy,b.LastSaved as [DateTime], a.PackCount
	from #MBS a
	join marketbase_History b on b.MBID=a.MBID and b.[version]=a.[version]
	join [user] c on b.userid=c.userid

END

--exec [AuditMarketBaseSettingsReport] 546,1,4

--------------------------------------

--select distinct query from marketbasemapquery where marketbaseid = 778