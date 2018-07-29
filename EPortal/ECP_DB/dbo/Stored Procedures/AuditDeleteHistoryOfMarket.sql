
create procedure AuditDeleteHistoryOfMarket
	@marketDefId int
as
begin
	set nocount on
	delete from MarketDefinitionPacksAuditReport where marketdefinitionid = @marketDefId 
	delete from additionalfilter_history where marketdefbasemap_historyid in (select id from marketdefbasemap_history where marketdefid = @marketDefId )
	delete from marketdefbasemap_history where marketdefid = @marketDefId 
	delete from marketdefinitions_history where marketdefid = @marketDefId 

end