CREATE procedure [dbo].[GenerateTerritoryStructureReportForAll]

AS
BEGIN
	SET NOCOUNT ON;

	declare @territoryId int
	
	IF OBJECT_ID('TerritoryList')IS NOT NULL DROP TABLE TerritoryList
	CREATE TABLE [dbo].[TerritoryList](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](255) NULL,
	[ClientName] [varchar](255) NULL
	) ON [PRIMARY]
	
	select distinct id into #terr from territories where client_id not in (select id from clients where name='Demonstration')

	while exists(select * from #terr)
	begin
		select @territoryId = (select top 1 id from #terr order by id asc)
		print('territoryid:')
		print(@territoryId)
		begin

		exec [GenerateTerritoryStructureReport] @territoryId

		end

		delete #terr where id = @territoryId

	end

	drop table #terr

	select * from TerritoryList order by clientname
	
END