CREATE VIEW dbo.vw_MarketBase
AS
SELECT Id AS MarketBaseId, Name, Description, Suffix, DurationTo, DurationFrom, BaseType, LastSaved, GuiId
FROM     dbo.MarketBases
GO