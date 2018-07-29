CREATE TABLE [dbo].[DeliveryThirdParty_History] (
    [Id]                   INT IDENTITY (1, 1) NOT NULL,
    [DeliveryThirdPartyId] INT NOT NULL,
    [DeliverableId]        INT NOT NULL,
    [DeliverableVersion]   INT NULL,
    [ThirdPartyId]         INT NOT NULL,
    CONSTRAINT [PK__DeliveryThirdParty_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

