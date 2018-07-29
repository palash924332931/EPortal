
CREATE PROCEDURE [dbo].[IRPImportMarketDefinitionMultipleMBAndPack] 
	-- Add the parameters for the stored procedure here
	@pDimensionId int 
AS
BEGIN
	SET NOCOUNT ON;

	declare @kount int

	--## STEP 1: INSERT INTO MarketDefinitions
	--CHECK FOR EXISTING MARKET DEFINITION
	select @kount = count(*) from MarketDefinitions where DimensionId = @pDimensionId
	if @kount  > 0
	begin
		-- Delete existing Market Definition if any
		exec [dbo].[IRPDeleteMarketDefinitionFromDimensionID] @pDimensionId
	end 

	select @kount = count(*) from MarketDefinitions where DimensionId = @pDimensionId
	if @kount = 0
	begin
		insert into MarketDefinitions (Name, Description, ClientId, GUIID, DimensionId)
		--select replace(replace(replace(DimensionName,'/',' '), '&', ' '),',',' '), NULL, C.ClientId, NULL, DimensionId
		select DimensionName, NULL, C.ClientId, NULL, DimensionId
		from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId
		where DimensionID = @pDimensionId and VersionTo > 0

	--select * from MarketDefinitions
	end


	--## STEP 2: INSERT INTO MarketDefinitionBaseMaps
	declare @marketDefinitionId int
	select @marketDefinitionId = Id from MarketDefinitions where DimensionId = @pDimensionId

	select * into #tMarketBases from 
	(
		select a.marketbaseid from IRP.DimensionBaseMap a join marketbases b on a.marketbaseid = b.id where DimensionId = @pDimensionId 
		except 
		select marketbaseid from MarketDefinitionBaseMaps where marketdefinitionid = @marketDefinitionId
	)A

	select @kount = count(*) from #tMarketBases
	if @kount > 0
	begin
		print 'market definition id '
		print @marketDefinitionId
		insert into MarketDefinitionBaseMaps (Name, MarketBaseId, DataRefreshType, MarketDefinitionId)
		select M.Name +' ' + M.Suffix, D.MarketBaseId, 'static', @marketDefinitionId
		from (
			select * from #tMarketBases
		) D join MarketBases M on D.MarketBaseId = M.Id


		--select * from MarketDefinitionBaseMaps

		--## STEP 3: INSERT INTO MarketDefinitionPacks
		declare @marketBaseId int
		declare @marketBaseName nvarchar(200)
		declare @whereClause nvarchar(max)
		declare @unionClause nvarchar(max)
		declare @insertStatement nvarchar(max) 
		set @insertStatement = N'insert into MarketDefinitionPacks (Pack, MarketBase, MarketBaseId, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, MarketDefinitionId, Alignment, Product, Molecule)'

		select * into #loopTable from #tMarketBases 

		declare @pMarketBaseId int
		set @unionClause = ''

		while exists(select * from #loopTable)
		begin
			-------PROCESSING OF QUERY CONSTRUCTION USING UNION FOR MULTIPLE MARKET BASES-------
			select @pMarketBaseId = (select top 1 marketBaseId from #loopTable order by marketBaseId asc)			
			select @marketBaseName = Name + ' ' + Suffix from MarketBases M where Id = @pMarketBaseId

			select @whereClause = ' where ' + 
			case when c.FilterValue = 'Molecule' then c.ColumnName + ' like ' + '(' + left([Values], 1) + '%' + substring([Values], 2, len([Values]) -2) + '%' + right([Values], 1) +')'
			else c.ColumnName + ' in ' + '(' + [Values] +')'  end 
			from basefilters b join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] c on b.Criteria = c.FilterValue
			where MarketBaseId = @pMarketBaseId
			print(@whereClause)

			set @unionClause = @unionClause	+ ' select Pack_Description, '''+ @marketBaseName +''', ' + cast(@pMarketBaseId as varchar) + ', PFC, ORG_LONG_NAME, ATC4_Code, NEC4_Code, ''static'', ' + cast(@marketDefinitionId as varchar) + ', ''static-left'' 
			, ProductName as Product, M.Description as Molecule from DimProduct_Expanded left join DMMoleculeConcat M on M.FCC = DimProduct_Expanded.FCC' + @whereClause + ' UNION '

			print('Union Clause')
			print(@unionClause)
			--EXEC(@insertStatement+@whereClause)

			delete #loopTable
			where MarketBaseId = @pMarketBaseId
		end


		drop table #loopTable
		declare @finalQuery varchar(max)
		set @finalQuery = left(@insertStatement+@unionClause, len(@insertStatement+@unionClause) - 6)
		print('Final Query: ' + @finalQuery)
	
		if (right(@finalQuery,3) <> 'Mol')
		begin
			EXEC(@finalQuery)
		end
	
		--select * from MarketDefinitionPacks

		--grouping information entry
		--declare @maxLevel int
		--select distinct @maxLevel=max(levelno) from irp.items where dimensionid=@pDimensionId
		--and shortname is not null or shortname<>'' and (number is not null or number<>'') and versionto=32767 
		---

		select  DISTINCT
		CASE WHEN TRY_CONVERT(int, p.item) IS not NULL   
		THEN p.item
		ELSE null  
		END AS FCC
		,p.Name,
		case Charindex(';', g.shortname)
		when 0 then null
		when 1 then null
		else Substring(g.shortname, 1,Charindex(';', g.shortname)-1)
		end as groupname,
		case Charindex(';', g.shortname)
		when 0 then 1.0
		when LEN(g.shortname) then 1.0
		else substring(g.shortname, Charindex(';', g.shortname)+8, LEN(g.shortname))
		end as factor,
		g.number [groupno]
		into #fcctemp
		from irp.items g
		join irp.items p
		on g.itemid = p.parent
		where g.dimensionid = @pDimensionId
		and p.itemtype = 1
		and p.versionto > 0
		and g.versionto > 0

		update m set Alignment = 'dynamic-right',m.groupname=f.groupname,m.factor= f.factor,m.groupnumber=f.groupno
		from MarketDefinitionPacks m join dimproduct_expanded d on m.pfc=d.pfc join #fcctemp f on d.fcc=f.fcc
		where m.PFC in (select distinct PFC from dimproduct_expanded where FCC in (select distinct FCC from #fcctemp))
		and marketdefinitionid = @marketDefinitionId

	---update groupname null in marketdefinitionpacks

		update marketdefinitionpacks set groupnumber = '' where groupnumber is null
		update marketdefinitionpacks set groupname = '' where groupname is null
		--update marketdefinitionpacks set factor = '' where factor is null
	end
	exec  [dbo].[CombineMultipleMarketBasesForMarket] @marketDefinitionId

END



--[dbo].[IRPImportMarketDefinitionMultipleMBAndPack] 4703

--select * from [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] 

--update [CONFIG_ECP_MKT_DEF_FILTERS] set ColumnName = '[M].[Description]' where FilterValue = 'Molecule'




