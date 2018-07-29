CREATE TABLE [dbo].[DeliveryMarket_History] (
    [Id]                 INT IDENTITY (1, 1) NOT NULL,
    [DeliveryMarketId]   INT NOT NULL,
    [DeliverableId]      INT NULL,
    [DeliverableVersion] INT NULL,
    [MarketDefId]        INT NULL,
    [MarketDefVersion]   INT NULL,
    CONSTRAINT [PK_DeliveryMarket_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

