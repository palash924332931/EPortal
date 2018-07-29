
CREATE PROCEDURE [dbo].[UpdateCustomGroupNumberForAllTerritories] 
AS
BEGIN
	SET NOCOUNT ON;

	select * into #loopTable from Territories
	select * from #loopTable

	declare @pTerritoryId int

	while exists(select * from #loopTable)
	begin
		select @pTerritoryId = (select top 1 Id
						   from #loopTable
						   order by Id asc)

		print('TxR id : ')
		print(@pTerritoryId)
		-------CALL SP TO PROCESS EACH MARKET DEFINITION-------
		EXEC [dbo].[IRPImportTerritoryCustomGroupNumber]  @pTerritoryId

		delete #loopTable
		where Id = @pTerritoryId
	end

	drop table #loopTable
END

--[dbo].[UpdateCustomGroupNumberForAllTerritories] 






