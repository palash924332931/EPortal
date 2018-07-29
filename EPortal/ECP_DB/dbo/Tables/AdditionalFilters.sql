CREATE TABLE [dbo].[AdditionalFilters] (
    [Id]                        INT            IDENTITY (1, 1) NOT NULL,
    [Name]                      NVARCHAR (100) NULL,
    [Criteria]                  NVARCHAR (80)  NULL,
    [Values]                    NVARCHAR (200) NULL,
    [IsEnabled]                 BIT            NOT NULL,
    [MarketDefinitionBaseMapId] INT            NOT NULL,
    CONSTRAINT [PK_dbo.AdditionalFilters] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.AdditionalFilters_dbo.MarketDefinitionBaseMaps_MarketDefinitionBaseMapId] FOREIGN KEY ([MarketDefinitionBaseMapId]) REFERENCES [dbo].[MarketDefinitionBaseMaps] ([Id])
);

