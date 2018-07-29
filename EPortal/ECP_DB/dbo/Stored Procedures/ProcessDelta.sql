CREATE PROCEDURE [dbo].[ProcessDelta]

AS
BEGIN
	SET NOCOUNT ON;

	exec BuildQueryForDelta
	exec [dbo].[ProcessAllMarketDefinitionsForDelta]

END

