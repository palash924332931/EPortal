CREATE TABLE [IRP].[BasesFields] (
    [BaseID]             SMALLINT       NOT NULL,
    [FieldID]            SMALLINT       NOT NULL,
    [FieldName]          NVARCHAR (100) NOT NULL,
    [DisplayName]        NVARCHAR (100) NULL,
    [DisplayNameForeign] NVARCHAR (100) NULL,
    [DataType]           NVARCHAR (20)  NOT NULL,
    [Criteria]           BIT            NULL,
    [GroupBy]            BIT            NULL,
    [SubBase]            TINYINT        NULL,
    [DefGroup]           TINYINT        NULL,
    [Link]               TINYINT        NULL,
    [Displayed]          BIT            NULL,
    [DisplayOrder]       TINYINT        NULL,
    [DescriptionField]   BIT            NULL
);

