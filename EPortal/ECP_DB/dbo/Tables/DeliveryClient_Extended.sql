CREATE TABLE [dbo].[DeliveryClient_Extended] (
    [Id]               INT IDENTITY (1, 1) NOT NULL,
    [DeliveryClientId] INT NOT NULL,
    [Client_No]        INT NULL,
    CONSTRAINT [PK_dbo.DeliveryClient_Extended] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

