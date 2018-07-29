CREATE TABLE [dbo].[DeliveryTerritory_History] (
    [Id]                  INT IDENTITY (1, 1) NOT NULL,
    [DeliveryTerritoryId] INT NOT NULL,
    [DeliverableId]       INT NULL,
    [DeliverableVersion]  INT NULL,
    [TerritoryId]         INT NULL,
    [TerritoryVersion]    INT NULL,
    CONSTRAINT [PK_DeliveryTerritory_History_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

