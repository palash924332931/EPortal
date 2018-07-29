CREATE TABLE [dbo].[Levels] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (200) NULL,
    [LevelNumber]     INT            NOT NULL,
    [LevelIDLength]   INT            NOT NULL,
    [LevelColor]      NVARCHAR (20)  NULL,
    [BackgroundColor] NVARCHAR (20)  NULL,
    [TerritoryId]     INT            NOT NULL,
    [IRPLevelID]      INT            NULL,
    CONSTRAINT [PK_dbo.Levels] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.Levels_dbo.Territories_TerritoryId] FOREIGN KEY ([TerritoryId]) REFERENCES [dbo].[Territories] ([Id])
);

