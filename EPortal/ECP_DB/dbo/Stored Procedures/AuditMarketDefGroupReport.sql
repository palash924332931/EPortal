CREATE PROCEDURE [dbo].[AuditMarketDefGroupReport]
	@versionFrom int,
	@versionTo int,
	@marketDefId int
as
begin

	SET NOCOUNT ON
	declare @GroupReport table(
		GroupName varchar(100),
		MarketAttribute varchar(100),
		PFC varchar(25),
		PackDescription varchar(100),
		[Action] varchar(20),
		[Version] int,
		SubmittedBy varchar(50),
		[DateTime] datetime, 
		MarketDefId int
	)
	declare @i int

	set @i = @versionFrom
	while(@i < @versionTo)
	begin
		
		IF OBJECT_ID(N'tempdb..#sourceG') IS NOT NULL drop table #sourceG
		IF OBJECT_ID(N'tempdb..#destG') IS NOT NULL drop table #destG

		select * into #sourceG from MarketGroupPacks_History where [version] = @i and marketdefid = @marketDefId
		select * into #destG from MarketGroupPacks_History where [version] = @i + 1 and marketdefid = @marketDefId

		IF OBJECT_ID(N'tempdb..#addedG') IS NOT NULL drop table #addedG
		select * into #addedG from(
			select GroupName, MarketAttribute, PFC, PackDescription from #destG
			except
			select GroupName, MarketAttribute, PFC, PackDescription from #sourceG
		)A

		IF OBJECT_ID(N'tempdb..#deletedG') IS NOT NULL drop table #deletedG
		select * into #deletedG from(
			select GroupName, MarketAttribute, PFC, PackDescription from #sourceG
			except
			select GroupName, MarketAttribute, PFC, PackDescription from #destG
		)A

		insert into @GroupReport
		select a.groupname , a.marketattribute, PFC, PackDescription, 'Added', @i+1 as version, firstname + ' ' + lastname as submittedBy, ModifiedDate, @marketDefId
		from #addedG a 
		join marketdefinitions_history mh on mh.version = @i + 1 and mh.marketdefid = @marketDefId
		join dbo.[user] u on u.userid = mh.userid
		union
		select a.groupname , a.marketattribute, PFC, PackDescription, 'Deleted', @i+1 as version, firstname + ' ' + lastname as submittedBy, ModifiedDate, @marketDefId
		from #deletedG a 
		join marketdefinitions_history mh on mh.version = @i + 1 and mh.marketdefid = @marketDefId
		join dbo.[user] u on u.userid = mh.userid
		set @i = @i + 1
	end

	select * from @GroupReport
end