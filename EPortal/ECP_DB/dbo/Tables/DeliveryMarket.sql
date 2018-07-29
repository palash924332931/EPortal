CREATE TABLE [dbo].[DeliveryMarket] (
    [DeliveryMarketId] INT IDENTITY (1, 1) NOT NULL,
    [DeliverableId]    INT NULL,
    [MarketDefId]      INT NULL,
    CONSTRAINT [PK__Delivery__C0E96CC9BD923B05] PRIMARY KEY CLUSTERED ([DeliveryMarketId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__DeliveryM__Deliv__503BEA1C] FOREIGN KEY ([DeliverableId]) REFERENCES [dbo].[Deliverables] ([DeliverableId]),
    CONSTRAINT [FK__DeliveryM__Marke__51300E55] FOREIGN KEY ([MarketDefId]) REFERENCES [dbo].[MarketDefinitions] ([Id])
);

