CREATE TABLE [copy].[ClientMarketBases] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [ClientId]     INT NOT NULL,
    [MarketBaseId] INT NOT NULL,
    CONSTRAINT [PK_copy.ClientMarketBases] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

