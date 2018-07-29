CREATE TABLE [IRP].[ReportParameter] (
    [ReportParameterID] INT            NOT NULL,
    [ReportID]          SMALLINT       NOT NULL,
    [WriterParameterID] SMALLINT       NOT NULL,
    [Code]              NVARCHAR (40)  NOT NULL,
    [Name]              NVARCHAR (40)  NOT NULL,
    [Type]              TINYINT        NOT NULL,
    [DimensionType]     TINYINT        NULL,
    [PCount]            TINYINT        NOT NULL,
    [Value]             NVARCHAR (100) NULL,
    [VersionFrom]       SMALLINT       NOT NULL,
    [VersionTo]         SMALLINT       NOT NULL
);

