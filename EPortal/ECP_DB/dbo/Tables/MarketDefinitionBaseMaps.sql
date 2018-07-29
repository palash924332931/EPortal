CREATE TABLE [dbo].[MarketDefinitionBaseMaps] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [Name]               NVARCHAR (200) NULL,
    [MarketBaseId]       INT            NOT NULL,
    [DataRefreshType]    NVARCHAR (20)  NULL,
    [MarketDefinitionId] INT            NOT NULL,
    CONSTRAINT [PK_dbo.MarketDefinitionBaseMaps] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketBases_MarketBaseId] FOREIGN KEY ([MarketBaseId]) REFERENCES [dbo].[MarketBases] ([Id]),
    CONSTRAINT [FK_dbo.MarketDefinitionBaseMaps_dbo.MarketDefinitions_MarketDefinitionId] FOREIGN KEY ([MarketDefinitionId]) REFERENCES [dbo].[MarketDefinitions] ([Id])
);

