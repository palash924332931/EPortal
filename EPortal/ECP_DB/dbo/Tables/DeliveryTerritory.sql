CREATE TABLE [dbo].[DeliveryTerritory] (
    [DeliveryTerritoryId] INT IDENTITY (1, 1) NOT NULL,
    [DeliverableId]       INT NULL,
    [TerritoryId]         INT NULL,
    CONSTRAINT [PK__Delivery__A8CAEA30550E46D6] PRIMARY KEY CLUSTERED ([DeliveryTerritoryId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__DeliveryT__Deliv__5224328E] FOREIGN KEY ([DeliverableId]) REFERENCES [dbo].[Deliverables] ([DeliverableId]),
    CONSTRAINT [FK__DeliveryT__Terri__45BE5BA9] FOREIGN KEY ([TerritoryId]) REFERENCES [dbo].[Territories] ([Id])
);

