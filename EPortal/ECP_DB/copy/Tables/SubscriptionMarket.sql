CREATE TABLE [copy].[SubscriptionMarket] (
    [SubscriptionMarketId] INT IDENTITY (1, 1) NOT NULL,
    [SubscriptionId]       INT NULL,
    [MarketBaseId]         INT NULL,
    CONSTRAINT [PK__Subscrip__9585FB84031A6821] PRIMARY KEY CLUSTERED ([SubscriptionMarketId] ASC) WITH (FILLFACTOR = 1)
);

