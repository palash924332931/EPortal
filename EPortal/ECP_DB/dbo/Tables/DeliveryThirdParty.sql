CREATE TABLE [dbo].[DeliveryThirdParty] (
    [DeliveryThirdPartyId] INT IDENTITY (1, 1) NOT NULL,
    [DeliverableId]        INT NOT NULL,
    [ThirdPartyId]         INT NOT NULL,
    CONSTRAINT [PK__Delivery__0AB5FD1223F0EA5A] PRIMARY KEY CLUSTERED ([DeliveryThirdPartyId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__DeliveryT__Deliv__540C7B00] FOREIGN KEY ([DeliverableId]) REFERENCES [dbo].[Deliverables] ([DeliverableId]),
    CONSTRAINT [FK__DeliveryT__Third__55009F39] FOREIGN KEY ([ThirdPartyId]) REFERENCES [dbo].[ThirdParty] ([ThirdPartyId])
);

