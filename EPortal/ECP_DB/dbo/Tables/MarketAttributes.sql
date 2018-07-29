CREATE TABLE [dbo].[MarketAttributes] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [AttributeId]        INT           NULL,
    [Name]               NVARCHAR (50) NULL,
    [OrderNo]            INT           NULL,
    [MarketDefinitionId] INT           NULL,
    CONSTRAINT [PK_MarketAttributes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

