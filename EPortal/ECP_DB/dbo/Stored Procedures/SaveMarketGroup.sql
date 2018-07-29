CREATE PROCEDURE [dbo].[SaveMarketGroup]

   @groupView dbo.typGroupView READONLY, 
   @isEdit int,
   @marketDefId int = 0
AS
BEGIN
	if @isEdit = 1
	begin
		--declare @marketDefId int
		--select  distinct @marketDefId = MarketDefinitionId from @groupView
		delete from MarketGroupMappings where AttributeId in (select distinct AttributeId from @groupView)
		delete from MarketAttributes where MarketDefinitionId = @marketDefId 
		delete from MarketGroups where MarketDefinitionId = @marketDefId
			
	end

	insert into MarketAttributes(AttributeId,Name,OrderNo,MarketDefinitionId)
	select distinct attributeid, attributename name, orderno, marketdefinitionid
	from @groupView Where IsAttribute=1

	insert into MarketGroups(GroupId,Name,MarketDefinitionId,GroupOrderNo)
	select distinct groupid, groupname name, marketdefinitionid, grouporderno
	from @groupView

	insert into MarketGroupMappings(ParentId,GroupId,IsAttribute, AttributeId)
	select parentid,groupid,isattribute,attributeid 
	from @groupView
	
END
