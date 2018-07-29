
CREATE Procedure [dbo].[IRPDeleteTerritory_WithAudit]
	@TerritoryId int, @userId as int
AS
BEGIN
	-------AUDIT DELETE INFO------
	insert into DeleteLogTable select 'T', Id, [name],dimensionid, client_id, @userId,getdate() from Territories where Id=@TerritoryId
	--select top 10 * from Territories_history 
	insert into Territories_history (TerritoryId, [version], name, client_id, dimensionid, modifieddate,userid, lastsaved)
	select Id, -1, name, client_Id, dimensionId, getdate(), @userID, getdate()  from Territories where Id=@TerritoryId

	exec [dbo].[IRPDeleteTerritory] @TerritoryId
END