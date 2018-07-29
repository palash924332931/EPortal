CREATE TABLE [dbo].[DeliveryClient_History] (
    [Id]                 INT IDENTITY (1, 1) NOT NULL,
    [DeliveryClientId]   INT NOT NULL,
    [DeliverableId]      INT NULL,
    [DeliverableVersion] INT NULL,
    [ClientId]           INT NULL,
    CONSTRAINT [PK_DeliveryClient_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

