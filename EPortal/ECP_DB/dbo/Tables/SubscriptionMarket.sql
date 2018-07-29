CREATE TABLE [dbo].[SubscriptionMarket] (
    [SubscriptionMarketId] INT IDENTITY (1, 1) NOT NULL,
    [SubscriptionId]       INT NULL,
    [MarketBaseId]         INT NULL,
    CONSTRAINT [PK__Subscrip__9585FB84031A6821] PRIMARY KEY CLUSTERED ([SubscriptionMarketId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__Subscript__Marke__6BE40491] FOREIGN KEY ([MarketBaseId]) REFERENCES [dbo].[MarketBases] ([Id]),
    CONSTRAINT [FK__Subscript__Subsc__6CD828CA] FOREIGN KEY ([SubscriptionId]) REFERENCES [dbo].[Subscription] ([SubscriptionId])
);

