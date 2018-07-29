CREATE TABLE [dbo].[DeliveryClient] (
    [DeliveryClientId] INT IDENTITY (1, 1) NOT NULL,
    [DeliverableId]    INT NULL,
    [ClientId]         INT NULL,
    CONSTRAINT [PK__Delivery__0BFCC04FBA03552A] PRIMARY KEY CLUSTERED ([DeliveryClientId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__DeliveryC__Clien__4E53A1AA] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Clients] ([Id]),
    CONSTRAINT [FK__DeliveryC__Deliv__4F47C5E3] FOREIGN KEY ([DeliverableId]) REFERENCES [dbo].[Deliverables] ([DeliverableId])
);

