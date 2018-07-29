CREATE TABLE [dbo].[Levels_History] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (MAX) NULL,
    [LevelNumber]      INT            NOT NULL,
    [LevelIDLength]    INT            NOT NULL,
    [LevelColor]       NVARCHAR (MAX) NULL,
    [BackgroundColor]  NVARCHAR (MAX) NULL,
    [LevelId]          INT            NOT NULL,
    [TerritoryId]      INT            NOT NULL,
    [TerritoryVersion] INT            NOT NULL,
    [IRPLevelID]       INT            NULL,
    CONSTRAINT [PK_Levels_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);

