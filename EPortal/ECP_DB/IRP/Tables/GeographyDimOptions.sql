CREATE TABLE [IRP].[GeographyDimOptions] (
    [DimensionID] SMALLINT      NOT NULL,
    [Unassigned]  BIT           NOT NULL,
    [UName]       NVARCHAR (40) NULL,
    [UChar]       NVARCHAR (2)  NULL,
    [SRAClient]   SMALLINT      NULL,
    [SRASuffix]   CHAR (1)      NULL,
    [LD]          TINYINT       NULL,
    [AD]          TINYINT       NULL,
    [Options]     VARCHAR (100) NULL,
    [VersionFrom] SMALLINT      NOT NULL,
    [VersionTo]   SMALLINT      NOT NULL
);

