CREATE TABLE [dbo].[ReportFieldList] (
    [FieldID]          INT           NOT NULL,
    [FieldName]        VARCHAR (100) NOT NULL,
    [FieldDescription] VARCHAR (200) NULL,
    [TableName]        VARCHAR (100) NOT NULL,
    [FieldType]        VARCHAR (30)  NULL,
    CONSTRAINT [PK_ReportFieldList] PRIMARY KEY CLUSTERED ([FieldID] ASC)
);

