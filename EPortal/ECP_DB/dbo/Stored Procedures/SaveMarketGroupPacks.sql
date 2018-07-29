CREATE PROCEDURE [dbo].[SaveMarketGroupPacks] 
	 @marketGroupPack dbo.typMarketGroupPack READONLY,
	 @isEdit int,
	 @marketDefinitionId int = 0
AS
BEGIN
	if @isEdit = 1
	begin
		delete from dbo.MarketGroupPacks where MarketDefinitionId = @marketDefinitionId
	end
	
	insert into dbo.MarketGroupPacks(GroupId, PFC, MarketDefinitionId)
	select distinct GroupId, PFC, MarketDefinitionId
	from @marketGroupPack

END
