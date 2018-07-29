CREATE TABLE [dbo].[ClientMarketBases] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [ClientId]     INT NOT NULL,
    [MarketBaseId] INT NOT NULL,
    CONSTRAINT [PK_dbo.ClientMarketBases] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

