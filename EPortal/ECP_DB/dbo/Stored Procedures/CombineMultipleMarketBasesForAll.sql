CREATE PROCEDURE [dbo].[CombineMultipleMarketBasesForAll]
 
AS
BEGIN
	SET NOCOUNT ON;
	
	update marketdefinitionpacks set groupnumber = '' where groupnumber is null
	update marketdefinitionpacks set groupname = '' where groupname is null
	update marketdefinitionpacks set Factor = '1.0' where Factor is null
	update marketdefinitionpacks set StateStatus = '' where StateStatus is null
	update marketdefinitionpacks set ChangeFlag = '' where ChangeFlag is null

	----REMOVE DUPLICATE RECORDS FROM MarketDefinitionPacks----
	;with CTE_DUP as
	(
		select row_number() over (
			partition by pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
			order by pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
		) as rownum,
		pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
		from MarketDefinitionPacks
		where --MarketDefinitionId = 553 and 
		MarketBaseId is not null
	)
	--select * from CTE_DUP where rownum > 1 order by marketdefinitionid, pack;
	delete from CTE_DUP where rownum > 1;

	----COMBINING MULTIPLE MARKET BASES-----
	IF OBJECT_ID('tempdb..#t') IS NOT NULL drop table #t

	select C.pack, M.MarketBase, M.MarketBaseId, C.GroupNumber, C.GroupName, C.Factor Factor, C.PFC, C.Manufacturer, C.ATC4, C.NEC4, C.DataRefreshType, C.StateStatus, C.MarketDefinitionId, C.Alignment, C.Product, C.ChangeFlag, C.Molecule
	into #t
	from(
		select distinct rownum, pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
		from(
			select rownum, pack, GroupNumber, GroupName, isnull(Factor, '1.0') Factor, PFC, isnull(Manufacturer,'') Manufacturer, isnull(ATC4,'') ATC4, isnull(NEC4, '') NEC4, DataRefreshType, isnull(StateStatus, '') StateStatus, MarketDefinitionId, Alignment, Product, isnull(ChangeFlag, '') ChangeFlag, isnull(Molecule, '') Molecule
			,count(*) as kount 
			from 
			(
				select rank() over (order by pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule) as rownum,
				pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
				from MarketDefinitionPacks
				where 
				--MarketDefinitionId = 220 and 
				MarketBaseId is not null --
			)A
			group by rownum, pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
			--order by marketdefinitionid, pack
		)B
		where B.kount > 1
		--order by marketdefinitionid, pack
	)C
	join MarketDefinitionPacks M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC AND C.GroupNumber = M.GroupNumber 
	and C.ATC4 =  isnull(M.ATC4,'') and C.NEC4 = isnull(M.NEC4,'') and C.Manufacturer = isnull(M.Manufacturer,'')
	order by C.marketdefinitionid, C.pack

	--select * from #t

	IF OBJECT_ID('tempdb..#aggregatedMarketBase') IS NOT NULL drop table #aggregatedMarketBase
	select pack, 
		STUFF((SELECT ', ' + CAST(MarketBase AS VARCHAR(500)) [text()]
			 FROM #t 
			 WHERE Pack = t.Pack and MarketDefinitionId = t.MarketDefinitionId and PFC = t.PFC AND GroupNumber = t.GroupNumber and ATC4 = t.ATC4 and NEC4 = t.NEC4 and Manufacturer = t.Manufacturer
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' ') MarketBase,
			STUFF((SELECT ', ' + CAST(MarketBaseId AS VARCHAR(500)) [text()]
			 FROM #t 
			 WHERE Pack = t.Pack and MarketDefinitionId = t.MarketDefinitionId and PFC = t.PFC AND GroupNumber = t.GroupNumber and ATC4 = t.ATC4 and NEC4 = t.NEC4 and Manufacturer = t.Manufacturer
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' ') MarketBaseId,
		GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule
	into #aggregatedMarketBase
	from #t t
	group by pack, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, ChangeFlag, Molecule

	--select * from #aggregatedMarketBase

	--select C.* from MarketDefinitionPacks C 
	--inner join #t M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC --AND C.GroupNumber = M.GroupNumber and C.ATC4 = M.ATC4 and C.NEC4 = isnull(M.NEC4,'') and C.Manufacturer = isnull(M.Manufacturer,'')

	
	-----DELETE RECORDS/PACKS COMMON FOR MULTIPLE MARKET BASES------
	delete C from MarketDefinitionPacks C 
	inner join #t M on C.Pack = M.Pack and C.MarketDefinitionId = M.MarketDefinitionId and C.PFC = M.PFC --AND C.GroupNumber = M.GroupNumber and C.ATC4 = M.ATC4 and C.NEC4 = isnull(M.NEC4,'') and C.Manufacturer = isnull(M.Manufacturer,'')
	--and id not in (198252)

	-----INSERT COMIBNED MARKET BASES FOR COMMON PACKS--------
	insert into MarketDefinitionPacks select * from #aggregatedMarketBase

END