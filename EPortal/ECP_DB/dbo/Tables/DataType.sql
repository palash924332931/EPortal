CREATE TABLE [dbo].[DataType] (
    [DataTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (80) NULL,
	[IsChannel] bit NOT NULL DEFAULT(0),
    CONSTRAINT [PK__DataType__4382081F57CB4A5F] PRIMARY KEY CLUSTERED ([DataTypeId] ASC) WITH (FILLFACTOR = 1)
);

