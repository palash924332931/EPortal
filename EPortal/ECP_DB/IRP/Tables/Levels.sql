CREATE TABLE [IRP].[Levels] (
    [LevelID]     INT            NOT NULL,
    [DimensionID] SMALLINT       NULL,
    [RefLevelID]  INT            NULL,
    [LevelNo]     TINYINT        NOT NULL,
    [RefLevelNo]  TINYINT        NOT NULL,
    [LevelName]   NVARCHAR (100) NOT NULL,
    [LevelType]   TINYINT        NOT NULL,
    [MaxSiblings] BIGINT         NOT NULL,
    [Visible]     BIT            NOT NULL,
    [Options]     NVARCHAR (40)  NULL,
    [VersionFrom] SMALLINT       NOT NULL,
    [VersionTo]   SMALLINT       NOT NULL
);

