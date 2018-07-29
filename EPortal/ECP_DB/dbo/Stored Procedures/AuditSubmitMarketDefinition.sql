CREATE PROCEDURE [dbo].[AuditSubmitMarketDefinition]
	@marketDefId int,
	@userId int
AS
BEGIN

		declare @lastVersion int
		declare @version int
		declare @marketdefbasemapid int
		declare @marketbaseid int

		declare @pfc varchar(30)
		declare @action varchar(10)
		declare @loopVersion int

		declare @tempReport table(
			[pfc] [nvarchar](30) NULL,
			[pack] [nvarchar](255) NULL,
			[action] [nvarchar](11) NULL,
			[MarketBase] [nvarchar](255) NULL,
			[Groups] [nvarchar](500) NULL,
			[factor] [nvarchar](20) NULL,
			[version] [int] NULL,
			[user] [nvarchar](200) NULL,
			[time_stamp] [datetime] NULL,
			[MarketDefinitionId] [int] NULL
		)

		select @lastVersion=max([Version]) from marketdefinitions_history where marketdefid = @marketDefId
		if @lastVersion is null 
		begin
			set @version = 1
		end
		else
		begin
			set @version = @lastVersion + 1
		end

		insert into marketdefinitions_history
		select id, @version, name, description, clientid, guiid, dimensionid, GETDATE(), @userId, null, null, null, lastSaved 
		from marketdefinitions where id = @marketDefId

		insert into MarketDefBaseMap_History (marketdefid, [version], name, marketbaseid, marketbaseversion, datarefreshtype)
		select marketdefinitionid, @version, name, marketbaseid, 0, datarefreshtype from marketdefinitionbasemaps where marketdefinitionid = @marketDefId

		select id, marketdefid, [version], name, marketbaseid, marketbaseversion, datarefreshtype into #loop1 from 
		MarketDefBaseMap_History where marketdefid = @marketDefId and [version]=@version
		while exists(select * from #Loop1)
		begin
			--to be inserted into additionalfilter_history
			select @marketdefbasemapid = (select top 1 id from #loop1 order by marketdefid, marketbaseid asc)
			select @marketbaseid = (select top 1 marketbaseid from #loop1 order by marketdefid, marketbaseid asc)
	
			insert into additionalfilter_history(MarketDefBaseMap_HistoryId, MarketDefVersion, name, criteria, [values], isenabled)
			select @marketdefbasemapid, @version, a.name, a.criteria, a.[values], a.isenabled 
			from additionalFilters a join marketdefinitionbasemaps b on a.MarketDefinitionBaseMapId = b.Id 
			where b.marketdefinitionid = @marketDefId and b.marketbaseid = @marketbaseid    

			delete #loop1 where marketdefid = @marketDefId and marketbaseid = @marketbaseid
		end

		drop table #loop1

		if @lastVersion is null
		begin
			--insert into marketdefpack_history
			--(marketdefinitionid, marketdefversion, pack, marketbase, marketbaseid, factor, pfc, manufacturer, atc4, nec4, datarefreshtype, statestatus, alignment, product, changeflag, molecule)
			--select marketdefinitionid, @version, pack, marketbase, marketbaseid, factor, pfc, manufacturer, atc4, nec4, datarefreshtype, statestatus, alignment, product, changeflag, molecule
			--from marketdefinitionpacks where marketdefinitionid = @marketDefId and alignment = 'dynamic-right'

			insert into MarketDefinitionPacksAuditReport
			select pfc, pack, '', marketbase, null, factor, @version, firstname + ' ' + lastname, getdate(), marketdefinitionid
			from marketdefinitionpacks a join dbo.[user] u on u.userid = @userid
			where marketdefinitionid =  @marketdefid AND alignment = 'dynamic-right'
		end

		else 
		begin
			select pfc into #v1_packs from MarketDefinitionPacksAuditReport where [version] = 1 and marketdefinitionid = @marketDefId
			select pfc, pack, [action], marketbase, groups, factor 
			into #v1_pack_details from MarketDefinitionPacksAuditReport where [version] = 1 and marketdefinitionid = @marketDefId

			select * into #loopPackStatus from MarketDefinitionPacksAuditReport where marketdefinitionid = @marketDefId and [version] > 1

			while exists(select * from #loopPackStatus)
			begin
				select @pfc = (select top 1 pfc from #loopPackStatus order by [version], pfc)
				select @action = (select top 1 [action] from #loopPackStatus order by [version], pfc)
				select @loopVersion = (select top 1 [version] from #loopPackStatus order by [version], pfc)
				if @action = 'Added'
				begin
					insert into #v1_packs values (@Pfc)
					insert into #v1_pack_details 
					select pfc, pack, [action], marketbase, groups, factor 
					from #loopPackStatus where pfc = @pfc and @action = 'Added' 
					
				end 
				else if @action = 'Deleted'
				begin
					delete from #v1_packs where pfc = @pfc
				end
				
				delete #loopPackStatus where pfc = @pfc and [version] = @loopVersion and [action] = @action
			end

			drop table #loopPackStatus

			select pfc into #addedPacks from 
			(
				select pfc from marketdefinitionpacks where marketdefinitionid = @marketDefId and alignment = 'dynamic-right'
				except
				select distinct pfc from #v1_packs
			)A
			print ('added packs in version ' + cast (@version as varchar))
			select * from #addedPacks

			select pfc into #deletedPacks from 
			(
				select distinct pfc from #v1_packs
				except
				select pfc from marketdefinitionpacks where marketdefinitionid = @marketDefId and alignment = 'dynamic-right'
		
			)B
			print ('deleted packs in version ' + cast (@version as varchar))
			select * from #deletedPacks

			insert into @tempReport
			select distinct a.pfc, b.pack, 'Added', b.MarketBase, null, b.factor, @version, firstname + ' ' + lastname, getdate(), @marketDefId
			from #addedPacks a join (select * from marketdefinitionpacks where marketdefinitionid =  @marketdefid AND alignment = 'dynamic-right') b on a.pfc = b.pfc
			join dbo.[user] u on u.userid = @userid
			

			select * from #v1_pack_details order by pfc

			insert into @tempReport
			select a.pfc, b.pack, 'Deleted', b.MarketBase, null, b.factor, @version, firstname + ' ' + lastname, getdate(), @marketDefId
			from #deletedPacks a join (select distinct * from #v1_pack_details) b on a.pfc = b.pfc
			join dbo.[user] u on u.userid = @userid

			drop table #v1_packs
		end

		insert into MarketDefinitionPacksAuditReport select distinct * from @tempReport
		--select * from MarketDefinitionPacksAuditReport

		--------SAVING GROUPING HISTORY-----------
		declare @groupHistoryId int
		declare @groupId int

		insert into MarketAttributes_History
		select attributeid, name, orderno, MarketDefinitionId, @version from MarketAttributes where MarketDefinitionId = @marketDefId

		insert into MarketGroups_History(GroupId, name, MarketDefId, [version])
		select GroupId, name, MarketDefinitionId, @version from MarketGroups where MarketDefinitionId = @marketDefId

		insert into MarketGroupMappings_History
		select ParentId, GroupId, IsAttribute, AttributeId, @marketDefId, @version from MarketGroupMappings 
		where attributeid in (select attributeId from MarketAttributes WHERE marketdefinitionId = @marketDefId)
		
		insert into dbo.MarketGroupFilters_History
		select name, criteria, [values], isEnabled, groupid, attributeid, marketdefinitionid, isAttribute, @version
		from MarketGroupFilters where marketdefinitionid = @marketDefId

		--------SAVING GROUPING PACK HISTORY-----------
		insert into MarketGroupPacks_History
		--select PFC, GroupId, marketdefinitionId, @version from MarketGroupPacks where marketdefinitionId = @marketDefId
		
		select distinct b.name GroupName, d.name MarketAttribute, a.PFC, e.Pack PackDescription, @marketDefId, @version 
			from MarketGroupPacks a join MarketGroups b on a.groupId = b.groupId
				join MarketGroupMappings c on c.groupId = b.groupId
				join MarketAttributes d on d.attributeId = c.attributeId
				join (select PFC, Pack from marketdefinitionpacks where marketdefinitionid = @marketDefId) e on e.PFC = a.PFC
		where a.marketdefinitionid = @marketDefId

		--declare @groupPackCountinHistory int
		--declare @groupPackCount int
		--declare @groupPackVersionCount int
		--declare @groupPackFirstVersion int

		--declare @tempGroupReport table(
		--	GroupName varchar(100),
		--	MarketAttribute varchar(100),
		--	PFC varchar(25),
		--	PackDescription varchar(100),
		--	[Action] varchar(20),
		--	[Version] int,
		--	SubmittedBy varchar(50),
		--	[DateTime] datetime
		--)

		--select @groupPackCountinHistory =  count(*) from MarketGroupPacks_history where marketdefid = @marketDefId
		--if @groupPackCountinHistory = 0
		--begin
		--	select @groupPackCount = count(*) from MarketGroupPacks where marketdefinitionid = @marketDefId		
		--	if	@groupPackCount > 0
		--	begin
		--		insert into AuditMarketDefGroupingReport
		--		select b.name GroupName, d.name MarketAttribute, a.PFC, e.Pack PackDescription, null, @version, firstname + ' ' + lastname, getdate(), @marketDefId
		--		from MarketGroupPacks a join MarketGroups b on a.groupId = b.groupId
		--		join MarketGroupMappings c on c.groupId = b.groupId
		--		join MarketAttributes d on d.attributeId = c.attributeId
		--		join (select PFC, Pack from marketdefinitionpacks where marketdefinitionid = @marketDefId) e on e.PFC = a.PFC
		--		join dbo.[user] u on u.userid = @userid
		--		where a.marketdefinitionid = @marketdefid
		--	end
		--end
		--else
		--begin
		--	select @groupPackVersionCount = count(distinct [version]) from  MarketGroupPacks_History where marketdefid = @marketDefId 
		--	select @groupPackFirstVersion = min([Version]) from MarketGroupPacks_History where marketdefid = @marketDefId 
			
		--	select GroupName, MarketAttribute, PFC, PackDescription into #v1_groupPacks
		--	from AuditMarketDefGroupingReport where marketDefId = @marketDefId and [version] = @groupPackFirstVersion

		--	select b.name GroupName, d.name MarketAttribute, a.PFC, e.Pack PackDescription into #tCurrentGropuing
		--	from MarketGroupPacks a join MarketGroups b on a.groupId = b.groupId
		--		join MarketGroupMappings c on c.groupId = b.groupId
		--		join MarketAttributes d on d.attributeId = c.attributeId
		--		join (select PFC, Pack from marketdefinitionpacks where marketdefinitionid = @marketDefId) e on e.PFC = a.PFC

		--	select GroupName, MarketAttribute, PFC, PackDescription into #addedGroupPacks from 
		--	(
		--		select * from #tCurrentGropuing
		--		except
		--		select * from #v1_groupPacks
		--	)A

		--	select GroupName, MarketAttribute, PFC, PackDescription into #deletedGroupPacks from 
		--	(
		--		select * from #v1_groupPacks
		--		except
		--		select * from #tCurrentGropuing
		--	)B

		--	insert into @tempGroupReport
		--	select GroupName, MarketAttribute, PFC, PackDescription, 'Added', 

		--end

	select a.*, b.GroupName into #tPFCGroups
	from MarketDefinitionPacksAuditReport a join marketgrouppacks_history b on a.PFC = b.PFC and a.MarketDefinitionId = b.MarketDefId and a.version = b.version
	where a.MarketDefinitionId = @marketDefId

	select distinct * into #tPFCGroups2 from(
		SELECT 
			b.PFC, b.Pack, b.[action], b.marketbase, b.factor, b.version, b.[user], b.[time_stamp], b.marketdefinitionid,
			(SELECT ',' + a.GroupName 
			FROM #tPFCGroups a
			WHERE a.PFC = b.PFC and a.PACK = b.PACK and a.ACTION = b.ACTION and a.MARKETBASE = b.MARKETBASE and a.FACTOR = b.FACTOR and a.version = b.version and a.[user] = b.[user] and a.[time_stamp] = b.[time_stamp] and a.marketdefinitionid = b.marketdefinitionid 
			FOR XML PATH('')) [GroupName]
		FROM #tPFCGroups b
		GROUP BY b.PFC, b.Pack, b.[action], b.marketbase, b.factor, b.version, b.[user], b.[time_stamp], b.marketdefinitionid
	)X

	update a set a.groups = replace(isnull(b.groupname, ','),left(isnull(b.groupname, ','),1), '')
	from MarketDefinitionPacksAuditReport a join #tPFCGroups2 b on a.PFC = b.PFC and a.MarketDefinitionId = b.MarketDefinitionId and a.version = b.version
	where a.MarketDefinitionId = @marketDefId
	
	--select * from marketgrouppacks_history

	-------Keep full-copy of the latest submitted version of a market definition-------

	--Delete if any record exists
	Delete from [dbo].[MarketDefPack_History] where MarketDefinitionId = @marketDefId

	--Insert latest submitted version
	Insert into [dbo].[MarketDefPack_History]
	([MarketDefinitionId], [MarketDefVersion], [Pack], [MarketBase], [MarketBaseId], [GroupNumber], [GroupName]
	,[Factor], [PFC], [Manufacturer], [ATC4], [NEC4], [DataRefreshType], [StateStatus], [Alignment], [Product], [ChangeFlag], [Molecule])  
	
	select MarketDefinitionId, @version, pack, marketbase, marketbaseid, groupnumber, groupname
	, factor, pfc, Manufacturer, atc4, nec4, DataRefreshType, StateStatus, Alignment, product, changeflag, molecule
	from marketdefinitionpacks a join dbo.[user] u on u.userid = @userid
	where marketdefinitionid =  @marketdefid --AND alignment = 'dynamic-right'

END

--------------
--drop table AuditMarketDefGroupingReport
--go
--create table AuditMarketDefGroupingReport
--(
--	GroupName varchar(100),
--	MarketAttribute varchar(100),
--	PFC varchar(25),
--	PackDescription varchar(100),
--	[Action] varchar(20),
--	[Version] int,
--	SubmittedBy varchar(50),
--	[DateTime] datetime, 
--	MarketDefId int
--);
--go

GO