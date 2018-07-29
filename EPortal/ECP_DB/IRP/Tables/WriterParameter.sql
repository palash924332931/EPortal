CREATE TABLE [IRP].[WriterParameter] (
    [WriterParameterID] SMALLINT      NOT NULL,
    [WriterID]          SMALLINT      NOT NULL,
    [Code]              NVARCHAR (20) NOT NULL,
    [Name]              NVARCHAR (20) NOT NULL,
    [Type]              TINYINT       NOT NULL,
    [DimensionType]     TINYINT       NULL,
    [MinCount]          TINYINT       NOT NULL,
    [MaxCount]          TINYINT       NOT NULL,
    [Default]           NVARCHAR (50) NULL
);

