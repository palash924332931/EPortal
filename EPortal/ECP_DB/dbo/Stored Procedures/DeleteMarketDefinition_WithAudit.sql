CREATE Procedure [dbo].[DeleteMarketDefinition_WithAudit]
	@MarketDefID int, @userId as int
AS
BEGIN
	-------AUDIT DELETE INFO------
	insert into DeleteLogTable select 'M', Id, [name],dimensionid, clientid, @userId,getdate() from MarketDefinitions where Id=@MarketDefID
	--select top 10 * from marketdefinitions_history 
	insert into marketdefinitions_history (MarketDefId, [version], name, clientid, dimensionid, modifieddate,userid, lastsaved)
	select Id, -1,name, clientId, dimensionId, getdate(), @userID, getdate() from MarketDefinitions where Id=@MarketDefID

	exec [dbo].[DeleteMarketDefinition] @MarketDefID
END
