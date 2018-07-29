CREATE TABLE [dbo].[IRPImportLog] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]     INT           NULL,
    [DimType]      CHAR (1)      NULL,
    [DimensionId]  INT           NULL,
    [Status]       NVARCHAR (50) NULL,
    [TimeOfImport] DATETIME      NULL,
    [UserName]     VARCHAR (300) NULL,
	[Key]		   NVARCHAR (100) NULL,
    CONSTRAINT [PK_IRPImportLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

