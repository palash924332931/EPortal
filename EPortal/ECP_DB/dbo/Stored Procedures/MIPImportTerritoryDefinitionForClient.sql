
create PROCEDURE [dbo].[MIPImportTerritoryDefinitionForClient] 
	@pClientName nvarchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	declare @teamCode nvarchar(20)
	declare @count int
	declare @territoryId int
	declare @clientId int
	declare @irpClientNo int
	declare @subCount int
	declare @subscriptionId int
	declare @deliverableId int

	select @clientId = id from clients where name = @pClientName
	select @irpClientNo = IRPClientNo from irp.clientmap where clientId = @clientId

	-- CREATE DUMMY SUBSCRIPTION/DELIVERABLE IF NOT EXISTS
	select @subCount = count(*) from Subscription where clientid = @clientId and name like 'MIP-%'
	if (@subCount = 0)
	begin
		insert into subscription(name, clientid, startdate, enddate, serviceterritoryid, active, lastmodified, modifiedby, countryid, serviceid, datatypeid, sourceid)
		values ('MIP-DUMMY-Subscription', @clientId, CAST('2018-01-01 00:00:00.000' as datetime), CAST('2019-03-03 12:30:22.820' as datetime),1,1,CAST('2018-02-12 13:22:29.900' as datetime), 1,1,2,1,2)

		select @subscriptionId = subscriptionid from subscription where clientid = @clientId and name like 'MIP-%'

		insert into deliverables(subscriptionid, reportwriterid,frequencytypeid,restrictionid,periodid,frequencyid,startdate,enddate,probe,packexception,census,onekey,lastmodified,modifiedby,deliverytypeid)
		values(@subscriptionId, 43,1,1,5,30,CAST('2018-01-01 00:00:00.000' as datetime), CAST('2019-03-03 12:30:22.820' as datetime),0,0,0,0,CAST('2018-02-12 13:22:29.900' as datetime),1,2)
	end

	select @subscriptionId = subscriptionid from subscription where clientid = @clientId and name like 'MIP-%'
	select @deliverableId = deliverableid from deliverables where subscriptionid = @subscriptionid 

	SELECT distinct team_code into #loopTeamCodes from vw_Everest_TXR_FeedOUT where client_name = @pClientName 
		and txr_exclude_flag = 'N' AND (client_defined = 'Y' OR ims_defined = 'Y')

	while exists(select * from #loopTeamCodes)
	begin
		select @teamCode = (select top 1 team_code from #loopTeamCodes order by team_code asc)

		print('team_code: ')
		print(@teamCode)

		select @count = count(id) from territories where team_code = @teamCode
		if (@count > 0)
		begin
			select @territoryId = id from territories where team_code = @teamCode
			exec [dbo].[MIPDeleteTerritory] @territoryId
		end

		exec [dbo].[MIPImportTerritoryDefinition] @teamCode, @clientId, @irpClientNo, @deliverableId

		delete #loopTeamCodes where team_code = @teamCode
	end

	
	select client_id, Id, row_number() over (partition by client_id order by Id) as rownumber into #t
	from territories where client_id = @clientId
	order by client_id

	update a set a.AD = b.rownumber, a.LD = b.rownumber
	from territories a join #t b on a.id = b.id and a.client_id = b.client_id

END

--use mirror
--select * from everest_sit.dbo.subscription where clientid in (49,56,82,145,227,254)
--select * from everest_sit.dbo.deliverables where subscriptionid = 4971
--select * from deliveryterritory
--select * from clients where name in ('Ferring', 'Seqirus', 'BMS', 'Servier', 'Nutricia', 'Celgene')
--select distinct team_code from vw_Everest_TXR_FeedOUT where client_name = 'Servier' and txr_exclude_flag = 'N' AND (client_defined = 'Y' OR ims_defined = 'Y')
--select * from territories where team_code in (21,23,11,13,24,12)

--exec [dbo].[MIPImportTerritoryDefinitionForClient] 'Servier'

--select id from clients where name = 'Servier'
--select IRPClientNo from irp.clientmap where clientId = 145 --432
--select subscriptionid from subscription where clientid = 145 and name like 'MIP-%'--60
--select deliverableid from deliverables where subscriptionid = 60

----insert into deliverables(subscriptionid, reportwriterid,frequencytypeid,restrictionid,periodid,frequencyid,startdate,enddate,probe,packexception,census,onekey,lastmodified,modifiedby,deliverytypeid)
----values(60, 43,1,1,5,30,CAST('2018-01-01 00:00:00.000' as datetime), CAST('2019-03-03 12:30:22.820' as datetime),0,0,0,0,CAST('2018-02-12 13:22:29.900' as datetime),1,2)
	
--select * from deliverables where subscriptionid = 60 --44

--select * from frequencytype
--select * from territories where team_code = 11

--exec [dbo].[MIPImportTerritoryDefinition] 11, 145, 432, 44

--select * from levels where territoryid = 111240