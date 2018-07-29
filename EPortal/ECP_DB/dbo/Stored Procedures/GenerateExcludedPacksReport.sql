
CREATE PROCEDURE [dbo].[GenerateExcludedPacksReport] 
AS
BEGIN
	SET NOCOUNT ON;

	exec [dbo].[BuildQueryForExclusion]

	declare @query nvarchar(max)
	truncate table ExcludedPacksReport

	select * into #loopTable5 from PackExclusionQuery
		select * from #loopTable5

		declare @pMarketBaseMapId int

		while exists(select * from #loopTable5)
		begin
			select @pMarketBaseMapId = (select top 1 MarketDefBaseMapId
							   from #loopTable5
							   order by MarketDefBaseMapId asc)

			print(@pMarketBaseMapId)
			select @query = query from packexclusionquery where MarketDefBaseMapId = @pMarketBaseMapId
			exec('insert into ExcludedPacksReport ' + @query)
			delete #loopTable5 where MarketDefBaseMapId = @pMarketBaseMapId
		end

		drop table #loopTable5

END
