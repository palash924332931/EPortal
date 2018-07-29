CREATE TABLE [dbo].[MarketGroupPacks] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [PFC]                NVARCHAR (50) NULL,
    [GroupId]            INT           NULL,
    [MarketDefinitionId] INT           NULL,
    CONSTRAINT [PK_group]].[MarketGroupPacks] PRIMARY KEY CLUSTERED ([Id] ASC)
);

