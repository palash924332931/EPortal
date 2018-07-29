CREATE VIEW dbo.vw_Market
AS
SELECT Id, Name, Description, ClientId, GuiId, DimensionId, LastSaved
FROM     dbo.MarketDefinitions
GO