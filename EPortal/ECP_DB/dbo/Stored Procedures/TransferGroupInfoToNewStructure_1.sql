CREATE procedure [dbo].[TransferGroupInfoToNewStructure]
as
begin
	declare @marketDefinitionid int
	declare @kount int
	declare @attributeid int

	select distinct MarketDefinitionid into #loopTableMD from MarketDefinitionPacks where isnull(groupnumber, '') <> ''
	--select distinct MarketDefinitionid into #loopTableMD from MarketGROUPs

	while exists(select * from #loopTableMD)
	begin
		select @marketDefinitionid = (select top 1 MarketDefinitionid
							from #loopTableMD
							order by MarketDefinitionid asc)

		print('Mkt def id : ')
		print(@marketDefinitionid)
		
		-----delete existing data if already exists-----
		select @kount = count(id) from marketattributes where marketdefinitionid = @marketDefinitionid
		if @kount > 0
		begin
			select @attributeid = attributeid from marketattributes where marketdefinitionid = @marketDefinitionid
			delete from MarketGroupPacks where marketdefinitionid = @marketDefinitionid
			delete from marketgroupmappings where parentid = @attributeid
			delete from marketgroups where marketdefinitionid = @marketDefinitionid
			delete from marketattributes where marketdefinitionid = @marketDefinitionid
		end

		-------------------------------------------------------------------------------------------
		declare @maxattrid int
		declare @newattrid int
		declare @kount2 int
		select @kount2 = count(attributeid) from marketattributes
		if @Kount2 = 0 
		begin
			set @maxattrid = 100
		end
		else
		begin 
			select @maxattrid = max(attributeid) from marketattributes
		--select * from marketattributes
		end

		--select @maxattrid = max(attributeid) from marketattributes

		set @newattrid = @maxattrid + 1
		print 'new attr '
		print @newattrid

		insert into marketattributes (attributeid, [name], orderno, marketdefinitionid) values (@newattrid, 'group', 1, @marketDefinitionid)

		--select * from marketgroups
		insert into marketgroups (groupid, [name], marketdefinitionid) 
		select distinct convert(int, GroupNumber), groupname, marketdefinitionid from marketdefinitionpacks where marketdefinitionid = @marketDefinitionid and isnull(groupnumber,'') <> ''

		--update GroupOrderNo
		IF OBJECT_ID(N'tempdb..#t') IS NOT NULL drop table #t
		select Id, row_number() over (partition by marketdefinitionid order by Id) as grouporderno into #t
		from marketgroups where marketdefinitionid = @marketDefinitionid order by marketdefinitionid, grouporderno
		
		update A set A.GroupOrderNo = b.GroupOrderNo
		from MarketGroups  A join #t b on A.Id = b.Id
		where MarketDefinitionid = @marketDefinitionid
		 
		--select * from marketgroupmappings
		insert into marketgroupmappings (parentid, groupid, isattribute, attributeid)
		select distinct NULL, convert(int, GroupNumber), 1,NULL from marketdefinitionpacks where marketdefinitionid = @marketDefinitionid and isnull(groupnumber,'') <> ''
		UPDATE marketgroupmappings set ParentId = @newattrid, AttributeId=@newattrid where  parentid is null

		--select * from marketgrouppacks
		insert into marketgrouppacks (PFC, GroupId, Marketdefinitionid)
		select PFC, convert(int, GroupNumber), marketdefinitionid from marketdefinitionpacks where marketdefinitionid = @marketDefinitionid and isnull(groupnumber,'') <> ''
		
		-------------------------------------------------------------------------------------------

		delete #loopTableMD where MarketDefinitionid = @marketDefinitionid
	end

	drop table #loopTableMD	
 end


-- --select * from marketgroups where marketdefinitionid = 20
--select marketdefinitionid, Id, GroupOrderNo--,row_number() over (partition by marketdefinitionid order by Id) as grouporderno into #t
--from marketgroups order by marketdefinitionid, grouporderno