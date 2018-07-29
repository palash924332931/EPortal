CREATE TABLE [dbo].[DeliveryType] (
    [DeliveryTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (80) NULL,
    CONSTRAINT [PK__Delivery__6B117964B1284DF2] PRIMARY KEY CLUSTERED ([DeliveryTypeId] ASC) WITH (FILLFACTOR = 1)
);

