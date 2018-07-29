CREATE TABLE [IRP].[Bases] (
    [BaseID]          SMALLINT       NOT NULL,
    [DimensionTypeID] TINYINT        NOT NULL,
    [BaseName]        NVARCHAR (100) NOT NULL,
    [BaseTable]       NVARCHAR (100) NOT NULL,
    [LinkField]       NVARCHAR (100) NULL,
    [PopulationSP]    NVARCHAR (100) NOT NULL,
    [SubBaseTable]    NVARCHAR (100) NOT NULL,
    [JoinField]       NVARCHAR (100) NOT NULL
);

