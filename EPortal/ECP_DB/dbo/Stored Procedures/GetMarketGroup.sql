create procedure [dbo].[GetMarketGroup]
	@pMarketDefinitionId int
as
begin
	select * from [dbo].[vwGroupView] where marketdefinitionid = @pMarketDefinitionId
end