CREATE TABLE [IRP].[WriterParameterValue] (
    [ValueID]           SMALLINT       NOT NULL,
    [WriterParameterID] SMALLINT       NOT NULL,
    [Value]             VARCHAR (50)   NOT NULL,
    [Description]       NVARCHAR (100) NOT NULL,
    [Default]           BIT            NOT NULL
);

