CREATE PROCEDURE [dbo].[AuditMarketDefBaseMapReport]
	@versionFrom int,
	@versionTo int,
	@marketDefId int
as
begin

	SET NOCOUNT ON
	declare @BaseMapReport table(MBName varchar(100), DataRefreshSettings varchar(16), Filter nvarchar(max), Action varchar(10), Version int, SubmittedBy varchar(100), [DateTime] datetime)

	declare @i int

	set @i = @versionFrom
	while(@i < @versionTo)
	begin
		
		IF OBJECT_ID(N'tempdb..#sourceMB1') IS NOT NULL drop table #sourceMB1
		IF OBJECT_ID(N'tempdb..#sourceMB2') IS NOT NULL drop table #sourceMB2
		IF OBJECT_ID(N'tempdb..#sourceMB') IS NOT NULL drop table #sourceMB
		IF OBJECT_ID(N'tempdb..#destMB1') IS NOT NULL drop table #destMB1
		IF OBJECT_ID(N'tempdb..#destMB2') IS NOT NULL drop table #destMB2
		IF OBJECT_ID(N'tempdb..#destMB') IS NOT NULL drop table #destMB

		select * into #sourceMB1 from marketdefbasemap_history where [version] = @i and marketdefid = @marketDefId
		select a.*, b.criteria + '=' + b.[values] as [conditions] into #sourceMB2 from #sourceMB1 a left join additionalfilter_history b on a.id = b.marketdefbasemap_historyid


		select * into #destMB1 from marketdefbasemap_history where [version] = @i + 1 and marketdefid = @marketDefId
		select a.*, b.criteria + '=' + b.[values] as [conditions] into #destMB2 from #destMB1 a left join additionalfilter_history b on a.id = b.marketdefbasemap_historyid

		--select * from #sourceMB2
		--select * from #destMB2

		select distinct * into #sourceMB from(
			SELECT 
				b.id, b.marketdefid, b.version, b.marketbaseid, b.name, b.DataRefreshType,
				(SELECT ' ' + a.conditions 
				FROM #sourceMB2 a
				WHERE a.marketbaseid = b.marketbaseid and a.marketdefid = b.marketdefid and a.version = b.version and a.DataRefreshType = b.DataRefreshType and a.id = b.id
				FOR XML PATH('')) [conditions]
			FROM #sourceMB2 b
			GROUP BY b.id, b.marketdefid, b.version, b.marketbaseid, b.version, b.conditions, b.name, b.DataRefreshType
		)X

		

		select distinct * into #destMB from(
			SELECT 
				b.id, b.marketdefid, b.version, b.marketbaseid,  b.name, b.DataRefreshType,
				(SELECT ' ' + a.conditions 
				FROM #destMB2 a
				WHERE a.marketbaseid = b.marketbaseid and a.marketdefid = b.marketdefid and a.version = b.version and a.DataRefreshType = b.DataRefreshType and a.id = b.id
				FOR XML PATH('')) [conditions]
			FROM #destMB2 b
			GROUP BY b.id, b.marketdefid, b.version, b.marketbaseid, b.version, b.conditions, b.name, b.DataRefreshType
		)X

		--select * from #sourceMB
		--select * from #destMB


		IF OBJECT_ID(N'tempdb..#addedMB') IS NOT NULL drop table #addedMB
		select * into #addedMB from(
			select marketdefid, name, marketbaseid, DataRefreshType, conditions from #destMB
			except
			select marketdefid, name, marketbaseid, DataRefreshType, conditions from #sourceMB
		)A

		IF OBJECT_ID(N'tempdb..#deletedMB') IS NOT NULL drop table #deletedMB
		select * into #deletedMB from(
			select marketdefid, name, marketbaseid, datarefreshtype, conditions from #sourceMB
			except
			select marketdefid, name, marketbaseid, datarefreshtype, conditions from #destMB
		)A

		--select * from #addedMB
		--select * from #deletedMB

		insert into @BaseMapReport
		select a.name MarketBaseName, case when a.DataRefreshType = 'static' then 'Static' else 'Dynamic' end DataRefreshSettings, 
		a.conditions, 'Added', @i+1 as version, firstname + ' ' + lastname as submittedBy, ModifiedDate
		from #addedMB a 
		join #destMB d on d.MarketDefId = a.MarketDefId and d.MarketBaseId = a.MarketBaseId and d.DataRefreshType = a.DataRefreshType
		LEFT join AdditionalFilter_History af on af.marketdefbasemap_historyid = d.id
		join marketdefinitions_history mh on mh.version = @i + 1 and mh.marketdefid = @marketDefId
		join dbo.[user] u on u.userid = mh.userid
		union
		select a.name MarketBaseName, case when a.DataRefreshType = 'static' then 'Static' else 'Dynamic' end DataRefreshSettings, 
		a.conditions, 'Deleted', @i+1 as version, firstname + ' ' + lastname as submittedBy, ModifiedDate
		from #deletedMB a 
		join #sourceMB d on d.MarketDefId = a.MarketDefId and d.MarketBaseId = a.MarketBaseId and d.DataRefreshType = a.DataRefreshType
		LEFT join AdditionalFilter_History af on af.marketdefbasemap_historyid = d.id
		join marketdefinitions_history mh on mh.version = @i + 1 and mh.marketdefid = @marketDefId
		join dbo.[user] u on u.userid = mh.userid

		set @i = @i + 1
	end

	select * from @BaseMapReport
end