
CREATE PROCEDURE [dbo].[AuditMarketDefSubmitStatus]
	@clientId int
as
begin

	declare @reportSubmit table(marketdefid int, marketdefinitionname varchar(50), isSubmitted int)
	declare @marketdefid int
	declare @lastSaved datetime

	select * into #loopSubmit from marketdefinitions where clientid = @clientId 
	while exists(select * from #loopSubmit) 
	begin
		select @marketdefid = (select top 1 id from #loopSubmit order by id asc)
		select @lastSaved  = (select top 1 lastSaved from marketdefinitions_history where marketdefid = @marketdefid order by lastsaved desc)
		if @lastSaved = '' set @lastSaved = '1971-01-01'
		else if @lastSaved is null set @lastSaved = '1971-01-01'
		
		print(@lastSaved)
		
		insert into @reportSubmit
		select ID, name, 
		case 
			when lastSaved is null then 0
			when lastSaved > @lastSaved
				then 0 
			else 1 end as isSubmitted
		from marketdefinitions  
		where id = @marketdefid 

		delete #loopSubmit where id = @marketdefid
	end

	drop table #loopSubmit
	select * from @reportSubmit
end