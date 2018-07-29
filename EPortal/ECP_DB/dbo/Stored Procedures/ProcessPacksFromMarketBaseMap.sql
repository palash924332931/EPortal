

CREATE PROCEDURE [dbo].[ProcessPacksFromMarketBaseMap]
 @MarketDefinitionId int, 
 @MarketBaseId int,
 @MarketDefBaseMapId int
AS
BEGIN
	SET NOCOUNT ON;

	declare @selectSql nvarchar(max)
	declare @countNewPacks int

	select @selectSql = query from MarketBaseMapQuery
	where MarketDefinitionId = @MarketDefinitionId and MarketBaseId = @MarketBaseId and MarketDefBaseMapId = @MarketDefBaseMapId

----FROM HERE 2-----
	--select distinct 24 as MarketBaseId, PFC, dimproduct_Expanded_test2.FCC, CHANGE_FLAG from dimproduct_Expanded_test2 where  [Org_Long_Name] in ('A PAK') AND CHANGE_FLAG = 'A'

	-----STORING THE OUTPUT OF QUERY INTO TEMPORARY TABLE VARIABLE
	declare @QueryResult table(MarketBaseId int, PFC varchar(30), FCC varchar(30), CHANGE_FLAG char(1))
	insert @QueryResult EXEC(@selectSql)

	--select * from @QueryResult

	-------COMPARING with HISTORY-----------
	--select Q.MarketBaseId, Q.PFC, Q.FCC, H.CHANGE_FLAG into #packInHistory
	--from @QueryResult Q join [HISTORY_TDW-ECP_DIM_PRODUCT] H on Q.PFC = H.PFC and Q.FCC = H.FCC
	
	IF OBJECT_ID(N'tempdb..#packInHistory') IS NOT NULL drop table #packInHistory
	select * into #packInHistory from @QueryResult

	print('PACK IN HISTORY: ')
	select * from #packInHistory

	------Market Definition Packs update----------
	-----------INSERT NEW PACKS--------------
	IF OBJECT_ID(N'tempdb..#newPacks') IS NOT NULL drop table #newPacks
	select distinct Pack_Description as Pack, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' MarketBase, PS.MarketBaseId MarketBaseId, '' GroupNumber, '' GroupName, '' Factor, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, 'XXXXXXXX' DataRefreshType, '' as StateStatus, @MarketDefinitionId as MarketDefinitionId, 'XXXXXXXXXXXXXXX' Alignment, P.ProductName as Product,  MC.Description as Molecule
	into #newPacks
	from #packInHistory PS join DimProduct_Expanded P
	on PS.PFC = P.PFC and PS.FCC = P.FCC
	left join DMMoleculeConcat MC
	on P.Fcc=MC.FCC
	where PS.CHANGE_FLAG = 'A'

	--print('new packs:' )
	--select * from #newPacks

	select @countNewPacks = count(*) from #newPacks
	print('Count New Packs: ')
	print(@countNewPacks)
	if @countNewPacks > 0
	begin
		update #newPacks set MarketBase = MB.Name + ' ' + MB.Suffix
		from MarketBases MB 
		where MB.Id = #newPacks.MarketBaseId 

		----
		update #newPacks set DataRefreshType= MD.DataRefreshType, 
		Alignment = MD.DataRefreshType + '-' + case when MD.DataRefreshType = 'static' then 'left' else 'right' end 
		from MarketDefinitionBaseMaps MD 
		where MD.Id = @MarketDefBaseMapId

		--select * from #newPacks


		--Split MarketDefinitionPacks table
		select A.[pack], A.[MarketBase], Split.a.value('.', 'VARCHAR(100)') AS MarketBaseID,A.[GroupNumber], A.[GroupName], A.[Factor], A.[PFC], A.[Manufacturer], A.[ATC4], A.[NEC4], A.[DataRefreshType], A.[StateStatus], A.[MarketDefinitionId], A.[Alignment], A.[Product],A.[Molecule]
		into #mdpSplit
		from  (select [pack],MarketBase,GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, Molecule,
			 CAST ('<M>' + REPLACE([MarketBaseId], ',', '</M><M>') + '</M>' AS XML) AS MarketBaseID  
			 from  MarketDefinitionPacks where MarketDefinitionId =@MarketDefinitionId) AS A CROSS APPLY MarketBaseID.nodes ('/M') AS Split(a)
	
		-----TRIM SPACE------
		update #mdpSplit set MarketBaseId = LTRIM(RTRIM(MarketBaseId))

		--update market base name
		update s
		set s.MarketBase=mb.Name
		from #mdpSplit s
		join MarketBases mb
		on mb.id=s.MarketBaseID
	--where s.MarketBase like '%,%'
	
		print('Split:' )
		select * from #mdpSplit

		--select * into #packsToInsert from 
		--(
		--	select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, Molecule from #newPacks
		--	except
		--	select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, Molecule from #mdpSplit where MarketDefinitionId = @MarketDefinitionId --and MarketBaseId = @MarketBaseId
		--)A

		select * into #packsToInsert from
		( 
			select a.Pack, a.MarketBase, a.MarketBaseId, b.GroupNumber, b.GroupName, b.Factor, a.PFC, a.Manufacturer, a.ATC4, a.NEC4, b.DataRefreshType, b.StateStatus, a.MarketDefinitionId, b.Alignment, a.Product, a.Molecule from
			(
				select PFC, MarketDefinitionId, MarketBaseId, Pack, MarketBase, Manufacturer, ATC4, NEC4, Product, Molecule from #newPacks
				except
				select PFC, MarketDefinitionId, MarketBaseId, Pack, MarketBase, Manufacturer, ATC4, NEC4, Product, Molecule from #mdpSplit where MarketDefinitionId = @MarketDefinitionId --and MarketBaseId = @MarketBaseId
			)A join #newPacks B on a.pfc = b.pfc and a.marketdefinitionid = b.marketdefinitionid and a.marketbaseid = b.marketbaseid
		)C

		insert into MarketDefinitionPacks 
		select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, StateStatus, MarketDefinitionId, Alignment, Product, 'A' Change_Flag, Molecule  
		from #packsToInsert
	
		print('#packsToInsert:' )
		select * from #packsToInsert
	end

	-----------DELETE PACKS--------------
	--delete from MarketDefinitionPacks 
	--where PFC in 
 --  --and MarketBaseId = @MarketBaseId 
	--	(
	--		select distinct PFC from #packInHistory where CHANGE_FLAG = 'D'
	--	)

	--print('#packsDeleted:')
	--select distinct PFC from #packInHistory where CHANGE_FLAG = 'D'

	-----------UPDATE MODIFIED PACKS--------------
	--select distinct Pack_Description as Pack, PS.PFC PFC, P.Org_Short_Name as Manufacturer, P.ATC4_Code as ATC4, P.NEC4_Code as NEC4, P.ProductName as Product, MC.Description as Molecule
	--into #modifiedPacks
	--from #packInHistory PS join DimProduct_Expanded P
	--on PS.PFC = P.PFC and PS.FCC = P.FCC
	--left join DMMoleculeConcat MC
	--on P.Fcc=MC.FCC
	--where PS.CHANGE_FLAG = 'M'

	
	--print('Modified Packs: ')
	--select * from #modifiedPacks
	--update MarketDefinitionPacks 
	--set Pack=M.Pack, Manufacturer=M.Manufacturer, ATC4=m.ATC4, NEC4=M.NEC4, Product=M.Product, Molecule=M.Molecule
	--from MarketDefinitionPacks MD join #modifiedPacks M on MD.PFC = M.PFC 

	----APPLY MOLECULE DELTA-----
	select * into #tmolecule from 
	(
		select distinct A.FCC,C.PFC from dmmolecule A 
		join Dimproduct_Expanded B on A.FCC = B.FCC 
		join MarketDefinitionPacks C on C.PFC = B.PFC
		where A.CHANGE_FLAG <> 'U'
	)A

	update a set a.Molecule = c.[Description]
	--select distinct b.FCC, a.PFC, c.Description
	from MarketDefinitionPacks a join #tmolecule b on a.PFC = b.PFC
	join DMMOLECULECONCAT c on b.FCC = C.FCC

END