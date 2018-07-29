CREATE TABLE [dbo].[PackMarketBases] (
    [PackId]       INT NOT NULL,
    [MarketBaseId] INT NOT NULL,
    CONSTRAINT [FK__PackMarke__Marke__5F7E2DAC] FOREIGN KEY ([MarketBaseId]) REFERENCES [dbo].[MarketBases] ([Id])
);

