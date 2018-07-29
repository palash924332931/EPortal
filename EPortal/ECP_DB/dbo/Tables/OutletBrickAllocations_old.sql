CREATE TABLE [dbo].[OutletBrickAllocations_old] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [NodeCode]               NVARCHAR (MAX) NULL,
    [NodeName]               NVARCHAR (MAX) NULL,
    [Address]                NVARCHAR (MAX) NULL,
    [BrickOutletCode]        NVARCHAR (MAX) NULL,
    [BrickOutletName]        NVARCHAR (MAX) NULL,
    [LevelName]              NVARCHAR (MAX) NULL,
    [CustomGroupNumberSpace] NVARCHAR (MAX) NULL,
    [Type]                   NVARCHAR (MAX) NULL,
    [TerritoryId]            INT            NOT NULL,
    CONSTRAINT [PK_dbo.OutletBrickAllocations] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.OutletBrickAllocations_dbo.Territories_TerritoryId] FOREIGN KEY ([TerritoryId]) REFERENCES [dbo].[Territories] ([Id])
);

