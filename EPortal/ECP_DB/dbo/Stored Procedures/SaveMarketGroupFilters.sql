
CREATE PROCEDURE [dbo].[SaveMarketGroupFilters] 
	@marketGroupFilter [dbo].[typMarketGroupFilter] READONLY,
	@isEdit int,
	@marketDefinitionId int = 0
AS
BEGIN
	if @isEdit = 1
	begin
		delete from dbo.MarketGroupFilters where MarketDefinitionId = @marketDefinitionId
	end
	
	insert into dbo.MarketGroupFilters(Name, Criteria, [Values], IsEnabled, GroupId,IsAttribute, AttributeId, MarketDefinitionId)
	select distinct Name, Criteria, [Values], IsEnabled, GroupId,IsAttribute, AttributeId, MarketDefinitionId
	from @marketGroupFilter

END
