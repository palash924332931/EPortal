CREATE TABLE [dbo].[Dimension_12Dec] (
    [DimensionID]    SMALLINT       NOT NULL,
    [RefDimensionID] SMALLINT       NULL,
    [ClientID]       SMALLINT       NOT NULL,
    [DimensionType]  TINYINT        NOT NULL,
    [DimensionName]  NVARCHAR (100) NOT NULL,
    [Levels]         TINYINT        NOT NULL,
    [BaseID]         SMALLINT       NOT NULL,
    [Valid]          BIT            NOT NULL,
    [VersionFrom]    SMALLINT       NOT NULL,
    [VersionTo]      SMALLINT       NOT NULL
);

