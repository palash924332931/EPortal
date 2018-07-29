CREATE PROCEDURE [dbo].[AuditMarketDefPacksReport]
	@versionFrom int,
	@versionTo int,
	@marketDefId int
as
begin

	SET NOCOUNT ON
	
	select PFC, Pack as PackDescription, [Action], MarketBase, Groups, Factor, [Version], [User] as ActionBy, time_stamp as [DateTime] from MarketDefinitionPacksAuditReport
	where marketdefinitionid=@marketDefId and [version]>@versionFrom and [version]<=@versionTo

end

--exec [dbo].[AuditMarketDefPacksReport] 1,6,1361