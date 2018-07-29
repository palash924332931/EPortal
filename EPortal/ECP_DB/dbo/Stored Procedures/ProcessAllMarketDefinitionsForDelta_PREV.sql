--alter table excluded_dimproduct_expanded add time_stamp datetime
--go




CREATE PROCEDURE [dbo].[ProcessAllMarketDefinitionsForDelta_PREV] 
AS
BEGIN
	SET NOCOUNT ON;

	declare @count int
	select @count=count(*) from [dbo].[RAW_TDW-ECP_DIM_PRODUCT]

	if @count > 0 
	begin

		---- FOR IMPORT : SET CHANGE_FLAG = 'U' FOR COMMON PACKS BETWEEN EXISTING MKT DEFs and REFERENCE DATA
		update a set a.change_flag = 'U'
		from dimproduct_expanded a 
		join MarketDefinitionPacks b on a.PFC = b.PFC 
		where a.CHANGE_FLAG = 'A'
	
		---- FOR NEW RUN : FIRST CHANGE FLAGS TO U that are more than 1 month old
		--update MarketDefinitionPacks_backup set changeflag = 'U' where changeFlag = 'A'
		update a set changeflag = 'U' from marketdefinitionpacks a
		join (select pfc from dimproduct_expanded where highlighter = 'U') b on a.pfc = b.pfc

		-- DELETE ALL 'D' FLAGGED PACKS AT FIRST
		delete from marketdefinitionpacks where PFC in (select distinct PFC from dimproduct_expanded where change_flag = 'D')
		--DELETE ALL PACKS FALLEN UNDER PACK EXCLUSION RULES
		delete A from MarketDefinitionPacks A join excluded_dimproduct_expanded B on A.PFC = B.PFC

		--------------------
		--select count(*) from (select A.pfc from marketdefinitionpacks a join excluded_dimproduct_expanded b on a.PFC = b.PFC)C
		--------------------


		--UPDATE MODIFIED 'M' PACKS
		update MarketDefinitionPacks 
		set Pack=M.Pack_Description, Manufacturer=M.Org_Long_Name, ATC4=m.ATC4_Code, NEC4=M.NEC4_Code, Product=M.ProductName
		from MarketDefinitionPacks MD 
		join (select pfc,Pack_Description,Org_Long_Name,ATC4_Code,NEC4_Code,ProductName from dimproduct_expanded where change_flag = 'M')M on MD.PFC = M.PFC
		--AFTER UPDATE, CHANGE M TO U
		update dimproduct_expanded set CHANGE_FLAG = 'U' where CHANGE_FLAG = 'M'

		select * into #loopTable from MarketDefinitions --where id > 80
		select * from #loopTable

		declare @pMarketDefinitionId int

		while exists(select * from #loopTable)
		begin
			select @pMarketDefinitionId = (select top 1 Id
							   from #loopTable
							   order by Id asc)

			print('Mkt def id : ')
			print(@pMarketDefinitionId)
			-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
			EXEC [dbo].[ProcessMarketDefinitionForNewDataLoad] @MarketDefinitionId = @pMarketDefinitionId

			delete #loopTable where Id = @pMarketDefinitionId
		end

		drop table #loopTable

		--------------------------------------------------------------------------
		select * into #tDuplicatePack from (
			select marketdefinitionid, pfc, marketbase, marketbaseid,  groupname, groupnumber, factor, changeflag, alignment,
			row_number() over (partition by marketdefinitionid, pfc, marketbase, marketbaseid  
			order by marketdefinitionid, pfc, marketbase, marketbaseid,  alignment, groupname, groupnumber, factor, changeflag) num
				from(
				select a.marketdefinitionid, a.pfc, marketbase, marketbaseid,  groupname, groupnumber, factor, changeflag, alignment 
				from marketdefinitionpacks a join 
				(
					select marketdefinitionid, pfc, kount from(
						   select marketdefinitionid, pfc, count(1) kount from(
								 select pfc, marketdefinitionid from marketdefinitionpacks)A group by marketdefinitionid, pfc
					)B where kount > 1
				)b on a.marketdefinitionid = b.marketdefinitionid and a.pfc = b.pfc
			--order by 1,2,6
			)X
		)Y
		where num = 2
		--order by 1,2,3,alignment, num
		
		delete a from marketdefinitionpacks a join #tDuplicatePack b on a.marketdefinitionid = b.marketdefinitionid and a.pfc = b.pfc
		and a.marketbaseid = b.marketbaseid and a.changeflag = b.changeflag and a.alignment = b.alignment

		select * into #tDuplicatePack2 from (
			select marketdefinitionid, pfc, marketbase, marketbaseid,  groupname, groupnumber, factor, changeflag, alignment,
			row_number() over (partition by marketdefinitionid, pfc, marketbase, marketbaseid  
			order by marketdefinitionid, pfc, marketbase, marketbaseid,  alignment, changeflag) num
				from(
				select a.marketdefinitionid, a.pfc, marketbase, marketbaseid,  groupname, groupnumber, factor, changeflag, alignment 
				from marketdefinitionpacks a join 
				(
					select marketdefinitionid, pfc, kount from(
						   select marketdefinitionid, pfc, count(1) kount from(
								 select pfc, marketdefinitionid from marketdefinitionpacks)A group by marketdefinitionid, pfc
					)B where kount > 1
				)b on a.marketdefinitionid = b.marketdefinitionid and a.pfc = b.pfc
			--order by 1,2,6
			)X
		)Y
		where num = 2
		--order by 1,2,3,alignment, num

		delete a from marketdefinitionpacks a join #tDuplicatePack2 b on a.marketdefinitionid = b.marketdefinitionid and a.pfc = b.pfc
		and a.marketbaseid = b.marketbaseid and a.changeflag = b.changeflag and a.alignment = b.alignment

		select * into #tDuplicatePack3 from (
			select marketdefinitionid, pfc, marketbase, marketbaseid,  groupname, groupnumber, factor, changeflag, alignment,
			row_number() over (partition by marketdefinitionid, pfc  
			order by marketdefinitionid, pfc, alignment, changeflag) num
				from(
				select a.marketdefinitionid, a.pfc, marketbase, marketbaseid,  groupname, groupnumber, factor, changeflag, alignment 
				from marketdefinitionpacks a join 
				(
					select marketdefinitionid, pfc, kount from(
						   select marketdefinitionid, pfc, count(1) kount from(
								 select pfc, marketdefinitionid from marketdefinitionpacks)A group by marketdefinitionid, pfc
					)B where kount > 1
				)b on a.marketdefinitionid = b.marketdefinitionid and a.pfc = b.pfc
			--order by 1,2,6
			)X
		)Y
		where num = 2
		order by 1,2,3,alignment, num

		delete a from marketdefinitionpacks a join #tDuplicatePack3 b on a.marketdefinitionid = b.marketdefinitionid and a.pfc = b.pfc
		and a.marketbaseid = b.marketbaseid and a.changeflag = b.changeflag and a.alignment = b.alignment
		--------------------------------------------------------------------------
		
		EXEC [CombineMultipleMarketBasesForAll]
	end

END