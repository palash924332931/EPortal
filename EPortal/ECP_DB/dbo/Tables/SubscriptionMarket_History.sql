CREATE TABLE [dbo].[SubscriptionMarket_History] (
    [Id]                   INT IDENTITY (1, 1) NOT NULL,
    [SubscriptionMarketId] INT NOT NULL,
    [SubscriptionId]       INT NULL,
    [SubscriptionVersion]  INT NULL,
    [MarketBaseId]         INT NULL,
    [MarketBaseVersion]    INT NULL,
    CONSTRAINT [PK__SubscriptionMarket_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

