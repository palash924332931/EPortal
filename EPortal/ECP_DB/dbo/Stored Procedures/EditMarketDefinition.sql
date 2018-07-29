CREATE PROCEDURE [dbo].[EditMarketDefinition]
	@marketdefinitionid int,
    @TVP TYP_MarketDefinitionPacks READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from marketdefinitionpacks where marketdefinitionid = @marketdefinitionid
		insert into marketdefinitionpacks select * from @TVP 
	commit
