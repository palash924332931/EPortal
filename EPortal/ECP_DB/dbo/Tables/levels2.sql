CREATE TABLE [dbo].[levels2] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (MAX) NULL,
    [LevelNumber]     INT            NOT NULL,
    [LevelIDLength]   INT            NOT NULL,
    [LevelColor]      NVARCHAR (MAX) NULL,
    [BackgroundColor] NVARCHAR (MAX) NULL,
    [TerritoryId]     INT            NOT NULL
);

