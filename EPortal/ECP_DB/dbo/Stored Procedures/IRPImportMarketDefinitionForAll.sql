Create procedure [dbo].[IRPImportMarketDefinitionForAll]

AS
BEGIN
	SET NOCOUNT ON;

	declare @cid int

	select distinct a.id into #loop from clients a join irp.clientmap b on a.id=b.clientid

	while exists(select * from #loop)
		begin

			select @cid = (select top 1 id from #loop order by id asc)
		
			print(@cid)
				
			exec [IRPImportMarketDefinitionForClient] @cid

			delete #loop where id = @cid
		
		end

	drop table #loop

		
END